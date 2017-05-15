# Tìm hiểu file XML trong KVM

## Mục lục

### [1. Giới thiệu về file XML trong KVM](#gioi-thieu)

### [2. Các thành phần trong file domain XML](#thanh-phan)

### [3. Hướng dẫn tạo máy ảo bằng file XML](#create)

----

### <a name="gioi-thieu"> 1. Giới thiệu về file XML trong KVM </a>

- XML (viết tắt từ tiếng Anh: eXtensible Markup Language, tức "Ngôn ngữ đánh dấu mở rộng") là ngôn ngữ đánh dấu với mục đích chung do W3C đề nghị, để tạo ra các ngôn ngữ đánh dấu khác. Đây là một tập con đơn giản của SGML, có khả năng mô tả nhiều loại dữ liệu khác nhau. Mục đích chính của XML là đơn giản hóa việc chia sẻ dữ liệu giữa các hệ thống khác nhau, đặc biệt là các hệ thống được kết nối với Internet.
- VM trong KVM có hai thành phần chính đó là VM's definition được lưu dưới dạng file XML mặc định ở thư mục `/etc/libvirt/qemu` và VM's storage lưu dưới dạng file image.
- File domain XML chứa những thông tin về thành phần của máy ảo (số CPU, RAM, các thiết lập của I/O devices...)
- libvirt dùng những thông tin này để tiến hành khởi chạy tiến trình QEMU-KVM tạo máy ảo.
- Ngoài domain XML, KVM cũng có các file XML khác để lưu các thông tin liên quan tới network, storage...
- Ví dụ của domain xml:

<img src="http://i.imgur.com/7Uclwv5.png">

### <a name= "thanh-phan"> 2. Các thành phần trong file domain XML </a>

- Thẻ không thể thiếu trong file domain xml là `domain` , Nó có 2 thành phần chính, `type` cho biết hypervisor đang sử dụng, `id` là mã nhận dạng của máy ảo. 

#### Metadata

<img src="http://i.imgur.com/3YJxNDG.png">

- `name` : Tên máy ảo, chỉ bao gồm kí tự chữ và số và không được trùng với những máy ảo đang chạy.
- `uuid` : Mã nhận dạng quốc tế duy nhất cho máy ảo. Format theo RFC 4122. Nếu thiếu trường uuid khi khởi tạo, mã này sẽ được tự động generate.
- `title` : Tiêu đề của máy ảo.
- `description` : Đoạn mô tả của máy ảo, nó sẽ không được libvirt sửa dụng.
- `metadata` : Chứa những thông tin về file xml.

#### Operating system booting

- Có nhiều các để boot máy ảo và mỗi cách lại có những lợi ích và hạn chế riêng. Bài viết này sẽ chỉ đưa ra 2 ví dụ đó là boot từ BIOS và kernel

**BIOS Bootloader**

- Boot thông qua BIOS được hỗ trợ bởi những hypervisors full virtualization. Người dùng sẽ phải thiết lập thứ tự ưu tiên các thiết bị boot.

<img src="http://i.imgur.com/13r0mcN.png">

- `type` : Chỉ ra loại OS được boot để tạo thành VM. `hvm` cho biết OS cần chạy trên "bare metal", yêu cầu full virtualization. `arch` chỉ ra loại kiến trúc CPU dùng để ảo hóa, `machine` chỉ la loại máy sử dụng.
- `boot` : `dev` chỉ ra thiết bị dùng để khởi động. Nó có thể là `fd`, `hd`, `cdrom` hoặc `network`. Nếu có nhiều thiết bị được khai báo, nó sẽ được sắp xếp làm thứ tự ưu tiên.
- `bootmenu` : Chỉ ra có cho khởi động boot menu hay không. Tùy chọn `enable` có giá trị `yes` hoặc `no`. `timeout` là thời gian đợi trước khi sử dụng chế độ mặc định.


**Direct kernel boot**

<img src="http://i.imgur.com/5mhTKYx.png">

- `loader` : `readonly` có giá trị `yes` hoặc `no` chỉ ra file image writable hay readonly. `type` có giá trị `rom` hoặc `pflash` chỉ ra nơi guest memory được kết nối.
- `kernel` : đường dẫn tới kernel image trên hệ điều hành máy chủ
- `initrd`: đường dẫn tới ramdisk image trên hđh máy chủ
- `cmdline`: xác định giao diện điều khiển thay thế

