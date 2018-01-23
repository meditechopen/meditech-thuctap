# Hướng dẫn cài đặt và cấu hình HAProxy + keepalived trên CentOS 7

## Mục lục

[1. Mô hình](#1)

[2. Cấu hình haproxy](#2)

[3. Cấu hình keepalived](#3)


-----------

<a name="1"></a>
## 1. Mô hình

<img src="https://i.imgur.com/pcjCNsN.png">

Môi trường lab: KVM

HĐH: CentOS 7.3 - 17.08

**Lưu ý:** Nếu bạn sử dụng hđh CentOS 7.3-1611 thì sẽ phải update trước khi cài keepalived

<a name="2"></a>
## 2. Cấu hình haproxy

**Trên server haproxy1**

- Tải và cài đặt package

`yum install haproxy -y`

- Cấu hình haproxy

`vi /etc/haproxy/haproxy.cfg`

``` sh
global
        daemon
        maxconn 256

    defaults
        mode http
        timeout connect 5000ms
        timeout client 50000ms
        timeout server 50000ms
        stats enable
        stats uri /monitor
        stats auth root:meditech2017

    frontend http-in
        bind *:80
        default_backend servers

    backend servers
        balance roundrobin
        server web1 192.168.100.65:80 check
        server web2 192.168.100.66:80 check
```

Trong đó web1 là hostname, 192.168.100.65:80 là ip của server chạy web server. Ở đây mình đã dựng sẵn 2 web-server đơn giản với apache.

Tiến hành tương tự với `haproxy2`.

- Sau khi cài đặt, tiến hành start và cho phép dịch vụ khởi động cùng hệ thống.

``` sh
systemctl start haproxy
systemctl enable haproxy
```

- Mở port 80 để người dùng có thể truy cập

``` sh
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
```

- Truy cập vào địa chỉ của haproxy và kiểm tra

<img src="https://i.imgur.com/VNWM7Sp.png">

Tiến hành F5 lại và kiểm tra

<img src="https://i.imgur.com/E8jIXyV.png">

Như vậy haproxy đã hoạt động, vì ta sử dụng roundrobin nên hai các request sẽ được direct lần lượt qua hai server.

<a name="3"></a>
## 3. Cấu hình keepalived

- Cài đặt package

`yum install keepalived -y`

- Cấu hình keepalived

**Trên server haproxy1**

`vi /etc/keepalived/keepalived.conf`

``` sh
vrrp_instance VI_1 {
  interface ens3
  state MASTER
  virtual_router_id 51
  priority 101
  virtual_ipaddress {
    192.168.100.151
  }
}
```

**Trên server haproxy1**

``` sh
rrp_instance VI_1 {
  interface ens3
  state BACKUP
  virtual_router_id 51
  priority 100
  virtual_ipaddress {
    192.168.100.151
  }
}
```

- Sau khi cấu hình xong, start dịch vụ và cho phép khởi động cùng hệ thống

``` sh
systemctl start keepalived
systemctl enable keepalived
```

- Kiểm tra xem trên node MASTER đã có virtual ip chưa

<img src="https://i.imgur.com/jUh83s1.png">

Tiến hành truy cập vào địa chỉ VIP để kiểm tra:

<img src="https://i.imgur.com/tjyCosf.png">

- Tiến hành tắt server `haproxy1` và kiểm tra tại server `haproxy2`

<img src="https://i.imgur.com/k6de4sR.png">

- Như vậy VIP đã ngay lập tức được chuyển qua server BACKUP

**Tài liệu tham khảo**

https://www.adminvietnam.org/cau-hinh-haproxy-va-keepalived/357/

https://itlabvn.net/he-thong/huong-dan-cai-dat-cau-hinh-keepalived-va-haproxy-tren-centos
