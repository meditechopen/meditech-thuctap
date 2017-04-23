# Tìm hiểu KVM

## Mục lục

### [1. Khái niệm và vai trò](#vai-tro)

### [2. Cấu trúc](#cau-truc)

### [3. Mô hình triển khai](#mo-hinh)

### [4. Cơ chế hoạt động](#co-che)

### [5. Tính năng](#tinh-nang)

-------

### <a name = "vai-tro"></a> 1. Khái niệm và vai trò.

- KVM (Kernel-based virtual machine) là giải pháp ảo hóa cho hệ thống linux trên nền tảng phần cứng x86 có các module mở rộng hỗ trợ ảo hóa (Intel VT-x hoặc AMD-V). 
Về bản chất, KVM không thực sự là một hypervisor có chức năng giải lập phần cứng để chạy các máy ảo. 
Chính xác KVM chỉ là một module của kernel linux hỗ trợ cơ chế mapping các chỉ dẫn trên CPU ảo (của guest VM) 
sang chỉ dẫn trên CPU vật lý (của máy chủ chứa VM). 
Hoặc có thể hình dung KVM giống như một driver cho hypervisor để sử dụng được tính năng ảo hóa của các vi xử lý như Intel VT-x 
hay AMD-V, mục tiêu là tăng hiệu suất cho guest VM.

- KVM ban đầu được phát triển bởi Qumranet – một công ty nhỏ, sau đó được Redhat mua lại vào tháng 9 năm 2008. 
Ta có thể thấy KVM là thế hệ tiếp theo của công nghệ ảo hóa. KVM được sử dụng mặc định từ bản RHEL (Redhat Enterprise Linux) 
từ phiên bản 5.4 và phiên bản Redhat Enterprise Virtualization dành cho Server.

- Qumranet phát hành mã của KVM cho cộng đồng mã nguồn mở. Hiện nay, các coog ty nổi tiếng như IBM, 
Intel và ADM cũng đã cộng tác với dự án. Từ phiên bản 2.6.20, KVM trở thành một phần của hạt nhân Linux.


- Bảng so sánh KVM với VMWare:

<img src="http://i.imgur.com/SRDtP40.png">

### <a name = "cau-truc"></a> 2. Cấu trúc của KVM

- Trong kiến trúc KVM, máy ảo là một tiến trình Linux, được lập lịch bởi chuẩn Linux scheduler. 
Trong thực tế mỗi CPU ảo xuất hiện như là một tiến trình Linux. Điều này cho phép KVM sử dụng tất cả các tính năng của Linux kernel.
- Cấu trúc tổng quan:

<img src ="http://i.imgur.com/rnvsnoJ.png">

- Linux có tất cả các cơ chế của một VMM cần thiết để vận hành (chạy) các máy ảo. 
Chính vì vậy các nhà phát triển không xây dựng lại mà chỉ thêm vào đó một vài thành phần để hỗ trợ ảo hóa. 
KVM được triển khai như một module hạt nhân có thể được nạp vào để mở rộng Linux bởi những khả năng này.
- Trong một môi trường linux thông thường mỗi process chạy hoặc sử dụng user-mode hoặc kernel-mode. 
KVM đưa ra một chế độ thứ 3, đó là guest-mode. Nó dựa trên CPU có khả năng ảo hóa với kiến trúc Intel VT hoặc AMD SVM, 
một process trong guest-mode bao gồm cả kernel-mode và user-mode.

**Trong cấu trúc tổng quan của KVM bao gồm 3 thành phần chính:**
- KVM kernel module: 
  <ul>
  <li>là một phần trong dòng chính của Linux kernel.</li>
  <li>cung cấp giao diện chung cho Intel VMX và AMD SVM (thành phần hỗ trợ ảo hóa phần cứng)</li>
  <li>chứa những mô phỏng cho các instructions và CPU modes không được support bởi Intel VMX và AMD SVM</li>
  </ul>
- quemu - kvm: là chương trình dòng lệnh để tạo các máy ảo, thường được vận chuyển dưới dạng các package "kvm" hoặc "qemu-kvm".
  Có 3 chức năng chính:
  <ul>
  <li>Thiết lập VM và các thiết bị ra vào (input/output)</li>
  <li>Thực thi mã khách thông qua KVM kernel module</li>
  <li>Mô phỏng các thiết bị ra vào (I/O) và di chuyển các guest từ host này sang host khác</li>
  </ul>
