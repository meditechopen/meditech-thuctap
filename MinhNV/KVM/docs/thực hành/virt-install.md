# 1.1 Sử dung virt install để tạo máy ảo 

Tải gói phụ trợ: 

```sudo apt-get install virtinst```

## Tạo máy ảo bằng file image 

- Tải file image (giống như file ghost) về để khởi động, ví dụ này sẽ images linux được thu gọn. File được đặt trong thư mục chứa images của KVM ( /var/lib/libvirt/images)

- Di chuyển vào thư mục chứ file images

``cd /var/lib/libvirt/images``

- Tải file images về 

``wget https://ncu.dl.sourceforge.net/project/gns-3/Qemu%20Appliances/linux-microcore-3.8.2.img``

- Sử dụng virt install để tạo máy ảo 

```sh 
sudo virt-install \
     -n VM01 \ 
     -r 128 \ 
      --vcpus 1 \ số cpu 
     --os-variant=generic \ 
     --disk path=/var/lib/libvirt/images/linux-microcore-3.8.2.img,format=qcow2,bus=virtio,cache=none \ 
     --network brigde=br0 \
     --hvm --virt-type kvm \
     --vnc --noautoconsole \
     --import
```

Trong đó:

- n: tên máy ảo
- r: bộ nhớ ram
- vcpu là số cpu
- os variant : các tùy chon cho hệ điều hành
- disk path: đường đẫn đến file img trong máy
- hvm: sử dụng đầy đủ các tính năng ảo hóa
- brigde: tên Linux brigde đã cấu hình
- vnc: đưa ra giao diện ảo vnc để điều khiển VM .
- noautoconsole: không tự động kết nối tới guest console

## 1.2 Tạo máy ảo bằng file iso 

```sh 
virt-install --name vmname --ram 1024 --vcpus=1 \
--disk path=/var/lib/libvirt/images/vmname.img,size=20,bus=virtio \
--network bridge=br0 \
--cdrom /home/tannt/ubuntu-14.04.4-server-amd64.iso \
--console pty,target_type=serial --hvm \
--os-variant ubuntutrusty --virt-type=kvm --os-type Linux
```
VD: 

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/virt(iso).PNG?raw=true">

- Ở đây mình không thêm câu lệnh ``--graphics none`` để có thể dùng phần mềm đồ họa virt manager quản lý máy ảo 
- Bước tiếp theo bạn dùng virt manager để cài hệ điều hành cho máy ảo

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/virtisso.PNG?raw=true">

- Tham khảo cách cài đặt <a href="https://github.com/nguyenminh12051997/MediTech/blob/master/install_ubuntu_server.md">Ubuntu14.04</a>


## 1.3 Tạo máy ảo bằng cách tải trực tiếp các gói trên mạng về để cài đặt

```sh
virt-install \
--name template \
--ram 1024\
--disk path=/var/kvm/images/template.img,size=20 \
--vcpus 1 \
--os-type linux \
--os-variant ubuntutrusty \
--network bridge=br0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://jp.archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/' \
--extra-args 'console=ttyS0,115200n8 serial'
```
VD: 
- Trên máy KVM sử dụng lệnh

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/virtdown.PNG?raw=true">

- Đây là đường dẫn link tải trực tiếp file cài đặt <a href="http://jp.archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/">Ubuntu14.04</a>

Nguồn  <a href="https://www.server-world.info/en/note?os=Ubuntu_14.04&p=kvm&f=2">server-world</a>

- Tiếp đó màn hình hiển thị như sau 

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/KVM/images/virtdownss.PNG?raw=true">

- Tới bước này mình cài đặt hệ điều hành giống các bước cài đặt Ubuntu 14.04. Tham khảo cách cài đặt <a href="https://github.com/nguyenminh12051997/MediTech/blob/master/install_ubuntu_server.md">Ubuntu14.04</a>


