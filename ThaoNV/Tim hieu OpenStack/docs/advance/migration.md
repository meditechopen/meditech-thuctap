# Tìm hiểu về migrate máy ảo trong OpenStack

## Mục lục

[1. Giới thiệu về tính năng migrate trong OpenStack](#intro)

[2. Các kiểu migrate hiện có trong OPS và workflow của chúng](#type)

[3. So sánh ưu nhược điểm giữa cold và live migrate](#compare)

[4. Hướng dẫn cấu hình cold migrate trong OpenStack](#cold)

[5. Hướng dẫn cấu hình live migrate trong OpenStack](#live)

---------

<a name="intro"></a>
## 1. Giới thiệu về tính năng migrate trong OpenStack

<img src="http://i.imgur.com/vFgXoEK.png">

Migration là quá trình di chuyển máy ảo từ host vật lí này sang một host vật lí khác. Migration được sinh ra để làm nhiệm vụ bảo trì nâng cấp hệ thống. Ngày nay tính năng này đã được phát triển để thực hiện nhiều tác vụ hơn:

- Cân bằng tải: Di chuyển VMs tới các host khác kh phát hiện host đang chạy có dấu hiệu quá tải.
- Bảo trì, nâng cấp hệ thống: Di chuyển các VMs ra khỏi host trước khi tắt nó đi.
- Khôi phục lại máy ảo khi host gặp lỗi: Restart máy ảo trên một host khác.

Trong OpenStack, việc migrate được thực hiện giữa các node compute với nhau hoặc giữa các project trên cùng 1 node compute.

<a name="type"></a>
## 2. Các kiểu migrate hiện có trong OPS và workflow của chúng

OpenStack hỗ trợ 2 kiểu migration đó là:

- Cold migration : Non-live migration
- Live migration :
  - True live migration (shared storage or volume-based)
  - Block live migration

**Workflow khi thực hiện cold migrate**

- Tắt máy ảo (giống với virsh destroy) và ngắt kết nối với volume
- Di chuyển thư mục hiện tại của máy ảo (instance_dir ->
instance_dir_resize)
- Nếu sử dụng QCOW2 với backing files (chế độ mặc định) thì image sẽ được convert thành dạng flat
- Với shared storage, di chuyển thư mục chứa máy ảo. Nếu không, copy toàn bộ thông qua SCP.

**Workflow khi thực hiện live migrate**

- Kiểm tra lại xem  storage backend có phù hợp với loại migrate sử dụng không
  - Thực hiện check shared storage với chế độ migrate thông thường
  - Không check khi sử dụng block migrations
  - Việc kiểm tra thực hiện trên cả 2 node gửi và nhận, chúng được điều phối bởi RPC call từ scheduler.
- Đối với nơi nhận
  - Tạo các kết nối càn thiết với volume.
  - Nếu dùng block migration, tạo thêm thư mục chứa máy ảo, truyền vào đó những backing files còn thiếu từ Glance và tạo disk trống.
- Tại nơi gửi, bắt đầu quá trình migration (qua url)
- Khi hoàn thành, generate lại file XML và define lại nó ở nơi chứa máy ảo mới.

Dưới đây là các hình minh họa tiến trình khi thực hiện migrate máy ảo:

- Pre-migration: VM trên host A đang chạy, host B được lựa chọn bởi người dùng hoặc scheduler.

<img src="https://github.com/thaonguyenvan/meditech-thuctap/blob/master/ThaoNV/Tim%20hieu%20OpenStack/images/migrate1.png?raw=true">

- Reservation: Xác nhận host B có đủ tà nguyên để thực hiện migrate, tạo mới một máy ảo trên host B.

<img src="https://github.com/thaonguyenvan/meditech-thuctap/blob/master/ThaoNV/Tim%20hieu%20OpenStack/images/migrate3.png?raw=true">

- Iterative pre-copy : Bộ nhớ được di chuyển, máy ảo mới ở trạng thái suspend

<img src="https://github.com/thaonguyenvan/meditech-thuctap/blob/master/ThaoNV/Tim%20hieu%20OpenStack/images/migrate5.png?raw=true">

- Stop and copy : Suspend máy ảo và copy phần còn lại cũng như trạng thái của CPU.

<img src="https://github.com/thaonguyenvan/meditech-thuctap/blob/master/ThaoNV/Tim%20hieu%20OpenStack/images/migrate6.png?raw=true">

- Commitment : Host B trở thành primary host cho VM.

<img src="https://github.com/thaonguyenvan/meditech-thuctap/blob/master/ThaoNV/Tim%20hieu%20OpenStack/images/migrate7.png?raw=true">

<a name="compare"></a>
### 3. So sánh ưu nhược điểm giữa cold và live migrate

**Cold migrate**

- Ưu điểm:
  - Đơn giản, dễ thực hiện
  - Thực hiện được với mọi loại máy ảo
- Hạn chế:
  - Thời gian downtime lớn
  - Không thể chọn được host muốn migrate tới.
  - Quá trình migrate có thể mất một khoảng thời gian dài

**Live migrate**

- Ưu điểm:
  - Có thể chọn host muốn migrate
  - Tiết kiệm chi phí, tăng sự linh hoạt trong khâu quản lí và vận hành.
  - Giảm thời gian downtime và gia tăng thêm khả năng "cứu hộ" khi gặp sự cố
- Nhược điểm:
  - Dù chọn được host nhưng vẫn có những giới hạn nhất định
  - Quá trình migrate có thể fails nếu host bạn chọn không có đủ tài nguyên.
  - Bạn không được can thiệp vào bất cứ tiến trình nào trong quá trình live migrate.
  - Khó migrate với những máy ảo có dung lượng bộ nhớ lớn và trường hợp hai host khác CPU.

- Trong live-migrate, có 2 loại đó là True live migration và Block live migration. Hình dưới đây mô tả những loại storage mà 2 loại migration trên hỗ trợ:

<img src="https://github.com/thaonguyenvan/meditech-thuctap/blob/master/ThaoNV/Tim%20hieu%20OpenStack/images/migrate2.png?raw=true">

**Ngữ cảnh sử dụng:**

- Nếu bạn buộc phải chọn host và giảm tối da thời gian downtime của server thì bạn nên chọn live-migrate (tùy vào loại storage sử dụng mà chọn true hoặc block migration)
- Nếu bạn không muốn chọn host hoặc đã kích hoạt configdrive (một dạng ổ lưu trữ metadata của máy ảo, thường được dùng để cung cấp cấu hình network khi không sử dụng DHCP) thì hãy lựa chọn cold migrate.

<a name="cold"></a>
### 4. Hướng dẫn cấu hình cold migrate trong OpenStack

- Sử dụng với SSH tunneling để migrate máy ảo hoặc resize máy ảo ở node mới.

**Các bước cấu hình SSH Tunneling giữa các Nodes compute**

- Cho phép user nova có thể login (thực hiện trên tất cả các node compute)

`# usermod -s /bin/bash nova`

- Thực hiện tạo key pair trên node compute nguồn cho user nova

``` sh
# su nova
$ ssh-keygen
$ echo 'StrictHostKeyChecking no' >> /var/lib/nova/.ssh/config
$ cat /var/lib/nova/.ssh/id_rsa.pub >> /var/lib/nova/.ssh/authorized_keys
$ exit
```

- Thực hiện với quyền root, scp key pari tới compute node

``` sh
scp /var/lib/nova/.ssh/id_rsa computeNodeAddress:~/
scp /var/lib/nova/.ssh/id_rsa.pub computeNodeAddress:~/
```

- Trên node đích, thay đổi quyền của key pair cho user nova và add key pair đó vào SSH.

``` sh
$ mkdir -p /var/lib/nova/.ssh
$ cp id_rsa /var/lib/nova/.ssh/
$ cat id_rsa.pub >> /var/lib/nova/.ssh/authorized_keys
$ chown nova:nova /var/lib/nova/.ssh/authorized_keys
$ chown nova:nova /var/lib/nova/.ssh/id_rsa
$ echo 'StrictHostKeyChecking no' >> /var/lib/nova/.ssh/config
```

- Kiểm tra để chắc chắn rằng user `nova` có thể login được vào node compute còn lại mà không cần sử dụng password

``` sh
# su nova
$ ssh computeNodeAddress
$ exit
```

- Thực hiện restart service (Thực hiện trên cả node nguồn và đích)

``` sh
systemctl restart libvirtd.service
systemctl restart openstack-nova-compute.service
```

**Thực hiện migrate máy ảo**

- Tắt máy ảo

`# nova stop vm1`

- Migrate vm, nova-scheduler sẽ dựa vào cấu hình blancing weitgh và filter để define ra node compute đích

`# nova migrate vm1`

- Chờ đến khi vm thay đổi trạng thái sang `VERIFY_RESIZE` (dùng nova show để xem), confirm việc migrate :

`nova resize-confirm  vm1`

<a name="live"></a>
### 5. Hướng dẫn cấu hình live migrate (block migration) trong OpenStack

OpenStack hỗ trợ 2 loại live migrate, mỗi loại lại có yêu cầu và được sử dụng với mục đích riêng:

- True live migration (shared storage or volume-based) : Trong trường hợp này, máy ảo sẽ được di chuyển sửa dụng storage mà cả hai máy computes đều có thể truy cập tới. Nó yêu cầu máy ảo sử dụng block storage hoặc shared storage.
- Block live migration : Mất một khoảng thời gian lâu hơn để hoàn tất quá trình migrate bởi máy ảo được chuyển từ host này sang host khác. Tuy nhiên nó lại không yêu cầu máy ảo sử dụng hệ thống lưu trữ tập trung.

Các yêu cầu chung:
- Cả hai node nguồn và đích đều phải được đặt trên cùng subnet và có cùng loại CPU.
- Cả controller và compute đều phải phân giải được tên miền của nhau.
- Compute node buộc phải sử dụng KVM với libvirt.

**Cấu hình migration**

- Sửa thông tin trong libvirt
cp /etc/libvirt/libvirtd.conf /etc/libvirt/libvirtd.conf.orig

``` sh
sed -i 's|#listen_tls = 0|listen_tls = 0|'g /etc/libvirt/libvirtd.conf
sed -i 's|#listen_tcp = 1|listen_tcp = 1|'g /etc/libvirt/libvirtd.conf
sed -i 's|#tcp_port = "16509"|tcp_port = "16509"|'g /etc/libvirt/libvirtd.conf
sed -i 's|#auth_tcp = "sasl"|auth_tcp = "none"|'g /etc/libvirt/libvirtd.conf

cp /etc/sysconfig/libvirtd /etc/sysconfig/libvirtd.orig
sed -i 's|#LIBVIRTD_ARGS="--listen"|LIBVIRTD_ARGS="--listen"|'g /etc/sysconfig/libvirtd
```

- Cập nhậy URL trong file `/etc/nova/nova.conf`

`live_migration_uri=qemu+tcp://nova@%s/system`

- Restart lại dịch vụ:

``` sh
systemctl restart libvirtd
systemctl restart openstack-nova-compute.service
```

- Nếu sử dụng block live migration cho các VMs boot từ local thì sửa file `nova.conf` rồi restart lại dịch vụ nova-compute :

``` sh

[libvirt]
.......
block_migration_flag=VIR_MIGRATE_UNDEFINE_SOURCE, VIR_MIGRATE_PEER2PEER, VIR_MIGRATE_LIVE, VIR_MIGRATE_NON_SHARED_INC
......
```

`systemctl restart openstack-nova-compute.service`

**Migrate máy ảo**

- Chạy câu lệnh `nova list` xem danh sách máy ảo

``` sh
[root@controller ~]# nova list
+--------------------------------------+------+--------+------------+-------------+-------------------------+
| ID                                   | Name | Status | Task State | Power State | Networks                |
+--------------------------------------+------+--------+------------+-------------+-------------------------+
| b20fe6cb-832a-4654-8262-4e9f0dfe87e0 | vm04 | ACTIVE | -          | Running     | provider1=172.16.69.243 |
+--------------------------------------+------+--------+------------+-------------+-------------------------+
```

- Để xem máy ảo đang thuộc host nào, chạy câu lệnh `nova show VMName`

``` sh
[root@controller ~]# nova show vm04
+--------------------------------------+----------------------------------------------------------+
| Property                             | Value                                                    |
+--------------------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig                    | AUTO                                                     |
| OS-EXT-AZ:availability_zone          | nova                                                     |
| OS-EXT-SRV-ATTR:host                 | compute2                                                 |
| OS-EXT-SRV-ATTR:hostname             | vm04                                                     |
| OS-EXT-SRV-ATTR:hypervisor_hostname  | compute2                                                 |
```

- Chạy câu lệnh `nova service-list` để xem danh sách các node có thể migrate tới:

``` sh
[root@controller ~]# nova service-list
+----+------------------+------------+----------+---------+-------+----------------------------+-----------------+
| Id | Binary           | Host       | Zone     | Status  | State | Updated_at                 | Disabled Reason |
+----+------------------+------------+----------+---------+-------+----------------------------+-----------------+
| 1  | nova-conductor   | controller | internal | enabled | up    | 2017-07-21T11:00:06.000000 | -               |
| 2  | nova-consoleauth | controller | internal | enabled | up    | 2017-07-21T11:00:04.000000 | -               |
| 4  | nova-scheduler   | controller | internal | enabled | up    | 2017-07-21T11:00:03.000000 | -               |
| 6  | nova-compute     | compute1   | nova     | enabled | up    | 2017-07-21T11:00:05.000000 | -               |
| 7  | nova-compute     | compute2   | nova     | enabled | up    | 2017-07-21T11:00:06.000000 | -               |
+----+------------------+------------+----------+---------+-------+----------------------------+-----------------+
```

- Ở đây máy ảo đang chạy trên node compute2 và mình muốn chuyển nó sang compute1, trước tiên kiểm tra lại để chắc chắn compute1 có đủ tài nguyên:

``` sh
[root@controller ~]# nova host-describe compute1
+----------+------------+-----+-----------+---------+
| HOST     | PROJECT    | cpu | memory_mb | disk_gb |
+----------+------------+-----+-----------+---------+
| compute1 | (total)    | 4   | 8191      | 49      |
| compute1 | (used_now) | 0   | 512       | 0       |
| compute1 | (used_max) | 0   | 0         | 0       |
+----------+------------+-----+-----------+---------+
```

- Thực hiện migrate máy ảo bằng câu lệnh `nova live-migration vm04 compute1` với những máy dùng shared storage. Đối với những máy boot từ local, sử dụng câu lệnh sau:

`nova live-migration --block-migrate vm04 compute1`

Máy ảo sẽ chuyển sang trạng thái `MIGRATING`.

<img src="../images/migrate4.png">

Sau một khoảng thời gian, máy ảo sẽ được migrate sang node compute mới.

``` sh
[root@controller ~]# nova show vm04
+--------------------------------------+----------------------------------------------------------+
| Property                             | Value                                                    |
+--------------------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig                    | AUTO                                                     |
| OS-EXT-AZ:availability_zone          | nova                                                     |
| OS-EXT-SRV-ATTR:host                 | compute1                                                 |
| OS-EXT-SRV-ATTR:hostname             | vm04                                                     |
| OS-EXT-SRV-ATTR:hypervisor_hostname  | compute1                                                 |
```


**Link tham khảo:**


https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/8/html-single/migrating_instances/

https://raymii.org/s/articles/Openstack_-_(Manually)_migrating_(KVM)_Nova_Compute_Virtual_Machines.html

https://01.org/sites/default/files/dive_into_vm_live_migration_2.pdf

https://www.openstack.org/assets/presentation-media/OSSummitAtlanta2014-NovaLibvirtKVM2.pdf

https://www.openstack.org/videos/boston-2017/openstack-in-motion-live-migration
