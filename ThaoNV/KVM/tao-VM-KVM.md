# Hướng dẫn cài máy ảo trên KVM

## Mục lục

###  [1. Cài máy ảo bằng virt-install](#virt-install)

### [2. Cài máy ảo bằng virt-manager](#virt-manager)

### [3. Cài máy ảo bằng webvirt](#webvirt)

### [4. Các tùy chọn card mạng trong máy ảo](#card-mang)

---

### Mô hình

<img src="http://i.imgur.com/ZQnnxHr.png">


### <a name ="virt-install"> 1. Cài máy ảo bằng virt-install </a>

**Tạo VM từ image có sẵn**

- Tải file image (giống file ghost) về để khởi động, ví dụ này sẽ images linux được thu gọn. File được đặt trong thư mục chứa images của KVM (thư mục `/var/lib/libvirt/images`) bằng câu lệnh:

  `cd /var/lib/libvirt/images wget wget https://ncu.dl.sourceforge.net/project/gns-3/Qemu%20Appliances/linux-microcore-3.8.2.img`

- Tạo VM từ images

  ```sh
  sudo virt-install \
      -n VM01 \
      -r 128 \
       --vcpus 1 \
      --os-variant=generic \
      --disk path=/var/lib/libvirt/images/linux-microcore-3.8.2.img,format=qcow2,bus=virtio,cache=none \
      --network bridge=br0 \
      --hvm --virt-type kvm \
      --vnc --noautoconsole \
      --import
  ```

  ​

**Tạo VM từ file ISO**

- ```sh
  virt-install \
   -n myRHELVM1 \
   --description "Test VM with RHEL 6" \
   --os-type=Linux \
   --os-variant=rhel6 \
   --ram=2048 \
   --vcpus=2 \
   --disk path=/var/lib/libvirt/images/myRHELVM1.img,bus=virtio,size=10 \
   --graphics none \
   --cdrom /var/rhel-server-6.5-x86_64-dvd.iso \
   --network bridge:br0
  ```

  ​

**Tạo VM bằng cách tải từ trên internet**

```sh
  virt-install \
  --name template \
  --ram 2048 \
  --disk path=/var/kvm/images/template.img,size=30 \
  --vcpus 2 \
  --os-type linux \
  --os-variant ubuntutrusty \
  --network bridge=br0 \
  --graphics none \
  --console pty,target_type=serial \
  --location 'http://jp.archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/' \
  --extra-args 'console=ttyS0,115200n8 serial'
```

**Những thông số đáng chú ý**

- --name: Tên máy ảo

- --ram: RAM của máy ảo

- --disk path=xxx, size=xxx

  'path=' => nơi lưu file ổ cứng của máy ảo

  'size=' => số lượng file ổ cứng của máy ảo

- --vcpus : số lượng CPU của máy ảo

- --os-type : loại OS

- --os-variant : tên OS

- --network : loại mạng mà VM sử dụng

- --graphics : loại graphics

- --console : loại console

- --location : nơi lưu file cài đặt

- --cdrom nơi chứa file ISO để cài đặt


### <a name ="virt-manager"> 2. Tạo máy ảo bằng virt-manager</a>

- Tiến hành cài đặt công cụ virt-manager để quản lí máy ảo bằng câu lệnh

  `apt-install virt-manager`
  

- Sau khi đã cài đặt virt-manager, tiến hành tải file ISO từ trên mạng internet và để vào thư mục mặc định đó là:

  `/var/lib/libvirt/images/`
  

- Hoặc bạn cũng có thể tải các file image từ internet về và để trong thư mục trên bằng câu lệnh sau:

  ```sh
  cd /var/lib/libvirt/images/

  wget https://ncu.dl.sourceforge.net/project/gns-3/Qemu%20Appliances/linux-microcore-3.8.2.img

  wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
  ```

  Hai file images trên sẽ được dùng để tạo máy ảo mà không cần phải cài từ đầu(giống các file ghost)

- Tiến hành kích hoạt virt-manager bằng câu lệnh:

  `virt-manager`

- Lưu ý: Nếu bạn sử dụng MobaXterm sẽ hỗ trợ Forward X11 mặc định. Trong trường hợp bạn sử dụng Putty, cần tiến hành các bước sau:

  - Tải Xming tại địa chỉ https://sourceforge.net/projects/xming/

  - Cài đặt Xming, trong quá trình cài đặt, để mặc định các tùy chọn

  - Khởi động Xming

  - Khởi động Putty, cấu hình để kích hoạt X11 phía client theo các thao tác `Connection` => `SSH` => `X11` 

    <img src="https://github.com/hocchudong/KVM-QEMU/raw/master/hinhanh/img1.png">

  - Thực hiện nhập IP của máy chủ vào bằng tài khoản root

  - Khởi động virt-manager bằng câu lệnh `virt-manager`

- Sau khi thực hiện lệnh phía trên, một cửa sổ quản lí KVM sẽ hiện ra cho người dùng

  <img src="http://i.imgur.com/B3v0wMa.png">

