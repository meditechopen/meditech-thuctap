# Hướng dẫn đóng image Windows Server 2008 R2 Enterprise với cloud-init và QEMU Guest Agent

## Chú ý:

- Sử dụng công cụ virt-manager hoặc web-virt để kết nối tới console máy ảo
- OS cài đặt KVM là Ubuntu 14.04
- Phiên bản OpenStack sử dụng là Mitaka
- Hướng dẫn bao gồm 2 phần chính: thực hiện trên máy ảo cài OS và thực hiện trên KVM Host

----------------------

### Bước 1: Tạo máy ảo bằng kvm

Lưu ý: Bạn cần tải ISO của OS tại trang chủ của Microsoft và file virio driver phiên bản stable [tại đây](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso)

Bạn có thể dử dụng virt-manager hoặc virt-install để tạo máy ảo

Ở đây mình sử dụng virt-install

``` sh
qemu-img create -f qcow2 /var/lib/libvirt/images/win2k8r2.img  40G

virt-install --connect qemu:///system \
  --name ws2008 --ram 4096 --vcpus 4 \
  --network bridge=br0,model=virtio \
  --disk path=/var/lib/libvirt/images/win2k8r2.img,format=qcow2,device=disk,bus=virtio \
  --cdrom /var/lib/libvirt/images/EN_Windows_Server_2008_R2-64-SP1.iso \
  --disk path=/var/lib/libvirt/images/virtio-win-0.1.141.iso,device=cdrom \
  --vnc --os-type windows --os-variant win2k8
```

Lưu ý: Virtual size mà bạn chọn cho ổ đĩa sẽ là size tối thiểu của volume nếu bạn muốn boot máy ảo từ volume sau này.
Nên tạo máy ảo với định dạng file ổ đĩa là qcow2 để không mất công chuyển đổi sau này.

### Bước 2: Chỉnh sửa file .xml

Sau khi máy ảo được bật lên, tiến hành tắt máy ảo và bổ sung thêm channel trong <devices> (để máy host giao tiếp với máy ảo sử dụng qemu-guest-agent), sau đó save lại

`virsh edit ws2008`

với win2k8 là tên máy ảo

``` sh
...
<devices>
 <channel type='unix'>
      <target type='virtio' name='org.qemu.guest_agent.0'/>
      <address type='virtio-serial' controller='0' bus='0' port='1'/>
 </channel>
</devices>
```

**Lưu ý:**

Không cần thực hiện lại các bước 3-4 nếu đã thực hiện ở lần đóng image trước đó

### Bước 3: Tạo thêm thư mục cho channel vừa tạo và phân quyền cho thư mục đó

`vim /etc/apparmor.d/abstractions/libvirt-qemu`

Bổ sung thêm cấu hình sau vào dòng cuối cùng

`/var/lib/libvirt/qemu/channel/target/*.qemu.guest_agent.0 rw,`

Mục đích là phân quyền cho phép libvirt-qemu được đọc ghi các file có hậu tố .qemu.guest_agent.0 trong thư mục /var/lib/libvirt/qemu/channel/target
Khởi động lại libvirt và apparmor

``` sh
service libvirt-bin restart
service apparmor reload
```

### Bước 4: Bật máy ảo để cài đặt OS

<img src="https://i.imgur.com/gHZPFOV.png">

### Bước 5: Lựa chọn cài đặt

<img src="https://i.imgur.com/MQr2F7W.png">
<img src="https://i.imgur.com/F7wkD1C.png">

### Bước 6: Lựa chọn chỉ cài đặt Windows không tự động Upgrade

<img src="https://i.imgur.com/O9H5lxJ.png">

### Bước 7: Máy ảo sẽ không tự động load ổ đĩa cứng

Lựa chọn load driver

<img src="https://i.imgur.com/qdpyPc3.png">


Browse tới file ISO vừa đưa vào. Chọn Driver storage cho Windows 2k12R2
<img src="https://i.imgur.com/5bQcV3G.png">

Chọn Next để cài đặt

<img src="https://i.imgur.com/vuYGx20.png">

### Bước 8: Lúc này máy ảo đã nhận ổ đĩa, tiến hành cài đặt OS, làm theo các hướng dẫn để cài như bình thường

<img src="https://i.imgur.com/P0WQ2nC.png">
<img src="https://i.imgur.com/xa63lfG.png">

### Bước 9: Sau khi cài xong OS, tắt VM và sửa lại Boot Options, lựa chọn Boot từ Hard Disk và bật máy ảo

<img src="https://i.imgur.com/x2lCcp5.png">

## 2. Xử lý image sau khi đã cài xong OS

### Bước 1: Tạo password administrator cho máy ảo

<img src="https://i.imgur.com/90wpiSw.png">

### Bước 2: Vào "Device Manager" để update driver cho NIC, cài đặt network driver để VM nhận card mạng