#### CPU Allocation

<img src="http://i.imgur.com/7bmcuzn.png">

**vcpu**

- `cpuset`: danh sách các cpu vật lí mà máy ảo sử dụng
- `current` : chỉ định cho phéo kích hoặt nhiều hơn số cpu đang sử dụng
- `placement`: vị trí của cpu, giá trị bao gồm `static` và `dynamic`, trong đó `static` là giá trị mặc định

**vcpus**

- Trạng thái của từng cpu cụ thể

#### Memory Allocation

<img src="http://i.imgur.com/FnnpqXC.png">

**memory**

- Dung lượng RAM tối đa ở thời điểm khởi động.
- `unit` : đơn vị, mặc định là `KiB` (kibibytes = 1024 bytes), có thể sử dụng `b` (bytes), `KB` (Kilobytes = 1000 bytes), `MB` (Megabytes = 1000000 bytes), `M` hoặc `MiB` (Mebibytes = 1,048,576 bytes), `GB` (gigabytes = 1,000,000,000 bytes), `G` hoặc `GiB` (gibibytes = 1,073,741,824 bytes), `TB` (terabytes = 1,000,000,000,000 bytes), `T` hoặc `TiB` (tebibytes = 1,099,511,627,776 bytes)
- `maxMemory` : Dung lượng RAM tối đa có thể sử dụng
- `currentMemory` : Dung lượng RAM thực tế đang được sử dụng

#### Events configuration

<img src="http://i.imgur.com/0fi8Vne.png">

- `on_poweroff` : Hành động được thực hiện khi người dùng yêu cầu tắt máy
- `on_reboot`: Hành động được thực hiện khi người dùng yêu cầu reset máy
- `on_crash` : Hành động được thực hiện khi có sự cố
- Những hành động được phép thực thi:
  <ul>
  <li>destroy : Chấm dứt và giải phóng tài nguyên</li>
  <li>restart : Chấm dứt rồi khởi động lại giữ nguyên cấu hình</li>
  <li>preserve : Chấm dứt nhưng dữ liệu vẫn được lưu lại</li>
  <li>rename-restart : Khởi động lại với tên mới</li>
  </ul>

- `destroy` và `restart` được hỗ trợ trong cả `on_poweroff` và `on_reboot`. `preserve` dùng trong `on_reboot`, `rename-restart` dùng trong `on_poweroff`
- `on_crash` hỗ trợ 2 hành động: 
  <ul>
  <li>coredump-destroy: domain bị lỗi sẽ được dump trước khi bị chấm dứt và giải phóng tài nguyên </li>
  <li>coredump-restart: domain bị lỗi sẽ được dump trước khi được khởi động lại với cấu hình cũ</li>
  </ul>


#### Hypervisor features

<img src="http://i.imgur.com/CGMbPMb.png">

- `pae` : Chế độ mở rộng địa chỉ vật lí cho phép sử dụng 32 bit để lưu trữ tới hơn 4GB bộ nhớ.
- `acpi` : Được sử dụng để quản lí nguồn điện
- `apic`: Sử dụng cho quản lí IRQ 
- `hap` : Bật/tắt chết độ phần cứng hỗ trợ, mặc định nó sẽ bật.

#### Time keeping

**Clock**

<img src="http://i.imgur.com/ZtRqYNb.png">

- `offset` : giá trị `utc`, `localtime`, `timezone` và `variable`

#### Devices

**emulator**

<img src = "http://i.imgur.com/oF6iyrE.png">

- Đường dẫn tới thiết bị mô phỏng nhị phân. Trong KVM, đó là `/usr/bin/kvm`

**Hard drives, floppy disks, CDROMs**

**1. Disk**

<img src="http://i.imgur.com/X3Vq6fi.png">

- `disk` : Mô tả ổ đĩa, bao gồm các giá trị:
  <ul>
  <li>type : kiểu ổ đĩa, có thể chọn "file", "block", "dir", "network" hoặc "volume"</li>
  <li>device : Cách ổ đĩa tiếp xúc với hệ điều hành. Các giá trị có thể chọn là "floppy", "disk", "cdrom", "lun". Giá trị mặc định là "disk".</li>
  <li>snapshot : Chọn chế độ mặc định của ổ đĩa khi snapshot. Các giá trị ở đây là "internal", "external" và "no" </li>
  </ul>
  
