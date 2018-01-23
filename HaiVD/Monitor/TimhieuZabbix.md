# Tìm hiểu về Zabbix
-------------------------------------------
# Mục lục

## [I.Tổng quan về Zabbix](#tq)
### [1.1 Khái niệm Zabbix](#11)
### [1.2 Tính năng Zabbix](#12)
### [1.3 Các thành phần Zabbix](#13)
### [1.4 Cấu trúc thư mục Zabbix](#14)
### [1.5 Các định nghĩa trong Zabbix ](#15)
### [1.6 Cách thức hoạt động trong Zabbix Server](#16)
### [1.7 Cách giao tiếp giữa Zabbix Server và Zabbix Agent](#17)


## [II. Cài đặt Zabbix](#cd)
### [2.1 ]

<a name=tq></a>
## I.Tổng quan về Zabbix

<a name=11></a>
### 1.1 Khái niệm Zabbix

Zabbix là công cụ mã nguồn mở với mục đích giám sát và cảnh báo hạ tầng CNTT trong hệ thống của doanh nghiệp, tổ chức. Zabbix cung cấp nhiều phương thức khác nhau phục vụ cho việc giám sát hạ tầng IT, gần như tất cả các hạ tầng IT thông thường trong hệ thống. Ngoài ra, Zabbix cho phép các cơ chế giám sát phân tán với một hệ thống quản trị tập trung. Khi rất nhiều hệ thống cần phải có một cơ sở dữ liệu tập trung, Zabbix cho phép cơ chế giám sát phân tán thông qua các nodes và proxies và vẫn sử dụng các Zabbix agents để thu thập dữ liệu giám sát.

<a name=12></a>
### 1.2 Tính năng Zabbix

Zabbix có nhiều tính năng như :

– Quản lý tập trung, sử dụng web interface.
– Chạy trên gần như tất cả HĐH Unix-base như CentOS, Ubuntu, FreeBSD, Solaris..
– Có phiên bản Agents cho HĐH Unix-like và Windows.
– Có khả năng monitor các thiết bị hỗ trợ SNMP (v1,2,3), IPMS.
– Hiển thị đồ họa và các tính năng minh họa khác.
– Cảnh báo trong Zabbix cho phép dễ dàng tích hợp với các hệ thống khác.
– Cấu hình linh hoạt, bao hồm các mẫu (template).
– Và rất nhiều tính năng khác cho phép thiết kế, triển khai một hệ thống monitoring hoàn chỉnh.

<a name=13></a>
### 1.3 Các thành phần Zabbix

Một hệ thống Zabbix đầy đủ gồm 3 thành phần cơ bản :

- Zabbix Server : Đây là thành phần trung tâm của Zabbix, chứa tất cả các dữ liệu cấu hình, thống kê và các hoạt động được lưu trữ,nhận các số liệu từ các Zabbix Agent,Proxy,host,..về tính khả dụng và toàn vẹn của các hệ thống.Zabbix Server cũng có thể tự kiểm tra các dịch vụ kết nối mạng như máy chủ web, máy chủ thư bằng các dịch vụ kiểm tra đơn giản. Zabbix Server gồm 3 thành phần con :
<ul>
<li>Zabbix Server : Nơi xử lý toàn bộ hệ thống </li>
<li>WebInterface : Cung cấp giao diện quản lý, giám sát cho quản trị viên.</li>
<li>Zabbix Database : Thường là MySQL hoặc Oracle lưu trữ tất cả các dữ liệu từ Agents và Proxy gửi lên.</li>
</ul>

- Zabbix proxy : là phần tùy chọn của Zabbix, Proxy sẽ thu nhận dữ liệu, lưu trong bộ nhớ đệm và được chuyển đến Zabbix Server.Zabbix Proxy là một giải pháp lý tưởng cho giám sát tập trung của địa điểm từ xa, chi nhánh , mạng lưới không có các quản trị viên.Zabbix Proxy cũng có thể được sử dụng để phân phối tải một đơn Zabbix server.
- Zabbix Agent : Để chủ động trong việc giám sát các thiết bị cục bộ và các ứng dụng (ổ cứng,bộ nhớ,xử lý số liệu thống kê,.... ) trên hệ thống mạng, các hệ thống phải chạy trên Zabbix agent, Agent sẽ thu thập thông tin  hoạt đông từ hệ thống mà nó đang chạy và báo cáo dự liệu đến Zabbix Server để xử lý tiếp. Trong trường hợp lỗi (ổ cứng đầy,dịch vụ chết,...)các Zabbix server sẽ báo cáo cho quản trị viên.

<a name=14></a>
### 1.4 Cấu trúc thư mục Zabbix

