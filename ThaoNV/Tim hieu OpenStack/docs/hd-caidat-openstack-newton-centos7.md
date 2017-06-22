# Hướng dẫn cài đặt OpenStack Newton trên CentOS 7.3

## Mục lục

[1. Chuẩn bị](#prepare)

[2. Setup môi trường cài đặt](#set-up)

- [2.1. Cài đặt trên controller](#controller)
- [2.2. Cài đặt trên compute node](#compute)

[3. Cài đặt identity service - keystone](#keystone)

--------

### <a name="prepare">1. Chuẩn bị </a>

**Distro:** CentOS 7.3, 2 NIC (1 Public Bridge, 1 Private Bridge)

**Môi trường lab:** KVM

**Mô hình**

<img src="http://i.imgur.com/eCvKl9k.png">

**IP Planning**

<img src="http://i.imgur.com/nJUFfP1.png">

### <a name="setup">2. Setup môi trường cài đặt </a>

#### <a name="controller">2.1 Cài đặt trên controller </a>

Cấu hình file `/etc/hosts` và `/etc/resolv.conf`

``` sh

vi /etc/hosts

127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.100.197    controller
192.168.100.198    compute
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

#### <a name ="compute">2.2 Cài đặt trên compute node </a>

Cấu hình file `/etc/hosts` và `/etc/resolv.conf`

``` sh

vi /etc/hosts

127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.100.197    controller
192.168.100.198    compute
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

### <a name="keystone">3. Cài đặt và cấu hình Keystone </a>

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
