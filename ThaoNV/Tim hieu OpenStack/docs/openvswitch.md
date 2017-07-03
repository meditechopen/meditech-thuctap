# Tìm hiểu Open vSwitch

## Mục lục

1. Giới thiệu về SDN (Software Defined Networking) và Open Flow

2. Giới thiệu Open vSwitch

3. Những hạn chế khi sử dụng Linux Bridge - So sánh Open vSwitch và Linux Bridge

4. Cấu trúc của Open vSwitch

5. Hướng dẫn cài đặt KVM với Open vSwitch

6. Một vài câu lệnh với Open vSwitch

--------

## 1. Giới thiệu về SDN (Software Defined Networking) và Open Flow

**SDN (Software Defined Networking)**

SDN (Software Defined Networking) hay mạng điều khiển bằng phần mềm là một kiến trúc đem tới sự tự động, dễ dàng quản lí, tiết kiệm chi phí và có tính tương thích cao, đặc biệt phù hợp với những ứng dụng yêu cầu tốc độ băng thông cũng như sự tự dộng ngày nay. Kiến trúc này tách riêng hai chức năng là quản lí và truyền tải dữ liệu. SDN dựa trên giao thức luồng mở (Open Flow) và là kết quả nghiên cứu của Đại học Stanford và California Berkeley. SDN tách định tuyến và chuyển các luồng dữ liệu riêng rẽ và chuyển kiểm soát luồng sang thành phần mạng riêng có tên gọi là thiết bị kiểm soát luồng (Flow Controller).

Tóm lại có 3 ý chính đối với SDN đó là:

- Tách biệt phần quản lí (control plane) với phần truyền tải dữ liệu (data plane).
- Các thành phần trong network có thể được quản lí bởi các phần mềm được lập trình chuyên biệt.
- Tập trung vào kiểm soát và quản lí network.

Cùng quay trở lại quá khứ, khi mà người ta vẫn sử dụng Ethernet Hub. Về bản chất, thiết bị này chỉ làm công việc lặp đi lặp lại đó là mỗi khi nhận dữ liệu, nó lại forward tới tất cả các port mà nó kết nối.

Tuy nhiên điều này có thể gây nên nhiều hệ lụy xấu như broadcast storms, bandwidth bị giảm và looping (lụt). Kiểu truyền tải dữ liệu này được gọi là Data Plane/Forwarding Plane. Đó là lí do vì sao nó nhanh chóng bị thay thế bởi thiết bị layer 2 hay còn được biết tới với cái tên Network Switch. Thiết bị này về cơ bản đã "thông minh" hơn rất nhiều khi mà nó biết gửi dữ liệu tới đúng interface, và từ đây khái niệm control plane cũng bắt đầu xuất hiện.

Các thiết bị mạng đều có sự xuất hiện của control plane, nó cung cấp thông tin để xây lên bảng kết nối giúp các thiết bị mạng biết được chính xác nơi cần gửi dữ liệu.

<img src="http://i.imgur.com/lleKL7G.png">

Dưới đây là mô hình của kiến trúc SDN

<img src="http://i.imgur.com/0f19CtI.png">

Nhìn chung, SDN có 3 phần chính đó là:

- Network infrastructure: Bao gồm các thiết bị mạng như router, switch, bao gồm cả thiết bị ảo và thật.
- Controller: Bao gồm phần mềm dựa trên bộ điều khiển tập trung, có thể đặt trên server để giao tiếp với tất cả các thiết bị mạng bằng cách sử dụng API như OpenFlow hoặc OVMDB.

- Applications: Bao gồm hàng loạt các ứng dụng có sự tồn tại của network. Các ứng dụng này có thể nói chuyện với controller sử dụng API để thực hiện những yêu cầu.

**Open Flow**

OpenFlow là tiêu chuẩn đầu tiên, cung cấp khả năng truyền thông giữa các giao diện của lớp điều khiển và lớp chuyển tiếp trong kiến trúc SDN. OpenFlow cho phép truy cập trực tiếp và điều khiển mặt phẳng chuyển tiếp của các thiết bị mạng như switch và router, cả thiết bị vật lý và thiết bị ảo, do đó giúp di chuyển phần điều khiển mạng ra khỏi các thiết bị chuyển mạch thực tế tới phần mềm điều khiển trung tâm.
Các quyết định về các luồng traffic sẽ được quyết định tập trung tại OpenFlow Controller giúp đơn giản trong việc quản trị cấu hình trong toàn hệ thống.
Một thiết bị OpenFlow bao gồm ít nhất 3 thành phần:

