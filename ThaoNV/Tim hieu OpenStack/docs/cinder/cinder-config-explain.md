# Giải thích file cấu hình Cinder

# Mục lục
 Mục lục 

 *	[1 File cấu hình cinder.conf](#1)
	*	[1.1 Khai báo về database](#1.1)
	*	[1.2 Khai báo về Message Queue](#1.2)
	*	[1.3 Khai báo về xác thực Keystone](#1.3)
	*	[1.4 IP management](#1.4)
	*	[1.5 Cấu hình Storage backend](#1.5)
		*	[1.5.1 LVM Backend](#1.5.1)
		*	[1.5.2 GlusterFS Backend](#1.5.2)
	*	[1.6 Các cấu hình khác](#1.6)
	

## 1. File cấu hình cinder.conf (Multi-Backend GlusterFS và LVM) <a name="1"> </a>
 
```sh
[DEFAULT]
rpc_backend = rabbit
auth_strategy = keystone
my_ip = 192.168.11.12
enabled_backends = lvm,glusterfs
glance_api_servers = http://172.16.69.11:9292
[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
iscsi_protocol = iscsi
iscsi_helper = lioadm
[glusterfs]
volume_driver = cinder.volume.drivers.glusterfs.GlusterfsDriver
glusterfs_shares_config = /etc/cinder/glusterfs_shares
glusterfs_mount_point_base = $state_path/mnt_gluster
[BACKEND]
[BRCD_FABRIC_EXAMPLE]
[CISCO_FABRIC_EXAMPLE]
[COORDINATION]
[FC-ZONE-MANAGER]
[KEYMGR]
[cors]
[cors.subdomain]
[database]
connection = mysql+pymysql://cinder:Welcome123@172.16.69.11/cinder
[keystone_authtoken]
auth_uri = http://172.16.69.11:5000
auth_url = http://172.16.69.11:35357
memcached_servers = 172.16.69.11:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = cinder
password = Welcome123
[matchmaker_redis]
[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
[oslo_messaging_amqp]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
rabbit_host = 172.16.69.11
rabbit_userid = openstack
rabbit_password = Welcome123
[oslo_middleware]
[oslo_policy]
[oslo_reports]
[oslo_versionedobjects]
[ssl]
```

### 1.1 Khai báo về database <a name="1.1"> </a>
 
```sh
[database]
connection = mysql+pymysql://cinder:Welcome123@172.16.69.11/cinder
```

 -	`connection = ...` : chỉ ra địa chỉ mà cần kết nối database. Khai báo password :**Welcome123** cho database Cinder và địa chỉ : **172.416.69.11** (hostname hoặc IP) của node Controller

### 1.2 Khai báo về Message Queue <a name="1.2"> </a>

```sh
[DEFAULT]
rpc_backend = rabbit

[oslo_messaging_rabbit]
rabbit_host = 172.16.69.11
rabbit_userid = openstack
rabbit_password = Welcome123
```

 -	`rpc_backend = rabbit` : Trình điều khiển message được sử dụng mặc định là rabbitMQ.
 -	`rabbit_host = 172.16.69.11` : IP của RabbitMQ server (node Controller)
 -	`rabbit_userid = openstack` : User để kết nối với RabbitMQ server 
 
### 1.3 Khai báo về xác thực Keystone <a name="1.3"> </a>

```sh
[DEFAULT]
auth_strategy = keystone

[keystone_authtoken]
auth_uri = http://172.16.69.11:5000
auth_url = http://172.16.69.11:35357
memcached_servers = 172.16.69.11:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = cinder
password = Welcome123
```

 -	`auth_strategy = keystone` : Cấu hình sử dụng **keystone** để xác thực. Hỗ trợ **noauth** và **deprecated** 
 -	`auth_uri = http://172.16.69.11:5000` : Cấu hình enpoint Identity service
 -	`auth_url = http://172.16.69.11:35357` : URL để xác thực Identity service
 -	`memcached_servers = 172.16.69.11:11211` : Địa chỉ Memcache-server
 -	`auth_type = password` : Hình thức xác thực sử dụng **password**
 -	`project_domain_name = default` : Chỉ định project domain name openstack
 -	`user_domain_name = default` : Chỉ định user domain name openstack
 -	`project_name = service` : Chỉ định project name openstack
 -	`username = cinder` : Chỉ định username của cinder
 -	`password = Welcome123` : CHỉ định password của cinder
 
### 1.4 IP management <a name="1.4"> </a>

```sh
[DEFAULT]
my_ip = 192.168.11.12
```

 -	`my_ip = 192.168.11.12` : Địa chỉ IP management của Storage Node
 
### 1.5 Cấu hình Storage backend <a name="1.5"> </a>

#### 1.5.1 LVM Backend <a name="1.5.1"> </a>
```sh
[DEFAULT]
enabled_backends = lvm

[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
iscsi_protocol = iscsi
iscsi_helper = lioadm
```

 -	`enabled_backends = lvm` : Sử dụng backend là LVM. Đối với multiple backend chỉ cần dấu phẩy giữa các backend (ví dụ : enable_backends = lvm,nfs,glusterfs)
 - `volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver` : Chỉ định driver mà LVM sử dụng
 -	`volume_group = cinder-volumes` : Chỉ định vgroup mà tạo lúc cài đặt. Sử dụng câu lệnh `vgs` hoặc `vgdisplay` để xem thông tin về vgroup đã tạo.
 -	`iscsi_protocol = iscsi`: Xác định giao thức iSCSI cho iSCSI volumes mới, được tạo ra với tgtadm hoặc lioadm. Để kích hoạt RDMA , tham số lên lên được đặt là "iser" . Hỗ trợ cho giao thức iSCSI giá trị là "iscsi" và "iser"
 -	`iscsi_helper = lioadm` : Chỉ ra iSCSI sử dụng. Mặc định là tgtadm. Có các tùy chọn sau :
	-	lioadm hỗ trợ LIO iSCSI
	-	scstadmin cho SCST
	-	iseradm cho ISER
	-	ietadm cho iSCSI
 
#### 1.5.2 GlusterFS Backend <a name="1.5.2"> </a>
```sh
[DEFAULT]
enabled_backends = glusterfs
[glusterfs]
volume_driver = cinder.volume.drivers.glusterfs.GlusterfsDriver
glusterfs_shares_config = /etc/cinder/glusterfs_shares
glusterfs_mount_point_base = $state_path/mnt_gluster
```
 -	`enabled_backends = glusterfs` : Sử dụng backend là Glusterfs
 -	`volume_driver = cinder.volume.drivers.glusterfs.GlusterfsDriver` : Chỉ định driver mà Glusterfs sử dụng
 -	`glusterfs_shares_config = /etc/cinder/glusterfs_shares` : File cấu hình để kết nối tới GlusterFS.
 -	`glusterfs_mount_point_base = $state_path/mnt_gluster` : Mount point tới GlusterFS
 
	-	Nội dung file `glusterfs_shares`
	```sh
	172.16.69.13:/cinder-vol
	```
	
	 -	`172.16.69.13` : IP của GlusterFS Pool. Tham khảo bài [sau](https://github.com/meditechopen/mdt-technical/blob/master/TRIMQ/GlusterFS/glusterfs.md#33) về GlusterFS
	 -	`cinder-vol` : Tên volume đã tạo ở GlusterFS

### 1.6 Các cấu hình khác <a name="1.6"> </a>
```sh
[DEFAULT]
my_ip = 192.168.11.12
glance_api_servers = http://172.16.69.11:9292

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
```

 -	`my_ip = 192.168.11.12` : IP Management của Storage node
 -	`glance_api_servers = http://172.16.69.11:9292` : URL kết nối tới Glance
 -	`lock_path = /var/lib/cinder/tmp` : Khai báo thư mục chứa lock_path