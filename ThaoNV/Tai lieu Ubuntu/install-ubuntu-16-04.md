# Hướng dẫn cài đặt Ubuntu Server 16.04 64 Bit trên VMWare


**Bước 1: Chọn ngôn ngữ cho Ubuntu Server**

<img src="http://i.imgur.com/ZFAYH9y.png">

**Bước 2: Chọn `Install Ubuntu Server` để bắt đầu quá trình cài đặt**

<img src="http://i.imgur.com/2jDUZhc.png">

**Bước 3: Chọn ngôn ngữ cài đặt**

<img src="http://i.imgur.com/fuidqe0.png">

**Bước 4: Chọn khu vực**

<img src="http://i.imgur.com/67G73F7.png">

**Bước 5: Chọn `No` nếu không muốn dò bàn phím và tiến hành chọn kiểu bàn phím thủ công**

<img src="http://i.imgur.com/2PYJvww.png">
**Bước 6: Chọn layout cho bàn phím**

<img src="http://i.imgur.com/Nj1fpfI.png">

<img src="http://i.imgur.com/39rjdnN.png">

**Bước 7: DHCP báo không thể cấp địa chỉ IP động, lúc này phải chọn cấu hình bằng tay. Chọn `Configure network manually`.**

<img src="http://i.imgur.com/bave4pH.png">

<img src="http://i.imgur.com/C1v5bHS.png">

**Bước 8: Cấu hình địa chỉ IP, netmask, gateway, name server(có thể để trống), hostname, domain name(có thể để trống).**

<img src="http://i.imgur.com/ZGGAmBK.png">

<img src="http://i.imgur.com/L1W8Hvk.png">

<img src="http://i.imgur.com/LUZUZPJ.png">

<img src="http://i.imgur.com/UEMp9Dn.png">

<img src="http://i.imgur.com/BW0GWYJ.png">

**Bước 9: Tạo user và password**

- Không giống một số hệ điều hành Linux khác như CentOS, Ubuntu không cho phép người dùng đặt mật khẩu và sử dụng ngay tài khoản `root`. Thay vào đó, chúng ta phải
tạo một tài khoản mới rồi sau khi cài đặt xong mới có thể dùng nó để đăng nhập sang tài khoản root. Điều này góp phần tăng tính bảo mật cho HĐH Ubuntu Server.

<img src="http://i.imgur.com/NUOJqUD.png">

<img src="http://i.imgur.com/x5LJghl.png">

<img src="http://i.imgur.com/R7zgau3.png">

Tại phần nhập password, hãy chọn `Show password in clear` nếu bạn muốn Ubuntu hiển thị những gì bạn vừa nhập.

**Bước 10: Server hỏi xem liệu người dùng có muốn mã hóa thư mục `home` không. Chọn `No` nếu không muốn.**

<img src="http://i.imgur.com/KBQBaKH.png">

**Bước 11: Chọn timezone**

<img src="http://i.imgur.com/V99hdK0.png">

**Bước 12: Phân vùng ổ cứng cho Ubuntu**

