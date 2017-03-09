# Tìm hiểu về KMV

# Mục lục
##  [I.Giới thiệu](#gioithieu)
###   [1.1 Định nghĩa](#dinhnghia)
###   [1.2 Lịch sử ](#lichsu)
##  [II.Cấu trúc KVM](#cautruc)
### [2.1 Cấu trúc tổng quan](#tongquan)
### [2.2 Hiệu suất và cải tiến trong cấu trúc](#hieusuat)
### [2.3 Mô hình KVM Stack](#stack)
### [2.4 Mô hình KVM QEMU](#qemu)
##  [III. Cài đặt KVM trên Linux Mint](#caidat)
### [3.1 Cài đặt KVM](#cdkvm)
### [3.2 Hướng dẫn cài đặt máy ảo](#cdmayao)
## [IV. Tìm hiểu vể Virsh Command Line Interfaces](#vcli)





-----------------------------------------

<a name="gioithieu"></a>
## I.Giới thiệu

<a name="dinhnghia"></a>
### 1.1 Định nghĩa

  - `KVM(Kernel-based Virtual Machine)` : là giải pháp ảo hóa toàn diện trên phần cứng x86 và hỗ trợ hầu hết các hệ điều hành của Linux và Windowws. KVM chuyển đổi một nhân Linux (Linux kernel) thành một bare metal hypervisor và thêm vào đó những đặc trưng riêng của các bộ xử lý Intel như Intel VT-X hay AMD như AMD-V.Nó có thể cài đặt các hệ điều hành khác nhau mà không cần phụ thuộc vào hệ điều hành của máy chủ vật lý.Hơn thế nữa, KVM còn tích hợp các đặc điểm bảo mật của Linux như SELinux hay các cơ chế bảo mật nhiều lớp, điều đó làm cho các máy ảo được bảo vệ tối đa và cách ly hoàn toàn.

  - KVM được phát triển trên nền tảng mã nguồn mở, chính vì thế nó ngày càng lớn mạnh và trở thành một lựa chọn hàng đầu cho doanh nghiệp và hơn thế nữa, nó còn được hỗ trợ từ những nhà sản xuất thiết bị phần cứng, đó là những công nghệ ảo hóa được tích hợp vào bộ vi xử lý như Intel VT-X hay AMD-V để gia tăng đáng kể hiệu suất, tính linh hoạt và khả năng bảo mật.
  - Ngoài ra, do hoạt động trên nền tảng hệ điều hành Linux hay nói đúng hơn là KVM được tải thẳng vào bên trong Linux kernel nên KVM đạt hiệu suất rất cao, cùng một cấu hình, KVM có thể tạo được số lượng máy ảo tương đương nhiều hơn so với VMware.

<a name="lichsu"></a>
### 1.2 Lịch sử
  - KVM ra đời phiên bản đầu tiên vào năm 2007 bởi công ty Qumranet tại Isarel, KVM được tích hợp sẵn vào nhân của hệ điều hành Linux bắt đầu từ phiên bản 2.6.20
  - Năm 2008, RedHat đã mua lại Qumranet và bắt đầu phát triển, phổ biến KVM Hypervisor.

<a name="cautruc"></a>
## II. Cấu trúc KVM

<a name="tongquan"></a>
### 2.1 Cấu trúc tổng quan

  <img src="http://i.imgur.com/8XkZY4C.png">

   - Khi sử dụng KVM, máy ảo sẽ chạy như một tiến trình trên máy chủ Linux.
   - Các CPU ảo (Virtual CPUs) được xử lý như các luồng thông thường,được xử lý theo lập lịch của Linux.
   - Máy ảo được thừa kế các tính năng như NUMA (Non-uniform memory access) và HugePages trong linux.
   - Ổ đĩa, card mạng, thiết bị vào/ra ảnh của máy ảo sẽ ảnh hưởng một phần đến máy chủ vật lý.
   - Lưu lượng mạng thường đường truyền qua card Brige.

<a name="hieusuat"></a>
### 2.2 Hiệu suất và cải tiến :
  - `CPU/Kernel` : được thừa kế rất nhiều từ các nhà sản xuất :
  <ul>
  <li>`NUMA (Non-Uniform Memory Access)`: Truy cập bộ nhớ không đồng dạng NUMA là quá trình song song truy cập kiến trúc máy tính đi đôi với SMP (sysmetric multiprocessing: đa xử lý đối xứng) và MPP (massively parallel processing: xử lý song song “đồ sộ”) trong khả năng của nó để khai thác sức mạnh của hệ thống đa xử lý. </li>
  <li>`CFS (Completely Fair Scheduler)` : là một quá trình lập lịch đã được sáp nhập vào bản phát hành 2.6.23 của hạt nhân Linux và là lịch trình mặc định. Nó xử lý phân bổ nguồn lực CPU để thực hiện các quy trình, và nhằm mục đích tối đa hóa việc sử dụng CPU tổng thể đồng thời tối đa hóa hiệu suất tương tác.</li>
  <li>`RCU (Read Copy Update)` : Giúp xử lý tốt hơn các luồng dữ liệu chia sẻ. </li>
  <li>`Up to 160 VCPUs` : Hỗ trợ tối đa lên đến 160 Virtual CPUs</li>
  </ul>


  - `Memory- Bộ nhớ`
  Hỗ trợ HugePages( giúp quản lý và cải thiện hiệu suất đang kể cho bộ nhớ) và tối ưu hóa cho các môi trường đòi hỏi tiêu tốn bộ nhớ.

  - `Networking - Mạng`:
  <ul>
  <li>`Vhost-net` : chưa tìm hiểu được.</li>
  <li>`SR-IOV`: chưa tìm hiểu được.</li>
  </ul>


  - `Block I/O - Khối vào/ra` :
  <ul>
  <li>AIO (Asynchronous I/O) : Hỗ trợ xử lý các luồng I/O khác nhau hoạt động chồng chéo với nhau.</li>
  <li>MSI  : Ngắt kết nối thiết bị bus bus PCI </li>
  <li>Scatter Gather : Giúp cải tiến I/O để xử lý các bộ nhớ đệm dữ liệu</li>
  </ul>

