# Tìm hiểu OpenvSwitch

## Mục lục

1. Giới thiệu về SDN (Software Defined Networking) và Open Flow

2. Giới thiệu OpenvSwitch

3. Những hạn chế khi sử dụng Linux Bridge - So sánh OpenvSwitch và Linux Bridge

4. Cấu trúc của OpenvSwitch

5. Hướng dẫn cài đặt KVM với OpenvSwitch

--------

## 1. Giới thiệu về SDN (Software Defined Networking) và Open Flow

**SDN (Software Defined Networking)**

SDN (Software Defined Networking) hay mạng điều khiển bằng phần mềm là một kiến trúc đem tới sự tự động, dễ dàng quản lí, tiết kiệm chi phí và có tính tương thích cao, đặc biệt phù hợp với những ứng dụng yêu cầu tốc độ băng thông cũng như sự tự dộng ngày nay. Kiến trúc này tách riêng hai chức năng là quản lí và truyền tải dữ liệu. SDN dựa trên giao thức luồng mở (Open Flow) và là kết quả nghiên cứu của Đại học Stanford và California Berkeley. SDN tách định tuyến và chuyển các luồng dữ liệu riêng rẽ và chuyển kiểm soát luồng sang thành phần mạng riêng có tên gọi là thiết bị kiểm soát luồng (Flow Controller).

Tóm lại có 3 ý chính đối với SDN đó là:

- Tách biệt phần quản lí (control plane) với phần truyền tải dữ liệu (data plane).
- Các thành phần trong network có thể được quản lí bởi các phần mềm được lập trình chuyên biệt.
- Tập trung vào kiểm soát và quản lí network.

Cùng quay trở lại quá khứ, khi mà người ta vẫn sử dụng Ethernet Hub. Về bản chất, thiết bị này chỉ làm công việc lặp đi lặp lại đó là mỗi khi nhận dữ liệu, nó lại forward tới tất cả các port mà nó kết nối.

Tuy nhiên điều này có thể gây nên nhiều hệ lụy xấu như broadcast storms, bandwidth bị giảm và looping (lụt). Kiểu truyền tải dữ liệu này được gọi là Data Plane/Forwarding Plane. Đó là lí do vì sao nó nhanh chóng bị thay thế bởi thiết bị layer 2 hay còn được biết tới với cái tên Network Switch. Thiết bị này về cơ bản đã "thông minh" hơn rất nhiều khi mà nó biết gửi dữ liệu tới đúng interface, và từ đây khái niệm control plane cũng bắt đầu xuất hiện.

Các thiết bị mạng đều có sự xuất hiện của control plane, nó cung cấp thông tin để xây lên bảng kết nối giúp các thiết bị mạng biết được chính xác nơi cần gửi dữ liệu.

<img src="">

Dưới đây là mô hình của kiến trúc SDN

<img src="">

Nhìn chung, SDN có 3 phần chính đó là:

- Network infrastructure: Bao gồm các thiết bị mạng như router, switch, bao gồm cả thiết bị ảo và thật.
- Controller: Bao gồm phần mềm dựa trên bộ điều khiển tập trung, có thể đặt trên server để giao tiếp với tất cả các thiết bị mạng bằng cách sử dụng API như OpenFlow hoặc OVMDB.

- Applications: Bao gồm hàng loạt các ứng dụng có sự tồn tại của network. Các ứng dụng này có thể nói chuyện với controller sử dụng API để thực hiện những yêu cầu.

**Open Flow**

OpenFlow là tiêu chuẩn đầu tiên, cung cấp khả năng truyền thông giữa các giao diện của lớp điều khiển và lớp chuyển tiếp trong kiến trúc SDN. OpenFlow cho phép truy cập trực tiếp và điều khiển mặt phẳng chuyển tiếp của các thiết bị mạng như switch và router, cả thiết bị vật lý và thiết bị ảo, do đó giúp di chuyển phần điều khiển mạng ra khỏi các thiết bị chuyển mạch thực tế tới phần mềm điều khiển trung tâm.
Các quyết định về các luồng traffic sẽ được quyết định tập trung tại OpenFlow Controller giúp đơn giản trong việc quản trị cấu hình trong toàn hệ thống.
Một thiết bị OpenFlow bao gồm ít nhất 3 thành phần:

- Secure Channel: kênh kết nối thiết bị tới bộ điều khiển (controller), cho phép các lệnh và các gói tin được gửi giữa bộ điều khiển và thiết bị.
- OpenFlow Protocol: giao thức cung cấp phương thức tiêu chuẩn và mở cho một bộ điều khiển truyền thông với thiết bị.
- Flow Table: một liên kết hành động với mỗi luồng, giúp thiết bị xử lý các luồng.

<img src="">


## 2. Giới thiệu OpenvSwitch

