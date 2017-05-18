# Tìm hiểu về OpenStack

## Mục lục

- 1. [Định nghĩa, lịch sử hình thành và công dụng của OpenStack](#def)
- 2. [Thành phần](#com)

----

### <a name = "def"> 1. Định nghĩa, lịch sử hình thành và công dụng của OpenStack </a>

Đa số những người làm trong ngành IT trước khi nghe tới OpenStack đều đã biết đến những cụm từ như Ảo hóa và Điện toán đám mây. Vậy nên trước khi tìm hiểu về OpenStack. Hãy cùng tìm hiểu qua về ảo hóa và điện toán đám mây.

**Ảo hóa (Virtualization)**

Ảo Hóa là kỹ thuật  tạo ra phần cứng, thiết bị  mạng, thiết bị lưu trữ  … ẢO – không có thật (và ở góc độ nào đó có thể hiểu là “giả lập” và “mô phỏng” lại các thành phần này)

Đi kèm với Ảo hóa thường có các cụm từ Hardware Virtualization, Platform Virtualization: các cụm từ này ám chỉ việc tạo ra các thành phần phần cứng (ảo) để tạo ra các máy ảo (Virtual Machine), chúng có gần như đầy đủ các thành phần như máy thật (physical machine ) và có thể cài đặt hệ điều hành (Linux, Windows, ….trong network thì có thể có các Router ảo và Switch ảo ) và tất nhiên người dùng có thể sử dụng và khai thác được các máy ảo, thiết bị ảo này. 

Các bạn có thể tìm hiểu sâu hơn về ảo hóa thông qua một vài keywords sau: Full-Virtualization, Para-Virtualization, Operating system-level virtualization, Hypervisor.

**Điện toán đám mây (Cloud Computing)**

Cloud Computing  là mô hình cho phép truy cập qua mạng để lựa chọn và sử dụng tài nguyên  có thể được tính toán (ví dụ: mạng, máy chủ, lưu trữ, ứng dụng và dịch vụ) theo nhu cầu một cách thuận tiện và nhanh chóng; đồng thời cho phép kết thúc sử dụng dịch vụ, giải phóng tài nguyên dễ dàng, giảm thiểu các giao tiếp với nhà cung cấp

Có thể coi đây là bước kế tiếp của Ảo hóa. Ảo hóa phần cứng, ảo hóa ứng dụng. là thành phần quản lý và tổ chức, vận hành  các hệ thống ảo hóa trước đó.

Cloud Computing có 5 đặc tính, 4 mô hình dịch vụ và 3 mô hình triển khai

5 đặc tính:

- Rapid elasticity: Khả năng thu hồi và cấp phát tài nguyên
- Broad network access: Truy nhập qua các chuẩn mạng
- Measured service: Dịch vụ sử dụng đo đếm được,  hay là chi trả theo mức độ sử dụng pay as you go
- On-demand self-service: Khả năng tự phục vụ
- Resource pooling: Chia sẻ tài nguyên

4 mô hình dịch vụ

- Public Cloud: Đám mây công cộng (là các dịch vụ trên nền tảng Cloud Computing để cho các cá nhân và tổ chức thuê, họ dùng chung tài nguyên).
- Private Cloud: Đám mây riêng (dùng trong một doanh nghiệp và không chia sẻ với người dùng ngoài doanh nghiệp đó)
- Community Cloud: Đám mây cộng đồng (là các dịch vụ trên nền tảng Cloud computing do các công ty cùng hợp tác xây dựng và cung cấp các dịch vụ cho cộng đồng
- Hybrid Cloud : Là mô hình kết hợp (lai) giữa các mô hình Public Cloud và Private Cloud

3 mô hình triển khai

- Hạ tầng như một dịch vụ (Infrastructure as a Service)
- Nền tảng như một dịch vụ (Platform as a Service)
- Nền tảng như một dịch vụ (Platform as a Service)

**Vậy OpenStack là gì?**

OpenStack là một phần mềm mã nguồn mở, dùng để triển khai Cloud Computing, bao gồm private cloud và public cloud (nhiều tài liệu giới thiệu là Cloud Operating System)

``` sh
OpenStack is a cloud operating system that controls large pools of compute, storage, and networking resources throughout a datacenter, all managed through a dashboard that gives administrators control while empowering their users to provision resources through a web interface.
```

Hình dưới đây minh họa vị trí của OpenStack trong thực tế:

<img src="http://i.imgur.com/KcI8Fq0.png">

- Phía dưới là phần cứng đã được ảo hóa để chia sẻ cho ứng dụng, người dùng
- Trên cùng là các ứng dụng của bạn, tức là các phần mềm mà bạn sử dụng
- Và OpenStack là phần ở giữa 2 phần trên, trong OpenStack có các thành phần, module khác nhau nhưng trong hình minh họa các thành phần cơ bản: Dashboard, Compute, Networking, API, Storage …

Cần hiểu thoáng và nhanh gọn hình này, ở đây OpenStack đã bao trùm cả lên phần ảo hóa, nó chính là trong khối Compute. Do vậy bạn đừng hiểu nhầm sang khía cạnh Ảo hóa.

**Một vài thông tin tóm tắt về OpenStack**

- Ban đầu, OpenStack được phát triển bởi NASA và Rackspace, và ra phiên bản đầu tiên vào năm 2010. Định hướng của họ từ khi mới bắt đầu là tạo ra một dự án nguồn mở mà mọi người có thể sử dụng hoặc đóng góp. OpenStack dưới chuẩn Apache License 2.0, và vì thế phiên bản đầu tiên đã phát triển rộng rãi trong cộng đồng được hỗ trợ bởi hơn 9000 cộng tác viên trên gần 90 quốc gia, và hơn 150 công ty bao gồm Redhat, Canonical, IBM, AT&T, Cisco, Intel, PayPal, Comcast và một nhiều cái tên khác. Đến nay, OpenStack đã cho ra mắt 15 phiên bản, các bạn có thể xem thêm tại [đây](https://releases.openstack.org/).
- OpenStack hoạt động theo hướng mở: (Open) Công khai lộ trình phát triển, (Open) công khai mã nguồn … Stack mang nghĩa là tầng, lớp (ở đây được hiểu là OpenStack được phát triển theo nguyên lí các tầng lớp chồng lên nhau).
- Tháng 10/2010 Racksapce và NASA công bố phiên bản đầu tiên của OpenStack, có tên là OpenStack Austin, với 2 thành phần chính ( project con) : Compute (tên mã là Nova) và Object Storage (tên mã là Swift)
- Tên các phiên bản được bắt đầu theo thứ tự A, B, C, D …trong bảng chữ cái.

### < a name ="com"> 2. Thành phần </a>

OpenStack không phải là một dự án đơn lẻ mà là một nhóm các dự án nguồn mở nhằm mục đích cung cấp các dịch vụ cloud hoàn chỉnh. OpenStack chứa nhiều thành phần:

- OpenStack compute (code-name Nova): là module quản lý và cung cấp máy ảo. Tên phát triển của nó Nova. Nó hỗ trợ nhiều hypervisors gồm KVM, QEMU, LXC, XenServer... Compute là một công cụ mạnh mẽ mà có thể điều khiển toàn bộ các công việc: networking, CPU, storage, memory, tạo, điều khiển và xóa bỏ máy ảo, security, access control. Bạn có thể điều khiển tất cả bằng lệnh hoặc từ giao diện dashboard trên web.

- OpenStack Glance (code-name Glance): là OpenStack Image Service, quản lý các disk image ảo. Glance hỗ trợ các ảnh Raw, Hyper-V (VHD), VirtualBox (VDI), Qemu (qcow2) và VMWare (VMDK, OVF). Bạn có thể thực hiện: cập nhật thêm các virtual disk images, cấu hình các public và private image và điều khiển việc truy cập vào chúng, và tất nhiên là có thể tạo và xóa chúng.

- OpenStack Object Storage (code-name Swift): dùng để quản lý lưu trữ. Nó là một hệ thống lưu trữ phân tán cho quản lý tất cả các dạng của lưu trữ như: archives, user data, virtual machine image … Có nhiều lớp redundancy và sự nhân bản được thực hiện tự động, do đó khi có node bị lỗi thì cũng không làm mất dữ liệu, và việc phục hồi được thực hiện tự động.

- Identity Server(code-name Keystone): quản lý xác thực cho user và projects.

- OpenStack Netwok (code-name Neutron): là thành phần quản lý network cho các máy ảo. Cung cấp chức năng network as a service. Đây là hệ thống có các tính chất pluggable, scalable và API-driven.

- OpenStack dashboard (code-name Horizon): cung cấp cho người quản trị cũng như người dùng giao diện đồ họa để truy cập, cung cấp và tự động tài nguyên cloud. Việc thiết kế có thể mở rộng giúp dễ dàng thêm vào các sản phẩm cũng như dịch vụ ngoài như billing, monitoring và các công cụ giám sát khác.

**Link tham khảo:**

https://vietstack.wordpress.com/2014/02/15/openstack-la-gi-va-de-lam-gi/
https://viblo.asia/le.cong.phuc/posts/ZabG9zZ5vzY6
https://www.slideshare.net/lanhuonga3/tm-hiu-v-openstack