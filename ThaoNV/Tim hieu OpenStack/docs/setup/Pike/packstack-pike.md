# Hướng dẫn cài đặt OpenStack Pike bằng Packstack trên CENTOS 7


## 1. Các bước chuẩn bị
### 1.1. Giới thiệu

- Lưu ý: Trong tài liệu này chỉ thực hiện cài đặt OpenStack.
- Packstack là một công cụ cài đặt OpenStack nhanh chóng.
- Packstack được phát triển bởi redhat
- Chỉ hỗ trợ các distro: RHEL, Centos
- Tự động hóa các bước cài đặt và lựa chọn thành phần cài đặt.
- Nhanh chóng dựng được môi trường OpenStack để sử dụng làm PoC nội bộ, demo khách hàng, test tính năng.
- Nhược điểm 1 : Đóng kín các bước cài đối với người mới.
- Nhược điểm 2: Khó bug các lỗi khi cài vì đã được đóng gói cùng với các tool cài đặt tự động (puppet)


### 1.2. Môi trường thực hiện

- Distro: CentOS 7.x
- OpenStack Pike
- NIC1 - ens3: Là dải mạng mà các máy ảo sẽ giao tiếp với bên ngoài. Dải mạng này sử dụng chế độ bridge hoặc NAT của VMware Workstation
- NIC2 - ens4: là dải mạng sử dụng cho các traffic MGNT + API + DATA VM. Dải mạng này sử dụng chế độ hostonly trong VMware Workstation


### 1.3. Mô hình

<img src="https://i.imgur.com/uOGzmSi.png">

### 1.4. IP Planning

<img src="https://i.imgur.com/0uj3Ueh.png">

## 2. Các bước cài đặt
### 2.1. Các bước chuẩn bị trên trên Controller

- Thiết lập hostname

	```sh
	hostnamectl set-hostname controller
	```

- Thiết lập IP

	```sh
  echo "Setup IP  ens3"
  nmcli c modify ens3 ipv4.addresses 192.168.100.73/24
  nmcli c modify ens3 ipv4.gateway 192.168.100.1
  nmcli c modify ens3 ipv4.dns 8.8.8.8
  nmcli c modify ens3 ipv4.method manual
  nmcli con mod ens3 connection.autoconnect yes

  echo "Setup IP  ens4"
  nmcli c modify ens4 ipv4.addresses 10.10.10.99/24
  nmcli c modify ens4 ipv4.method manual
  nmcli con mod ens4 connection.autoconnect yes

  sudo systemctl disable firewalld
  sudo systemctl stop firewalld
  sudo systemctl disable NetworkManager
  sudo systemctl stop NetworkManager
  sudo systemctl enable network
  sudo systemctl start network

	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

  ```
- Khai báo repos cho OpenStack Pike

```sh
    sudo yum install -y centos-release-openstack-pike
    yum update -y

    sudo yum install -y wget crudini fping
    yum install -y openstack-packstack
    init 6
```

### 2.2. Các bước chuẩn bị trên trên Compute1

- Thiết lập hostname

    ```sh
    hostnamectl set-hostname compute1
    ```

- Thiết lập IP

  ```sh
  echo "Setup IP  ens3"
  nmcli c modify ens3 ipv4.addresses 192.168.100.74/24
  nmcli c modify ens3 ipv4.gateway 192.168.100.1
  nmcli c modify ens3 ipv4.dns 8.8.8.8
  nmcli c modify ens3 ipv4.method manual
  nmcli con mod ens3 connection.autoconnect yes

  echo "Setup IP  ens4"
  nmcli c modify ens4 ipv4.addresses 10.10.10.100/24
  nmcli c modify ens4 ipv4.method manual
  nmcli con mod ens4 connection.autoconnect yes

  sudo systemctl disable firewalld
  sudo systemctl stop firewalld
  sudo systemctl disable NetworkManager
  sudo systemctl stop NetworkManager
  sudo systemctl enable network
  sudo systemctl start network

	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
  ```

- Khai báo repos cho OpenStack Pike

