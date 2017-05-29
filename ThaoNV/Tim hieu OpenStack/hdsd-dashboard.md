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

**Configure access and security for instances**

Trước khi chạy máy ảo, bạn nên add security group rules để cho phép user ping hoặc SSH tới máy ảo. Security groups là một danh sách các IP rules được định nghĩa để điều khiển truy cập và nó được áp dụng với tất cả các máy ảo trong 1 project. Để làm được điều này thì bạn có thể add rules cho security group mặc định hoặc add mới một  security group.

Key pairs là thông tin SSH được "bơm" vào máy ảo khi nó được khởi chạy. Để sử dụng key pairs, file image để chạy máy ảo phải chứa package cloud init. Mỗi một project nên có ít nhất 1 key pair.

Nếu bạn đã tạo key pair bằng một công cụ  bên ngoài, bạn có thể import nó vào OpenStack. Key pair có thể được dùng cho nhiều máy ảo khác nhau trong 1 project.

Khi máy ảo được tạo, nó sẽ tự động được gán địa chỉ IP. Địa chỉ IP này sẽ theo máy ảo cho tới khi nó bị hủy bỏ. Bên cạnh đó, bạn cũng có thể gán floating IP cho máy ảo. Địa chỉ này có thể được thay đổi bất cứ lúc nào, nó không phụ thuộc vào trạng thái của máy ảo.

**Add a rule to the default security group**

Thực hiện các bước sau để kích hoạt SSH và ICMP (ping) cho máy ảo.

1. Đăng nhập vào dashboard
2. Chọn project
3. Trong `Project tab` click `Access & Security`.
4. Chọn  security group mặc định và click `Manage Rules.`
5. Để cho phép SSH, click `Add Rule`.
6. Trong hộp thoại được mở ra, điền những thông tin sau
- Rule: SSH
- Remote: CIDR
- CIDR: 0.0.0.0/0
7. Click `Add`.
8. Để thêm ICMP rule, click `Add Rule`
9. Trong hộp thoại được mở ra, điền những thông tin sau
- Rule: All ICMP
- Direction: Ingress
- Remote: CIDR
- CIDR: 0.0.0.0/0

10. Click `Add`.

**Add a key pair**

1. Đăng nhập vào máy ảo
2. Chọn project
3. Tại tab Compute, click `Access & Security`
4. Click `Key Pairs`, màn hình sẽ hiện một vài key pairs có sẵn
5. Click `Create Key Pair`
6. Trong hộp thoại mới mở, điền tên key pair, Click `Create Key Pair`
7. Confirm để download keypair

**Import a key pair**

1. Đăng nhập vào máy ảo
2. Chọn project
3. Tại tab Compute, click `Access & Security`
4. Click `Key Pairs`, màn hình sẽ hiện một vài key pairs có sẵn
5. Click `Import Key Pair`
6. Trong hộp thoại mới mở, điền tên key pair, copy public key vào `Public Key` box sau đó click `Import Key Pair`
7. Lưu file `*.pem`
8. Thay đổi quyền cho phép chỉ mình bạn có thể đọc và viết file ấy, chạy câu lệnh

`$ chmod 0600 yourPrivateKey.pem`

Note: Nếu sử dụng dashboard từ Windows, sử dụng Putty gen để load file `*.pem`, convert và lưu nó lại dưới dạng `*.ppk`

9. Để key pair biết SSH, chạy câu lệnh

`$ ssh-add yourPrivateKey.pem`

Compute database sẽ lưu lại public key. Dashboard sẽ có danh sách các key pair trong phần `Access & Security`.

**Allocate a floating IP address to an instance**

1. Đăng nhập vào máy ảo
2. Chọn project
3. Tại tab Compute, click `Access & Security`
4. Click `Floating IPs`
5. Click `Allocate IP To Project.`
6. Chọn pool để lấy địa chỉ IP
7. Trong danh sách `Floating IPs`, chọn `Associate`.
8. Điền thông tin trong hộp thoại mới mở  và click `Associate`

**Launch and manage instances**

Bạn có thể tạo các máy ảo (instances) từ những nguồn sau:

- Image được upload qua image service
- Image bạn vừa copy vào volume. Máy ảo sẽ được tạo từ volume.
- Snapshot mà bạn đã tạo.

**Launch an instance**

1. Đăng nhập vào máy ảo
2. Chọn project
3. Tại tab Compute, click `Instances`
4. Click `Launch Instance.`
5. Trong hộp thoại mới mở, điền các thông tin sau:
- Instance Name: Tên máy ảo
- Availability Zone: Thông thường đây sẽ là các vùng được đưa ra bởi những nhà cung cấp cloud. Trong một vài trường hợp, nó là nova.
- Count: Số lượng các máy ảo tạo nên. Giá trị mặc định là 1
- Instance Boot Source: Có 4 lựa chọn
	- Boot from image
	- Boot from snapshot
	- Boot from volume
	- Boot from image (creates a new volume)
	- Boot from volume snapshot (creates a new volume)

- Image Name: Nếu bạn chọn boot từ image ở bước trước, một danh sách image sẽ hiện ra để bạn lựa chọn.
- Instance Snapshot: Giống với image nhưng danh sách hiện ra sẽ là các snapshot.
- Volume: Giống với image nhưng danh sách hiện ra sẽ là các volume.
- Flavor: Kích thước của máy ảo
- Selected Network: Chọn network cho máy ảo
- Ports 
- Security Groups: Kích hoạt security groups mà bạn muốn gán cho máy ảo

