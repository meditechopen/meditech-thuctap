# Hướng dẫn cấu hình multiple Cinder và thực hiện tính năng migrate volume

## Mục lục

[1. Mô hình tổng quan của Cinder](#intro)

[2. Cấu hình multiple cinder storage backends](#backend)

[3. Cấu hình multiple cinder storage nodes](#node)

[4. Migrate volume](#migrate)

-------------

<a name="intro"></a>
## 1. Mô hình tổng quan của Cinder

Cinder là dịch vụ block storage quản lí các volumes trên các thiết bị lưu trữ. Đối với các hệ thống thực tế, các máy ảo sẽ được kết nối với volume thông qua storage network bởi hypervisor trên node compute.

Dưới đây là kiến trúc của Cinder

<img src="http://i.imgur.com/ncYBHUC.png">

Hình dưới đây mô tả tiến trình gán volume vào máy ảo

<img src="http://i.imgur.com/iSwCSXD.png">

Volume được `cinder-volume` tạo ra bằng cinder driver ví dụ như LVM, nfs... Thông qua API, yêu cầu tạo volume sẽ được truyền tới thông qua đường management.

Sau khi volume được tạo ra, `nova-compute` sẽ kết nối hypervisor với volume thông qua storage network. Từ đây volume sẽ được coi như là thiết bị phần cứng local đối với máy ảo.

<a name="backend"></a>
## 2. Cấu hình multiple cinder storage backend

multiple-storage backends cho phép tạo ra vài giải pháp lưu trữ cho hệ thống OpenStack và cinder-volume sẽ được chạy trên mỗi một backend storage. Nó có thể cấu hình trên cùng 1 node hoặc ở nhiều node khác nhau. Ví dụ máy chủ của bạn có 1 ổ SSD và 1 ổ SATA, cấu hình của cinder sẽ định nghĩa ra 2 backends, 1 cho SSD và 1 cho SATA.

Mỗi backend lúc này sẽ có một tên riêng. Khi volume được tạo mới, scheduler sẽ được dùng để chọn lựa ra backend phù hợp với yêu cầu. Để cấu hình multiple-storage backends, tùy chọn `enabled_backends` cần được dùng, nó sẽ định nghĩa các group cấu hình cho mỗi backend (lvm1 và lvm2).

Đây là mô hình OpenStack với 1 node storage.

<img src="http://i.imgur.com/5wZHTlX.png">

Node storage đã được cấu hình cinder sử dụng driver là `lvm`, mình sẽ gán thêm 1 ổ đĩa có dung lượng 100 GB. Sau khi gán, ta có thêm 1 ổ `dev/sdc`, tiến hành khai báo lại trong phần filter của lvm trong file `/etc/lvm/lvm.conf`:

``` sh
devices {
filter = [ "a/sdb/","a/sdc/", "r/.*/"]
}
```

Tạo physical volume đối với ổ sdc:

`pvcreate /dev/sdc`

Tạo volume group đối với ổ sdc:

`vgcreate cinder-volumes-2 /dev/sdc`

Chỉnh sửa lại file cấu hình `/etc/cinder/cinder.conf` sử dụng 2 backends:

``` sh
[DEFAULT]
auth_strategy = keystone
transport_url = rabbit://openstack:Welcome123@172.16.69.238
my_ip = 172.16.69.243
enabled_backends = lvm1,lvm2
glance_api_servers = http://172.16.69.238:9292

[database]
connection = mysql+pymysql://cinder:Welcome123@172.16.69.238/cinder

[keystone_authtoken]
auth_uri = http://172.16.69.238:5000
auth_url = http://172.16.69.238:35357
memcached_servers = 172.16.69.238:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = cinder
password = Welcome123

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp

[lvm1]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
iscsi_protocol = iscsi
iscsi_helper = lioadm
volume_backend_name=THAO1

[lvm2]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes-2
iscsi_protocol = iscsi
iscsi_helper = lioadm
volume_backend_name=THAO2
```

Restart lại các dịch vụ của cinder:

`openstack-service restart cinder`

Tạo ra 2 volume types và gán chúng với 2 backends.

``` sh
cinder type-create lvm_gold
cinder type-create lvm_silver
cinder type-list
cinder type-key lvm_silver set volume_backend_name=THAO2
cinder type-key lvm_gold set volume_backend_name=THAO1
```

Giờ đây bạn có thể tạo ra volume với 2 backends khác nhau:

``` sh
cinder create --display-name vol1 --volume-type lvm_gold 5
cinder create --display-name vol2 --volume-type lvm_silver 5
```

Mỗi backend sẽ có 1 cinder-volume riêng

``` sh
[root@block2 ~]# cinder-manage service list
Binary           Host                                 Zone             Status     State Updated At           RPC Version  Object Version  Cluster                      
cinder-scheduler controller                           nova             enabled    :-)   2017-07-26 09:36:50  3.0          1.11                                         
cinder-volume    block@lvm1                           nova             enabled    :-)   2017-07-26 09:36:21  3.0          1.11                                         
cinder-volume    block@lvm2                           nova             enabled    :-)   2017-07-26 09:36:27  3.0          1.11                                         
```

<a name="node"></a>
## 3. Cấu hình multiple cinder storage nodes

Các hệ thống thực tế thường có nhiều hơn 1 node storage. Sau đây sẽ là hướng dẫn cấu hình 2 node storage sử dụng driver LVM và kết nối tới máy ảo thông qua iSCSI. Ở ví dụ dưới đây, mỗi node storage sử dụng các loại storage backends khác nhau. Dựa vào volume type được yêu cầu trong request, cinder scheduler sẽ chọn backend để tạo volume.

Thực hiện cài 2 node storage với 2 backend là lvm1 và lvm2. Tham khảo thêm cách cài đặt block storage service [tại đây](https://github.com/thaonguyenvan/meditech-ghichep-openstack/blob/master/docs/hd-caidat-openstack-newton-OVS-bonding.md#cinder)

Tiếp theo ta cũng tiến hành tạo 2 backend types và tạo volume

``` sh
cinder type-create lvm_silver
cinder type-create lvm_gold
cinder type-key lvm_silver set volume_backend_name=silver
cinder type-key lvm_gold set volume_backend_name=gold
```

Khi tạo volume, cinder scheduler sẽ quyết định node dựa theo backends type. Mục đích tạo ra các backends giống nhau trên 2 node storage khác nhau là nhằm mục đích migrate volume. Các volume chỉ có thể migrate được nếu chúng có cùng volume type.

Ở đây mình tạo ra 2 volume có dung lượng 5 GB

``` sh
cinder create --display-name vol1 --volume-type lvm_silver 5
cinder create --display-name vol2 --volume-type lvm_gold 5
```

<a name="migrate"></a>
## 4. Migrate volume

Để có thể migrate được volume, chúng phải có cùng volume type. Mặc định nếu không khai báo, volume sẽ thuộc loại `none` khi tạo. Để thay đổi volume type mặc định, ta có thể chỉnh sửa thông số `default_volume_type` trong file config `/etc/cinder/cinder.conf`.

``` sh
# vi /etc/cinder/cinder.conf
[DEFAULT]
...
default_volume_type = lvm_silver
...
```

Ở node controller, kiểm tra lại các volume type đang có:

``` sh
[root@controller ~]# cinder type-list
+--------------------------------------+------------+-------------+-----------+
| ID                                   | Name       | Description | Is_Public |
+--------------------------------------+------------+-------------+-----------+
| 7f769d80-89d4-46c7-ab2e-2cbd1c612c01 | lvm_gold   | -           | True      |
| de827fba-4739-42ce-a315-929e38387162 | lvm_silver | -           | True      |
+--------------------------------------+------------+-------------+-----------+
```

Xem các volume hiện có

``` sh
[root@controller ~]# cinder list
+--------------------------------------+-----------+--------+------+-------------+----------+-------------+
| ID                                   | Status    | Name   | Size | Volume Type | Bootable | Attached to |
+--------------------------------------+-----------+--------+------+-------------+----------+-------------+
| 3e5d9923-08d6-403a-bf13-2ba0544d29cc | available | vol2   | 5    | lvm_gold    | false    |             |
| 689e8950-2ea2-4f72-9123-7dd47308dd38 | available | vol1   | 5    | lvm_silver  | false    |             |
+--------------------------------------+-----------+--------+------+-------------+----------+-------------+
```

Kiểm tra `vol1` hiện đang ở node nào

``` sh
[root@controller ~]# cinder show 689e8950-2ea2-4f72-9123-7dd47308dd38
+--------------------------------+--------------------------------------+
| Property                       | Value                                |
+--------------------------------+--------------------------------------+
| attachments                    | []                                   |
| availability_zone              | nova                                 |
| bootable                       | false                                |
| consistencygroup_id            | None                                 |
| created_at                     | 2017-07-26T10:41:21.000000           |
| description                    | None                                 |
| encrypted                      | False                                |
| id                             | 689e8950-2ea2-4f72-9123-7dd47308dd38 |
| metadata                       | {}                                   |
| migration_status               | None                                 |
| multiattach                    | False                                |
| name                           | vol1                                 |
| os-vol-host-attr:host          | block2@lvm2#THAO2                    |
| os-vol-mig-status-attr:migstat | None                                 |
| os-vol-mig-status-attr:name_id | None                                 |
| os-vol-tenant-attr:tenant_id   | e9264a9f015143758c744d7a2fc58eae     |
| replication_status             | disabled                             |
| size                           | 5                                    |
| snapshot_id                    | None                                 |
| source_volid                   | None                                 |
| status                         | available                            |
| updated_at                     | 2017-07-26T10:41:25.000000           |
| user_id                        | 0237219e6a1e4d69a46f53d0c3f4060d     |
| volume_type                    | lvm_silver                           |
+--------------------------------+--------------------------------------+
```

Như vậy volume `vol1` đang ở node `block2` với volume type là `lvm2`. Ta thực hiện câu lệnh sau để migrate sang node 1 với volume type là `lvm2`:

``` sh
cinder migrate 689e8950-2ea2-4f72-9123-7dd47308dd38 block@lvm2#THAO2
```

Sau khi thực hiện câu lệnh, trạng thái của volume sẽ chuyển sang `migrating`

<img src="http://i.imgur.com/F3JrboG.png">

Khi quá trình migrate hoàn tất, volume sẽ chuyển sang node `block` với trạng thái `success`

<img src="http://i.imgur.com/6eNVslc.png">


**Link tham khảo:**

https://github.com/kalise/OpenStack-Lab-Tutorial/blob/master/Content/working-cinder.md

https://github.com/kalise/OpenStack-Lab-Tutorial/blob/master/Content/multiple_cinder.md

http://www.sparkmycloud.com/blog/cinder-block-storage-as-a-service/
