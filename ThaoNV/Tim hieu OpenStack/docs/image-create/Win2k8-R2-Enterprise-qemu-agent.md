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
![Create VM 10](/images/Screenshot_1.png)

### Bước 5: Lựa chọn phiên bản cài đặt (Windows Server 2012 R2 Standard Evaluation GUI)
![Create VM 11](/images/win2k12_standard/win2k12_11.jpg)
![Create VM 12](/images/win2k12_standard/win2k12_12.jpg)

### Bước 6: Lựa chọn chỉ cài đặt Windows không tự động Upgrade
![Create VM 13](/images/win2k12_standard/win2k12_13.jpg)

### Bước 7: Máy ảo sẽ không tự động load ổ đĩa cứng
![Create VM 14](/images/win2k12_standard/win2k12_14.jpg)

Đưa ISO"virtio-win.iso" vào CD ROM trống đã gắn ban đầu
![Create VM 15](/images/win2k12_standard/win2k12_16.jpg)

Browse tới file ISO vừa đưa vào
![Create VM 16](/images/win2k12_standard/win2k12_17.jpg)

Chọn Driver storage cho Windows 2k12R2
![Create VM 17](/images/win2k12_standard/win2k12_18.jpg)
![Create VM 18](/images/win2k12_standard/win2k12_19.jpg)

### Bước 8: Lúc này máy ảo đã nhận ổ đĩa, tiến hành cài đặt OS, làm theo các hướng dẫn để cài như bình thường
![Create VM 19](/images/win2k12_standard/win2k12_20.jpg)
![Create VM 20](/images/win2k12_standard/win2k12_21.jpg)

### Bước 9: Sau khi cài xong OS, tắt VM và sửa lại Boot Options, lựa chọn Boot từ Hard Disk và bật máy ảo
![Create VM 21](/images/win2k12_standard/win2k12_22.jpg)

## 2. Xử lý image sau khi đã cài xong OS

### Bước 1: Tạo password administrator cho máy ảo
![Create VM 22](/images/win2k12_standard/win2k12_23.jpg)

### Bước 2: Vào "Device Manager" để update driver cho NIC, cài đặt Baloon network driver để VM nhận card mạng
![Create VM 23](/images/win2k12_standard/win2k12_24.jpg)
![Create VM 24](/images/win2k12_standard/win2k12_25.jpg)
![Create VM 25](/images/win2k12_standard/win2k12_26.jpg)
![Create VM 26](/images/win2k12_standard/win2k12_27.jpg)
![Create VM 27](/images/win2k12_standard/win2k12_28.jpg)

### Bước 3: Kiểm tra lại việc cài đặt Driver cho NIC
![Create VM 28](/images/win2k12_standard/win2k12_29.jpg)

