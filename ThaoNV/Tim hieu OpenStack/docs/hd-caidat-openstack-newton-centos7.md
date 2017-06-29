# Hướng dẫn cài đặt OpenStack Newton trên CentOS 7.3

## Mục lục

[1. Chuẩn bị](#prepare)

[2. Setup môi trường cài đặt](#set-up)

- [2.1. Cài đặt trên controller](#controller)
- [2.2. Cài đặt trên 2 compute node](#compute)
- [2.3. Cài đặt trên node block storage](#storage)

[3. Cài đặt identity service - keystone](#keystone)

[4. Cài đặt image service - glance](#glance)

[5. Cài đặt compute service - nova](#nova)

  - [5.1 Cài đặt trên node controller](#5.1)
  - [5.2 Cài đặt trên node compute](#5.2)

[6. Cài đặt networking service - neutron](#neutron)

  - [6.1 Cài đặt trên node controller](#6.1)
  - [6.2 Cài đặt trên node compute](#6.2)

[7. Cài đặt dashboard - horizon](#horizon)

[8. Cài đặt block storage service - cinder](#cinder)

  - [8.1 Cài đặt trên node controller](#8.1)
  - [8.2 Cài đặt trên node storage](#8.2)

[9. Tạo máy ảo theo provider network](#launch)


--------

## <a name="prepare">1. Chuẩn bị </a>

**Distro:** CentOS 7.3, 2 NIC (1 Public Bridge, 1 Private Bridge)

**Môi trường lab:** KVM

**Mô hình**

<img src="http://i.imgur.com/RNQ3tW9.png">

**IP Planning**

<img src="http://i.imgur.com/izdpCT2.png">

## <a name="setup">2. Setup môi trường cài đặt </a>

### <a name="controller">2.1 Cài đặt trên controller </a>

Cấu hình file `/etc/hosts` và `/etc/resolv.conf`

``` sh

vi /etc/hosts

127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.100.197    controller
192.168.100.198    compute
192.168.100.199    compute2
192.168.100.200    block
```

``` sh
vi /etc/resolv.conf

nameserver 8.8.8.8
```

Kiểm tra ping ra internet và ra compute

```sh
ping -c 4 openstack.org
ping -c 4 compute
```

Tắt firewall và selinux

``` sh
systemctl disable firewalld
systemctl stop firewalld
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```

Khởi động lại máy

`init 6`

**Cài đặt Network Time Protocol (NTP)**

Cài đặt package

`yum install chrony -y`

Chỉnh sửa cấu hình file `/etc/chrony.conf`

``` sh
sed -i "s/server 0.centos.pool.ntp.org iburst/server vn.pool.ntp.org iburst/g" /etc/chrony.conf

sed -i 's/server 1.centos.pool.ntp.org iburst/#server 1.centos.pool.ntp.org iburst/g' /etc/chrony.conf

sed -i 's/server 2.centos.pool.ntp.org iburst/#server 2.centos.pool.ntp.org iburst/g' /etc/chrony.conf

sed -i 's/server 3.centos.pool.ntp.org iburst/#server 3.centos.pool.ntp.org iburst/g' /etc/chrony.conf

sed -i 's/#allow 192.168\/16/allow 192.168.100.0\/24/g' /etc/chrony.conf
```

Start dịch vụ và cho khởi động cùng hệ thống

``` sh
systemctl enable chronyd.service
systemctl start chronyd.service
```

Kiểm tra lại

``` sh
[root@controller ~]# chronyc sources
210 Number of sources = 1
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^* time.vng.vn                   3   6   377    37   -647us[ -871us] +/-  254ms
```

**Kích hoạt OpenStack repository**

`yum install centos-release-openstack-newton`

**Update packages**

`yum upgrade -y`

**Cài đặt OpenStack client**

`yum install python-openstackclient`

**Cài đặt openstack-selinux**

`yum install openstack-selinux`

**Cài đặt và cấu hình SQL database**

Cài đặt package

`yum install mariadb mariadb-server python2-PyMySQL -y`

Tạo file `/etc/my.cnf.d/openstack.cnf`

``` sh
vi /etc/my.cnf.d/openstack.cnf

[mysqld]

bind-address = 192.168.100.197
default-storage-engine = innodb
innodb_file_per_table
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
```

Start dịch vụ và cấu hình khởi động cùng hệ thống

``` sh
systemctl enable mariadb.service
systemctl start mariadb.service
```

Thực hiện security cho mysql, thực hiện theo các bước sau :

```sh
mysql_secure_installation

Enter current password for root (enter for none): [enter]
Change the root password? [Y/n]: y
Set root password? [Y/n] y
New password:Welcome123
Re-enter new password:Welcome123
Remove anonymous users? [Y/n]: y
Disallow root login remotely? [Y/n]: y
Remove test database and access to it? [Y/n]: y
Reload privilege tables now? [Y/n]: y
```

**Cài đặt và cấu hình RabbitMQ**

Cài đặt package

`yum install rabbitmq-server`

Start dịch vụ và cấu hình khởi động cùng hệ thống

``` sh
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
```

Thêm user `openstack`

``` sh
rabbitmqctl add_user openstack Welcome123

Creating user "openstack" ...
```

Phân quyền cho user openstack được phép config, write, read trên rabbitmq

`rabbitmqctl set_permissions openstack ".*" ".*" ".*"`

**Cài đặt và cấu hình Memcached**

Cài đặt packages

`yum install memcached python-memcached`

Sao lưu cấu hình memcache

`cp /etc/sysconfig/memcached /etc/sysconfig/memcached.origin`

Chính sửa cấu hình memcache

`sed -i 's/OPTIONS=\"-l 127.0.0.1,::1\"/OPTIONS=\"-l 192.168.100.197,::1\"/g' /etc/sysconfig/memcached`

Start dịch vụ và cấu hình khởi động cùng hệ thống

``` sh
systemctl enable memcached.service
systemctl start memcached.service
```

### <a name ="compute">2.2 Cài đặt trên compute node </a>

Cấu hình file `/etc/hosts` và `/etc/resolv.conf`

``` sh

vi /etc/hosts

127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.100.197    controller
192.168.100.198    compute
192.168.100.199    compute2
192.168.100.200    block
```

``` sh
vi /etc/resolv.conf

nameserver 8.8.8.8
```

Kiểm tra ping ra internet và ra controller

```sh
ping -c 4 openstack.org
ping -c 4 controller
```

Tắt firewall và selinux

``` sh
systemctl disable firewalld
systemctl stop firewalld
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```

Khởi động lại máy

`init 6`

**Cài đặt Network Time Protocol (NTP)**

Cài đặt package

`yum install chrony -y`

Chỉnh sửa cấu hình file `/etc/chrony.conf`

``` sh
sed -i "s/server 0.centos.pool.ntp.org iburst/server controller iburst/g" /etc/chrony.conf

sed -i 's/server 1.centos.pool.ntp.org iburst/#server 1.centos.pool.ntp.org iburst/g' /etc/chrony.conf

sed -i 's/server 2.centos.pool.ntp.org iburst/#server 2.centos.pool.ntp.org iburst/g' /etc/chrony.conf

sed -i 's/server 3.centos.pool.ntp.org iburst/#server 3.centos.pool.ntp.org iburst/g' /etc/chrony.conf
```

Start dịch vụ và cho khởi động cùng hệ thống

``` sh
systemctl enable chronyd.service
systemctl start chronyd.service
```

Kiểm tra lại

``` sh
[root@compute ~]# chronyc sources
210 Number of sources = 1
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^? controller                    0  10     0   10y     +0ns[   +0ns] +/-    0ns
```

**Kích hoạt OpenStack repository**

`yum install centos-release-openstack-newton`

**Update packages**

`yum upgrade -y`

**Cài đặt OpenStack client**

`yum install python-openstackclient`

**Cài đặt openstack-selinux**

`yum install openstack-selinux`

**Lưu ý**

Thực hiện các bước cài đặt tương tự với node compute2 và block.

## <a name="keystone">3. Cài đặt và cấu hình Keystone </a>

**Lưu ý:** Dịch vụ này chạy trên controller mode

Tạo database cho keystone

``` sh
mysql -u root -pWelcome123
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'Welcome123';
exit
```

Cài đặt keystone

`yum install -y openstack-keystone httpd mod_wsgi`

Sao lưu file cấu hình keystone

`cp /etc/keystone/keystone.conf /etc/keystone/keystone.conf.origin`

Chỉnh sửa file cấu hình keystone

``` sh
[database]
...
connection = mysql+pymysql://keystone:KEYSTONE_DBPASS@controller/keystone

[token]
...
provider = fernet
```

Đồng bộ database keystone

`su -s /bin/sh -c "keystone-manage db_sync" keystone`

Tạo Fernet key repositories

``` sh
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
```

Bootstrap dịch vụ identity

```sh
keystone-manage bootstrap --bootstrap-password Welcome123 \
  --bootstrap-admin-url http://controller:35357/v3/ \
  --bootstrap-internal-url http://controller:35357/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne
```

**Cấu hình Apache HTTP server**

Sao lưu file `/etc/httpd/conf/httpd.conf`

`cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.origin`

Chỉnh sửa file `/etc/httpd/conf/httpd.conf`

``` sh
vi /etc/httpd/conf/httpd.conf

...
ServerName controller
```

Tạo liên kết tới file `/usr/share/keystone/wsgi-keystone.conf`

`ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/`

Start dịch vụ và cho khởi động cùng hệ thống

``` sh
systemctl enable httpd.service
systemctl start httpd.service
```

Cấu hình tài khoản admin

```sh
export OS_USERNAME=admin
export OS_PASSWORD=Welcome123
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3
```

Tạo service project

`openstack project create --domain default --description "Service Project" service`

Tạo demo project

`openstack project create --domain default --description "Demo Project" demo`

Tạo demo user

``` sh
$ openstack user create --domain default --password-prompt demo

User Password:
Repeat User Password:
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | default                          |
| enabled             | True                             |
| id                  | aeda23aa78f44e859900e22c24817832 |
| name                | demo                             |
| password_expires_at | None                             |
+---------------------+----------------------------------+
```

Tạo role demo

``` sh
openstack role create user

+-----------+----------------------------------+
| Field     | Value                            |
+-----------+----------------------------------+
| domain_id | None                             |
| id        | 997ce8d05fc143ac97d83fdfb5998552 |
| name      | user                             |
+-----------+----------------------------------+
```

Gán role demo vào project và user demo

`openstack role add --project demo --user demo user`

Sao lưu file /etc/keystone/keystone-paste.ini

`cp /etc/keystone/keystone-paste.ini /etc/keystone/keystone-paste.ini.origin`

Xóa các `admin_token_auth` khỏi các section sau:

``` sh
[pipeline:public_api]

[pipeline:admin_api]

[pipeline:api_v3]
```

Unset biến

`unset OS_AUTH_URL OS_PASSWORD`

Request authentication token cho admin user

``` sh
$ openstack --os-auth-url http://controller:35357/v3 \
  --os-project-domain-name Default --os-user-domain-name Default \
  --os-project-name admin --os-username admin token issue

Password:
+------------+-----------------------------------------------------------------+
| Field      | Value                                                           |
+------------+-----------------------------------------------------------------+
| expires    | 2016-02-12T20:14:07.056119Z                                     |
| id         | gAAAAABWvi7_B8kKQD9wdXac8MoZiQldmjEO643d-e_j-XXq9AmIegIbA7UHGPv |
|            | atnN21qtOMjCFWX7BReJEQnVOAj3nclRQgAYRsfSU_MrsuWb4EDtnjU7HEpoBb4 |
|            | o6ozsA_NmFWEpLeKy0uNn_WeKbAhYygrsmQGA49dclHVnz-OMVLiyM9ws       |
| project_id | 343d245e850143a096806dfaefa9afdc                                |
| user_id    | ac3377633149401296f6c0d92d79dc16                                |
+------------+-----------------------------------------------------------------+
```

Request authentication token cho demo user

``` sh
$ openstack --os-auth-url http://controller:5000/v3 \
  --os-project-domain-name Default --os-user-domain-name Default \
  --os-project-name demo --os-username demo token issue

Password:
+------------+-----------------------------------------------------------------+
| Field      | Value                                                           |
+------------+-----------------------------------------------------------------+
| expires    | 2016-02-12T20:15:39.014479Z                                     |
| id         | gAAAAABWvi9bsh7vkiby5BpCCnc-JkbGhm9wH3fabS_cY7uabOubesi-Me6IGWW |
|            | yQqNegDDZ5jw7grI26vvgy1J5nCVwZ_zFRqPiz_qhbq29mgbQLglbkq6FQvzBRQ |
|            | JcOzq3uwhzNxszJWmzGC7rJE_H0A_a3UFhqv8M4zMRYSbS2YF0MyFmp_U       |
| project_id | ed0b60bf607743088218b0a533d5943f                                |
| user_id    | 58126687cbcc4888bfa9ab73a2256f27                                |
+------------+-----------------------------------------------------------------+
```

Tạo các file source script `admin-rc` và `demo-rc`

``` sh
vi admin-openrc

export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=Welcome123
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
```

```sh
vi demo-rc

export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=Welcome123
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
```

Kiểm tra script

``` sh
. admin-rc

openstack token issue
```

<a name="glance"></a>
## 4. Cài đặt image service - glance

**Lưu ý:** Dịch vụ này thường chạy trên controller node và sử dụng file system làm backend lưu images.

Tạo database

``` sh
mysql -u root -pWelcome123
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'Welcome123';
exit
```

Tạo glance user

``` sh
. admin-rc
openstack user create glance --domain default --password Welcome123
```

Gán role admin cho user và service glance

`openstack role add --project service --user glance admin`

Tạo glance service entity

`openstack service create --name glance --description "OpenStack Image" image`

Tạo API endpoints cho Image service

``` sh
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292
```

Cài đặt package

`yum install openstack-glance -y`

Sao lưu cấu hình file config glance-api

`cp /etc/glance/glance-api.conf /etc/glance/glance-api.conf.origin`

Chỉnh sửa file config glance-api

``` sh
[database]
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = Welcome123

[paste_deploy]
flavor = keystone

[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/
```

Sao lưu file config glance-registry

`cp /etc/glance/glance-registry.conf /etc/glance/glance-registry.conf.origin`

Chỉnh sửa file config glance-registry

``` sh
[database]
connection = mysql+pymysql://glance:Welcome123@controller/glance

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = GLANCE_PASS

[paste_deploy]
flavor = keystone
```

Đồng bộ glance database

`su -s /bin/sh -c "glance-manage db_sync" glance`

Start dịch vụ glance-api và glance-registry, cho phép khởi động dịch vụ cùng hệ thống

``` sh
systemctl enable openstack-glance-api.service openstack-glance-registry.service
systemctl start openstack-glance-api.service openstack-glance-registry.service
```

Kiểm tra lại cài đặt. Tải image

``` sh
. admin-openrc
wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
```

Upload image

``` sh
openstack image create "cirros" \
  --file cirros-0.3.4-x86_64-disk.img \
  --disk-format qcow2 --container-format bare \
  --public
```

Kiểm tra lại image vừa upload

`openstack image list`

<a name="nova"></a>
## 5. Cài đặt compute service - nova

<a name="5.1"></a>
### 5.1 Cài đặt trên node controller

Tạo database cho nova

``` sh
mysql -u root -pWelcome123
CREATE DATABASE nova_api;
CREATE DATABASE nova;
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'Welcome123';
exit
```

Tạo user nova

``` sh
. admin-openrc
openstack user create --domain default --password-prompt nova
```

Gán role admin cho user nova

`openstack role add --project service --user nova admin`

Tạo nova service

` openstack service create --name nova --description "OpenStack Compute" compute`

Tạo API endpoint cho Compute service

``` sh
openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1/%\(tenant_id\)s
```

Cài đặt các packages

``` sh
yum install openstack-nova-api openstack-nova-conductor openstack-nova-console openstack-nova-novncproxy openstack-nova-scheduler -y
```

Sao lưu file cấu hình

`cp /etc/nova/nova.conf /etc/nova/nova.conf.origin`

Chỉnh sửa file cấu hình `/etc/nova/nova.conf`

``` sh
[DEFAULT]
auth_strategy = keystone
enabled_apis = osapi_compute,metadata
transport_url = rabbit://openstack:RABBIT_PASS@controller
my_ip = 192.168.100.197
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver

[api_database]
connection = mysql+pymysql://nova:Welcome123@controller/nova_api

[database]
connection = mysql+pymysql://nova:Welcome123@controller/nova

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = nova
password = Welcome123

[vnc]
vncserver_listen = $my_ip
vncserver_proxyclient_address = $my_ip

[glance]
api_servers = http://controller:9292

[oslo_concurrency]
lock_path = /var/lib/nova/tmp
```

Đồng bộ database

``` sh
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage db sync" nova
```

Start các service nova và cho phép khởi động dịch vụ cùng hệ thống

``` sh
systemctl enable openstack-nova-api.service openstack-nova-consoleauth.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service

systemctl start openstack-nova-api.service openstack-nova-consoleauth.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service
```

<a name="5.2"></a>
### 5.2 Cấu hình trên node Compute

Cài đặt packages

`yum install openstack-nova-compute -y`

Sao lưu file cấu hình

`cp /etc/nova/nova.conf /etc/nova/nova.conf.origin`

Chỉnh sửa file cấu hình

``` sh
[DEFAULT]
auth_strategy = keystone
enabled_apis = osapi_compute,metadata
my_ip = 192.168.100.198
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver

[keystone_authtoken]
...
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = nova
password = Welcome123

[vnc]
enabled = True
vncserver_listen = 0.0.0.0
vncserver_proxyclient_address = $my_ip
novncproxy_base_url = http://192.168.100.197:6080/vnc_auto.html

[glance]
api_servers = http://controller:9292

[oslo_concurrency]
lock_path = /var/lib/nova/tmp
```

Chạy câu lệnh sau để xem phần cứng của bạn có hỗ trợ ảo hóa hay không:

`egrep -c '(vmx|svm)' /proc/cpuinfo`

Nếu giá trị là 1 hoặc lớn hơn thì phần cứng của bạn đã hỗ trợ ảo hóa.
Nếu giá trị là 0 thì bạn buộc phải cấu hình libvirt sửa dụng QEMU thay vì KVM.

Chỉnh sửa lại section `[libvirt]` trong file `/etc/nova/nova.conf`

``` sh
[libvirt]
virt_type = qemu
```

**Lưu ý:**

- Nếu bạn dựng máy ảo trên KVM hoặc VMWare, bạn **buộc** phải thay cấu hình cho libvirt sử dụng QEMU.

Sau đó tiếp tục tiến hành start các service nova và cho phép khởi động dịch vụ cùng hệ thống.

``` sh
systemctl enable libvirtd.service openstack-nova-compute.service
systemctl start libvirtd.service openstack-nova-compute.service
```

**Lưu ý:**

- Nếu nova-compute không thể khởi động, check `/var/log/nova/nova-compute.log` và thấy `AMQP server on controller:5672 is unreachable` thì firewall trên controller đang ngăn cản truy cập tới port 5672. Tiến hành mở port và khởi động lại dịch vụ.

- Node compute còn lại tiến hành cấu hình tương tự.

- Sau khi cấu hình xong quay trở lại node controller và kiểm tra các service đã lên hay chưa.

``` sh
. admin-openrc
openstack compute service list
```

<a name="neutron"></a>
## 6. Cấu hình networking service - neutron

Ở đây sử dụng linux bridge và mix provider network + self-service network

<a name="6.1"></a>
### 6.1 Cấu hình trên node controller

Tạo database

``` sh
mysql -u root -pWelcome123
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'Welcome123';
```

Tạo user neutron và gán role admin cho user neutron

``` sh
. admin-openrc
openstack user create --domain default --password-prompt neutron
openstack role add --project service --user neutron admin
```

Tạo service neutron

`openstack service create --name neutron --description "OpenStack Networking" network`

Tạo Networking service API endpoints

``` sh
openstack endpoint create --region RegionOne network public http://controller:9696

openstack endpoint create --region RegionOne network internal http://controller:9696

openstack endpoint create --region RegionOne network admin http://controller:9696
```

**Cấu hình provider network**

- **Lưu ý:** Để có thể cài được self-service network, trước tiên bạn phải cài provider network

Cài đặt các packages

`yum install openstack-neutron openstack-neutron-ml2 openstack-neutron-linuxbridge ebtables`

Sao lưu file cấu hình

`cp /etc/neutron/neutron.conf /etc/neutron/neutron.conf.origin`

Chỉnh sửa file cấu hình `/etc/neutron/neutron.conf`

``` sh
[database]
auth_strategy = keystone
connection = mysql+pymysql://neutron:Welcome123@controller/neutron
core_plugin = ml2
service_plugins =
transport_url = rabbit://openstack:Welcome123@controller
notify_nova_on_port_status_changes = True
notify_nova_on_port_data_changes = True

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = neutron
password = Welcome123


[nova]
auth_url = http://controller:35357
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = nova
password = Welcome123

[oslo_concurrency]
lock_path = /var/lib/neutron/tmp
```

Sao lưu file cấu hình Modular Layer 2

`cp /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini.origin`

Chỉnh sửa file cấu hình Modular Layer 2

``` sh
[ml2]
type_drivers = flat,vlan
tenant_network_types =
mechanism_drivers = linuxbridge
extension_drivers = port_security

[ml2_type_flat]
flat_networks = provider

[securitygroup]
enable_ipset = True
```

Sao lưu file cấu hình Linux bridge agent

`cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini.origin`

Chỉnh sửa file cấu hình Linux bridge agent

``` sh
[linux_bridge]
physical_interface_mappings = provider:ens3

[vxlan]
enable_vxlan = False

[securitygroup]
enable_security_group = True
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
```

**Lưu ý:** Thay `ens3` bằng tên card mạng kết nối tới dải external của bạn.

Sao lưu file cấu hình DHCP agent

`cp /etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini.origin`

Chỉnh sửa file cấu hình DHCP agent

``` sh
[DEFAULT]
interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = True
```

**Cấu hình self-service network**

Chỉnh sửa file `/etc/neutron/neutron.conf`

``` sh
[DEFAULT]
service_plugins = router
allow_overlapping_ips = True
```

Chỉnh sửa file `/etc/neutron/plugins/ml2/ml2_conf.ini`

``` sh
[ml2]
type_drivers = flat,vlan,vxlan
tenant_network_types = vxlan
mechanism_drivers = linuxbridge,l2population

[ml2_type_vxlan]
vni_ranges = 1:1000
```

Chỉnh sửa file `/etc/neutron/plugins/ml2/linuxbridge_agent.ini`

``` sh
[vxlan]
enable_vxlan = True
local_ip = 10.10.10.10
l2_population = True
```

- Cấu hình layer-3 agent

Sao lưu file cấu hình

`cp /etc/neutron/l3_agent.ini /etc/neutron/l3_agent.ini.origin`

Chỉnh sửa file cấu hình

``` sh
[DEFAULT]
interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver
```

**Cấu hình metadata agent**

Sao lưu file cấu hình metadata agent

`cp /etc/neutron/metadata_agent.ini /etc/neutron/metadata_agent.ini.origin`

Chỉnh sửa file cấu hình metadata agent

``` sh
[DEFAULT]
nova_metadata_ip = 192.168.100.197
metadata_proxy_shared_secret = Welcome123
```

**Cấu hình Compute service sửa dụng Networking service**

Chỉnh sửa file cấu hình `/etc/nova/nova.conf`

``` sh
[neutron]
url = http://controller:9696
auth_url = http://controller:35357
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = neutron
password = Welcome123
service_metadata_proxy = True
metadata_proxy_shared_secret = Welcome123
```

Tạo symbolic link giữa `/etc/neutron/plugin.ini` và `/etc/neutron/plugins/ml2/ml2_conf.ini`

`ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini`

Đồng bộ database

`su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron`

Restart Compute API service

`systemctl restart openstack-nova-api.service`

Start các service neutron và cho phép khởi động dịch vụ cùng hệ thống

``` sh
systemctl enable neutron-server.service neutron-linuxbridge-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service

systemctl start neutron-server.service neutron-linuxbridge-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service

systemctl enable neutron-l3-agent.service
systemctl start neutron-l3-agent.service
```

<a name="6.2"></a>
### 6.2 Cấu hình trên node Compute

Cài đặt packages

`yum install openstack-neutron-linuxbridge ebtables ipset`

Sao lưu file cấu hình

`cp /etc/neutron/neutron.conf /etc/neutron/neutron.conf.origin`

Chỉnh sửa file cấu hình

``` sh
[DEFAULT]
auth_strategy = keystone
transport_url = rabbit://openstack:Welcome123@controller

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = neutron
password = Welcome123

[oslo_concurrency]
lock_path = /var/lib/neutron/tmp
```

**Cấu hình provider network**

Sao lưu file cấu hình Linux bridge agent

`cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini.origin`

Chỉnh sửa file cấu hình

``` sh
[linux_bridge]
physical_interface_mappings = provider:ens3

[vxlan]
enable_vxlan = False

[securitygroup]
enable_security_group = True
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
```

- Lưu ý: Thay ens3 bằng card mạng kết nối tới external network của bạn

**Cấu hình self-service network**

Chỉnh sửa file `/etc/neutron/plugins/ml2/linuxbridge_agent.ini`

``` sh
[vxlan]
enable_vxlan = True
local_ip = 10.10.10.11
l2_population = True
```

**Cấu hình Compute service sử dụng network service**

Chỉnh sửa file cấu hình `/etc/nova/nova.conf`

``` sh
[neutron]
...
url = http://controller:9696
auth_url = http://controller:35357
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = neutron
password = Welcome123
```

Restart compute service

`systemctl restart openstack-nova-compute.service`

Start Linux bridge agent và cho phép khởi động cùng hệ thống

``` sh
systemctl enable neutron-linuxbridge-agent.service
systemctl start neutron-linuxbridge-agent.service
```

Kiểm tra lại các cấu hình

``` sh
. admin-openrc
neutron ext-list
openstack network agent list
```

<a name="horizon"></a>
## 7. Cấu hình dashboard - horizon

**Lưu ý:** Dịch vụ này chạy trên node controller

Cài đặt packages

`yum install openstack-dashboard -y`

Sao lưu file cấu hình

`cp /etc/openstack-dashboard/local_settings /etc/openstack-dashboard/local_settings.origin`

Chỉnh sửa file cấu hình

``` sh
OPENSTACK_HOST = "controller"

ALLOWED_HOSTS = ['*', ]

SESSION_ENGINE = 'django.contrib.sessions.backends.cache'

CACHES = {
    'default': {
         'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
         'LOCATION': 'controller:11211',
    }
}

OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST
OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True

OPENSTACK_API_VERSIONS = {
    "identity": 3,
    "image": 2,
    "volume": 2,
}

OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "default"

OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"

OPENSTACK_NEUTRON_NETWORK = {
    ...
    'enable_router': False,
    'enable_quotas': False,
    'enable_distributed_router': False,
    'enable_ha_router': False,
    'enable_lb': False,
    'enable_firewall': False,
    'enable_vpn': False,
    'enable_fip_topology_check': False,
}
```

Restart lại dịch vụ

`systemctl restart httpd.service memcached.service`

Để kiểm tra, dùng trình duyệt kết nối tới địa chỉ `http://controller_ip/dashboard`. Dùng tài khoản admin hoặc demo trên domain default.

<a name="cinder"></a>
## 8. Cấu hình Block storage service - Cinder

<a name="8.1"></a>
### 8.1 Cấu hình trên node controller

Tạo database

``` sh
mysql -u root -pWelcome123
CREATE DATABASE cinder;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'Welcome123';
```

Tạo user cinder và gán role admin cho nó

``` sh
. admin-openrc
openstack user create --domain default --password-prompt cinder
openstack role add --project service --user cinder admin
```

Tạo cinder và cinderv2 service entities

``` sh
openstack service create --name cinder --description "OpenStack Block Storage" volume

openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2

openstack endpoint create --region RegionOne volume public http://controller:8776/v1/%\(tenant_id\)s

openstack endpoint create --region RegionOne volume internal http://controller:8776/v1/%\(tenant_id\)s

openstack endpoint create --region RegionOne volume admin http://controller:8776/v1/%\(tenant_id\)s

openstack endpoint create --region RegionOne volumev2 public http://controller:8776/v2/%\(tenant_id\)s

openstack endpoint create --region RegionOne volumev2 internal http://controller:8776/v2/%\(tenant_id\)s

openstack endpoint create --region RegionOne volumev2 admin http://controller:8776/v2/%\(tenant_id\)s
```

Cài đặt package

`yum install openstack-cinder -y`

Sao lưu file cấu hình

`cp /etc/cinder/cinder.conf /etc/cinder/cinder.conf.origin`

Chỉnh sửa file cấu hình

``` sh
[DEFAULT]
auth_strategy = keystone
transport_url = rabbit://openstack:RABBIT_PASS@controller
my_ip = 192.168.100.197

[database]
connection = mysql+pymysql://cinder:Welcome123@controller/cinder

[keystone_authtoken]
...
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = cinder
password = Welcome123

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
```

Đồng bộ database

`su -s /bin/sh -c "cinder-manage db sync" cinder`

Cấu hình cho Compute sử dụng cinder, chỉnh sửa trong file `/etc/nova/nova.conf`

```sh
[cinder]
os_region_name = RegionOne
```

Khởi động lại Compute API service

`systemctl restart openstack-nova-api.service`

Start các service cinder và cho phép khởi động dịch vụ cùng hệ thống

``` sh
systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service
systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service
```

<a name="8.2"></a>
### 8.2 Cài đặt trên node storage

Cài đặt LVM package

`yum install lvm2 -y`

Start LVM metadata service và cho phép khởi động cùng hệ thống

``` sh
systemctl enable lvm2-lvmetad.service
systemctl start lvm2-lvmetad.service
```

Tạo physical volume `dev/sdb`

`pvcreate /dev/sdb`

Tạo LVM volume group `cinder-volumes`

`vgcreate cinder-volumes /dev/sdb`

Cấu hình cho phép LVM scan các thiết bị chứa `cinder-volumes`. Sửa file `/etc/lvm/lvm.conf`

``` sh
devices {
filter = [ "a/sdb/", "r/.*/"]
}
```

- Lưu ý: Nếu storage node của bạn dùng LVM cho các disk khác ví dụ như disk chứa OS thì bạn phải add thêm vào filter để nó tìm thấy. ví dụ `filter = [ "a/sda/", "a/sdb/", "r/.*/"]`

Cài đặt các packages

`yum install openstack-cinder targetcli python-keystone`

Sao lưu file cấu hình

`cp /etc/cinder/cinder.conf /etc/cinder/cinder.conf.origin`

Chỉnh sửa file cấu hình

``` sh
[DEFAULT]
auth_strategy = keystone
transport_url = rabbit://openstack:RABBIT_PASS@controller
my_ip = 192.168.100.200
enabled_backends = lvm
glance_api_servers = http://controller:9292

[database]
connection = mysql+pymysql://cinder:Welcome123@controller/cinder

[keystone_authtoken]
...
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = cinder
password = Welcome123

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp

[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
iscsi_protocol = iscsi
iscsi_helper = lioadm
```

Start dịch vụ và cho phép khởi động cùng hệ thống

``` sh
systemctl enable openstack-cinder-volume.service target.service
systemctl start openstack-cinder-volume.service target.service
```

Kiểm tra lại xem các service đã lên chưa

``` sh
. admin-openrc
openstack volume service list
```

<a name="launch"></a>
## 9. Tạo máy ảo theo provider network

- Tạo provider network

``` sh
. admin-openrc
openstack network create  --share --external --provider-physical-network provider --provider-network-type flat provider
```

- Tạo subnet

``` sh
openstack subnet create --network provider \
  --allocation-pool start=192.168.100.201,end=192.168.100.250 \
  --dns-nameserver 8.8.8.8 --gateway 192.168.100.1 \
  --subnet-range 192.168.100.0/24 provider
```

- Tạo m1.nano flavor

Flavor này chỉ dùng để test với CirrOS image

`openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano`

- Thêm security group rules cho phép ping và ssh

``` sh
openstack security group rule create --proto icmp default
openstack security group rule create --proto tcp --dst-port 22 default
```

- Tạo máy ảo bằng provider network, bạn có thể truy cập vào dashboard hoặc dùng câu lệnh.

``` sh
openstack server create --flavor m1.nano --image cirros \
  --nic net-id=PROVIDER_NET_ID --security-group default \
   provider-instance
```

`PROVIDER_NET_ID` là id của provider network.
