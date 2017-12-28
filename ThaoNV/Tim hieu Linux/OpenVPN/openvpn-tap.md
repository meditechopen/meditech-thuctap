# Hướng dẫn cài đặt OpenVPN theo cơ chế TAP

## Mô hình lab

<img src="https://i.imgur.com/KpCFAvZ.png">

- Môi trường lab: KVM
- OS:
  - Server: Ubuntu 14.04 (1 Bridge, 1 Default, 1 Host-only)
  - Client: Windows 7, Ubuntu 14.04, CentOS 7

### Mục tiêu

- Cấu hình bridge sao cho các vpn clients được đặt cùng dải với local network của VPN server.

## Hướng dẫn cài đặt và cấu hình

- Update packages

`apt-get update`

- Cài đặt OpenVPN and Easy-RSA.

`apt-get install openvpn easy-rsa -y`

- Giải nén các file config mẫu vào thư mục /etc/openvpn

`gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/server.conf`

- Để forward gói tin giữa các dải mạng trong VPN Server

`vim /etc/sysctl.conf`

Thêm vào dòng cuối cùng của file

`net.ipv4.ip_forward = 1`

- Copy các script vào thư mục /etc/openvpn

`cp -r /usr/share/easy-rsa/ /etc/openvpn`

- Tạo thư mục chứa key

`mkdir /etc/openvpn/easy-rsa/keys`

- Sửa file `/etc/openvpn/easy-rsa/vars`

`vim /etc/openvpn/easy-rsa/vars`

``` sh
export KEY_COUNTRY="VN"
export KEY_PROVINCE="HN"
export KEY_CITY="Hanoi"
export KEY_ORG="Meditech"
export KEY_EMAIL="thao.nguyenvan@meditech.vn"
export KEY_OU="Meditech"

export KEY_NAME="server"
```

- Tạo DH key

`openssl dhparam -out /etc/openvpn/dh2048.pem 2048`

- Tạo CA key cho VPN Server

```sh
cd /etc/openvpn/easy-rsa
source vars
./clean-all
./build-ca
```

Enter liên tục để lấy các giá trị mặc định

- Tạo cert và key cho VPN Server

`./build-key-server server`

Lựa chọn các giá trị mặc định.

Khi gặp các thông báo sau, lựa chọn ‘y’

``` sh
Sign the certificate? [y/n]y
1 out of 1 certificate requests certified, commit? [y/n]y
```

Nếu thành công, sẽ xuất hiện thông báo

``` sh
Write out database with 1 new entries
Data Base Updated
```

- Copy các file ca, crt và key ra thư mục /etc/openvpn

`cp /etc/openvpn/easy-rsa/keys/{MyCloudVNN.crt,MyCloudVNN.key,ca.crt} /etc/openvpn`

- Sửa file `/etc/openvpn/server.conf`

`vim /etc/openvpn/server.conf`

``` sh
dev tap0
#Khai báo các cert, key và CA của VPN server
ca ca.crt
cert server.crt
key server.key
#Sử dụng khóa Diffie Hellman 2048 bits
dh dh2048.pem
#Comment lại dòng nay
#server 10.8.0.0 255.255.255.0
#Sử dụng cơ chê bridge để cấp IP cho VPN Client, khai báo dải IP được cấp
server-bridge 10.10.10.123 255.255.255.0 10.10.10.130 10.10.10.150
#Add route để VPN Client có thể truy cập vào các máy chủ tại dải private
push "route 192.168.122.0 255.255.255.0"
push "route 10.10.10.0 255.255.255.0"
#Thiết lập dns
push "dhcp-option DNS 208.67.222.222"
push "dhcp-option DNS 8.8.8.8"
user nobody
group nogroup
#Khai báo log trạng thái của OpenVPN
status /var/log/openvpn-status.log
#Khai báo log hoạt động của OpenVPN
log         /var/log/openvpn.log
log-append  /var/log/openvpn.log
```

- Cài đặt Linux Bridge

`apt-get install bridge-utils -y`

- Tạo br0, br1 và gán eth1 và eth0 cho nó

``` sh
brctl addbr br0
brctl addbr br1
brctl addif br0 eth1
brctl addif br1 eth0
```

- Sửa file /etc/network/interfaces để gắn eth1 vào br0 và eth0 vào bond1

``` sh
auto eth0
iface eth0 inet manual

auto br1
iface br1 inet static
        bridge_ports eth0
        address 192.168.100.35
        netmask 255.255.255.0
        gateway 192.168.100.1
        dns-nameservers 8.8.8.8
        bridge_stp off
        bridge_fd 0
        bridge_maxwait 0

auto br0
iface br0 inet static
        address 10.10.10.123
        netmask 255.255.255.0
        bridge_ports eth1
        bridge_fd 9
        bridge_hello 2
        bridge_maxage 12
        bridge_stp off

auto eth1
iface eth1 inet manual
        up ip link set dev $IFACE up
        down ip link set dev $IFACE down
```