- Docs : Thư mục chứa file hướng dẫn
- Src : Thư mục chưa tất cả source cho các tiến trình Zabbix
- Src/zabbix_server : Thư mục chưa file tạo và source cho Zabbix server
- Src/zabbix_agent : Thư mục chưa file tạo và source cho Zabbix Agent
- Src/zabbix_get : Thư mục chưa file tạo cho Zabbix get
- Src/zabbix_sender : Thư mục chứa file tạo và source cho Zabbix sender
- Incude : Thư mục chứa các thư viện Zabbix.
- Misc/init.d : Thư mục chưa các tệp tin khởi động trên các nền khác nhau.
- Frontends/php : Thư mục chứa các file php
- Create : Thư mục chứa dữ liệu cho việc tạo cơ sở dữ liệu ban đầu.
- Upgrades : Thư mục chứa thủ tục nâng cáp cho phiên bản khác nhau của linux.

<a name=15></a>
### 1.5 Các định nghĩa trong Zabbix

Khi triển khai một hệ thống Zabbix có thể gặp những định nghĩa sau :
- host : Thiết bị muốn giám sát (IP/DNS)
- host group : Một nhóm các logic host(có thể chỉ là các host hoặc có thêm template).Được dùng khi sử dụng quyền truy cập cho các nhóm người dùng khác nhau.
- item : Phần dữ liệu muốn nhận được từ host.
- trigger  : Biểu thức xác định ngưỡng vấn đề của các dữ liệu nhận được và đánh giá chúng.(gồm 2 trạng thái : OK và PROBLEM).
- event : Các sự kiện thay đổi,ví dụ như trạng thái của thiết bị,...
- action : Là những phản ứng của hệ thống trước 1 sự kiện nào đó.
- escalation : Các kịch bản phản ứng được dựng sẵn.
- template : Các bản mẫu gồm rất nhiều item,trigger,action,... có sẵn .
- media : nghĩa là nơi cung cấp các cảnh báo, hay còn hiểu như là một kênh phân phối.
- notification : Thông báo gửi tới người dùng,được lấy từ media.
- remote command : Các câu lệnh tự động thực hiện trên các host từ xa.
- web scenario : Một hoặc nhiều yêu cầu HTTP để kiểm tra tính khả dụng của một trang web.
- frontend : Giao diện web được cung cấp với Zabbix
- Zabbix API : cho phép bạn sử dụng giao thức JSON RPC để tạo, cập nhật và lấy các đối tượng Zabbix (host, grap  và những thứ khác) hoặc thực hiện bất kỳ tác vụ tùy chỉnh nào khác.

<a name=16></a>
### 1.6 Cách thức hoạt động trong Zabbix Server

- Zabbix Server trực tiếp theo dõi các thiết bị ,hoặc có thể thông qua Zabbix Proxy. Cả Zabbix Agents, Zabbix Proxy và Zabbix Server đều được viết bằng ngôn ngữ lập trình C.Còn Zabbix Web được viết bằng ngôn ngữ PHP . Các thành phần này có thể được cài đặt trên cùng một máy hoặc trên các máy chủ khác . Khi chạy các thành phần riêng biệt , Zabbix Server và Zabbix Web đều phải truy cập vào Zabbix Database. Zabbix Web cần phải truy cập vào Zabbix Server đê hiển thị trạng thái Server và một số chức năng bổ sung khác. Các hướng kết nối có thể được mô tat như hình sau :

<img src=http://i.imgur.com/8HmOSab.png>

Có thể tách thành từng phần và triển khai trên các hệ thống khác nhau để nâng cao hiệu suất, nhưng đối với một hệ thống giám sát, cần sự hoạt động ổn định thì nên để cả 3 thành phần nên cùng 1 hệ thống nhăm giảm thiểu tối ưu các rủi ro có thể xảy ra.

<a name=17></a>
### 1.7 Cách giao tiếp giữa Zabbix Server và Zabbix Agent

Trong hệ thống Zabbix Agent, dựa trên cách trao đổi với Zabbix Server thì Zabbix Agent được chia làm 2 loại :

- Passive Agent : Khi Zabbix Server muốn kiểm tra thông tin của các Host , Zabbix Server sẽ gửi Request đến Zabbix Agent các item để yêu cầu Zabbix Agent cung cấp thông tin. Zabbix Agent sẽ tiến thành thu thập những thông tin đó và gửi lại cho Zabbix Server, phiên kết nối kết thúc.

<img src=http://i.imgur.com/GVhVaZc.png>


- Active Agent : Zabbix Server không hề tự động yêu cầu các thông số như Passive Agent. Mà Active Agent tự động gửi yêu cầu Zabbix Server cần giám sát nhưng thông số nào. Sau đó Zabbix Server sẽ phản hồi lại các yêu cầu thông số mà Zabbix Server muốn giám sát. Phiên kết nối kết thúc. Active Agent sẽ tiến hành thu thập thông tin Zabbix Server cần và mở 1 phiên kết nối 1 chiều đến Zabbix Server và gửi các thông tin mà Zabbix Server yêu cầu.

<img src=http://i.imgur.com/YmYV4b4.png>

<img src=http://i.imgur.com/iZvmvOs.png>