<img src="https://i.imgur.com/jLuswJY.png">
<img src="https://i.imgur.com/62rWjNK.png">
<img src="https://i.imgur.com/WfmQcVi.png">
<img src="https://i.imgur.com/fHaw9wI.png">

### Bước 3: Kiểm tra lại việc cài đặt Driver cho NIC

<img src="https://i.imgur.com/HVCAuIx.png">

### Bước 4: Cài đặt Baloon driver cho Memory
Copy `/virtio-win-0.1.1/Baloon/2k8R2/amd64` từ CD Drive vào `C:\`

<img src="https://i.imgur.com/u4OV2jB.png">

Chạy CMD, trỏ về thư mục amd64 vừa copy và chạy lệnh:
```
PS C:\Users\Administrator> cd C:\amd64
PS C:\amd6>. \blnsvr.exe -i
```
<img src="https://i.imgur.com/aU66s4d.png">

Kiểm tra trong services.msc

<img src="https://i.imgur.com/wZz5wV7.png">

Truy cập vào "Device Manager" -> "Other Devices" -> "PCI Device" -> "Update Driver Software"

<img src="https://i.imgur.com/X9fsFrn.png">

Browse tới thư mục vừa được copy vào ổ C.

<img src="https://i.imgur.com/2hTs15h.png">

Driver đã đc cài đặt

### Bước 5: Cài đặt qemu-guest-agent
#### *Chú ý: qemu-guest-agent là một daemon chạy trong máy ảo, giúp quản lý và hỗ trợ máy ảo khi cần (có thể cân nhắc việc cài thành phần này lên máy ảo)*

Vào "Device Manager", chọn update driver cho `PCI Simple Communication Controller`

<img src="https://i.imgur.com/zV44srr.png">
<img src="https://i.imgur.com/2VMJcpu.png">
<img src="https://i.imgur.com/RcjtYAA.png">

Kiểm tra lại việc cài đặt Driver cho `PCI Simple Communication Controller`

<img src="https://i.imgur.com/9HRlNAX.png">

Cài đặt qemu-guest-agent cho Windows Server 2k8R2, vào CD ROM virio và cài đặt phiên bản qemu-ga (ở đây là `qemu-ga-x64`)

<img src="https://i.imgur.com/UjYgQol.png">

Kiểm tra lại việc cài đặt qemu-guest-agent

`PS C:\Users\Administrator> Get-Service QEMU-GA`

<img src="https://i.imgur.com/3RT33Mv.png">

Kiểm tra lại version của qemu-guest-agent (phải đảm bảo version >= 7.3.2)

<img src="https://i.imgur.com/svvFq8x.png">

### Bước 6: Disable Firewall và enable remote desktop

<img src="https://i.imgur.com/rZzv1tc.png">
<img src="https://i.imgur.com/KoPdQmt.png">

### Bước 7: Cài đặt cloud-init bản mới nhất

Download cloud base init cho Windows bản mới nhất tại [đây](https://cloudbase.it/cloudbase-init/)


<img src="https://i.imgur.com/6rBY09l.png">

Tiến hành cài đặt

<img src="https://i.imgur.com/lbNv7iP.png">
<img src="https://i.imgur.com/UexqGiz.png">
<img src="https://i.imgur.com/avbPIpj.png">
<img src="https://i.imgur.com/74mP8mP.png">
<img src="https://i.imgur.com/Jzz3UUj.png">

Trước khi "Finish" cài đặt, sửa lại file `C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\cloudbase-init.conf`

```
[DEFAULT]
username=Administrator
groups=Administrators
inject_user_password=true
first_logon_behaviour=no
config_drive_raw_hhd=true
config_drive_cdrom=true
config_drive_vfat=true
bsdtar_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\bsdtar.exe
mtools_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\
verbose=true
debug=true
logdir=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\
logfile=cloudbase-init.log
default_log_levels=comtypes=INFO,suds=INFO,iso8601=WARN,requests=WARN
logging_serial_port_settings=COM1,115200,N,8
mtu_use_dhcp_config=true
ntp_use_dhcp_config=true
local_scripts_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts\
```

**Lưu ý:**

Nếu bạn thêm `first_logon_behaviour=no` thì bạn sẽ không thể thay đổi password ở lần đăng nhập đầu tiên.

Enable Sysprep và shutdown máy

<img src="https://i.imgur.com/xLJdRBD.png">
<img src="https://i.imgur.com/LXEwAOI.png">

## 3.Thực hiện trên Host KVM
### Bước 1: Cài đặt bộ libguestfs-tools để xử lý image (nên cài đặt trên Ubuntu OS để có bản libguestfs mới nhất)
```
apt-get install libguestfs-tools -y
```

### Bước 2: Dùng lệnh sau để tối ưu kích thước image:
```
virt-sparsify --compress /var/lib/libvirt/images/win2k8r2.img /var/lib/libvirt/images/win2k8r2_shrink.img
```

### Bước 3: Upload image lên glance
```
glance image-create --name win2k8 \
--disk-format qcow2 \
--container-format bare \
--file /root/win2k8r2_shrink.img \
--visibility=public \
--property hw_qemu_guest_agent=yes \
--progress
```

### Bước 4: Kiểm tra việc upload image đã thành công hay chưa

`openstack image list`

### Bước 5: Chỉnh sửa metadata của image upload

<img src="https://github.com/hocchudong/Image_Create/blob/master/images/win2k12_standard/win2k12_47.jpg?raw=true">

Thêm 2 metadata là 'hw_qemu_guest_agent' và 'os_type', với giá trị tương ứng là `true` và `windows`, sau đó save lại

<img src="https://github.com/hocchudong/Image_Create/blob/master/images/win2k12_standard/win2k12_48.jpg?raw=true">

### Bước 6: Image đã sẵn sàng để launch máy ảo.

## 4. Thử nghiệm việc đổi password máy ảo (sau đã đã tạo máy ảo)
### Cách 1: sử dụng nova API (lưu ý máy ảo phải đang bật)

Trên node Controller, thực hiện lệnh và nhập password cần đổi

```
root@controller1:# nova set-password win2k8_qemu_ga
New password:
Again:
```
với `win2k8_qemu_ga` là tên máy ảo


### Cách 2: sử dụng trực tiếp libvirt
#### Xác định vị trí máy ảo đang nằm trên node compute nào. VD máy ảo đang sử dụng là `win2k8_qemu_ga`

`root@controller1:# nova show win2k8_qemu_ga`

