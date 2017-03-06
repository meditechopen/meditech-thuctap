
#DHCP
##Khái niệm:
DHCP là viết tắt của Dynamic Host Configuration Protocol:

Giao thức Cấu hình Host Động DHCP được thiết kế làm giảm thời gian chỉnh cấu hình cho mạng TCP/IP bằng cách tự động gán các địa chỉ IP cho khách hàng khi họ vào mạng.

DHCP tập trung việc quản lý địa chỉ IP ở các máy tính trung tâm chạy chương trình DHCP. Mặc dù có thể gán địa chỉ IP vĩnh viễn cho bất cứ máy tính nào trên mạng, DHCP cho phép gán tự động. Để khách có thể nhận địa chỉ IP từ máy chủ DHCP, bạn khai báo cấu hình để khách “nhận địa chỉ tự động từ một máy chủ”. Tùy chọn nầy xuất hiện trong vùng khai báo cấu hình TCP/IP của đa số hệ điều hành. Một khi tùy chọn nầy được thiết lập, khách có thể “thuê” một địa chỉ IP từ máy chủ DHCP bất cứ lúc nào. Phải có ít nhất một máy chủ DHCP trên mạng. Sau khi cài đặt DHCP, bạn tạo một phạm vi DHCP (scope), là vùng chứa các địa chỉ IP trên máy chủ, và máy chủ cung cấp địa chỉ IP trong vùng này

Nói một cách tổng quan hơn DHCP là dich vụ mang đến cho chúng ta nhiều lợi điểm trong công tác quản trị và duy trì một mạng TCP/IP như:

- Tập chung quản trị thông tin về cấu hình IP.
- Cấu hình động các máy.
- Cấu hình IP cho các máy một cách liền mạch
- Sự linh hoạt
- Khả năng mở rộng.

##Chức năng:
- Mỗi thiết bị trên mạng cơ sở TCP/IP phải có một địa chỉ IP duy nhất để truy cập mạng và các tài nguyên của nó. Không có DHCP, cấu hình IP phải được thực hiện một cách thủ công cho các máy tính mới, các máy tính di chuyển từ mạng con này sang mạng con khác, và các máy tính được loại bỏ khỏi mạng.

- Bằng việc phát triển DHCP trên mạng, toàn bộ tiến trình này được quản lý tự động và tập trung. DHCP server bảo quản vùng của các địa chỉ IP và giải phóng một địa chỉ với bất cứ DHCP client có thể khi nó có thể ghi lên mạng. Do là cơ chế động nên các IP đã được cấp phát nhưng trong một khoảng thời gian nhất định mà không còn hoạt động sẽ được thu hồi và cấp lại cho máy khác khi tham gia mạng.



##Các thông điệp DHCP:

- **DHCP Discover**: Một DHCP Client khi mới tham gia vào hệ thống mạng, nó sẽ yêu cầu thông tin địa chỉ IP từ DHCP Server bằng cách broadcast một gói DHCP Discover. Địa chỉ IP nguồn trong gói là 0.0.0.0 bởi vì client chưa có địa chỉ IP.

- **DHCP Offer**: Khi DHCP server nhận được gói DHCP Discover từ client, nó sẽ gửi lại một gói DHCP Offer chứa địa chỉ IP, Subnet Mask, Gateway,... Có thể nhiều DHCP server gửi lại với gói DHCP Offer nhưng Client sẽ chấp nhận gói DHCP Offer đầu tiên nó nhận được.

- **DHCP Request**: Khi DHCP client nhận được một gói DHCP Offer, nó đáp lại bằng việc broadcast gói DHCP Request để xác nhận hoặc để kiểm tra lại các thông tin mà DHCP server vừa gửi.

- **DHCP Acknowledge**: Server kiểm tra và xác nhận lại sự chấp nhận trên bằng gói tin DHCP Acknowledge, Client có thể tham gia trên mạng TCP/IP và hoàn thành hệ thống khởi động.

- **DHCP Nak**: Nếu một địa chỉ IP đã hết hạn hoặc đã được đặt một máy tính khác, DHCP Server gửi gói DHCP Nak cho Client, như vậy Client phải bắt đầu tiến trình thuê bao lại.

- **DHCP Decline**: Nếu DHCP Client nhận được bản tin trả về không đủ thông tin hoặc hết hạn, nó sẽ gửi gói DHCP Decline đến các Server và Client phải bắt đầu tiến trình thuê bao lại.

- **DHCP Release**: Client gửi bản tin này đến server để ngừng thuê IP. Khi nhận được bản tin này, server sẽ thu hồi lại IP đã cấp cho Client, khi đó client sẽ không được cấu hình IP.

##Cơ chế hoạt động 

<img src="https://4.bp.blogspot.com/-a7zDnDRnrdE/V2HsgvgsNYI/AAAAAAAAAGQ/cOW7xedGlaw84kmRHWKOOebp62tb_FZuACLcB/s1600/dhcp.jpg">

- Bước 1: Khi máy Client khởi động, máy sẽ gửi broadcast gói tin DHCP DISCOVER, yêu cầu một Server phục vụ mình. Gói tin này cũng chứa địa chỉ MAC của client. Nếu client không liên lạc được với DHCP Server thì sau 4 lần truy vấn không thành công nó sẽ tự động phát sinh ra 1 địa chỉ IP riêng cho chính mình nằm trong dãy 169.254.0.0 đến 169.254.255.255 dùng để liên lạc tạm thời. Và client vẫn duy trì việc phát tín hiệu Broad cast sau mỗi 5 phút để xin cấp IP từ DHCP Server.

