# Tìm hiểu về firewall

## Mục lục

1. firewall là gì và tại sao cần có firewall?

2. Tính năng của firewall

3. Các loại firewall

4. firewall topo

---------

## 1. firewall là gì và tại sao cần có firewall?

Firewall là access control device, nó tập trung phân tích ip packet, so sánh nó với các rules và quyết định xem packet đó có được phép đi qua hay không hoặc thực hiện một số hành động khác.

Tại sao cần firewall?

Giờ đây kết nối internet là gần như bắt buộc đối với mọi tổ chức. Tuy nhiên việc kết nối internet cũng mang lại những mối nguy hại bởi nó cho phép bên ngoài có thể kết nối tới mạng local của bạn. Việc trang bị cho mỗi server những tính năng bảo mật là một giải pháp tuy nhiên nó  không thực sự tối ưu đối với những hệ thống có nhiều máy với những hệ điều hành khác nhau. Firewall được sinh ra để giải quyết vấn đề này, nó sẽ được đặt ở giữa internet và mạng local của bạn để control network vào và ra.

## 2. Tính năng của firewall

**những mục tiêu khi firewall ra đời**

- Tất cả các traffic vào và ra đều phải đi qua firewall.

- Chỉ có những traffic được xác thực, được định nghĩa qua local policy mới được phép pass qua.

- Firewall không thể bị thâm nhập

Khi mới ra đời, firewall chủ yếu tập trung vào quản lí service, giờ đây, nó đã có thể làm nhiều hơn thế:

- Service control: Xác định loại internet services có thể được access. Firewall sẽ filter gói tin dựa trên IP address, protocol, or port number hoặc cung cấp proxy software tiếp nhận và phân tích service request trước khi cho phép nó đi qua.

- Direction control: Xác định hướng đi của từng service request

- User control: Điều khiển access tới dịch vụ dựa vào users

- Behavior control: Điều khiển cách sử dụng các dịch vụ đặc biệt. Ví dụ firewall sẽ filter e-mail để giảm spam.

**khả năng của firewall**

- Firewall định nghĩa ra single choke point giữ các users chưa được xác thức khỏi network được bảo vệ, chặn những dịch vụ có khả năng gây hại tới hệ thống và cung cấp sự bảo vệ đối với IP spoofing và routing attacks.

- Firewall cũng cung cấp nơi để giám sát security-related events, thử nghiệm và đưa ra những cảnh báo.

- Firewall là platform cho một số tính năng như NAT hoặc ghi log lại về mức độ sử dụng internet.

- Firewall có thể được sử dụng để triển khai virtual private networks.

**Những hạn chế của firewall**

- Firewall không thể bảo vệ lại những cuộc tấn công đi vòng qua nó.

- Firewall không thể bảo vệ hoàn toàn khỏi những mối nguy hại từ bên trong (ví dụ nhân viên hợp tác với bên ngoài tổ chức tấn công)

- Firewall không thê bảo vệ những wireless communications giữa local systems trên các sides khác nhau của internal firewall.

-  Các thiết bị cầm tay, laptop có thể bị lây nhiễm từ bên ngoài và thâm nhập vào mạng nội bộ.

## 3. Các loại firewall

### 3.1 Packet Filtering Firewall

packet filtering firewall áp dụng một loạt các rules đối với incoming và outgoing IP packet rồi sau đó forward hoặc discard packet. Firewall thường được cấu hình để filter ở cả hai chiều. Filter rules bao gồm: source/destination ip address, source/destination port number, ip protocol field, interface.

Nếu packet không match với rule nào thì policy sẽ được thực thi. Có 2 policy chính đó là forward và discard. policy discard được khuyến cáo sử dụng và thường nó được áp dụng đối với các doanh nghiệp và tổ chức. Ngược lại, policy forward lại thường được sử dụng bởi các tổ chức mở hơn ví dụ như các trường đại học.

Mô hình phổ biến nhất của firewall

<img src="">

Các loại firewall và layer mà nó sử dụng tới

<img src="">

## 3.2 Stateful Inspection Firewalls

Như chúng ta đã biết, hầu hết các ứng dụng ngày nay chạy trên sử dụng giao thức TCP với mô hình client-server. Khi mà ứng dụng sử dụng TCP để tạo ra session, nó tạo ra 1 kết nối TCP với 2 port number, một cho server (0-1024) và 1 cho local (1024-65535).

Packet filtering bình thường sẽ buộc phải cho phép inbound network traffic đối với tất cả các port xuất phát từ local (1024-65535). Điều này có thể dẫn tới một số nguy cơ về bảo mật.

stateful inspection packet firewall sẽ thiết chặt lại rules đối với tcp traffic bằng việc tạo ra directory cho outbound tcp connections. Mỗi một kết nối được thiết lập sẽ được nằm trong 1 entry. Giờ đây packet filter chỉ cho phép incoming traffic có packets phù hợp với profile trong entries của directory.