- Tiến hành tạo máy ảo tại đây bằng cách:

  - Tại cửa sổ `Virtual Machine Manager` chọn `new`

    <img src="http://i.imgur.com/zpoxyRh.png">

  - Nhập tên máy ảo và lựa chọn cách cài máy ảo
    - Nếu bạn cài từ file ISO, hãy chọn `Local install media`

    - Nếu bạn cài từ file images, hãy chọn `Import existing disk image`

    - Hai lựa chọn còn lại dành cho việc cài đặt bằng cách tải từ trên mạng internet

      <img src="http://i.imgur.com/hf2Xebc.png">

  - Ở đây tôi chọn kiểu cài từ file ISO, lựa chọn `Use ISO image` chọn `Browse` để tìm tới file ISO đã có sẵn

    <img src="http://i.imgur.com/dpCkQkI.png">

  - Chọn RAM và CPU cho máy ảo

    <img src="http://i.imgur.com/H6NVdyJ.png">

  - Chọn dung lượng ổ cứng cho máy ảo

    <img src="http://i.imgur.com/9QfbdDn.png">

  - Kết thúc quá trình tạo máy ảo, chọn `Customize configuration before install`để có thể thay đổi những cài đặt trước khi bắt đầu cài OS.

    <img src="http://i.imgur.com/MYY73Dc.png">

  - Tại đây, bạn có thể thay đổi những thông số mà mình đã chọn vd như: RAM, CPU, Card mạng...

    <img src="http://i.imgur.com/ouHbPLX.png">

  - Nhấn `Begin Installation` để bắt đầu
  
  ### <a name ="card-mang"></a> 4. Các tùy chọn card mạng trong máy ảo

Nếu bạn đã quen với VMWare, chắc hẳn bạn sẽ biết trong VMWare có 3 chế độ card mạng đó là Bridge, NAT và Host-only. Tương tự
 như VMWare, các máy ảo của KVM cũng có 3 tùy chọn card mạng đó là NAT, Public Bridge và Private Bridge.

 #### 1. NAT

 - Đây là cấu hình card mạng mặc định của KVM. Cơ chế NAT sẽ cấp cho mỗi VM một địa chỉ IP theo dải mặc định, nó sẽ hoạt động giống với
  một chiếc Router, chuyển tiếp các gói tin giữa những lớp mạng khác nhau trên một mạng lớn. Về mặt logic, ta có thể hiểu nó là 1 bridge riêng biệt và
   nó sẽ giao tiếp với bridge mà card mạng thật kết nối để các máy ảo có thể kết nối ra bên ngoài mạng internet.
  Chúng ta có thể xem dải mạng mặc định mà cơ chế NAT sẽ cấp cho các máy ảo ở trong file:

  `/var/lib/libvirt/network/default.xml`

  <img src="https://raw.githubusercontent.com/nguyenminh12051997/meditech-thuctap/master/MinhNV/KVM/images/natdhcp.PNG">

  - Các card mạng của máy ảo sẽ được gắn vào 1 bridge mặc định (vibr0), bridge này đã có gateway mặc định, các gói tin của máy ảo sẽ đi qua bridge này trước khi được chuyển tới bridge có kết nối từ card mạng thật để ra ngoài internet.
  
  - KVM sẽ cấp DHCP cho các máy dùng chế độ NAT theo dải mặc định, người dùng có thể xem tại file `/var/lib/libvirt/network/default.xml`

  #### 2. Public Bridge

  - Chế độ này sẽ cho phép các máy ảo có cùng dải mạng vật lí với card mạng thật. Để có thể làm được điều này, bạn cần thiết lập 1 bridge
   và cho phép nó kết nối với cổng vật lí của thiết bị thật (eth0).

  - Các bước để cấu hình public bridge:
    <ul>
    <li>Sử dụng câu lệnh `brctl addbr Ten_bridge` để tạo một bridge</li>
    <li>Gán card mạng thật cho bridge đó bằng câu lệnh `brctl addif Ten_bridge Ten_card_mang` .</li>
    <li>Cấu hình cho card mạng trong file: `/etc/network/interfaces` . 
        Tại đây, hãy comment các cấu hình của card mạng vật lý và cấu hình lại cho bridge vừa tạo </li>
    <li>Khởi động lại dịch vụ mạng</li>
    </ul>

  - Sau khi đã cấu hình public bridge, khi tạo máy ảo, bạn chỉ cần chọn chế độ "Bridge br0" là các máy ảo sẽ tự động được nhận các địa chỉ ip trùng với dải địa chỉ của card vật lí.
  
  - Cơ chế cấp DHCP cho các máy ảo sẽ do Router bên ngoài đảm nhận, nhờ vậy nên các VM mới có dải địa chỉ ip trùng với card vật lí bên ngoài.

   #### 3. Private Bridge

   - Chế độ này sẽ sử dụng một bridge riêng biệt để các VM giao tiếp với nhau mà không ảnh hưởng tới địa chỉ của KVM host.
   - Ta có thể tạo ra private bridge bằng cách chỉnh sửa file `/etc/network/interfaces`.
     Tại đây, bạn sẽ không cần phải comment các cấu hình của card vật lý đồng thời không cần thêm tham số `bridge_ports`
     cho bridge.

  - Bạn cũng có thể tạo ra private bridge bằng cách sử dụng virt-manager.
    <ul>
    <li>Trong phần `Edit`, chọn `Connection Details` -> `Virtual Networks`</li>
    <li>Chọn biểu tượng dấu `+`</li>
    <li>Điền tên</li>
    <li>Điền địa chỉ IP</li>
    <li>Chọn `Isolated virtual network` và ấn Finish</li>
    </ul>
  - Khi tạo máy ảo và kết nối tới private bridge, các máy ảo sẽ được cấp phát địa chỉ theo dải IP mà người dùng chọn. Chúng có thể giao tiếp 
  với nhau những không đi ra được internet.
  
 - Một máy ảo có thể được kết nối tới nhiều các private bridge, nhờ vậy nó có thể giao tiếp với nhau.
 
 Mô hình:
 
 <img src="http://i.imgur.com/C3FojzR.png">
 
 Nhờ việc gán nhiều card mạng mà VM ở dải 20.0.0.0 có thể ping tới máy ở dải 10.0.0.0

