# Hướng dẫn tạo máy ảo trên VMWare Workstation 12

## Mục lục
[1. Tổng quan về VMWare Workstation](#tong-quan)

[2. Cách tạo máy ảo trên VMWare Workstation](#huong-dan)

[3. Một số lưu ý trong phần Settings](#luu-y)

-----
### <a name = "tong-quan"></a> 1. Tổng quan về VMWare Workstation
- VMware Workstation là một phần mềm ảo hóa desktop mạnh mẽ dành cho các nhà phát triển/kiểm tra
phần mềm và các chuyên gia IT cần chạy nhiều HĐH một lúc trên một máy PC. 
- Người dùng có thể chạy các HĐH Windows, Linux, Netware hay Solaris x86 trên các máy ảo di động mà không cần phải khởi
động lại hay phân vùng ổ cứng.
- VMware Workstation cung cấp khả năng hoạt động tuyệt vời và nhiều
tính năng mới như tối ưu hóa bộ nhớ và khả năng quản lý các thiết lập nhiều lớp. 
- Các tính năng thiết yếu
như mạng ảo, chụp ảnh nhanh trực tiếp, kéo thả, chia sẻ thư mục và hỗ trợ PXE khiến VMware
Workstation trở thành công cụ mạnh mẽ nhất và không thể thiếu cho các nhà doanh nghiệp phát triển tin
học và các nhà quản trị hệ thống.
- VMware Workstation họat động bằng cách cho phép nhiều HĐH và các ứng dụng của chúng chạy đồng
thời trên một máy duy nhất. Các HĐH và ứng dụng này được tách ra vào trong các máy ảo. Những máy
ảo này cùng tồn tại trên một phần cứng duy nhất. Các layer ảo của VMware sẽ kết nối các phần cứng vật
lý với các máy ảo, do đó mỗi máy ảo sẽ có CPU, bộ nhớ, các ổ đĩa, thiết bị nhập/xuất riêng.
- Giao diện của VMware Workstation 12
<img src ="http://i.imgur.com/vutiPzg.png">

### <a name = "huong-dan"></a> 2. Cách tạo máy ảo trên VMware Workstation

- Bước 1: Trên màn hình chính, chọn `Create a new Virtual Machine` để tạo máy ảo mới
<img src = "http://i.imgur.com/q7kvhfF.png">

Tại đây ta thấy có 2 lựa chọn là `Typical` và `Custom`. `Typical` là cài đặt theo những tùy chọn mặc định, `Custom` là tùy chỉnh theo ý người dùng.
Ở đây tôi chọn `Custom`.

- Bước 2: Lựa chọn ổ đĩa.
<img src = "http://i.imgur.com/d3thGkA.png">

- Ở đây có 3 lựa chọn:
  <ul>
  <li>Cài đặt từ ổ đĩa</li>
  <li>Cài đặt từ file .iso</li>
  <li>Cài đặt sau (Phần cứng trống)</li>
  </ul>

Tôi lựa chọn cài sau.

- Bước 3: Lựa chọn hệ điều hành và phiên bản.
<img src = "http://i.imgur.com/vT0Q7ie.png">
Ở đây tôi chọn Linux với hệ điều hành Ubuntu 64 bit.

- Bước 4: Đặt tên và lựa chọn vị trí lưu máy ảo trên máy tính.
<img src = "http://i.imgur.com/LvimHoQ.png">

- Bước 5: Lựa chọn số nhân và số lõi cpu cho máy ảo
<img src = "http://i.imgur.com/6G8Y40D.png">

Ở đây tôi chọn mặc định là 1 processor.

- Bước 6: Lựa chọn RAM cho máy ảo. 
<img src = "http://i.imgur.com/ImmXXPA.png">

Tùy theo cấu hình máy thật mà người dùng có thể lựa chọn RAM tối đa. Ở đây tôi chọn mức 2 GB.

- Bước 7: Lựa chọn card mạng cho máy ảo
<img src = "http://i.imgur.com/re4pcKk.png">

Ở đây sẽ có 4 tùy chọn:
- Card Bridge: Card này sẽ sử dụng chính card mạng thật của máy để kết nối ra ngoài internet(card ethernet hoặc wireless). 
Do đó khi sử dụng card mạng này IP của máy ảo sẽ cùng với dải IP của máy thật. 
Lưu ý: Card Bridge trên máy ảo chỉ có thể giao tiếp với card mạng thật trên máy thật.
- Card NAT: Card này sẽ Nat địa chỉ IP của máy thật ra một địa chỉ khác cho máy ảo sử dụng.
  <ul>
  <li>Card NAT chỉ có thể giao tiếp với card mạng ảo VMnet8 trên máy thật.</li>
  <li>Card NAT chỉ có thể giao tiếp với các card NAT trên các máy ảo khác.</li>
  <li>Card NAT không thể giao tiếp với mạng vật lý mà máy tính thật đang kết nối. 
    Tuy nhiên nhờ cơ chế NAT được tích hợp trong VMWare, máy tính ảo có thể gián tiếp liên lạc với mạng vật lý bên ngoài.</li>
  </ul>
- Card Host-only:
  <ul>
  <li>Card Host-only chỉ có thể giao tiếp với card mạng ảo VMnet1 trên máy thật.</li>
  <li>Card Host-only chỉ có thể giao tiếp với các card Host-only trên các máy ảo khác.</li>
  <li>Card Host-only không thể giao tiếp với mạng vật lý mà máy tính thật đang kết nối.</li>
  </ul>
- Lựa chọn cuối cùng đó là không cấu hình kết nối mạng.
Ở đây tôi chọn NAT.

- Bước 8: Lựa chọn I/O Controller Types
<img src = "http://i.imgur.com/GpeXQnV.png">
Ở đây có 3 tùy chọn là BusLogic (không khả dụng ở những phiên bản hệ điều hành 64bit), LSI Logic và LSI Logic SAS.
Mặc định VMWare sẽ lựa chọn LSI Logic do nó được support rộng rãi hơn ở các phiên bản hệ điều hành. Ở đây tôi để mặc định.

- Bước 9: Lựa chọn kiểu ổ đĩa cho máy ảo
<img src = "http://i.imgur.com/6eJmLHJ.png">
Ở đây có 3 lựa chọn:
IDE, SCSI và SATA. Thực tế cho thấy rằng sự khác biệt giữa chúng không quá lớn do những giới hạn của máy thật. 
VMWare mặc định chọn SCSI bởi nó được cho là có hiệu năng tốt hơn. Ở đây tôi để mặc định.

- Bước 10: Lựa chọn ổ đĩa cho máy ảo.
<img src = "http://i.imgur.com/8yXDDUl.png">

- Tại đây có 3 lựa chọn:
  <ul>
  <li>Create a new virtual disk: Tạo mới một ổ đĩa ảo.</li>
  <li>Use an existing virtual disk: Dùng lại ổ đĩa ảo đã được tạo.</li>
  <li>Use a physical disk: Cho phép máy ảo truy cập vào ổ đĩa thật.</li>
  </ul>
  
Ở đây tôi chọn mặc định là tạo mới một ổ đĩa ảo.

- Bước 11: Thiết lập dung lượng cho ổ cứng
<img src = "http://i.imgur.com/MrhA27x.png">
Tại đây người dùng có thể lựa chọn dung lượng tối đa cho ổ cứng. VMWare cũng cho bạn lựa chọn sử dụng tất cả những dung lượng trống (Allocate all disk space now).
Ngoài ra, bạn cũng có 2 tùy chọn đó là lưu ổ cứng thành 1 file (Store a virtual disk as a single file)
hoặc nhiều file (Split virtual disk into multiple file).
Tại đây tôi chọn dung lượng là 20GB và phân chia ổ cứng thành nhiều file.

- Bước 12: Lựa chọn nơi lưu file ổ cứng
<img src = "http://i.imgur.com/2SYMAEX.png">

- Bước 13: Hoàn thành việc tạo máy ảo
Chọn `Customize Hardware` để tùy chỉnh những lựa chọn về phần cứng hoặc click `Finish` để hoàn thành việc tạo máy ảo.
<img src = "http://i.imgur.com/VEAqSdb.png">

Sau khi Finish. Bạn cũng có thể lựa chọn vào `Settings` để tùy chỉnh những cài đặt phần cứng như ổ đĩa, card mạng...

### <a name = "luu-y"></a> 3. Một số lưu ý trong phần Settings:
- Tại phần `Processor`, ngoài việc tùy chỉnh số processor, VMware cũng cho phép người dùng chỉnh sửa công nghệ ảo hóa.
Cụ thể tại phần `Prefer mode` có 4 tùy chọn đó là:
  <ul>
  <li>Automatic: Chế độ mặc định, cho phép VMware lựa chọn tự động tùy chọn ảo hóa phù hợp nhất với máy ảo</li>
  <li>Binary translation: Một kĩ thuật ảo hóa cho kiến trúc x86, cho phép những dòng lệnh cũng như mã máy chưa được ảo hóa được trình biên dịch nhị phân chuyển đổi thành mã an toàn. Đây là công nghệ ảo hóa phần mềm.</li>
  <li>Intel VT-x or AMD-V: Công nghệ hỗ trợ ảo hóa của CPU Intel, những con CPU được thiết kế để hỗ trợ người dùng tối đa trong việc tạo máy ảo. Đây là công nghệ ảo hóa phần cứng</li>
  <li>Intel VT-x/EPT or AMD-V/RVI: Extended Page Tables là phần nâng cấp thêm (phần mở rộng) để hỗ trợ cho việc theo dõi địa chỉ bộ nhớ MMU (Memory Management Unit)</li>
  </ul> 

- Ngoài ra, người dùng cũng có 3 tùy chọn nữa, đó là:
  <ul>
  <li>Disable acceleration for binary translation: Bỏ qua việc biên dịch nhanh, điều này đồng nghĩa với việc mọi thứ sẽ được chạy qua trình biên dịch nhị phân</li>
  <li>Virtualize Intel VT-x/EPT or AMD-V/RVI: Chỉ chọn nếu bạn muốn ảo hóa trên nền tảng ảo hóa, ví dụ như việc cài ESXi lên VMWare</li>
  <li>Virtualize CPU performance counters: Chỉ chọn nếu bạn chạy các ứng dụng có yêu cầu truy cập vào CPU performance counters</li>
  </ul>
  
- Tại phần `Network Adapter`, người dùng cũng có thể thêm vào các card mạng. Tại đây có 4 tùy chọn chính đó là Bridged, NAT, Host-only và Custom. 
Mặc định Bridged sẽ là VMnet0, NAT là VMnet8 và Host-only là VMnet1.
- Sự khác biệt giữa VMnetNAT và NAT:
  <ul>
  <li>Ở chế độ NAT thì card mạng của máy ảo kết nối trực tiếp với VMnet8, VMnet8 cho phép máy ảo đi internet thông qua cơ chế NAT (NAT device). Lúc này lớp mạng bên trong máy ảo khác hẳn với lớp mạng của card vật lý bên ngoài. IP của card mạng sẽ được cấp bởi DHCP VMnet8 cấp, trong trường hợp bạn     muốn thiết lập IP tĩnh cho card mạng máy ảo bạn phải đảm bảo chung lớp mạng với VNnet8 thì máy ảo mới có thể đi internet.</li>
  <li>Còn ở chế độ VMnetNAT, tức là khi chọn Custom, lúc này nếu chế độ NAT nếu được chuyển sang 1 card mạng khác(ví dụ VMnet1), thì VMnet1 sẽ kết nối tới VMnet8 mặc định(VMnet8 kết nối mặc định tới NAT device).</li>
  </ul>

**Phân biệt Thin và Thick Provisioning**
- Thin Provision: Khi bạn tạo ổ đĩa với Thin Provision, VM chỉ chiếm đúng dung lượng mà nó đang lưu trữ. Giả sử bạn tạo một máy ảo 500GB,
 và dữ liệu trong đó chiếm 100GB thì khoảng trống còn lại sẽ không được định dạng sẵn và các máy khác có thể dùng. Điều này giúp ta tiết 
 kiệm không gian đĩa trống, tránh tạo ra những virtual disk mà không sử dụng hết. Mặc dù vậy, nhược điểm của Thin Provision đó là hiệu suất
 không được cao.
 - Thick Provision: Giả sử bạn tạo VM 500 GB, chứa 100GB dữ liệu thì file Disk VMDK được tạo ra có đúng 500GB, phần 400GB còn lại được định
 dạng sẵn là pre-zero khiến nó sẵn sàng để VM đó sử dụng sau này, nhờ vậy mà hiệu suất cao hơn rất nhiều so với Thin Provision.