<a name="stack"></a>
### 2.3 Mô hình KVM Stack

<img src="http://i.imgur.com/DHuQKkm.png">

Trong đó :
- `User-facing tools` : là các công cụ hỗ  trợ quản lý máy ảo.Có thể là Virt-manager (hỗ trợ giao diện) hoặc Virsh(dòng lệnh) hoặc Virt-tools(công cụ quản lý trung tâm dữ liệu).
- `Mgmt layer` : Lớp này là thư viện libvirt cung cấp API để các công cụ quản lý máy ảo hoặc các hypervisor tương tác với KVM thực hiện các thao tác quản lý tài nguyên ảo hóa.
- `Virtual machine` :  Chính là các máy ảo người dùng tạo ra. Thông thường, nếu không sử dụng các công cụ như virsh hay virt-manager thì sử dụng QEMU.
- `Kernel support` : Chính là KVM, cung cấp một module làm hạt nhân cho hạ tầng ảo hóa (kvm.ko) và một module kernel đặc biệt hỗ trợ các vi xử lý VT-x hoặc AMD-V (kvm-intel.ko hoặc kvm-amd.ko).

<a name="qemu"></a>
### 2.4 Mô hình KVM & QEMU
Mô hình :

<img src=http://i.imgur.com/XVHHuxq.jpg>

QEMU có thể tận dụng KVM khi chạy một kiến ​​trúc mục tiêu tương tự như kiến ​​trúc lưu trữ. Chẳng hạn, khi chạy qemu-system-x86 trên một bộ xử lý tương thích x86, bạn có thể tận dụng tăng tốc KVM - mang lại lợi ích cho máy chủ và hệ thống máy ảo của bạn.

<a name="caidat"></a>
## III. Cài đặt KVM trên Linux Mint

<a name="cdkvm"></a>
### 3.1 Cài đặt KVM
- Bước 1 : KVM chỉ làm việc nếu CPU hỗ trợ ảo hóa phần cứng, Intel VT-x hoặc AMD-V. Để xác định CPU có những tính năng này không, thực hiện lệnh sau:

  `egrep -c '(svm|vmx)' /proc/cpuinfo`

  <img src=http://i.imgur.com/4j11OYS.png>

  Giá trị 0 chỉ thị rằng CPU không hỗ trợ ảo hóa phần cứng trong khi giá trị khác 0 chỉ thị có hỗ trợ. Người dùng có thể vẫn phải kích hoạt chức năng hỗ trợ ảo hóa phần cứng trong BIOS của máy kể cả khi câu lệnh này trả về giá trị khác 0.Ở đây giá trị của mình là 4.
- Bước 2 : Sử dụng lệnh sau để cài đặt KVM và các gói phụ   trợ. Virt-Manager là một ứng dụng có giao diện đồ họa dùng để quản lý máy ảo. Ta có thể dùng lệnh kvm trực tiếp nhưng libvirt và Virt-Manager giúp đơn giản hóa các bước hơn.
   Đối với Lucid (10.04) hoặc phiên bản sau :

    `sudo apt-get install qemu-kvm libvirt-bin bridge-utils virt-manager`

   Đối với Karmic (9.10) hoặc phiên bản trước :

    `sudo aptitude install kvm libvirt-bin ubuntu-vm-builder bridge-utils`

    <ul>
    <li>libvirt-bin : cung cấp libvirt mà bạn cần quản lý qemu và kvm bằng libvirt</li>
    <li>ubuntu-vm-builder : Công cụ dưới dạng dòng lệnh giúp quản lý các máy ảo.</li>
    <li>qemu-kvm : Phần phụ trợ cho KVM</li>
    <li>bridge-utils: Cung cấp mạng kết nối bắc cầu từ máy ảo ra internet.</li>
    <li>virt-manager : Virtual Machine Manager</li>
    </ul>

