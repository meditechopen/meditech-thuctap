# Tìm hiểu tổng quan về log 
## 1. Là gì và để làm gì?

- Log là gì? Log giống như một nhật kí hệ thống ghi lại các sự việc xảy ra đối với hệ thống. 

- Log dùng để làm gì?

	+ Log ghi lại liên tục các thông báo về hoạt động của cả hệ thống hoặc của các dịch vụ được triển khai trên hệ thống và file tương ứng. Log file thường là các file văn bản thông thường dưới dạng “clear text” tức là bạn có thể dễ dàng đọc được nó, vì thế có thể sử dụng các trình soạn thảo văn bản (vi, vim, nano...) hoặc các trình xem văn bản thông thường (cat, tailf, head...) là có thể xem được file log.
	+ Các file log có thể nói cho bạn bất cứ thứ gì bạn cần biết, để giải quyết các rắc rối mà bạn gặp phải miễn là bạn biết ứng dụng nào, tiến trình nào được ghi vào log nào cụ thể.
	+ Trong hầu hết hệ thống Linux thì /var/log là nơi lưu lại tất cả các log.

## 2. Nơi lưu log và mức độ quan trọng 

Ví dụ: Bạn là một người quản lý tòa nhà. Mỗi ngày bạn nhận được rất nhiều video ghi lại từ camera an ninh. Có nhiều video như vậy để dễ dàng theo dõi bạn phải quy hoạch chúng lại cho từ tiêu chuẩn hay mục đich riêng. Trong log khái niệm đó người ta gọi là Facility

- Các loại Facility được sử dụng trong hệ thống linux là: 
  
	+ auth: sử dụng cho những sự kiện bảo mật, các hoạt động đòi hỏi user/password(getty, su, login)
	+ authpriv: các thông báo liên quan đến kiểm soát truy cập và bảo mật.
	+ cron: cron là 1 tiện ích cho phép thực hiện các tác vụ như một cách tự động theo định kì, ở một chế độ nền của hệ thống.
	+ daemon: sử dụng bởi các tiến trình hện thống. demon là một chương trình hoạt động liên tục
	+ kern: các thông báo từ kernel
	+ mail: log liên quan đến hệ thống mail
	+ ftp: log liên quan đến dịch vụ ftp
	+ local 0 - local 7: log dự trữ cho sử dụng nội bộ

- Mức độ quan trọng trong file log

|Code|Mức cảnh báo|	Ý nghĩa|
|---------|--------------|---------|
|0|emerg|	Thông báo tình trạng khẩn cấp|
|1|alert|	Hệ thống cần can thiệp ngay|
|2|crit|	Tình trạng nguy kịch|
|3|error|	Thông báo lỗi đối với hệ thống|
|4|warn|	Mức cảnh báo đối với hệ thống|
|5|notice|	Chú ý đối với hệ thống|
|6|info|	Thông tin của hệ thống|
|7|debug|	Quá trình kiểm tra hệ thống|

## 3. Syslog và Rsyslog

### 3.1 Giới thiệu về Syslog

Syslog là một giao thức client/server là giao thức dùng để chuyển log và thông điệp đến máy nhận log. Máy nhận log thường được gọi là syslogd, syslog daemon hoặc syslog server. Syslog có thể gửi qua UDP hoặc TCP. Các dữ liệu được gửi dạng cleartext. Syslog dùng cổng 514.

Syslog được phát triển năm 1980 bởi Eric Allman, nó là một phần của dự án Sendmail, và ban đầu chỉ được sử dụng duy nhất cho Sendmail. Nó đã thể hiện giá trị của mình và các ứng dụng khác cũng bắt đầu sử dụng nó. Syslog hiện nay trở thành giải pháp khai thác log tiêu chuẩn trên Unix-Linux cũng như trên hàng loạt các hệ điều hành khác và thường được tìm thấy trong các thiết bị mạng như router Trong năm 2009, Internet Engineering Task Forec (IETF) đưa ra chuẩn syslog trong RFC 5424

