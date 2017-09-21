# Tìm hiểu về Linux Network Namespaces

## Mục lục

1. Khái niệm, chức năng của Network namespaces

2. Một số thao tác quản lí cơ bản

3. Lab tính năng

- 3.1. Kết nối 2 namespace
- 3.2. Cấp dhcp cho 2 namespace khác nhau

------------

## 1. Khái niệm, chức năng của Network namespaces

Thông thường thì những cài đặt trên Linux sẽ sử dụng chung một danh sách các network interfaces và routing table entries. Bạn có thể thay đổi nó nhưng về cơ bản nó vẫn được dùng chung trên cùng OS.

Network namespaces sinh ra để thay đổi điều này. Với Network namespaces, bạn có thể có các instances of network interfaces và routing tables hoạt động độc lập và tách biệt với nhau.

Mỗi network namespaces có bản định tuyến riêng, các thiết lập iptables riêng cung cấp cơ chế NAT và lọc đối với các máy ảo thuộc namespace đó. Linux network namespaces cũng cung cấp thêm khả năng để chạy các tiến trình riêng biệt trong nội bộ mỗi namespace.

## 2. Một số thao tác quản lí cơ bản

Ban đầu, khi khởi động hệ thống Linux, bạn sẽ có một namespace mặc định đã chạy trên hệ thống và mọi tiến trình mới tạo sẽ thừa kế namespace này, gọi là root namespace. Tất cả các quy trình kế thừa network namespace được init sử dụng (PID 1).

<img src="https://i.imgur.com/E6rD6TH.jpg">

