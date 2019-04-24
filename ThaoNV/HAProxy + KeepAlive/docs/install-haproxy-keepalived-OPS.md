# Hướng dẫn cài HAProxy và keepalived trên OPS

## Mục lục

[1. Mô hình](#)

[2. Tạo VIP](#)

[3. Cấu hình haproxy + keepalived](#)

[4. Cấu hình trên OPS](#)

-------------------

<a name="1"></a>
## 1. Mô hình

<img src="https://i.imgur.com/0jaqpCU.png">

OS: Ubuntu 14.04

<a name="2"></a>
## 2. Tạo VIP

Sử dụng câu lệnh

`openstack port create --network <net-id> vip`

<img src="https://i.imgur.com/62OIVyW.png">

Bạn có thể chỉ định ip bằng tùy chọn `--fixed-ip`

Ta sẽ sử dụng port này để chứa IP VIP.

<a name="3"></a>
## 3.Cấu hình haproxy + keepalived

Tham khảo [tại đây](https://github.com/thaonguyenvan/meditech-thuctap/blob/master/ThaoNV/HAProxy%20%2B%20KeepAlive/docs/lab-haproxy-keepalived.md)

Ở đây mình sẽ cấu hình haproxy và keepalived cơ bản với 2 web-server cài apache2

**Cấu hình haproxy**

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
        bind 192.168.100.51:80
        balance  roundrobin
        mode  http
        server haproxy1 192.168.100.52:80 check
        server haproxy2 192.168.100.55:80 check
```

Trong đó `192.168.100.52` và `192.168.100.55` là 2 web server của mình. Trên đây mình có cấu hình một trang web đơn giản:

<img src="https://i.imgur.com/PvwTTtB.png">

Tương tự với web server còn lại

<img src="https://i.imgur.com/PYA4Kv2.png">

**Cấu hình keepalived trên haproxy1**

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
            192.168.100.51         
        }
        track_script {
            chk_haproxy
        }
}
```

Trong đó `192.168.10.51` là ip của port VIP mà ta đã tạo lúc đầu.

Đối với `haproxy2`, tiến hành cấu hình tương tự nhưng thay `MASTER` bằng `BACKUP` và `priority` từ `100` thành `99`.

Sau khi cấu hình, khởi động lại 2 dịch vụ

``` sh
service haproxy restart
service keepalived restart
```

<a name="4"></a>
## 4. Cấu hình trên OPS


**Cấu hình neutron**

Vì mặc định thì Neutron chỉ cho phép mỗi port lắng nghe traffic trên 1 địa chỉ IP nhưng haproxy thì cần VIP.

Vì thế ta cần cấu hình để port lắng nghe nhiều IP. Đầu tiên ta tìm port ID bằng câu lệnh

`nova interface-list haproxy1`

<img src="https://i.imgur.com/tSz8Z7p.png">

`nova interface-list haproxy2`

<img src="https://i.imgur.com/rnDSw32.png">

- Sau đó xem thông tin chi tiết các port

`openstack port show 16cb05d9-9694-499e-8412-64ed3943cb84`

<img src="https://i.imgur.com/2Egfh1i.png">

Tương tự với port còn lại

`openstack port show b1ef066b-05a3-4c71-bf5a-71a8f6a2d557`

<img src="https://i.imgur.com/5KafhYM.png">

- Cuối cùng ta phải thêm VIP vào từng port bằng câu lệnh

`neutron port-update 16cb05d9-9694-499e-8412-64ed3943cb84 --allowed_address_pairs list=true type=dict ip_address=192.168.100.51`

<img src="https://i.imgur.com/wGfgvAs.png">

`neutron port-update b1ef066b-05a3-4c71-bf5a-71a8f6a2d557 --allowed_address_pairs list=true type=dict ip_address=192.168.100.51`

<img src="https://i.imgur.com/BRoS61E.png">

**Kiểm tra lại**

Ta thấy IP đã lên trên phía haproxy1

<img src="https://i.imgur.com/L0gM6pL.png">

Trong khi đó haproxy2 chỉ có 1 IP

<img src="https://i.imgur.com/nKUWX4z.png">

Nếu haproxy1 bị tắt, ngay lập tức IP sẽ chuyển sang phía haproxy2

<img src="https://i.imgur.com/UJPeKGs.png">

Kiểm tra VIP :

<img src="https://i.imgur.com/JMXR036.png">

**Tài liệu tham khảo**

https://www.stratoscale.com/blog/compute/highly-available-lb-openstack-instead-lbaas/

https://www.stratoscale.com/blog/openstack/load-balancer-openstack-without-lbaas/