- Bước 3 : Chỉ quản trị viên (root user) và những người dùng thuộc libvirtd group có quyền sử dụng máy ảo KVM. Chạy lệnh sau để thêm tài khoản người dùng vào libvirtd group:

   Đối với Karmic (9.10) và phiên bản sau (nhưng không phải 14.04 LTS)

  `sudo add Username libvirtd`

   Đối với phiên bản phát hành trước Karmic (9.10) :

   `$ groups`

   `$ sudo adduser Username kvm`

   `$ sudo adduser Username libvirtd`



   <img src=http://i.imgur.com/SoHk9rO.png>

- Bước 4 : Sau khi chạy lệnh này, đăng xuất rồi đăng nhập trở lại. Nhập câu lệnh sau sau khi đăng nhập:

  `virsh --connect qemu:///system list`

  Một danh sách máy ảo còn trống xuất hiện. Điều này thể hiện mọi thứ đang hoạt động đúng.

  <img src=http://i.imgur.com/nyYZFgJ.png>


  Như vậy là cài đặt xong.Để cài đặt một hệ điều hành trên KVM chúng ta tiến hành cài đặt nó trên Phần mềm Virtual Machine Manager.

<a name=cdmayao></a>
### 3.2 Hướng dẫn cài đặt máy ảo
  Bài hướng dẫn này mình thực hiện trên Linux Mint 17.3 nên cần phải có đủ tất các gói phụ trợ.

  Đầu tiên kiểm tra xem đã có đầy đủ tất cả các gói phụ trợ hay chưa :
  <img src="http://i.imgur.com/FaRnGB3.png">
   Có tổng cộng tất cả 11 gói :
   - gir1.2-spice-client-glib-2.0
   - gir1.2-spice-client-gtk-2.0
   - gir1.2-spice-client-gtk-3.0
   - libspice-client-glib-2.0-8:amd64
   - libspice-client-gtk-2.0-4:amd64
   - libspice-client-gtk-3.0-4:amd64
   - libspice-server1:amd64
   - python-spice-client-gtk
   - spice-client-glib-usb-acl-helper
   - spice-client-gtk
   - spice-vdagent

Nếu thiếu gói nào thì các bạn hãy cài đặt gói ấy để tránh xảy ra một số lỗi .
Bây giờ chúng ta sẽ tiến hành cài đặt
  - Bước 1 : Mở Virtual Machine Manager lên xuất hiện hộp thoại, Chọn File/ New Virtual Machine xuất hiện hộp thoại  :
  <img src=http://i.imgur.com/QnxOEvn.png>
  - Bước 2 : Trỏ Browse đến file iso hệ điều hành cần cài đặt :
  <img src=http://i.imgur.com/XZjrYsK.png>

  - Bước 3 : Tùy chỉnh thông số máy ảo RAM,CPU
  <img src=http://i.imgur.com/eW4c5x6.png>

  - Bước 4 : Tùy chọn dung lượn ổ cứng
  <img src=http://i.imgur.com/zlVlrCa.png>

  - Bước 5 : Đặt tên cho máy ảo và tùy chọn cấu hình, card mạng.
  <img src=http://i.imgur.com/I8lc7bL.png>

  - Bước 6 : Tiến hành cài đặt hệ điều hành như bình thường
  <img src=http://i.imgur.com/LY4pA7o.png>
  - Sau khi cài đặt xong :
  <img src=http://i.imgur.com/SJfiiE8.png>

   Theo mình cảm nhận so với VMware thì tốc độ xử lý nhanh hơn rất nhiều.

<a name=vcli></a>
## IV. Tìm hiểu về Virsh Command Line Interfaces
  Hiểu một cách đơn giản nhất Virsh CLI là công cụ quản lý KVM bằng giao diện dòng lệnh.

  Các tùy chọn quản lý cơ bản :
  - help :  Hiển thị trợ giúp
  - list :  Hiển thị danh sách các domains
  - creat :   Thiết lập 1 domain từ thư mục XML
  - start :   Khởi động một domain đã hoạt động trước đó.
  - destroy :   Xóa đi một domain
  - define :  Định nghĩa một domain (không phải như start)
  - domid :   chuyển từ dạng domain name hoặc UUID sang domain id
  - domuuid :   chuyển đổi từ domain name hoặc domain id sang UUID
  - domname :   chuyển đổi từ domain id hoặc UUID sang domain name.
  - dominfo : thông tin về domain
  - domstate : trạng thái của domain
  - quit : thoát khỏi Virsh CLI
  - reboot : khởi động lại domain
  - restore : quay lại một trạng thái nào đó của domain
  - resum : tiếp tục hoạt động một domain sau khi tạm ngưng
  - save : lưu trạng thái domain
  - shutdown : tắt domain
  - suppend : tạm ngưng hoạt động domain
  - undefine : Bỏ định nghĩa domain

Các tùy chọn quản lý tài nguyên :
  - setmem : thay đổi cấp phát bộ nhớ
  - setmaxmem : thay đổi dung lượng bộ nhớ tối đa
  - setvcpus : thay đổi số virtual CPUs
  - vcpuinfo : thông tin Virtual CPUs của domain
  - vcpupin : kiểm soát mối liên hệ giữa các vCPUs.

Các tùy chọn giám sát và khắc phục sự cố :
  - version : hiển thị phiên bản
  - dumpxml : thông tin domain trong XML
  - noteinfo : thông tin về note
