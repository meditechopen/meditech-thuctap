# QoS network trong OPS

## Mục lục

[1. QoS là gì và để làm gì?](#1)

[2. Hướng dẫn cấu hình QoS network trong OPS](#2)

[3. Hướng dẫn test cấu hình](#3)

-----------

<a name="1"></a>
## 1. QoS là gì và để làm gì?

QoS được hiểu là khả năng đảm bảo về các yêu cầu liên quan tới network như bandwidth, latency, jitter và tính tin cậy trong việc tuân thủ theo Service Level Agreement (SLA) giữa nhà cung cấp ứng dụng và người dùng.

Ví dụ đơn giản đó là chúng ta có thể set bandwidth cho từng loại traffic (những traffic như Voice over IP, streaming,... cần được ưu tiên hơn chẳng hạn)

QoS policies có thể được áp dụng:

- Theo từng network: Tất cả các ports được gán vào network nơi có QoS policies sẽ được áp dụng.
- Theo từng port: Các port cụ thể sẽ được áp dụng các policies, khi port đã có policies rồi thì nó sẽ bị ghi đè.

Trong OPS, QoS là một advanced service plug-in, nó được khai báo trong code của neutron và cung cấp thông qua ml2 extension driver.

<a name="2"></a>
## 2. Hướng dẫn cấu hình QoS network trong OPS

- Cấu hình thêm qos service trong file `/etc/neutron/neutron.conf` ở node network

``` sh
[DEFAULT]

service_plugins = router,qos
```

- Khai báo trong file `/etc/neutron/plugins/ml2/ml2_conf.ini`

``` sh
[ml2]
extension_drivers = port_security, qos
```

- Khai báo trong file `/etc/neutron/plugins/ml2/openvswitch_agent.ini`

``` sh
[agent]
extensions = qos
```

- Trên compute node, khai báo extensions trong file `/etc/neutron/plugins/ml2/openvswitch_agent.ini`

``` sh
[agent]
extensions = qos
```

**Hướng dẫn tạo QoS policy and its bandwidth limit rule:**

Mặc định thì chỉ có admins mới có thể tạo QoS policies , bạn có thể thay đổi cấu hình trong file `policy.json` để cho phép người dùng trên các projects xem được và tạo QoS policies.

Ví dụ:

``` sh
"get_policy": "rule:regular_user",
"create_policy": "rule:regular_user",
"update_policy": "rule:regular_user",
"delete_policy": "rule:regular_user",
```

- Câu lệnh để tạo policy mới:

``` sh
neutron qos-policy-create bw-limiter

[root@controller ~(keystone_admin)]# neutron qos-policy-create bw-limiter
Created a new policy:
+-----------------+--------------------------------------+
| Field           | Value                                |
+-----------------+--------------------------------------+
| created_at      | 2017-10-11T02:28:50Z                 |
| description     |                                      |
| id              | 349ba7d1-95f7-437b-aa82-24a907550ce2 |
| name            | bw-limiter                           |
| project_id      | fe365fdcc17c487f9cf7d375fa01a379     |
| revision_number | 1                                    |
| rules           |                                      |
| shared          | False                                |
| tenant_id       | fe365fdcc17c487f9cf7d375fa01a379     |
| updated_at      | 2017-10-11T02:28:50Z                 |
+-----------------+--------------------------------------+
```

- Set up bandwidth cho policy

``` sh
neutron qos-bandwidth-limit-rule-create --max-kbps 102400 --max-burst-kbps 1000 bw-limiter
```

**Lưu ý:**

Mặc định traffic sẽ được limit theo chiều egress đối với các port được áp policy, để thay đổi sang chiều ingress, sử dụng câu lệnh sau:

``` sh
openstack network qos rule create --type bandwidth-limit --max-kbps 3000 \
    --max-burst-kbits 300 --ingress bw-limiter
```

Tuy nhiên câu lệnh này chỉ có tác dụng trong một vài bản OPS gần đây, những bản cũ không thể áp policy theo chiều ingress được

- Để hiển thị các port, sử dụng câu lệnh sau:

``` sh
neutron port-list
```

- Áp rule vào port cần thiết lập

`neutron port-update ID_PORT --qos-policy bw-limiter`

- Để áp policy vào network, sử dụng câu lệnh

``` sh
openstack network set --qos-policy bw-limiter private
```

Tuy nhiên câu lệnh này cũng không thể áp dụng với các bản OPS cũ như mitaka, newton

- Bỏ rule của port vừa thiết lập

`neutron port-update ID_PORT --no-qos-policy`

<a name="3"></a>
## 3. Hướng dẫn test cấu hình

- Môi trường mình sử dụng để test là OPS newton được dựng trên hệ thống ảo hóa gồm 1 node controller và 2 node compute

- Để control được bandwidth thì trước tiên ta cần biết được bandwidth mặc định của các máy ảo trong openstack. Đối với môi trường thực tế (các máy physical), mình đo được bandwidth giữa các máy ảo trong cùng một compute rơi vào khoảng hơn 10gbps. Đối với các máy ảo ở khác compute thì nó bằng với bandwidth đường mạng bên ngoài.

Sau đây là bandwidth của môi trường lab mà mình sử dụng:

- Giữa các máy ảo trong cùng compute:

``` sh
root@vm02:~# nuttcp 192.168.100.48
 1460.7117 MB /  10.02 sec = 1222.7274 Mbps 41 %TX 34 %RX 0 retrans 1.90 msRTT
```

- Giữa các máy ảo khác compute:

``` sh
root@vm03:~# nuttcp 192.168.100.45
  227.6125 MB /  10.10 sec =  189.1304 Mbps 43 %TX 53 %RX 0 retrans 2.50 msRTT
```

- Như vậy ở hệ thống lab của mình, bandwidth giữa các máy ảo cùng compute sẽ rơi vào khoảng hơn 1gbps còn các máy ảo khác compute sẽ là khoảng gần 190mbps.

- Ở đây mình tạo một policy rule với limit bandwidth là 100 mbps và áp nó vào một port sau đó dùng nuttcp để đo lại traffic từ nó tới một máy ảo trong cùng compute và 1 máy ảo khác compute:

``` sh
neutron qos-bandwidth-limit-rule-create --max-kbps 102400 --max-burst-kbps 1000 bw-limiter
neutron port-update 5f6cd58b-8e73-42e1-9fad-b7b6531483de --qos-policy bw-limiter
```

Và đây là kết quả khi đo với một máy cùng compute:

``` sh
root@vm04:~# nuttcp 192.168.100.45
  109.0521 MB /  10.03 sec =   91.2076 Mbps 6 %TX 41 %RX 0 retrans 1.63 msRTT
root@vm04:~# nuttcp 192.168.100.45
  111.7376 MB /  10.02 sec =   93.5570 Mbps 12 %TX 37 %RX 0 retrans 1.89 msRTT
```

Kết quả khi đo với máy khác compute:

``` sh
root@vm04:~# nuttcp 192.168.100.46
   99.3936 MB /  10.06 sec =   82.8852 Mbps 20 %TX 50 %RX 0 retrans 2.20 msRTT
root@vm04:~# nuttcp 192.168.100.46
   97.8260 MB /  10.06 sec =   81.5569 Mbps 19 %TX 48 %RX 0 retrans 2.47 msRTT
```

bandwidth ổn định ở mức 80-90 mbps.

- Tuy nhiên các traffic ingress vào port này vẫn không có sự thay đổi về bandwidth:

``` sh
# different compute
root@vm03:~# nuttcp 192.168.100.48
  200.6303 MB /  10.11 sec =  166.4986 Mbps 34 %TX 32 %RX 0 retrans 3.45 msRTT

# same compute
root@vm02:~# nuttcp 192.168.100.48
 1473.9375 MB /  10.02 sec = 1234.0992 Mbps 38 %TX 36 %RX 0 retrans 2.79 msRTT
```

Link tham khảo:

https://github.com/hocchudong/ghichep-OpenStack/blob/master/04-Neutron/ghichep-neutron.md

http://specs.openstack.org/openstack/neutron-specs/specs/liberty/qos-api-extension.html

https://docs.openstack.org/neutron/latest/admin/config-qos.html

https://docs.openstack.org/mitaka/networking-guide/config-qos.html