- libvirt management stack:
  <ul>
  <li>cung cấp API để các tool như virsh có thể giao tiếp và quản lí các VM</li>
  <li>cung cấp chế độ quản lí từ xa an toàn</li>
  </ul>
### <a name ="mo-hinh"></a> 3. Mô hình triển khai
- Hình dưới đây mô tả mô hình thực hiện của KVM. Đây là một vòng lặp của các hành động diễn ra để vận hành các máy ảo. 
Những hành động này được phân cách bằng 3 phương thức chúng ta đã đề cập trước đó: user-mode, kernel-mode, guest-mode.

<img src="http://i.imgur.com/wG8E4s8.png">

Như ta thấy:

- User-mode: Các modul KVM gọi đến sử dụng ioclt() để thực thi mã khách cho đến khi hoạt động I/O khởi xướng bởi guest hoặc một 
sự kiện nào đó bên ngoài xảy ra. Sự kiện này có thể là sự xuất hiện của một gói tin mạng, cũng có thể là trả lời của một gói tin 
mạng được gửi bởi các may chủ trước đó. Những sự kiện như vậy được biểu diễn như là tín hiệu dẫn đến sự gián đoạn của thực thi mã khách.
- Kernel-mode: Kernel làm phần cứng thực thi các mã khách tự nhiên. Nếu bộ xử lý thoát khỏi guest do cấp phát bộ nhớ hay I/O hoạt động, 
kernel thực hiện các nhiệm vụ cần thiết và tiếp tục luồng thực hiện, Nếu các sự kiện bên ngoài như tín hiệu hoặc I/O hoạt động khởi 
xướng bởi các guest tồn tại, nó thoát tới user-mode.
- Guest-mode: Đây là cấp độ phần cứng, nơi mà các lệnh mở rộng thiết lập của một CPU có khả năng ảo hóa được sử dụng để thực thi mã 
nguồn gốc, cho đến khi một lệnh được gọi như vậy cần sự hỗ trợ của KVM, một lỗi hoặc một gián đoạn từ bên ngoài.

- Khi một máy ảo chạy, có rất nhiều chuyển đổi giữa các chế độ. Từ kernel-mode tới guest-mode và ngược lại rất nhanh, 
bởi vì chỉ có mã nguồn gốc được thực hiện trên phần cứng cơ bản. Khi I/O hoạt động diễn ra các luồng thực thi tới user-mode, 
rất nhiều thiết bị ảo I/O được tạo ra, do vậy rất nhiều I/O thoát ra và chuyển sang chế độ user-mode chờ. 
Hãy tưởng tượng mô phỏng một đĩa cứng và 1 guest đang đọc các block từ nó. Sau đó QEMU mô phỏng các hoạt động bằng cách giả 
lập các hoạt động bằng các mô phỏng hành vi của các ổ đĩa cứng và bộ điều khiển nó được kết nối. Để thực hiện các hoạt động đọc, 
nó đọc các khối tương ứng từ một tập tin lớp và trả về dữ liệu cho guest. Vì vậy, user-mode giả lập I/O có xu hướng xuất hiện một 
nút cổ chai làm chậm việc thực hiện máy ảo.

### <a name ="co-che"></a> 4. Cơ chế hoạt động

- Để các máy ảo giao tiếp được với nhau, KVM sử dụng Linux Bridge và OpenVSwitch, đây là 2 phần mềm cung cấp các giải pháp ảo hóa network.
Trong bài này, tôi sẽ sử dụng Linux Bridge.
- Linux bridge là một phần mềm đươc tích hợp vào trong nhân Linux để giải quyết vấn đề ảo hóa phần network trong các máy vật lý. 
Về mặt logic Linux bridge sẽ tạo ra một con switch ảo để cho các VM kết nối được vào và có thể nói chuyện được với nhau cũng như sử 
dụng để ra mạng ngoài.
- Cấu trúc của Linux Bridge khi kết hợp với KVM - QEMU.

<img src = "http://i.imgur.com/Krk1JRm.png">

- Ở đây:
  <ul>
  <li>Bridge: tương đương với switch layer 2</li>
  <li>Port: tương đương với port của switch thật</li>
  <li>Tap (tap interface): có thể hiểu là giao diện mạng để các VM kết nối với bridge cho linux bridge tạo ra</li>
  <li>fd (forward data): chuyển tiếp dữ liệu từ máy ảo tới bridge</li>
  </ul>

