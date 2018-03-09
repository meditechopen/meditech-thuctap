# Tìm hiểu tổng quan Image Service - Glance

## Mục lục

[1. Giới thiệu về OpenStack Image Service - Glance](#intro)

[2. Các thành phần của Glance](#component)

[3. Kiến trúc của Glance](#architecture)

[4. Các định dạng image của Glance](#image)

[5. Glance Status Flow](#flow)

[6. Các file cấu hình của glance](#config)

[7. Image and Instance](#instance)

--------

<a name ="intro"></a>
### 1. Giới thiệu về OpenStack Image Service - Glance

- OpenStack Image service là dịch vụ trung trâm trong kiến trúc Infrastructure-as-a-Service (IaaS). Nó chấp nhận các API requests cho disk hoặc server images và metadata từ phía người dùng hoặc từ Compute service. Nó cũng hỗ trợ lưu trữ disk hoặc server images trên rất nhiều loại repository, bao gồm cả OpenStack Object Storage - Swift.

- Trong Glance, các images được lưu trữ giống như các template. Các Template này sử dụng để vận hành máy ảo mới. Glance là giải pháp để quản lý các ảnh đĩa trên cloud. Nó cũng có thể lấy bản snapshots từ các máy ảo đang chạy để thực hiện dự phòng cho các VM và trạng thái các máy ảo đó.

<a name ="component"></a>
### 2. Các thành phần của Glance

Glance có các thành phần sau:

- glance-api : tiếp nhận lời gọi API để tìm kiếm, thu thập và lưu trữ image
- glance-registry: thực hiện tác vụ lưu trữ, xử lý và thu thập metadata của images. Metadata bao gồm các thông tin như kích thước và loại image.
- database: cơ sở dữ liệu lưu trữ metadata của image

<img src="http://i.imgur.com/qiYM1n9.png">

- Storage repository for image files: Có rất nhiều các loại repository được hỗ trợ để lưu image. Một vài backend phổ biến:
  - File system: Glance lưu trữ images của các máy ảo trong hệ thống tệp tin thông thường theo mặc định, hỗ trợ đọc ghi các image files dễ dàng vào hệ thống tệp tin.
  - Object Storage: Là hệ thống lưu trữ do OpenStack Swift cung cấp - dịch vụ lưu trữ có tính sẵn sàng cao , lưu trữ các image dưới dạng các object.
  - BlockStorage : Hệ thống lưu trữ có tính sẵn sàng cao do OpenStack Cinder cung cấp, lưu trữ các image dưới dạng khối
  - VMWare
  - HTTP : Glance có thể đọc các images của các máy ảo sẵn sàng trên Internet thông qua HTTP. Hệ thống lưu trữ này chỉ cho phép đọc.
  - RADOS Block Device(RBD): Lưu trữ các images trong cụm lưu trữ Ceph sử dụng giao diện RBD của Ceph

<a name ="architecture"></a>
### 3. Kiến trúc của Glance

- Glance có kiến trúc client-server cung cấp REST API cho user để thông qua đó gửi yêu cầu tới server.
- Glance Domain Controller quản lí các hoạt động bên trong. Các hoạt động được chia ra thành các tầng khác nhau. Mỗi tầng thực hiện một chức năng riêng biệt.
- Glane store là lớp giao tiếp giữa glane và storage back end ở ngoài glane hoặc local filesystem và nó cung cấp giao diện thống nhất để truy cập. Glance sử dụng SQL central Database để truy cập cho tất cả các thành phần trong hệ thống.
- Kiến trúc của glance bao gồm một số thành phần sau:
  - Client: Bất kỳ ứng dụng nào sử dụng Glance server đều được gọi là client.
  - REST API: dùng để gọi đến các chức năng của Glance thông qua REST.
  - Database Abstraction Layer (DAL): một API để thống nhất giao tiếp giữa Glance và database.
  - Glance Domain Controller: là middleware thực hiện các chức năng chính của Glance là: authorization, notifications, policies, database connections.
  - Glance Store: tổ chức tương tác Glance và các data store.
  - Registry Layer: Layer không bắt buộc để tổ chức giao tiếp mang tính bảo mật giữa domain và DAL nhờ việc sử dụng một dịch vụ riêng biệt.

  <img src="http://i.imgur.com/vQRgVGS.png">

<a name ="image"></a>
### 4. Các định dạng image của Glance

Các định dạng trên đĩa (Disk Formats) của một image máy ảo là định dạng của hình ảnh đĩa cơ bản. Sau đây là các định dạng đĩa được hỗ trợ bởi OpenStack Glance.

**Disk Formats**

| Disk format | Notes |
|-------------|-------|
| Raw | Định dạng đĩa phi cấu trúc |
| VHD | Định dạng chung hỗ trợ bởi nhiều công nghệ ảo hóa trong OpenStack, ngoại trừ KVM |
| VMDK | Định dạng hỗ trợ bởi VMWare |
| qcow2 | Định dạng đĩa QEMU, định dạng mặc định hỗ trợ bởi KVM vfa QEMU, hỗ trợ các chức năng nâng cao |
| VDI | Định dạng ảnh đĩa ảo hỗ trợ bởi VirtualBox |
| ISO | 	Định dạng lưu trữ cho đĩa quang |
| AMI, ARI, AKI | Định dạng ảnh Amazon machine, ramdisk, kernel |

**Container Formats**

Container Formats mô tả định dạng files và chứa các thông tin metadata về máy ảo thực sự. Các định dạng container hỗ trợ bởi Glance

| Container format | Notes |
|------------------|-------|
| bare | Định dạng xác định không có container hoặc metadata đóng gói cho image |
| ovf | Định dạng container OVF |
| aki | Xác định lưu trữ trong Glance là Amazon kernel image |
| ari | Xác định lưu trữ trong Glance là Amazon ramdisk image |
| ami | Xác định lưu trữ trong Glance là Amazon machine image |
| ova | Xác định lưu trữ trong Glance là file lưu trữ OVA |
| docker | Xác định lưu trữ trong Glance và file lưu trữ Docker |

<a name ="flow"></a>
### 5. Glance Status Flow

Glance status flow cho biết trạng thái của image trong quá trình tải lên. Khi tạo một image, bước đầu tiên là queuing, image được đưa vào hàng đợi và được nhận diện trong một khoảng thời gian ngắn, được bảo vệ và sẵn sàng để tải lên. Sau khi queuing image chuyển sang trạng thái Saving nghĩa là quá trình tải lên chưa hoàn thành. Một khi image được tải lên hoàn toàn, trạng thái image chuyển sang Active. Khi quá trình tải lên thất bại nó sẽ chuyển sang trạng thái bị hủy hoặc bị xóa. Ta có thể deactive và reactive các image đã upload thành công bằng cách sử dụng command.
Glance status flow được mô tả theo hình sau:

<img src="http://i.imgur.com/ZNddPJV.jpg">

Các trạng thái của image:

- **queued** : Định danh của image được bảo vệ trong Glance registry. Không có dữ liệu nào của image được tải lên Glance và kích thước của image không được thiết lập về zero khi khởi tạo.
- **saving** : Biểu thị rằng dữ liệu của image đang được upload lên glance. Khi một image đăng ký với một call đến POST /image và có một x-image-meta-location header, image đó sẽ không bao giờ được trong tình trạng saving (dữ liệu Image đã có sẵn ở vị trí khác).
- **active** : Biểu thị một image đó là hoàn toàn có sẵn trong Glane. Điều này xảy ra khi các dữ liệu image được tải lên.
- **deactivated** : Trạng thái biểu thị việc không được phép truy cập vào dữ liệu của image với tài khoản không phải admin. Khi image ở trạng thái này, ta không thể tải xuống cũng như export hay clone image.
- **killed** : Trạng thái biểu thị rằng có vấn đề xảy ra trong quá trình tải dữ liệu của image lên và image đó không thể đọc được
- **deleted** : Trạng thái này biểu thị việc Glance vẫn giữ thông tin về image nhưng nó không còn sẵn sàng để sử dụng nữa. Image ở trạng thái này sẽ tự động bị gỡ bỏ vào ngày hôm sau.

<a name ="config"></a>
### 6. Các file cấu hình của glance

- **glance-api.conf** : File cấu hình cho API của image service.
- **glance-registry.conf** : File cấu hình cho glance image registry - nơi lưu trữ metadata về các images.
- **glance-scrubber.conf** : Được dùng để dọn dẹp các image đã được xóa
- **policy.json** : Bổ sung truy cập kiểm soát áp dụng cho các image service. Trong này, chúng tra có thể xác định vai trò, chính sách, làm tăng tính bảo mật trong Glane OpenStack.

<a name ="instance"></a>
### 7. Image and Instance

- Như đã đề cập, disk images được lưu trữ giống như các template. Image service kiểm soát việc lưu trữ và quản lý của các images. Instance là một máy ảo riêng biệt chạy trên compute node, compute node quản lý các instances. User có thể vận hành bao nhiêu máy ảo tùy ý với cùng một image. Mỗi máy ảo đã được vận hành được tạo nên bởi một bản sao của image gốc, bởi vậy bất kỳ chỉnh sửa nào trên instance cũng không ảnh hưởng tới image gốc. Ta có thể tạo bản snapshot của các máy ảo đang chạy nhằm mục đích dự phòng hoặc vận hành một máy ảo khác.

- Khi ta vận hành một máy ảo, ta cần phải chỉ ra flavor của máy ảo đó. Flavor đại diện cho tài nguyên ảo hóa cung cấp cho máy ảo, định nghĩa số lượng CPU ảo, tổng dung lượng RAM cấp cho máy ảo và kích thước ổ đĩa không bền vững cấp cho máy ảo. OpenStack cung cấp một số flavors đã định nghĩa sẵn, ta có thể tạo và chỉnh sửa các flavors theo ý mình.
Sơ đồ dưới đây chỉ ra trạng thái của hệ thống trước khi vận hành máy ảo. Trong đó image store chỉ số lượng các images đã được định nghĩa trước, compute node chứa các vcpu có sẵn, tài nguyên bộ nhớ và tài nguyên đĩa cục bộ, cinder-volume chứa số lượng volumes đã định nghĩa trước đó.

<img src="http://i.imgur.com/kEnNq97.jpg">

Trước khi vận hành 1 máy ảo, ta phải chọn một image, flavor và các thuộc tính tùy chọn. Lựa chọn flavor nào cung cấp root volume, có nhãn là vda và một ổ lưu trữ tùy chọn được đánh nhãn vdb (ephemeral - không bền vững, và cinder-volumen được map với ổ đĩa ảo thứ ba, có thể gọi tên là vdc

<img src="http://i.imgur.com/MqsSLF9.jpg">

Theo mô tả trên hình, image gốc được copy vào ổ lưu trữ cục bộ từ image store. Ổ vda là ổ đầu tiên mà máy ảo truy cập. Ổ vdb là ổ tạm thời (không bền vững - ephemeral) và rỗng, được tạo nên cùng với máy ảo, nó sẽ bị xóa khi ngắt hoạt động của máy ảo. Ổ vdc kết nối với cinder-volume sử dụng giao thức iSCSI. Sau khi compute node dự phòng vCPU và tài nguyên bộ nhớ, máy ảo sẽ boot từ root volume là vda. Máy ảo chạy và thay đổi dữ liệu trên các ổ đĩa. Nếu volume store được đặt trên hệ thống mạng khác, tùy chọn "my_block_storage_ip" phải được dặc tả chính xác trong tệp cấu hình storage node chỉ ra lưu lượng image đi tới compute node.
Khi máy ảo bị xóa, ephemeral storage (khối lưu trữ không bền vững) bị xóa; tài nguyên vCPU và bộ nhớ được giải phóng. Image không bị thay đổi sau tiến trình này.

**Link tham khảo:**

http://www.sparkmycloud.com/blog/openstack-glance/