Syslog ban đầu sử dụng UDP, điều này là không đảm bảo cho việc truyền tin. Tuy nhiên sau đó IETF đã ban hành RFC 3195 Reliable Delivery for syslog - đảm bảo tin cậy cho syslog và RFC 6587 Transmission of Syslog Messages over TCP - Truyền tải thông báo syslog qua TCP. Điều này có nghĩa là ngoài UDP thì giờ đây syslog cũng đã sử dụng TCP để đảm bảo an toàn cho quá trình truyền tin.

Trong chuẩn syslog, mỗi thông báo đều được dán nhãn và được gán các mức độ nghiêm trọng khác nhau. Các loại phần mềm sau có thể sinh ra thông báo: auth , authPriv , daemon , cron , ftp , dhcp , kern , mail, syslog, user, ... Với các mức độ nghiêm trọng từ cao nhất trở xuống Emergency, Alert, Critical, Error, Warning, Notice, Info, and Debug.

#### Định dạng chung của một gói tin syslog

Độ dài một thông báo không được vượt quá 1024 bytes

- PRI

Phần PRI là một số được đặt trong ngoặc nhọn, thể hiện cơ sở sinh ra log hoặc mức độ
nghiêm trọng. là 1 số 8bit. 3 bit đầu tiên thể hiện cho tính nghiêm trọng của thông báo.5
bit còn lại đại diện cho sơ sở sinh ra thông báo.

Giá trị Priority được tính như sau: Cơ sở sinh ra log x 8 + Mức độ nghiêm trọng. Ví dụ,
thông báo từ kernel (Facility = 0) với mức độ nghiêm trọng (Severity =0) thì giá trị
Priority = 0x8 +0 = 0. Trường hợp khác,với "local use 4" (Facility =20) mức độ nghiêm
trọng (Severity =5) thì số Priority là 20 x 8 + 5 = 165.

Vậy biết một số Priority thì làm thế nào để biết nguồn sinh log và mức độ nghiêm trọng
của nó. Ta xét 1 ví dụ sau:

Priority = 191 Lấy 191:8 = 23.875 -> Facility = 23 ("local 7") -> Severity = 191 - (23 * 8 ) = 7 (debug)

- HEADER

Phần Header thì gồm các phần chính sau

- Time stamp 

Thời gian mà thông báo được tạo ra. Thời gian này được lấy từ thời gian hệ thống ( Chú ý nếu như thời gian của server và thời gian của client khác nhau thì thông báo ghi trên log được gửi lên server là thời gian của máy client)

- Hostname hoặc IP

- Message

Phần MSG chứa một số thông tin về quá trình tạo ra thông điệp đó. Gồm 2 phần chính

- Tag field

- Content field

Tag field là tên chương trình tạo ra thông báo. Content field chứa các chi tiết của thông báo

### 2.2 Rsyslog

Rsyslog - "The rocket-fast system for log processing" được bắt đầu phát triển từ năm 2004 bởi Rainer Gerhards rsyslog là một phần mềm mã nguồn mở sử dụng trên Linux dùng để chuyển tiếp các log message đến một địa chỉ trên mạng (log receiver, log server) Nó thực hiện giao thức syslog cơ bản, đặc biệt là sử dụng TCP cho việc truyền tải log từ client tới server. Hiện nay rsyslog là phần mềm được cài đặt sẵn trên hầu hết hệ thống Unix và các bản phân phối của Linux như : Fedora, openSUSE, Debian, Ubuntu, Red Hat Enterprise Linux, FreeBSD…

## File log trong centos7

- /var/log/auth.log: Lưu các log về xác thực

- /var/log/boot.log : Log các hoạt động trong quá trình khởi động hệ thống

- /var/log/cron: Log lưu các lịch hoạt động tự động

- /var/log/dmesg : Giống log message bên dưới nhưng chủ yếu là log bộ đệm

- /var/log/message: Log lưu thông tin chung của hệ thống

- /var/log/httpd/: Thư mục chứa log của dịch vụ Apache

- /var/log/maillog: Các log hoạt động mail trên máy chủ

- /var/log/secure: Log bảo mật

- /var/log/wtmp  : Ghi log đăng nhập

- /var/log/yum.log: Các log của Yum

## Tài liệu tham khảo 

- http://en.wikipedia.org/wiki/Syslog
- http://en.wikipedia.org/wiki/Rsyslog
- https://mangmaytinh.net/threads/tim-hieu-ve-log-files-trong-linux.138/


