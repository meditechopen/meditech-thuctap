# Cài đặt và cấu hình dịch vụ Cinder

# I. Cài đặt và cấu hình Cinder sử dụng backend là LVM.

## 1. Setup mô hình

 - Mô hình :

 ![cinder1](/images/cinder-multi-lvm01.png)

 - IP Planning :

  ![cinder1](/images/cinder-multi-lvm02.png)

  **Chú ý** : Hệ thống OpenStack đã được cài đặt hoàn chỉnh trước đó. Tham khảo link [sau](https://github.com/meditechopen/mdt-technical/blob/master/ManhDV/OpenStack/docs/caidat-openstack/OPS-Mitaka-bonding.md) để cài đặt OpenStack Mitaka với network bonding.

## 2. Cài đặt và cấu hình Cinder trên node Controller

 - Tạo database cho Cinder

```sh
 mysql -u root -pWelcome123
CREATE DATABASE cinder;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' \
  IDENTIFIED BY 'Welcome123';
exit
```

 - Tạo và phân quyền cho user cinder

`source admin-rc`

`openstack user create cinder --domain default --password Welcome123`

`openstack role add --project service --user cinder admin`

 - Tạo service entity

```sh
openstack service create --name cinder --description "OpenStack Block Storage" volume

openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2
```

 - Tạo service API endpoint

```sh
openstack endpoint create --region RegionOne volume public http://172.16.69.10:8776/v1/%\(tenant_id\)s

openstack endpoint create --region RegionOne volume internal http://172.16.69.10:8776/v1/%\(tenant_id\)s

openstack endpoint create --region RegionOne volume admin http://172.16.69.10:8776/v1/%\(tenant_id\)s

openstack endpoint create --region RegionOne volumev2 public http://172.16.69.10:8776/v2/%\(tenant_id\)s

openstack endpoint create --region RegionOne volumev2 internal http://172.16.69.10:8776/v2/%\(tenant_id\)s

openstack endpoint create --region RegionOne volumev2 admin http://172.16.69.10:8776/v2/%\(tenant_id\)s
```

 - Cài đặt Cinder

`yum install -y openstack-cinder`

 - Sao lưu file cấu hình

`cp /etc/cinder/cinder.conf /etc/cinder/cinder.conf.orig`

 - Sửa file cấu hình /etc/cinder/cinder.conf

```sh
[DEFAULT]
rpc_backend = rabbit
auth_strategy = keystone
my_ip = 172.16.69.10

[database]
connection = mysql+pymysql://cinder:Welcome123@172.16.69.10/cinder

[oslo_messaging_rabbit]
rabbit_host = 172.16.69.10
rabbit_userid = openstack
rabbit_password = Welcome123

[keystone_authtoken]
auth_uri = http://172.16.69.10:5000
auth_url = http://172.16.69.10:35357
memcached_servers = 172.16.69.10:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = cinder
password = Welcome123

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
```


 - Đồng bọ database Cinder

`su -s /bin/sh -c "cinder-manage db sync" cinder`

 - Sửa file /etc/nova/nova.conf

```sh
[cinder]
os_region_name = RegionOne
```

 - Restart dịch vụ nova

```sh
systemctl restart openstack-nova-api.service
```

 - Restart dịch vụ cinder và cho phép khởi động cùng hệ thống :

```sh
systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service
systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service
```

## 3. Cài đặt và cấu hình cinder trên Cinder node

 - Cài đặt LVM

`yum install -y lvm2`

 - Khởi động dịch vụ LVM và cho phép khởi động cùng hệ thống.

```sh
systemctl enable lvm2-lvmetad.service
systemctl start lvm2-lvmetad.service
```

 - Tạo LVM physical volume /dev/sdb

`pvcreate /dev/sdb`

 - Tạo LVM volume group `cinder-volumes`

`vgcreate cinder-volumes /dev/sdb`

 - Sửa file /etc/lvm/lvm.conf, để LVM chỉ scan ổ sdb cho block storage

```sh
devices {
...
filter = [ "a/sdb/", "r/.*/"]
```

 - Cài đặt package cho cinder

`yum install openstack-cinder targetcli python-keystone`

 - Sao lưu file cấu hình cinder /etc/cinder/cinder.conf

`cp /etc/cinder/cinder.conf /etc/cinder/cinder.conf.orig`

 - Sửa file cấu hình /etc/cinder/cinder.conf

```sh
[DEFAULT]
rpc_backend = rabbit
auth_strategy = keystone
my_ip = 192.168.11.12
enabled_backends = lvm
glance_api_servers = http://172.16.69.10:9292

[oslo_messaging_rabbit]
rabbit_host = 172.16.69.10
rabbit_userid = openstack
rabbit_password = Welcome123

[database]
connection = mysql+pymysql://cinder:Welcome123@172.16.69.10/cinder

[keystone_authtoken]
auth_uri = http://172.16.69.10:5000
auth_url = http://172.16.69.10:35357
memcached_servers = 172.16.69.10:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = cinder
password = Welcome123

[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
iscsi_protocol = iscsi
iscsi_helper = lioadm
volume_backend_name = lvm

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
```

 - Start dịch vụ cinder-volume và cho phép khởi động cùng hệ thống

```sh
systemctl enable openstack-cinder-volume.service target.service
systemctl start openstack-cinder-volume.service target.service
```

 - Quay lại node CTL, kiểm tra cinder-list

```sh
source admin-rc
cinder service-list
```

# II. Cấu hình Cinder sử dụng Multi Backend LVM

## 1. Trên node Cinder

 - Tại node Cinder, thêm 1 ổ cứng để tạo thêm LVM trên đó.

  ![cinder1](/images/cinder-multi-lvm03.png)

 - Tạo LVM physical volume /dev/sdb

```sh
pvcreate /dev/sdc
```

 - Tạo LVM volume group cinder-volumes

```sh
vgcreate cinder-volumes02 /dev/sdc
```

 - Sửa file /etc/lvm/lvm.conf, để LVM chỉ scan sdb và sdc cho block storage
devices {
...
filter = [ "a/sdb/", "a/sdc/", "r/.*/"]  

 - Restart dịch vụ LVM

```sh
systemctl restart lvm2-lvmetad.service
```

 - Sửa file cấu hình /etc/cinder/cinder.conf :

 ```sh
 [DEFAULT]
rpc_backend = rabbit
auth_strategy = keystone
my_ip = 192.168.11.12
enabled_backends = lvm01,lvm02
glance_api_servers = http://172.16.69.10:9292

[oslo_messaging_rabbit]
rabbit_host = 172.16.69.10
rabbit_userid = openstack
rabbit_password = Welcome123

[database]
connection = mysql+pymysql://cinder:Welcome123@172.16.69.10/cinder

[keystone_authtoken]
auth_uri = http://172.16.69.10:5000
auth_url = http://172.16.69.10:35357
memcached_servers = 172.16.69.10:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = cinder
password = Welcome123

[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
iscsi_protocol = iscsi
iscsi_helper = lioadm
volume_backend_name = lvm

[lvm02]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes02
iscsi_protocol = iscsi
iscsi_helper = lioadm
volume_backend_name = lvm2

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
```

 - Ta cần thêm section `[lvm02]` và chỉnh sửa dòng cấu hình `enabled_backends`. Trong section [lvm2], cần chú ý thông sô `volume_group` trùng với tên VG đã tạo.

 - Restart dịch vụ cinder

```sh
systemctl restart openstack-cinder-volume.service target.service
```

## 2. Trên node Controller

 - Tạo volume type tương với mỗi LVM được tạo trên node Cinder. Tạo volume_type cho VG1

```sh
source admin-openrc
openstack volume type create lvm
openstack  volume type set lvm --property volume_backend_name=lvm
```

 - Tạo volume_type cho VG2

```sh
openstack volume type create lvm2
openstack  volume type set lvm --property volume_backend_name=lvm2
```
 - List các volume_type đã tạo :

```sh
openstack volume type list --long
```

 - Tạo thử volume với tùy chọn volume_type.
