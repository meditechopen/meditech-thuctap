# Mục lục
[Tổng quan](#tongquan)
- [1. Lịch sử hình thành](#history)
- [2. Kiến trúc](#kientruc)
<ul>
<li> [2.1 Kiến trúc KVM](#kientruc)</li>
<li> [2.2 Mô hình thực hiện](#mohinh)</li>
<li> [2.3 Kvm stack](#stack)</li>
 </ul>
- [3. KVM-qemu](#qemu)
- [4. Tính năng của KVM](#tinhnang)

# Tìm hiểu về Kernel-based Virtual Machine (KVM)

KVM (Kernel-based virtual machine) là giải pháp ảo hóa cho hệ thống linux trên nền tảng phần cứng x86 có các module mở rộng hỗ trợ ảo hóa (Intel VT-x hoặc AMD-V). 
Về bản chất, KVM không thực sự là một hypervisor có chức năng giải lập phần cứng để chạy các máy ảo. Chính xác KVM chỉ là một module của kernel linux hỗ trợ cơ chế mapping các chỉ dẫn trên CPU ảo (của guest VM) sang chỉ dẫn trên CPU vật lý (của máy chủ chứa VM). Hoặc có thể hình dung KVM giống như một driver cho hypervisor để sử dụng được tính năng ảo hóa của các vi xử lý như Intel VT-x hay AMD-V, mục tiêu là tăng hiệu suất cho guest VM.
<a name=tongquan></a>
## Tổng quan.
<a name=history></a>
### 1. Lịch sử hình thành.
KVM ban đầu được phát triển bởi Qumranet – một công ty nhỏ, sau đó dduwwcj Redhat mua lại vào tháng 9 năm 2008. Ta có thể thấy KVM là thế hệ tiếp theo của công nghệ ảo hóa. KVM được sử dụng mặc định từ bản RHEL (Redhat Enterprise Linux) từ phiên bản 5.4 và phiên bản Redhat Enterprise Virtualization dành cho Server.

Qumranet phát hành mã của KVM cho cộng đồng mã nguồn mở. Hiện nay, các coog ty nổi tiếng như IBM, Intel và ADM cũng đã cộng tác với dự án. Từ phiên bản 2.6.20, KVM trở thành một phần của hạt nhân Linux.
<a name=kientruc></a>
### 2. Kiến trúc

#### 2.1 Kiến trúc KVM

##### Linux as a VMM

Linux có tất cả các cơ chế của một VMM cần thiết để vận hành (chạy) các máy ảo. Chính vì vậy các nhà phát triển không xây dựng lại mà chỉ thêm vào đó một vài thành phần để hỗ trợ ảo hóa. KVM được triển khai như một modul hạt nhân có thể được nạp vào để mở rộng Linux bởi những khả năng này.

<img src="https://camo.githubusercontent.com/c537bd78fbe3869c77537961335cfdaaf24d99af/687474703a2f2f692e696d6775722e636f6d2f4c44554a534e5a2e706e67">

Trong một môi trường linux thông thường mỗi process chạy hoặc sử dụng user-mode hoặc kernel-mode. KVM đưa ra một chế độ thứ 3, đó là guest-mode. Nó dựa trên CPU có khả năng ảo hóa với kiến trúc Intel VT hoặc AMD SVM, một process trong guest-mode bao gồm cả kernel-mode và user-mode.

#### Quản lý nguồn tài nguyên

Các nhà phát triển KVM hướng tới tái sử dụng nhiều mã nguồn có thể. Do đó họ chủ yếu sửa đổi việc sửa đổi việc quản lý bộ nhớ Linux cho phép ánh xạ bộ nhớ vật lý vào không gian địa chỉ ảo. Do đó họ bổ sung thêm các bảng shadow, điều này rất cần thiết trong những ngày đầu của ảo hóa x86, khi Intel và AMD không phát hành EPT tương ứng với NPT.

Trong những hệ điều hành hiện nay, có rất nhiều process hơn so với số CPU sẵn có để chạy chúng. Việc lập lịch (scheduler) của một hệ điều hành để đưa ra 1 trật tự cho mỗi process được giao cho một trong những CPU sẵn có. Bằng cách này tất cả các process đang chạy sẽ chia sẻ thời gian tính toán. Kể từ khi các nhà phát triển KVM muốn tái sử dụng hầu hết các cơ chế của Linux, họ đơn giản chỉ hướng đến mỗi máy ảo như một process, dựa vào đó lập lịch gán sức mạnh tính toán cho các máy ảo.

#### Giao diện điều khiển 

Một khi modul nhân KVM được load vào, node /dev/kvm sẽ được sinh ra trong hệ thống tập tin linux. Đây là một node đặc biệt, nó cho phép kiểm soát hypervisor thông qua một tập hợp các ipctls. Nó được sử dụng trong hệ điều hành như một interface cho các process đang chạy trong user-guest để giao tiếp với drive. Ioctl() gọi hệ thống cho phép thực hiện một số hoạt động để tạo ra các máy ảo mới, phân chia bộ nhớ cho máy ảo, phân chia và khởi động các CPU ảo.

#### Mô phỏng phần cứng

Để cung cấp phần cứng như ổ đĩa cứng, ổ đĩa CD hay card mạng cho máy ảo, KVM sử dụng QEMU. Đây là tên gọi của một công cụ nền tảng ảo hóa, cho phép giả lập toàn bộ một nền tảng máy tính bao gồm đồ họa, mạng, ổ đĩa và nhiều hơn nữa. Mỗi một máy ảo khởi động một process QEMU được bắt đầu dưới chế độ user và kèm theo đó là các thiết bị được mô phỏng. Khi một máy ảo thực hiện I/O, nó bị chặn bởi KVM và chuyển hướng đến các quá trình liên quan đến QEMU cho khách.

<a name=mohinh></a>
#### 2.2 Mô hình thực hiện.

Hình dưới đây mô tả mô hình thực hiện của KVM. Đây là một vòng lặp của các hành động diễn ra để vận hành các máy ảo. Những hành động này được phân cách bằng 3 phương thức chúng ta đã đề cập trước đó: user-mode, kernel-mode, guest-mode.

<img src="https://opencloudvn.files.wordpress.com/2014/03/screenshot-from-2014-03-31-214311.png?w=291&h=300">

Như ta thấy:

- User-mode: Các modul KVM gọi đến sử dụng ioclt() để thực thi mã khách cho đến khi hoạt động I/O khởi xướng bởi guest hoặc một sự kiện nào đó bên ngoài xảy ra. Sự kiện này có thể là sự xuất hiện của một gói tin mạng, cũng có thể là trả lời của một gói tin mạng được gửi bởi các may chủ trước đó. Những sự kiện như vậy được biểu diễn như là tín hiệu dẫn đến sự gián đoạn của thực thi mã khách.


- Kernel-mode: Kernel làm phần cứng thực thi các mã khách tự nhiên. Nếu bộ xử lý thoát khỏi guest do cấp phát bộ nhớ hay I/O hoạt động, kernel thực hiện các nhiệm vụ cần thiết và tiếp tục luồng thực hiện, Nếu các sự kiện bên ngoài như tín hiệu hoặc I/O hoạt động khởi xướng bởi các guest tồn tại, nó thoát tới user-mode.


- Guest-mode: Đây là cấp độ phần cứng, nơi mà các lệnh mở rộng thiết lập của một CPU có khả năng ảo hóa được sử dụng để thực thi mã nguồn gốc, cho đến khi một lệnh được gọi như vậy cần sự hỗ trợ của KVM, một lỗi hoặc một gián đoạn từ bên ngoài.



Khi một máy ảo chạy, có rất nhiều chuyển đổi giữa các chế độ. Từ kernel-mode tới guest-mode và ngược lại rất nhanh, bởi vì chỉ có mã nguồn gốc được thực hiện trên phần cứng cơ bản. Khi I/O hoạt động diễn ra các luồng thực thi tới user-mode, rất nhiều thiết bị ảo I/O được tạo ra, do vậy rất nhiều I/O thoát ra và chuyển sang chế độ user-mode chờ. Hãy tưởng tượng mô phỏng một đĩa cứng và 1 guest đang đọc các block từ nó. Sau đó QEMU mô phỏng các hoạt động bằng cách giả lập các hoạt động bằng các mô phỏng hành vi của các ổ đĩa cứng và bộ điều khiển nó được kết nối. Để thực hiện các hoạt động đọc, nó đọc các khối tương ứng từ một tập tin lớp và trả về dữ liệu cho guest. Vì vậy, user-mode giả lập I/O có xu hướng xuất hiện một nút cổ chai làm chậm việc thực hiện máy ảo.
<a name=stack></a>
#### 2.3 KVM stack


<img src="http://i.imgur.com/r7tPZ8y.png">

Trên đây là KVM Stack bao gồm 4 tầng:

- User-facing tools: Là các công cụ quản lý máy ảo hỗ trợ KVM. Các công cụ có giao diện đồ họa (như virt-manager) hoặc giao diện dòng lệnh như (virsh)
- Management layer: Lớp này là thư viện libvirt cung cấp API để các công cụ quản lý máy ảo hoặc các hypervisor tương tác với KVM thực hiện các thao tác quản lý tài nguyên ảo hóa, vì tự thân KVM không hề có khả năng giả lập và quản lý tài nguyên như vậy.
- Virtual machine: Chính là các máy ảo người dùng tạo ra. Thông thường, nếu không sử dụng các công cụ như virsh hay virt-manager, KVM sẽ sử được sử dụng phối hợp với một hypervisor khác điển hình là QEMU.
- Kernel support: Chính là KVM, cung cấp một module làm hạt nhân cho hạ tầng ảo hóa (kvm.ko) và một module kernel đặc biệt hỗ trợ các vi xử lý VT-x hoặc AMD-V (kvm-intel.ko hoặc kvm-amd.ko)
<a name=qemu></a>
### 3. KVM-QEMU
Nhắc đến các phần mềm máy ảo, người ta thường nhắc đến VMWare và Virtual PC. Có một phần mềm nhỏ gọn và miễn phí và tính năng không kém là qemu.

Hệ thống ảo hóa KVM hay đi liền với QEMU. Về mặt bản chất, QEMU đã là một hypervisor hoàn chỉnh và là hypervisor loại 2. QEMU có khả năng giả lập tài nguyên phần cứng, trong đó bao gồm một CPU ảo. Các chỉ dẫn của hệ điều hành tác động lên CPU ảo này sẽ được QEMU chuyển đổi thành chỉ dẫn lên CPU vật lý nhờ một translator là TCG(Tiny Core Generator). Các hypervisor loại 2 khác như VMWare cũng có các bộ chuyển đổi tương tự, và bản thân các bộ dịch này hiệu suất không lớn. 
Do KVM hỗ trợ ánh xạ CPU vật lý sang CPU ảo, cung cấp khả năng tăng tốc phần cứng cho máy ảo và hiệu suất của nó nên QEMU sử dụng KVM làm accelerator tận dụng tính năng này của KVM thay vì sử dụng TCG.

##### Mô hình KVM & QEMU

<img src="http://cloudgeekz.com/wp-content/uploads/2014/11/Clipboard023.jpg">



<a name=tinhnang></a>
### 4. Các tính năng của KVM

#### 4.1. Security

Trong kiến trúc KVM, máy ảo được xem như các tiến trình Linux thông thường, nhờ đó nó tận dụng được mô hình bảo mật của hệ thống Linux như SELinux, cung cấp khả năng cô lập và kiểm soát tài nguyên. 
Bên cạnh đó còn có SVirt project - dự án cung cấp giải pháp bảo mật MAC (Mandatory Access Control - Kiểm soát truy cập bắt buộc) tích hợp với hệ thống ảo hóa sử dụng SELinux để cung cấp một cơ sở hạ tầng cho phép người quản trị định nghĩa nên các chính sách để cô lập các máy ảo. Nghĩa là SVirt sẽ đảm bảo rằng các tài nguyên của máy ảo không thể bị truy cập bởi bất kì các tiến trình nào khác; việc này cũng có thể thay đổi bởi người quản trị hệ thống để đặt ra quyền hạn đặc biệt, nhóm các máy ảo với nhau chia sẻ chung tài nguyên.

#### 4.2. Memory Management

KVM thừa kế tính năng quản lý bộ nhớ mạnh mẽ của Linux. Vùng nhớ của máy ảo được lưu trữ trên cùng một vùng nhớ dành cho các tiến trình Linux khác và có thể swap. KVM hỗ trợ NUMA (Non-Uniform Memory Access - bộ nhớ thiết kế cho hệ thống đa xử lý) cho phép tận dụng hiệu quả vùng nhớ kích thước lớn. 
KVM hỗ trợ các tính năng ảo của mới nhất từ các nhà cung cấp CPU như EPT (Extended Page Table) của Microsoft, Rapid Virtualization Indexing (RVI) của AMD để giảm thiểu mức độ sử dụng CPU và cho thông lượng cao hơn. 
KVM cũng hỗ trợ tính năng Memory page sharing bằng cách sử dụng tính năng của kernel là Kernel Same-page Merging (KSM).

#### 4.3. Storage

KVM có khả năng sử dụng bất kỳ giải pháp lưu trữ nào hỗ trợ bởi Linux để lưu trữ các Images của các máy ảo, bao gồm các ổ cục bộ như IDE, SCSI và SATA, Network Attached Storage (NAS) bao gồm NFS và SAMBA/CIFS, hoặc SAN thông qua các giao thức iSCSI và Fibre Channel. 
KVM tận dụng được các hệ thống lưu trữ tin cậy từ các nhà cung cấp hàng đầu trong lĩnh vực Storage. 
KVM cũng hỗ trợ các images của các máy ảo trên hệ thống tệp tin chia sẻ như GFS2 cho phép các images có thể được chia sẻ giữa nhiều host hoặc chia sẻ chung giữa các ổ logic.

#### 4.4. Live migration

KVM hỗ trợ live migration cung cấp khả năng di chuyển ác máy ảo đang chạy giữa các host vật lý mà không làm gián đoạn dịch vụ. Khả năng live migration là trong suốt với người dùng, các máy ảo vẫn duy trì trạng thái bật, kết nối mạng vẫn đảm bảo và các ứng dụng của người dùng vẫn tiếp tục duy trì trong khi máy ảo được đưa sang một host vật lý mới. KVM cũng cho phép lưu lại trạng thái hiện tại của máy ảo để cho phép lưu trữ và khôi phục trạng thái đó vào lần sử dụng tiếp theo.

#### 4.5. Performance and scalability

KVM kế thừa hiệu năng và khả năng mở rộng của Linux, hỗ trợ máy ảo với 16 CPUs ảo, 256GB RAM và hệ thống máy host lên tới 256 cores và trên 1TB RAM.