```sh
    sudo yum install -y centos-release-openstack-pike
    yum update -y

    sudo yum install -y wget crudini fping
    yum install -y openstack-packstack
    init 6
```

### 2.3. Các bước chuẩn bị trên trên Compute2

Làm tương tự như với compute1

### 2.4. Bắt đầu cài đặt `packstack` trên trên Controller

- Login vào máy chủ Controler và thực hiện các bước dưới bằng  quyền root.
- Thực hiện lệnh `fping` từ máy `controller` để kiểm tra các IP trên các máy đã thiết lập đúng hay chưa.
  ```sh
  fping 10.10.10.100 10.10.10.101
  ```
- Trong hướng dẫn này sẽ thực hiện cài đặt đồng thời 2 usecase về network của OpenStack, đó là `Provider network` và `Self service network`. Có nghĩa là máy ảo có thể gắn vào dải `provider` hoặc `selfservice`
- SSH vào máy chủ Controller và thực hiện bằng quyền `root`
- Sử dụng lệnh dưới để cài OpenStack.
- Khi cài, màn hình sẽ yêu cầu nhập mật khẩu của các máy COM1 và COM2, sau đó `packstack` sẽ tự động cài trên các máy này mà ko cần thao tác.

```sh
packstack --allinone \
    --default-password=Welcome123 \
    --os-cinder-install=y \
    --os-neutron-ovs-bridge-mappings=extnet:br-ex \
    --os-neutron-ovs-bridge-interfaces=br-ex:ens3 \
    --os-neutron-ovs-bridges-compute=br-ex \
    --os-neutron-ml2-type-drivers=vxlan,flat \
    --os-controller-host=192.168.100.73 \
    --os-compute-hosts=192.168.100.74,192.168.100.75 \
    --os-neutron-ovs-tunnel-if=ens4 \
    --provision-demo=n
```

- Sau khi cài đặt hoàn tất, trên màn hình sẽ xuất hiên thông báo về các kết quả cài đặt cùng với link truy cập và các tài khoản.

- Truy cập vào web theo địa chỉ `http://192.168.100.73/dashboard`, tài khoản là `admin`, mật khẩu là `Welcome123`

## 3. Sử dụng OpenStack sau khi cài đặt xong.

- Thực hiện lệnh dưới để khai báo biến môi trường mỗi khi đăng nhập phiên mới vào máy chủ.

	```
	source /root/keystonerc_admin
	```

- Kiểm tra trạng thái của các service NOVA bằng lệnh `openstack compute service list`, nếu state là `up` thì có thể tiếp tục các bước dưới.
```sh

[root@controller ~(keystone_admin)]# openstack compute service list
+----+------------------+------------+----------+---------+-------+----------------------------+
| ID | Binary           | Host       | Zone     | Status  | State | Updated At                 |
+----+------------------+------------+----------+---------+-------+----------------------------+
|  1 | nova-cert        | controller | internal | enabled | up    | 2017-07-17T08:49:13.000000 |
|  2 | nova-consoleauth | controller | internal | enabled | up    | 2017-07-17T08:49:15.000000 |
|  7 | nova-scheduler   | controller | internal | enabled | up    | 2017-07-17T08:49:11.000000 |
|  8 | nova-conductor   | controller | internal | enabled | up    | 2017-07-17T08:49:11.000000 |
|  9 | nova-compute     | compute1   | nova     | enabled | up    | 2017-07-17T08:49:10.000000 |
+----+------------------+------------+----------+---------+-------+----------------------------+

```

-  Kiểm tra trạng thái của dịch vụ neutron bằng lệnh `neutron agent-list`, nếu có biểu tượng `:)` thì có thể tiếp tục bước dưới.

