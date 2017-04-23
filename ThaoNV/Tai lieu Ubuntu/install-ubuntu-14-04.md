# Cài đặt Ubuntu server 14.04-4 64 bit lên VMware worksation
## Mục lục
[I. Giới thiệu về Ubuntu server 14.04](#gioi-thieu)

[II. Cách cài ubuntu server 14.04 64 bit trên VMware](#cai-dat)

----

### <a name="gioi-thieu"></a>I. Giới thiệu về Ubuntu server 14.04
#### 1. Tổng quan chung về HĐH Ubuntu
- Ubuntu là một hệ điều hành máy tính dựa trên Debian GNU/Linux, một bản phân phối Linux thông dụng.
- Bản phát hành đầu tiên của Ubuntu là vào 20 tháng 10 năm 2004, bắt đầu bằng việc tạo ra một nhánh tạm thời của dự án Debian Linux.
- Mục đích của Ubuntu bao gồm việc cung cấp một hệ điều hành ổn định, cập nhật cho người dùng bình thường, và tập trung vào sự tiện dụng và dễ dàng cài đặt.
- Ubuntu được tài trợ bởi Canonical Ltd (chủ sở hữu là một người Nam Phi Mark Shuttleworth). Thay vì bán Ubuntu, Canonical tạo ra doanh thu bằng cách bán hỗ trợ kĩ thuật.
- Trong quá trình phát triển, dự án Ubuntu đã cho ra đời nhiều phiên bản khác nhau của Ubuntu, như Ubuntu Desktop cho máy tính để bàn, 
Ubuntu Netbook Remix cho netbook (đã ngừng phát triển), Ubuntu Server cho các máy chủ, Ubuntu Business Desktop Remix cho các doanh nghiệp, 
Ubuntu for Android và Ubuntu for Phones cho các thiết bị di động. 

#### 2. Các tính năng nổi bật

- Ubuntu là phần mềm mã nguồn mở tự do, có nghĩa là người dùng được tự do chạy, sao chép, phân phối, nghiên cứu, thay đổi và cải tiến phần mềm theo điều khoản của giấy phép GNU GPL.
- Ubuntu kết hợp những đặc điểm nổi bật chung của hệ điều hành nhân Linux, như tính bảo mật trước mọi virus và malware, khả năng tùy biến cao, tốc độ, hiệu suất làm việc, 
và những đặc điểm riêng tiêu biểu của Ubuntu như giao diện bắt mắt, bóng bẩy, cài đặt ứng dụng đơn giản, sự dễ dàng trong việc sao lưu dữ liệu và sự hỗ trợ của một cộng đồng người dùng khổng lồ.

### <a name="cai-dat"></a>II. Cách cài ubuntu server 14.04 64 bit trên VMware
#### 1. Cấu hình tối thiểu

<img src="https://cloud.githubusercontent.com/assets/18635054/14889327/87ee89c8-0d88-11e6-884a-b7dd88d35149.png">

#### 2. Các bước cài đặt

**Bước 1: Chọn ngôn ngữ cho Ubuntu Server**

<img src="https://cloud.githubusercontent.com/assets/18635054/14889350/9bdca47e-0d88-11e6-80d7-a0709f9a9c9f.png">

**Bước 2: Chọn `Install Ubuntu Server` để bắt đầu quá trình cài đặt**

<img src="https://cloud.githubusercontent.com/assets/18635054/14889352/9edd833c-0d88-11e6-9f4e-092ecd5d08d4.png">

**Bước 3: Chọn ngôn ngữ cài đặt**

<img src="https://cloud.githubusercontent.com/assets/18635054/14889472/280ab3d2-0d89-11e6-8660-b18ee207a391.png">

**Bước 4: Chọn time zone và khu vực**

<img src="https://cloud.githubusercontent.com/assets/18635054/14889477/2a66885e-0d89-11e6-9f53-364f15c55115.png">

**Bước 5: Nếu khu vực vừa chọn không tương thích với ngôn ngữ đã chọn, máy sẽ báo phải chọn lại khu vực**

<img src="https://cloud.githubusercontent.com/assets/18635054/14889514/4641a9e6-0d89-11e6-9cbc-f5b53989f84f.png">

**Bước 6: Chọn `No` nếu không muốn dò bàn phím và tiến hành chọn kiểu bàn phím thủ công**

<img src="https://cloud.githubusercontent.com/assets/18635054/14889517/4a5793ec-0d89-11e6-9aa4-13a52ca0a58f.png">

<img src="https://cloud.githubusercontent.com/assets/18635054/14889519/503d2952-0d89-11e6-9ffb-77204e3937df.png">

<img src="https://cloud.githubusercontent.com/assets/18635054/14889588/9dac6edc-0d89-11e6-95f9-602c3bb34ec1.png">

**Bước 7: DHCP báo không thể cấp địa chỉ IP động, lúc này phải chọn cấu hình bằng tay. Chọn `Configure network manually`.**

<img src="https://cloud.githubusercontent.com/assets/18635054/14889591/a4e6b2de-0d89-11e6-8cec-22df86372e78.png">

<img src="https://cloud.githubusercontent.com/assets/18635054/14889624/c6fa2ba8-0d89-11e6-9e6d-a1a99eb41d8c.png">

**Bước 8: Cấu hình địa chỉ IP, netmask, gateway, name server(có thể để trống), hostname, domain name(có thể để trống).**

<img src="https://cloud.githubusercontent.com/assets/18635054/14889629/cbc01b84-0d89-11e6-9b4c-def629ac9044.png">

<img src="https://cloud.githubusercontent.com/assets/18635054/14889652/e89e827c-0d89-11e6-8e77-d1c1f7aaf5b9.png">

<img src="https://cloud.githubusercontent.com/assets/18635054/14889673/f9864840-0d89-11e6-8804-d8fb844a5652.png">

<img src="https://cloud.githubusercontent.com/assets/18635054/14889675/fd440b84-0d89-11e6-87ca-2507df44c587.png">

<img src="https://cloud.githubusercontent.com/assets/18635054/14889683/027a05f4-0d8a-11e6-9f41-a7ec7e47eef6.png">

<img src="https://cloud.githubusercontent.com/assets/18635054/14889722/219e2d52-0d8a-11e6-8b1e-c6511c55e52c.png">

**Bước 9: Tạo user và password**

- Không giống một số hệ điều hành Linux khác như CentOS, Ubuntu không cho phép người dùng đặt mật khẩu và sử dụng ngay tài khoản `root`. Thay vào đó, chúng ta phải
tạo một tài khoản mới rồi sau khi cài đặt xong mới có thể dùng nó để đăng nhập sang tài khoản root. Điều này góp phần tăng tính bảo mật cho HĐH Ubuntu Server.

<img src="https://cloud.githubusercontent.com/assets/18635054/14889743/385c86a6-0d8a-11e6-9e86-25e2209a6764.png">

<img src="https://cloud.githubusercontent.com/assets/18635054/14889752/3ecb10f2-0d8a-11e6-93da-30b136634b9a.png">

<img src="https://cloud.githubusercontent.com/assets/18635054/14889750/3ead6f02-0d8a-11e6-8b36-2d9c56b7e601.png">

<img src="https://cloud.githubusercontent.com/assets/18635054/14889753/3edc56d2-0d8a-11e6-8e55-866d228a8cb2.png">

**Bước 10: Server hỏi xem liệu người dùng có muốn mã hóa thư mục `home` không. Chọn `No` nếu không muốn.**

<img src="https://cloud.githubusercontent.com/assets/18635054/14889789/6dbd0c08-0d8a-11e6-980b-7bfa015a4593.png">

**Bước 11: Phân vùng ổ cứng cho Ubuntu**

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

<img src="https://cloud.githubusercontent.com/assets/18635054/14890749/0dfc6d8c-0d8e-11e6-822e-3cf98535b5c9.png">

<img src="https://cloud.githubusercontent.com/assets/18635054/14890751/0e0f565e-0d8e-11e6-8032-d40af7bb35e5.png">

<img src="https://cloud.githubusercontent.com/assets/18635054/14890753/0e36de90-0d8e-11e6-9362-2a562fb652ff.png">

<img src="https://cloud.githubusercontent.com/assets/18635054/14890750/0dfdda96-0d8e-11e6-8db5-535f2d9f3278.png">

<img src="https://cloud.githubusercontent.com/assets/18635054/14890748/0df6ea10-0d8e-11e6-9bb8-5a2ededc86b5.png">


**Bước 12: Cấu hình HTTP Proxy Server**

- Điền vào proxy, nếu không có thì để trống.

<img src="https://cloud.githubusercontent.com/assets/18635054/14889924/e18ae8e4-0d8a-11e6-82e5-dd2d450b97cd.png">

**Bước 13: Cấu hình cập nhật**

- Có 3 sự lựa chọn 
  <ul>
  <li>No automatic update: Không tự động cập nhật</li>
  <li>Install security updates automatically: Cấu hình cho phép tự động cập nhật.</li>
  <li>Mange system with Landscape: Quản lý từ xa.</li>
  </ul>

- Tùy vào người sử dụng, ở đây tôi chọn "Không cho phép tự động cập nhật"

<img src="https://cloud.githubusercontent.com/assets/18635054/14889926/e2356a62-0d8a-11e6-8e73-40081927d330.png">

**Bước 14: Cấu hình cài đặt các phần mềm hỗ trợ**

- Ấn `Space` để chọn phần mềm bạn muốn cài thêm, ở đây tôi chọn cài thêm `OpenSSH Server` để có thể SSH từ xa.

<img src="https://cloud.githubusercontent.com/assets/18635054/14889928/e25f0caa-0d8a-11e6-831f-89c78d528d41.png">

**Bước 15: Cài đặt boot loader (GRUB) trên ổ đĩa**

<img src="https://cloud.githubusercontent.com/assets/18635054/14889955/fda32280-0d8a-11e6-86dc-9fac4509dbee.png">

GRUB (Grand Unified Bootloader) là một Boot loader đa dụng. Nó cho phép bạn Boot vào nhiều hệ điều hành trên cùng một Boot Drive. 
Cho nên bạn có thể cài đặt và sử dụng nhiều hệ điều hành trên cùng một ổ đĩa cứng. GRUB được sử dụng rộng rãi trên rất nhiều hệ thống UNIX.

**Bước 16: Kết thúc cài đặt và chọn `Continue` để reboot lại máy**

<img src="https://cloud.githubusercontent.com/assets/18635054/14889954/fda11c4c-0d8a-11e6-919a-b73540e70593.png">

**Cách chuyển sang tài khoản root**

- Sau khi reboot lại máy, các bạn đăng nhập bằng bằng tài khoản đã tạo ở bước 9.

<img src="https://cloud.githubusercontent.com/assets/18635054/14890047/519c6acc-0d8b-11e6-9776-eeee20f9c08b.png">

- Từ tài khoản vừa đăng nhập, thực hiện đặt mật khẩu cho tài khoản root bằng câu lệnh
`sudo passwd root`
- Nhập mật khẩu cho tài khoản root sau đó dùng câu lệnh `su root` để chuyển sang tài khoản root.
- Tiến hành nhập mật khẩu cho tài khoản root vừa tạo.

<img src="https://cloud.githubusercontent.com/assets/18635054/14890045/515c2700-0d8b-11e6-8554-253d72a0aec3.png">

**Cách cấu hình để SSH từ xa**
(Chú ý: bạn phải cài dịch vụ OpenSSH Server ở bước 14 )
- Đăng nhập bằng tài khoản root và thực hiện câu lệnh

`vi /etc/ssh/sshd_config`

- Sửa `PermitRootLogin` từ `without-password` thành `yes`

<img src="https://cloud.githubusercontent.com/assets/18635054/14890287/2f095802-0d8c-11e6-982f-701b00979e64.png">

Giờ đây bạn đã có thể SSH vào Ubuntu từ bên ngoài:

<img src="http://image.prntscr.com/image/b2c0f53d90d24370a1bf5bbf77c70eba.png">
<img src="http://i.imgur.com/Jo5EGcw.png">