Ta sử dụng câu lệnh `ip netns` để làm việc với network namespaces (xem thêm [tại đây](http://manpages.ubuntu.com/manpages/xenial/en/man8/ip-netns.8.html))

**List namespaces**

- Để hiển thị toàn bộ các namespaces trên hệ thống:

``` sh
ip netns
# or
ip netns list
```

- Nếu chưa thêm bất kì network namespace nào thì đầu ra màn hình sẽ để trống. root namespace sẽ không được liệt kê khi sử dụng câu lệnh ip netns list

**Add namespaces**

- Để thêm một network namespace

`ip netns add <namespace_name>`

Ví dụ:

``` sh
ip netns add hihi
ip netns add hoho
```

- Sử dụng câu lệnh ip netns hoặc ip netns list để hiển thị các namespace hiện tại:

``` sh
root@ubuntu:~# ip netns
hoho
hihi
```

- Mỗi khi thêm vào một namespace, một file mới được tạo trong thư mục /var/run/netns với tên giống như tên namespace. (không bao gồm file của root namespace).

``` sh
root@ubuntu:~# ls -l /var/run/netns
total 0
-r--r--r-- 1 root root 0 Sep 21 16:16 hihi
-r--r--r-- 1 root root 0 Sep 21 16:16 hoho
```

**Executing commands in namespaces**

- Để xử lý các lệnh trong một namespace (không phải root namespace)

`ip netns exec <namespace> <command>`

Ví dụ: Liệt kê các interfaces trong namespace `hihi`

``` sh
root@ubuntu:~# ip netns exec hihi ip a
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
```

- Kết quả đầu ra sẽ khác so với khi chạy câu lệnh ip a ở chế độ mặc định (trong root namespace). Mỗi namespace sẽ có một môi trường mạng cô lập và có các interface và bảng định tuyến riêng.

- Để liệt kê tất các các địa chỉ interface của các namespace sử dụng tùy chọn `–a` hoặc `–all` như sau:

``` sh
root@ubuntu:~# ip -a netns  exec ip a

netns: hoho
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00

netns: hihi
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
```

- Để sử dụng các câu lệnh với namespace ta sử dụng command bash để xử lý các câu lệnh trong riêng namespace đã chọn

``` sh
ip netns exec <namespace_name> bash
ip a #chi hien thi thong tin trong namespace <namespace_name>
```

- Để thoát khỏi vùng làm việc của namespace gõ `exit`

``` sh
root@ubuntu:~# ip netns exec hihi bash
root@ubuntu:~# ip a
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
root@ubuntu:~# exit
exit
root@ubuntu:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master br0 state UP group default qlen 1000
    link/ether 52:54:00:7b:74:51 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::5054:ff:fe7b:7451/64 scope link
       valid_lft forever preferred_lft forever
```

**Assign network interface to a specific namespace**

Sử dụng câu lệnh sau để gán interface vào namespace:

`ip link set <interface_name> netns <namespace_name>`


**Delete namespace**

`ip netns delete <namespace_name>`

## 3. Lab tính năng

### 3.1 Kết nối 2 namespace sử dụng Openvswitch

**Kết nối thông qua virtual ethernet (veth)**

<img src="https://i.imgur.com/0qlTPbd.png">

- Thêm Virtual switch ovs1

``` sh
root@thaonv:~# ovs-vsctl add-br ovs1
root@thaonv:~# ovs-vsctl show
c9582077-437a-4f6f-bd15-e5904621fb05
    Bridge "ovs1"
        Port "ovs1"
            Interface "ovs1"
                type: internal
    ovs_version: "2.0.2"
```

- thêm cặp veth (Virtual Ethernet interfaces) nối giữa namespace ns1 và switch ovs1

`ip link add veth-ns1 type veth peer name eth0-ns1`

- Thêm veth dùng để nối giữa ns2 và ovs1

`ip link add veth-ns2 type veth peer name eth0-ns2`

Như vậy ta có 2 cặp

``` sh
root@thaonv:~# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 52:54:00:b3:96:f7 brd ff:ff:ff:ff:ff:ff
3: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default
    link/ether d2:40:6c:71:08:a6 brd ff:ff:ff:ff:ff:ff
4: ovs1: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default
    link/ether a6:91:17:ba:3d:40 brd ff:ff:ff:ff:ff:ff
7: eth0-ns1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 8a:de:12:6a:f4:70 brd ff:ff:ff:ff:ff:ff
8: veth-ns1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 12:96:f7:4d:f1:77 brd ff:ff:ff:ff:ff:ff
9: eth0-ns2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether b2:a4:15:bc:d2:d7 brd ff:ff:ff:ff:ff:ff
10: veth-ns2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 6a:32:2d:53:a9:e5 brd ff:ff:ff:ff:ff:ff
```

- Chuyển interface eth0-ns1 vào namespace ns1 và eth1-ns2 vào namespace ns2 và bật lên

``` sh
ip link set eth0-ns1 netns ns1
 ip netns exec ns1 ip link set eth0-ns1 up

 ip link set eth0-ns2 netns ns2
 ip netns exec ns2 ip link set eth0-ns2 up
```

- Các interface còn lại gán vào openvswitch port và bật lên

``` sh
ip link set veth-ns1 up
ip link set veth-ns2 up
ovs-vsctl add-port ovs1 veth-ns1
ovs-vsctl add-port ovs1 veth-ns2
```

- Kiểm tra lại

``` sh
root@thaonv:~# ovs-vsctl show
c9582077-437a-4f6f-bd15-e5904621fb05
    Bridge "ovs1"
        Port "ovs1"
            Interface "ovs1"
                type: internal
        Port "veth-ns1"
            Interface "veth-ns1"
        Port "veth-ns2"
            Interface "veth-ns2"
    ovs_version: "2.0.2"
```

- Gán địa chỉ IP và ping thử giữa 2 namespace

``` sh
ip netns exec ns1 ifconfig eth0-ns1 10.0.0.1/24
ip netns exec ns2 ifconfig eth0-ns2 10.0.0.2/24
ip netns exec ns1 ping 10.0.0.2
```

- Kết quả:

``` sh
root@thaonv:~# ip netns exec ns1 ping 10.0.0.2
PING 10.0.0.2 (10.0.0.2) 56(84) bytes of data.
64 bytes from 10.0.0.2: icmp_seq=1 ttl=64 time=0.766 ms
64 bytes from 10.0.0.2: icmp_seq=2 ttl=64 time=0.046 ms
64 bytes from 10.0.0.2: icmp_seq=3 ttl=64 time=0.026 ms
```

**Kết nối thông qua OVS port**

<img src="https://i.imgur.com/O8mZjZv.png">

- Cách này không kết nối các namespace thông qua veth, mà sử dụng kết nối trực tiếp thông qua port internal của Openvswitch.

- Cách thực hiện tương tự như phần trên, không tạo thêm 2 veth mà tạo ra 2 port tap1 và tap2 type internal trên ovs1

``` sh
ovs-vsctl add-port ovs1 tap1 -- set interface tap1 type=internal
ovs-vsctl add-port ovs1 tap2 -- set interface tap2 type=internal
```

- Gán 2 port trên vào 2 namespaces và bật lên

``` sh
ip link set tap1 netns ns1
ip link set tap2 netns ns2
ip netns exec ns1 ip link set tap1 up
ip netns exec ns2 ip link set tap2 up
```

- Gán địa chỉ IP và ping thử giữa 2 interface

``` sh
ip netns exec ns1 ifconfig tap1 10.0.0.1/24
ip netns exec ns2 ifconfig tap2 10.0.0.2/24
ip netns exec ns1 ping 10.0.0.2
```

- Kết quả

``` sh
root@thaonv:~# ip netns exec ns1 ping 10.0.0.2
PING 10.0.0.2 (10.0.0.2) 56(84) bytes of data.
64 bytes from 10.0.0.2: icmp_seq=1 ttl=64 time=0.622 ms
64 bytes from 10.0.0.2: icmp_seq=2 ttl=64 time=0.020 ms
64 bytes from 10.0.0.2: icmp_seq=3 ttl=64 time=0.047 ms
```

### 3.2. Cấp dhcp cho 2 namespace khác nhau

Topology sau đây lấy ý tưởng từ hệ thống OpenStack. Trên mỗi máy Compute, các máy ảo thuộc về mỗi vlan đại diện cho các máy của một tenant. Chúng tách biệt về layer 2 và được cấp phát IP bởi các DHCP server ảo cùng VLAN (các DHCP server ảo này thuộc về các namespaces khác nhau và không cùng namespace với các máy ảo của các tenant, được cung cấp bởi dịch vụ dnsmasq). Các DHCP server này hoàn toàn có thể cấp dải địa chỉ trùng nhau do tính chất của namespace. Sau đây là mô hình:

<img src="https://i.imgur.com/4iCRJPM.png">

Mô hình bài lab bao gồm 2 DHCP namespace (DHCP1, DHCP2) và hai namespaces dành cho các máy ảo của 2 tenant (ns1, ns2), các máy ảo trên 2 tenant này thuộc về hai VLANkhác nhau (VLAN100 và VLAN200). DHCP server trên các namespace DHCP1, DHCP2 sẽ cấp địa chỉ IP cho các máy ảo của 2 tenant trên 2 namespace tương ứng là ns1 và ns2.

- Tạo veth kết nối 2 network namespace và ovs1

``` sh
ip link add veth-ns1 type veth peer name eth0-ns1
ip link add veth-ns2 type veth peer name eth0-ns2
ip link set eth0-ns1 netns ns1
ip link set eth0-ns2 netns ns2
ip link set veth-ns1 up
ip link set veth-ns2 up
ip netns exec ns1 ip link set lo up
ip netns exec ns1 ip link set eth0-ns1 up
ip netns exec ns2 ip link set lo up
ip netns exec ns2 ip link set eth0-ns2 up

ovs-vsctl add-port ovs1 veth-ns1 -- set port veth-ns1 tag=100
ovs-vsctl add-port ovs1 veth-ns2 -- set port veth-ns2 tag=200
```

- Tạo 2 namespace cho các DHCP namespace

``` sh
ip netns add DHCP1
ip netns add DHCP2
```

- Trên switch ảo ovs1 tạo 2 internal interface là tap1 và tap2 để kết nối với 2 namespaces tương ứng là DHCP1 và DHCP2. Chú ý gán tap1 vào VLAN100, tap2 vào VLAN200:

``` sh
# cau hinh tap1
ovs-vsctl add-port ovs1 tap1 -- set interface tap1 type=internal
ovs-vsctl set port tap1 tag=100
# cau hinh tag2
ovs-vsctl add-port ovs1 tap2 -- set interface tap2 type=internal
ovs-vsctl set port tap2 tag=200
```

- Kiểm tra lại

``` sh
root@thaonv:~# ovs-vsctl show
c9582077-437a-4f6f-bd15-e5904621fb05
    Bridge "ovs1"
        Port "tap1"
            tag: 100
            Interface "tap1"
                type: internal
        Port "tap2"
            tag: 200
            Interface "tap2"
                type: internal
        Port "ovs1"
            Interface "ovs1"
                type: internal
        Port "veth-ns1"
            tag: 100
            Interface "veth-ns1"
        Port "veth-ns2"
            tag: 200
            Interface "veth-ns2"
    ovs_version: "2.0.2"
```

-  Gán 2 internal interface tap1 và tag2 trên lần lượt vào các namespace DHCP1 và DHCP2. Chú ý là thực hiện hai thao tác này trên bash của root namespace. Nếu đang thao tác trong các namespace ns1 và ns2 thì phải thoát ra bằng lệnh exit cho tới khi trở về root namespace.

``` sh
ip link set tap1 netns DHCP1
ip link set tap2 netns DHCP2
```

- Thiết lập IP cho các internal interfaces tap1 và tag2. Thiết lập dải địa chỉ cấp phát cho các máy ảo trên các các tenant namespaces tương ứng ns1 và ns2 sử dụng dnsmasq (nếu máy host chưa có cần cài đặt dùng lệnh: apt-get install dnsmasq -y)

- Cấu hình cho tap1

``` sh
# cau hinh IP cho tap1
ip netns exec DHCP1 bash
ip link set dev lo up
ip link set dev tap1 up
ip address add 10.0.10.2/24 dev tap1
# cau hinh dai dia chi cap phat cho cac may ao trong namespace ns1
ip netns exec DHCP1 dnsmasq --interface=tap1 \
--dhcp-range=10.0.10.10,10.0.10.100,255.255.255.0
```

- Cấu hình cho tap2

``` sh
# cau hinh IP cho tap2
 ip netns exec DHCP2 bash
 ip link set dev lo up
 ip link set dev tap2 up
 ip address add 10.0.10.2/24 dev tap2
 # cau hinh dai dia chi cap phat cho cac may ao trong namespace ns2
 ip netns exec DHCP2 dnsmasq --interface=tap2 \
 --dhcp-range=10.0.10.10,10.0.10.100,255.255.255.0
```

- Kiểm tra lại các tiến trình dnsmasq đã cấu hình chính xác chưa

``` sh
root@thaonv:~# ps aux | grep dnsmasq
dnsmasq   2730  0.0  0.0  31028   888 ?        S    18:34   0:00 /usr/sbin/dnsmasq -x /var/run/dnsmasq/dnsmasq.pid -u dnsmasq -r /var/run/dnsmasq/resolv.conf -7 /etc/dnsmasq.d,.dpkg-dist,.dpkg-old,.dpkg-new
nobody    2786  0.0  0.0  31032   888 ?        S    18:35   0:00 dnsmasq --interface=tap1 --dhcp-range=10.0.10.10,10.0.10.100,255.255.255.0
root      2788  0.0  0.0   4876   176 pts/0    R+   18:35   0:00 grep --color=auto dnsmasq
```

- Ta sẽ cấp phát IP cho các virtual interfaces eth0-ns1 và eth0-ns2 thuộc hai namespaces tương ứng ns1 và ns2.

- Xin cấp IP cho eth0-ns1 và kiểm tra địa chỉ IP trong namespace ns1.

``` sh
ip netns exec ns1 dhclient eth0-ns1 # xin cap dia chi IP
ip netns exec ns1 ip a
```

Kết quả :

``` sh
root@thaonv:~#  ip netns exec ns1 ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
17: eth0-ns1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 8e:70:33:c2:33:dc brd ff:ff:ff:ff:ff:ff
    inet 10.0.10.76/24 brd 10.0.10.255 scope global eth0-ns1
       valid_lft forever preferred_lft forever
    inet6 fe80::8c70:33ff:fec2:33dc/64 scope link
       valid_lft forever preferred_lft forever
```

**Link tham khảo:**

https://github.com/hocchudong/thuctap012017/blob/master/TamNT/Virtualization/docs/7.Linux_network_namespace.md

http://abregman.com/2016/09/29/linux-network-namespace/

https://blog.scottlowe.org/2013/09/04/introducing-linux-network-namespaces/