```sh

[root@controller ~(keystone_admin)]# neutron agent-list
+--------------------------------------+--------------------+------------+-------------------+-------+----------------+---------------------------+
| id                                   | agent_type         | host       | availability_zone | alive | admin_state_up | binary                    |
+--------------------------------------+--------------------+------------+-------------------+-------+----------------+---------------------------+
| 61e342d2-91c6-434c-976a-3fb2c7cd5e7a | Metering agent     | controller |                   | :-)   | True           | neutron-metering-agent    |
| 6cb93409-5969-4393-bd7a-cb36bcac2124 | Open vSwitch agent | compute1   |                   | :-)   | True           | neutron-openvswitch-agent |
| 9ad40459-1a35-409f-9f84-09ef0a8db76c | DHCP agent         | controller | nova              | :-)   | True           | neutron-dhcp-agent        |
| bb28bd00-9124-4cb4-94a1-209bd429bdf0 | Metadata agent     | controller |                   | :-)   | True           | neutron-metadata-agent    |
| dda53f34-909c-425c-916d-08b75cb76545 | L3 agent           | controller | nova              | :-)   | True           | neutron-l3-agent          |
| e6a3cfb2-8f3a-425d-8172-62cdf457b4eb | Open vSwitch agent | controller |                   | :-)   | True           | neutron-openvswitch-agent |
+--------------------------------------+--------------------+------------+-------------------+-------+----------------+---------------------------+

```

### 3.1. Upload image
- Thực thi biến môi trường
  ```sh
  source ~/keystonerc_admin
  ```

- Upload images
  ```sh
  curl http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img | glance \
  image-create --name='cirros' \
  --visibility=public \
  --container-format=bare \
  --disk-format=qcow2
  ```

###  3.2. Tạo network, router
- Tạo network public
  ```sh
  neutron net-create external_network --provider:network_type flat \
  --provider:physical_network extnet  \
  --router:external \
  --shared
  ```

- Tạo subnet trong network public
  ```sh
  neutron subnet-create --name public_subnet \
  --enable_dhcp=True --dns-nameserver 8.8.8.8 \
  --allocation-pool=start=192.168.100.80,end=192.168.100.90 \
  --gateway=192.168.100.1 external_network 192.168.100.0/24
  ```

- Tạo network private
  ```sh
  neutron net-create private_network
  neutron subnet-create --name private_subnet private_network 10.10.10.0/24 \
  --dns-nameserver 8.8.8.8
  ```

Lưu ý: Sau khi tạo private_network sẽ hiện ra một bảng có chứa đoạn mã ID. Nếu thực hiện tiếp câu lệnh thứ hai của đoạn lệnh trên gặp phải lỗi `Multiple router matches found for name` ta thay thế tên `private_network` bằng mã ID của nó

- Tạo router tên là `Vrouter` và add các network vừa tạo ở trên vào router.

  ```sh
  neutron router-create Vrouter
  neutron router-gateway-set Vrouter external_network
  neutron router-interface-add Vrouter private_subnet
  ```
 Nếu cũng gặp lỗi ta thay thế tên Vrouter bằng ID của nó sau khi create Vrouter

- Kiểm tra IP của router vừa được gán interface

 ```sh

[root@controller ~(keystone_admin)]# neutron router-port-list 12ecfceb-b926-40b0-9ebb-0aa7efde8371
+--------------------------------------+------+-------------------+---------------------------------------------------------------------------------------+
| id                                   | name | mac_address       | fixed_ips                                                                             |
+--------------------------------------+------+-------------------+---------------------------------------------------------------------------------------+
| 0c058942-d544-4777-8fe3-69da28abd347 |      | fa:16:3e:db:86:3c | {"subnet_id": "d2ea77a8-1840-4b85-b940-0824eab873c2", "ip_address": "10.10.10.1"}     |
| adea7ad3-a74d-48ef-8551-65b0c72323aa |      | fa:16:3e:ab:d6:df | {"subnet_id": "c95bf9c4-fa38-402b-87bd-0d526721ee36", "ip_address": "192.168.100.89"} |
+--------------------------------------+------+-------------------+---------------------------------------------------------------------------------------+

```

12ecfceb-b926-40b0-9ebb-0aa7efde8371 là id của Vrouter

- Ping tới ip của dải provider để kiểm tra xem đã gán được interface hay chưa

