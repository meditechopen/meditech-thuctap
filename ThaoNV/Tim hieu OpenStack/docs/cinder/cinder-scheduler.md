# Cơ chế filter và weight của cinder-scheduler

## Mục lục

[1. Giới thiệu tổng quan về cinder-scheduler](#intro)

[2. Cinder Scheduler Filters](#filter)

[3. Cinder Scheduler Weights](#weight)

[4. Quản lý Block Storage scheduling](#manage)

-------------

<a name="intro"></a>
## 1. Giới thiệu tổng quan về cinder-scheduler

Giống với `nova-scheduler`, cinder cũng có một daemon chịu trách nhiệm cho việc quyết định xem sẽ tạo cinder volume ở đâu khi mô hình có hơn một backend storage. Mặc định nếu người dùng không chỉ rõ host để tạo máy ảo thì cinder-scheduler sẽ thực hiện filter và weight theo những opions sau:

``` sh
# Which filter class names to use for filtering hosts when not specified in the
# request. (list value)
#scheduler_default_filters = AvailabilityZoneFilter,CapacityFilter,CapabilitiesFilter

# Which weigher class names to use for weighing hosts. (list value)
#scheduler_default_weighers = CapacityWeigher
```

Bạn sẽ buộc phải kích hoạt tùy chọn `filter_scheduler` để sử dụng multiple-storage back ends.

<a name="filter"></a>
## 2. Cinder Scheduler Filters

- AvailabilityZoneFilter : Filter bằng availability zone
- CapabilitiesFilter : Filter theo tài nguyên (máy ảo và volume)
- CapacityFilter : Filter dựa vào công suất sử dụng của volume backend
- DifferentBackendFilter  : Lên kế hoạch đặt các volume ở các backend khác nhau khi có 1 danh sách các volume
- DriverFilter : Dựa vào ‘filter function’ và metrics.
- InstanceLocalityFilter : lên kế hoạch cho các volume trên cùng 1 host. Để có thể dùng filter này thì Extended Server Attributes cần được bật bởi nova và user sử dụng phải được khai báo xác thực trên cả nova và cinder.
- JsonFilter : Dựa vào JSON-based grammar để chọn lựa backends
- RetryFilter : Filter những node chưa từng được schedule
- SameBackendFilter : Lên kế hoạch đặt các volume có cùng backend như những volume khác.

<a name="weight"></a>
## 3. Cinder Scheduler Weights

- AllocatedCapacityWeigher : Allocated Capacity Weigher sẽ tính trọng số của host bằng công suất được phân bổ. Nó sẽ đặt volume vào host được khai báo chiếm ít tài nguyên nhất.
- CapacityWeigher : Trạng thái công suất thực tế chưa được sử dụng.
- ChanceWeigher : Tính trọng số random, dùng để tạo các volume khi các host gần giống nhau
- GoodnessWeigher : Gán trọng số dựa vào goodness function.

Goodness rating:

``` sh
0 -- host is a poor choice
.
.
50 -- host is a good choice
.
.
100 -- host is a perfect choice
```

- VolumeNumberWeigher : Tính trọng số theo số lượng volume đang có.

<a name="manage"></a>
## 4. Quản lý Block Storage scheduling

Đối với admin, ta có thể quản lí việc volume sẽ được tạo theo backend nào. Bạn có thể dùng affinity hoặc anti-affinity giữa hai volumes. Affinity có nghĩa rằng chúng được đặt cùng 1 backend và anti-affinity có nghĩa rằng chúng được lưu trên các backend khác nhau.

Một số ví dụ:

1. Tạo volume cùng backend với Volume_A

`openstack volume create --hint same_host=Volume_A-UUID --size SIZE VOLUME_NAME`

2. Tạo volume khác backend với Volume_A

`openstack volume create --hint different_host=Volume_A-UUID --size SIZE VOLUME_NAME`

3. Tạo volume cùng backend với Volume_A và Volume_B

`openstack volume create --hint same_host=Volume_A-UUID --hint same_host=Volume_B-UUID --size SIZE VOLUME_NAME`

hoặc

`openstack volume create --hint same_host="[Volume_A-UUID, Volume_B-UUID]" --size SIZE VOLUME_NAME`

4. Tạo volume khác backend với Volume_A và Volume_B

`openstack volume create --hint different_host=Volume_A-UUID --hint different_host=Volume_B-UUID --size SIZE VOLUME_NAME`

hoặc

`openstack volume create --hint different_host="[Volume_A-UUID, Volume_B-UUID]" --size SIZE VOLUME_NAME`


**Link tham khảo:**

https://docs.openstack.org/cinder/latest/scheduler-weights.html

https://docs.openstack.org/cinder/latest/scheduler-filters.html

https://docs.openstack.org/cinder/latest/cli/cli-cinder-scheduling.html
