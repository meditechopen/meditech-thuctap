# Tìm hiểu về Nagios
----------------------------------
# Mục lục
## [I. Tổng quan về Nagios](#tongquan)
###  [1.1 Khái niệm](#khainiem)
###  [1.2 Lịch sử phát triển](#lichsu)
###  [1.3 Chức năng](#chucnang)
###  [1.4 Đặc điểm](#dacdiem)
###  [1.5 Kiến trúc và tổ chức hoạt động](#kientructochuc)
####  [1.5.1 Kiến trúc của Nagios](#kientruc)




--------------------------------------------

<a name="tongquan"></a>
# I. Tổng quan về Nagios

<a name="khainiem"></a>
## 1.1 Khái Niệm
  - Nagios là một mã nguồn mở phổ biến trên hệ thống máy tính và phần mềm ứng dụng giám sát mạng.Nagios kiểm soát máy chủ và dịch vụ, cảnh báo cho người sử dụng khi có dấu hiệu lỗi trong hệ thống.

  - Nagios là một công cụ mạnh mẽ cung cấp cho bạn nhận thức tức thời về cơ sở hạ tầng IT quan trọng của tổ chức bạn. Nagios cho phép bạn phát hiện và sửa chữa các vấn đề và giảm thểu các vấn đề trong tương lai trước khi chúng ảnh hưởng đến người dùng cuối và khách hàng.


<a name="lichsu"></a>
## 1.2 Lịch sử phát triển
  - 1996 : Ethan Galstad tạo một ứng dụng MS-DOS đơn giản được thiết kế để "ping" các máy chủ Novell Netware và gửi các trang số. Ứng dụng được thiết kế bằng cách sử dụng các ứng dụng bên thứ ba bên ngoài để thực hiện kiểm tra máy chủ và gửi các trang. Khái niệm kiến ​​trúc cơ bản sẽ được sử dụng cho Nagios được sinh ra.
  - 1998 : Ethan sử dụng những ý tưởng và kiến ​​trúc của công việc trước đây của mình để bắt đầu xây dựng một ứng dụng mới và được cải tiến để chạy dưới Linux.
  - 1999 : Ethan công bố tác phẩm của mình dưới dạng một dự án mã nguồn mở dưới cái tên "NetSaint"
  - 2002 : Ethan quyết định đổi tên dự án thành "Nagios", một từ viết tắt cho "Nagios Is not Gonna Insist On Sainthood". Dự án phát triển NetSaint Plugins được chuyển đến dự án Nagios Plugins.
  - 2005 : Nagios là dự án của Tháng được bình chọn bởi SourceForge.net (POTM) vào tháng Sáu.
  - 2006 : Nagios được đánh giá là một "công cụ phải có" trong một doanh nghiệp.
  - 2007 : Ethan đã thành lập Nagios Enterprises, LLC để cung cấp các dịch vụ tư vấn và phát triển xung quanh Nagios.
  <ul>
  <li>Nagios được bầu chọn là một trong những công cụ tốt nhất dành cho người quản trị hệ thống trong Giải thưởng Cộng đồng SourceForge.net.</li>
  <li>Nagios đoạt giải thưởng "Ứng dụng Giám sát Mạng của năm 2007 " của LinuxQuestions.org</li>
  <li>LinuxWorld.com đánh giá Nagios là một trong "5 công cụ bảo mật mã nguồn mở hàng đầu trong doanh nghiệp".</li>
  </ul>

  - 2008 :
  <ul>
  <li>Nagios làm bìa trước của tạp chí Thông tin Tuần báo mang tên "Doanh nghiệp mã nguồn mở".</li>
  <li>Nagios tiếp tục giành giải "Ứng dụng giám sát mạng của năm 2008"</li>
  <li>Nagios được tải trực tiếp từ SourceForge.net trên 500.000 lần.</li>
  </ul>
  .......
  - 2016 :
  <ul>
  <li>Nagios Core vượt quá 7.500.000 lượt tải xuống trực tiếp từ SourceForge.net </li>
  <li>Nagios giành được "Dự án Tháng" của SourceForge cho tháng 10 năm 2016.</li>
  </ul>

