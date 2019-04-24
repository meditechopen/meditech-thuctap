# Hướng dẫn đóng image CentOS 6 với Cloud-init (không dùng LVM)

## Tạo máy ảo bằng kvm

Ở đây mình sử dụng web-virt để tạo máy ảo. Bạn có thể sử dụng bất kì công cụ nào để tạo máy ảo trên kvm.
Phiên bản OPS sử dụng: Pike

Lưu ý: Virtual size mà bạn chọn cho ổ đĩa sẽ là size tối thiểu của volume nếu bạn muốn boot máy ảo từ volume sau này.
Nên tạo máy ảo với định dạng file ổ đĩa là qcow2 để không mất công chuyển đổi sau này.

**Một số lưu ý trong quá trình cài đặt**

- Đối với phân vùng dữ liệu, có một vài tùy chọn, ở đây mình không dùng LVM (do nếu dùng lvm, máy ảo sẽ không thể tự resize) nên mình chọn manual.

Lưu ý chỉ cần tạo duy nhất một phân vùng `/` với định dạng `ext4` là được.

### 1.1. Cấu hình card eth0 tự động active khi hệ thống boot-up

vi /etc/sysconfig/network-scripts/ifcfg-eth0 :

```
ONBOOT=yes
```

###### Xóa 2 dòng :

```
HWADDR=xx:xx:xx:xx:xx:xx
UUID=.....
```

###### Active network interface
```
ifup eth0
```

### 1.2. Cài đặt ```cloud-utils-growpart``` để resize đĩa cứng lần đầu boot

```
yum install -y epel-release
yum install cloud-utils-growpart dracut-modules-growroot cloud-init -y
```

### 1.3. Rebuild initrd file
```
rpm -qa kernel | sed 's/^kernel-//'  | xargs -I {} dracut -f /boot/initramfs-{}.img {}
```

### 1.4. Cấu hình grub để  ‘phun’ log ra cho nova (Output của lệnh : nova get-console-output)

`vi /boot/grub/grub.conf`

Thay phần ```rhgb quiet```

Bằng : ```console=tty0 console=ttyS0,115200n8```

### 1.5. Cấu hình cloud-init, sửa file `/etc/cloud/cloud.cfg` như sau

`vi /etc/cloud/cloud.cfg`

```
disable_root: 0
ssh_pwauth:   1
...
system_info:
  default_user:
    name: root
  distro: rhel
  paths:
    cloud_dir: /var/lib/cloud
    templates_dir: /etc/cloud/templates
  ssh_svcname: sshd
```

User mặc định mà bạn cần chèn password sau này là `root`

### 1.6. Để sau khi boot máy ảo, có thể nhận đủ các NIC gắn vào:
```
yum install netplug -y
yum install wget -y
wget https://github.com/thaonguyenvan/meditech-thuctap/edit/master/ThaoNV/Tim%20hieu%20OpenStack/docs/image-create/netplug/netplug_cent6.5 -O netplug
```

### 1.7. Đưa file netplug vào thư mục /etc/netplug
```
mv netplug /etc/netplug.d/netplug
chmod +x /etc/netplug.d/netplug
```

### 1.8. Disable default config route
```
echo "NOZEROCONF=yes" >> /etc/sysconfig/network
```

### 1.9. Disable việc sinh ra file 70-persistent-net.rules (để mỗi khi clone máy ảo sẽ không bị thay đổi label card mạng)
```
echo "#" > /lib/udev/rules.d/75-persistent-net-generator.rules
```

### 1.10. Cài đặt qemu-guest-agent
#### *Chú ý: qemu-guest-agent là một daemon chạy trong máy ảo, giúp quản lý và hỗ trợ máy ảo khi cần (có thể cân nhắc việc cài thành phần này lên máy ảo)*
```
yum install qemu-guest-agent -y
```
#### Kiểm tra phiên bản `qemu-ga` bằng lệnh:
```
qemu-ga --version
```

Kết quả:
```
qemu-guest-agent-0.12.1.2-2.491.el6_8.6.x86_64
```

Khởi chạy qemu-guest-agent
```
service qemu-ga start
```

Khởi chạy qemu-guest-agent khi boot máy
```
chkconfig qemu-ga on
```

#### Disable SELinux
Sửa file /etc/selinux/config
```
SELINUX=disabled
```

###### Cleaning and Poweroff
```
yum clean all
poweroff
```

## 2. Thực hiện trên Host KVM
### 2.1. Cài đặt bộ libguestfs-tools để xử lý image (nên cài đặt trên Ubuntu OS để có bản libguestfs mới nhất)
```
apt-get install libguestfs-tools -y
```

### 2.2. Xử dụng lệnh `virt-sysprep` để xóa toàn bộ các thông tin máy ảo:
```
virt-sysprep -a CentOS65.img
```

### 2.3. Giảm kích thước image
```
sudo virt-sparsify --compress CentOS65.img CentOS65_shrink.img
```

### 2.4. Upload image lên glance

```
glance image-create --name centos68 \
--disk-format qcow2 \
--container-format bare \
--file /root/centos68.img \
--visibility=public \
--property hw_qemu_guest_agent=yes \
--progress
```

*Lưu ý:*

Nếu bạn upload máy ảo qua dashboard, hãy kiểm tra để chắc chắn có 2 option sau trong phần metadata của image:

<img src="https://i.imgur.com/TqPyogo.png">

### 2.5. Kiểm tra việc upload image đã thành công hay chưa

### Image đã sẵn sàng để launch máy ảo.

## Done