- Secure Channel: kênh kết nối thiết bị tới bộ điều khiển (controller), cho phép các lệnh và các gói tin được gửi giữa bộ điều khiển và thiết bị.
- OpenFlow Protocol: giao thức cung cấp phương thức tiêu chuẩn và mở cho một bộ điều khiển truyền thông với thiết bị.
- Flow Table: một liên kết hành động với mỗi luồng, giúp thiết bị xử lý các luồng.

<img src="http://i.imgur.com/t4SOR63.png">


## 2. Giới thiệu OpenvSwitch

Open vSwitch là switch ảo mã nguồn mở theo giao thức OpenFlow. Nó là một multilayer software được viết bằng ngôn ngữ C cung cấp cho người dùng các chức năng quản lí network interface.

Open vSwitch rất phù hợp với chức năng là một switch ảo trong môi trường ảo hóa. Nó hỗ trợ rất nhiều nền tảng như Xen/XenServer, KVM, và VirtualBox.

Các chức năng của Open vSwitch:

- Standard 802.1Q VLAN model with trunk and access ports
- NIC bonding with or without LACP on upstream switch
- NetFlow, sFlow(R), and mirroring for increased visibility
- QoS (Quality of Service) configuration, plus policing
- Geneve, GRE, VXLAN, STT, and LISP tunneling
- 802.1ag connectivity fault management
- OpenFlow protocol support
- Transactional configuration database with C and Python bindings
- High-performance forwarding using a Linux kernel module

## 3. Những hạn chế khi sử dụng Linux Bridge - So sánh OpenvSwitch và Linux Bridge

**Hạn chế của Linux Bridge**

Linux Bridge (LB) là cơ chế ảo hóa mặc định được sử dụng trong KVM. Nó rất dễ dàng để cấu hình và quản lí tuy nhiên nó vốn không được dùng cho mục đích ảo hóa vì thế bị hạn chế một số các chức năng.

LB không hỗ trợ tunneling và OpenFlow protocols. Điều này khiến nó bị hạn chế trong việc mở rộng các chức năng. Đó cũng là lí do vì sao  Open vSwitch xuất hiện.

Dưới đây là bảng so sánh giữa hai công nghệ này:

| Open vSwitch | Linux bridge |
|--------------|--------------|
| Được thiết kế cho môi trường mạng ảo hóa | Mục đích ban đầu không phải dành cho môi trường ảo hóa |
| Có các chức năng của layer 2-4 | Chỉ có chức năng của layer 2 |
| Có khả năng mở rộng | Bị hạn chế về quy mô |
| ACLs, QoS, Bonding | Chỉ có chức năng forwarding |
| Có OpenFlow Controller | Không phù hợp với môi trường cloud |
| Hỗ trợ netflow và sflow | Không hỗ trợ tunneling |

**OVS**

- Ưu điểm: các tính năng tích hợp nhiều và đa dạng, kế thừa từ linux bridge. OVS hỗ trợ ảo hóa lên tới layer4. Được sự hỗ trợ mạnh mẽ từ cộng đồng. Hỗ trợ xây dựng overlay network.

- Nhược điểm: Phức tạp, gây ra xung đột luồng dữ liệu

**LB**

- Ưu điểm:

các tính năng chính của switch layer được tích hợp sẵn trong nhân. Có được sự ổn định và tin cậy, dễ dàng trong việc troubleshoot
Less moving parts: được hiểu như LB hoạt động 1 cách đơn giản, các gói tin được forward nhanh chóng

- Nhược điểm:

để sử dụng ở mức user space phải cài đặt thêm các gói. VD vlan, ifenslave. Không hỗ trợ openflow và các giao thức điều khiển khác.
không có được sự linh hoạt


## 4. Các thành phần và kiến trúc của Open vSwitch

