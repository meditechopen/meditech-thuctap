#      **Chi tiết về SSH và OpenSSH**
===================================
# Mục lục
## [I. Tổng quan về SSH](#tq)
### [1.1 Thế nào là SSH](#tqssh)
### [1.2 Thế nào là openSSH](#tqopen)
### [1.3 SSH Server](#tqserver)
### [1.4 SSH Clients](#tqclient)
### [1.5 Các phiên bản SSH](#tqpbssh)
## [II. Mã hóa , thuật toán và khóa trong SSH](#mhttk)
### [2.1 Mã hóa](#mh)
### [2.2 Thuật toán](#tt)
## [III. OpenSHH Server ](#openserver)
### [3.1 File cấu hình](#31)




====================================


<a name=tq></a>
## I. Tổng quan về OpenSSH
  Trong vòng 10 năm trở lại đây OpenSSH trở thành một tiêu chuẩn công cụ cho việc điều khiển từ xa các hệ điều hành Unix cũng như các hệ thống và các thiết bị mạng khác.

<a name=tqssh></a>
### 1.1 Thế nào là SSH

  SSH (Secure Shell) là một giao thức với mục đích tạo ra một kênh giao tiếp mã hóa giữa hai thiết bị mạng với nhau.SSH bảo vệ dữ liệu giữa hai thiết bị , vì thế những người khác không thể can thiệp vào nó.Tatu Ylönen đã tạo ra phương thức này đầu tiên và triển khai no vào năm 1995.Nó nhanh chóng được mở rộng ra và dần dần thay thế các phương thức bao mật khác như Telnet, RSH, RLogin,....Ngày nay, nhiều gói phần mềm dựa trên giao thức SSH để bảo mật và xác thực trong việc vận chuyển dữ liệu cá nhân, công khai và các đường mạng bí mật.

<a name=tqopen></a>
### 1.2 Thế nào là openSSH

  OpenSSH là một chương trình mã nguồn mở (Open Source) được sử dụng để mã hoá (encrypt) các giao dịch giữa các host với nhau bằng cách sử dụng Secure Shell (SSH). Bởi nó luôn luôn mã hoá (encrypt) tất cả các giao dịch, ẩn đi, che dấu username và password được sử dụng cho những phiên đăng nhập từ xa. Sau khi phiên đăng nhập được thực hiện, nó sẽ tiếp tục mã hoá (encrypt) tất cả những dữ liệu giao dịch giữa 2 host.

  OpenSSH được phát triển tự một dự án của OpenBSD .Nó dựa trên đầy đủ các tiêu chuẩn của SSH trên Linux và BSD. Vì thế nó được sử ụng trong nhiều sản phẩm công nghệ của các hãng điện tử lớn như HP, Cisco, Oracle, Novell, Dell, Juniper, IBM và nhiều hơn nữa.

  OpenSSH bắt đầu từ 2 phiên bản : OpenBSD và Portable OpenSSH .

<a name=tqserver></a>
### 1.3 SSH Server

  Là một máy chủ SSH trong mạng phục vụ các yêu cầu SSH đến. Xác thực các yêu cầu và cung cấp các câu lệnh quản lý hệ thống ( hoặc các dịch vụ khác nếu bạn cấu hình ). Nơi tập trung tất cả về  của SSH là **sshd**.

<a name=tqclient></a>
### 1.4 SSH Clients

  Bạn có thể dùng SSH client để kết nối đến các máy chủ hoặc các thiết bị mạng từ xa. Công cụ SSH client thông dụng nhất của Windows là PuTTY cũng giống như ssh trên các máy Unix từ Openssh Client.Khách hàng có thể chọn lựa bản thương mại hoặc có phí.

