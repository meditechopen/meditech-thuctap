# VMware
### Mục lục
[I.Giới thiệu](#gioithieu)

[II.Ưu và nhược điểm](#uuvanhuoc)
- [2.1 Ưu điểm](#uudiem)
- [2.2 Nhược điểm](#nhuocdiem)

[III.Hướng dẫn cài đặt VMware](#caidat)
- [3.1 Trên Windows](#trenwindows)
<ul>
<li>  [3.1.1 Cài đặt chương trình trên Windows](#ctwindows)</li>
<li>  [3.1.2 Cài đặt một hệ điều hành trên Windows](#hdhwindows)</li>
</ul>
- [3.2 Trên Linux](#trenlinux)
<ul>
<li>  [3.1.1 Cài đặt chương trình trên linux](#ctlinux)</li>
<li>  [3.1.2 Cài đặt một hệ điều hành trên linux](#hdhlinux)</li>
</ul>

[IV. Cấu hình mở rộng của VMware](#cauhinhmorong)
- [4.1 Lưu trạng thái máy ảo với Snapshot](#snapshot)
- [4.2 Nhân bản máy ảo Clone](#clone)
- [4.3 Sử dụng VMware tool](#vmwaretool)

[V. Kết luận](#ketluan)

=============================
<a name="gioithieu"></a>
## I.Giới thiệu
`VMware Workstation` là một phần mềm ảo hóa desktop mạnh mẽ dành cho các nhà phát triển/kiểm tra phần mềm và các chuyên gia IT cần chạy nhiều HĐH một lúc trên một máy PC. Người dùng có thể chạy các HĐH Windows, Linux, Netware hay Solaris x86 trên các máy ảo di động mà không cần phải khởi động lại hay phân vùng ổ cứng. VMware Workstation cung cấp khả năng hoạt động tuyệt vời và nhiều tính năng mới như tối ưu hóa bộ nhớ và khả năng quản lý các thiết lập nhiều lớp. Các tính năng thiết yếu như mạng ảo, chụp ảnh nhanh trực tiếp, kéo thả, chia sẻ thư mục và hỗ trợ PXE khiến VMware Workstation trởthành công cụ mạnh mẽ nhất và không thể thiếu cho các nhà doanh nghiệp phát triển tin học và các nhà quản trị hệ thống.

VMware Workstation họat động bằng cách cho phép nhiều HĐH và các ứng dụng của chúng chạy đồng thời trên một máy duy nhất. Các HĐH và ứng dụng này được tách ra vào trong các máy ảo. Những máy ảo này cùng tồn tại trên một phần cứng duy nhất. Các layer ảo của VMware sẽ kết nối các phần cứng vật lý với các máy ảo, do đó mỗi máy ảo sẽ có CPU, bộnhớ, các ổ đĩa, thiết bị nhập/xuất riêng

Có 3 loại VMware :
-  *Vmware work station*
- *Vmware server*
- *Vmware vsphere*

Trong đó :

- Vmware work station và vmware server dùng cho desktop, nó là 1 chương trình ứng dụng chạy trên hệ điều hành window hoặc linux giúp cho chúng ta tạo ra máy ảo 1 cách dễ dàng nhằm mục đích thử nghiệm PC hay tần dụng tối đa hiệu năng của PC để làm được nhiều việc khác
- Vmware vsphere nó là 1 nền tảng giúp chúng ta có thể tạo ra hạ tầng điện toán đám mây, nó gồm có các bộ ảo hóa hay được sử dụng cho các doanh nghiệp, khác với vmware work station, vmware server thì vmware vsphere không được sử dụng trong các máy tính cá nhân mà nó được sự dụng để cài đặt trực tiếp trên các máy server (máy chủ)

<a name="uuvanhuoc"></a>
## II. Ưu và nhược điểm
<a name="uudiem"></a>

### 2.1 Ưu điểm

Việc dùng máy ảo có rất nhiều lợi ích mạng lại như :
<ul>
<li> Khả năng bảo mật, tính tiện dụng cao , nếu máy ảo bị trục trặc hoặc bị virus thì máy thật vẫn không bị ảnh hưởng.</li>
<li>Tận dụng được tài nguyên thừa của máy thật.</li>
<li> Thiết lập và cài đặt nhiều hệ điều hành trên 1 hệ điều hành ban đầu.Tạo môi trường thử nghiệm cho nhiều mục đích
</ul>

<a name="nhuocdiem"></a>
### 2.2 Nhược điểm

Bên cạnh những ưu điểm trên thì việc sử dụng máy ảo cũng có nhiều hạn chế :
<ul>
<li> Thông thường, mỗi máy ảo chỉ dùng một tập tin để lưu tất cả những gì diễn ra trong máy ảo. Do đó nếu bị mất tập tin này xem như mất tất cả.</li>
<li> Nếu máy tính có phần cứng thấp thì việc chạy thêm máy ảo sẽ bị chậm và không đáp ứng được nhu cầu sử dụng của người dùng.</li>
<li>Do các máy ảo đều được thiết lập trên một máy tính nên khi máy thật xảy ra lỗi như hỏng hóc thì  các máy ảo cũng bị ảnh hưởng theo.</li>

<a name="caidat"></a>
## III.Hướng dẫn cài đặt VMware

<a name="trenwindowns"></a>
### 3.1 Trên Windows

<a name="ctwindows"></a>
#### 3.1.1 Cài đặt chương trình trên Windows

- Bước 1 : Sau khi đã tải bản VMware Workstation mới nhất tại [Trang chủ VMware](http://www.vmware.com/products/player/playerpro-evaluation.html), Chúng ta bắt đầu tiến hành cài đặt :


    <img src=http://i.imgur.com/KJ9TK8g.png>

- Bước 2 : Sau đó bạn chọn `I accept the terms in the License Agreement` sau đó bạn nhấn Next để tiếp tục.


    <img src=http://i.imgur.com/RuML1ut.png>
- Bước 3 :Nhấn Next để tiếp tục.


    <img src=http://i.imgur.com/L07a0iD.png>

- Bước 4 : Ở bước này bạn bỏ chọn 2 phần như trong hình sau đó nhấn Next để tiếp tục.


    <img src=http://i.imgur.com/Z2ZmPtI.png>

  Tích thứ nhất là kiểm tra cập nhật phiên bản khi máy tính khởi động.

  Tích thứ hai là gửi dữ liệu cho nhà sản xuất

- Bước 5 : Ở bước này ta chọn nơi lưu `shortcut`. Có thể chọn như hình


    <img src=http://i.imgur.com/t5IaObT.png>

- Bước 6 : Chọn `Install`


    <img src=http://i.imgur.com/HtF1SlH.png>

- Bước 7 : Chờ cài đặt


    <img src=http://i.imgur.com/p2dFGhf.png>

- Bước 8 :Quá trình cài đặt thành công nhấn `License` để kích hoạt phần mềm.


    <img src=http://i.imgur.com/2oSz1Uu.png>

- Bước 9 : Điền `Key` và chọn `Enter` để hoàn thành


    <img src=http://i.imgur.com/ckRDdPF.png>

- Bước 10 : Finish - Kết thúc cài đặt


    <img src=http://i.imgur.com/3pgLmZf.png>

<a name="hdhwindows"></a>
#### 3.1.2 Cài đặt một hệ điều hành trên Windows

Đầu tiên để cài một hệ điều hành thì chúng ta phải chuẩn bị một file iso của hệ điều hành muốn cài. Chúng ta có thể dowload từ trang chủ của các nhà cung cấp.
Ở bài này mình sẽ giới thiệu một số bước cơ bản để cài hệ điều hành windows 7 trên VMware
- Bước 1 : Khởi động phần mềm Vmware lên trên thanh công cụ ta chọn `File` tiếp đến ta chọn mục `New Vitrual Machine`.

<img src=http://i.imgur.com/jwero9N.png>

- Bước 2: Trong cửa sổ  `New Vitrual Machine Wizard` ta chọn mục `Custom (advanced)` sau đó nhấn `Next` để tiếp tục.

<img src=http://i.imgur.com/K7u35jF.png>

- Bước 3: Trong mục `Hardware compatibility` ta chọn phiên bản mới nhất là Workstation 12.0 sau đó nhấn Next để tiếp tục.

<img src=http://i.imgur.com/DfNfzj6.png>

- Bước 4: Ở phần tiếp theo ta chọn mục `Installer disc image file (iso)` sau đó  nhấn `Browse` và chọn đến file iso windows 7 đã download về.

<img src=http://i.imgur.com/2RilHK9.png>

- Bước 5:  Ở phần tiếp theo điền như sau:

<img src=http://i.imgur.com/gqGJGXX.png>

Phần `Windows product key` : điền key bản quyền windows vào nếu có. Nếu không có thì các bạn để trống.

Phần `Full name` : điền tên máy tính.

Phần `Password`: điền password windows nếu cần không thì bỏ trống.

Phần `Confirm`: điền lại password ở trên 1 lần nữa nếu ở trên không đặt password thì bỏ trống.



Sau khi điền xong các bạn nhấn `Next` để tiếp tục.

- Bước 6 : Khi bạn nhấn `Next` mà ở phần trước các bạn không điền mục `Windows product key` thì hộp thoại thông báo sẽ hiện ra các bạn chọn Do not show this message again sau đó nhấn `Yes` nếu đã điền key các bạn có thể bỏ qua bước này.

<img src=http://i.imgur.com/B1FzUp7.png>

- Bước 7: Ở phần này ở mục `Vitrual machine name` các bạn điền tên máy ảo và ở mục `Location` các bạn chọn `Browse` để chọn nơi lưu trữ máy ảo sau đó nhấn `Next` để tiếp tục.

<img src=http://i.imgur.com/CghQE0W.png>

- Bước 8: Trong phần `Frimware type` có 2 tùy chọn :

  `BIOS` thường dùng cho các hệ điều hành windows hoặc linux.

  `EFI` dành riêng cho hệ điều hành của Apple

  Ở đây ta cài hệ điều hành windows nên chọn BIOS và ấn Next.

<img src=http://i.imgur.com/nEupKw4.png>

- Bước 9: Trong mục `Processors` phần `Number of processors` (số nhân của cpu) và `Number of cores per processor` (số lõi trên cpu). Các bạn nên chọn ít nhân nhiều lõi để máy ảo hoạt động tốt hơn. Sau đó các bạn nhấn `Next` để tiếp tục.

<img src=http://i.imgur.com/d9iCjYd.png>

- Bước 10: Trong mục `Memory for Vitrual Machine` các bạn thiết lập RAM cho máy ảo trong phần `Memory for this vitrual machine` các bạn điền số RAM cho máy ảo mà bạn mong muốn hoặc dùng thanh kéo bên trái số  RAM được tính theo công thức `1GB = 1024 MB`. Sau đó nhấn `Next` để tiếp tục.

<img src=http://i.imgur.com/IA2LSbh.png>

- Bước 11: Ở mục `Network connection` các bạn chọn một trong các phần:

<img src=http://i.imgur.com/zoextMp.png>

`Use bridged Network`
  <li> Card Bridge trên máy ảo chỉ có thể giao tiếp với card mạng thật trên máy thật.</li>
  <li> Card mạng Bridge này có thể giao tiếp với mạng vật lý mà máy tính thật đang kết nối.</li>


`Use network address translation (NAT)`
  <li> Card NAT chỉ có thể giao tiếp với card mạng ảo VMnet8 trên máy thật.</li>
  <li> Card NAT chỉ có thể giao tiếp với các card NAT trên các máy ảo khác.</li>
  <li> Card NAT không thể giao tiếp với mạng vật lý mà máy tính thật đang kết nối. Tuy nhiên nhờ cơ chế NAT được tích hợp trong VMWare, máy tính ảo có thể gián tiếp liên lạc với mạng vật lý bên ngoài.</li>

`Use host-only Networking`
  <li> Card Host-only chỉ có thể giao tiếp với card mạng ảo VMnet1 trên máy thật.</li>
  <li> Card Host-only chỉ có thể giao tiếp với các card Host-only trên các máy ảo khác.</li>
<li> Card Host-only không thể giao tiếp với mạng vật lý mà máy tính thật đang kết nối.</li>

- Bước 12: Trong phần `I/O controller types` có 3 tùy chọn

  `BusLogic` và `LSI Logic` là trình điều khiển giao diện song song, chỉ hỗ trợ hệ điều hành 32 bít.

  `Buslogic` không cung cấp khả năng tự sửa lỗi khi hệ điều hành không tương thích với trình điều khiển.

  `LSI logic`cải thiện hiệu suất tốt nhất trong bộ SCSI.
  `LSI Logic SAS` là trình điều khiển giao diện nối tiếp , hỗ trợ cả 32 bit và 64 bit cho tất cả các hệ điều hành hiện nay.

<img src=http://i.imgur.com/pjeaLM5.png>

- Bước 13 : Ở mục `Vitrual disk type` có 3 tùy chọn loại ổ đĩa

  `IDE`: mạch điện tử tích hợp trong ổ đĩa

  `SCSI`: thường được dùng trong các máy server ,có tốc độ nhanh hơn chuẩn IDE.

  `SATA`: Sử dụng tín hiệu truyền nối tiếp,có một kết nối riêng biệt cho dữ liệu đi ra hay đi vào thiết bị.

<img src=http://i.imgur.com/XbwFUIP.png>

- Bước 14 : Trong mục `Disk` các bạn chọn `Create a new virtual` disk để tạo ổ đĩa máy ảo mới sau đó nhấn `Next` để tiếp tục.

<img src=http://i.imgur.com/zWhnqkH.png>


- Bước 15: Ở phần này trong mục `Maximum disk size (GB)` bạn thiết lập dung lượng tối đa cho ổ cứng sau đó bạn chọn mục `Split virtual disk into multiple file` sau đó nhấn `Next` để tiếp tục.

<img src=http://i.imgur.com/V7RcLEt.png>

- Bước 16: Ở phần tiếp theo bạn để nguyên mặc định nhấn `Next` để tiếp tục.

<img src=http://i.imgur.com/m9nK4Gx.png>

- Bước 17 : Ấn `Finish` và kết thúc quá trình tùy chọn cài đặt. Các bước tiếp theo tương tự như cài win trên máy thật.

<img src=http://i.imgur.com/VhwcqhG.png>

<a name="trenlinux"></a>
### 3.2 Trên Linux

<a name="ctlinux"></a>
#### 3.2.1 Cài đăt chương trình trên linux

- Bước 1 : Cài đặt acacs gói bổ trợ cho VMware. Vào `Terminal` thực hiện câu lệnh sau :

  `haikma@root:~$ sudo apt-get install gcc build-essential -y`

- Bước 2 : Truy cập [Trang chủ VMware](#http://www.vmware.com/go/tryworkstation-linux-64) download bản cài đặt về
- Bước 3 :Tiến hành cài đăt VMware từ `Terminal`

    Đầu tiên trước khi cài đặt chúng ta cần cấp quyền executable cho file vừa tải

    `haikma@root:~/Downloads$ chmod +x Vmware-Workstation-Full-12.1.1-3770994.x86_64.bundle`

    Sau khi đã cấp quyền, bắt đầu tiến hành cài đặt bằng quyền `root`

    `haikma@root:~/Downloads$ sudo ./Vmware-Workstation-Full-12.1.1-3770994.x86_64.bundle`

    Sau khi thực hiện, giao diện cài đặt VMware sẽ hiện ra, chúng ta tiến hành cài đặt như trên `Windows`.

<a name="hdhlinux"></a>
#### 3.2.2 Cài đặt một hệ điều hành trên Linux

  Ở bước này, để cài đặt một hệ điều hành mới thì cũng cần có một file iso của hệ điều hành cần cài và tiến hành cài đặt như các bước trên hệ điều hành `Windows`

<a name="cauhinhmorong"></a>  
## IV. Cấu hình mở rộng của VMware

<a name="snapshot"></a>
### 4.1 Lưu trạng thái máy ảo với Snapshot

  Snapshot là một công cụ rất hay cuả VMware, nó có ý nghĩa như sau :

  <li>Giúp lưu lại tình trạng của máy tính tại một thời điểm bất kỳ</li>
  <li>Hỗ trợ khôi phục máy tính về trạng thái Snapshot trước đó</li>
  <li>Giúp công việc restore dễ dàng hơn mà không cần phải cài lại HĐH hay gỡ các service trước đó</li>

  Sau đây mình sẽ hướng dẫn các bạn các bước cơ bản để Snapshot trạng thái của một máy ảo trong VMware:
  - Bước 1 : Click chuột phải vào máy cần Snapshot -> Chọn Snapshot -> Take Snapshot
  - Bước 2 : Lưu tên Snapshot và ghi chú thêm về trạng thái đó. Sau đó Click `Take Snapshot`

  <img src="http://i.imgur.com/xmuayKc.jpg">

  Vậy là các bạn đã có thể lưu được trạng thái máy ảo tại thời điểm Snapshoot.

  Đến lúc cần quay lại trạng thái nào thì chỉ cần chọn Snapshot -> click vào Snapshot cần quay lại.Chờ một chút, vậy là máy ảo sẽ quay lại thời điểm thực hiện Snapshoot.

<a name="clone"></a>
### 4.2 Nhân bản máy ảo Clone

Đúng như tên gọi của nó: Clone – bản sao. Khi sử dụng tính năng này, phần mềm sẽ tự tạo ra một bản sao giống hệt như bản gốc của bạn có trước đó, với cách làm này, chúng ta sẽ rất tiết kiệm thời gian.

Để thực hiện tính năng này chúng ta làm như sau :

- Bước 1 : Click máy muốn Clone -> Manage -> Clone

<img src=http://i.imgur.com/y2LuR1B.png>

- Bước 2 : Cửa số mới hiện lên, Ấn `Next`

<img src=http://i.imgur.com/BklClEC.png>

- Bước 3 : Chọn `The current state in the virtual machine` và ấn `Next`

<img src=http://i.imgur.com/m6nFFmf.png>

- Bước 4 : Ở cửa sổ tiếp theo có 2 option để bạn chọn:

    `Creat a linked Clone` : Tùy chọn này cho phép tạo một bản sao y hệt như bản gốc, nhưng vẫn phải kết nối vào bản gốc, khi bản gốc không hoạt động thì bản sao cũng không hoạt động được.

    `Creat a full Clone` : Tùy chọn này cũng cho phép tạo một bản sao y hệt như bản không, nhưng không cần kết nối vào bản gốc mà hoạt động độc lập. Thường thì các bạn nên chọn tùy chọn này

<img src=http://i.imgur.com/TYLAE9X.png>

- Bước 5 : Đổi tên máy ảo và chọn nơi lưu trữ cho bản Clone. Sau đó ấn `Finish`

<img src=http://i.imgur.com/nhDLy9Q.png>

- Bước 6 : Quá trình Clone bắt đầu, chờ vài phút hoặc hơn phụ thuộc vào cấu hình máy thật.

<img src=http://i.imgur.com/q0pRz6w.png>

- Bước 7 : Quá trình Clone thành công .Ấn `Close` để kết thúc.

<a name="vmwaretool"></a>
### 4.3 Sử dụng VMware tool

`VMware Tools`là bộ công cụ giúp tăng cường hiệu suất cho máy ảo của VMware. Hiểu một cách đơn giản, VMware Tools sẽ đem lại cho bạn các lợi ích sau đây :

<li>Cho phép Shutdown một máy ngay từ giao diện quản lý chung bên ngoài.</li>

<li>Tăng cường về xử lý đồ họa trên máy ảo.</li>

<li>Cho phép copy/paste dữ liệu từ máy thật và máy ảo bằng kéo thả.</li>

Ngoài ra nó còn có rất nhiều chức năng khác.

Các bước cài đặt VMware tool như sau :
  - Bước 1 : Click chuột phải vào máy cần cài VMware tool -> Chọn Install VMware tool. Hiển ra hộp thoại :

  <img src=http://i.imgur.com/CtxrwPB.png>

  - Bước 2 : Để mặc định Complete , ấn `Next`

  <img src=http://i.imgur.com/XhrJBUH.png>

  - Bước 3 : Chọn `Install`

  <img src=http://i.imgur.com/v359t27.png>

  - Bước 4 : Chờ tiến trình cài đặt kết thúc

  <img src=http://i.imgur.com/BZcGihx.png>

  - Bước 5 : Chọn `Finish` để kết thúc quá trình cài đặt

  <img src=http://i.imgur.com/vOqyHfT.png>

  Sau khi kết thúc, máy ảo sẽ phải khởi động lại để khởi động VMware tool.Sau khi khởi động xong, bạn có thể trải nghiệm các tiện ích mà VMware tool mang lại.

<a name="ketluan"></a>
## V.Kết luận  
