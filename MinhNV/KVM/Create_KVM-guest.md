# Cài đặt KVM-guest

## Có 3 cách cài đặt:
- Sử dụng giao diện dòng lệnh ( công cụ Virsh CLI)
- Sử dụng giao diện đồ họa ( công cụ Virtual Machine Manager)
- Sử dụng giao diện web ( công cụ webvirMgr)
## Sử dụng giao diện dòng lệnh để cài đặt KVM-guest
- Làm việc với KVM chúng ta sẽ sử dụng libvirt. Libvirt là một framework/API mã nguồn mở giúp quản lý nhiều hypervisor và máy ảo

- Trong VMware virtualization, bạn sẽ biết VMware-base VM có 2 thành phần chính:

 - VM definition, lưu trữ trong file .VMX
 - VM's storage, lưu trữ trong một hoặc nhiều file .VMDK
- Từ đó tôi có thể xác định KVM guest cũng có 2 thành phần chính:

 - VM definition, xác định trong định dạng XML
 - VM's storage, lưu trữ trong một volume manage bởi LVM hoặc một file lưu trong hệ thống
- Bạn có thể tìm thấy cấu hình XML của một KVM guest theo 2 cách, cả 2 cách đều sử dụng lệnh virsh là một phần của libvirt
 - Sửa file cầu hình của một guest, sử dụng virsh edit <Name of guest VM>, hệ thống sẽ mở file XML trong cửa sổ đang làm việc - Xuất file cấu hình của guest, sử dụng lệnh virsh dumpxml <Name of guest VM>, lệnh này sẽ dump file cấu hình XML ra STDOUT, bạn có thể chuyển nó vào file nếu muốn.
 - Thành phần thứ 2 của KVM guest là storage; như đã nhắc ở trên, cái này có thể là một file trong hệ thống hoặc có thể là một volume managed với một logical volume manager (LVM)
 - Sửa file cầu hình của một guest, sử dụng virsh edit <Name of guest VM>, hệ thống sẽ mở file XML trong cửa sổ đang làm việc
Xuất file cấu hình của guest, sử dụng lệnh virsh dumpxml <Name of guest VM>, lệnh này sẽ dump file cấu hình XML ra STDOUT, bạn có thể chuyển nó vào file nếu muốn.

Sử dụng lệnh ``apt-get install virtinst`` để tải gói phụ trợ về máy.

- Tạo VM bằng các cài đặt img có sẵn

 - Tải file image (giống như file ghost) về để khởi động, ví dụ này sẽ images linux được thu gọn. File được đặt trong thư mục chứa images của KVM ( ``/var/lib/libvirt/images``)

``sh
cd /var/lib/libvirt/images

wget wget https://ncu.dl.sourceforge.net/project/gns-3/Qemu%20Appliances/linux-microcore-3.8.2.img

 ``

img src="http://i.imgur.com/4vowYDx.png">

- Tạo VM từ IMG:
``sh
sudo virt-install \
     -n VM01 \
     -r 128 \
      --vcpus 1 \
     --os-variant=generic \
     --disk path=/var/lib/libvirt/images/linux-microcore-3.8.2.img,format=qcow2,bus=virtio,cache=none \
     --network brigde=br0 \
     --hvm --virt-type kvm \
     --vnc --noautoconsole \
     --import
``

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

Kiểm tra các máy ảo VM: ``virsh list --all``

<img src="http://i.imgur.com/6sGe5oQ.png">














-
