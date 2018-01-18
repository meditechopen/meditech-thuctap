# Hướng dẫn cài đặt và cấu hình HAProxy + keepalived trên CentOS 7

## Mục lục

[1. Mô hình](#1)

[2. Cấu hình keepalived](#3)

[3. Cấu hình haproxy](#2)


-----------

<a name="1"></a>
## 1. Mô hình

<img src="https://i.imgur.com/2XqhdTK.png">

Môi trường lab: KVM

HĐH: CentOS 7.3 - 17.08

**Lưu ý:** Nếu bạn sử dụng hđh CentOS 7.3-1611 thì sẽ phải update trước khi cài keepalived

<a name="3"></a>
## 2. Cấu hình keepalived

- Cài đặt package

`yum install keepalived -y`

Để cho phép HAProxy ràng buộc vào các địa chỉ IP được chia sẻ, chúng ta thêm dòng sau vào /etc/sysctl.conf :

`vi /etc/sysctl.conf`

thêm vào file dòng sau:

`net.ipv4.ip_nonlocal_bind=1`

kiểm tra

`sysctl -p`

- Cấu hình keepalived

**Trên server haproxy1**

`vi /etc/keepalived/keepalived.conf`

``` sh
vrrp_script chk_haproxy {           
        script "killall -0 haproxy"     
        interval 2                      
        weight 2                        
}

vrrp_instance VI_1 {
        interface eth0
        state MASTER
        virtual_router_id 51
        priority 101                    
        virtual_ipaddress {
            192.168.100.37         
        }
        track_script {
            chk_haproxy
        }
}
```

**Trên server haproxy2**

``` sh
vrrp_script chk_haproxy {       
        script "killall -0 haproxy"     
        interval 2                      
        weight 2                        
}

vrrp_instance VI_1 {
        interface eth0
        state BACKUP
        virtual_router_id 51
        priority 100                    
        virtual_ipaddress {
            192.168.100.37              
        }
        track_script {
            chk_haproxy
        }
}
```

Note: Thử chạy `killall -0 haproxy` nếu server báo `command not found`, bạn cần cài gói `psmisc`.

- Sau khi cấu hình xong, start dịch vụ và cho phép khởi động cùng hệ thống

``` sh
systemctl start keepalived
systemctl enable keepalived
```

- Kiểm tra xem trên node MASTER đã có virtual ip chưa

<img src="https://i.imgur.com/jUh83s1.png">

<a name="2"></a>
## 3. Cấu hình haproxy

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

listen httpd
    bind 192.168.100.37:80
    balance  roundrobin
    mode  http
    server web1 10.10.10.35:80 check
    server web2 10.10.10.36:80 check
```

Trong đó 192.168.100.37 là ip VIP, web1 là hostname, 192.168.100.35:80 là ip của server chạy web server. Ở đây mình đã dựng sẵn 2 web-server đơn giản với apache.

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

Tiến hành truy cập vào địa chỉ VIP để kiểm tra:

<img src="https://i.imgur.com/tjyCosf.png">

- Tiến hành tắt dịch vụ haproxy tại server `haproxy1` và kiểm tra tại server `haproxy2`

<img src="https://i.imgur.com/k6de4sR.png">

- Như vậy VIP đã ngay lập tức được chuyển qua server BACKUP

**Tài liệu tham khảo**

https://www.adminvietnam.org/cau-hinh-haproxy-va-keepalived/357/

https://itlabvn.net/he-thong/huong-dan-cai-dat-cau-hinh-keepalived-va-haproxy-tren-centos
