# Install cobbler on Centos7

## Mô hình

<img src="https://i.imgur.com/zspIz8f.png">

- cobbler server: 
	
	+ OS: Centos7
	+ IP: 192.168.100.44 và 172.16.2.12
	+ Đã có sẵn iso của Centos7 và Ubuntu

- local repo: 
	
	+ OS: Ubuntu 16
	+ IP: 192.168.100.136 và 172.16.2.254
	+ Cài đặt apt-cache-ng 

## Bước 1: Tải epel-release và các gói cần thiết 

```sh
yum install epel-release
yum install cobbler cobbler-web dnsmasq syslinux pykickstart xinetd dhcp -y
```

## Bước 2: Khởi động cobbler và http service

```sh
systemctl start cobblerd ; systemctl enable cobblerd
systemctl start httpd ; systemctl enable httpd
```

- Tắt selinux 

Chỉnh sửa file cấu hình 

```sh 
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/selinux/config
```

Tắt bằng lệnh 

``setenforce 0``

Reboot lại máy 

- Mở port trong firewalld 

```sh
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=443/tcp --permanent
firewall-cmd --add-service=dhcp --permanent
firewall-cmd --add-port=69/tcp --permanent
firewall-cmd --add-port=69/udp --permanent
firewall-cmd --add-port=4011/udp --permanent
firewall-cmd --reload
```

Ở đây trong môi trường lab nên mình sẽ disable và stop firewalld

## Bước 3: Truy cập vào dashbroad của cobbler

``https://<ip_server_cobbler>/cobbler_web/``

<img src="https://i.imgur.com/6ahfM7X.png">

USER và PASS mặc định là cobbler/cobbler

## Bước 4: Cấu hình cobbler

- Lấy doạn mã hóa password root

``openssl passwd -1``

Nhập password vào sau đó sẽ gen ra một đoạn mã. Lưu nó lại để sử dụng cho bước sau 

- Chỉnh sửa file setting như sau 

```sh
vi /etc/cobbler/settings
-------------------------------------------------------
default_password_crypted: "doan_ma_ban_vua_gen"
manage_dhcp: 1
manage_dns: 1
pxe_just_once: 1
next_server: 172.16.2.12
server: 172.16.2.12
--------------------------------------------------------
```

- Chỉnh sửa 2 file dhcp.template và dnsmasq.template

```sh
vi /etc/cobbler/dhcp.template
-----------------------------------------------
subnet 172.16.2.12  netmask 255.255.255.0 {
     option routers             172.16.2.12;
     option domain-name-servers 172.16.2.12;
     option subnet-mask         255.255.255.0;
     range dynamic-bootp        172.16.2.10 172.16.2.20;
     default-lease-time         21700;
     max-lease-time             43100;
     next-server                $next_server;

     class "pxeclients" {
          match if substring (option vendor-class-identifier, 0, 9) = "PXEClient";
          if option pxe-system-type = 00:02 {
                  filename "ia64/elilo.efi";
          } else if option pxe-system-type = 00:06 {
                  filename "grub/grub-x86.efi";
          } else if option pxe-system-type = 00:07 {
                  filename "grub/grub-x86_64.efi";
          } else {
                  filename "pxelinux.0";
          }
     } 
}
--------------------------------------------
```

```sh
vi /etc/cobbler/dnsmasq.template
--------------------------------------------
dhcp-range=172.16.2.10 172.16.2.20
--------------------------------------------
```

- Khởi động lại cobbler và kiểm tra 

```sh
systemctl restart cobblerd
systemctl restart xinetd ; systemctl enable xinetd
cobbler check
```

- Sau đó sẽ hiển thị "Things You Might Want To Fix:"

Mình đã tìm hiểu và note lại một số câu lệnh để fix các lỗi trên

```sh
cobbler get-loaders
systemctl enable rsyncd.service
systemctl restart rsyncd.service
yum -y install debmirror pykickstart
	comment out 'dists' on /etc/debmirror.conf for proper debian support
	comment out 'arches' on /etc/debmirror.conf for proper debian support
yum install fence-agents-all -y
vi /etc/xinetd.d/tftp 
	server_args             = -s /var/lib/tftpboot
```

