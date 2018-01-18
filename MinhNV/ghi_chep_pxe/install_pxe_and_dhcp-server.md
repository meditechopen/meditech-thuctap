## Hướng dẫn cài đặt PXE Server trên CentOS 7

### Menu

- [1. Giới thiệu](#1)
- [2. Chuẩn bị](#2)
- [3. Các bước cài đặt](#3)
	- [3.1 Cài đặt SysLinux Bootloader](#31)
	- [3.2 Cài đặt và cấu hình TFTP](#32)
	- [3.3 Cài đặt và cấu hình Apache - HTTPD](#33)
	- [3.4 Cấu hình PXE Boot Server](#34)
	- [3.5 Cài đặt và cấu hình DHCP](#35)
- [4. Tham khảo](#4)

<a name="1" />
	
### 1. Giới thiệu

PXE - **Preboot eXecution Environment** là một kỹ thuật cho phép chạy hoặc cài đặt OS từ card mạng NIC (có hỗ trợ PXE-enabled) mà không cần sử dụng đến CD/DVD hoặc các thiết bị ngoại vi (USB,...) truyền thống. Sau khi xây dựng một PXE server, chúng ta có thể cài OS đồng thời trên các Server khác nhau.

<a name="2" />

### 2. Chuẩn bị

- **Mô hình triển khai**

<img width="70%" src="https://i.imgur.com/B4hjS5E.png" />


- Trên máy Server:

	- IP: 192.168.100.135 và 172.16.2.12
	- Tắt SELinux
	- Tắt Firewalld hoặc iptables
	- Một file ISO image `CentOS-7-x86_64-Minimal-1611.iso`

- Trên máy dhcp server

	- IP: 192.168.100.44 và 172.16.2.254

<a name="3" />

### 3. Các bước cài đặt

<a name="31" />

#### 3.1 Cài đặt SysLinux Bootloader

```
yum install -y syslinux
```

Trong kỹ thuật PXE, chúng ta cài SysLinux để lấy một số file cần thiết cho việc hỗ trợ boot như `pxelinux.0, menu.c32, memdisk,...`

<a name="32" />

#### 3.2 Cài đặt và cấu hình TFTP

- **Bước 1:** Cài đặt TFTP

```
yum install -y tftp-server xinetd
```

Trong kỹ thuật này, TFTP cho phép client lấy file cần thiết cho việc hỗ trợ boot như `pxelinux.0, menu.c32, memdisk,...` mà không cần phải xác thực.

- **Bước 2:** Cấu hình TFTP

	- Cho phép TFTP hoạt động
	
	Chúng ta sửa file cấu hình ở `xinetd` như sau:
	
	```
	vi /etc/xinetd.d/tftp
	```

	Sửa dòng **“disable=yes”** thành “no”:
	
	<img src="/images/tftp.png" />
	
	- Khởi động lại `xinetd`:
	
	```
	systemctl restart xinetd
	systemctl enable xinetd
	```
	
<a name="33" />

#### 3.3 Cài đặt và cấu hình Apache - HTTPD

- **Bước 1:** Cài đặt HTTPD

	HTTPD làm nhiệm vụ như một Mirror chứa các file cài đặt OS, client sẽ truy cập vào mirror local này mà không phải đi ra ngoài Internet để lấy file.
	
	```
	yum install -y httpd
	```
	
- **Bước 2:** Cấu hình HTTPD

	Tạo folder chứa các images:
	
	```
	mkdir /var/lib/tftpboot/images
	chmod -R 755 /var/lib/tftpboot/images
	```
	
	Thêm alias trên HTTPD, cho phép truy cập vào folder trên
	
	```
	vi /etc/httpd/conf.d/pxeboot.conf
	```
	
	```
	Alias /images "/var/lib/tftpboot/images/"
	<Directory "/var/lib/tftpboot/images">
	Options Indexes FollowSymLinks
	Require all granted
	</Directory>
	```

- **Bước 3:** Khởi động HTTPD
	
```
systemctl restart httpd 
systemctl enable httpd 
```

<a name="34" />

#### 3.4 Cấu hình PXE Boot Server

- **Bước 1:** Copy các file boot vào thư mục TFTP

	Như đã nói ở trên, SysLinux sẽ sinh ra một số file hỗ trợ việc boot. Chúng ta vào thư mục của nó và copy các file cần thiết.
	
	```
	cd /usr/share/syslinux/
	cp pxelinux.0 menu.c32 memdisk mboot.c32 chain.c32 /var/lib/tftpboot/
	```
	
- **Bước 2:** Mount và cấu hình cho images

	Như đã liệt kê ở bước chuẩn bị, chúng ta sử dụng `CentOS-7-x86_64-Minimal-1611.iso` để cài đặt cho các client.
	
	- Tạo thư mục để mount images
	
	```
	mkdir /var/lib/tftpboot/images/centos7_x64
	```
	
	Di chuyển đến nơi lưu trữ image và mount nó vào thư mục `centos7_x64`. Trong ví dụ, image được chứa trong `/opt`.
	Chúng ta thêm dòng sau vào file `/etc/fstab`
	
	```
	...
	/opt/CentOS-7-x86_64-Minimal-1611.iso /var/lib/tftpboot/images/centos7_x64 iso9660 loop 0 0
	```
	
	Sử dụng lệnh, để reload lại `/etc/fstab`
	
	```
	mount -a
	```
	
	PS: Kiểm tra lại thư mục `/var/lib/tftpboot/images/centos7_x64`. Trong trường hợp chưa nhận dữ liệu, chúng ta phải reboot hệ thống.
	
- **Bước 3:** Tạo file cấu hình cho PXE-Server
	
	- Tạo thư mục chứa file cấu hình

	```
	mkdir /var/lib/tftpboot/pxelinux.cfg
	```
	
	- Tạo 1 file cấu hình mặc định bên trong folder với nội dung bên dưới
	
	```
	vi /var/lib/tftpboot/pxelinux.cfg/default
	```
	
	```
	default menu.c32
	prompt 0
	timeout 300
	ONTIMEOUT local

	menu title ########## PXE Boot Menu ##########

	label 1
	menu label ^1) Install CentOS 7
	kernel images/centos7_x64/images/pxeboot/vmlinuz
	append initrd=images/centos7_x64/images/pxeboot/initrd.img method=http://172.16.2.12/images/centos7_x64 devfs=nomount
	```
	
	Lưu lại file và thoát.
	
<a name="35" />

#### 3.5 Cài đặt và cấu hình DHCP

Trong kỹ thuật PXE, DHCP có vai trò làm nhiệm vụ cấp IP cho máy client và thông tin về TFTP và file boot.

- **Bước 1:** Cài đặt DHCP

```
yum install -y dhcp
```

- **Bước 2:** Cấu hình DHCP

	- Cấp DHCP trên card `eth1`
	
	Chúng ta sửa file `vi /etc/sysconfig/dhcpd`, với nội dung
	
	```
	DHCPDARGS="eth1"
	```
	
	Lưu lại và thoát.
	
	- Cấu hình cấp dải IP `172.16.2.0/24` trên `eth1`
	
		- Backup file cấu hình
		
		```
		mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bk
		```
		
		- Tạo file cấu hình mới và thêm thông tin
		
		```
		vi /etc/dhcp/dhcpd.conf
		```
		
		```
		# default lease time
		default-lease-time 600;
		# max lease time
		max-lease-time 7200;
		# this DHCP server to be declared valid
		authoritative;
		# specify network address and subnet mask
		subnet 172.16.2.0 netmask 255.255.255.0 {
		# specify the range of lease IP address
		range dynamic-bootp 172.16.2.200 172.16.2.254;
		# specify broadcast address
		option broadcast-address 172.16.2.255;
		# specify default gateway
		option routers 172.16.2.254;
		}
		allow booting;
		allow bootp;
		option option-128 code 128 = string;
		option option-129 code 129 = text;
		next-server 172.16.2.12;
		filename "pxelinux.0";
		```

Cấu hình phần next-server trỏ IP về pxe server

- **Bước 3:** Khởi động DHCP

```
systemctl restart dhcpd
systemctl enable dhcpd
```

<a name="36" />

#### 3.6 Cấu hình trên Client

Trong bài Lab này, chúng tôi sử dụng VirtualBox.

Tạo một máy ảo trên VirtualBox, sử dụng 1 card mạng LAN dùng chung với máy PXE server bên trên.

- Card mạng LAN với Server PXE:

<img src="https://github.com/hoangdh/ghichep-PXE/raw/master/images/client1.png" />

- Boot từ card mạng:

<img src="https://github.com/hoangdh/ghichep-PXE/raw/master/images/client2.png" />

- Sau khi boot xong:

<img src="https://github.com/hoangdh/ghichep-PXE/raw/master/images/client3.png" />

- Chọn OS mà bạn muốn cài đặt (Nếu có nhiều)

<img src="https://github.com/hoangdh/ghichep-PXE/raw/master/images/client4.png" />

- Cài đặt OS như sử dụng DVD/CD hoặc USB-Boot

<img src="/images/client5.png" />

<a name="4" />

### 4. Tham khảo:

- https://www.tecmint.com/install-pxe-network-boot-server-in-centos-7/