- Các tính năng chính:
  <ul>
  <li>STP: Spanning Tree Protocol - giao thức chống lặp gói tin trong mạng</li>
  <li>VLAN: chia switch (do linux bridge tạo ra) thành các mạng LAN ảo, cô lập traffic giữa các VM trên các VLAN khác nhau của cùng một switch.</li>
  <li>FDB (forwarding database): chuyển tiếp các gói tin theo database để nâng cao hiệu năng switch. 
  Database lưu các địa chỉ MAC mà nó học được. Khi gói tin Ethernet đến, bridge sẽ tìm kiếm trong database có chứa MAC address không. 
  Nếu không, nó sẽ gửi gói tin đến tất cả các cổng.</li>
  </ul>


### <a name ="tinh-nang"></a> 5. Tính năng

#### Security

- Trong kiến trúc KVM, máy ảo được xem như các tiến trình Linux thông thường, nhờ đó nó tận dụng được mô hình bảo mật của hệ thống Linux như SELinux, cung cấp khả năng cô lập và kiểm soát tài nguyên. 
Bên cạnh đó còn có SVirt project - dự án cung cấp giải pháp bảo mật MAC (Mandatory Access Control - Kiểm soát truy cập bắt buộc) tích hợp với hệ thống ảo hóa sử dụng SELinux để cung cấp một cơ sở hạ tầng cho phép người quản trị định nghĩa nên các chính sách để cô lập các máy ảo. Nghĩa là SVirt sẽ đảm bảo rằng các tài nguyên của máy ảo không thể bị truy cập bởi bất kì các tiến trình nào khác; việc này cũng có thể thay đổi bởi người quản trị hệ thống để đặt ra quyền hạn đặc biệt, nhóm các máy ảo với nhau chia sẻ chung tài nguyên.

#### Memory Management

- KVM thừa kế tính năng quản lý bộ nhớ mạnh mẽ của Linux. Vùng nhớ của máy ảo được lưu trữ trên cùng một vùng nhớ dành cho các tiến trình Linux khác và có thể swap. KVM hỗ trợ NUMA (Non-Uniform Memory Access - bộ nhớ thiết kế cho hệ thống đa xử lý) cho phép tận dụng hiệu quả vùng nhớ kích thước lớn. 
KVM hỗ trợ các tính năng ảo của mới nhất từ các nhà cung cấp CPU như EPT (Extended Page Table) của Microsoft, Rapid Virtualization Indexing (RVI) của AMD để giảm thiểu mức độ sử dụng CPU và cho thông lượng cao hơn. 
KVM cũng hỗ trợ tính năng Memory page sharing bằng cách sử dụng tính năng của kernel là Kernel Same-page Merging (KSM).

#### Storage

- KVM có khả năng sử dụng bất kỳ giải pháp lưu trữ nào hỗ trợ bởi Linux để lưu trữ các Images của các máy ảo, bao gồm các ổ cục bộ như IDE, SCSI và SATA, Network Attached Storage (NAS) bao gồm NFS và SAMBA/CIFS, hoặc SAN thông qua các giao thức iSCSI và Fibre Channel. 
KVM tận dụng được các hệ thống lưu trữ tin cậy từ các nhà cung cấp hàng đầu trong lĩnh vực Storage. 
KVM cũng hỗ trợ các images của các máy ảo trên hệ thống tệp tin chia sẻ như GFS2 cho phép các images có thể được chia sẻ giữa nhiều host hoặc chia sẻ chung giữa các ổ logic.

#### Live migration

- KVM hỗ trợ live migration cung cấp khả năng di chuyển ác máy ảo đang chạy giữa các host vật lý mà không làm gián đoạn dịch vụ. Khả năng live migration là trong suốt với người dùng, các máy ảo vẫn duy trì trạng thái bật, kết nối mạng vẫn đảm bảo và các ứng dụng của người dùng vẫn tiếp tục duy trì trong khi máy ảo được đưa sang một host vật lý mới. KVM cũng cho phép lưu lại trạng thái hiện tại của máy ảo để cho phép lưu trữ và khôi phục trạng thái đó vào lần sử dụng tiếp theo.

#### Performance and scalability

- KVM kế thừa hiệu năng và khả năng mở rộng của Linux, hỗ trợ máy ảo với 16 CPUs ảo, 256GB RAM và hệ thống máy host lên tới 256 cores và trên 1TB RAM.