Open vSwitch là switch ảo mã nguồn mở theo giao thức OpenFlow. Nó là một multilayer software được viết bằng ngôn ngữ C cung cấp cho người dùng các chức năng quản lí network interface.

Open vSwitch rất phù hợp với chức năng là một switch ảo trong môi trường ảo hóa. Nó hỗ trợ rất nhiều nền tảng như Xen/XenServer, KVM, và VirtualBox.

Các chức năng của Open vSwitch:

- Standard 802.1Q VLAN model with trunk and access ports
- NIC bonding with or without LACP on upstream switch
- NetFlow, sFlow(R), and mirroring for increased visibility
- QoS (Quality of Service) configuration, plus policing
- Geneve, GRE, VXLAN, STT, and LISP tunneling
- 802.1ag connectivity fault management
- OpenFlow protocol support
- Transactional configuration database with C and Python bindings
- High-performance forwarding using a Linux kernel module

## 3. Những hạn chế khi sử dụng Linux Bridge - So sánh OpenvSwitch và Linux Bridge

**Hạn chế của Linux Bridge**

Linux Bridge (LB) là cơ chế ảo hóa mặc định được sử dụng trong KVM. Nó rất dễ dàng để cấu hình và quản lí tuy nhiên nó vốn không được dùng cho mục đích ảo hóa vì thế bị hạn chế một số các chức năng.

LB không hỗ trợ tunneling và OpenFlow protocols. Điều này khiến nó bị hạn chế trong việc mở rộng các chức năng. Đó cũng là lí do vì sao  Open vSwitch xuất hiện.

Dưới đây là bảng so sánh giữa hai công nghệ này:

| Open vSwitch | Linux bridge |
|--------------|--------------|
| Được thiết kế cho môi trường mạng ảo hóa | Mục đích ban đầu không phải dành cho môi trường ảo hóa |
| Có các chức năng của layer 2-4 | Chỉ có chức năng của layer 2 |
| Có khả năng mở rộng | Bị hạn chế về quy mô |
| ACLs, QoS, Bonding | Chỉ có chức năng forwarding |
| Có OpenFlow Controller | Không phù hợp với môi trường cloud |
| Hỗ trợ netflow và sflow | Không hỗ trợ tunneling |

**OVS**

- Ưu điểm: các tính năng tích hợp nhiều và đa dạng, kế thừa từ linux bridge. OVS hỗ trợ ảo hóa lên tới layer4. Được sự hỗ trợ mạnh mẽ từ cộng đồng. Hỗ trợ xây dựng overlay network.

- Nhược điểm: Phức tạp, gây ra xung đột luồng dữ liệu

**LB**

- Ưu điểm:

các tính năng chính của switch layer được tích hợp sẵn trong nhân. Có được sự ổn định và tin cậy, dễ dàng trong việc troubleshoot
Less moving parts: được hiểu như LB hoạt động 1 cách đơn giản, các gói tin được forward nhanh chóng

- Nhược điểm:

để sử dụng ở mức user space phải cài đặt thêm các gói. VD vlan, ifenslave. Không hỗ trợ openflow và các giao thức điều khiển khác.
không có được sự linh hoạt


## 4. Các thành phần và kiến trúc của Open vSwitch

Các thành phần chính của Open vSwitch:

- ovs-vswitchd :  daemon tạo ra switch, nó được đi kèm với Linux kernel module
- ovsdb-server : Một máy chủ cơ sở dữ liệu nơi ovs-vswitchd truy vấn để có được cấu hình.
- ovs-dpctl : công cụ để cấu hình switch kernel module.
- ovs-vsctl : Dùng để truy vấn và cập nhật cấu hình cho ovs-vswitchd.
- ovs-appctl : Dùng để gửi câu lệnh chạy Open vSwitch daemons.

<img src="">

**Cơ chế hoạt động**

Nhìn chung Open vSwitch được chia làm phần, Open vSwitch kernel module (Data Plane) và user space tools (Control Plane).

OVS kernel module sẽ dùng netlink socket để tương tác với vswitchd daemon để tạo và quản lí số lượng OVS switches trên hệ thống local. SDN Controller sẽ tương tác với vswitchd sử dụng giao thức OpenFlow. ovsdb-server chứa bảng dữ liệu. Các clients từ bên ngoài cũng có thể tương tác với ovsdb-server sử dụng json rpc với dữ liệu theo dạng file JSON.

Open vSwitch có 2 modes, normal và flow:
- Normal Mode: Ở mode này, Open vSwitch tự quản lí tất cả các công việc switching/forwarding. Nó hoạt động như một switch layer 2.

- Flow Mode: Ở mode này, Open vSwitch dùng flow table để quyết định xem port nào sẽ nhận packets. Flow table được quản lí bởi SDN controller nằm bên ngoài.

<img src="">

## 5. Hướng dẫn cài đặt KVM với OpenvSwitch
