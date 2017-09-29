# Một số bài lab về iptables

## Mục lục

1. Mô hình lab 1

2. Mô hình lab 2

3. Mô hình lab 3

---------

## 1. Mô hình lab 1

**Mô hình**

<img src="https://i.imgur.com/OxtRKF3.png">

Server: CentOS 7 (1 NIC Bridge)

Client: Windows 7 (1 NIC Bridge)

Môi trường lab: KVM

**Yêu cầu**

Sử dụng iptables để:

- DROP các INPUT traffic mặc định tới server
- ACCEPT các OUTPUT traffic mặc định từ server
- ACCEPT các traffic đã kết nối (ESTABLISHED)
- ACCEPT kết nối từ loopback
- ACCEPT các kết nối ping 5 lần 1 phút từ internal network (192.168.100.0/24)
- ACCEPT các kết nối ssh từ internal network (192.168.100.0/24)

**Thực hiện**

- Disable Firewalld mặc định trên máy

``` sh
systemctl stop firewalld
systemctl mask firewalld
```

- Cài iptables service

`yum install -y iptables-services`

- Cho phép iptables service khởi động cùng hệ thống

`systemctl enable iptables`

- Bật iptables service

`systemctl start iptables`

- Viết script rules cho iptables

`vi iptables.sh`

``` sh
#!/bin/bash

trust_host='192.168.100.0/24'
my_host='192.168.100.32'

# Xóa các rules cũ
/sbin/iptables -F
/sbin/iptables -X

# Cấu hình các policy mặc định
/sbin/iptables -P INPUT DROP
/sbin/iptables -P OUTPUT ACCEPT
/sbin/iptables -P FORWARD DROP

# Cho phép các kết nối ở trạng thái đã được thiết lập
/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Cho phép các kết nối từ loopback
/sbin/iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT

# Cho phép kết nối ping 5 lần 1 phút từ internal network (192.168.100.0/24)
/sbin/iptables -A INPUT -p icmp --icmp-type echo-request -s $trust_host \
-d $my_host -m limit --limit 1/m --limit-burst 5 -j ACCEPT

# Cho phép kết nối ssh từ internal network
/sbin/iptables -A INPUT -p tcp -m state --state NEW -m tcp -s $trust_host \
-d $my_host --dport 22 -j ACCEPT

# Lưu lại và restart iptables
service iptables save
systemctl restart iptables
```

- Chạy script và kiểm tra

`sh iptables.sh `

## Mô hình lab 2

**Mô hình**

<img src="https://i.imgur.com/68asd3a.png">

**Yêu cầu**

Sử dụng iptables để:

- DROP các INPUT traffic mặc định tới server
- ACCEPT các OUTPUT traffic mặc định từ server
- DROP các traffic forward mặc định
- ACCEPT các traffic đã kết nối (ESTABLISHED)
- ACCEPT kết nối từ loopback
- ACCEPT các kết nối ping 5 lần 1 phút từ internal network (10.10.10.0/24)
- ACCEPT các kết nối ssh từ internal network (10.10.10.0/24)
- ACCEPT các kết nối ra ngoài từ internal network và chuyển đổi địa chỉ nguồn

**Thực hiện**

- Viết script rules cho iptables

`vi iptables.sh`

``` sh
#!/bin/bash

trust_host='10.10.10.0/24'
my_host='10.10.10.10'

echo 1 > /proc/sys/net/ipv4/ip_forward

/sbin/iptables -F
/sbin/iptables -t nat -F
/sbin/iptables -X

/sbin/iptables -P INPUT DROP
/sbin/iptables -P OUTPUT ACCEPT
/sbin/iptables -P FORWARD DROP

/sbin/iptables -A FORWARD -i ens6 -o ens3 -s $trust_host -j ACCEPT
/sbin/iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

/sbin/iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT

/sbin/iptables -A INPUT -p icmp --icmp-type echo-request -s $trust_host \
-d $my_host -m limit --limit 1/m --limit-burst 5 -j ACCEPT

/sbin/iptables -A INPUT -p tcp -m state --state NEW -m tcp -s $trust_host \
-d $my_host --dport 22 -j ACCEPT

/sbin/iptables -t nat -A POSTROUTING -o ens3 -s $trust_host -j MASQUERADE

service iptables save
systemctl restart iptables
```

- Chạy script và kiểm tra

`sh iptables.sh`

## Mô hình lab 3

**Mô hình**

<img src="https://i.imgur.com/V5H8n4P.png">

**Yêu cầu**

Sử dụng iptables để:

- DROP các INPUT traffic mặc định tới server
- ACCEPT các OUTPUT traffic mặc định từ server
- DROP các traffic forward mặc định
- ACCEPT các traffic đã kết nối (ESTABLISHED)
- ACCEPT kết nối từ loopback
- FORWARD các packet từ port 80 ens3 tới Backend1 trên cùng port
- FORWARD các packet từ port 443 ens3 tới Backend2 trên cùng port
- DROP các packet từ địa chỉ 192.168.100.20
- ACCEPT các kết nối ping 5 lần 1 phút từ internal network (10.10.10.0/24)
- ACCEPT các kết nối ssh từ internal network (10.10.10.0/24)
- DROP các packet từ địa chỉ 10.10.10.20
- ACCEPT các kết nối ra ngoài từ internal network và chuyển đổi địa chỉ nguồn

**Thực hiện**

- Viết script rules cho iptables

`vi iptables.sh`

``` sh
#!/bin/bash

trust_host='10.10.10.0/24'
my_internal_ip='10.10.10.10'
my_external_ip='192.168.100.32'

listen_port_1='80'
backend_host_1='10.10.10.11'
backend_port_1='80'

listen_port_2='443'
backend_host_2='10.10.10.12'
backend_port_2='443'

echo 1 > /proc/sys/net/ipv4/ip_forward

/sbin/iptables -F
/sbin/iptables -t nat -F
/sbin/iptables -X

/sbin/iptables -P INPUT DROP
/sbin/iptables -P OUTPUT ACCEPT
/sbin/iptables -P FORWARD DROP

/sbin/iptables -A FORWARD -i ens6 -o ens3 -s $trust_host -j ACCEPT
/sbin/iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

/sbin/iptables -A FORWARD -s 192.168.100.20/32 -j DROP

/sbin/iptables -A FORWARD -p tcp --dst $backend_host_1 --dport $backend_port_1 -j ACCEPT
/sbin/iptables -A FORWARD -p tcp --dst $backend_host_2 --dport $backend_port_2 -j ACCEPT

/sbin/iptables -A INPUT -s 10.10.10.20/32 -j DROP

/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
/sbin/iptables -A INPUT -p icmp --icmp-type echo-request -s $trust_host \
-d $my_internal_ip -m limit --limit 1/m --limit-burst 5 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m state --state NEW -m tcp -s $trust_host \
-d $my_internal_ip --dport 22 -j ACCEPT

/sbin/iptables -t nat -A POSTROUTING -o ens3 -s $trust_host -j MASQUERADE

/sbin/iptables -t nat -A PREROUTING -p tcp --dst $my_external_ip --dport $listen_port_1 \
-j DNAT --to-destination $backend_host_1:$backend_port_1
/sbin/iptables -t nat -A PREROUTING -p tcp --dst $my_external_ip --dport $listen_port_2 \
-j DNAT --to-destination $backend_host_2:$backend_port_2

service iptables save
systemctl restart iptables
```

- Chạy script và kiểm tra

`sh iptables.sh`

**Link tham khảo**

https://www.server-world.info/en/note?os=CentOS_6&p=iptables&f=1
