# Hướng dẫn cài đặt và sử dụng Apt-Cacher-NG

### Apt-Cacher-NG là gì?

- Apt-Cacher-NG là một caching proxy server, sau khi cài đặt, nó sẽ "cache" các gói đã download từ trên internet về và đặt tại server cho những lần sử dụng sau. Nhờ vậy, các máy khác lần sau sẽ không cần phải mất thời gian tải các packages từ trên internet về nữa.

<img src="http://i.imgur.com/s0g2gDN.png">

- Lợi ích chính:
  <ul>
  <li>Tiết kiệm thời gian</li>
  <li>Tiết kiệm băng thông</li>
  <li>Người dùng có thể tích hợp dữ liệu từ file ISO hoặc DVD vào apt-cacher-ng bằng cách sử dụng tùy chọn "import"</li>
  </ul>

### Hướng dẫn cài đặt và sử dụng

#### 1. Mô hình

- Cài đặt trong môi trường ảo hóa KVM
- Máy server: 
  <ul>
  <li>Ubuntu 16.04, 1 NIC</li>
  <li>Máy server cài gói apt-caher-ng để trở thành caching proxy server</li>
  </ul>

- Máy Clients:
  <ul>
  <li>Sử dụng hệ điều hành Ubuntu và CentOS</li>
  <li>Tiến hành khai báo repos trên từng máy client</li>
  </ul>

**Phía server**

**Bước 1**

- Cài đặt apache2 bằng câu lệnh

`apt-get -y install apache2`

**Bước 2** 

- Cài đặt apt-cacher-ng bằng câu lệnh

`sudo apt-get install apt-cacher-ng`

**Bước 3** 

- Sửa file cấu hình bằng câu lệnh `vi /etc/apt-cacher-ng/acng.conf` để sử dụng cho Ubuntu

- Bỏ comment dòng 36 (Port: 3142)

<img src="http://i.imgur.com/5ttzEHh.png">

- Thêm `BindAddress: 0.0.0.0` vào dòng 48

<img src="http://i.imgur.com/ckw1Y3j.png">

- Bỏ comment dòng 101 (VerboseLog: 1)

<img src="http://i.imgur.com/mztqgyJ.png">

- Bỏ comment dòng 110

<img src="http://i.imgur.com/VTfxtf2.png">

- Bỏ comment và sử giá trị `DnsCacheSeconds` ở dòng 162 thành `2000`

<img src="http://i.imgur.com/NyN5cT8.png">

- Thêm `VfilePatternEx: ^/\?release=[0-9]+&arch=` và `VfilePatternEx: ^(/\?release=[0-9]+&arch=.*|.*/RPM-GPG-KEY-examplevendor)$` vào file cấu hình

<img src="http://i.imgur.com/SUhzQOI.png">

- Thêm `Remap-centos: file:centos_mirrors /centos` vào file cấu hình

<img src="http://i.imgur.com/rWMH53a.png">

- Tiến hành tạo mirror list bằng câu lệnh

`curl https://www.centos.org/download/full-mirrorlist.csv | sed 's/^.*"http:/http:/' | sed 's/".*$//' | grep ^http >/etc/apt-cacher-ng/centos_mirrors`

- Thêm `PassThroughPattern: .*` vào file cấu hình

<img src="http://i.imgur.com/NzZxFdC.png">

**Bước 4**

- Tiến hành restart lại dịch vụ bằng câu lệnh 

`service apt-cacher-ng restart`

- Giờ đây bạn có thể truy cập trang quản trị của apt-cacher-ng theo địa chỉ `ip_server:3142`

<img src="http://i.imgur.com/2oZkfpJ.png">

<img src="http://i.imgur.com/nU2dGYN.png">

**Phía Clients**

- Đối với những máy sử dụng hệ điều hành Ubuntu, tiến hành chạy dòng sau để khai báo repos:

`echo 'Acquire::http { Proxy "http://x.x.x.x:3142"; };' >  /etc/apt/apt.conf.d/01proxy`

- Đối với những máy sử dụng hệ điều hành CentOS: 

`echo "proxy=http://x.x.x.x:3142" >> /etc/yum.conf`

**Link tham khảo**
https://github.com/hocchudong/ghichep-repos/blob/master/ghichu-repos.md#apt-cache-ng-server
http://www.tecmint.com/apt-cache-server-in-ubuntu/
https://www.pitt-pladdy.com/blog/_20150720-132951_0100_Home_Lab_Project_apt-cacher-ng_with_CentOS/
https://blog.packagecloud.io/eng/2015/05/05/using-apt-cacher-ng-with-ssl-tls/
