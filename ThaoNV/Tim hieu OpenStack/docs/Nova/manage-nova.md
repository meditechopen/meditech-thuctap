# Các thao tác quản trị cơ bản với Nova

## Mục lục

[1. Quản lý flavor](#flavor)

[2. Quản lí và truy cập máy ảo sử dụng keypair](#keypair)

[3. Khởi tạo, tắt và hủy máy ảo](#instance)

[4. Quản lí snapshot](#snapshot)

[5. Quản lí quota](#quota)

[6. Lấy số liệu thống kê nova](#statistic)

[7. Kiểm tra hoạt động và Quản lí Nova Compute Servers](#verify)

8. Quản lí volume

----------

<a name="flavor"></a>
## 1. Quản lý flavor

Instance flavor là template của máy ảo và nó chỉ ra máy ảo thuộc loại nào. Ngay sau khi cài đặt OpenStack cloud, người dùng sẽ có trước một vài các flavor. Bạn có thể thêm hoặc xóa các flavor có sẵn.

Flavor cho biết các thông số sau:

| Element | Description |
|---------|-------------|
| Name | Tên mô tả |
| Memory MB | RAM máy ảo (megabytes) |
| Disk | Ổ đĩa máy ảo (gigabytes). Đây là ephemeral disk mà base image được copy lên. Khi boot từ volume thì nó không được sử dụng |
| Ephemeral | Kích thước của ephemeral data disk số 2. Đây là đĩa trống, chưa được format và chỉ tồn tại khi máy ảo chạy |
| Swap | Đây là tùy chọn cho swap của máy ảo. Giá trị mặc định là 0 |
| VCPUs | Số lượng CPUs ảo của máy ảo |
| Is Public	| Quy định flavor có thể được dùng bởi tất cả các user hay chỉ những user trong project nào đó |
| Extra Specs | Quy định flavor được dùng trên node compute nào |

Để hiển thị danh sách các flavor, dùng câu lệnh `openstack flavor list` hoặc `nova flavor-list`

``` sh
[root@controller ~(keystone_admin)]# openstack flavor list
+----+-----------+-------+------+-----------+-------+-----------+
| ID | Name      |   RAM | Disk | Ephemeral | VCPUs | Is Public |
+----+-----------+-------+------+-----------+-------+-----------+
| 1  | m1.tiny   |   512 |    1 |         0 |     1 | True      |
| 2  | m1.small  |  2048 |   20 |         0 |     1 | True      |
| 3  | m1.medium |  4096 |   40 |         0 |     2 | True      |
| 4  | m1.large  |  8192 |   80 |         0 |     4 | True      |
| 5  | m1.xlarge | 16384 |  160 |         0 |     8 | True      |
+----+-----------+-------+------+-----------+-------+-----------+
```

Để hiển thị thông tin chi tiết của 1 flavor, sử dụng câu lệnh `openstack flavor show`

``` sh
[root@controller ~(keystone_admin)]# openstack flavor show m1.tiny
+----------------------------+---------+
| Field                      | Value   |
+----------------------------+---------+
| OS-FLV-DISABLED:disabled   | False   |
| OS-FLV-EXT-DATA:ephemeral  | 0       |
| disk                       | 1       |
| id                         | 1       |
| name                       | m1.tiny |
| os-flavor-access:is_public | True    |
| properties                 |         |
| ram                        | 512     |
| rxtx_factor                | 1.0     |
| swap                       |         |
| vcpus                      | 1       |
+----------------------------+---------+
```

Mặc định chỉ có admin mới có thể list ra toàn bộ và tạo mới flavor. Để tạo mới flavor với tên `m10.tiny` có 3GB disk, 400MB RAM và 1 vCPU, sử dụng câu lệnh sau:

``` sh
[root@controller ~(keystone_admin)]# nova flavor-create --is-public true m10.tiny auto 400 3 1
+--------------------------------------+----------+-----------+------+-----------+------+-------+-------------+-----------+
| ID                                   | Name     | Memory_MB | Disk | Ephemeral | Swap | VCPUs | RXTX_Factor | Is_Public |
+--------------------------------------+----------+-----------+------+-----------+------+-------+-------------+-----------+
| a0b2da8f-0ad2-4ecd-b9ed-6a4c5adad0b8 | m10.tiny | 400       | 3    | 0         |      | 1     | 1.0         | True      |
+--------------------------------------+----------+-----------+------+-----------+------+-------+-------------+-----------+
```

Để xóa flavor, sử dụng câu lệnh `nova flavor-delete`. Ví dụ ở đây mình muốn xóa flavor m10.tiny vừa tạo:

``` sh
[root@controller ~(keystone_admin)]# nova flavor-delete m10.tiny
+--------------------------------------+----------+-----------+------+-----------+------+-------+-------------+-----------+
| ID                                   | Name     | Memory_MB | Disk | Ephemeral | Swap | VCPUs | RXTX_Factor | Is_Public |
+--------------------------------------+----------+-----------+------+-----------+------+-------+-------------+-----------+
| a0b2da8f-0ad2-4ecd-b9ed-6a4c5adad0b8 | m10.tiny | 400       | 3    | 0         |      | 1     | 1.0         | True      |
+--------------------------------------+----------+-----------+------+-----------+------+-------+-------------+-----------+
```

**Lưu ý**: Trên dashboard, để thực hiện các thao tác quản lí với flavor, vào System -> Flavors.

- Flavor có thể bị giới hạn bởi hypervisor. Ví dụ libvirt driver có thể kích hoạt quotas để định mức số CPUs, disk, bandwith I/O ... trên máy ảo. Xem thêm [tại đây](https://docs.openstack.org/admin-guide/compute-flavors.html).

<a name="keypair"></a>
## 2. Quản lí và truy cập máy ảo sử dụng keypair

SSH cho phép bạn xác thực user bằng việc sử dụng private-public keypair. Máy ảo chạy với public key chỉ có thể được sử dụng bởi người nắm giữ private key.

OpenStack có thể lưu public key và đưa nó vào bên trong instance ở thời điểm máy ảo được khởi chạy. Nhiệm vụ của bạn là phải giữ private key ở trạng thái bảo mật. Nếu bạn mấy key, bạn sẽ không thể lấy lại. Trong trường hợp đó bạn nên bỏ public key ở máy ảo và generate ra một cặp keys khác. Nếu ai đó có private key, họ sẽ có thể truy cập được vào máy ảo của bạn.

Để tạo keypair, chạy câu lệnh sau:

`nova keypair-add apresskey1 > ~/apresskey`

Private key sẽ được lưu tại file `~/apresskey1` trong máy tính của bạn.

``` sh
[root@controller ~(keystone_admin)]# cat ~/apresskey1
-----BEGIN RSA PRIVATE KEY-----
MIIEqAIBAAKCAQEAhsJfqKRynQl17KQe/uG+M02WhAdenct/i1nDcoRKelEgjEtK
..............
MvBytQJEJkkWWTjzw8lb2Y5AI2e+b+BpT3S6wnYdf85NPkpvH7LRyGMd3g4=
-----END RSA PRIVATE KEY-----
```

Public key được lưu trên OpenStack cloud và đã sẵn sàng để sử dụng. Bạn có thể check danh sách public keys bằng câu lệnh sau:

``` sh
[root@controller ~(keystone_admin)]# nova keypair-list
+------------+-------------------------------------------------+
| Name       | Fingerprint                                     |
+------------+-------------------------------------------------+
| apresskey1 | f3:22:69:ae:e7:35:24:34:7f:3a:f4:6f:d7:8c:81:29 |
+------------+-------------------------------------------------+
```

Trước khi SSH client có thể dùng private key, bạn cần chắc chắn đã cấp quyền truy cập cho nó:

``` sh
[root@controller ~(keystone_admin)]# chmod 600 apresskey1
[root@controller ~(keystone_admin)]# ls -l apresskey1
-rw-------. 1 root root 1684 Jun 22 16:41 apresskey1
```

Nếu bạn muốn tạo và xóa keypair trên dashboard, tìm tới Project -> Compute -> Access & Security -> Key Pairs

Khi máy ảo chạy và được gán floating IP, bạn có thể kết nối tới nó bằng câu lệnh:

`$ ssh -i ~/apresskey1 cirros@10.100.1.103`

Tùy chọn -i dùng để chỉ tới private key.

<a name="instance"></a>
## 3. Khởi tạo, tắt và hủy máy ảo

Để khởi tạo một máy ảo, bạn cần cung cấp 3 yếu tố: tên máy ảo, flavor, và source của máy ảo. Source ở đây có thể là image, snapshot hoặc volume. Bạn cũng có thể thêm một vài yếu tố tùy chọn như  keypair, security group, user data files, và volume.

Dưới đây là câu lệnh để khởi rạo máy ảo:

``` sh
nova boot --flavor FLAVOR_ID --image IMAGE_ID --key-name KEY_NAME \
 --user-data USER_DATA_FILE --security-groups SEC_GROUP_NAME --meta KEY=VALUE \ INSTANCE_NAME
```

Ví dụ ở đây bạn muốn tạo máy ảo với tên `vm01` bằng flavor `m1.tiny` từ image `cirros-0.3.4-x86_64` và dùng extenal network:

``` sh
[root@controller tmp(keystone_admin)]# nova boot --flavor m1.tiny --image cirros-0.3.4-x86_64 --key-name apresskey1 --nic net-id=78288d77-4a28-42d7-bb4b-01cecc088a30 vm01
+--------------------------------------+------------------------------------------------------------+
| Property                             | Value                                                      |
+--------------------------------------+------------------------------------------------------------+
| OS-DCF:diskConfig                    | MANUAL                                                     |
| OS-EXT-AZ:availability_zone          |                                                            |
| OS-EXT-SRV-ATTR:host                 | -                                                          |
| OS-EXT-SRV-ATTR:hypervisor_hostname  | -                                                          |
| OS-EXT-SRV-ATTR:instance_name        | instance-00000018                                          |
| OS-EXT-STS:power_state               | 0                                                          |
| OS-EXT-STS:task_state                | scheduling                                                 |
| OS-EXT-STS:vm_state                  | building                                                   |
| OS-SRV-USG:launched_at               | -                                                          |
| OS-SRV-USG:terminated_at             | -                                                          |
| accessIPv4                           |                                                            |
| accessIPv6                           |                                                            |
| adminPass                            | DFJXhAw33i3t                                               |
| config_drive                         |                                                            |
| created                              | 2017-06-22T10:03:21Z                                       |
| flavor                               | m1.tiny (1)                                                |
| hostId                               |                                                            |
| id                                   | 82a69aeb-97ee-4e52-89d4-1b1058f40526                       |
| image                                | cirros-0.3.4-x86_64 (965552f0-6124-454e-8896-dcec78351bd0) |
| key_name                             | apresskey1                                                 |
| metadata                             | {}                                                         |
| name                                 | vm01                                                       |
| os-extended-volumes:volumes_attached | []                                                         |
| progress                             | 0                                                          |
| security_groups                      | default                                                    |
| status                               | BUILD                                                      |
| tenant_id                            | b47e8a9d5d88439dadc4f849c0424e8c                           |
| updated                              | 2017-06-22T10:03:22Z                                       |
| user_id                              | cd171df00daf44208ba66c8fab9595b9                           |
+--------------------------------------+------------------------------------------------------------+
```

Kiểm tra trạng thái máy ảo, dùng câu lệnh `nova list`

``` sh
[root@controller tmp(keystone_admin)]# nova list
+--------------------------------------+------+--------+------------+-------------+----------------------------------+
| ID                                   | Name | Status | Task State | Power State | Networks                         |
+--------------------------------------+------+--------+------------+-------------+----------------------------------+
| 82a69aeb-97ee-4e52-89d4-1b1058f40526 | vm01 | ACTIVE | -          | Running     | external_network=192.168.100.183 |
+--------------------------------------+------+--------+------------+-------------+----------------------------------+
```

Để kết nối máy ảo vừa tạo với console trên trình duyệt bằng noVNC client, chạy câu lệnh sau:

`nova get-vnc-console vm01 novnc`

Bạn sẽ nhận được 1 đoạn URL, paste đoạn này vào trình duyệt để kết nối tới máy ảo:

<img src="http://i.imgur.com/KaRdyu6.png">

Trên dashboard, để tạo máy ảo, tìm đến Project -> Compute -> Instances

Để xóa máy ảo, sử dụng câu lệnh `nova delete`

Ví dụ để xóa vm01 vừa tạo:

``` sh
[root@controller tmp(keystone_admin)]# nova delete vm01
Request to delete server vm01 has been accepted.
[root@controller tmp(keystone_admin)]# nova list
+----+------+--------+------------+-------------+----------+
| ID | Name | Status | Task State | Power State | Networks |
+----+------+--------+------------+-------------+----------+
+----+------+--------+------------+-------------+----------+
```

Để reboot máy ảo, sử dụng `nova reboot`, đây là soft reboot, để sử dụng hard reboot, thêm tùy chọn `--hard`.

``` sh
[root@controller tmp(keystone_admin)]# nova reboot vm01
Request to reboot server <Server: vm01> has been accepted.
```

Để dừng máy ảo, sử dụng `nova stop`

``` sh
[root@controller tmp(keystone_admin)]# nova stop vm01
Request to stop server vm01 has been accepted.
[root@controller tmp(keystone_admin)]# nova list
+--------------------------------------+------+---------+------------+-------------+----------------------------------+
| ID                                   | Name | Status  | Task State | Power State | Networks                         |
+--------------------------------------+------+---------+------------+-------------+----------------------------------+
| 82a69aeb-97ee-4e52-89d4-1b1058f40526 | vm01 | SHUTOFF | -          | Shutdown    | external_network=192.168.100.183 |
+--------------------------------------+------+---------+------------+-------------+----------------------------------+
```

Để start máy ảo, sử dụng `nova start`

``` sh
[root@controller tmp(keystone_admin)]# nova start vm01
Request to start server vm01 has been accepted.
[root@controller tmp(keystone_admin)]# nova list
+--------------------------------------+------+--------+------------+-------------+----------------------------------+
| ID                                   | Name | Status | Task State | Power State | Networks                         |
+--------------------------------------+------+--------+------------+-------------+----------------------------------+
| 82a69aeb-97ee-4e52-89d4-1b1058f40526 | vm01 | ACTIVE | -          | Running     | external_network=192.168.100.183 |
+--------------------------------------+------+--------+------------+-------------+----------------------------------+
```

<a name="snapshot"></a>
## 4. Quản lí snapshot

OpenStack có thể tạo snapshot khi máy ảo đang chạy. snapshot tương tự như image, người dùng có thể tạo mới máy ảo từ snapshot.

Kiểm tra xem có image hay máy ảo nào đang chạy không:

``` sh
[root@controller tmp(keystone_admin)]# nova image-list
+--------------------------------------+---------------------+--------+--------+
| ID                                   | Name                | Status | Server |
+--------------------------------------+---------------------+--------+--------+
| 8867a307-8e2a-4c17-ac07-3bb126681ff5 | cent6               | ACTIVE |        |
| 965552f0-6124-454e-8896-dcec78351bd0 | cirros-0.3.4-x86_64 | ACTIVE |        |
+--------------------------------------+---------------------+--------+--------+
[root@controller tmp(keystone_admin)]# nova list
+--------------------------------------+------+--------+------------+-------------+----------------------------------+
| ID                                   | Name | Status | Task State | Power State | Networks                         |
+--------------------------------------+------+--------+------------+-------------+----------------------------------+
| 2e883f21-fb7e-44c5-b50c-9742fbfdceb7 | vm01 | ACTIVE | -          | Running     | external_network=192.168.100.184 |
+--------------------------------------+------+--------+------------+-------------+----------------------------------+
```

Bạn có thể tạo snapshot từ máy ảo đang chạy (vm01):

``` sh
[root@controller tmp(keystone_admin)]# nova image-create vm01 vm01_snap
[root@controller tmp(keystone_admin)]# nova image-list
+--------------------------------------+---------------------+--------+--------------------------------------+
| ID                                   | Name                | Status | Server                               |
+--------------------------------------+---------------------+--------+--------------------------------------+
| 8867a307-8e2a-4c17-ac07-3bb126681ff5 | cent6               | ACTIVE |                                      |
| 965552f0-6124-454e-8896-dcec78351bd0 | cirros-0.3.4-x86_64 | ACTIVE |                                      |
| 264575c0-1034-40fe-b8c8-761a68cc34f1 | vm01_snap           | ACTIVE | 2e883f21-fb7e-44c5-b50c-9742fbfdceb7 |
+--------------------------------------+---------------------+--------+--------------------------------------+
```

Giờ bạn có thể tạo máy ảo từ snapshot này

``` sh
[root@controller tmp(keystone_admin)]# nova boot --flavor m1.tiny --nic net-id=78288d77-4a28-42d7-bb4b-01cecc088a30 --image vm01_snap vm_from_sn
+--------------------------------------+--------------------------------------------------+
| Property                             | Value                                            |
+--------------------------------------+--------------------------------------------------+
| OS-DCF:diskConfig                    | MANUAL                                           |
| OS-EXT-AZ:availability_zone          |                                                  |
| OS-EXT-SRV-ATTR:host                 | -                                                |
| OS-EXT-SRV-ATTR:hypervisor_hostname  | -                                                |
| OS-EXT-SRV-ATTR:instance_name        | instance-0000001a                                |
| OS-EXT-STS:power_state               | 0                                                |
| OS-EXT-STS:task_state                | scheduling                                       |
| OS-EXT-STS:vm_state                  | building                                         |
| OS-SRV-USG:launched_at               | -                                                |
| OS-SRV-USG:terminated_at             | -                                                |
| accessIPv4                           |                                                  |
| accessIPv6                           |                                                  |
| adminPass                            | U699nCRrGRWs                                     |
| config_drive                         |                                                  |
| created                              | 2017-06-22T10:23:55Z                             |
| flavor                               | m1.tiny (1)                                      |
| hostId                               |                                                  |
| id                                   | e4804794-7d9f-4fbd-9721-9666f6953b2f             |
| image                                | vm01_snap (264575c0-1034-40fe-b8c8-761a68cc34f1) |
| key_name                             | -                                                |
| metadata                             | {}                                               |
| name                                 | vm_from_sn                                       |
| os-extended-volumes:volumes_attached | []                                               |
| progress                             | 0                                                |
| security_groups                      | default                                          |
| status                               | BUILD                                            |
| tenant_id                            | b47e8a9d5d88439dadc4f849c0424e8c                 |
| updated                              | 2017-06-22T10:23:55Z                             |
| user_id                              | cd171df00daf44208ba66c8fab9595b9                 |
+--------------------------------------+--------------------------------------------------+
```

<a name="quota"></a>
## 5. Quản lí quota

Quota giới hạn số lượng resource. Số lượng resource mặc định được cho phép cho mỗi tenant được định nghĩa trong file config của nova (/etc/nova/nova.conf). Dưới đây là ví dụ:

``` sh
# Number of instances allowed per project (integer value)
quota_instances=10
# Number of instance cores allowed per project (integer value)
quota_cores=20
# Megabytes of instance RAM allowed per project (integer value)
quota_ram=51200
# Number of floating IPs allowed per project (integer value)
quota_floating_ips=10
# Number of fixed IPs allowed per project (this should be at least the number
# of instances allowed) (integer value)
quota_fixed_ips=-1
# Number of metadata items allowed per instance (integer value)
quota_metadata_items=128
# Number of injected files allowed (integer value)
quota_injected_files=5
# Number of bytes allowed per injected file (integer value)
quota_injected_file_content_bytes=10240
# Length of injected file path (integer value)
quota_injected_file_path_length=255
# Number of security groups per project (integer value)
quota_security_groups=10
# Number of security rules per security group (integer value)
quota_security_group_rules=20
# Number of key pairs per user (integer value)
quota_key_pairs=100
```

User có thể lấy thông tin quota bằng câu lệnh:

``` sh
[root@controller tmp(keystone_admin)]#  nova quota-show
+-----------------------------+-------+
| Quota                       | Limit |
+-----------------------------+-------+
| instances                   | 10    |
| cores                       | 20    |
| ram                         | 51200 |
| floating_ips                | 10    |
| fixed_ips                   | -1    |
| metadata_items              | 128   |
| injected_files              | 5     |
| injected_file_content_bytes | 10240 |
| injected_file_path_bytes    | 255   |
| key_pairs                   | 100   |
| security_groups             | 10    |
| security_group_rules        | 20    |
| server_groups               | 10    |
| server_group_members        | 10    |
+-----------------------------+-------+
```

Dùng `quota-defaults` để xem quotas mặc định. Trên dashboard, bạn có thể xem một phần của quotas ở page overview.

<a name="statistic"></a>
## 6. Lấy số liệu thống kê nova

Để xem thông tin các hypervisor:

``` sh
[root@controller tmp(keystone_admin)]# nova hypervisor-list
+----+---------------------+-------+---------+
| ID | Hypervisor hostname | State | Status  |
+----+---------------------+-------+---------+
| 1  | meditech            | down  | enabled |
| 2  | compute2            | up    | enabled |
| 3  | compute1            | up    | enabled |
+----+---------------------+-------+---------+
```

Để check xem máy ảo nào đang chạy trên host:

``` sh
[root@controller tmp(keystone_admin)]# nova hypervisor-servers compute1
+--------------------------------------+-------------------+---------------+---------------------+
| ID                                   | Name              | Hypervisor ID | Hypervisor Hostname |
+--------------------------------------+-------------------+---------------+---------------------+
| 2e883f21-fb7e-44c5-b50c-9742fbfdceb7 | instance-00000019 | 3             | compute1            |
+--------------------------------------+-------------------+---------------+---------------------+
```

Để lấy thông tin tóm tắt về mức độ sử dụng tài nguyên của máy ảo trên host:

``` sh
[root@controller tmp(keystone_admin)]# nova host-describe compute1
+----------+----------------------------------+-----+-----------+---------+
| HOST     | PROJECT                          | cpu | memory_mb | disk_gb |
+----------+----------------------------------+-----+-----------+---------+
| compute1 | (total)                          | 3   | 6143      | 49      |
| compute1 | (used_now)                       | 1   | 1024      | 1       |
| compute1 | (used_max)                       | 1   | 512       | 1       |
| compute1 | b47e8a9d5d88439dadc4f849c0424e8c | 1   | 512       | 1       |
+----------+----------------------------------+-----+-----------+---------+
```

Trên dashboard, admin có thể xem tóm tắt thông số của hypervisor:

<img src="http://i.imgur.com/9kMh2VF.png">

Để lấy diagnostic information của một máy ảo nào đó:

``` sh
[root@controller tmp(keystone_admin)]# nova diagnostics 2e883f21-fb7e-44c5-b50c-9742fbfdceb7
+---------------------------+--------+
| Property                  | Value  |
+---------------------------+--------+
| memory                    | 524288 |
| memory-actual             | 524288 |
| memory-rss                | 169544 |
| tap9c1286ea-a6_rx         | 148723 |
| tap9c1286ea-a6_rx_drop    | 0      |
| tap9c1286ea-a6_rx_errors  | 0      |
| tap9c1286ea-a6_rx_packets | 2042   |
| tap9c1286ea-a6_tx         | 2190   |
| tap9c1286ea-a6_tx_drop    | 0      |
| tap9c1286ea-a6_tx_errors  | 0      |
| tap9c1286ea-a6_tx_packets | 26     |
| vda_errors                | -1     |
| vda_read                  | 0      |
| vda_read_req              | 0      |
| vda_write                 | 0      |
| vda_write_req             | 0      |
+---------------------------+--------+
```

Để lấy tóm tắt thông số thống kê của các tenant:

``` sh
[root@controller tmp(keystone_admin)]# nova usage-list
Usage from 2017-05-25 to 2017-06-23:
+----------------------------------+---------+--------------+-----------+---------------+
| Tenant ID                        | Servers | RAM MB-Hours | CPU Hours | Disk GB-Hours |
+----------------------------------+---------+--------------+-----------+---------------+
| b47e8a9d5d88439dadc4f849c0424e8c | 13      | 451869.56    | 273.17    | 4132.62       |
+----------------------------------+---------+--------------+-----------+---------------+
```

<a name="verify"></a>
## 7. Kiểm tra hoạt động và Quản lí Nova Compute Servers

Check xem nova servers đã được start hết hay chưa:

``` sh
[root@controller tmp(keystone_admin)]# systemctl status *nova* -n 0
● openstack-nova-novncproxy.service - OpenStack Nova NoVNC Proxy Server
   Loaded: loaded (/usr/lib/systemd/system/openstack-nova-novncproxy.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2017-06-22 16:24:54 +07; 1h 43min ago
 Main PID: 1083 (nova-novncproxy)
   CGroup: /system.slice/openstack-nova-novncproxy.service
           └─1083 /usr/bin/python2 /usr/bin/nova-novncproxy --web /usr/share/novnc/

● openstack-nova-api.service - OpenStack Nova API Server
   Loaded: loaded (/usr/lib/systemd/system/openstack-nova-api.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2017-06-22 16:26:34 +07; 1h 42min ago
 Main PID: 1109 (nova-api)
   CGroup: /system.slice/openstack-nova-api.service
           ├─1109 /usr/bin/python2 /usr/bin/nova-api
           ├─3210 /usr/bin/python2 /usr/bin/nova-api
           ├─3211 /usr/bin/python2 /usr/bin/nova-api
           ├─3220 /usr/bin/python2 /usr/bin/nova-api
           └─3221 /usr/bin/python2 /usr/bin/nova-api

● openstack-nova-cert.service - OpenStack Nova Cert Server
   Loaded: loaded (/usr/lib/systemd/system/openstack-nova-cert.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2017-06-22 16:26:30 +07; 1h 42min ago
 Main PID: 1124 (nova-cert)
   CGroup: /system.slice/openstack-nova-cert.service
           └─1124 /usr/bin/python2 /usr/bin/nova-cert

● openstack-nova-consoleauth.service - OpenStack Nova VNC console auth Server
   Loaded: loaded (/usr/lib/systemd/system/openstack-nova-consoleauth.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2017-06-22 16:26:30 +07; 1h 42min ago
 Main PID: 1094 (nova-consoleaut)
   CGroup: /system.slice/openstack-nova-consoleauth.service
           └─1094 /usr/bin/python2 /usr/bin/nova-consoleauth

● openstack-nova-scheduler.service - OpenStack Nova Scheduler Server
   Loaded: loaded (/usr/lib/systemd/system/openstack-nova-scheduler.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2017-06-22 16:26:31 +07; 1h 42min ago
 Main PID: 1130 (nova-scheduler)
   CGroup: /system.slice/openstack-nova-scheduler.service
           └─1130 /usr/bin/python2 /usr/bin/nova-scheduler

● openstack-nova-conductor.service - OpenStack Nova Conductor Server
   Loaded: loaded (/usr/lib/systemd/system/openstack-nova-conductor.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2017-06-22 16:26:30 +07; 1h 42min ago
 Main PID: 1125 (nova-conductor)
   CGroup: /system.slice/openstack-nova-conductor.service
           ├─1125 /usr/bin/python2 /usr/bin/nova-conductor
           ├─3172 /usr/bin/python2 /usr/bin/nova-conductor
           └─3173 /usr/bin/python2 /usr/bin/nova-conductor
```

Để xem các dịch vụ nova chạy trên host nào:

``` sh
[root@controller tmp(keystone_admin)]# nova host-list
+------------+-------------+----------+
| host_name  | service     | zone     |
+------------+-------------+----------+
| compute2   | compute     | nova     |
| compute1   | compute     | nova     |
| controller | consoleauth | internal |
| controller | conductor   | internal |
| controller | cert        | internal |
| controller | scheduler   | internal |
+------------+-------------+----------+
```

Để xem nova đã có trong Keystone services catalog chưa:

``` sh
[root@controller tmp(keystone_admin)]# openstack service show nova
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | Openstack Compute Service        |
| enabled     | True                             |
| id          | 459d69614a254028b902da314ff5a22b |
| name        | nova                             |
| type        | compute                          |
+-------------+----------------------------------+
```

Để phát hiện và sửa lỗi, có thể bạn sẽ cần biết tới địa chỉ của Compute service API endpoints::

``` sh
[root@controller tmp(keystone_admin)]# openstack endpoint show nova
+--------------+----------------------------------------------+
| Field        | Value                                        |
+--------------+----------------------------------------------+
| adminurl     | http://192.168.100.171:8774/v2/%(tenant_id)s |
| enabled      | True                                         |
| id           | 696b6aa001804b39aabd8f05b450b079             |
| internalurl  | http://192.168.100.171:8774/v2/%(tenant_id)s |
| publicurl    | http://192.168.100.171:8774/v2/%(tenant_id)s |
| region       | RegionOne                                    |
| service_id   | 459d69614a254028b902da314ff5a22b             |
| service_name | nova                                         |
| service_type | compute                                      |
+--------------+----------------------------------------------+
```

Nova service đang lắng nghe qua địa chỉ 192.168.100.171 và port 8774.

Bạn cũng sẽ có thể cần phải check log, bằng câu lệnh `lsof`, bạn có thể xem danh sách log và service đang sử dụng chúng:

``` sh
[root@controller tmp(keystone_admin)]# lsof /var/log/nova/*
COMMAND    PID USER   FD   TYPE DEVICE SIZE/OFF     NODE NAME
nova-novn 1083 nova    3w   REG  253,0   247320 34571249 /var/log/nova/nova-novncproxy.log
nova-cons 1094 nova    3w   REG  253,0  3002537 34483056 /var/log/nova/nova-consoleauth.log
nova-api  1109 nova    3w   REG  253,0  6495156 34571230 /var/log/nova/nova-api.log
nova-cert 1124 nova    3w   REG  253,0  2454313 34571248 /var/log/nova/nova-cert.log
nova-cond 1125 nova    3w   REG  253,0  2772916 34483058 /var/log/nova/nova-conductor.log
nova-sche 1130 nova    3w   REG  253,0   852534 34483057 /var/log/nova/nova-scheduler.log
nova-cond 3172 nova    3w   REG  253,0  2772916 34483058 /var/log/nova/nova-conductor.log
nova-cond 3173 nova    3w   REG  253,0  2772916 34483058 /var/log/nova/nova-conductor.log
nova-api  3210 nova    3w   REG  253,0  6495156 34571230 /var/log/nova/nova-api.log
nova-api  3211 nova    3w   REG  253,0  6495156 34571230 /var/log/nova/nova-api.log
nova-api  3220 nova    3w   REG  253,0  6495156 34571230 /var/log/nova/nova-api.log
nova-api  3221 nova    3w   REG  253,0  6495156 34571230 /var/log/nova/nova-api.log
```

## 8. Quản lí volume

Câu lệnh dùng để quản lí volume:

| Command | Description |
|---------|-------------|
| server add volume | Gán volume cho server |
| volume create	| Thêm mới volume |
| volume delete	| Xóa volume |
| server remove volume | Gỡ hoặc remove volume từ server |
| volume list	| hiển thị danh sách các volume |
| volume show | Hiển thị thông tin chi tiết về volume |
| snapshot create	| Tạo mới snapshot |
| snapshot delete	| Xóa snapshot |
| snapshot list	| Liệt kê danh sách snapshot |
| snapshot show	| Hiển thị thông tin chi tiết về snapshot |
| volume type create | Tạo mới loại volume |
| volume type delete | Xóa flavor |
| volume type list | Hiển thi các loại volume đang hỗ trợ |

Ví dụ để hiển thi các loại volume đang được hỗ trợ:

``` sh
[root@controller ~(keystone_admin)]# openstack volume type list
+--------------------------------------+-------+
| ID                                   | Name  |
+--------------------------------------+-------+
| 121fd629-c73e-4db2-9a71-b35228be60d5 | iscsi |
+--------------------------------------+-------+
```

## 9.

**Tham khảo:**

Andrey Markelov-Certified OpenStack Administrator Study Guide-Apress (2016)