- Có 4 sự lựa chọn cho người dùng
  <ul>
  <li>Guided - use entire disk: Tự động phân vùng ổ cứng. Dùng khi ổ cứng chưa từng được phân vùng, 
  lúc này máy sẽ tự động format lại toàn bộ ổ cứng và tự động định dạng cho từng vùng đã chia.(không dùng khi máy đang có dữ liệu).</li>
  <li>Guided - use entire disk and with set up LVM: Tự động phân vùng bằng LVM. Logical Volume Manager (LVM): là phương pháp cho 
  phép ấn định không gian đĩa cứng thành những logical Volume khiến cho việc thay đổi kích thước trở nên dễ dàng hơn (so với partition). 
  Với kỹ thuật Logical Volume Manager (LVM) bạn có thể thay đổi kích thước mà không cần phải sửa lại table của OS. 
  Điều này thật hữu ích với những trường hợp bạn đã sử dụng hết phần bộ nhớ còn trống của partition và muốn mở rộng dung lượng của nó</li>
  <li>Guided - use entire disk and with set encrypted up LVM`: Tự động phân vùng ổ cứng với LVM đồng thời cài đặt mã hóa ổ cứng để tăng tính bảo mật. 
  Máy sẽ yêu cầu người sử dụng khởi tạo khóa mật khẩu sử dụng để mã hóa ổ cứng khi đăng nhập vào Ubuntu. </li>
  <li>Manual: Phân vùng thủ công. Người sử dụng sẽ phân vùng và định dạng ổ cứng bằng tay(sử dụng khi người dùng đã tạo ra phân vùng trước đó).</li>
  </ul>


- Nếu bạn muốn phân vùng thủ công, hãy chia ra hai phân vùng chính
  <ul>
  <li>Phân vùng đầu tiên có định dạng ext4, thư mục root dùng để chứa dữ liệu và hệ điều hành</li>
  <li>Phân vùng thứ 2 khoảng 1,1 GB có định dạng swap dùng làm Ram ảo cho hệ điều hành</li>
  </ul>

- Ở đây tôi chọn phân vùng tự động với LVM.

<img src="http://i.imgur.com/03IyNxc.png">

<img src="http://i.imgur.com/S8IQJu8.png">

<img src="http://i.imgur.com/Knyx3Xa.png">

<img src="http://i.imgur.com/tWrUVDf.png">

<img src="http://i.imgur.com/uqO0vHP.png">


**Bước 13: Cấu hình HTTP Proxy Server**

- Điền vào proxy, nếu không có thì để trống.

<img src="http://i.imgur.com/8XVxp5s.png">

**Bước 14: Cấu hình cập nhật**

- Có 3 sự lựa chọn 
  <ul>
  <li>No automatic update: Không tự động cập nhật</li>
  <li>Install security updates automatically: Cấu hình cho phép tự động cập nhật.</li>
  <li>Mange system with Landscape: Quản lý từ xa.</li>
  </ul>

- Tùy vào người sử dụng, ở đây tôi chọn "Không cho phép tự động cập nhật"

<img src="http://i.imgur.com/kD6Rtiq.png">

**Bước 15: Cấu hình cài đặt các phần mềm hỗ trợ**

- Ấn `Space` để chọn phần mềm bạn muốn cài thêm, Ubuntu đã tự động chọn những gói tiêu chuẩn cho hệ thống, ở đây tôi chọn cài thêm `OpenSSH Server` để có thể SSH từ xa.

<img src="http://i.imgur.com/Bu2VbJ1.png">

**Bước 16: Cài đặt boot loader (GRUB) trên ổ đĩa**

<img src="http://i.imgur.com/WRyqKYx.png">

GRUB (Grand Unified Bootloader) là một Boot loader đa dụng. Nó cho phép bạn Boot vào nhiều hệ điều hành trên cùng một Boot Drive. 
Cho nên bạn có thể cài đặt và sử dụng nhiều hệ điều hành trên cùng một ổ đĩa cứng. GRUB được sử dụng rộng rãi trên rất nhiều hệ thống UNIX.

**Bước 17: Kết thúc cài đặt và chọn `Continue` để reboot lại máy**

<img src="http://i.imgur.com/ua6CHSZ.png">

**Cách chuyển sang tài khoản root**

- Sau khi reboot lại máy, các bạn đăng nhập bằng bằng tài khoản đã tạo ở bước 9.

- Từ tài khoản vừa đăng nhập, thực hiện đặt mật khẩu cho tài khoản root bằng câu lệnh
`sudo passwd root`
- Nhập mật khẩu cho tài khoản root sau đó dùng câu lệnh `su root` để chuyển sang tài khoản root.
- Tiến hành nhập mật khẩu cho tài khoản root vừa tạo.


**Cách cấu hình để SSH từ xa**
(Chú ý: bạn phải cài dịch vụ OpenSSH Server ở bước 15)
- Đăng nhập bằng tài khoản root và thực hiện câu lệnh

`vi /etc/ssh/sshd_config`

- Sửa `PermitRootLogin` từ `without-password` thành `yes`

<img src="https://cloud.githubusercontent.com/assets/18635054/14890287/2f095802-0d8c-11e6-982f-701b00979e64.png">

Giờ đây bạn đã có thể SSH vào Ubuntu từ bên ngoài:

<img src="http://image.prntscr.com/image/b2c0f53d90d24370a1bf5bbf77c70eba.png">
<img src="http://i.imgur.com/Jo5EGcw.png">
