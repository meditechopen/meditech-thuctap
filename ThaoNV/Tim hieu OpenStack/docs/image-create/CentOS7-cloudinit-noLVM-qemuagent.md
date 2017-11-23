# Hướng dẫn đóng image CentOS 7 với QEMU Guest Agent + cloud-init (no LVM)

## Chú ý:

- Hướng dẫn này dành cho các image không sử dụng LVM
- Sử dụng công cụ virt-manager hoặc web-virt để kết nối tới console máy ảo
- OS cài đặt KVM là Ubuntu 14.04
- Phiên bản OpenStack sử dụng là Pike
- Hướng dẫn bao gồm 2 phần chính: thực hiện trên máy ảo cài OS và thực hiện trên KVM Host

----------------------

## Bước 1: Tạo máy ảo bằng kvm

Bạn có thể dử dụng virt-manager hoặc virt-install để tạo máy ảo

Ở đây mình sử dụng virt-install

``` sh
# qemu-img create -f qcow2 /tmp/centos.qcow2 10G
# virt-install --virt-type kvm --name centos --ram 2048 \
  --disk /tmp/centos.qcow2,format=qcow2 \
  --network bridge=br0 \
  --graphics vnc,listen=0.0.0.0 --noautoconsole \
  --os-type=linux --os-variant=rhel7 \
  --location=/var/lib/libvirt/images/CentOS-7-x86_64-Minimal-1611.iso
```

**Một số lưu ý trong quá trình cài đặt**

- Thay đổi Ethernet status sang `ON` (mặc định là OFF). Bên cạnh đó, hãy chắc chắn máy ảo nhận được dhcp

<img src="http://i.imgur.com/2so4Nlo.png">

- Đối với phân vùng dữ liệu, có một vài tùy chọn, ở đây mình không dùng LVM

  - Ở đây mình chọn `“I will configure partitioning”` và `“Standard Partition”` dưới phần `“New mount points will use the following partition scheme”`
  - Tiếp theo đó, click vào dấu `+` để tạo phân vùng mới và chọn `/`
  - Phần `“File System”` mình để `ext4`

## Bước 2: Xử lí trên KVM host

Sau khi cài đặt xong, tiến hành reboot lại máy. Lưu ý ở một số phiên bản KVM, máy ảo có thể sẽ không tự reboot.

Tiến hành tắt máy ảo và xử lí một số bước sau trên KVM host:

- Chỉnh sửa file `.xml` của máy ảo, bổ sung thêm channel trong <devices> (để máy host giao tiếp với máy ảo sử dụng qemu-guest-agent), sau đó save lại

`virsh edit centos`

với `centos` là tên máy ảo

``` sh
...
<devices>
 <channel type='unix'>
      <target type='virtio' name='org.qemu.guest_agent.0'/>
      <address type='virtio-serial' controller='0' bus='0' port='1'/>
 </channel>
</devices>
...
```

- Tạo thêm thư mục cho channel vừa tạo và phân quyền cho thư mục đó

``` sh
mkdir -p /var/lib/libvirt/qemu/channel/target
chown -R libvirt-qemu:kvm /var/lib/libvirt/qemu/channel
```

- Nếu KVM host là ubuntu, sửa file /etc/apparmor.d/abstractions/libvirt-qemu

`vi /etc/apparmor.d/abstractions/libvirt-qemu`

Thêm dòng sau vào cuối File

`/var/lib/libvirt/qemu/channel/target/*.qemu.guest_agent.0 rw,`

Mục đích là phân quyền cho phép libvirt-qemu được đọc ghi các file có hậu tố `.qemu.guest_agent.0` trong thư mục `/var/lib/libvirt/qemu/channel/target`

Khởi động lại `libvirt` và `apparmor`

``` sh
service libvirt-bin restart
service apparmor reload
```

- Bật máy ảo lên

## Bước 3: Cấu hình máy ảo và cài đặt các package

- Xóa file hostname

`# rm /etc/hostname`

- Stop firewalld

``` sh
# systemctl disable firewalld.service
# systemctl stop firewalld.service
```

- Disable SELINUX

``` sh
# setenforce 0
# vi /etc/sysconfig/selinux

  SELINUX=permissive
```

**Lưu ý:**

Để sử sụng qemu-agent, phiên bản selinux phải > 3.12
Sử dụng câu lệnh sau để check

`rpm -qa | grep -i selinux-policy`

- Update package

``` sh
# yum update
```

- Để cho phép hypervisor có thể reboot hoặc shutdown instance, bạn sẽ phải cài acpi service.

``` sh
# yum install acpid
# systemctl enable acpid
```

- Cài đặt qemu guest agent, cloud-init và cloud-utils:

`yum install qemu-guest-agent cloud-init cloud-utils`

- Kích hoạt và khởi động qemu-guest-agent service

``` sh
# systemctl enable qemu-guest-agent.service
# systemctl start qemu-guest-agent.service
```

**Lưu ý:**

Để có thể thay đổi password máy ảo thì phiên bản qemu-guest-agent phải >= 2.5.0

Kiểm tra phiên bản qemu-ga bằng lệnh:

`qemu-ga --version`

- Cấu hình console