Các thành phần chính của Open vSwitch:

- ovs-vswitchd :  daemon tạo ra switch, nó được đi kèm với Linux kernel module
- ovsdb-server : Một máy chủ cơ sở dữ liệu nơi ovs-vswitchd truy vấn để có được cấu hình.
- ovs-dpctl : công cụ để cấu hình switch kernel module.
- ovs-vsctl : Dùng để truy vấn và cập nhật cấu hình cho ovs-vswitchd.
- ovs-appctl : Dùng để gửi câu lệnh chạy Open vSwitch daemons.

<img src="http://i.imgur.com/BveiREY.jpg">

**Cơ chế hoạt động**

Nhìn chung Open vSwitch được chia làm phần, Open vSwitch kernel module (Data Plane) và user space tools (Control Plane).

OVS kernel module sẽ dùng netlink socket để tương tác với vswitchd daemon để tạo và quản lí số lượng OVS switches trên hệ thống local. SDN Controller sẽ tương tác với vswitchd sử dụng giao thức OpenFlow. ovsdb-server chứa bảng dữ liệu. Các clients từ bên ngoài cũng có thể tương tác với ovsdb-server sử dụng json rpc với dữ liệu theo dạng file JSON.

Open vSwitch có 2 modes, normal và flow:
- Normal Mode: Ở mode này, Open vSwitch tự quản lí tất cả các công việc switching/forwarding. Nó hoạt động như một switch layer 2.

- Flow Mode: Ở mode này, Open vSwitch dùng flow table để quyết định xem port nào sẽ nhận packets. Flow table được quản lí bởi SDN controller nằm bên ngoài.

<img src="http://i.imgur.com/G4PxNjC.png">

## 5. Hướng dẫn cài đặt KVM với OpenvSwitch

**Mô hình**

- Môi trường lab: KVM
- 1 máy Ubuntu 14.04 có 2 NICs, 1 NIC bridge và 1 NIC host-only

**Cài đặt**

- Update máy ảo

`apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y`

- Kế tiếp, chúng ta sẽ cài đặt KVM và 02 gói hỗ trợ

`apt-get install qemu-kvm libvirt-bin virtinst -y`

- Chuẩn bị cài OVS, chúng ta sẽ gỡ bridge libvirt mặc định (name: virbr0).

``` sh
virsh net-destroy default
virsh net-autostart --disable default
```

- Gán quyền cho user libvirtd và kvm

``` sh
sudo adduser `id -un` libvirtd
sudo adduser `id -un` kvm
```

- Vì chúng ta không sử dụng linux bridge mặc định, chúng ta có thể gỡ các gói ebtables bằng lệnh sau. (Không chắc chắn 100% là bước này cần thiết, nhưng hầu hết các bài hướng dẫn sẽ có bước này).

`aptitude purge ebtables -y`

- Chúng ta sẽ cài OVS bằng lệnh sau.

` apt-get install openvswitch-controller openvswitch-switch openvswitch-datapath-source -y`

- Các gói OVS được cài đặt xong, chúng ta sẽ check KVM bằng lệnh sau:

`virsh -c qemu:///system list`

Lệnh trên trả về danh sách các VM (máy ảo) đang chạy, lúc này sẽ trống.

- Kiểm tra lại OVS bằng lệnh sau:

``` sh
service openvswitch-switch status
ovs-vsctl show
```

- Đầu tiên, sẽ xử dụng lệnh ovs-vsctl để tạo bridge và add với 1 physical interface

``` sh
ovs-vsctl add-br br0
ovs-vsctl add-port br0 eth0
```

- Kiểm tra các bridge đã tạo và interface đã được gán hay chưa

``` sh
root@ubuntu:~#  ovs-vsctl show
8ff95bd9-d8c8-403e-bbc4-d584e25e7304
    Bridge "br0"
        Port "br0"
            Interface "br0"
                type: internal
        Port "eth0"
            Interface "eth0"
    ovs_version: "2.0.2"
```

- Chỉnh sửa file /etc/network/interfaces

