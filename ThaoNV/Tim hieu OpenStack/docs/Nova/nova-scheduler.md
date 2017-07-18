# Tìm hiểu cơ chế filtering và weighting của nova-scheduler

## Mục lục

[1. Giới thiệu về nova-scheduler](#1)

[2. Cơ chế filtering](#2)

[3. Cơ chế weighting](#3)

----------

<a name ="1"></a>
## 1. Giới thiệu về nova-scheduler

Là một thành phần trong nova. Nó sẽ nhận trực tiếp lệnh từ nova-api để tìm kiếm node phù hợp để tạo máy ảo và nó cũng tim kiếm node phù hợp khi người dùng muốn migrate máy ảo. Để làm được việc này, nova-scheduler sử dụng 2 cơ chế đó là filtering và weighting. nova-scheduler giao tiếp với các thành phần khác thông qua queue và central database repo. Tất cả các compute node sẽ public trạng thái của nó bao gồm tài nguyên hiện có và dung lượng phần cứng khả dụng cho nova-scheduler thông qua queue. nova-scheduler sau đó sẽ dựa vào những dữ liệu này để đưa ra quyết định khi có request.

Khi nhận được yêu cầu từ người dùng, nova-scheduler sẽ filter những host phù hợp để launch máy ảo, những host không phù hợp sẽ bị loại. Sau đó nó dùng tiếp weighting để xác định xem đâu là host phù hợp nhất. Người dùng có thể thay đổi các thông số của 2 cơ chế này thông qua file `/etc/nova/nova.conf`.

Compute được cấu hình với những thông số scheduler mặc định sau:

``` sh
scheduler_driver_task_period = 60
scheduler_driver = nova.scheduler.filter_scheduler.FilterScheduler
scheduler_available_filters = nova.scheduler.filters.all_filters
scheduler_default_filters = RetryFilter, AvailabilityZoneFilter, RamFilter, DiskFilter, ComputeFilter, ComputeCapabilitiesFilter, ImagePropertiesFilter, ServerGroupAntiAffinityFilter, ServerGroupAffinityFilter
```

Mặc định thì `scheduler_driver` được cấu hình như là `filter scheduler`, scheduler này sẽ xem xét các host có đầy ddue các tiêu chí sau:

- Chưa từng tham gia vào scheduling (RetryFilter)
- Nằm trong vùng requested availability zone (requested availability zone)
- Có RAM phù hợp (RamFilter).
- Có dung lượng ổ cứng phù hợp cho root và ephemeral storage (DiskFilter).
- Có thể thực thi yêu cầu (ComputeFilter)
- Đáp ứng các yêu cầu ngoại lệ với các instance type (ComputeCapabilitiesFilter)
- Đáp ứng mọi yêu cầu về architecture, hypervisor type, hoặc virtual machine mode properties được khai báo trong instance’s image properties (ImagePropertiesFilter).
- Ở host khác với các instance khác trong group (nếu có) (ServerGroupAntiAffinityFilter).
- Ở trong danh sách các group hosts (nếu có) (ServerGroupAffinityFilter).

Scheduler sẽ cache lại danh sách available hosts, dùng `scheduler_driver_task_period` để quy định thời gian danh sách được update.

<a name ="2"></a>
## 2. Cơ chế filtering

<img src="http://i.imgur.com/DhPt1Xo.png">

Quá trình filter được lặp lại trên các compute nodes. Danh sách các hosts được chọn sẽ được sắp xếp sau bởi weighers. Scheduler sau đó sẽ chọn host theo số lượng các instances request. Nếu scheduler không thể chọn bất cứ host nào thì có nghĩa instance đó không thể được scheduled. Filter Scheduler có rất nhiều cơ chế filtering và weighting. Bạn cũng có thể tự chọn cho mình những giải thuật phù hợp.

- AllHostsFilter : Không filter, được tạo máy ảo trên bất cứ host nào available.
- ImagePropertiesFilter : filter host dựa vào properties được định nghĩa trên instance’s image. Nó sẽ chọn các host có thể hỗ trợ các thông số cụ thể trên image được sử dụng bởi instance. ImagePropertiesFilter dựa vào kiến trúc, hypervisor type và virtual machine mode được định nghĩa trong instance. Ví dụ, máy ảo yêu cầu host hỗ trợ kiến trúc ARM thì ImagePropertiesFilter sẽ chỉ chọn những host đáp ứng yêu cầu này.
- AvailabilityZoneFilter : filter bằng availability zone. Các host phù hợp với availability zone được ghi trên instance properties sẽ được chọn. Nó sẽ xem availability zone của compute node và availability zone từ phần request.
- ComputeCapabilitiesFilter : Kiểm tra xem host compute service có đủ khả năng đáp ứng các yêu cầu ngoài lề (extra_specs) với instance type không. Nó sẽ chọn các host có thể tạo được instance type cụ thể. extra_specs chứa key/value pairs ví dụ như `free_ram_mb (compared with a number, values like ">= 4096")`
- ComputeFilter : Chọn tất cả các hosts đang được kích hoạt.
- CoreFilter : filter dựa vào mức độ sử dụng CPU core. Nó sẽ chọn host có đủ số lượng CPU core.
- AggregateCoreFilter : filter bằng số lượng CPU core với giá trị `cpu_allocation_ratio` .
- IsolatedHostsFilter : filter dựa vào image_isolated, host_isolated và restrict_isolated_hosts_to_isolated_images flags.
- JsonFilter : Cho phép sử dụng JSON-based grammar để lựa chọn host.
- RamFilter : filter bằng RAM, các hosts có đủ dung lượng RAM sẽ được chọn.
- AggregateRamFilter : filter bằng số lượng RAM với giá trị `ram_allocation_ratio`. `ram_allocation_ratio` ở đây là tỉ lệ RAM ảo với RAM vật lý (mặc định là 1.5)
- DiskFilter : filter bằng dung lượng disk. các hosts có đủ dung lượng disk sẽ được chọn.
- AggregateDiskFilter : filter bằng dung lượng disk với giá trị `disk_allocation_ratio`.
- NumInstancesFilter : filter dựa vào số lượng máy ảo đang chạy trên node compute đó. node nào có quá nhiều máy ảo đang chạy sẽ bị loại. Nếu chỉ số `max_instances_per_host` đươc thiết lập. Những node có số lượng máy ảo đạt ngưỡng `max_instances_per_host` sẽ bị ignored.
- AggregateNumInstancesFilter : filter dựa theo chỉ số `max_instances_per_host`.
- IoOpsFilter : filter dựa theo số lượng  I/O operations.
- AggregateIoOpsFilter:  filter dựa theo chỉ số `max_io_ops_per_host`.
- SimpleCIDRAffinityFilter : Cho phép các instance trên các node khác nhau có cùng IP block.
- DifferentHostFilter : Cho phép các instances đặt trên các node khác nhau.
- SameHostFilter : Đặt instance trên cùng 1 node.
- RetryFilter : chỉ chọn các host chưa từng được schedule.

<a name ="3"></a>
## 3. Cơ chế weighting

<img src="http://i.imgur.com/U7P5m2V.png">

Sau khi filter các node có thể tạo máy ảo, scheduler sẽ dùng `weights` để tìm kiếm host phù hợp nhất. Weights được tính toán trên từng host khi mà instance chuẩn bị được schedule, weight được tính toán bằng cách giám sát việc sử dụng tài nguyên của hệ thống. Chúng ta có thể cầu hình để cho các instance được tạo trên các host khác nhau hoặc tạo trên cùng 1 node cho tới khi tài nguyên của node đó cạn kiệt thì mới chuyển sang node tiếp theo.

Nova scheduler tính toán mỗi weight với 1 configurable multiplier rồi sau đó cộng tất cả lại. Host có weight lớn nhất sẽ được ưu tiên. Cơ chế weights cũng cho phép bạn tạo 1 subnet gồm các node phù hợp rồi schedule sẽ lựa chọn ngẫu nhiên.

<img src="http://i.imgur.com/bCbiLIL.png">

Tóm lại, trong số các input của nova-scheduler có 3 thứ quan trọng nhất đó là cấu hình trong file `nova.conf`, service capability của mỗi host và request specifications. Cấu hình trong file conf sẽ quyết định cấu trúc của các class, service capability giống như base intelligent data còn request spec chính là service target.
