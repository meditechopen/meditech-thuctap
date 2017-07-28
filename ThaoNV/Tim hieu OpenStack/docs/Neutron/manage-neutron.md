# Lab cơ bản với neutron

## Mục lục

[1. Cài đặt neutron](#install)

[2. Quản lí network resources](#resource)

  - [2.1 Network](#network)
  - [2.2 Subnet](#subnet)
  - [2.3 Port](#port)

[3. Quản lí security group](#security)

-----------

<a name="install"></a>
## 1. Cài đặt neutron

Tham khảo cách cài đặt neutron sử dụng Linux Bridge (mix provider và self-service network (flat)) [tại đây](https://github.com/thaonguyenvan/meditech-ghichep-openstack/blob/master/docs/hd-caidat-openstack-newton-centos7.md#neutron) hoặc cách cài đặt neutron với bonding và OVS (mix provider và self-service network (flat)) [tại đây](https://github.com/thaonguyenvan/meditech-ghichep-openstack/blob/master/docs/hd-caidat-openstack-newton-OVS-bonding.md#neutron).

<a name="resource"></a>
## 2. Quản lí network resources

<a name="network"></a>
### 2.1 Network

**Tạo network**

Sử dụng câu lệnh `neutron net-create` hoặc `openstack network create` để tạo mới một external network theo kiểu flat

``` sh
. admin-openrc
openstack network create --share --provider-physical-network provider \
  --provider-network-type flat provider1
```

**Kiểm tra các network đang có**

Sử dụng câu lệnh `openstack network list` hoặc `neutron net-list` để kiểm tra có những network nào trong hệ thống

``` sh
[root@controller ~]#  neutron net-list
+--------------------------------------+--------------+------------------------------------------------------+
| id                                   | name         | subnets                                              |
+--------------------------------------+--------------+------------------------------------------------------+
| 8323f446-89fe-48cd-9bce-0b4cb3f6f8d6 | selfservice  | 4f241645-65bf-4837-871d-8b8adcfd27bf 192.168.11.0/24 |
| 8c839ac1-f406-4b6f-9602-64477c11c430 | provider1    | eba1913b-0b1f-44e4-9f7e-379285b48c88 172.16.69.0/24  |
| c705dab9-f3a5-4adb-95f0-5a5bbe5dfc56 | selfservice2 | 8c215605-afee-4a6c-a2b5-eb1c17f483b7 10.10.10.0/24   |
+--------------------------------------+--------------+------------------------------------------------------+
```

**Show thông tin một network**

Để xem thông tin chi tiết của network, sử dụng câu lệnh `neutron net-show` hoặc `openstack network show`

``` sh
[root@controller ~]# neutron net-show provider1
+---------------------------+--------------------------------------+
| Field                     | Value                                |
+---------------------------+--------------------------------------+
| admin_state_up            | True                                 |
| availability_zone_hints   |                                      |
| availability_zones        | nova                                 |
| created_at                | 2017-07-06T05:00:20Z                 |
| description               |                                      |
| id                        | 8c839ac1-f406-4b6f-9602-64477c11c430 |
| ipv4_address_scope        |                                      |
| ipv6_address_scope        |                                      |
| is_default                | False                                |
| mtu                       | 1500                                 |
| name                      | provider1                            |
| port_security_enabled     | True                                 |
| project_id                | e9264a9f015143758c744d7a2fc58eae     |
| provider:network_type     | flat                                 |
| provider:physical_network | provider                             |
| provider:segmentation_id  |                                      |
| revision_number           | 7                                    |
| router:external           | True                                 |
| shared                    | True                                 |
| status                    | ACTIVE                               |
| subnets                   | eba1913b-0b1f-44e4-9f7e-379285b48c88 |
| tags                      |                                      |
| tenant_id                 | e9264a9f015143758c744d7a2fc58eae     |
| updated_at                | 2017-07-07T09:37:34Z                 |
+---------------------------+--------------------------------------+
```

<a name="subnet"></a>
### 2.2 Subnet

**Tạo subnet**

Tạo subnet cho network vừa tạo, tại đây ta khai báo dải mạng cấp dhcp và dns, gateway cho network.

Lưu ý: đối với external network thì dải mạng khai báo phải trùng với dải provider để máy ảo ra ngoài.

``` sh
openstack subnet create --subnet-range 172.16.69.0/24 --gateway 172.16.69.1 \
  --network provider1 --allocation-pool start=172.16.69.242,end=172.16.69.250 \
  --dns-nameserver 8.8.8.8 provider1-v4
```

**Lưu ý:** Đối với self-service network, ta cần tạo router và gán cổng cho nó. Đầu ra của router sẽ được gán vào dải provider và đầu còn lại là của self-service. Như vậy, các máy ảo có thể ra được ngoài internet.

``` sh
openstack network set --external provider1
openstack network create selfservice1
openstack subnet create --subnet-range 192.168.1.0/24 \
  --network selfservice1 --dns-nameserver 8.8.8.8 selfservice1-v4
openstack router create router1
openstack router add subnet router1 selfservice1-v4
neutron router-gateway-set router1 provider1
```

**Xóa một subnet**

Để xóa subnet, bạn cần phải clear port trong router trước

- Xem những subnet đang có

``` sh
[root@controller ~]# neutron subnet-list
+--------------------------------------+--------------+-----------------+----------------------------------------------------+
| id                                   | name         | cidr            | allocation_pools                                   |
+--------------------------------------+--------------+-----------------+----------------------------------------------------+
| 4f241645-65bf-4837-871d-8b8adcfd27bf | selfservice  | 192.168.11.0/24 | {"start": "192.168.11.2", "end": "192.168.11.254"} |
| 8c215605-afee-4a6c-a2b5-eb1c17f483b7 | selfservice2 | 10.10.10.0/24   | {"start": "10.10.10.2", "end": "10.10.10.254"}     |
| eba1913b-0b1f-44e4-9f7e-379285b48c88 | provider1-v4 | 172.16.69.0/24  | {"start": "172.16.69.242", "end": "172.16.69.250"} |
+--------------------------------------+--------------+-----------------+----------------------------------------------------+
```

Ví dụ ở đây mình muốn xóa `selfservice2`

- Xem danh sách những router đang có

``` sh
[root@controller ~]# neutron router-list
+--------------------------------------+---------+------------------------------------------------------------------+-------------+-------+
| id                                   | name    | external_gateway_info                                            | distributed | ha    |
+--------------------------------------+---------+------------------------------------------------------------------+-------------+-------+
| 6c9927a0-851b-44dc-bf57-189a6b83ff89 | router2 | {"network_id": "8c839ac1-f406-4b6f-9602-64477c11c430",           | False       | False |
|                                      |         | "enable_snat": true, "external_fixed_ips": [{"subnet_id":        |             |       |
|                                      |         | "eba1913b-0b1f-44e4-9f7e-379285b48c88", "ip_address":            |             |       |
|                                      |         | "172.16.69.250"}]}                                               |             |       |
| aa7bc81a-eaa5-477b-8222-c0e2b4abe099 | router  | {"network_id": "8c839ac1-f406-4b6f-9602-64477c11c430",           | False       | False |
|                                      |         | "enable_snat": true, "external_fixed_ips": [{"subnet_id":        |             |       |
|                                      |         | "eba1913b-0b1f-44e4-9f7e-379285b48c88", "ip_address":            |             |       |
|                                      |         | "172.16.69.249"}]}                                               |             |       |
+--------------------------------------+---------+------------------------------------------------------------------+-------------+-------+
```

- Xem các port của router để xem subnet `selfservice2` đang được gán vào đâu

``` sh
[root@controller ~]# neutron router-port-list 6c9927a0-851b-44dc-bf57-189a6b83ff89
+--------------------------------------+------+-------------------+--------------------------------------------------------------------------------------+
| id                                   | name | mac_address       | fixed_ips                                                                            |
+--------------------------------------+------+-------------------+--------------------------------------------------------------------------------------+
| 5ae40a29-b5ad-4286-922a-70312e30baec |      | fa:16:3e:d2:a8:36 | {"subnet_id": "eba1913b-0b1f-44e4-9f7e-379285b48c88", "ip_address": "172.16.69.250"} |
| 99b8677c-4025-4e33-bf0b-35f7bf53e168 |      | fa:16:3e:d7:53:03 | {"subnet_id": "8c215605-afee-4a6c-a2b5-eb1c17f483b7", "ip_address": "10.10.10.1"}    |
+--------------------------------------+------+-------------------+--------------------------------------------------------------------------------------+
```

Như vậy subnet `selfservice2` đang được gán vào router2, ta tiến hành xóa subnet khỏi router2

``` sh
[root@controller ~]# neutron router-interface-delete 6c9927a0-851b-44dc-bf57-189a6b83ff89 8c215605-afee-4a6c-a2b5-eb1c17f483b7
Removed interface from router 6c9927a0-851b-44dc-bf57-189a6b83ff89.
```

Giờ đây ta có thể xóa subnet

``` sh
[root@controller ~]# neutron subnet-delete 8c215605-afee-4a6c-a2b5-eb1c17f483b7
Deleted subnet(s): 8c215605-afee-4a6c-a2b5-eb1c17f483b7
[root@controller ~]# neutron subnet-list
+--------------------------------------+--------------+-----------------+----------------------------------------------------+
| id                                   | name         | cidr            | allocation_pools                                   |
+--------------------------------------+--------------+-----------------+----------------------------------------------------+
| 4f241645-65bf-4837-871d-8b8adcfd27bf | selfservice  | 192.168.11.0/24 | {"start": "192.168.11.2", "end": "192.168.11.254"} |
| eba1913b-0b1f-44e4-9f7e-379285b48c88 | provider1-v4 | 172.16.69.0/24  | {"start": "172.16.69.242", "end": "172.16.69.250"} |
+--------------------------------------+--------------+-----------------+----------------------------------------------------+
```

Sau khi gỡ subnet khỏi router, bạn có thể xóa router bằng câu lệnh  `neutron router-delete <router-id>`

``` sh
[root@controller ~]# neutron router-delete 6c9927a0-851b-44dc-bf57-189a6b83ff89
Deleted router(s): 6c9927a0-851b-44dc-bf57-189a6b83ff89
```

Xóa luôn network bằng câu lệnh `neutron net-delete`

``` sh
[root@controller ~]# neutron net-delete c705dab9-f3a5-4adb-95f0-5a5bbe5dfc56
Deleted network(s): c705dab9-f3a5-4adb-95f0-5a5bbe5dfc56
```

**Tạo và gán floating IP**

Đối với những máy sử dụng tenant network, chúng có thể giao tiếp với nhau nhưng lại không thể ra được ngoài internet cũng như khi ta ở bên ngoài, ta sẽ không ssh vào được máy ảo. Floating IP ra đời để giải quyết vấn đề này, bạn chỉ cần tạo 1 floating ip từ external network rồi gán vào máy ảo. Mặc định số floating ip tối đa được tạo là 10.

- Để tạo floating ip, sử dụng câu lệnh `neutron floatingip-create`

``` sh
[root@controller ~]# neutron floatingip-create provider1
Created a new floatingip:
+---------------------+--------------------------------------+
| Field               | Value                                |
+---------------------+--------------------------------------+
| created_at          | 2017-07-28T03:47:51Z                 |
| description         |                                      |
| fixed_ip_address    |                                      |
| floating_ip_address | 172.16.69.247                        |
| floating_network_id | 8c839ac1-f406-4b6f-9602-64477c11c430 |
| id                  | 887c48f1-d1e6-4853-bc68-f1a5d8f06b1f |
| port_id             |                                      |
| project_id          | e9264a9f015143758c744d7a2fc58eae     |
| revision_number     | 1                                    |
| router_id           |                                      |
| status              | DOWN                                 |
| tenant_id           | e9264a9f015143758c744d7a2fc58eae     |
| updated_at          | 2017-07-28T03:47:51Z                 |
+---------------------+--------------------------------------+
```

- Xem danh sách các máy ảo

``` sh
[root@controller ~]# nova list
+--------------------------------------+------+--------+------------+-------------+-----------------------+
| ID                                   | Name | Status | Task State | Power State | Networks              |
+--------------------------------------+------+--------+------------+-------------+-----------------------+
| 1219a385-8bea-47cc-aae9-7c274ab9065b | vm01 | ACTIVE | -          | Running     | selfservice2=10.0.0.4 |
+--------------------------------------+------+--------+------------+-------------+-----------------------+
```

Ở đây mình có một máy ảo đang được gán vào self-service network có địa chỉ ip là `10.0.0.4`

Xem danh sách các port

``` sh
[root@controller ~]# neutron port-list
+--------------------------------------+------+-------------------+--------------------------------------------------------------------------------------+
| id                                   | name | mac_address       | fixed_ips                                                                            |
+--------------------------------------+------+-------------------+--------------------------------------------------------------------------------------+
| 3eb8506a-9b22-4588-b648-8af93c89249f |      | fa:16:3e:a9:38:2d | {"subnet_id": "546273cd-8244-4c8c-861a-6239e4660d8f", "ip_address": "10.0.0.1"}      |
| 5910cfed-e9d9-43d6-b7aa-f5ba9be5f7a0 |      | fa:16:3e:01:0c:15 | {"subnet_id": "eba1913b-0b1f-44e4-9f7e-379285b48c88", "ip_address": "172.16.69.242"} |
| 683b1840-6056-48a5-bcd6-2826f966451f |      | fa:16:3e:c2:d0:45 | {"subnet_id": "546273cd-8244-4c8c-861a-6239e4660d8f", "ip_address": "10.0.0.4"}      |
| f737097b-55ed-4edb-8b4b-5a5e83a28ffe |      | fa:16:3e:8b:a2:cb | {"subnet_id": "546273cd-8244-4c8c-861a-6239e4660d8f", "ip_address": "10.0.0.2"}      |
+--------------------------------------+------+-------------------+--------------------------------------------------------------------------------------+
```

- Gán floating ip vào port

``` sh
[root@controller ~]# neutron floatingip-associate 887c48f1-d1e6-4853-bc68-f1a5d8f06b1f 683b1840-6056-48a5-bcd6-2826f966451f
Associated floating IP 887c48f1-d1e6-4853-bc68-f1a5d8f06b1f
```

- Kiểm tra lại

``` sh
[root@controller ~]# nova list
+--------------------------------------+------+--------+------------+-------------+--------------------------------------+
| ID                                   | Name | Status | Task State | Power State | Networks                             |
+--------------------------------------+------+--------+------------+-------------+--------------------------------------+
| 1219a385-8bea-47cc-aae9-7c274ab9065b | vm01 | ACTIVE | -          | Running     | selfservice2=10.0.0.4, 172.16.69.247 |
+--------------------------------------+------+--------+------------+-------------+--------------------------------------+
```

Máy ảo đã được gán floating IP, ta có thể ssh vào từ bên ngoài.

<a name="port"></a>
### 2.3 Port

**Xem danh sách các port**

Để hiển thị danh sách các port đang được sử dụng và ip của các port ấy. Sử dụng câu lệnh `neutron port-list`

``` sh
[root@controller ~]# neutron port-list
+--------------------------------------+------+-------------------+--------------------------------------------------------------------------------------+
| id                                   | name | mac_address       | fixed_ips                                                                            |
+--------------------------------------+------+-------------------+--------------------------------------------------------------------------------------+
| 354c2f67-5fde-495c-8b96-1a0c73c91194 |      | fa:16:3e:bf:4a:5a | {"subnet_id": "eba1913b-0b1f-44e4-9f7e-379285b48c88", "ip_address": "172.16.69.245"} |
| 5910cfed-e9d9-43d6-b7aa-f5ba9be5f7a0 |      | fa:16:3e:01:0c:15 | {"subnet_id": "eba1913b-0b1f-44e4-9f7e-379285b48c88", "ip_address": "172.16.69.242"} |
| 5ae40a29-b5ad-4286-922a-70312e30baec |      | fa:16:3e:d2:a8:36 | {"subnet_id": "eba1913b-0b1f-44e4-9f7e-379285b48c88", "ip_address": "172.16.69.250"} |
| 99b8677c-4025-4e33-bf0b-35f7bf53e168 |      | fa:16:3e:d7:53:03 | {"subnet_id": "8c215605-afee-4a6c-a2b5-eb1c17f483b7", "ip_address": "10.10.10.1"}    |
| 9fb5e9e7-01f2-4f94-8fd1-804399066492 |      | fa:16:3e:98:66:a2 | {"subnet_id": "8c215605-afee-4a6c-a2b5-eb1c17f483b7", "ip_address": "10.10.10.2"}    |
| baff8c21-1446-462d-886a-d97a7fe34e1a |      | fa:16:3e:f0:a5:6c | {"subnet_id": "4f241645-65bf-4837-871d-8b8adcfd27bf", "ip_address": "192.168.11.2"}  |
| cc8bc937-9095-4fc6-8f5e-abae8393498b |      | fa:16:3e:93:55:3f | {"subnet_id": "eba1913b-0b1f-44e4-9f7e-379285b48c88", "ip_address": "172.16.69.249"} |
| dcf5eb90-7127-4168-8224-be95c041653e |      | fa:16:3e:17:da:ed | {"subnet_id": "4f241645-65bf-4837-871d-8b8adcfd27bf", "ip_address": "192.168.11.1"}  |
+--------------------------------------+------+-------------------+--------------------------------------------------------------------------------------+
```

**Xem thông tin chi tiết 1 port**

Để hiển thị thông tin chi tiết của 1 port, sử dụng câu lệnh `neutron port-show port-ID`

``` sh
[root@controller ~]# neutron port-show 99b8677c-4025-4e33-bf0b-35f7bf53e168
+-----------------------+-----------------------------------------------------------------------------------+
| Field                 | Value                                                                             |
+-----------------------+-----------------------------------------------------------------------------------+
| admin_state_up        | True                                                                              |
| allowed_address_pairs |                                                                                   |
| binding:host_id       | controller                                                                        |
| binding:profile       | {}                                                                                |
| binding:vif_details   | {"port_filter": true, "ovs_hybrid_plug": true}                                    |
| binding:vif_type      | ovs                                                                               |
| binding:vnic_type     | normal                                                                            |
| created_at            | 2017-07-07T10:23:17Z                                                              |
| description           |                                                                                   |
| device_id             | 6c9927a0-851b-44dc-bf57-189a6b83ff89                                              |
| device_owner          | network:router_interface                                                          |
| extra_dhcp_opts       |                                                                                   |
| fixed_ips             | {"subnet_id": "8c215605-afee-4a6c-a2b5-eb1c17f483b7", "ip_address": "10.10.10.1"} |
| id                    | 99b8677c-4025-4e33-bf0b-35f7bf53e168                                              |
| mac_address           | fa:16:3e:d7:53:03                                                                 |
| name                  |                                                                                   |
| network_id            | c705dab9-f3a5-4adb-95f0-5a5bbe5dfc56                                              |
| port_security_enabled | False                                                                             |
| project_id            | e9264a9f015143758c744d7a2fc58eae                                                  |
| revision_number       | 26                                                                                |
| security_groups       |                                                                                   |
| status                | ACTIVE                                                                            |
| tenant_id             | e9264a9f015143758c744d7a2fc58eae                                                  |
| updated_at            | 2017-07-21T08:54:57Z                                                              |
+-----------------------+-----------------------------------------------------------------------------------+
```

<a name="security"></a>
## 3. Quản lí security groups

Security Groups là các firewall rules có trách nhiệm filter các dữ liệu đi vào và đi ra cho máy ảo. Chúng được implement bởi iptables rules.

- Tạo mới một Security Group

``` sh
[root@controller ~]# nova secgroup-create apress-sgroup "Apress secgroup"
+--------------------------------------+---------------+-----------------+
| Id                                   | Name          | Description     |
+--------------------------------------+---------------+-----------------+
| ab6d4246-4f09-4178-aae5-e423a3a8d12f | apress-sgroup | Apress secgroup |
+--------------------------------------+---------------+-----------------+
```

- Thêm rule vào cho security group

``` sh
[root@controller ~]# nova secgroup-add-rule apress-sgroup tcp 22 22 0.0.0.0/0
+-------------+-----------+---------+-----------+--------------+
| IP Protocol | From Port | To Port | IP Range  | Source Group |
+-------------+-----------+---------+-----------+--------------+
| tcp         | 22        | 22      | 0.0.0.0/0 |              |
+-------------+-----------+---------+-----------+--------------+
```

- Hiển thị danh sách các rule đang có của 1 security group

`nova secgroup-list-rules apress-sgroup`

- Gán security group vào máy ảo

`nova add-secgroup vm01 apress-sgroup`

- Xóa security group khỏi máy ảo

`nova remove-secgroup vm01 default`

Xem thêm về các câu lệnh với security group rule [tại đây](https://docs.openstack.org/python-openstackclient/latest/cli/command-objects/security-group-rule.html).