- `source` : 
  <ul>
  <li>file : Đường dẫn tới ổ đĩa</li>
  <li>dir: Đường dẫn tới thư mục chứa ổ đĩa</li>
  </ul>
  
- `target` : 
  <ul>
  <li>dev : tên loại ổ đĩa, ví dụ: vda, hda...</li>
  <li>bus : xác định loại thiết bị ổ đĩa để mô phỏng, các giá trị : "ide", "scsi", "virtio", "xen", "usb", "sata", or "sd" "sd"</li>
  </ul>
  
- `driver` : 
  <ul>
  <li>name: tên trình điều khiển hỗ trợ, ở đây mặc định sẽ là "qemu"</li>
  <li>type : "dự bị" cho "name" ở trên, các giá trị có thể chọn : "raw", "bochs", "qcow2", và "qed"</li>
  </ul>
  
- `address`: 
  <ul>
  <li>type : Loại controller, có thể chọn "pci" hoặc "drive", đối với "drvie", các giá trị "controller", "bus", "target", và "unit" sẽ được mặc định thêm vào và có giá trị là 0</li>
  </ul>
  
**2. Controller**

<img src="http://i.imgur.com/AsSZMgr.png">

- Tùy thuộc vào cấu trúc của máy ảo mà nó có thể có các thiết bị ảo đi kèm, mỗi cái lại đi theo một bộ điều khiển. Thường thì libvirt sẽ tự động chỉ ra mà không cần khai báo qua file xml.
- Mỗi bộ điều khiển có một tham số bắt buộc là `type` và `index`, các giá trị có thể chọn của `type` là: 'ide', 'fdc', 'scsi', 'sata', 'usb', 'ccid', 'virtio-serial' hoặc 'pci'. Trong khi đó `index` sẽ chỉ ra thứ tự ưu tiên.

**Network interfaces**

- Có một vài kiểu set up network ví dụ như Virtual network (type = network), Bridge to LAN (type = bridge), Userspace SLIRP stack (type=user). Ở đây tôi sẽ nói về Bridge to LAN.

<img src="http://i.imgur.com/pDY2H6N.png">

- `source` : tham số bắt buộc là "bridge":  tên bridge
- `mac` : tham số bắt buộc là "address": địa chỉ mac
- `model` : tham số bắt buộc là "type", các giá trị thường được sử dụng trong KVM: "ne2k_isa, i82551, i82557b, i82559er, ne2k_pci, pcnet, rtl8139, e1000, virtio"
- Cài IP tĩnh:

<img src="http://i.imgur.com/rAxciL5.png">

**Input devices**

<img src="http://i.imgur.com/sKoRlrd.png">

- Chỉ có 1 tham số bắt buộc đó là `type`, các giá trị có thể chọn là 'mouse', 'tablet',  'keyboard' hoặc 'passthrough'. Tham số `bus` để xác định chính xác thiết bị, các giá trị có thể chọn là "xen" (paravirtualized), "ps2", "usb" và "virtio".

**Graphical framebuffers**

<img src="http://i.imgur.com/UjBi3XA.png">

- `graphic` : Thuộc tính bắc buộc là type, các giá trị có thể chọn : "sdl", "vnc", "spice", "rdp" và "desktop". Đối với mỗi loại sẽ có thêm những tham số được thêm vào. 

**Video devices**

<img src="http://i.imgur.com/cOWbMOJ.png">

- `model`  : Tham số bắt buộc là "type", các giá trị có thể lựa chọn là  "vga", "cirrus", "vmvga", "xen", "vbox", "qxl", "virtio" và "gop", tùy thuộc vào hypervisor.
  <ul>
  <li>`heads` : số lượng màn hình</li>
  <li>`ram` và `vram` chỉ ra kích thước của primary và secondary bar</li>
  </ul>
  
**Guest interface**

- serial port:

<img src = "http://i.imgur.com/5UGmz09.png">

- console:

Nếu không có `target type` được chọn , mặc định trong KVM sẽ sử dụng `serial`.