Security Groups là một dạng firewall trong cloud. Nó quy định những traffic nào được phép forward tới máy ảo. Nếu bạn chưa tạo bất cưa một security group nào, bạn chỉ cần gán security group mặc định cho máy ảo.

- Key Pair
- Customization Script Source : Scripts chạy sau khi máy ảo được tạo
- Available Metadata

6. Click `Launch Instance.`

Khi tạo máy ảo từ image, OpenStack sẽ tạo ra 1 bản copy của file image. 
Note: Khi chạy QEMU mà không có sự hỗ trợ của phần cứng sẽ gây lỗi:

`libvirtError: unsupported configuration: CPU mode 'host-model'
for ``x86_64`` qemu domain on ``x86_64`` host is not supported by hypervisor`

Sửa file nova.conf, thay cpu_mode="none" và virt_type=qemu in /etc/nova/nova-compute.conf để sửa lỗi.

**Connect to your instance by using SSH**

Để SSH tới máy ảo sử dụng file keypair đã download

1. Copy địa chỉ IP cho máy ảo của bạn
2. sử dụng câu lệnh để kết nối thông qua ssh

`$ ssh -i MyKey.pem ubuntu@10.0.0.2`

3. Confirm bằng cách type `yes`

Bạn cũng có thể SSH tới máy ảo mà không cần SSH keypair, nếu người quản trị đã kích hoạt root password.

**Track usage for instances**

Bạn có thể theo dõi mức độ sử dụng của các máy ảo trong mỗi một project từ đó đưa ra những tính toán cụ thể về mức phí mà khác hàng phải trả.

1. Đăng nhập vào máy ảo
2. Chọn project
3. Tại tab Compute, click `Overview`
4. Để truy vấn mức độ sử dụng trong 1 tháng, lựa chọn tháng và click `Submit`
5. Để download bản tóm tắt, click `Download CSV Summary`

**Create an instance snapshot**

1. Đăng nhập vào máy ảo
2. Chọn project
3. Tại tab Compute, click `Instances`
4. Lựa chọn máy ảo muốn tạo snapshot
5. click Create Snapshot.
6. Điền tên và click `Create Snapshot`

**Manage an instance**

1. Đăng nhập vào máy ảo
2. Chọn project
3. Tại tab Compute, click `Instances`
4. Chọn máy ảo
5. Trong danh sách menu list các action, bạn có thể resize, rebuild hoặc truy cập console, sửa instance...

**Create and manage networks**

**Create a network**

1. Đăng nhập vào máy ảo
2. Chọn project
3. Tại tab Network, click `Networks`
4. Click `Create Network.`
5. Trong hộp thoại mới mở, điền những thông tin sau

- Network Name: Tên network
- Shared: Chia sẻ network với các projects khác, chỉ admin mới có quyền lựa chọn
- Admin State: Trạng thái để bắt đầu kích hoạt network
- Create Subnet: Tích vào để tạo subnet
	- Subnet Name: Tên subnet
	- Network Address: Địa chỉ IP cho subnet
	- IP Version: IPv4 hoặc IPv6
	- Gateway IP: Địa chỉ gateway
	- Disable Gateway: Không sử dụng gateway
	- Enable DHCP: Kích hoạt DHCP
	- Allocation Pools: Lựa chọn IP pools
	- DNS Name Servers: Địa chỉ DNS
	- Host Routes: Địa chỉ định tuyến

6. Click Create.

**Create a router**

1. Đăng nhập vào máy ảo
2. Chọn project
3. Tại tab Network, click `Routers`
4. Click Create Router.
5. Tại hộp thoại mới mở, chọn tên cho router và External Network sau đó click Create Router.
6. Để kết nối private network với router vừa tạo, thực hiện một vài bước sau:
- Tại tab `Routers`, click vào tên của router
- Trong phần `Router Details`, click `Interfaces` -> `Add Interface`
- Tại phần `Add Interface`, lựa chọn Subnet

7. Click Add Interface.

**Create and manage volumes**

Volume là thiết bị block storage được gán vào các máy ảo. Bạn có thẻ gán nó vào máy ảo đang chạy hoặc gỡ nó ra rồi gán vào máy ảo khác vào bất cứ thời điểm nào. Bạn cũng có thể tạo snapshot hoặc xóa volume.

**Create a volume**

1. Đăng nhập vào máy ảo
2. Chọn project
3. Tại tab Compute, click `Volume`
4. Click Create Volume.
5. Điền những thông tin sau
- Volume Name: Tên volume
- Description: Mô tả
- Volume Source:
	- No source, empty volume: Tạo một volume trắng, không chứa bất cứ file nào.
	- Snapshot: Một danh sách các snapshot sẽ hiện lên để bạn lựa chọn.
	- Image: Một danh sách các image sẽ hiện lên để bạn lựa chọn.
	- Volume: Một danh sách các volume sẽ hiện lên để bạn lựa chọn.

- Type: Để trống
- Size (GB): Kích thước của Volume, được tính bằng gibibytes (GiB)
- Availability Zone

5. Click Create Volume.

**