- Khởi động lại card mạng

`ifdown –a && ifup -a`

- Add thêm rule vào iptables để các máy chủ trong hệ thống có thể ra Internet thông qua GW là VPN Server

``` sh
iptables --table nat --append POSTROUTING --out-interface br1 -j MASQUERADE
iptables --append FORWARD --in-interface br0 -j ACCEPT
```

- Khởi động và kiểm tra trạng thái OpenVPN server

``` sh
service openvpn start
service openvpn status
```

Nếu thành công, sẽ xuất hiện thông báo

`VPN 'server' is running`

- Copy các script để khởi động linux bridge

`cp /usr/share/doc/openvpn/examples/sample-scripts/{bridge-start,bridge-stop} /etc/openvpn`

- Sửa file script để gán tap0 vào br0

`vi /etc/openvpn/bridge-start`

``` sh
#!/bin/sh

#################################
# Set up Ethernet bridge on Linux
# Requires: bridge-utils
#################################

# Define Bridge Interface
br="br0"

# Define list of TAP interfaces to be bridged,
# for example tap="tap0 tap1 tap2".
tap="tap0"

# Define physical ethernet interface to be bridged
# with TAP interface(s) above.
eth="eth1"
eth_ip="10.10.10.123"
eth_netmask="255.255.255.0"
eth_broadcast="10.10.10.255"

for t in $tap; do
    brctl addif $br $t
done

for t in $tap; do
    ifconfig $t 0.0.0.0 promisc up
done

ifconfig $eth 0.0.0.0 promisc up

ifconfig $br $eth_ip netmask $eth_netmask broadcast $eth_broadcast
```

- Chạy script để gắn tap0 vào br0 (mỗi khi khởi động lại VPN server đều phải thực hiện bước này)

``` sh
cd /etc/openvpn
./bridge-start
```

- Kiểm tra việc gắn tap0 vào br0

`brctl show`

Nếu thành công, sẽ thấy eth1 và tap0 gắn vào br0

``` sh
root@u14-thaonv:~# brctl show
bridge name     bridge id               STP enabled     interfaces
br0             8000.525400e30c08       no              eth1
                                                        tap0
br1             8000.525400853c00       no              eth0
```

- Để br0 tự động add tap0 khi máy chủ khởi động lại, thực hiện như sau

``` sh
cp /etc/openvpn/bridge-start /etc/init.d/
chmod +x /etc/init.d/bridge-start
update-rc.d bridge-start defaults
```

Kết quả:

``` sh
update-rc.d: warning: /etc/init.d/bridge-start missing LSB information
update-rc.d: see <http://wiki.debian.org/LSBInitScripts>
 Adding system startup for /etc/init.d/bridge-start ...
   /etc/rc0.d/K20bridge-start -> ../init.d/bridge-start
   /etc/rc1.d/K20bridge-start -> ../init.d/bridge-start
   /etc/rc6.d/K20bridge-start -> ../init.d/bridge-start
   /etc/rc2.d/S20bridge-start -> ../init.d/bridge-start
   /etc/rc3.d/S20bridge-start -> ../init.d/bridge-start
   /etc/rc4.d/S20bridge-start -> ../init.d/bridge-start
   /etc/rc5.d/S20bridge-start -> ../init.d/bridge-start
```

- Đã hoàn tất cài đặt server, tiến hành gen keys cho client 1

`./build-key client1`

Ấn ENTER để bỏ qua

``` sh
Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```
Ấn `y` để tiếp tục

``` sh
Sign the certificate? [y/n] y
1 out of 1 certificate requests certified, commit? [y/n] y
```

- Tiến hành chỉnh sửa file cấu hình cho client

`cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /etc/openvpn/easy-rsa/keys/client.ovpn`

`vi /etc/openvpn/easy-rsa/keys/client.ovpn`

```sh
dev tap
remote 192.168.100.35 1194

user nobody
group nogroup

ca ca.crt
cert client1.crt
key client1.key
```

- Trên phía client, cài đặt OpenVPN Client và copy 4 file sau vào thư mục `C:\Program Files\OpenVPN\config`

``` sh
/etc/openvpn/easy-rsa/keys/client1.crt
/etc/openvpn/easy-rsa/keys/client1.key
/etc/openvpn/easy-rsa/keys/client.ovpn
/etc/openvpn/ca.crt
```

<img src="https://i.imgur.com/TLs6zyr.png">

- Tiến hành connect và ping kiểm tra ra ngoài internet + các máy server của các dải mạng LAN
