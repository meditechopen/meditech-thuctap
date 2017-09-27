# Giới thiệu về HAProxy, Load Balancing concept và KeepAlive

## Mục lục

1. Giới thiệu chung

2. Các khái niện trong HAProxy

3. Các kiểu load balancing

4. Các giải thuật load balancing phổ biến

5. So sánh HAProxy và một số giải pháp LB khác

----------

## 1. Giới thiệu chung

HAProxy, viết tắt của High Availability Proxy, là phần mềm mã nguồn mở cân bằng tải TCP/HTTP và giải pháp proxy mã nguồn mở phổ biến, có thể chạy trên Linux, Solaris, và FreeBSD. Nó thường dùng để cải thiện hiệu suất (performance) và sự tin cậy (reliability) của môi trường máy chủ bằng cách phân tán lưu lượng tải (workload) trên nhiều máy chủ (như web, application, database). Nó cũng thường dùng cho môi trường cao cấp gồm: GitHub, Imgur, Instagram, và Twiter.

High Availability hay còn được gọi là HA có nghĩa là “Độ sẵn sàng cao“, những máy chủ, thiết bị loại này luôn luôn sẵn sàng phục vụ, người sử dụng không cảm thấy nó bị trục trặc, hỏng hóc gây gián đoạn. Để đảm bảo được điều đó, tối thiểu có một cặp máy, thiết bị chạy song song, liên tục liên lạc với nhau, cái chính hỏng, cái phụ sẽ lập tức biết và tự động thay thế. Một ví dụ đơn giản nhất là một số máy chủ có hai bộ nguồn, tự động thay thế nóng cho nhau.

Load Balancing hay cân bằng tải là một phương pháp phân phối khối lượng tải trên nhiều máy tính hoặc một cụm máy tính để có thể sử dụng tối ưu các nguồn lực, tối đa hóa thông lượng, giảm thời gian đáp ứng và tránh tình trạng quá tải trên máy chủ.

HAProxy thường được kết hợp với KeepAlive (sẽ giải thích chi tiết ở phần dưới) để tạo thành một giải pháp HA rất hiệu quả với giá thành thấp.

## 2. Các khái niện trong HAProxy

**Proxy**

Proxy là 1 internet server làm nhiệm vụ chuyển tiếp, kiểm soát thông tin giữa client và server, proxy có 1 địa chỉ IP và 1 port cố định. Cách thức hoạt động: tất cả các yêu cầu từ client gửi đến server trước hết phải thông qua proxy, proxy kiếm tra xem yêu cầu nếu được phép sẽ gửi đến server và cũng tương tự cho server.

– Forward proxy: Là khái niệm proxy chúng ta dùng hàng ngày, nó là thiết bị đứng giữa 1 client và tất cả các server mà client đó muốn truy cập vào.

– Reverse proxy: là 1 proxy ngược, nó đứng giữa 1 server và tất cả các client và server mà server đó phục vụ, tương tự 1 nhà ga kiêm 1 trạm kiểm soát, các yêu cầu từ client gửi lên server bắt buộc phải ghé vào reverse proxy, tại đây yêu cầu sẽ được kiếm soát, lọc bỏ, và luân chuyển đến server. Ưu điểm của nó là khả năng quản lý tập trung, giúp chúng ta có thể kiếm soát mọi yêu cầu do client gửi lên server mà chúng ta cần bảo vệ.

**Access Control List (ACL)**

Trong LB, ACLs được dùng để test các điều kiện và thực hiện hành động (chọn lựa server, chặn request,...) dựa theo kết quả test. Việc sử dụng ACLs cho phép chuyển hướng lưu lượng mạng một cách linh động dựa trên nhiều tác nhân giống pattern-matching và 1 số kết nối đến backend, ví dụ:

`acl url_blog path_beg /blog`

ACL này thỏa nếu đường dẫn trong request của người dùng bắt đầu với /blog. Ví dụ http://yourdomain.com/blog/blog-entry-1.

