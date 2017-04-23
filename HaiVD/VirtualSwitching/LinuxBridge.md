# **Tìm hiểu về Linux Bridge**
------------------------------------------
# Mục lục
## [I. Giới thiệu Linux Bridge](#gt)
### [1.1 Khái niệm](#11)
### [1.2 Chức năng](#12)
### [1.3 Cấu trúc](#13)
## [II. Thiết lập Linux Bridge](#tl)
### [2.1 Cài đặt](#21)
### [2.2 Các tùy chọn quản lý](#22)
## [III Thực hành Lab](#lab)


<a name=gt></a>
## I. Giới thiệu về Linux Bridge

<a name=11></a>
### 1.1 Khái niệm
- Linux Bridge là một trong ba công nghệ cung cấp giải pháp switch ảo cho Linux,nhằm giải quyết các vấn đề về ảo hóa Network trong nhân linux.
- Bản chất của Linux Bridge là tạo ra các Switch ảo ( chức năng tương tự như Switch thật) nhằm kết nối các máy ảo với nhau và có thể giao tiếp với mạng Internet thông qua máy thật.
- Linux bridge thường sử dụng kết hợp với hệ thống ảo hóa KVM-QEMU.

<a name=12></a>
### 1.2 Chức năng
- STP: Spanning Tree Protocol - giao thức chống lặp gói tin trong mạng
- VLAN: chia switch (do linux bridge tạo ra) thành các mạng LAN ảo, cô lập traffic giữa các VM trên các VLAN khác nhau của cùng một switch.
- FDB (forwarding database): chuyển tiếp các gói tin theo database để nâng cao hiệu năng switch. Database lưu các địa chỉ MAC mà nó học được. Khi gói tin Ethernet đến, bridge sẽ tìm kiếm trong database có chứa MAC address không. Nếu không, nó sẽ gửi gói tin đến tất cả các cổng.

<a name=13></a>
### 1.3 Cấu trúc
- Hình sau mô tả sự khác nhau giữa một máy vật lý không thiết lậ Linux Bridge và môt máy thiết lập Linux Bridge :

<img src=http://i.imgur.com/UorJBSp.png>
- Khi một máy vật lý thiết lập chết độ Linux Bridge thì các kết nối giữa các máy ảo trong máy vật lý đó sẽ phải thông qua Switch ảo đã tạo (ở trong hình Switch ảo tên là br0).Br0 có thể được đi ra ngoài Internet nhờ chuyển tiếp đến cổng eth0 hoặc eth1 của máy vật lý.
- Mô hình sau mô tả rõ hơn về Linux Bridge được triển khai kèm với KVM-QEMU :

<img src=http://i.imgur.com/Ve30A3U.png>

- Kiến trúc gồm :
  <ul>
  <li>`Port`: tương đương với port của switch thật</li>
  <li>`Bridge`: bridge ảo tương đương với switch vật lý layer 2 </li>
  <li>`Tap`: hay tap `interface` có thể hiểu là giao diện mạng để các VM kết nối với bridge cho linux bridge tạo ra</li>
  <li>`fd`: forward data - chuyển tiếp dữ liệu từ máy ảo tới bridge</li>
  </ul>

<a name=tl></a>
## II. Thiết lập Linux Bridge

<a name=21></a>
### 2.1 Cài đặt
  Có thể cài đặt Linux Bridge theo 2 cách :
- Cách 1 :

```
sudo apt-get install bridge-utils
```
- Cách 2 :

```
$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/bridge-utils.git
$ cd bridge-utils
$ autoconf
$ ./configure
```

<a name=22></a>
### 2.2 Các tùy chọn quản lý :
Để tạo, xóa, gán, bỏ gán hay thiết lập các tính năng nâng cao :


- Tạo 1 Logic Switch Bridge tên là "bridgename" :

```
brctl addbr bridgename
```

- Lệnh xóa tương ứng :

```
brctl delbr bridgename
```
- Thêm một thiết bị  vào Bridge :

```
brctl addif bridgename device
```
- Xóa một thiết bị khỏi Bridge :

```
brctl delif//bridgename// //device//
```
- Hiển thị các thiết bị được thêm vào trong Bridge :

```
brctl show
```
- Hiển thị thông tin về  thời gian gói tin được giữ trong địa chỉ MAC :

```
brctl showmacs bridgename
```
- Sử dụng Spanning Tree khi chạy nhiều Bridge hoặc dư thừa Bridge :

```
brctl stp bridgename on
```
- Thiết lập thông số  Bridge priority (Chỉ số mức độ ưu tiên ): mỗi Bridge có một mức độ ưu tiên. Port nào có chỉ số priority cao hơn thì khi máy ảo gắn bridge đó vào thì nó sẽ nhận được IP của port có priority cao hơn.

```
brctl setportprio bridgename Number_port Number_priority
```

<a name=lab></a>
## III. Thực hành, Lab

- Mô hình :

<img src=http://i.imgur.com/d0B5kBo.png>

- Trường hợp 1: Tạo một switch ảo và gán interface eth1 vào switch đó, tạo một máy ảo bên trong máy host, gắn vào tap interface của switch và kiểm tra địa chỉ được cấp phát. (Có thể tạo 2 VM trong host cùng gắn vào tap interface của switch, ping kiểm tra kết nối).
- Trường hợp 2: Gắn cả 2 card mạng eth1, eth2 của host vào switch ảo, set priority cho hai port ứng với 2 card. Kiểm tra xem máy ảo (gắn vào tap interface của switch ảo) nhận ip cùng dải với card mạng vật lý nào.

**Trường hợp 1 :**
 - Bước 1: Tạo switch ảo tên là haikma
 ```
 brctl addbr haikma
 ```
 - Bước 2 : Gán port eth1 vào switch haikma
 ```
 brctl addif haikma eth1
 ```
 - Bước 3 : Chỉnh file cấu hình thêm :
  ```
  auto haikma
  iface haikma inet dhcp
  bridge_ports eth1
  bridge_stp on
  bridge_fd 0
  bridge_maxwait 0
  ```

- Bước 4 : Khởi động lại card mạng
  ```
  ifdown -a && ifup -a
  ```
- Xem kết quả :
```
bridge name	bridge id		STP enabled	interfaces
haikma		8000.000c29586f2e	yes		eth1
lxcbr0		8000.000000000000	no
virbr0		8000.000000000000	yes
```

**Trường hợp 2 :**  gắn thêm cổng eth0 vào bridge haikma. Đông thời thiết lập mức độ ưu tiên cho cả 2 port :


 ```
 brctl addif haikma eth0

 # Thiết lập mức ưu tiên cho các port
 brctl setportprio haikma eth1 1
 brctl setportprio haikma eth0 2
 ```
- Trong bài lab này, card eth1 thuộc dải mạng 10.10.10.0/24 và card eth0 thuộc dải mạng 10.0.2.0/24. Như vậy VM sẽ nhận IP thuộc dải 10.0.2.0/24