``` sh
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet manual
up ifconfig $IFACE 0.0.0.0 up
up ip link set $IFACE promisc on
down ip link set $IFACE promisc off
down ifconfig $IFACE down

auto eth1
iface eth0 inet static
address 10.10.10.50
netmask 255.255.255.0

auto br0
iface br0 inet static
address 192.168.100.44
netmask 255.255.255.0
gateway 192.168.100.1
network 192.168.100.0
broadcast 192.168.100.255
dns-nameservers 8.8.8.8 8.8.4.4
```

- Tiến hành reset lại network

`etc/init.d/networking restart`

- Như vậy ta đã cài xong kvm với OVS, để kiểm tra xem có các network nào trong KVM

`virsh net-list --all`

Lúc này có thể thấy network default đã bị hủy, ta cần tạo network mới để sử dụng. Tạo file `ovsnet.xml` cho libvirt network:

``` sh
<network>
   <name>br0</name>
   <forward mode='bridge'/>
   <bridge name='br0'/>
   <virtualport type='openvswitch'/>
 </network>
```

- Thực hiện lệnh để tạo network

``` sh
virsh net-define ovsnet.xml
 virsh net-start br0
 virsh net-autostart br0
```

- Kiểm tra lại network đã khai báo cho libvirt bằng lệnh `virsh net-list --all`, chúng ta sẽ nhìn thấy network có tên là `br0`, đây chính là network có type là `openvswitch` đã khai báo ở trên.

``` sh
root@ubuntu:~# virsh net-list --all
 Name                 State      Autostart     Persistent
----------------------------------------------------------
 br0                  active     yes           yes
 default              inactive   no            yes
```

Ở đây tạo nhanh một KVM guest sử dụng virt-install

``` sh
cd /var/lib/libvirt/images

wget https://ncu.dl.sourceforge.net/project/gns-3/Qemu%20Appliances/linux-microcore-3.8.2.img

virt-install \
      -n VM01 \
      -r 128 \
       --vcpus 1 \
      --os-variant=generic \
      --disk path=/var/lib/libvirt/images/linux-microcore-3.8.2.img,format=qcow2,bus=virtio,cache=none \
      --network network=br0 \
      --hvm --virt-type kvm \
      --vnc --noautoconsole \
      --import
```

## 6. Một vài câu lệnh với Open vSwitch

- ovs-<functionality> : Bạn chỉ cần nhập vào `ovs` rồi ấn `tab` 2 lần là có thể xem tất cả các câu lệnh đối với Open vSwitch.

- ovs-vsctl : là câu lệnh để cài đặt và thay đổi một số cấu hình ovs. Nó cung cấp interface cho phép người dùng tương tác với Database để truy vấn và thay đổi dữ liệu.
  - ovs-vsctl show: Hiển thị cấu hình hiện tại của switch.
  - ovs-vsctl list-br: Hiển thị tên của tất cả các bridges.
  - ovs-vsctl list-ports <bridge> : Hiển thị tên của tất cả các port trên bridge.
  - ovs-vsctl list interface <bridge>: Hiển thị tên của tất cả các interface trên bridge.
  - ovs-vsctl add-br <bridge> : Tạo bridge mới trong database.
  - ovs-vsctl add-port <bridge> : <interface> : Gán interface (card ảo hoặc card vật lý) vào Open vSwitch bridge.

- ovs-ofctl và ovs-dpctl : Dùng để quản lí và kiểm soát các  flow entries. OVS quản lý 2 loại flow:
  - OpenFlows : flow quản lí control plane
  - Datapath : là kernel flow.
  - ovs-ofctl giao tiếp với OpenFlow module, ovs-dpctl
giao tiếp với Kernel module.

- ovs-ofctl show <BRIDGE> : hiển thị thông tin ngắn gọn về switch bao gồm port number và port mapping.
- ovs-ofctl dump-flows <Bridge> : Dữ liệu trong OpenFlow tables
- ovs-dpctl show : Thông tin cơ bản về logical datapaths (các bridges) trên switch.
- ovs-dpctl dump-flows : Hiển thị flow cached trong datapath.
- ovs-appctl bridge/dumpflows <br> : thông tin trong flow tables và offers kết nối trực tiếp cho VMs trên cùng hosts.
- ovs-appctl fdb/show <br> : Hiển thị các cặp mac/vlan.