với `win2k8_qemu_ga` là tên máy ảo

Kết quả:
```
+--------------------------------------+----------------------------------------------------------------------------------+
| Property                             | Value                                                                            |
+--------------------------------------+----------------------------------------------------------------------------------+
| OS-DCF:diskConfig                    | MANUAL                                                                           |
| OS-EXT-AZ:availability_zone          | nova                                                                             |
| OS-EXT-SRV-ATTR:host                 | compute6		                                                                  |
| OS-EXT-SRV-ATTR:hostname             | win2k8-qemu-ga                                                                  |
| OS-EXT-SRV-ATTR:hypervisor_hostname  | compute6                                                                         |
| OS-EXT-SRV-ATTR:instance_name        | instance-00001827                                             
```

Như vậy máy ảo nằm trên node compute6 với KVM name là `instance-00001827`

#### Trên compute6, kiểm tra để tìm file socket kết nối tới máy ảo
```
root@compute6:~# bash -c  "ls /var/lib/libvirt/qemu/*.sock"
```

Kết quả:
```
/var/lib/libvirt/qemu/org.qemu.guest_agent.0.instance-00001827.sock

instance-0000001d: tên của máy ảo trên KVM
```

```
root@compute6:~# file /var/lib/libvirt/qemu/org.qemu.guest_agent.0.instance-00001827.sock
```

Kết quả:
```
/var/lib/libvirt/qemu/org.qemu.guest_agent.0.instance-00001827.sock: socket
```

#### Kiểm tra kết nối tới máy ảo. Ở trên node compute chứa máy ảo (compute6), chạy lệnh:
```
root@compute6:~# virsh qemu-agent-command instance-00001827 '{"execute":"guest-ping"}'
```

Kết quả:
```
{"return":{}}
```

#### Sinh password mới `123456a@` (password phải đáp ứng yêu cầu phức tạp của Windows)
```
echo -n "123456a@" | base64
```

Kết quả:
```
MTIzNDU2YUA=
```

#### Ở trên node compute chứa máy ảo (compute6), chèn password mới vào máy ảo, lưu ý máy ảo phải đang bật
```
root@compute6:~# virsh  qemu-agent-command instance-00001827 '{ "execute": "guest-set-user-password","arguments": { "crypted": false,"username": "administrator","password": "MTIzNDU2YUA=" } }'
```

Kết quả;
```
{"return":{}}
```

Thử đăng nhập vào máy ảo với password `123456a@`

## Done


Tham khảo:

[1] - http://www.stratoscale.com/blog/storage/deploying-ceph-challenges-solutions/?utm_source=twitter&utm_medium=social&utm_campaign=blog_deploying-ceph-challenges-solutions

[2] - https://pve.proxmox.com/wiki/Qemu-guest-agent

[3] - https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Virtualization_Administration_Guide/sect-QEMU_Guest_Agent-Running_the_QEMU_guest_agent_on_a_Windows_guest.html

[4] - https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Virtualization_Deployment_and_Administration_Guide/chap-QEMU_Guest_Agent.html

[5] -
https://github.com/hocchudong/Image_Create/blob/master/docs/Windows2K12R2_qemu_ga.md