- Bước 2: Các máy Server trên mạng khi nhận được yêu cầu đó. Nếu còn khả năng cung cấp địa chỉ IP, đều gửi lại cho máy Client một gói tin DHCP OFFER, đề nghị cho thuê một địa chỉ IP trong một khoảng thời gian nhất định, kèm theo là một Subnet Mask và địa chỉ của Server. Server sẽ không cấp phát đia chỉ IP vừa đề nghị cho client thuê trông suốt thời gian thương thuyết.

- Bước 3: Máy Client sẽ lựa chọn một trong những lời đề nghị ( DHCPOFFER) và gửi broadcast lại gói tin DHCPREQUEST và chấp nhận lời đề nghị đó. Điều này cho phép các lời đề nghị không được chấp nhận sẽ được các Server rút lại và dùng để cấp phát cho các Client khác.

- Bước 4: Máy Server được Client chấp nhận sẽ gửi ngược lại một gói tin DHCP ACK như một lời xác nhận, cho biết địa chỉ IP đó, Subnet Mask đó và thời hạn cho sử dụng đó sẽ chính thức được áp dụng. Ngoài ra server còn gửi kèm những thông tin bổ xung như địa chỉ Gateway mặc định, địa chỉ DNS Server.

##DHCP header

Tên Field | Kích thước (byte) | Mô tả |
--- | --- | --- |
Op | 1 | *Operation Code*: Chỉ ra cho ta thấy loại thông điệp. Giá trị 1 là request message, 2 là reply message. |
HType | 1 | *Hardware Type*: Loại công nghệ mà mạng đó đang sử dụng. VD: Ethernet,... |
HLen | 1 | *Hardware Address Length*: Độ dài của địa chỉ phần cứng của công nghệ mạng ở trên. VD MAC=6 |
Hops | 1 | *Hops*: Có giá trị bằng 0 trước khi gửi yêu cầu, khi qua mỗi Relay Agent sẽ được tăng thêm 1 |
XID | 4 | *Transaction Identifier*: Một trường dài 32bit được client tạo ra, để liên kết thông điệp yêu cầu và phản hồi từ máy chủ DHCP|
Secs | 2 | *Seconds*: Số giây mà client gửi thông điệp đến server|
Flags | 2 | Đây là một loại dấu hiệu để nhận biết gói tin client có phải là Broadcast (1) hay không. |
CIAddr | 4 | *Client IP Address*: Máy khách sẽ đưa IP của nó vào trường này nếu nó hợp lệ hoặc đang trong các trạng thái BOUND, RENEWING, REBINDING; ngược lại giá trị bằng 0 |
YIAddr | 4 | *"Your" IP Address* Đây là địa chỉ IP mà server gán cho client |
SIAddr | 4 | *Server IP Address* Địa chỉ của DHCP mà client giao tiếp để thuê IP trong suốt thời gian ở trong mạng này |
GIAddr | 4 | *Gateway IP Address*Địa chỉ GW để mạng này ra ngoài mạng khác, Internet,... |
CHAddr | 16 | *Client Hardware Address* Địa chỉ MAC của client, dùng để xác định và giao tiếp |
SName | 64 | *Server Name* Tên của server, có thể là domain của server |
File | 128 | *Boot Filename* Với client, khởi động thông điệp DHCPDiscover. Với server thì nó dùng để gửi đi các thông điệp Off |
Options | Variable | Các tùy chọn, các thông số đi kèm (nếu có) |

#Cài đặt và cấu hình DHCP
Mô hình triển khai 

<img src="http://i.imgur.com/CaHMm6I.png">

Trước hết chúng ta sử dung câu lệnh ``sudo apt-get install isc-dhcp-server`` để cài đặt dịch vụ DHCP

**note** để cài được dịch vụ DHCP phải có card NAT để chúng ta có thể tiến hành tải và cài đặt những repo cần thiết cho quá trình lab.

vào file cấu hình dhcpd.conf . Ở đây mình chọn địa chỉ cấp phát IP từ 10.10.10.10 đến 10.10.10.40

<img src="http://i.imgur.com/gNNZx8c.png">

Sau đó lưu file lại và khởi động dịch vụ DHCP bằng câu lệnh 

``sudo /etc/init.d/isc-dhcp-server start``


 Cuối cùng là kiểm tra máy client xem đã nhận được IP động chưa.

<img src="http://i.imgur.com/pSQLiQr.png">


Thông thường một máy chủ DHCP-server sẽ được cấu hình theo 2 phương pháp

- Vùng địa chỉ : Phương pháp này đòi hỏi phải xác định 1 vùng (Phạm Vi) của địa chỉ IP và DHCP cung cấp cho khách hàng của họ đang cấu hình và tính năng động trên một server cơ sở . Một khi DHCP client không còn trên mạng cho 1 khoảng thời gian xác định, cấu hình là hết hạn và khi trở lại sẽ được cấp phát địa chỉ mới bằng cách sử dụng các dịch vụ của DHCP.

- Địa chỉ MAC : Phương pháp này đòi hỏi phải sử dụng dịch vụ DHCP xác định địa chỉ phần cứng duy nhất của mỗi card mạng kết nối với các mạng lưới và sau đó liên tục cung cấp một cấu hình DHCP mỗi lần khách hàng yêu cầu để tạo ra một trình phục vụ DHCP bằng cách sử dụng các thiết bị mạng.


