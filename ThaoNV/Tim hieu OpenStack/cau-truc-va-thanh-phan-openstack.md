# Các thành phần và cấu trúc của OpenStack

OpenStack là một nền tảng điện toán đám mây mã nguồn mở được tạo thành bởi nhiều services khác nhau. Mỗi service sẽ đảm nhận một chức năng cụ thể và chúng có mối liên hệ mật thiết với nhau.

### Các projects thành phần

Bảng dưới đây sẽ mô tả rõ hơn về từng service cấu thành lên kiến trúc của OpenStack:

| Service          | Project name | Description                              |
| ---------------- | ------------ | ---------------------------------------- |
| Dashboard        | Horizon      | Cung cấp giao diện trên nền tảng web để người dùng tương tác với các dịch vụ khác của OpenStack ví dụ như tạo VM, gán địa chỉ IP, cấu hình kiểm soát truy cập... |
| Compute service  | Nova         | Quản lí các máy ảo trong môi trường OpenStack. Nó có trách nhiệm khởi tạo, lên lịch và gỡ bỏ các VM theo yêu cầu |
| Networking       | Neutron      | Cung cấp khả năng kết nối mạng cho các dịch vụ khác. Cung cấp API cho người dùng tạo ra network và quản lí chúng. Nó có kiến trúc linh hoạt hỗ trợ hầu hết các công nghệ về networking. |
| Object Storage   | Swift        | Lưu trữ và truy xuất các dữ liệu phi cấu trúc thông qua RESTful, HTTP based API. Nó có khả năng chịu lỗi cao nhờ cơ chế sao chép và mở rộng. Quy trình thực hiện của Swift không giống với file server. |
| Block Storage    | Cinder       | Cung cấp các storage để chạy máy ảo. Kiến trúc linh hoạt của nó cho phép người dùng khởi tạo và quản lí các thiết bị lưu trữ. |
| Identity service | Keystone     | Cung cấp dịch vụ xác thực và ủy quyền cho các dịch vụ khác. Cung cấp một danh mục các thiết bị đầu cuối cho tất cả các dịch vụ OpenStack. |
| Image Service    | Glance       | Lưu trữ và truy xuất các ổ đĩa của máy ảo. Compute sẽ sử dụng dịch vụ này trong suốt quá trình khởi tạo và chạy máy ảo |

Ngoài những dịch vụ chính kể trên, OpenStack còn có thêm một vài dịch vụ khác như Telemetry, Orchestration, Database và Data Processing service.

### Kiến trúc

Hình dưới đây mô tả về mối liên hệ giữa các sịch vụ trong OpenStack

<img src="http://i.imgur.com/7VqoRow.png">

Nếu nhìn sơ qua, chắc hẳn bạn sẽ thấy nó khá phức tạp. Hãy cùng tới với sơ đồ theo layer của Sean Dague:

<img src="http://i.imgur.com/2sSpZ2C.png">

Trong mô hình này, OpenStack có 4 layers:

- Layer 1 - Basic Compute Infrastructure
- Layer 2 - Extended Infrastructure
- Layer 3 - Optional Enhancements
- Layer 4 - Consumption Services

Và đây là kiến trúc logical của OpenStack phiên bản Ocata:

<img src="https://docs.openstack.org/admin-guide/_images/openstack-arch-kilo-logical-v1.png">

### Tổng quan về các services thành phần trong OpenStack

#### 1. Nova - Compute service

Được dùng để khởi tạo và quản lí hệ thống điện toán đám mây. Đây là thành phần chính trong hệ thống Infrastructure-as-a-Service (IaaS). Các modules chính của nó được xây dựng bằng Python.

OpenStack Compute giao tiếp với OpenStack Identity để xác thực, OpenStack Image để lấy ổ cứng cài đặt, OpenStack Dashboard để lấy giao diện người dùng và người quản trị. OpenStack Compute có thể mở rộng theo chiều ngang tùy theo từng phần cứng, nó cũng có thể downloaf images để tạo máy ảo.

OpenStack Compute hỗ trợ rất nhiều Hypervisor bao gồm KVM (libvirt/QEMU), ESXi from VMware, Hyper-V from Microsoft và XenServer. 

Tùy vào mức độ hỗ trợ và số hypervisor này được chia làm 3 nhóm:

- Nhóm A: libvirt (qemu/KVM on x86). Được hỗ trợ đầy đủ nhất, việc kiểm thử bao gồm unit test và functional testing.
- Nhóm B: Hyper-V, VMware, XenServer 6.2. Được hỗ trợ ở mức trung bình, việc kiểm thử bao gồm unit test và functional testing cung cấp bởi một hệ thống bên ngoài.
- Nhóm C: baremetal, docker , Xen via libvirt, LXC via libvirt. Đây là nhóm ít được hỗ trợ nhất. Nên cẩn thẩn khi sử dụng chúng.

Các thành phần cấu thành lên Nova service:

- Cloud Controller: đại diện cho trạng thái toàn cục và tương tác với các component khác
- API Server: có thể coi như các Web services cho cloud controller
- Compute Controller: cung cấp tài nguyên máy chủ tính toán
- Object Store: cung cấp dịch vụ lưu trữ
- Auth Manager: cung cấp dịch vụ xác thực và ủy quyền
- Volume Controller: cung cấp các khối lưu trữ bền vững và nhanh chóng cho các computer server
- Network controller: cung cấp mạng ảo cho phép các compute server tương tác với nhau và với public network
- Scheduler lựa chọn compute controller phù hợp nhất để host một instance (máy ảo)
- The queue : Đóng vai trò trung tâm truyền thông điệp giữa các daemons.  Thông thường được dùng với RabbitMQ, nó cũng có thể sử dụng bất cứ AMPQ message queue nào khác ví dụ như  Apache Qpid (used by Red Hat OpenStack) và ZeroMQ.
- SQL database: Lưu trữ trạng thái trong quá trình cloud khởi tạo và chạy, nó bao gồm:
  <ul>
  <li>Available instance types</li>
  <li>Instances in use</li>
  <li>Available networks</li>
  <li>Projects</li>
  </ul>

Theo lí thuyết thì OpenStack Compute hỗ trợ bất cứ database nào mà SQLAlchemy hỗ trợ. Thông thường người ta sử dụng SQLite3, MySQL, MariaDB, và PostgreSQL.

Trong OpenStack, các thành phần kể trên có những tên gọi khác nhau ví dụ như: nova-api, nova-scheduler, nova-conductor...

Dưới đây là mô hình mô tả mối quan hệ giữa các thành phần với nhau:

<img src="http://i.imgur.com/RT36Njd.png">

Ken Pepple đã diễn tả Nova bằng 3 câu ngắn gọn kèm theo mô hình:

- End users (DevOps, Developers and even other OpenStack components):  Sử dụng nova-api để giao tiếp với OpenStack Nova
- Các OpenStack Nova daemons trao đổi thông tin qua queue (chứa các hành động) và database (chứa các thông tin) để thực thi các yêu cầu của api
- OpenStack Glance về cơ bản là một phần hoàn toàn tách biệt, OpenStack Nova giao tiếp với nó thông qua Glance API.

<img src="http://i.imgur.com/40vgvU1.gif">

Trước đây OpenStack Nova có nova-networking, tuy nhiên sau này bị bỏ đi vì sự xuất hiện của neutron (sẽ nói thêm ở phần neutron). Mặc dù vậy người dùng vẫn có thể lựa chọn giữa hai loại này.

#### 2. Glance - Image service 

Glance cho phép người dùng tìm kiếm, đăng kí và di chuyển các disk image của máy ảo. Nó sung cấp giao diện web đơn giản (REST: Representational State Transfer) cho phép người dùng truy xuất metadata của image trong các VM. Glance làm viễ trực tiếp với Nova để hỗ trợ cho việc tạo máy ảo, nó cũng giao tiếp với Keystone để xác thực API.

<img src="http://i.imgur.com/2n3ZkDy.png">

OpenStack Image service là trung tâm của Infrastructure-as-a-Service (IaaS). Nó tiếp nhận các API requests cho ổ đĩa, server images hoặc metadata. Nó cũng hỗ trợ các storage lưu trữ khác nhau bao gồm OpenStack Object Storage.

Các thành phần chính của OpenStack Image service:

- glance-api : Chấp thuận các API calls cho việc tìm kiếm, vận chuyển và lưu trữ.
- glance-registry : Lưu, xử lí và truy vấn metadata về các images. Metadata bao gồm các thông tin về image như là kích cỡ và loại.
- database: Lưu trữ metadata, MySQL hoặc SQLite thường được sử dụng.
- Storage repository : Hỗ trợ nhiều loại kho lưu trữ thông thường  bao gồm: RADOS block devices, VMware datastore, HTTP và Swift.
- Metadata definition service: API cho nhà phân phối, quản trị và người dùng để tự định nghĩa metadata của riêng họ.

Danh sách các định dạng ổ đĩa và container được hỗ trợ bao gồm:

- Disk Format: Disk format của một image máy ảo là định dạng của disk image, bao gồm:
  <ul>
  <li>raw: là định dạng ảnh đĩa phi cấu trúc</li>
  <li>vhd: là định dạng ảnh đĩa chung sử dụng bởi các công nghệ VMware, Xen, Microsoft, VirtualBox, etc.</li>
  <li>vmdk: định dạng ảnh đĩa chung hỗ trợ bởi nhiều công nghệ ảo hóa khác nhau (điển hình là VMware)</li>
  <li>vdi: định dạng ảnh đĩa hỗ trợ bởi VirtualBox và QEMU emulator</li>
  <li>iso: định dạng cho việc lưu trữ dữ liệu của ổ đĩa quang</li>
  <li>qcow2: hỗ trợ bởi QEMU và có thể ở rộng động, hỗ trợ copy on write</li>
  <li>aki:  Amazon kernel image</li>
  <li>ari: Amazon ramdisk image</li>
  <li>ami: Amazon machine image</li>
  </ul>

- Container Format:
  <ul>
  <li>bare: định dạng này xác định rằng không có container hoặc metadata cho image</li>
  <li>ovf: định dạng OVF container</li>
  <li>aki: xác định Amazon kernel image lưu trữ trong Glance</li>
  <li>ami: Xác định Amazon ramdisk image lưu trữ trong Glance</li>
  <li>ova: xác định file OVA tar lưu trữ trong Glance</li>
  </ul>