### Bước 4: Cài đặt Baloon driver cho Memory
Copy `/virtio-win-0.1.1/Baloon/2k12R2/amd64` từ CD Drive vào `C:\`
![Create VM 29](/images/win2k12_standard/win2k12_30.jpg)

Chạy CMD, trỏ về thư mục amd64 vừa copy và chạy lệnh:
```
PS C:\Users\Administrator> cd C:\amd64
PS C:\amd6>. \blnsvr.exe -i
```
![Create VM 30](/images/win2k12_standard/win2k12_31.jpg)
Kiểm tra trong services.msc
![Create VM 31](/images/win2k12_standard/win2k12_32.jpg)

### Bước 5: Cài đặt qemu-guest-agent
#### *Chú ý: qemu-guest-agent là một daemon chạy trong máy ảo, giúp quản lý và hỗ trợ máy ảo khi cần (có thể cân nhắc việc cài thành phần này lên máy ảo)*

Vào "Device Manager", chọn update driver cho `PCI Simple Communication Controller`
![Create VM 32](/images/win2k12_standard/win2k12_33.jpg)
![Create VM 33](/images/win2k12_standard/win2k12_34.jpg)
![Create VM 34](/images/win2k12_standard/win2k12_35.jpg)

Kiểm tra lại việc cài đặt Driver cho `PCI Simple Communication Controller`
![Create VM 35](/images/win2k12_standard/win2k12_36.jpg)

Cài đặt qemu-guest-agent cho Windows Server 2k12, vào CD ROM virio và cài đặt phiên bản qemu-ga (ở đây là `qemu-ga-x64`)
![Create VM 36](/images/win2k12_standard/win2k12_37.jpg)

Kiểm tra lại việc cài đặt qemu-guest-agent

`PS C:\Users\Administrator> Get-Service QEMU-GA`

![Create VM 37](/images/win2k12_standard/win2k12_38.jpg)

Kiểm tra lại version của qemu-guest-agent (phải đảm bảo version >= 7.3.2)
![qemu-ga version](/images/win2k12_standard/win2k12_49.jpg)

### Bước 6: Disable Firewall và enable remote desktop
![disable FW](/images/win2k12_standard/win2k12_51.jpg)
![enable RDP](/images/win2k12_standard/win2k12_50.jpg)


### Bước 7: Cài đặt cloud-init bản mới nhất
Download cloud base init cho Windows bản mới nhất tại [đây](https://cloudbase.it/cloudbase-init/)
![Create VM 38](/images/win2k12_standard/win2k12_39.jpg)

Tiến hành cài đặt
![Create VM 39](/images/win2k12_standard/win2k12_40.jpg)
![Create VM 40](/images/win2k12_standard/win2k12_41.jpg)
![Create VM 41](/images/win2k12_standard/win2k12_42.jpg)
![Create VM 42](/images/win2k12_standard/win2k12_43.jpg)

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
Enable Sysprep và shutdown máy

![Create VM 43](/images/win2k12_standard/win2k12_44.jpg)
![Create VM 44](/images/win2k12_standard/win2k12_45.jpg)

## 3.Thực hiện trên Host KVM
### 3.1. Cài đặt bộ libguestfs-tools để xử lý image (nên cài đặt trên Ubuntu OS để có bản libguestfs mới nhất)
```
apt-get install libguestfs-tools -y
```

### 3.2. Dùng lệnh sau để tối ưu kích thước image:
```
virt-sparsify --compress /var/www/ftp/images/win2012x64_standard.img /var/www/ftp/images/win2012x64_standard_shrink.img
```

### 3.3. Upload image lên glance
```
openstack image create Win2k12 --disk-format qcow2 --container-format bare --public < /var/www/ftp/images/win2012x64_standard_shrink.img
```

### 3.4. Kiểm tra việc upload image đã thành công hay chưa

![Create VM 45](/images/win2k12_standard/win2k12_46.jpg)

### 3.5. Chỉnh sửa metadata của image upload
![Create VM 46](/images/win2k12_standard/win2k12_47.jpg)

Thêm 2 metadata là 'hw_qemu_guest_agent' và 'os_type', với giá trị tương ứng là `true` và `windows`, sau đó save lại
![Create VM 47](/images/win2k12_standard/win2k12_48.jpg)

### 3.6. Image đã sẵn sàng để launch máy ảo.

## 4. Thử nghiệm việc đổi password máy ảo (sau đã đã tạo máy ảo)
### Cách 1: sử dụng nova API (lưu ý máy ảo phải đang bật)
Trên node Controller, thực hiện lệnh và nhập password cần đổi

```
root@controller1:# nova set-password win2k12_qemu_ga
New password:
Again:
```
với `win2k12_qemu_ga` là tên máy ảo


### Cách 2: sử dụng trực tiếp libvirt
#### Xác định vị trí máy ảo đang nằm trên node compute nào. VD máy ảo đang sử dụng là `win2k12_qemu_ga`

`root@controller1:# nova show win2k12_qemu_ga`

với `win2k12_qemu_ga` là tên máy ảo

Kết quả:
```
+--------------------------------------+----------------------------------------------------------------------------------+
| Property                             | Value                                                                            |
+--------------------------------------+----------------------------------------------------------------------------------+
| OS-DCF:diskConfig                    | MANUAL                                                                           |
| OS-EXT-AZ:availability_zone          | nova                                                                             |
| OS-EXT-SRV-ATTR:host                 | compute6		                                                                  |
| OS-EXT-SRV-ATTR:hostname             | win2k12-qemu-ga                                                                  |
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