```sh

[root@controller ~(keystone_admin)]# ping 192.168.100.89
PING 192.168.100.89 (192.168.100.89) 56(84) bytes of data.
64 bytes from 192.168.100.89: icmp_seq=1 ttl=64 time=0.272 ms
64 bytes from 192.168.100.89: icmp_seq=2 ttl=64 time=0.044 ms
64 bytes from 192.168.100.89: icmp_seq=3 ttl=64 time=0.041 ms
64 bytes from 192.168.100.89: icmp_seq=4 ttl=64 time=0.050 ms

```

- Mở các rule cần thiết cho máy ảo (trong thực tế nên mở các rule cần thiết, tránh mở tất cả các port như hướng dẫn này)

 ```sh

  openstack security group rule create --proto icmp default
  openstack security group rule create --proto tcp --dst-port 1:65535 default
  openstack security group rule create --proto udp --dst-port 1:65535 default

 ```
- Trước khi vào dashboard để tạo máy ảo ta cần chỉnh sửa một vài lỗi sau

	+ Không nhận metadata:

	Sửa file /etc/neutron/dhcp_agent.ini trên controller node

	``vi /etc/neutron/dhcp_agent.ini``

	Bỏ comment và sửa thành true

	``enable_isolated_metadata = True``

	Khởi động lại các service của neutron trên Controller node.

```sh

[root@controller ~(keystone_admin)]# neutron agent-list
+--------------------------------------+--------------------+------------+-------------------+-------+----------------+---------------------------+
| id                                   | agent_type         | host       | availability_zone | alive | admin_state_up | binary                    |
+--------------------------------------+--------------------+------------+-------------------+-------+----------------+---------------------------+
| 61e342d2-91c6-434c-976a-3fb2c7cd5e7a | Metering agent     | controller |                   | :-)   | True           | neutron-metering-agent    |
| 6cb93409-5969-4393-bd7a-cb36bcac2124 | Open vSwitch agent | compute1   |                   | :-)   | True           | neutron-openvswitch-agent |
| 9ad40459-1a35-409f-9f84-09ef0a8db76c | DHCP agent         | controller | nova              | :-)   | True           | neutron-dhcp-agent        |
| bb28bd00-9124-4cb4-94a1-209bd429bdf0 | Metadata agent     | controller |                   | :-)   | True           | neutron-metadata-agent    |
| dda53f34-909c-425c-916d-08b75cb76545 | L3 agent           | controller | nova              | :-)   | True           | neutron-l3-agent          |
| e6a3cfb2-8f3a-425d-8172-62cdf457b4eb | Open vSwitch agent | controller |                   | :-)   | True           | neutron-openvswitch-agent |
+--------------------------------------+--------------------+------------+-------------------+-------+----------------+---------------------------+

```

Lỗi không kết nối được tới console, gặp phải khi chạy máy ảo với nhiều node compute

Thay hostname trong dòng dưới ở file /etc/nova/nova.conf bằng IP của chính máy compute đó.

``vncserver_proxyclient_address=192.168.100.100``

Restart lại dịch vụ openstack-nova-compute

## 4. Sử dụng dashboad
### 4.1. Tạo máy ảo

- Đăng nhập vào dashboad và thưc hiện theo bước sau
- Click vào tab `Instances` và chọn `Launch Instance`
- Trong tab `Details`, nhập tên máy ảo

<img src="http://i.imgur.com/qOEHOXB.png">

- Trong tab `Source` chọn images cho máy ảo

<img src="http://i.imgur.com/Uu6gjcn.png">

- Trong tab `Flavor` chọn kích thước của máy ảo

<img src="http://i.imgur.com/wagYkPg.png">

- Trong tab `Network` chọn dải mạng mà máy ảo sẽ gắn vào. Trong ví dụ này chọn dải external, nếu chọn dải private thì cần thực hiện bước floating IP.

<img src="http://i.imgur.com/3OioSyZ.png">

 Chờ máy máy khởi tạo và thưc hiện ping, ssh để kiểm tra với IP được cấp trên dashboad
