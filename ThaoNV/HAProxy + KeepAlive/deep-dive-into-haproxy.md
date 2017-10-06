# Tìm hiểu sâu về HAProxy

## Mục lục

[1. Giới thiệu chung về load balancing và load balancer](#1)

[2. Giới thiệu về HAProxy](#2)

  - [2.1 HAProxy là gì](#2.1)
  - [2.2 Cách thức hoạt động](#2.2)
  - [2.3 Các tính năng cơ bản](#2.3)

[3. Chi tiết các tùy chọn cấu hình quan trọng trong HAProxy](#3)

  - [3.1 Định dạng file cấu hình](#3.1)
  - [3.2 Biến môi trường](#3.2)
  - [3.3 Time format](#3.3)
  - [3.4 Ví dụ](#3.4)
  - [3.5 Global parameters](#3.5)
  - [3.6 Proxies](#3.6)
  - [3.7 Proxy keywords matrix](#3.7)
  - [3.8 main keywords reference](#3.8)

[4. Hướng dẫn quản lí HAProxy](#4)

  - [4.1 Tổng quan về kiến trúc của HAProxy](#4.1)
  - [4.2 Hướng dẫn cấu hình để HAProxy đẩy log ra syslog](#4.2)

----------------

<a name="1"></a>
## 1. Giới thiệu chung về load balancing và load balancer

Load Balancing bao gồm việc kết hợp lại nhiều thành phần để có được tổng hợp khả năng xử lí trên các thiết bị riêng lẻ mà không cần có sự can thiệp nào từ phía người dùng và có khả năng mở rộng. Như vậy sẽ có nhiều quá trình xử lí diễn ra trong cùng thời gian mà nó xử lí một tiến trình riêng lẻ.

Lợi ích chính của load balancing đó là sử dụng hết tất cả tài nguyên để đem lại hiệu suất tốt nhất. Ví dụ ngoài đời thường, một tuyến đường có nhiều làn sẽ cho phép nhiều xe đi qua hơn trong cùng một thời điểm mà không cần phải tăng tốc độ của các xe chạy qua.

Ví dụ của load balancing:

- Quá trình schedule của hệ thống với nhiều vi xử lí
- EtherChannel, Bonding
- ......

Thành phần thực hiện các load balancing operations được gọi là load balancer. Một trong những use case áp dụng load balancing tốt nhất đó là môi trường web.

Load balancer có thể hoạt động ở:
- Link level: quyết định card mạng để gửi gói tin
- Network level: quyết định đường mạng để gửi gói tin đi
- server level : quyết định server nào sẽ xử lí request

Có hai công nghệ thực hiện điều này và mỗi thứ lại cần những điều kiện nhất định.

Loại thứ nhất hoạt động ở packet level. Mối quan hệ giữa input và output packet là 1-1. Nó có thể hoạt động stateful (layer 4) và phù hợp nhất với network-level load balancing.

Loại thứ 2 hoạt động trên các nội dung của phiên làm việc. Nội dung có thể được thay đổi và output stream được phân lại thành các packets khác nhau. Loại này thường hoạt động bằng proxies và được gọi là layer 7 load balancer. Công nghệ này rất phù hợp với server load balancing.

<a name="2"></a>
## 2. Giới thiệu về HAProxy

<a name="2.1"></a>
### 2.1 HAProxy là gì

HAProxy là:

- TCP Proxy: có có thể chấp nhận các kết nối tcp từ listening socket, kết nối nó tới server và gán các sockets này lại với nhau ch phép traffic di chuyển theo cả hai chiều
- HTTP reverse-proxy: Hay còn gọi là gateway, tự bản thân nó có thể là server, nhận các http requests từ kết nối được thông qua bởi listening TCP socket và chuyển các requests này tới các server bằng nhiều kết nối khác nhau.
- SSL terminator / initiator / offloader
- TCP normalizer
- HTTP normalizer
- HTTP fixing tool
- content-based switch: dựa vào thành phần của request để xác định server nhận
- server load balancer
- traffic regulator: thực hiện một số rule để limit traffic
- protection against DDoS: nó có thể lưu giữ danh số liệu về địa chỉ ip, url,... và thực hiện các hành động (làm chậm, block,...)

<a name="2.2"></a>
### 2.2 Cách thức hoạt động

HAProxy là single-threaded, event-driven, non-blocking engine kết hợp các I/O layer với priority-based scheduler. Vì nó được thiết kế với mục tiêu vận chuyển dữ liệu, kiến trúc của nó được tối ưu hóa để chuyển dữ liệu nhanh nhất có thể. Nó có những layer model với những cơ chế riêng để đảm bảo dữ liệu không đi tới những level cao hơn nếu không cần thiết. Phần lớn những quá trình xử lí diễn ra ở kernel và HAProxy làm mọi thứ tốt nhất để giúp kernel làm việc nhanh nhất có thể.

HAProxy (product) chỉ yêu cầu haproxy (programs) được thực thi và file cấu hình để chạy. File cấu hình sẽ được đọc trước khi nó khởi động, sau đó HAProxy sẽ cố gắng gộp tất cả listening sockets và từ chối khởi động nếu có cái gì đó lỗi. Vì thế sẽ không có bất cứ một lỗi run-time nào, một khi đã chạy, nó sẽ chỉ dừng lại nếu có lệnh.

Một khi HAProxy được bật lên, nó thực hiện 3 điều:

- Xử lí các incoming connections
- Định kì check các trạng thái của server (health checks)
- Trao đổi thông tin với các haproxy nodes khác

Quá trình xử lí các incoming connections là phần phức tạp nhất và nó phụ thuộc vào rất nhiều cấu hình. Có thể tóm gọn nó lại trong 9 bước:

- Cho phép các connections từ listening sockets thuộc về các cấu hình trong phần frontend
- Áp dụng các frontend-specific processing rules đối với những connections này
- Chuyển các incoming connections tới "backend", nơi chứa các server và cả những kế hoạch load balancing cho nó
- Áp dụng những backend-specific processing rules cho các connections
- Dựa vào kế hoạch load balancing mà quyết định server sẽ nhận kết nối
- Áp dụng backend-specific processing rules cho dữ liệu được trả về từ server
- Áp dụng frontend-specific processing rules cho dữ liệu được trả về từ server
- Tạo log để ghi lại những gì đã xảy ra
- Đối với http, lặp lại bước 2 để đợi một request mới, nếu không có, tiến hành đóng kết nối.

<a name="2.3"></a>
### 2.3 Các tính năng cơ bản

- Proxying
- SSL
- Monitoring
- HA
- Load balancing
- Sampling and converting information
- Maps
- ACLs and conditions
- Content switching
- HTTP rewriting and redirection
- Server protection
- Logging
- Statistics

<a name="3"></a>
## 3. Chi tiết các tùy chọn cấu hình quan trọng trong HAProxy

<a name="3.1"></a>
### 3.1 Định dạng file cấu hình

Quá trình cấu hình cho HAProxy bao gồm 3 nguồn chính:

- Các câu lệnh từ command-line được ưu tiên trước
- "global" sections, nơi chứa process-wide parameters
- proxies sections, có thể lấy từ "defaults", "listen", "frontend" và "backend"

<a name="3.2"></a>
### 3.2 Biến môi trường

Bến trong HAProxy được bao bọc bởi dấu nháy kép. Nó phải được bắt đầu bằng "$" và nằm bên trong dấu ngoặc nhọn ({}). Nó có thể chứa chữ cái hoặc dấu gạch dưới ( _ ) nhưng không được phép bắt đầu bằng chữ số.

Ví dụ:

``` sh
        bind "fd@${FD_APP1}"

        log "${LOCAL_SYSLOG}:514" local0 notice   # send to local server

        user "$HAPROXY_USER"
```

<a name="3.3"></a>
### 3.3 Time format

Thông thường các dịnh dạng thời gian trong HAProxy thường được biểu diễn theo định dạng milliseconds, tuy nhiên HAProxy cũng hỗ trợ nhiều định dạng khác:

  - us : microseconds. 1 microsecond = 1/1000000 second
  - ms : milliseconds. 1 millisecond = 1/1000 second. (Mặc định)
  - s  : seconds. 1s = 1000ms
  - m  : minutes. 1m = 60s = 60000ms
  - h  : hours.   1h = 60m = 3600s = 3600000ms
  - d  : days.    1d = 24h = 1440m = 86400s = 86400000ms

<a name="3.4"></a>
### 3.4 Ví dụ

``` sh
   # Simple configuration for an HTTP proxy listening on port 80 on all
   # interfaces and forwarding requests to a single backend "servers" with a
   # single server "server1" listening on 127.0.0.1:8000
   global
       daemon
       maxconn 256

   defaults
       mode http
       timeout connect 5000ms
       timeout client 50000ms
       timeout server 50000ms

   frontend http-in
       bind *:80
       default_backend servers

   backend servers
       server server1 127.0.0.1:8000 maxconn 32


   # The same configuration defined with a single listen block. Shorter but
   # less expressive, especially in HTTP mode.
   global
       daemon
       maxconn 256

   defaults
       mode http
       timeout connect 5000ms
       timeout client 50000ms
       timeout server 50000ms

   listen http-in
       bind *:80
       server server1 127.0.0.1:8000 maxconn 32
```

Test cấu hình bằng câu lệnh sau:

`$ sudo haproxy -f configuration.conf -c`

<a name="3.5"></a>
### 3.5 Global parameters

Các parameters trong secions global thường được sử dụng trong suốt quá chình xử lí và một số cũng là dành riêng cho hệ điều hành (process-wide and often OS-specific)

Dưới đây là một số keywords được hỗ trợ trong section này:

``` sh
* Process management and security
   - ca-base
   - chroot
   - crt-base
   - cpu-map
   - daemon
   - description
   - deviceatlas-json-file
   - deviceatlas-log-level
   - deviceatlas-separator
   - deviceatlas-properties-cookie
   - external-check
   - gid
   - group
   - hard-stop-after
   - log
   - log-tag
   - log-send-hostname
   - lua-load
   - nbproc
   - node
   - pidfile
   - presetenv
   - resetenv
   - uid
   - ulimit-n
   - user
   - setenv
   - stats

 * Performance tuning
   - max-spread-checks
   - maxconn
   - maxconnrate
   - maxcomprate
   - maxcompcpuusage
   - maxpipes
   - maxsessrate
   - maxsslconn
   - maxsslrate
   - maxzlibmem
   - noepoll
   - nokqueue
   - nopoll
   - nosplice
   - nogetaddrinfo
   - noreuseport
   - spread-checks
   - server-state-base
   - server-state-file
   - ssl-engine
   - ssl-mode-async
   - tune.buffers.limit
   - tune.buffers.reserve
   - tune.bufsize
   - tune.chksize
   - tune.comp.maxlevel
   - tune.http.cookielen

 * Debugging
   - debug
   - quiet
```

**Process management and security**

- ca-base <dir> : Thư mục mặc định chứa SSL CA certificates and CRLs
- chroot <jail dir> : Thay đổi thư mục mặc định thành <jail dir> và thực thi chroot().
- daemon : "Makes the process fork into background". Là mode được khuyên dùng khi vận hành.
- external-check: Cho phép user sử dụng external agent để thực hiện health checks.
- gid <number> : Thay đổi process' group ID thành <number>
- log <address> [len <length>] [format <format>] <facility> [max level [min level]] : Thêm syslog server (tối đa 2)
- log-send-hostname [<string>] : Đặt hostname trong syslog header
- log-tag <string> : Đặt tag trong syslog header
- master-worker [exit-on-failure] : Đặt chế độ master-worker
- pidfile <pidfile> : Viết pids của tất cả các process vào 1 file
- presetenv <name> <value> : Set <value> cho variable <name>
- stats maxconn <connections> : Mặc định thì stats socket cho phép 10 kết nối đồng thời
- uid <number> : Thay đổi process' user ID thành <number>
- description <text> : Thêm mô tả

**Performance tuning**

- max-spread-checks <delay in milliseconds> : Dùng để set thời gian delay giữa lần thực hiện health check cuối cùng và lần check mới.
- maxconn <number>: Set số connections tối đa có thể nhận trong cùng một thời điểm. Tự động chặn những connections mới khi quá giới hạn.
- maxconnrate <number> : Set số connections trên 1 giây.
- maxcompcpuusage <number>: Số CPU tối đa mà HAProxy có thể sử dụng

**Lưu ý:**

Trên đây chỉ là những tùy chọn thông dụng, xem thêm [tại đây](http://www.haproxy.org/download/1.8/doc/configuration.txt)

<a name="3.6"></a>
### 3.6 Proxies

Các cấu hình proxy có thể được đặt trong 4 secions:

- defaults [<name>]
- frontend <name>
- backend  <name>
- listen   <name>

Trong đó:

- "defaults" chứa những parameters mặc định cho tất cả những sections sử dụng phần khai báo của nó
- "frontend" chứa danh sách listening sockets cho phép kết nối từ clients
- "backend" sections chứa danh sách các servers mà proxy sẽ kết nối và forward packets.
- "listen" định nghĩa proxy hoàn chỉnh, là sự kết hợp của frontend và backend. Nó thường chỉ được dùng cho TCP-only traffic

Hiện tại thì có 2 proxy mode được hỗ trợ đó là "tcp" và "http". Nếu sử dụng "tcp" thì HAProxy đơn giản chỉ forward các traffic giữa 2 sides. Nếu sử dụng "http" mode thì nó sẽ phần tích giao thức và có thể tương tác với chúng bằng cách chặn, chuyển hướng, thêm, sửa, xóa nội dung trong request hoặc responses.

<a name="3.7"></a>
### 3.7 Proxy keywords matrix

Dưới đây là một số keywords được hỗ trợ. Những keywords có dấu ( * ) có thể sử dụng ngược lại nếu thêm prefix "no":

``` sh
keyword                              defaults   frontend   listen    backend
------------------------------------+----------+----------+---------+---------
acl                                       -          X         X         X
appsession                                -          -         -         -
backlog                                   X          X         X         -
balance                                   X          -         X         X
bind                                      -          X         X         -
bind-process                              X          X         X         X
capture cookie                            -          X         X         -
capture request header                    -          X         X         -
capture response header                   -          X         X         -
compression                               X          X         X         X
cookie                                    X          -         X         X
declare capture                           -          X         X         -
default-server                            X          -         X         X
default_backend                           X          X         X         -
description                               -          X         X         X
disabled                                  X          X         X         X
dispatch                                  -          -         X         X
email-alert from                          X          X         X         X
email-alert level                         X          X         X         X
-- keyword -------------------------- defaults - frontend - listen -- backend -
errorloc303                               X          X         X         X
force-persist                             -          X         X         X
filter                                    -          X         X         X
fullconn                                  X          -         X         X
grace                                     X          X         X         X
hash-type                                 X          -         X         X
http-check disable-on-404                 X          -         X         X
http-check expect                         -          -         X         X
http-check send-state                     X          -         X         X
http-request                              -          X         X         X
http-response                             -          X         X         X
http-reuse                                X          -         X         X
http-send-name-header                     -          -         X         X
id                                        -          X         X         X
ignore-persist                            -          X         X         X
load-server-state-from-file               X          -         X         X
log                                  (*)  X          X         X         X
log-format                                X          X         X         -
log-format-sd                             X          X         X         -
log-tag                                   X          X         X         X
max-keep-alive-queue                      X          -         X         X
maxconn                                   X          X         X         -
mode                                      X          X         X         X
monitor fail                              -          X         X         -
monitor-net                               X          X         X         -
monitor-uri                               X          X         X         -
option abortonclose                  (*)  X          -         X         X
option accept-invalid-http-request   (*)  X          X         X         -
option accept-invalid-http-response  (*)  X          -         X         X
option allbackups                    (*)  X          -         X         X
option checkcache                    (*)  X          -         X         X
option clitcpka                      (*)  X          X         X         -
option contstats                     (*)  X          X         X         -
option dontlog-normal                (*)  X          X         X         -
option dontlognull                   (*)  X          X         X         -
option forceclose                    (*)  X          X         X         X
-- keyword -------------------------- defaults - frontend - listen -- backend -
option forwardfor                         X          X         X         X
option http-buffer-request           (*)  X          X         X         X
option http-ignore-probes            (*)  X          X         X         -
option http-keep-alive               (*)  X          X         X         X
option http-no-delay                 (*)  X          X         X         X
option http-pretend-keepalive        (*)  X          X         X         X
option http-server-close             (*)  X          X         X         X
option http-tunnel                   (*)  X          X         X         X
option http-use-proxy-header         (*)  X          X         X         -
option httpchk                            X          -         X         X
option httpclose                     (*)  X          X         X         X
option httplog                            X          X         X         X
option http_proxy                    (*)  X          X         X         X
option independent-streams           (*)  X          X         X         X
option ldap-check                         X          -         X         X
option external-check                     X          -         X         X
option log-health-checks             (*)  X          -         X         X
option log-separate-errors           (*)  X          X         X         -
option logasap                       (*)  X          X         X         -
option mysql-check                        X          -         X         X
option nolinger                      (*)  X          X         X         X
option originalto                         X          X         X         X
option persist                       (*)  X          -         X         X
option pgsql-check                        X          -         X         X
option prefer-last-server            (*)  X          -         X         X
option redispatch                    (*)  X          -         X         X
option redis-check                        X          -         X         X
option smtpchk                            X          -         X         X
option socket-stats                  (*)  X          X         X         -
-- keyword -------------------------- defaults - frontend - listen -- backend -
option tcp-check                          X          -         X         X
option tcp-smart-accept              (*)  X          X         X         -
option tcp-smart-connect             (*)  X          -         X         X
option tcpka                              X          X         X         X
option tcplog                             X          X         X         X
option transparent                   (*)  X          -         X         X
external-check command                    X          -         X         X
external-check path                       X          -         X         X
persist rdp-cookie                        X          -         X         X
rate-limit sessions                       X          X         X         -
redirect                                  -          X         X         X
-- keyword -------------------------- defaults - frontend - listen -- backend -
reqtarpit                                 -          X         X         X
retries                                   X          -         X         X
rspadd                                    -          X         X         X
rspdel                                    -          X         X         X
rspdeny                                   -          X         X         X
rspidel                                   -          X         X         X
rspideny                                  -          X         X         X
rspirep                                   -          X         X         X
rsprep                                    -          X         X         X
server                                    -          -         X         X
server-state-file-name                    X          -         X         X
server-template                           -          -         X         X
source                                    X          -         X         X
stats admin                               -          X         X         X
stats auth                                X          X         X         X
stats enable                              X          X         X         X
stats hide-version                        X          X         X         X
stats http-request                        -          X         X         X
stats realm                               X          X         X         X
stats refresh                             X          X         X         X
stats scope                               X          X         X         X
stats show-desc                           X          X         X         X
stats show-legends                        X          X         X         X
stats show-node                           X          X         X         X
stats uri                                 X          X         X         X
-- keyword -------------------------- defaults - frontend - listen -- backend -
stick match                               -          -         X         X
stick on                                  -          -         X         X
stick store-request                       -          -         X         X
stick store-response                      -          -         X         X
stick-table                               -          X         X         X
tcp-check connect                         -          -         X         X
tcp-check expect                          -          -         X         X
tcp-check send                            -          -         X         X
tcp-check send-binary                     -          -         X         X
tcp-request connection                    -          X         X         -
tcp-request content                       -          X         X         X
timeout check                             X          -         X         X
timeout client                            X          X         X         -
timeout client-fin                        X          X         X         -
timeout connect                           X          -         X         X
timeout http-keep-alive                   X          X         X         X
timeout http-request                      X          X         X         X
timeout queue                             X          -         X         X
timeout server                            X          -         X         X
timeout tunnel                            X          -         X         X
use_backend                               -          X         X         -
use-server                                -          -         X         X
------------------------------------+----------+----------+---------+---------
 keyword                              defaults   frontend   listen    backend
```

Xem thêm [tại đây](http://www.haproxy.org/download/1.8/doc/configuration.txt)

<a name="3.8"></a>
### 3.8 main keywords reference

- acl <aclname> <criterion> [flags] [operator] <value> ...

Khai báo acl

Ví dụ:

        acl invalid_src  src          0.0.0.0/7 224.0.0.0/3
        acl invalid_src  src_port     0:1023
        acl local_dst    hdr(host) -i localhost

- balance <algorithm> [ <arguments> ]

Khai báo load balancing algorithm được sử dụng trong backend. Có những tùy chọn sau:

    - roundrobin: Các server sẽ được chọn theo lượt, còn tùy thuộc vào weights. Đây là giải thuật mặc định, được cho là "mượt" và công bằng nhất. Tối đa nó có thể xử lí 4095 server cho mỗi backend.

    - leastconn : Server có số lượng connections thấp nhất sẽ được nhận connection mới. Trong khi Round-robin được thực thi nhằm mục đích sử dụng hết các servers thì giải thuật này được khuyến khích sử dụng cho những sessions dài hơi ví dụ như LDAP, SQL, TSE, etc... Nó không thực sực sự phù hợp với những kết nối ngắn hạn như HTTP.

    - first : Server đầu tiên mà còn slots sẽ nhận được connections. Đầu tiên ở đây có nghĩa là nó đã được sắp xếp theo số id từ nhỏ nhất tới lớn nhất, thường sẽ là thứ tự của server. Một khi server đã đật đến giới hạn những connections có thể nhận (maxconn) thì server tiếp theo sẽ được chọn. Nếu muốn sử dụng, bạn sẽ phải thiết lập "maxconn". Nó cũng thường được sử dụng cho các sessions dài hơi.

    - source : Địa chỉ ip sẽ được "băm" và chia tùy thuộc theo weights của các server đang chạy để chọn server nhận request. Nó đảm bảo những ip từ cùng client sẽ tới cùng một server cho mỗi lần request. Thường thì nod=s được sử dụng cho tcp mode và không có cookie.


- bind [<address>]:<port_range> [, ...] [param*] hoặc bind /<path> [, ...] [param*]

Khai báo một hoặc một vài địa chỉ và/hoặc port listening cho frontend

Ví dụ:

listen http_proxy
            bind :80,:443
            bind 10.0.0.1:10080,10.0.0.1:10443
            bind /var/run/ssl-frontend.sock user root mode 600 accept-proxy

            listen http_https_proxy
                        bind :80
                        bind :443 ssl crt /etc/haproxy/site.pem

            listen http_https_proxy_explicit
                bind ipv6@:80
                bind ipv4@public_ssl:443 ssl crt /etc/haproxy/site.pem
                bind unix@ssl-frontend.sock user root mode 600 accept-proxy

            listen external_bind_app1
                bind "fd@${FD_APP1}"

- default_backend <backend>

Khai báo backend được sử dụng khi không có "use_backend" rule nào match

- maxconn <conns>

Số lượng connections tối đa có thể nhận tại một thời điểm

- mode { tcp|http|health }

Mode hoặc protocol cho instance

  - tcp: mode mặc định full-duplex connection sẽ được thiết lập giữa client và server, sẽ không có phân tích layer 7 nào được thực thi. Nó thường được sử dụng cho SSL, SSH, SMTP,...
  - http : Client request sẽ được phân tích trước khi gửi đến server, đây là mode thể hiện hầu hết các giá trị của HAProxy
  - health : Nó sẽ chỉ reply "OK" đối với những connections tới và thực hiện đóng connections khi kết thúc. Nó thường được sử dụng để các thành phần bên ngoài check health.


- server <name> <address>[:[port]] [param*]

Khai báo server trong phần backend

**Lưu ý:**

Trên đây chỉ là những keywords thường được sử dụng, xem thêm [tại đây](http://www.haproxy.org/download/1.8/doc/configuration.txt)

<a name="4"></a>
## 4. Hướng dẫn quản lí HAProxy

<a name="4.1"></a>
### 4.1 Tổng quan về kiến trúc của HAProxy

HAProxy là một single-threaded, event-driven, non-blocking daemon. Có nghĩa rằng nó sử dụng event multiplexing để schedule tất cả các hoạt động của nó. Vậy nên ta chỉ thấy nó hoạt động như một process duy nhất khi sử dụng lệnh "ps aux" để show.

HAProxy được thiết kế tách biệt nó trong chroot jail suốt quá trình startup, nó sẽ không thể access tới bất cứ file-system nào. Vậy nên nó không thể reload lại bằng cách sử dụng file cấu hình khi đang chạy, thay vào đó, một tiến trình mới sẽ bắt đầu với file cấu hình đã update.

HAProxy không ghi log files nhưng nó có thê sử dụng syslog protocol để gửi logs tới remote server.

HAProxy sử dụng đồng hồ bên trong nó để xác định timeouts, thường thì thời gian được lấy từ hệ thống.

HAProxy là tcp proxy chứ không phải router. Nó làm việc với các kết nối đã được thiết lập và kiểm chứng bởi kernel.

<a name="4.2"></a>
### 4.2 Hướng dẫn cấu hình để HAProxy đẩy log ra syslog

Vì HAProxy không cho phép nó access tới file system nên cách duy nhất đó là gửi logs thông qua UDP server (mặc định ở port 514).

Để có thể làm được điều này, ta cần khai báo dòng sau vào cấu hình trong section `global`

``` sh
log /dev/log    local0
log /dev/log    local1 notice
```

Sau đó thêm dòng sau vào "defaults" section.

`log global`

Chính sửa lại file cấu hình của rsyslogd `/etc/rsyslog.conf`

``` sh
$ModLoad imudp
$UDPServerAddress *
$UDPServerRun 514
```

Cuối cùng là restart lại haproxy. Test lại bằng cách chạy câu lệnh sau

`strace -tt -s100 -etrace=sendmsg -p <haproxy's pid>`

**Link tham khảo**

http://www.haproxy.org/download/1.8/doc/