Để sử dụng nova console-log, bạn cần phải làm theo một số bước sau :

  - Thay đổi `GRUB_CMDLINE_LINUX`  option trong file `/etc/default/grub` từ `rhgb quiet` sang `console=tty0 console=ttyS0,115200n8`

  - Chạy câu lệnh để lưu lại

  `grub2-mkconfig -o /boot/grub2/grub.cfg`

- Thay đổi cấu hình mặc định bằng cách sửa đổi file `/etc/cloud/cloud.cfg`. Ở đây mình sẽ thay đổi tên account được dùng bởi cloud-init thành root

``` sh
disable_root: 0
ssh_pwauth:   1
...
users:
  - name: root
  (...)
```

**Lưu ý:**

Bạn cũng có thể chỉnh sửa cho user `root` login (disable_root: 0) và xóa toàn bộ section `default_user` dưới phần `system_info`

Khi launch máy ảo, bạn có thể truyền script vào cho máy ảo để thay đổi password của user account mặc định phía trên

``` python
#cloud-config
password: meditech2017
chpasswd: { expire: False }
ssh_pwauth: True
```

- Hủy bỏ zeroconf route

`# echo "NOZEROCONF=yes" >> /etc/sysconfig/network`

- Xóa thông tin card mạng

`# rm /etc/sysconfig/network-scripts/ifcfg-eth0`

## Bước 4: Tắt máy ảo

`# poweroff`

## Bước 5: Xóa bỏ MAC address details

`# virt-sysprep -d centos`

## Bước 7: Undefine the libvirt domain

`# virsh undefine centos`

## Bước 8: Giảm kích thước image

`# virt-sparsify --compress /tmp/centos.qcow2 /tmp/centos_shrink.img`

**Lưu ý:**

Nếu img bạn sử dụng đang ở định dạng raw thì bạn cần thêm tùy chọn `--convert qcow2` để giảm kích thước image.

## Bước 9: Upload image lên glance

- Di chuyển image tới máy CTL, sử dụng câu lệnh sau

``` sh
glance image-create --name centos \
--disk-format qcow2 \
--container-format bare \
--file /root/centos.img \
--visibility=public \
--property hw_qemu_guest_agent=yes \
--progress
```

- Kiểm tra xem image đã upload thành công chưa, kiểm tra metadata của image đã có `hw_qemu_guest_agent` hay chưa.

<img src="https://i.imgur.com/GIhnP9R.png">

<img src="https://i.imgur.com/PrsfYj0.png">

- Image đã sẵn sàng để launch máy ảo.

## Hướng dẫn thay đổi password

### Cách 1: sử dụng nova API (lưu ý máy ảo phải đang bật)

Trên node Controller, thực hiện lệnh và nhập password cần đổi

``` sh
root@controller:# nova set-password thaonv
New password:
Again:
```

với `thaonv` là tên máy ảo

### Cách 2: sử dụng trực tiếp libvirt

Xác định vị trí máy ảo đang nằm trên node compute nào. VD máy ảo đang sử dụng là thaonv

`root@controller:# nova show thaonv`

Kết quả:

``` sh
+--------------------------------------+----------------------------------------------------------------------------------------------------------+
| Property                             | Value                                                                                                    |
+--------------------------------------+----------------------------------------------------------------------------------------------------------+
| OS-DCF:diskConfig                    | AUTO                                                                                                     |
| OS-EXT-AZ:availability_zone          | nova                                                                                                     |
| OS-EXT-SRV-ATTR:host                 | compute2                                                                                                 |
| OS-EXT-SRV-ATTR:hostname             | thaonv                                                                                                   |
| OS-EXT-SRV-ATTR:hypervisor_hostname  | compute2                                                                                                 |
| OS-EXT-SRV-ATTR:instance_name        | instance-00000003                                                                                        |
```

Như vậy máy ảo nằm trên node compute1 với KVM name là `instance-00000003`

Kiểm tra trên máy compute2 để tìm file socket kết nối tới máy ảo

`bash -c  "ls /var/lib/libvirt/qemu/*.sock"`

Kết quả:

`/var/lib/libvirt/qemu/org.qemu.guest_agent.0.instance-00000003.sock`

instance-00000003: tên của máy ảo trên KVM

`file /var/lib/libvirt/qemu/org.qemu.guest_agent.0.instance-00000003.sock`

Kết quả:

`/var/lib/libvirt/qemu/org.qemu.guest_agent.0.instance-00000003.sock: socket`

Kiểm tra kết nối tới máy ảo

`virsh qemu-agent-command instance-00000003 '{"execute":"guest-ping"}'`

Kết quả:

`{"return":{}}`

Sinh password mới `thaodeptrai`

`echo -n "new" | base64`

Kết quả:

`dGhhb2RlcHRyYWk=`

Chèn password mới vào máy ảo, lưu ý máy ảo phải đang bật

virsh  qemu-agent-command instance-00000003 '{ "execute": "guest-set-user-password","arguments": { "crypted": false,"username": "root","password": "dGhhb2RlcHRyYWk=" } }'

Kết quả:

`{"return":{}}`

Thử đăng nhập vào máy ảo với password mới là `thaodeptrai`

**Link tham khảo**

http://openstack-xenserver.readthedocs.io/en/latest/24-create-kvm-centos-7-image.html

https://github.com/hocchudong/Image_Create/blob/master/docs/CentOS%207_noLVM%2Bqemu_ga%20.md

https://docs.openstack.org/image-guide/centos-image.html

https://access.redhat.com/solutions/732773