<a name=tqpb></a>
### 1.5 Các phiên bản SSH

  SSH có 2 phiên bản là SSH-1(version 1) và SSH-2 (version 2). SSH càng ngày càng phổ biến thì sẽ có nhiều người muốn tấn công nó.

  SSH-1 rất dễ bị tấn công mặc dù nó sẽ mã hóa dữ liệu và ngăn chặn tấn công như bình thường.Nhưng với phương thức này, kẻ tấn công có thể nghe lén và sao chép dữ liệu. Lời khuyên từ các chuyên gia : **Đừng sử dụng SSH-1**.

  SSH-2 là tiêu chuẩn hiện đại. Không có vấn đề bảo mật nào xảy ra với các giao thức .Được thiết kế xử lý các lỗ hổng một cách nhanh chóng.Tăng độ tính toán, làm cho các cuộc tấn công không còn khả thi nữa.

<a name=mhttk></a>
## II. Mã hóa, Thuật toán và Khóa.

  Mã hóa là việc chuyển đổi một văn bản thuần túy thành các bản mã không thể đọc được.
  Giải mã thì ngược lại, từ những bản mã chuyển đổi thành một văn bản đọc được.

  Việc chuyển đổi giữa mã hóa và giải mã đều dựa trên các thuật toán, áp dụng thêm khóa mã hóa dùng để mã hóa và khóa giải mã dùng để giải mã dữ liệu.

<a name=mh></a>
### 2.1 Mã hóa

Có 2 cách để mã hóa dữ liệu :
- Mã hóa đối xứng : ở phương thức mã hóa này, khóa mã hóa và khóa giải mã là một. Chính vì điều đó nên nếu kẻ tấn công biết được key mã hóa thì dễ dàng giải mã được dữ liệu. Điều này bắt buộc phải có một kênh an toàn để trao đổi khóa giữa bên mã hóa và bên giải mã.Việc này mang lại lợi ích là việc mã hóa và giải mã diễn ra một các nhanh chóng.
- Mã hóa bất đối xứng : Mỗi bên có một cặp khóa( khóa bí mật và khóa công khai) khi muốn gửi một dữ liệu đến một bên nào thì sử dụng khóa công khai của bên đó để mã hóa dữ liệu, khi nhận được bản mã, bên nhận sẽ sử dụng khóa bí mật để giải mã tài liệu.Ở phương thức này khóa bí mật và khóa công khai có mối quan hệ thuật toán phức tạp với nhau. Nên khi biết được khóa công khai thì rất khó tìm được khóa bí mật.Phương pháp này mang lại tính bảo mật cao,tuy nhiên tốc độ giải mã chậm.

  Sở dĩ tại sao mình nói kỹ về 2 phương pháp trên vì SSH sử dụng kết hợp cả 2 phương pháp đó.SSH sử dụng 2 lần xác thực.

  Đầu tiên Client sẽ sử dụng mã khóa công khai của Server để yêu cầu đăng nhập,Server sẽ dùng khóa bí mật để giải mã,nếu đúng thì cho phép truy cập, quá trình này được sử dụng nhằm tạo kênh an toàn để trao đổi khóa đối xứng.

  Sau khi xác thực tạo kênh an toàn, SSH server sẽ yêu cầu xác thực thêm một cặp khóa nữa,Client nhận được khóa qua kênh an toàn đã tạo trước đó, khóa này là khóa đối xứng để xác nhận bắt đầu được phép truy cập vào hệ thống cũng như được sử dụng các phương thức toàn vẹn hệ thống.

  Nếu phiên kết nối chạy trong một thời gian dài thì các cặp khóa liên tục được trao đổi với nhau để đảm bảo phiên đăng nhập được liên tục.

  SSH hỗ trợ nhiều thuật toán mã hóa đối xứng và bất đối xứng.Các thuật toán tương thích lẫn nhau ở mọi kết nối. Mặc dù OpenSSH cung cấp các tùy chọn để dễ dàng thay đổi các thuật toán được hỗ trợ và sở thích đối với mỗi người quản trị.Nhưng nếu không hiểu biết sâu thì đừng nên thay đổi.

<a name=opensshserver></a>
## III. OpenSSH Server

<a name=31></a>
### 3.1 File cấu hình

  Chỉnh sửa file cấu hình của SSH trong thư mục `/etc/ssh/sshd_config` nếu chúng ta cần thay đổi hoặc thêm một số tùy chọn :

