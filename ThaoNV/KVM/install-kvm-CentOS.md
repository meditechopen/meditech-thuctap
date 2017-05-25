# Hướng dẫn cài đặt KVM trên Cent OS 7.3 sử dụng Linux Bridge

## Mục lục

- [1. Mô hình](#mo-hinh)
- [2. Cách cài đặt KVM trên Cent OS 7 sử dụng Linux Bridge](#install)
- [3. Cách tạo và quản lí máy ảo với virt-manager](#create)

	- [3.1 Cách tạo máy ảo từ file image](#image)
	- [3.2 Cách tạo máy ảo từ file ISO](#iso)

-------

### <a name = "mo-hinh"> 1. Mô hình </a>

- Sử dụng VMWare làm môi trường dựng lab
- Máy server:
  <ul>
  <li>CentOS 7.3, 1 NIC (Bridge)</li>
  <li>Máy server cài các gói qemu-kvm, libvirt-bin, x-window và virt-manager để quản trị thông qua giao diện đồ họa</li>
  <li>Sử dụng Linux Bridge để ảo hóa network cho các máy ảo</li>
  </ul>

- Máy Client:
  <ul>
  <li>Sử dụng hệ điều hành Windows</li>
  <li>Cài đặt MobaXterm để ssh từ xa</li>
  </ul>

<img src="https://camo.githubusercontent.com/929bdfbfd2f27393f3dc40c380053d062e8d5395/687474703a2f2f692e696d6775722e636f6d2f7a467276546a772e6a7067">

### <a name ="install"> 2. Cách cài đặt KVM trên Cent OS 7.3 sử dụng Linux Bridge </a>

**Bước 1**

- Để cài đặt KVM, CPU của máy phải hỗ trợ ảo hóa phần cứng Intel VT-x hoặc AMD-V. 
  Để xác định CPU có những tính năng này không, thực hiện lệnh sau:

`egrep -c '(svm|vmx)' /proc/cpuinfo`

Giá trị 0 chỉ thị rằng CPU không hỗ trợ ảo hóa phần cứng trong khi giá trị khác 0 chỉ thị có hỗ trợ. 
Người dùng có thể vẫn phải kích hoạt chức năng hỗ trợ ảo hóa phần cứng trong BIOS của máy kể cả khi câu lệnh này trả về giá trị khác 0.

<img src="http://i.imgur.com/Cs2zowA.png">

Ở đây, giá trị trả về của mình là 1.

Nếu bạn sử dụng VMWare, hãy nhớ bật chức năng ảo hóa Intel VT-x/EPT hoặc AMD-V/RVI trong phần `Processors`

<img src="http://i.imgur.com/PIngLij.png">

**Bước 2**

- Sử dụng câu lệnh sau để cài đặt KVM và các gói phụ trợ liên quan

`yum -y install qemu-kvm libvirt bridge-utils virt-manager`

- Trong đó:
  <ul>
  <li>libvirt-bin: cung cấp libvirt mà bạn cần quản lý qemu và kvm bằng libvirt</li>
  <li>qemu-kvm: Phần phụ trợ cho KVM</li>
  <li>bridge-utils: chứa một tiện ích cần thiết để tạo và quản lý các thiết bị bridge.</li>
  <li>virt-manager: cung cấp giao diện đồ họa để quản lí máy ảo</li>
  </ul>
  
- Đối với bản Minimal, người dùng phải cài đặt gói x-window thì mới có thể sử dụng được công cụ đồ họa virt-manager. Cài x-window bằng câu lệnh

`yum install "@X Window System" xorg-x11-xauth xorg-x11-fonts-* xorg-x11-utils -y`

**Bước 3**

- Kiểm tra để chắc chắn rằng các modules của kvm đã được load vào kernel bằng lệnh:

`lsmod | grep kvm`

<img src="http://i.imgur.com/2KrGCor.png">

**Bước 4**

- Start dịch vụ libvirt và cho phép khởi động cùng hệ thống bằng 2 câu lệnh:

``` sh
systemctl start libvirtd
systemctl enable libvirtd
```

**Bước 5**

- Tạo mới một bridge tên là br0 bằng câu lệnh:

`nmcli c add type bridge autoconnect yes con-name br0 ifname br0`

- Gán địa chỉ IP cho bridge mới tạo bằng câu lệnh:

`nmcli c modify br0 ipv4.addresses 192.168.100.200/24 ipv4.method manual`

- Đặt gateway cho bridge bằng câu lệnh:

`nmcli c modify br0 ipv4.gateway 192.168.100.1`

- Đặt địa chỉ dns cho bridge bằng câu lệnh:

`nmcli c modify br0 ipv4.dns 8.8.8.8`

- Xóa cài đặt card mạng hiện tại bằng câu lệnh

`nmcli c delete ens3`

- Gán card mạng hiện tại vào bridge br0 bằng câu lệnh

`nmcli c add type bridge-slave autoconnect yes con-name ens3 ifname ens3 master br0`

**Bước 6**

- Reboot lại máy

### <a name ="create"> 3. Cách tạo và quản lí máy ảo bằng virt-manager </a>

#### <a name = "image"> 3.1. Cách tạo máy ảo bằng file image </a>

- Tiến hành download image và đặt tại thư mục `/var/lib/libvirt/images` :

``` sh
yum install wget -y
cd /var/lib/libvirt/images
wget https://ncu.dl.sourceforge.net/project/gns-3/Qemu%20Appliances/linux-microcore-3.8.2.img
```

- Sử dụng lệnh `virt-manager` để sử dụng công cụ này, một màn hình sẽ hiện lên để người dùng thao tác

<img src="http://i.imgur.com/2ZT6zhi.png">

- Chọn vào biểu tượng phía góc trái để tạo máy ảo
  Chọn cách tạo máy ảo, ở đây tôi chọn import từ file image có sẵn

<img src="http://i.imgur.com/ozy2gBS.png">

- Browse tới file image

<img src="http://i.imgur.com/8fls28B.png">

- Chọn RAM và CPU cho máy ảo

<img src="http://i.imgur.com/3KEn4GR.png">

- Chọn `Customize configuration before install`
- Tích vào mục `Hard Disk` để thiết lập chế độ boot của máy ảo từ disk.
  Lựa chọn `Apply` để chấp nhận các thiết lập.
  Sau đó chọn `Begin Installation` để bắt đầu khởi động máy ảo.

<img src="http://i.imgur.com/y43Lv0F.png">

#### <a name="iso"> 3.2. Cách tạo máy ảo bằng file ISO </a>

- Tiến hành download file iso và đặt tại thư mục `/var/lib/libvirt/images`:

``` sh
wget http://mirrors.nhanhoa.com/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1611.iso /var/lib/libvirt/images
```

- Chọn "File" -> "New Virtual Machine" và chọn tạo máy ảo từ file ISO

<img src="http://i.imgur.com/S3ekhHd.png">

- Browse tới file ISO

<img src="http://i.imgur.com/VGJP0aG.png">

- Chọn RAM và CPU cho máy ảo

<img src="http://i.imgur.com/fXkbZV0.png">

- Chọn dung lượng ổ cứng cho máy ảo. Sau đó tích chọn `Customize configuration before install`

<img src="http://i.imgur.com/zgfqCmb.png">

- Tại mục `Boot Options` , chọn `IDE CDROM 1` -> `Apply` -> `Begin Installation`

<img src="http://i.imgur.com/awSECrZ.png">

- Tiến hành cài OS cho máy ảo:

<img src="http://i.imgur.com/tj1xyCW.png">

**Link tham khảo:**

https://www.linuxtechi.com/install-kvm-hypervisor-on-centos-7-and-rhel-7/

https://www.server-world.info/en/note?os=CentOS_7&p=kvm&f=1