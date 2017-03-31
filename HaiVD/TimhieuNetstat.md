# Tìm hiểu về Netstat
=========================================
# Mục lục
## [I. Định nghĩa Netstat](#dn)
## [II. Các tùy chọn trong Netstat](#tuychon)
## [III. Các trạng thái Port trong Netstat](#trangthai)
## [IV. Tài liệu tham khảo](#tltk)

<a name=dn></a>
## I. Định nghĩa Netstat

  Netstat là một công cụ hữu ích của Linux cho phép bạn kiểm tra những dịch vào nào đang kết nối đến hệ thống của bạn. Nó rất hữu ích trong việc phân tích cái gì đang xảy ra trên hệ thống của bạn khi bạn cố gắng ngăn chặn một cuộc tấn công nhằm vào nó. Bạn có thể tìm thêm thông tin như có bao nhiêu kết nối được tạo ra trên một cổng, địa chỉ IP nào đang kết nối đến và nhiều thông tin khác nữa. Netstat đi kèm trong hầu hết các bản phân phối của Linux vì vậy nó nên được cài đặt trên hệ thống của bạn.

  Netstat nhằm kiểm tra và hiển thị các kết nối TCP đang hoạt động, các cổng mà máy tính đang nghe, thống kê Ethernet, bảng định tuyến IP, thống kê IPv4 (cho các giao thức IP, ICMP, TCP và UDP) và số liệu thống kê IPv6 (cho IPv6, ICMPv6, TCP over IPv6 , Và UDP trên các giao thức IPv6).

<a name=tuychon></a>
## II. Các tùy chọn trong Netstat

  Cấu trúc một câu lệnh trong Netstat :

```
netstat [-a] [-e] [-n] [-l] [-o] [-p Protocol] [-r] [-s] [Interval]
```
   Trong đó :

   - `netstat -a` : Hiển thị tất cả các kết nối TCP hoạt động và các cổng TCP và UDP trên máy tính đang nghe.

<img src=http://i.imgur.com/fJ40pgI.png>

  - ` netstat -at`: Kiểm tra các port đang sử dụng phương phức TCP

<img src=http://i.imgur.com/eb0EHUt.png>

  - `netstat -au` : Kiểm tra các port đang sử dụng phương phức UDP

<img src=http://i.imgur.com/9qWMtDp.png>

  - `netstat -e ` : Hiển thị thống kê Ethernet, chẳng hạn như số byte và gói tin được gửi và nhận. Tham số này có thể được kết hợp với -s.

<img src=http://i.imgur.com/QaZC7tI.png>
  - `netstat -n ` : Hiển thị các kết nối TCP hoạt động, tuy nhiên, các địa chỉ và số cổng được biểu hiện bằng số và không hiển thị tên.
  - `netstat -o` : Hiển thị các kết nối TCP đang hoạt động và bao gồm ID quy trình (PID) cho mỗi kết nối. Bạn có thể tìm ứng dụng dựa trên PID trên tab Processes trong Windows Task Manager. Tham số này có thể được kết hợp với -a, -n, và -p.
  - `netstat -p Protocol` : Hiển thị các kết nối cho giao thức được chỉ định bởi Giao thức. Trong trường hợp này, Giao thức có thể là tcp, udp, tcpv6 hoặc udpv6. Nếu tham số này được sử dụng với -s để hiển thị số liệu thống kê theo giao thức, Giao thức có thể là tcp, udp, icmp, ip, tcpv6, udpv6, icmpv6 hoặc ipv6.
  - `netstat -s` (-st,-su): Hiển thị số liệu thống kê theo giao thức. Theo mặc định, số liệu thống kê được hiển thị cho giao thức TCP, UDP, ICMP và IP.


  - `netstat -l` : Kiểm tra các port đang ở trạng thái Listen

<img src=http://i.imgur.com/tVPpeFZ.png>

  - `netstat -lt` : Kiểm tra các Port sử dụng TCP đang trạng thái listen

<img src=http://i.imgur.com/oAChwQ1.png>

  - `netstat -plnt` : Kiểm tra các port đang lắng nghe dịch vụ gì

<img src=http://i.imgur.com/KZFZkIj.png>

  - `netstat -r` : hiển thị thông tin bảng định tuyến

<img src=http://i.imgur.com/QQi1K0i.png>

## III. Các trạng thái Port trong Netstat
  Khi kiểm tra trạng thái các Port sẽ xuất hiện một trong các trạng thái sau :
  - ESTABLISHED : Kết nối được thiết lập
  - SYN_SENT : Đang cố gắng thiết lập kết nối.
  - SYN_RECV : Đã nhận được yêu cầu kết nối từ mạng.
  - FIN_WAIT1 : Kết nối đã được đóng và đang tắt.
  - FIN_WAIT2 : Kết nối đã được đóng và đang chờ ngắt kết nối từ xa.
  - TIME_WAIT : Kết nối đang chờ xử lý các gói tin còn trong mạng.
  - CLOSE : Kết nối không được sử dụng.
  - CLOSE_WAIT : Kết nối từ xa đã đóng, và đang chờ kết nối cục bộ kết thúc.
  - LAST_ACK : Kết nối từ xa đã đóng,kết nối cục bộ đã đóng và đang chờ xác nhận.
  - LISTEN : Kết nối đang được mở.
  - UNKNOWN : Không xác định.
<a name=tltk></a>
## IV. Tài liệu tham khảo

- https://technet.microsoft.com/en-us/library/bb490947.aspx
- http://netstat.net/
