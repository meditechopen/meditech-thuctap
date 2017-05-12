# Tìm hiểu về Zabbix
-------------------------------------------
# Mục lục

## [I.Tổng quan về Zabbix](#tq)
### [1.1 Khái niệm Zabbix](#11)
### [1.2 Tính năng Zabbix](#12)
### [1.3 Các thành phần Zabbix](#13)
### [1.4 Cấu trúc thư mục Zabbix](#14)
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

Zabbix gồm 4 thành phần cơ bản :

- Zabbix Server : Đây là thành phần trung tâm của Zabbix, chứa tất cả các dữ liệu cấu hình, thống kê và các hoạt động được lưu trữ,nhận các số liệu từ các Zabbix Agent,Proxy,host,..về tính khả dụng và toàn vẹn của các hệ thống.Zabbix Server cũng có thể tự kiểm tra các dịch vụ kết nối mạng như máy chủ web, máy chủ thư bằng các dịch vụ kiểm tra đơn giản.
- Zabbix proxy : là phần tùy chọn của Zabbix, Proxy sẽ thu nhận dữ liệu, lưu trong bộ nhớ đệm và được chuyển đến Zabbix Server.Zabbix Proxy là một giải pháp lý tưởng cho giám sát tập trung của địa điểm từ xa, chi nhánh , mạng lưới không có các quản trị viên.Zabbix Proxy cũng có thể được sử dụng để phân phối tải một đơn Zabbix server.
- Zabbix Agent : Để chủ động trong việc giám sát các thiết bị cục bộ và các ứng dụng (ổ cứng,bộ nhớ,xử lý số liệu thống kê,.... ) trên hệ thống mạng, các hệ thống phải chạy trên Zabbix agent, Agent sẽ thu thập thông tin  hoạt đông từ hệ thống mà nó đang chạy và báo cáo dự liệu đến Zabbix Server để xử lý tiếp. Trong trường hợp lỗi (ổ cứng đầy,dịch vụ chết,...)các Zabbix server sẽ báo cáo cho quản trị viên.
- Web Interface : Để dễ dàng truy cập,quản lý dữ liệu theo dõi và sau đó cấu hình Zabbix từ bất cứ giao diện web cung cấp. Giao diện là một phần của Zabbix Server và thường chạy trên các máy vật lý giống như đang chạy một trong các Zabbix Server.

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
