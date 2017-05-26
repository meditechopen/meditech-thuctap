# Hướng dẫn sử dụng Dashboard OpenStack

### Đăng nhập vào dashboard

Dashboard thường được cài đặt trên node controller. 

Để đăng nhập vào dashboard, nếu bạn là client, bạn cần phải biết hostname hoặc public IP và username/password. Tiếp theo, hãy sử dụng trình duyệt hỗ trợ JavaScript và cookies. Lưu ý để có thể truy cập vào console của máy ảo, trình duyệt của bạn phải hỗ trợ  HTML5 Canvas và HTML5 WebSockets. Xem thê, về những trình duyệt được hỗ trợ [tại đây](https://github.com/novnc/noVNC/wiki/Browser-support).
Sau khi truy cập vào giao diện login, bạn cần điền username và password để có thể đăng nhập.
Góc trên cùng bên phải sẽ hiển thị username của bạn. Bạn cũng có thể truy cập vào Settings hoặc signout khỏi dashboard qua đây.

Phần hiển thị chính của dashboard sẽ phụ thuộc vào quyền truy cập của user đăng nhập vào hệ thống.

- Nếu bạn đăng nhập với tư cách là user, dashboard sẽ hiển thị `Project tab` và `Identity tab`
- Nếu bạn đăng nhập với tư cách admin, dashboard sẽ hiển thị `Project tab`, `Identity tab` và `Admin tab`.

Lưu ý một số tab ví dụ như  Orchestration và Firewalls sẽ chỉ hiển thị nếu nó đã được cấu hình.

### OpenStack dashboard — Project tab

Projects là trung tâm tổ chức (organizational units) của cloud, nó còn được gọi là tenants hoặc accounts. Mỗi user là một thành viên của một hoặc nhiều projects . Với project, user có thể tạo và quản lí các máy ảo.

Ở tab projects, bạn có thể xem và quản lí tài nguyên trong một projects đã chọn bao gồm các máy ảo và file image. 

<img src="http://i.imgur.com/Sn7wpOZ.png">

Từ project tab, bạn có thể truy cập tới các thành phần sau:

**Compute tab:**

- Overview: Xem thống kê của projects
- Instances: Xem, tạo máy ảo, tạo snapshot hoặc kết nối đến chúng thông qua VNC
- Volumes: Bạn có thể thực hiện những task dưới đây
  <ul>
  <li>Volumes: Xem, tạo, sửa và xóa volumes</li>
  <li>Volume Snapshots: Xem, tạo, sửa, xóa các volume snapshot</li>
  </ul>

- Images: Xem những image mà snapshot máy ảo được tạo bởi user. Tạo, sửa và xóa images. Launch máy ảo từ image hoặc snapshot.
- Access & Security: Bạn có thể thực hiện những task dưới đây
- Security Groups: Xem, tạo, sửa và xóa các security groups và security group rules
- KeyPairs: Xem, tạo, sửa, nhập và xóa keypairs
- Floating IPs: Gán địa chỉ IP hoặc gỡ nó ra khỏi projects.
- Share Networks: Xem, quản lí và xóa các share networks
- Security Services: Xem, quản lí và xóa các security services

**Network tab:**

- Network Topology: Xem mô hình mạng
- Networks: Tạo và quản lí  public và private networks.
- Routers: Tạo và quản lí router
- Load Balancers: Tạo và quản lí load balancers
- Pools: Thêm và quản lí pools
- Members: Thêm và quản lí members
- Monitors: Thêm và quản lí monitors
- Firewalls: Tạo và quản lí firewalls
- Firewalls: Tạo và quản lí firewalls
- Firewall Policies: Thêm và quản lí firewall policies
- Firewall Rules: Thêm và quản lí firewall rules.

**Orchestration tab**

- Stacks: Sử dụng  REST API để sắp xếp vị trí của các ứng dụng cloud
- Resource Types: Hiển thị danh sách của tất cả các nguồn tài nguyên hỗ trợ cho HOT templates.

**Object Store tab**

- Containers:  tạo và quản lí các containers và objects.

### OpenStack dashboard — Admin tab

Người quản trị có thể dùng Admin tab để xem mức độ sử dụng cũng như quản lí các máy ảo, volumes, flavors, images, networks...

<img src="http://i.imgur.com/8wbYsyX.png">

Từ Admin tab, bạn có thể truy cập và thực hiện các tác vụ sau:

**System tab**

- Overview: Xem thống kê cơ bản
- Resource Usage:
- Usage Report: Xem thống kê mức độ sử dụng
- Stats: Số liệu thống kê của tất cả tài nguyên

- Hypervisors: Tóm tắt về hypervisor
- Host Aggregates: Xem, tạo và chỉnh sửa host aggregates. Xem danh sách  availability zones. (host aggregates có thể được coi là cơ chế cho việc phân vùng dành cho các availability zones)
- Instances: Xem, tạm dừng, migrate, reboot và xóa máy ảo. Đồng thời bạn cũng có thể xem log hoặc kết nối tới console thông qua VNC.
- Volumes: 
- Volumes: Xem, tạo, quản lí và xóa volumes
- Volume Types: Xem, tạo, quản lí và xóa volume types.
- Volume Snapshots: Xem, quản lí và xóa volume snapshots

- Flavors: Xem, tạo, sửa, xem thêm thông tin và xóa flavors.  flavor chính là kích thước của máy ảo.
- Images: Xem, tạo, sửa thông tin và xóa images
- Networks: Xem, tạo, sửa thông tin và xóa networks
- Routers:  Xem, tạo, sửa thông tin và xóa routers
- Defaults: Xem các giá trị quotas mặc định.  Quotas cho biết các kích thước tối đa và số lượng tài nguyên.
- Metadata Definitions: Nhập namespace và xem các thông tin metadata.
- System Information:
 - Services: Danh sách các services
 - Compute Services: Danh sách tất cả các compute services
 - Block Storage Services: Danh sách các Block Storage services.
 - Network Agents: thông tin về các network agents.
 - Orchestration Services: Danh sách các Orchestration services.

**OpenStack dashboard — Identity tab**

<img src="http://i.imgur.com/XCVoeHl.png">

- Projects: Xem, tạo, gán user, gỡ bỏ user và xóa projects
- Users: Xem, tạo, kích hoạt, vô hiệu hóa và xóa users.

**OpenStack dashboard — Settings tab**

<img src="http://i.imgur.com/FyYz2U0.png">

Click vào `Settings` ở góc trên cùng bên phải, phần drop down menu của user. Tại đây bạn có thể:

- User Settings: Xem và quản lí cài đặt dashboard
- Change Password: Thay đổi password cho user

**Upload and manage images**

Images của máy ảo là file chứa ổ cứng ảo có thể dùng để boot hệ điều hành lên và sử dụng.  Tùy thuộc vào quyền hạn mà bạn có thể thực hiện những tác vụ khác nhau.

#### Upload image

Để upload image, thực hiện các bước sau:

1. Đăng nhập vào dashboard
2. Chọn project
3. Ở project tab, chọn `Compute tab` và click vào `Images`
4. Click `Image Create`. Lúc này có một box mới hiện ra.

<img src="http://i.imgur.com/jc0fkK7.png">

5. Điền những thông tin sau

- Image name: Tên image
- Image description: Mô tả ngắn về image
- Image Source: Lựa chọn nguồn, có 2 lựa chọn đó là Image Location và Image File. Tùy vào lựa chọn của bạn mà hệ thống sẽ hiển thị cách thức, nếu bạn chọn Image Location, bạn sẽ phải điền URL nơi chưa image. Ngược lại nếu bạn chọn Image File., bạn sẽ phải browse tới nơi cchuwasimage trên máy của mình.
- Format: Lựa chọn định dạng cho image
- Architecture: Kiến trúc (i386 hoặc x86_64)
- Minimum Disk (GB): Bỏ trống
- Minimum RAM (MB): Bỏ trống
- Copy Data : Tùy chọn cho phép copy dữ liệu tới image service
- Visibility: Quyền truy cập tới image, Public hoặc Private.
- Protected : Chỉ những user với quyền nhất định mới có thể xóa image
- Image Metadata: Thêm metadata.

6. Click `Create Image`

#### Update image

Để update image:

1. Đăng nhập vào dashboard
2. Chọn project
3. Lựa chọn image muốn sửa
4. Lựa chọn `Edit Image` từ drop down menu góc trên cùng bên phải.
5. Chỉnh sửa image
6. Click `Edit Image` để hoàn thành

#### Delete image

Một khi đã xóa, bạn sẽ không thể lấy lại được image, chỉ những người có quyền mới có thể thực hiện tác vụ này:

1. Đăng nhập vào dashboard
2. Chọn Project
3. Chọn `Images`
4. Chọn image muốn xóa và click `Delete Images`
5. Xác nhận