```
# This is ssh server systemwide configuration file.

         Port 22
         ListenAddress 0.0.0.0
         HostKey /etc/ssh/ssh_host_key
         ServerKeyBits 1024
         LoginGraceTime 600
         KeyRegenerationInterval 3600
         PermitRootLogin no
         IgnoreRhosts yes
         IgnoreUserKnownHosts yes
         StrictModes yes
         X11Forwarding no
         PrintMotd yes
         SyslogFacility AUTH
         LogLevel INFO
         RhostsAuthentication no
         RhostsRSAAuthentication no
         RSAAuthentication yes
         PasswordAuthentication yes
         PermitEmptyPasswords no
         AllowUsers admin
```

- *Port 22* : Cổng lắng nghe của dịch vụ ssh, mặc định là cổng 22.
- *ListenAddress* : Cho phép truy cập ssh từ một địa chỉ nào đó, mặc định để 0.0.0.0 nghĩa là tất cả các địa chỉ đều có thể ssh đến SSH Server.
- *Hostkey* : Các tùy chọn về Hostkey, mặc định là */etc/ssh/ssh_host_key* nơi chứa các Private key của SSH Server.
- *ServerKeyBits* : Tùy chon độ dài bit của khóa trong RSA.
- *LoginGraceTime* : Xác định khoảng thời gian (giây) máy chủ sẽ đợi tới lúc ngắt kết nối khi thực hiện đăng nhập không thành công.
- *KeyRegenerationInterval* : Chỉ định khoảng thời gian (giây) mà máy chủ đợi trước khi tự động tạo khóa.Tùy chọn này nhằm tránh trường hợp giải mã các khóa khi bị nghe lén.
- *PermitRootLogin* : Cho phép đăng nhập với quyền `root` từ xa.Mặc định trên linux sẽ là *No* .Nếu muốn đăng nhập với quyền *root* thì cần thay đổi thông số này về *Yes*.
- *IgnoreRhosts* : xác định xem các tệp rhost hoặc shosts không nên được sử dụng trong xác thực.
- *IgnoreUserKnownHosts* : Tùy chọn xác định xem nên bỏ qua các user trong $HOME/ .ssh/know trong RhostsRSAAuthentication.
- *StrictModes* : xác định xem ssh nên kiểm tra quyền của người dùng trong thư mục chính và tệp rhosts của họ trước khi chấp nhận đăng nhập. Tùy chọn này nên đê *Yes*.
- *X11Forwarding* : xác định xem chuyển tiếp X11 nên được bật hay không trên máy chủ SSH Server.
- *PrintMotd* : xác định liệu trình nền ssh nên in nội dung của tập tin `/etc/motd` khi người dùng đăng nhập tương tác. Tập tin `/etc/motd` còn được gọi là thông điệp trong ngày.
- *SyslogFacility* : Mã cơ sở được sử dụng trong thông báo đăng nhập của sshd.
- *LogLevel* : xác định mức độ được sử dụng trong thông báo đăng nhập của sshd.
- *RhostsAuthentication* :  xác định xem sshd có thể thử sử dụng xác thực dựa trên rhosts. Bởi vì rhosts xác thực là không an toàn, bạn không nên sử dụng tùy chọn này.
- *RhostsRSAAuthentication* : xác định xem thử xác thực rhosts trong thương lượng với xác thực máy chủ RSA.
- *RSAAuthentication* :  xác định xem thử RSA được xác thực hay không. Tùy chọn này phải được đặt thành có để bảo mật tốt hơn trong các phiên của bạn.
- *PasswordAuthentication* : chỉ định chúng ta nên sử dụng xác thực dựa trên mật khẩu hay không. Để đảm bảo an toàn, tùy chọn này luôn phải được đặt thành *Yes*.
- *PermitEmptyPasswords* : Tùy chọn này cho phép đăng nhập vào hệ thống mà không cần mật khẩu. Thường sử dụng trong các SCP tự động.
- *AllowUsers* : Xác định và kiểm soát người dùng có thể truy cập các dịch vụ ssh. 
