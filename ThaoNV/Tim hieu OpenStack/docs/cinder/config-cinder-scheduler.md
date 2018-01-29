# Hướng dẫn cấu hình sử dụng driver filter và weighing cho cinder scheduler

## Mục lục

1. Tổng quan về driver filter và weigher, tại sao cần sử dụng chúng

2. Hướng dẫn thực hành với vô hình multi backend

--------------------

## 1. Tổng quan về driver filter và weigher, tại sao cần sử dụng chúng

Cinder cho phép bạn lựa chọn volume backend phù hợp dựa vào những đặc tính riêng bằng cách sử dụng `DriverFilter` và `GoodnessWeigher`.

Driver filter và weigher cho bạn khả năng kiểm soát cao hơn đối với cinder, bạn sẽ có thể điều chỉnh được việc lựa chọn backend phù hợp mỗi khi có volume request. Thay vì mặc định cinder sẽ dựa vào dung lượng trống để lựa chọn, bạn có thể cấu hình cho nó lựa chọn theo đúng ý mình.

**Làm sao để sử dụng driver filter và weighing**

Câu trả lời nằm trong file cấu hình `cinder.conf`. Mặc định nếu bạn không cấu hình gì thì nó sẽ filter theo những filters sau:

```
# Which filter class names to use for filtering hosts when not specified in the
# request. (list value)
#scheduler_default_filters = AvailabilityZoneFilter,CapacityFilter,CapabilitiesFilter

# Which weigher class names to use for weighing hosts. (list value)
#scheduler_default_weighers = CapacityWeigher
```

Ta thấy có 3 thứ đó là `AvailabilityZoneFilter` - filter theo cùng az, `CapacityFilter` filter theo dung lượng và `CapabilitiesFilter` filter theo extra_specs, tức là những thông tin ta khai báo thêm trong quá trình tạo volume type ví dụ như `volume_backend_name`.

Đối với weigher, mặc định là `CapacityWeigher`, nó cũng sẽ dựa vào dung lượng.

Để kích hoạt driver filter, đặt option `scheduler_default_filters` trong file `cinder.conf` thành `DriverFilter` hoặc thêm `DriverFilter` vào sau list ở trên và uncomment option đó.

Để kích hoạt goodness filter, thay đổi option `scheduler_default_weighers` trong file `cinder.conf` thành `GoodnessWeigher` hoặc thêm nó vào list.

Bạn có thể chọn sử dụng DriverFilter mà không cần GoodnessWeigher hoặc sử dụng cả hai.

**Lưu ý: Tùy từng backend mới hỗ trợ DriverFilter and GoodnessWeigher**

Một số properties dùng cho `CapabilitiesFilter`:

`host`
The host’s name
`volume_backend_name`
The volume back end name
`vendor_name`
The vendor name
`driver_version`
The driver version
`storage_protocol`
The storage protocol
`QoS_support`
Boolean signifying whether QoS is supported
`total_capacity_gb`
The total capacity in GB
`allocated_capacity_gb`
The allocated capacity in GB
`reserved_percentage`
The reserved storage percentage

Để xem các properties của volume types đang chạy:

`$ cinder extra-specs-list`

**Ví dụ về sử dụng filter and weigher**

``` sh
[default]
scheduler_default_filters = DriverFilter
enabled_backends = lvm-1, lvm-2

[lvm-1]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_backend_name = sample_LVM01
filter_function = "volume.size < 10"

[lvm-2]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_backend_name = sample_LVM02
filter_function = "volume.size >= 10"
```

Ví dụ trên sẽ filter dựa vào dung lượng của volume được yêu cầu.


``` sh
[default]
scheduler_default_weighers = GoodnessWeigher
enabled_backends = lvm-1, lvm-2

[lvm-1]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_backend_name = sample_LVM01
goodness_function = "(volume.size < 5) ? 100 : 50"

[lvm-2]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_backend_name = sample_LVM02
goodness_function = "(volume.size >= 5) ? 100 : 25"
```

Nếu volume size nhỏ hơn 5, lvm1 được đánh 100 điểm, lvm2 được đánh 25 điểm. Nếu volume size lơn hơn 5, lvm2 được đánh 100, lvm1 50.

Ta có thể kết hợp cả hai

``` sh
[default]
scheduler_default_filters = DriverFilter
scheduler_default_weighers = GoodnessWeigher
enabled_backends = lvm-1, lvm-2

[lvm-1]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_backend_name = sample_LVM01
filter_function = "stats.total_capacity_gb < 500"
goodness_function = "(volume.size < 25) ? 100 : 50"

[lvm-2]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_backend_name = sample_LVM02
filter_function = "stats.total_capacity_gb >= 500"
goodness_function = "(volume.size >= 25) ? 100 : 75"
```

## 2. Hướng dẫn thực hành với vô hình multi backend

- Cấu hình multibackend với lvm và glusterfs. Tham khảo [tại đây](https://github.com/hocchudong/ghichep-OpenStack/blob/master/05-Cinder/docs/cinder-multiplebackdends-lvm-gfs-nfs.md)

- Ở đây mình đã cấu hình xong cinder multibackend là lvm và glusterfs.

``` sh
[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
iscsi_protocol = iscsi
iscsi_helper = tgtadm
volume_backend_name = LVM

[glusterfs]
volume_driver = cinder.volume.drivers.glusterfs.GlusterfsDriver
glusterfs_shares_config = /etc/cinder/glusterfs_shares
glusterfs_mount_point_base = $state_path/mnt_gluster
volume_backend_name = GlusterFS
```

Sau khi tạo ra 2 volume types là `lvm` và `glusterfs`, ta tiến hành add properties cho 2 volume types:

``` sh
cinder type-key lvm set volume_backend_name=LVM
cinder type-key glusterfs set volume_backend_name=GlusterFS
```

Xem thử extra_specs

<img src="https://i.imgur.com/MIZkf1o.png">

Tiến hành tạo volume và xem thử filter có thực hiện đúng không

``` sh
cinder create --display_name disk_glusterfs --volume-type glusterfs 1
cinder create --display_name disk_lvm --volume-type lvm 1
```

- Sau đó ta tiến hành thêm filter rule

Sửa file cấu hình

``` sh
[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
iscsi_protocol = iscsi
iscsi_helper = tgtadm
volume_backend_name=LVM
filter_function = "volume.size < 5"

[glusterfs]
volume_driver = cinder.volume.drivers.glusterfs.GlusterfsDriver
glusterfs_shares_config = /etc/cinder/glusterfs_shares
glusterfs_mount_point_base = $state_path/mnt_gluster
volume_backend_name = GlusterFS
filter_function = "volume.size >= 5"
```

Sau đó restart lại cinder-volume

`service cinder-volume restart`

Sửa trong file `/etc/cinder/cinder.conf` của node CTL

``` sh
[DEFAULT]
scheduler_default_filters = DriverFilter
```

Restart lại cinder-scheduler

`service cinder-scheduler restart`

- Tạo volume 2 gb

`cinder create --display_name disk_2gb 2`

- Dùng `cinder show` để xem host chứa volume

`cinder show disk_2gb`

<img src="https://i.imgur.com/53eJqlp.png">

- Tạo thêm volume 5 gb và show xem

<img src="https://i.imgur.com/ZNhOLVz.png">


Như vậy filter rule đã hoạt động đúng.

**Link tham khảo:**

https://docs.openstack.org/cinder/latest/admin/blockstorage-driver-filter-weighing.html
