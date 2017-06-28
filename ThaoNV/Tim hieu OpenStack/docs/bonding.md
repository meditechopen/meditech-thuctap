# Tìm hiểu Network Bonding

## Mục lục

1. Network Bonding là gì?

2. Các mode trong network bonding

3. Thực hành cấu hình bonding trên CentOS 7 và test thử

-------

### 1. Network Bonding là gì?

Network bonding là phương pháp kết hợp hai hoặc nhiều network interfaces lại với nhau để trở thành 1 interface duy nhất. Nó giúp gia tăng băng thông, giảm thiểu sự dư thừa dữ liệu... Nếu 1 interface bị down, những cái còn lại sẽ giữ cho đường truyền mạng ổn định mà không bị ảnh hưởng.

Linux bonding drivers cung cấp cho ta phương thức để thực hiện điều ấy. Chức năng của "bonded" interface phụ thuộc vào mode được cấu hình.

### 2. Các mode trong network bonding

- mode=0 (balance-rr)

Là mode mặc định. Áp dụng cơ chế Round-robin cung cấp khả năng cân bằng tải và chịu lỗi.

- mode=1 (active-backup)

Áp dụng cơ chế Active-backup. Tại một thời điểm chỉ có 1 slave interface active, các slave khác sẽ active khi nào slave đang active bị lỗi. Địa chỉ MAC của đường bond sẽ thấy từ bên ngoài chỉ trên một port để tránh gây khó hiểu cho switch. Mode này cung cấp khả năng chịu lỗi.

- mode=2 (balance-xor)

Áp dụng phép XOR: thực hiện XOR MAC nguồn và MAC đích, rồi thực hiện modulo với số slave. Mode này cung cấp khả năng cân bằng tải và chịu lỗi

- mode=3 (broadcast)

Gửi tin trên tất cả các slave interfaces. Mode này cung cấp khả năng chịu lỗi.

- mode=4 (802.3ad)

IEEE 802.3ad. Mode này sẽ tạo một nhóm tập hợp các intefaces chia sẻ chung tốc độ và thiết lập duplex (hai chiều). Yêu cầu để sử dụng mode này là có Ethtool trên các drivers gốc để đạt được tốc độ và cấu hình hai chiều trên mỗi slave, đồng thời các switch sẽ phải cấu hình hỗ trợ chuẩn IEEE 802.3ad.

- mode=5 (balance-tlb)

Cân bằng tải thích ứng với quá trình truyền tin: lưu lượng ra ngoài phân tán dựa trên tải hiện tại trên mỗi slave (tính toán liên quan tới tốc độ). Lưu lượng tới nhận bởi slave active hiện tại, nếu slave này bị lỗi khi nhận gói tin, các slave khác sẽ thay thế, MAC address của đường bond sẽ chuyển sang một trong các slave còn lại.

- mode=6 (balance-alb)

 Cân bằng tải thích ứng: bao gồm cả cân bằng tải truyền (balance-tlb) và cân bằng tải nhận (rlb - receive load balancing) đối với lưu lượng IPv4. Cân bằng tải nhận đạt được nhờ kết hợp với ARP. Bonding driver sẽ chặn các bản tin phản hồi ARP gửi bởi hệ thống cục bộ trên đường ra và ghi đè địa chỉ MAC nguồn bằng địa chỉ MAC của một trong các slaves trên đường bond.


### 3. Thực hành cấu hình bonding mode 1 trên CentOS 7 và test thử

**Mô hình**

Một máy cài CentOS 7 với 2 card mạng thuộc dải mạng : 192.168.100.0/24

**Cấu hình**

Đối với CentOS 7, bonding module mặc định sẽ không được load. Sử dụng câu lệnh sau để kích hoạt:

`modprobe bonding`

Bạn có thể xem thông tin của bonding module bằng câu lệnh sau:

`modinfo bonding`

Tạo file cấu hình `bond0`:

`vi /etc/sysconfig/network-scripts/ifcfg-bond0`

Thêm vào những dòng sau:

``` sh
DEVICE=bond0
NAME=bond0
TYPE=Bond
BONDING_MASTER=yes
IPADDR=192.168.100.32
PREFIX=24
GATEWAY=192.168.100.1
ONBOOT=yes
BOOTPROTO=none
BONDING_OPTS="mode=1 miimon=100"
```

`BONDING_OPTS` sẽ chỉ ra bonding mode. Sau khi thêm xong  Lưu lại file cấu hình.

Tiếp theo ta sửa lại file cấu hình của 2 card mạng là ens3 và ens7

Đối với ens3, sửa và thêm vào những dòng sau:

``` sh
BOOTPROTO="none"
ONBOOT="yes"
MASTER=bond0
SLAVE=yes
```

Làm tương tự với `ens7`.

Sau đó restart lại cấu hình mạng

`systemctl restart network`

**Test Network Bonding**

Chạy câu lệnh sau để kiểm tra xem `bond0` đã được bật và chạy hay chưa:

`cat /proc/net/bonding/bond0`

``` sh
[root@meditech ~]# cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: fault-tolerance (active-backup)
Primary Slave: None
Currently Active Slave: ens3
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0

Slave Interface: ens3
MII Status: up
Speed: 100 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 52:54:00:9c:68:53
Slave queue ID: 0

Slave Interface: ens7
MII Status: up
Speed: 100 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 52:54:00:6b:f2:7b
Slave queue ID: 0
```

Có thể thấy bond0 đã được bật và nó được cấu hình ở mode 1 (active-backup). Ở mode này, chỉ có 1 slave được bật, slave còn lại sẽ được bật chỉ khi slave đang active bị chết.

**Test băng thông**

Dùng iperf test băng thông của `bond0`

``` sh
[root@meditech ~]# iperf -c 192.168.100.30 -b 1G
------------------------------------------------------------
Client connecting to 192.168.100.30, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.100.32 port 37752 connected with 192.168.100.30 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec   175 MBytes   146 Mbits/sec
```

Tiếp theo ta "hạ" một card mạng xuống và kiểm tra lại bằng thông:

``` sh
[root@meditech ~]# ifdown ens3
Device 'ens3' successfully disconnected.
[root@meditech ~]# iperf -c 192.168.100.30 -b 1G
------------------------------------------------------------
Client connecting to 192.168.100.30, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.100.32 port 37754 connected with 192.168.100.30 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec   167 MBytes   140 Mbits/sec
```

Có thể thấy băng thông không có sự thay đổi khi ta bỏ 1 card mạng đi.
