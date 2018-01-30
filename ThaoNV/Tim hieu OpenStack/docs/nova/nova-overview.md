# Tìm hiểu Compute Service - Nova

## Mục lục

[1. Giới thiệu về Compute Service - Nova](#intro)

[2. Các thành phần của Nova](#component)

[3. Kiến trúc của Nova](#architecture)

--------

<a name="intro"></a>
## 1. Giới thiệu về Compute Service - Nova

- Là service chịu trách nhiệm chứa và quản lí các hệ thống cloud computing. OpenStack Compute chính là phần chính quan trọng nhất trong kiến trúc hệ thống  Infrastructure-as-a-Service (IaaS). Phần lớn các modules của Nova được viết bằng Python.

- OpenStack Compute giao tiếp với OpenStack Identity để xác thực, OpenStack Image để lấy images và OpenStack Dashboard để lấy giao diện cho người dùng và người quản trị.

- Nova cho phép bạn điều khiển các máy ảo và networks, bạn cũng có thể quản lí các truy cập tới cloud từ users và projects. OpenStack Compute không chứa các phần mềm ảo hóa. Thay vào đó, nó sẽ định nghĩa các drivers để tương tác với các kĩ thuật ảo hóa khác chạy trên hệ điều hành của bạn và cung cấp các chức năn thông qua một web-based API.

<a name="component"></a>
## 2. Các thành phần của Nova

- **nova-api** : Là service tiếp nhận và phản hồi các compute API calls từ user. Service hỗ trợ OpenStack Compute API, Amazon EC2 API và Admin API đặc biệt được dùng để user thực hiện các thao tác quản trị. Nó cũng có một loạt các policies và thực hiện hầu hết các orchestration activities ví dụ như chạy máy ảo.

- **nova-api-metadata** : Là service tiếp nhận các metadata request từ máy ảo. Service này thường được dùng khi chạy multi-host kết hợp với nova-network.

- **nova-compute** : Là service chịu trách nhiệm tạo và hủy các máy ảo qua hypervisors APIs. Ví dụ:
  - XenAPI for XenServer/XCP
  - libvirt for KVM or QEMU
  - VMwareAPI for VMware

Quá trình xử lí khá phức tạp, về cơ bản, daemon tiếp nhận các actions từ queue và thực hiện một loạt các câu lệnh hệ thống như chạy máy ảo kvm và upsate trạng thái trong database.

- **nova-placement-api** : Lần đầu xuất hiện tại bản Newton, placement api được dùng để theo dõi thống kê và muức độ sử dụng của mỗi một resource provider. Provider ở đây có thể là compute node, shared storage pool hoặc  IP allocation pool. Ví dụ, một máy ảo có thể được khởi tạo và lấy RAM, CPU từ compute node, lấy disk từ storage bên ngoài và lấy địa chỉ IP từ pool resource bên ngoài.

- **nova-scheduler** : Service này sẽ lấy các yêu cầu máy ảo đặt vào queue và xác định xem chúng được chạy trên compute server host nào.

- **nova-conductor** : Là module chịu trách nhiệm về các tương tác giữa `nova-compute` và database. Nó sẽ loại bỏ tất cả các kết nối trực tiếp từ `nova-compute` tới database.

- **nova-consoleauth** : Xác thực token cho user mà console proxies cung cấp. Dịch vụ này buộc phải chạy cùng với console proxies. Bạn có thể chạy proxies trên 1 nova-consoleauth service hoặc ở trong 1 cluster configuration.

- **nova-novncproxy** : Cung cấp proxy cho việc truy cập các máy ảo đang chạy thông qua VNC connection. Nó hỗ trợ các trình duyệt based novnc clients.

- **nova-spicehtml5proxy** : Cung cấp proxy để truy cập các máy ảo đang chạy thông qua SPICE connection. Nó hỗ trợ các trình duyệt based HTML5 client.

- **nova-xvpvncproxy** : Cung cấp proxy cho việc truy cập các máy ảo đang chạy thông qua VNC connection. Nó hỗ trợ OpenStack-specific Java client.

- **The queue**: Trung tâm giao tiếp giữa các daemons. Thường dùng RabbitMQ hoặc các AMQP message queue khác như ZeroMQ.

- **SQL database** : Dùng để lưu các trạng thái của hạ tâng caloud bảo gồm:
  - Các loại máy ảo có thể chạy
  - Các máy ảo đang được dùng
  - Các network khả dụng
  - projects

Theo lý thuyết, Nova hỗ trợ tất cả các database mà SQLAlchemy support ví dụ như  SQLite3, MySQL, MariaDB, và PostgreSQL.

<a name="architecture"></a>
## 3. Kiến trúc của Nova

<img src="http://i.imgur.com/SWgKmDp.png">

- DB: sql database để lưu trữ dữ liệu.
- API: Thành phần để nhận HTTP request , chuyển đổi các lệnh và giao tiếp với thành các thành phần khác thông qua oslo.messaging queuses hoặc HTTP.
- Scheduler: Quyết định ,máy chủ được chọn để chạy máy ảo.
- Network: quản lý ip forwarding, bridges, và vlan.
- Compute: Quản lý giao tiếp với hypervisor và vitual machines.
- Conductor: Xử lý các yêu cầu mà cần sự phối hợp (build/resize), hoạt động như một proxy cho cơ sở dữ liệu, hoặc đối tượng chuyển đổi.
