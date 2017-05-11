# Tìm hiểu về giao thức DHCP
===========================================
# Mục lục

## [1. Tổng quan về giao thức DHCP](#tongquan)
###   [1.1 Giới thiệu](#gioithieu)
###  [1.2 Khái niệm](#khainiem)
## [2. Hoạt động của DHCP](#hoatdong)
###   [2.1 Tiến trình hoạt động trong DHCP](#tientrinh)
###   [2.2 Các bản tin trong DHCP](#bantin)
###   [2.3 Cấu trúc DHCP Header](#cautruc)



================================================

<a name="tongquan"></a>
## 1.Tổng quan về giao thức DHCP
### 1.1 Giới thiệu
  Thông thường trong một mô hình mạng, người quản trị có thể cấu hình địa chỉ IP bằng 2 cách : cấu hình IP thủ công (static) và cấu hình cấp phát tự động (Dynamic).
  - Stactic : người quản trị phải khai báo các thông tin như : địa chỉ IP,Default gatewway, DNS server,.. một cách thủ công.Nghĩa là đến từng máy tính trong mạng và cấu hính các thông tin đó. Điều này chỉ phù hợp cho các mạng Lan có dưới 20 máy hoặc một trong các máy trạm cần phải có một địa chỉ IP tĩnh,...Nhưng nếu một mạng máy tính lớn thì việc đến từng máy cấu hình thì không khả thi.Và việc các máy tính xung đột IP là điều khó tránh khỏi.
  
  -Dynamic : Một địa chỉ IP động là một địa chỉ sẽ thay đổi trong khoảng thời gian xác định. Người quản trị dùng dịch vụ DHCP để cấp phát địa chỉ IP động này cho các máy trạm trong mạng .Với mô hình này người quản trị không cần phải đến từng máy trạm trong mạng để cấu hình mà chỉ cần ngồi ở máy chủ DHCP để quản lý cấp phát.Phù hợp với việc cấp phát IP cho một mạng lớn, mạng công cộng.
  Việc cấp phát Ip động này mang đến rất nhiều lợi ích :
  - Cấu hình địa chỉ tập trung cho client.
  - Khắc phục được tình trạng xung đột IP.
  - Giúp cho nhà cung cấp tiết kiệm dc IP thật.
  - Phù hợp cho các máy tính thường xuyên di chuyển qua lại giữa các mạng.
  -Kết nối mạng không dây, hoặc cấp phát IP cho các thiết bị di động,...

<a name="khainiem"></a>
### 1.2 Khái niệm
  Dynamic Host Configuaration Protocl (DHCP - giao thức cấu hình động máy chủ) là một giao thức hoạt động theo mô hình Client-Server, tự động cấp phát địa chỉ IP cho các máy client trong mang và các thông tin cấu hình liên quan: subnet mask,default gatewway,... ngoài ra nó cũng cấp phát các thông số cấu hình TCP/IP tới các máy client trong hệ thống.

<a name="hoatdong"></a>
## 2. Hoạt động của DHCP

<a name="tientrinh"></a>
### 2.1 Tiến trình hoạt động trong DHCP
<img src=http://i.imgur.com/yT3YZes.png>

  - Bước 1 : Khi máy Client khởi động sẽ gửi broadcast gói tin DHCP Discover, yêu cầu một Server phục vụ mình. Gói tin này chứa địa chỉ MAC của client. Nếu Client không liên lạc được với DHCP Server thì sau 4 lần truy vấn không thành công nó sẽ tự động phát sinh ra một địa chỉ IP riêng cho chính mình nằm trong dãu 169.254.0.0 đến 169.254.255.255 dùng để liên lạc tạm thời. Và Client vẫn duy trì việc phát tín hiệu Broadcast đến các DHCP Server trong mạng sau mỗi 5 phút.

  - Bước 2 :Các máy Server trên mạng khi nhận được yêu cầu đó, nếu còn khả năng cung cấp địa chỉ IP thì sẽ gửi lại cho máy Client một gói tin DHCP OFFER, đề nghị cho thuê một địa chỉ trong một khoảng thời gian nhất định, kèm theo là SubnetMask và địa chỉ của Server. Server sẽ không cấp phát địa chỉ IP vừa đề nghị cho tuê trong suốt thời gian thương thuyết.
  - Bước 3 : Máy Client sẽ lựa chọn một DHCP OFFER và gửi broadcast lại gói tin DHCP REQUEST và chấp nhận lời đề nghị đó. Điều này cho phép các lời đề nghị không được phép chấp nhận sẽ được các Server rút lại và dùng để cấp phát cho các Client khác.
  - Bước 4 : Máy Server được Client chấp nhận sẽ gửi ngược lại một gói tin DHCP ACK như một lời xác nhận, cho biết địa chỉ IP đó, SubnetMask đó và thời hạn sử dụng đó sẽ chính thức được áp dụng kèm theo các thông tin bổ sung như Default gateway, DNS Server.

