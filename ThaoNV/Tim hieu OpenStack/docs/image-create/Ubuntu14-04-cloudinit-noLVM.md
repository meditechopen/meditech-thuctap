# Hướng dẫn đóng image Ubuntu 14.04 với cloud-init (không dùng LVM)

## Bước 1: Tạo máy ảo bằng KVM

Sử dụng virt-install hoặc virt-manager để tạo máy ảo. Ở đây mình dùng virt-install

``` sh
qemu-img create -f qcow2 /tmp/trusty.qcow2 10G
virt-install --virt-type kvm --name trusty --ram 1024 \
  --cdrom=/var/lib/libvirt/images/ubuntu-14.04.1-server-amd64.iso \
  --disk /tmp/trusty.qcow2,format=qcow2 \
  --network bridge=br0 \
  --graphics vnc,listen=0.0.0.0 --noautoconsole \
  --os-type=linux --os-variant=ubuntutrusty
```

**Một số lưu ý trong quá trình cài đặt**

- Đối với hostname, các bạn có thể đặt mặc định bởi ta dùng cloud-init để set sau.
- Đối với cấu hình partion, do ở đây mình dùng cloud-init nên không thể cấu hình LVM mặc định.
Thay vào đó, ta sẽ cấu hình bằng tay với 1 phân vùng root (/) để máy ảo có thể tự resize theo flavor mới.

Lưu ý: không dùng cấu hình tự động, mình đã thử và thấy máy ảo không thể tự resize.

<img src="http://i.imgur.com/hI7aW14.png">

- Đối với phần `software selection`, ta lựa chọn `OpenSSH server`

<img src="http://i.imgur.com/oLB72zc.png">

- Install GRUB boot loader

- Sau khi cài đặt xong, chọn `Continue` để reboot máy ảo.
Lưu ý: Có một số trường hợp đối với ubuntu14.04, máy ảo sẽ không reboot kể cả khi nó báo là sẽ reboot

- Sau khi đã hoàn tất cài đặt, tiến hành gỡ bỏ ổ đĩa, libvirt yêu cầu bạn gán một ổ đĩa trống tại nơi trước đó cd-rom được gán, có thể là `hdc`. Bạn có thể xem nó bằng câu lệnh ` virsh dumpxml vm-image`

``` sh
# virsh dumpxml trusty
<domain type='kvm'>
  <name>trusty</name>
...
    <disk type='block' device='cdrom'>
    <driver name='qemu' type='raw'/>
    <target dev='hdc' bus='ide'/>
    <readonly/>
    <address type='drive' controller='0' bus='1' target='0' unit='0'/>
  </disk>
...
</domain>
```

Chạy câu lệnh sau trên KVM để gỡ bỏ ổ đĩa

``` sh
# virsh start trusty --paused
# virsh attach-disk --type cdrom --mode readonly trusty "" hdc
# virsh resume trusty
```

## Bước 2: Cài các dịch vụ cần thiết

Truy cập vào máy ảo. Lưu ý với lần đầu boot, bạn phải sử dụng tài khoản tạo trong quá trình cài os, chuyển đổi nó sang tài khoản root để sử dụng.

**Cài đặt cloud-init, cloud-utils và cloud-initramfs-growroot**

`apt-get install cloud-utils cloud-initramfs-growroot cloud-init -y`

## Bước 3: Cấu hình để instance nhận metadata từ datasource

`dpkg-reconfigure cloud-init`

Sau khi màn hình mở ra, lựa chọn duy nhất EC2

<img src="http://i.imgur.com/o2e5Gwm.png">

## Bước 4: Cấu hình user nhận ssh keys

Thay đổi file `/etc/cloud/cloud.cfg` để chỉ định user nhận ssh keys khi truyền vào, mặc định là ubuntu. Ở đây mình đổi thành admin

``` sh
users:
  - name: admin
    (...)
```

## Bước 5: Xóa bỏ thông thin của địa chỉ MAC

xóa nội dung file `/lib/udev/rules.d/75-persistent-net-generator.rules` và `/etc/udev/rules.d/70-persistent-net.rules` (file này được gen bởi file trước) bằng các sử dụng `:%d`  trong `vi`.

Bạn cũng có thể thay thế file trên bằng 1 file rỗng. Lưu ý: không được xóa bỏ hoàn toàn file mà chỉ xóa nội dung.

## Bước 6: Cấu hình để instance báo log ra console

Thay đổi `GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8"` trong file `/etc/default/grub`.

Sau đó nhập lệnh `update-grub` để lưu lại.

## Bước 7: tắt máy ảo

`/sbin/shutdown -h now`

## Bước 8: Cài libguestfs-tools để xử lý image

`apt-get install libguestfs-tools -y`

**Lưu ý:**

Từ bước này thực hiện trên host KVM.

Bước 8 chỉ cần thực hiện ở lần đóng image đầu tiên.

## Bước 9: Clean up image

`virt-sysprep -d trusty`

## Bước 10: Undefine libvirt domain

`virsh undefine trusty`

## Bước 11: Giảm kích thước máy ảo

`virt-sparsify --compress /tmp/trusty.qcow2 /tmp/trusty-shrink.qcow2`

**Done**

**Link tham khảo**

https://docs.openstack.org/image-guide/openstack-images.html

https://docs.openstack.org/image-guide/ubuntu-image.html
