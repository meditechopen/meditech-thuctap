# Mục lục
- [ Sử dụng virt-manager](#sudụng)
- [ Tạo máy ảo bằng virt-manager](#caidat)
- [ Cài đặt network cho máy ảo](#network)
- [ Tài liệu tham khảo](#tailieu)

# Cách sử dụng Virt Manager để quản lý máy ảo.
<a name=sudung></a>
# 1. Dùng virt manager để tạo ra máy ảo
Ở đây chúng ta dùng putty để ssh vào máy server đã cài đặt sẵn KVM. Vì vậy:

- Máy server cài KVM và Linux Brigde 
- Máy client cần cài đặt putty ( cần có X11)

## Bước 1: Kích hoạt X11 trong putty ở máy client
Khởi động putty và cấu hình để kích hoạt X11 phía client theo hình các thao tác: Connection => SSH => X11.

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/687474703a2f2f692e696d6775722e636f6d2f634e32394c377a2e706e67.png?raw=true">

## Bước 2: Thực hiện nhập IP của máy chủ Ubuntu vào mục Secssion trong putty.

**Note: Login với tài khoản root (lưu ý, tính năng cho phép ssh bằng root phải được kích hoạt trước) và gõ lệnh dưới để khởi động công cụ quản lý KVM**

- Trên máy server cài KVM. Cấu hình file sshd_config 

``sudo vi /etc/ssh/sshd_config``

- Chúng ta tìm đến 2 dòng chỉnh sửa như sau
 
```sh 
PermitRootLogin yes
PasswordAuthentication yes
```
- Lưu và khởi động ssh 

``service ssh restart`` 

- Trở lại putty trên máy client và đăng nhập 

## Bước 3: Sử dụng lệnh để mở virt manager

``virt-manager``

Sau khi sử dụng lệnh để gọi virt manager trên máy client hiển thị lên màn hình

<a name=caidat></a>
## Bước 4: Dùng virt-manager để tạo máy ảo.

- Ở đây, mình tạo máy ảo từ file iso

### Bước 4.1 Chọn New và nhập tên máy ảo

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/new.PNG?raw=true">

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/Capture.PNG?raw=true">

Chọn Forward để sang bước tiếp.

### Bước 4.2 Chọn đường dẫn đến thư mục chứa file iso.

chọn Browse để tìm đến file iso có sẵn

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/Capture1.PNG?raw=true">

chọn file iso

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/Capture2.PNG?raw=true">

### Bước 4.3 Chọn CPUs và bộ nhớ RAM
<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/Capture3.PNG?raw=true">


### Bước 4.4 Chọn dung lượng bộ nhớ đĩa cho máy ảo 

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/687474703a2f2f692e696d6775722e636f6d2f68566845517a642e706e67.png?raw=true">

### Bước 4.5 Thiết lập các tùy chọn khác 

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/Capture5.PNG?raw=true">

- Lựa chọn vào mục Customize configuration before install

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/Capture6.PNG?raw=true">



- Chọn vào Advance Options để quan sát card mạng cho máy ảo, trong hướng dẫn này sử dụng card Bridge là br0. Lúc này máy ảo sẽ nhận IP cùng với card mạng đã được bridge (xem thêm tài liệu về linux bridge)

- Chọn Finish

### Bước 4..6 Chọn begin Installation để bắt đầu khởi động máy ảo.

### Bước 4.7 Màn hình console của máy ảo xuất hiện. Ta bắt đầu cài hệ điều hành cho máy ảo 

Tham khảo cài cách cài đặt <a href="https://github.com/nguyenminh12051997/MediTech/blob/master/install_ubuntu_server.md">Ubuntu14.04</a>


<a name=network></a>
## 2. Các tùy chọn network cho máy ảo. 
Có 3 tùy chọn network cho máy ảo
- [brigde public](#pub)
- [NAT](#nat)
- [bridge private](#pri)


<a name=pub></a>
### 2.1 Cài đặt brigde public cho máy ảo

Kịch bản: 

- Sử dụng Linux brigde đã cấu hình trên KVM có địa chỉ IP là 192.168.100.30

- Tạo ra 1 máy ảo có tên vm02 bằng virt manager

- Trong tùy chọn Details của màn hình console vm02 chon NIC

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/brigdepub.PNG?raw=true">

- Gán card mạng của máy ảo với bridge có tên là br0

- Chọn apply

- Vào máy ảo kiểm tra địa chỉ IP thì thấy cùng dải mạng với máy vật lý cài KVM

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/bridgeip.PNG?raw=true">

- Dùng lệnh mtr để show đường đi internet

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/bridgemtr.PNG?raw=true">


<a name=nat></a>
### 2.2 Sử dụng NAT được cấu hình sẵn trong network default

Kịch bản
- Tạo ra vm01 bằng virt manager 

- Trong tùy chọn Details  của màn hình console vm01 chon NIC

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/nattt.PNG?raw=true">

- Gán card mạng của máy ảo với virtual network default: NAT

- Chúng ta có thể xem dải mạng mà virtual network default cấp cho máy ảo bằng cách trên máy KVM sử dụng lệnh 

``` cat /var/lib/libvirt/network/default```

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/natdhcp.PNG?raw=true">

- Vào máy ảo kiểm tra địa chỉ ip để kiểm chứng

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/natip.PNG?raw=true">


- Dùng lệnh mtr để xem đường đi internet của máy ảo 

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/bridgemtr.PNG?raw=true">


<a name=pri></a>
### 2.3 Sử dụng brigde private để tạo mạng riêng cho các máy ảo 

Kịch bản
- Tạo 1 virtual network sử dụng dải mạng private là 10.10.10.0/24

- Tạo ra 2 máy ảo vm03 và vm04 bằng virt manager gán card mạng của 2 máy vào virtual network vừa tạo

**Tạo 1 virtual network** 

- Chọn Edit => connection details => virtual networks 

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/hostonly.png?raw=true">

- Chọn biểu tượng dấu cộng 

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/hostonly1.PNG">

- Chọn tên network muốn tạo mới 

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/hostonly2.PNG?raw=true">

- Chọn địa chỉ IP

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/hostonly3.PNG?raw=true">

- Chọn ``isolated virtual network``

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/hostonly4.PNG?raw=true">

- Chọn finish

- Ở đây mình tạo ra 2 máy ở vm03 và vm04 gán vào virtual network vừa tạo lần lượt với địa chỉ ip là 10.10.10.11 và 10.10.10.12

- Ping giữa máy vm03 và vm04

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/hostonly5.PNG?raw=true">

<a name=tailieu></a>
## Tài liệu tham khảo 
- https://github.com/hocchudong/KVM-QEMU
- https://www.ibm.com/support/knowledgecenter/linuxonibm/liaag/wkvm/wkvm_c_net_nat.htm
- http://serverfault.com/questions/775433/virtual-nics-and-host-only-adapter-in-kvm