<img src="http://i.imgur.com/qCm9QGP.png">

**Sound devices**

<img sc="http://i.imgur.com/vRZvl1W.png">

- `sound` : tham số bắt buộc là `model`, các giá trị có thể chọn : 'es1370', 'sb16', 'ac97', 'ich6' và 'usb'

**Memory balloon device**

<img src="http://i.imgur.com/3ftef3k.png">

- Được thêm tự động, mặc định với KVM, `model` sẽ là `virtio`

**Trên đây chỉ là một số thành phần chính trong file domain xml của KVM, các bạn tham khảo thêm [Domain XML format](http://libvirt.org/formatdomain.html#elementsDevices)**

### <a name = "create"> 3. Hướng dẫn tạo máy ảo bằng file XML </a>

**Bước 1: Chuẩn bị file xml**

- Dưới đây là file mà tôi sẽ sử dụng 

``` sh
<domain type='kvm'>
  <name>thao</name>
  <uuid>56b802be-24e1-11e7-bbb3-1c1b0d6d34d8</uuid>
  <memory>1048576</memory>
  <currentMemory>1048576</currentMemory>
  <vcpu>1</vcpu>
  <os>
    <type>hvm</type>
    <boot dev='cdrom'/>
  </os>
  <features>
    <acpi/>
  </features>
  <clock offset='utc'/>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/bin/kvm</emulator>
    <disk type="file" device="disk">
      <driver name="qemu" type="raw"/>
      <source file="/var/lib/libvirt/images/thao.img"/>
      <target dev="vda" bus="virtio"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x04" function="0x0"/>
    </disk>
    <disk type="file" device="cdrom">
      <driver name="qemu" type="raw"/>
      <source file="/var/lib/libvirt/images/ubuntu-14.04.4-server-amd64.iso"/>
      <target dev="hdc" bus="ide"/>
      <readonly/>
      <address type="drive" controller="0" bus="1" target="0" unit="0"/>
    </disk>
    <interface type='bridge'>
      <source bridge='br0'/>
      <mac address="52:54:00:29:8f:4e"/>
    </interface>
    <controller type="ide" index="0">
      <address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x1"/>
    </controller>
    <input type='mouse' bus='ps2'/>
    <graphics type='vnc' port='-1' autoport="yes" listen='0.0.0.0'/>
    <console type='pty'>
      <target port='0'/>
    </console>
  </devices>
</domain>
```

- file domain xml phía trên sẽ tạo ra máy ảo với những thông số sau:
  <ul>
  <li>1 GB RAM, 1 vCPU, 1 ổ đĩa</li>
  <li>Đường dẫn tới ổ đĩa: /var/lib/libvirt/images/thao.img</li>
  <li>Máy ảo được boot từ CDROM (/var/lib/libvirt/images/ubuntu-14.04.4-server-amd64.iso)</li>
  <li>Sử dụng Linux Bridge br0</li>
  </ul>
  
- Đối với mã uuid, các bạn có thể download package `uuid` về rồi sử dụng câu lệnh `uuid` để generate đoạn mã uuid:

<img src="http://i.imgur.com/PLdQUQX.png">

- Ngoài ra, bạn cũng có thể tạo ra file xml bằng việc dump từ một máy ảo đang chạy bằng câu lệnh `virsh dumpxml vm01 > vm02.xml`

**Bước 2: Tạo ổ đĩa**

- Dùng câu lệnh `qemu-img create -f raw /var/lib/libvirt/images/thao.img 10G` để tạo ổ đĩa có dung lượng 10GB với định dạng raw.

<img src="http://i.imgur.com/RIhCE6B.png">

**Bước 3: Khởi tạo máy ảo**

- Dùng câu lệnh `virsh start VMname.xml` để khởi tạo máy ảo:

<img src="http://i.imgur.com/hDTPA0h.png">

- Kiểm tra xem máy ảo đã được tạo hay chưa bằng câu lệnh `virsh list`

<img src="http://i.imgur.com/L290umb.png">

- Sử dụng virt-manager để quản lí máy ảo:

<img src="http://i.imgur.com/7wA7MUe.png">


**Link tham khảo**

1. http://libvirt.org/formatdomain.html#elementsDevices
2. https://websetnet.com/kvm-command-line-debian-ubuntu/
