# Hướng dẫn cấu hình OpenVPN theo cơ chế tun

## Mô hình lab

<img src="https://i.imgur.com/NiiP9bs.png">

- Môi trường lab: KVM
- OS:
  - Server: Ubuntu 14.04 (1 Bridge, 1 Default, 1 Host-only)
  - Client: Windows 7, Ubuntu 14.04, CentOS 7

### Mục tiêu

- Cấu hình sao cho các vpn-clients khi kết nối tới có thể truy cập vào các server thuộc các dải mạng LAN bên trong

## Hướng dẫn cài đặt và cấu hình

- Update packages

`apt-get update`

- Cài đặt OpenVPN and Easy-RSA.

`apt-get install openvpn easy-rsa -y`

- Giải nén các file config mẫu vào thư mục /etc/openvpn

`gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/server.conf`

- Chỉnh sửa file `/etc/openvpn/server.conf`

`vim /etc/openvpn/server.conf`

``` sh
dh2048.pem
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 208.67.222.222"
push "dhcp-option DNS 208.67.220.220"
user nobody
group nogroup
status /var/log/openvpn-status.log
log         /var/log/openvpn.log
log-append  /var/log/openvpn.log
```

- Để forward gói tin giữa các dải mạng trong VPN Server

`echo 1 > /proc/sys/net/ipv4/ip_forward`
`vim /etc/sysctl.conf`

Bỏ comment

`net.ipv4.ip_forward=1`

- Cấu hình firewall, ở đây mình dùng iptables

`apt-get install iptables-persistent –y`

``` sh
iptables -t nat -A POSTROUTING -s 10.8.0.0/8 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.8.0.0/8 -o eth1 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.8.0.0/8 -o eth2 -j MASQUERADE
```

Save lại

`iptables-save > /etc/iptables/rules.v4`

- Copy Easy-RSA generation scripts

`cp -r /usr/share/easy-rsa/ /etc/openvpn`

- Tạo directory

`mkdir /etc/openvpn/easy-rsa/keys`

- Chỉnh sửa file `/etc/openvpn/easy-rsa/vars`

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

- Gen Diffie-Hellman parameters

`openssl dhparam -out /etc/openvpn/dh2048.pem 2048`

- Chuyển qua `/etc/openvpn/easy-rsa` và build certificate

`cd /etc/openvpn/easy-rsa`

``` sh
. ./vars
./clean-all
./build-ca
```

**Lưu ý:**

Khi build CA, bạn chỉ cần ENTER để lấy các giá trị mặc định

- Generate Certificate và Key cho Server

`./build-key-server server`

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

- Chuyển Server Certificates và Keys

`cp /etc/openvpn/easy-rsa/keys/{server.crt,server.key,ca.crt} /etc/openvpn`

- Bật dịch vụ và kiểm extra

``` sh
service openvpn start
service openvpn status
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


**Link tham khảo:**

https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-14-04