<a name="bantin"></a>
### 2.2 Các bản tin tronng DHCP
  -`DHCP DISCOVER` : Là bản tin broadcast của client trong lần đầu tiên tham gia vào mạng, bản tin này yêu cầu cấp phát địa chỉ IP từ DHCP server.

  -`DHCP OFFER` : Là bản tin broadcast của DHCP server thông báo rằng đã nhận được bản tin DHCP DISCOVER và có tập cấu hình một địa chỉ IP để cấp cho client. Bản tin DHCP OFFER chứa một địa chỉ IP chưa cấp phát và kèm theo các thông tin cấu hình TCP/IP, cũng như thông tin về subnetmask, default gateway.

  -`DHCP REQUEST` : Bản tin broadcast bởi DHCP client sau khi lựa chọn một bản tin DHCP OFFER. Bản tin này chứa địa chỉ IP từ bản tin DHCP OFFER đã chọn, xác nhận thông tin IP đã nhận từ server để các DHCP server khác không gửi bản tin Offer cho client đó nữa.

  -`DHCP ACK` : Unicast bởi DHCP server đến DHCP client xác nhận thông tin từ gói DHCP REQUEST. Tất cả thông tin cấu hình IP sẽ được gửi đến cho client và kết thúc quá trình cấp phát IP.

  -`DHCP NACK` : Unicast bởi DHCP server tới DHCP clientthông báo từ chối bản tin DHCP REQUEST .

  -`DHCP DECLINE` :  bởi một DHCP client gửi tới một DHCP server, thông báo từ chối IP được cung cấp vì địa chỉ đó đã được sử dụng bởi một máy khác.

<a name="cautruc"></a>
### 2.3 Cấu trúc DHCP Header

<img src=http://i.imgur.com/WkTLKoU.png>

Trong đó :
  - Operation Code : Thể hiện loại gói tin DHCP
    + Value 1 : gói tin Request.
    + Value 2 : gói tin Reply.
  - Hardware type : Quy định loại hardware
    + Value 1 : Ethernet
    + Value 2 : IEEE 802,..
  - Hardware Address Length : Quy định độ dài địa chỉ Hardware.
  - Hops : Dùng cho gói tin Relay Agent.
  - Transaction Identifier : Được tạo ra từ client, dùng để liên kết giữa client và server.
  - Seconds : Quy định thời gian cho thuê IP của client (s).
  - Client IP Adress : Ip của client nếu có hoặc xin cấp lại IP khác, nếu client không có IP thì trường này mặc định = 0.
  - Your IP Address : IP Server cấp cho Client.
  - Server IP Address : địa chỉ IP của Server.
  - Gateway IP Add : địa chỉ gateway của mạng.
  - Client Hardware Add : địa chỉ vật lý của client.
  - Server name : khi gửi gói tin offer hoặc ack thì kèm theo DNS.
  - Boot File name : Sử dụng bời client để yêu cầu loại tập tin khởi động cụ thể trong gói tin discover.Sử dụng bởi server để chỉ rõ toàn bộ đường dẫn, tên file của file khởi động trong gói tin offer.