- Mount file iso

  + Đối với Centos
  
```sh
mkdir  /mnt/iso
mount -o loop CentOS-7-x86_64-Minimal-1611.iso  /mnt/iso/
cobbler import --arch=x86_64 --path=/mnt/iso --name=CentOS7
```

  + Đối với Ubuntu

```sh
mkdir  /mnt/iso2
mount -o loop ubuntu-16.04.3-server-amd64.iso /mnt/iso2/
cobbler import --arch=x86_64 --path=/mnt/iso2 --name=Ubuntu16
```

## Bước 5: Kiểm tra lại danh sách distro

- Bằng CLI:

``cobbler distro list``

- Xem trên web

<img src="https://i.imgur.com/DIkZQS4.png">

## Bước 6: Tạo file kickstart

```sh
vi /var/lib/cobbler/kickstarts/CentOS7.ks

#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Firewall configuration
firewall --disabled
# Install OS instead of upgrade
install
# Use HTTP installation media
url --url="http://172.16.2.12/cblr/links/CentOS7-x86_64/"

# Root password
rootpw --iscrypted $1$j9/aR8Et$uovwBsGM.cLGcwR.Nf7Qq0

# Network information
network --bootproto=dhcp --device=eth0 --onboot=on

# Reboot after installation
reboot

# System authorization information
auth useshadow passalgo=sha512

# Use graphical install
graphical

firstboot disable

# System keyboard
keyboard us

# System language
lang en_US

# SELinux configuration
selinux disabled

# Installation logging level
logging level=info

# System timezone
timezone Europe/Amsterdam

# System bootloader configuration
bootloader location=mbr

clearpart --all --initlabel
part swap --asprimary --fstype="swap" --size=1024
part /boot --fstype xfs --size=500
part pv.01 --size=1 --grow
volgroup root_vg01 pv.01
logvol / --fstype xfs --name=lv_01 --vgname=root_vg01 --size=1 --grow

%packages
@^minimal

@core
%end
%addon com_redhat_kdump --disable --reserve-mb='auto'
%end
```

Tạo file kickstart cho ubuntu

```sh
cat /var/lib/cobbler/kickstarts/u16.cfg.ks
# set language to use during installation
lang en_US
langsupport en_US

# set keyboard layout for the system
keyboard us

# reboot the system after installation
reboot
# config repo source.list
url --url http://172.16.2.12/cblr/links/Ubuntu16-x86_64/

# Sets up the authentication options for the system.
auth --useshadow --enablemd5

bootloader --location=mbr

zerombr yes

clearpart --all

# setup timezone
timezone Asia/Ho_Chi_Minh

# Set the system's root password
rootpw minhkma123

# Creates a new user on the system
user ttp --fullname=minhkma --password=minhkma123
# create partition on the system with LVM
part pv.01 --size 1 --grow

volgroup ubuntu pv.01
logvol swap --fstype swap --name=swap --vgname=ubuntu --size 1024
logvol / --fstype ext4 --vgname=ubuntu --size=1 --grow --name=slash

# hack around Ubuntu kickstart bugs
preseed partman-lvm/confirm_nooverwrite boolean true
preseed partman-auto-lvm/no_boot boolean true

# Configures network information

network --bootproto=dhcp --device=eth0 --onboot=on

# Do not configure the X Window System
skipx

## Install packet for the system
%packages  --ignoremissing
@ ubuntu-server
openssh-server

## Run script after installation
%post
mkdir /root/test
%end
```

## Bước 8: Tạo menu boot

```sh
cobbler profile edit --name=CentOS7-x86_64 --kickstart=/var/lib/cobbler/kickstarts/CentOS7.ks
cobbler profile edit --name=Ubuntu16-x86_64 --kickstart=/var/lib/cobbler/kickstarts/u16.cfg.ks
```


Đồng bộ dữ liệu

``cobbler sync``

## Bước 9: Tiến hành boot OS 

<img src="https://i.imgur.com/CGksMxk.png">

<img src="https://i.imgur.com/HHuHEI0.png">