<a name="chucnang"></a>
## 1.3 Chức năng
  - Giám sát trạng thái hoạt động của các dịch vụ mạng (SMTP, POP3, IMAP, HTTP, ICMP, FTP, SSH, DHCP, LDAP, DNS, name server, web proxy, TCP port ,UDP port, cở sở dữ liệu: mysql, portgreSQL, oracle)
  - Giám sát các tài nguyên các máy phục vụ và các thiết bị đầu cuối (chạy hệ điều hành Unix/Linux, Windows, Novell netware): tình trạng sử dụng CPU, người dùng đang đăng nhập, tình trạng sử dụng ổ đĩa cứng, tình trạng sử dụng bộ nhớ trong và swap,số tiến trình đang chạy, các tệp log hệ thống.
  - Giám sát các thông số an toàn thiết bị phần cứng trên host như : nhiệt độ CPU, tốc độ quạt, pin, giờ, hệ thống,...
  - Giám sát các thiết bị mạng có IP như router,switch và máy in. Với Router,switch, Nagios có thể theo dõi được tình trạng hoạt động, trạng thái bật,tắt của từng cổng, lưu lượng băng thông qua mỗi cổng, thời gian hoạt động liên tục của thiết bị. Với máy in, Nagios có thể nhận biết được trạng thái, tình huống xảy ra như kẹt giấy, hết mực,...
  - Cảnh báo cho người quản trị bằng nhiều hình thức như email, tin nhắn tức thời, âm thanh,... nếu như có thiết bị hay dịch vụ gặp trục trặc.
  - Tổng hợp lưu trữ và báo cáo định kỳ về tình trạng hoạt động của mạng.

<a name="dacdiem"></a>
## 1.4 Đặc điểm của Nagios
- Các hoạt động kiểm tra được thực hiện bởi các Plugin cho máy phục vụ Nagios và các mô đun trên client trên các thiết bị của người dùng cuối.Nagios chỉ định kì nhận các thông tin từ các plugin và xử lý những thông tin đó( thông báo cho quản trị,ghi log,hiển thị web,...)
- Thiết kế plugin đơn giản cho phép người dùng có thể tự định nghĩa và phát triển các plugin kiểm tra các dịch vụ theo nhu cầu riêng bằng các công cụ lập trình như shell,scripts, C/C++,Perl,Ruby,Python,PHP,C#.
- Có khả năng kiểm tra song song trạng thái hoạt động của các dịch vụ.
- Hỗ trợ khai báo kiến trúc mạng.Nagios không có khả năng nhận dạng được kiến trúc của mạng, toàn bộ các thiết bị, dịch vụ muốn được giám sát đều phải khai báo và định nghĩa trong cấu hình.
- Gửi thông báo đến từng người hoặc nhóm người được chỉ định sẵn khi host/dịch vụ được giám sát gặp vấn đề và khi chúng khôi phục hoạt động bình thường qua email,sms,...
- Giao diện web cho phép xem trạng thái của mạng, thông báo history, log,...

<a name="kientructochuc"></a>
## 1.5 Kiến trúc và tổ chức hoạt động

<a name="kientruc"></a>
### 1.5.1 Kiến trúc của Nagios
  Hệ thống Nagios gồm 2 thành phần chính :
  - Lõi Nagios
  - Các Plugin

  Phần lõi Nagios có chức năng quản lý các Host/Dịch vụ được giám sát, thu thập các kết quả kiểm tra host/dịch vụ từ các Plugin gửi về, biểu diễn trên gia diện chương trình, lưu trữ và thông báo cho người quản trị. Ngoài ra nó còn tổng hợp và đưa ra các báo cáo về tình hình hoạt động chung hoặc của từng host/dịch vụ trong một khoảng thời gian nào đó.

  Plugin là một bộ phận trực tiếp thực hiện kiểm tra host/dịch vụ. Mỗi loại dịch vị đều có một Plugin riêng biệt được viết để ohuc vụ riêng cho vông ciêc kiểm tra dịch vụ đó. Plugin là các script (Perl, C,...) hay các tệp đã được biên dịch (executable). Khi cần thực hiện kiểm tra một host/dịch vụ nào đó,Nagios chỉ việc gọi plugin tương ứng và nhận kết quả kiểm tra từ chúng. Với thiết kế như vậy, hệ thống Nagios rất dễ dàng được mở rộng và phát triển. Bất kì một thiết bị hay dich vụ nào cũng có thể được giám sát nếu như được viết plugin cho nó.

  <img src=http://i.imgur.com/t20GfIj.png>

  Hình 1 : Sự tương quan giữa các thành phần trong Nagios