Xem thêm hướng dẫn chi tiết về ACL, [HAProxy Configuration Manual](http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#7).

**Backend**

Backend là tập các máy chủ mà nhận các request được chuyển hướng. Backend được định nghĩa trong phần backend của cấu hình HAProxy. Cơ bản, 1 backend có thể được định nghĩa bởi:

- thuật toán cân bằng tải nào được dùng
- danh sách các máy chủ và cổng (port)

Một backend có thể chứa 1 hay nhiều máy chủ trong nó, thêm nhiều máy chủ vào backend sẽ gia tăng khả năng tải bằng cách phân phối lượng tải trên nhiều máy chủ. Gia tăng độ tin cậy cũng đạt được trong trường hợp này nếu một trong số các máy chủ của backend bị lỗi.

Đây là 1 ví dụ của 2 cấu hình backend, web-backend và blog-backend với 2 máy chủ web cho mỗi backend, lắng nghe trên cổng 80:

``` sh
backend web-backend:
    balance roundrobin
    server web1 web1.yourdomain.com:80 check
    server web2 web2.yourdomain.com:80 check

backend blog-backend:
    balance roundrobin
    mode http
    server blog1 blog1.yourdomain.com:80 check
    server blog2 blog2.yourdomain.com:80 check
```

Dòng balance roundrobin chỉ ra thuật toán cân bằng tải, sẽ nói rõ hơn trong phần các giải thuật cân bằng tải.

Dòng mode http chỉ ra rằng layer 7 proxy sẽ được dùng, sẽ nói rõ hơn trong phần các loại cân bằng tải.

Tùy chọn check ở cuối của mỗi chỉ thị server chỉ ra rằng việc kiểm tra sức khỏe (tình trạng của máy chủ) sẽ được thực hiện trên các máy chủ backend.

**Frontend**

Một frontend định nghĩa cách thức các request sẽ được chuyển hướng đến backend. Frontend được định nghĩa trong phần frontend của cấu hình HAProxy. Định nghĩa gồm các thành phần sau:

- Tập các địa chỉ IP và cổng (port) (vd: 10.1.1.7:80, * :443, …)
- ACLs
- Các quy tắc use_backend, mà định nghĩa backend nào sẽ được dùng phụ thuộc điều kiện ACL có khớp hay không, và/hoặc 1 quy tắt default_backend xử lý các trường hợp còn lại.

Một frontend có thể được cấu hình cho nhiều loại lưu lượng mạng.

**Sticky Sessions**

Một số ứng dụng yêu cầu người dùng giữa kết nối đến cùng máy chủ backend. Việc duy trì lâu dài này đạt được thông qua sticky session, dùng tham số appsession trong backend.

**Health Check**

HAProxy dùng health check để xác định nếu 1 máy chủ trong backend sẵn sàng xử lý request. Điều này tránh việc thủ công loại bỏ 1 máy chủ khỏi backend nếu nó không sẵn sàng. Mặc định health check tạo 1 kết nối TCP đến máy chủ, ví dụ nó kiểm tra nếu 1 máy chủ backend đang lắng nghe trên IP address và port đã được cấu hình.

Nếu một máy chủ không sẵn sàng khi health check, và vì thế không thể xử lý request, nó được tự động vô hiệu hóa trong backend. Ví dụ lưu lượng sẽ không được chuyển hướng đến cho đến khi nó sẵn sàng. Nếu tất cả các máy chủ trong backend lỗi, dịch vụ sẽ không sẵn sàng cho đến khi ít nhất 1 máy chủ trong backend sẵn sàng phục vụ.

Đối với 1 số loại backend nhất định, như máy chủ cơ sở dữ liệu, health check mặc định là không đủ để xác định máy chủ vẫn còn khỏe.

**keepalived**

là 1 phần mềm định tuyến được viết bằng C, cung cấp 1 công cụ đơn giản và mạnh mẽ cho việc cần bằng tải và HA cho hệ thống. Nói đơn giản hơn là keepalived dùng để cung cấp IP Failover cho 1 cluster. Cho phép 2 bộ cân bằng tải cài đặt cùng với nó hoạt động theo cơ chế active/backup.


## 3. Các kiểu load balancing

**Không cân bằng tải**

Một môi trường ứng dụng web đơn giản không hỗ trợ cân bằng tải:

<img src="https://i.imgur.com/tT8zGxe.png">

Trong ví dụ này, người dùng kết nối trực tiếp đến ứng dụng web, tại yourdomain.com và không có cơ chế cân bằng tải. Nếu máy chủ web (duy nhất) bị lỗi, người dùng sẽ không thể truy xuất đến web. Ngoài ra, nếu nhiều người dùng cùng truy xuất đến máy chủ web đồng thời và nó sẽ không thể xử lý kịp lượng tải gây ra chậm hoặc người dùng không thể kết nối đến web.

**Cân bằng tải Layer 4**

Cách đơn giản nhất để cân bằng lưu lượng mạng đến nhiều máy chủ là dùng cân bằng tải layer 4 (transport lalyer). Cân bằng tải theo cách này sẽ chuyển hướng lưu lượng người dùng dựa trên IP range và port (vd: nếu 1 request đến http://yourdomain.com/anything, lưu lượng sẽ được chuyển hướng đến backend mà xử lý tất cả các request cho yourdomain.com trên port 80). Xem thêm [tại đây](https://www.digitalocean.com/community/tutorials/an-introduction-to-networking-terminology-interfaces-and-protocols#protocols)

<img src="https://i.imgur.com/G5gLWug.png">

Người dùng truy xuất load balancer, nó sẽ chuyển hướng request đến các máy chủ của web-backend. Máy chủ backend được chọn sẽ hồi đáp trực tiếp request người dùng. Thường, tất cả các máy chủ trong web-backend phải phục vụ nội dung giống hệt nhau – nếu không, người dùng có thể nhận nội dung không phù hợp. Lưu ý rằng cả 2 máy chủ web kết nối đến cùng máy chủ database.

**Cân bằng tải layer 7**

Một cách phức tạp hơn để cân bằng tải lưu lượng mạng là dùng layer 7 (application layer). Dùng layer 7 cho phép load balancer chuyển hướng request đến các máy chủ backend khác nhau dựa trên nội dung request. Chế độ cân bằng tải này cho phép bạn chạy nhiều máy chủ ứng dụng web dưới cùng domain và port. Thêm thông tin về layer 7, xem phần HTTP của [Introduction Networking](https://www.digitalocean.com/community/tutorials/an-introduction-to-networking-terminology-interfaces-and-protocols#protocols)

<img src="https://i.imgur.com/drdMS6L.png">

Trong ví dụ này, nếu người dùng yêu cầu yourdomain.com/blog, họ sẽ được chuyển hướng đến blog-backend, là tập các máy chủ chạy ứng dụng blog. Các request khác được chuyển hướng đến web-backend, mà có thể chạy các ứng dụng khác. Trong ví dụ này, cả 2 backend dùng cùng máy chủ database.

Ví dụ một phần trong cấu hình frontend:

``` sh
frontend http
  bind *:80
  mode http

  acl url_blog path_beg /blog
  use_backend blog-backend .if url_blog

  default_backend web-backend
```

Cấu hình 1 frontend tên http sẽ xử lý lưu lượng vào trên port 80.

Dòng acl url_blog path_beg /blog match khi 1 request có đường dẫn bắt đầu với /blog.

Dòng use_backend blog-backend if url_blog dùng ACL để proxy lưu lượng đến blog-backend.

Dòng default_backend web-backend chỉ định rằng tất cả các lưu lượng khác sẽ chuyển hướng đến web-backend.

## 4. Các giải thuật cân bằng tải phổ biến

Thuật toán cân bằng tải dùng để xác định máy chủ nào, trong 1 backend, sẽ được chọn khi cân bằng tải. HAProxy cung cấp một số tùy chọn thuật toán. Ngoài việc cân bằng tải dựa trên các thuật toán, các máy chủ có thể được gán tham số weight để tính toán tần số mà máy chủ được chọn, so với các máy chủ khác.

Bởi vì HAProxy cung cấp nhiều thuật toán cân bằng tải, chúng ta sẽ chỉ mô tả 1 vài thuật toán thông dụng trong số chúng. Xem [HAProxy Configuration Manual](http://cbonte.github.io/haproxy-dconv/configuration-1.4.html#4.2-balance) để có danh sách đầy đủ các thuật toán.

**roundrobin**

Round Robin chọn các máy chủ lần lượt. Đây là thuật toán mặc định.

**leastconn**

Chọn máy chủ đang có ít kết nối đến nhất – khuyên dùng cho các kết nối có session kéo dài. Các máy chủ trong cùng backend cũng được xoay vòng theo cách roundrobin.

**source**

Chọn máy chủ dựa trên 1 hash của source IP, ví dụ IP address của người dùng của bạn. Đây là 1 phương pháp nhằm đảm bảo rằng 1 người dùng sẽ kết nối đến cùng 1 máy chủ.

## 5. Mô hình kết hợp với keepalived

Đối với các cài đặt load balancing layer 4/7 phía trên , chúng sử dụng 1 load balancer để điều khiển traffic tới một hoặc nhiều backend server. tuy nhiên nếu load balancer bị lỗi thì dữ liệu sẽ bị ứ đọng dẫn tới downtime (bottleneck - nghẽn cổ chai). keepalived sinh ra để giải quyết vấn đề này.

<img src="https://i.imgur.com/RgC5BdX.gif">

Ở ví dụ trên, ta có nhiều load balancer (1 active và một hoặc nhiều passive). Khi người dùng kết nối đến một server thông qua ip public của active load balancer, nếu load balancer ấy fails, phương thức failover sẽ detect nó và tự động gán ip tới 1 passive server khác.

## 6. So sánh HAProxy và một số giải pháp LB khác

**Một số giải pháp LB khác**

- Linux Virtual Server (LVS) – Một layer 4 load balancer đơn giản, nhanh được giới thiệu trong nhiều bản phân phối Linux.

- Nginx – Máy chủ web nhanh và đáng tin cậy được dùng cho proxy và cân bằng tải. Nginx thường dùng kết hợp với HAProxy cho việc lưu đệm (caching) và nén dữ liệu (compression) của mình.

**Link tham khảo**

https://www.digitalocean.com/community/tutorials/an-introduction-to-haproxy-and-load-balancing-concepts#haproxy-terminology
