# Hướng dẫn cài đặt KVM trên Cent OS 7 sử dụng Linux Bridge

## Mục lục

- [1. Mô hình](#mo-hinh)
- [2. Cách cài đặt KVM trên Cent OS 7 sử dụng Linux Bridge](#install)
- [3. Cách tạo và quản lí máy ảo với virt-manager](#create)

-------

### <a name = "mo-hinh"> 1. Mô hình </a>

- Sử dụng VMWare làm môi trường dựng lab
- Máy server:
  <ul>
  <li>CentOS 7, 1 NIC (Bridge)</li>
  <li>Máy server cài các gói qemu-kvm, libvirt-bin, x-window và virt-manager để quản trị thông qua giao diện đồ họa</li>
  <li>Sử dụng Linux Bridge để ảo hóa network cho các máy ảo</li>
  </ul>
  
- Máy Client:
  <ul>
  <li>Sử dụng hệ điều hành Windows</li>
  <li>Cài đặt MobaXterm để ssh từ xa</li>
  </ul>

<img src="https://camo.githubusercontent.com/929bdfbfd2f27393f3dc40c380053d062e8d5395/687474703a2f2f692e696d6775722e636f6d2f7a467276546a772e6a7067">

### <a name ="install"> 2. Cách cài đặt KVM trên Cent OS 7 sử dụng Linux Bridge </a>

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

`yum -y install qemu-kvm libvirt bridge-utils`

- Trong đó:
  <ul>
  <li>libvirt-bin: cung cấp libvirt mà bạn cần quản lý qemu và kvm bằng libvirt</li>
  <li>qemu-kvm: Phần phụ trợ cho KVM</li>
  <li>bridge-utils: chứa một tiện ích cần thiết để tạo và quản lý các thiết bị bridge.</li>
  </ul>
  
**Bước 3**

- Kiểm tra để chắc chắn rằng các modules của kvm đã được load vào kernel bằng lệnh:

`lsmod | grep kvm`

<img src="http://i.imgur.com/2KrGCor.png">

**Bước 4**

- Start dịch vụ libvirt

<img src="http://i.imgur.com/iVWKyHS.png">

**Bước 5**

- Tạo mới một bridge tên là br0 bằng câu lệnh:

`nmcli c add type bridge autoconnect yes con-name br0 ifname br0`

<img src="http://i.imgur.com/OvP0PZd.png">

- Gán địa chỉ ip và gateway cho bridge mới tạo bằng câu lệnh

`nmcli c modify br0 ipv4.addresses "192.168.100.200/24 192.168.100.1" ipv4.method manual`

- Xóa cài đặt card mạng hiện tại bằng câu lệnh

`nmcli c delete eno16777736`

- Gán card mạng hiện tại vào bridge br0 bằng câu lệnh

`nmcli c add type bridge-slave autoconnect yes con-name eno16777736 ifname eno16777736 master br0`

- Reset lại dịch vụ mạng bằng câu lệnh `systemctl restart network`
- Đối với bản Minimal, người dùng phải cài đặt gói x-window thì mới có thể sử dụng được virt-manager. Cài x-window bằng câu lệnh

`yum install "@X Window System" xorg-x11-xauth xorg-x11-fonts-* xorg-x11-utils -y`

**Bước 6**

- Cài đặt virt-manager để tạo và quản lí máy ảo bằng câu lệnh

`yum install virt-manager`

### <a name ="create"> 3. Cách tạo và quản lí máy ảo bằng virt-manager </a>

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