<a name="tochuc"></a>
### 1.5.2 Cách thức tổ chức hoạt động.
  Nagios có 5 các thực thi các hành động kiểm tra :
  - `Kiểm tra dịch vụ trực tiếp` : đối với dịch vụ mạng có các giao thức giao tiếp như SMTP,FTP,HTTP,.. thì Nagios có thể tiến hành kiểm tra trực tiếp một dịch vu xem nó có hoạt động hay không bằng cách gửi truy vấn kết nói dịch vu đến server dịch vụ và chờ kết quả trả về. Các plugin phục vụ kiểm tra được đặt ngay trên server Nagios.
  - `Chạy các plugin trên máy ở xa bằng Secure Shell` : Nếu như không truy cập trực tiếp kết nối đến client thì phải cài plugin trên máy được giám sát, Nagios sẽ điều khiển các plugin cục bộ trên client qua Secure shell bằng plugin *check_by_ssh* .Phương pháp này yêu cầu một tài khoản truy cập host được giám sát nhưng nó có thể thực thi được tất cả các plugin trên host đó.
  - `Bộ thực thi plugin từ xa(NRPE- Nagios Remote Plugin Executor)` : NRPE là một addon đi kèm với Nagios .Nó trợ giúp việc thực thi các plugin được cài đặt trên thiết bị được giám sát. NRPE được cài đặt trên các thiết bị được giám sát.Khi nhận được truy vấn từ Nagios Server thì nó gọi các plugin cục bộ phù hợp trên host này, thực hiện kiểm tra và trả về kết của cho Nagios Server. Phương pháp này không đòi hỏi tài khoản truy cập host được giám sát như sử dụng SSH . Tuy nhiên cũng như ssh, các plugin  phải được cài đặt trên máy được giám sát. NRPE có thể thực thi tất cả các plugin giám sát.Nagios có thể diều khiển máy cài NRPE kiểm tra các thông số phần cứng, tài nguyên,... hoặc sử dụng NRPE để thực thi các plugin yêu cầu truy vấn dich vụ mạng đến một máy thứ 3 để kiểm tra hoạt động của các dịch vụ mạng như http,ftp,mail,...
  - `Giám sát qua SNMP (Simple Network Management Protocol)` : Là tập hợp các các hoạt động giúp nhà quản trị mạng có thể quản lý, thay đổi trạng thái thiết
bị. Hiện nay rất nhiều thiết bị mạng hỗ trợ giao thức SNMP như Switch, router, máy
in, firewall ... Nagios cũng có khả năng sử dụng giao thức SNMP để theo dõi trạng
thái của các client, các thiết bị mạng có hỗ trợ SNMP. Qua SNMP, Nagios có được
thông tin về tình trạng hiện thời của thiết bị. Ví dụ như với SNMP, Nagios có thể biết
được các cổng của Switch, router có mở hay không, thời gian Uptime (chạy liên tục) là
bao nhiêu...
 - `NSCA (Nagios Service Check Acceptor)` : Nagios được coi là một phần mềm rất mạnh vì nó dễ dàng được mở rộng và kết
hợp với các phần mềm khác. Nó có thể tổng hợp thông tin từ các phần mềm kiểm tra của hãng thứ ba hoặc các tiến trình Nagios khác về trạng thái của host/dịch vụ. Như
thế Nagios không cần phải lập lịch và chạy các hành động kiểm tra host/dịch vụ mà các ứng dụng khác sẽ thực hiện điểu này và báo cáo thông tin về cho nó. Và các ứng dụng kiểm tra có thể tận dụng được khả năng rất mạnh của Nagios là thông báo và tổng hợp báo cáo. Nagios sử dụng công cụ NSCA để gửi các kết quả kiểm tra từ ứng dụng của bạn về server Nagios. Công cụ này giúp cho thông tin gửi trên mạng được an toàn hơn vì nó được mã hóa và xác thực.
