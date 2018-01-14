```

Ubuntu  là một hệ điều hành máy tính dựa trên Debian GNU/Linux, một bản phân phối Linux thông dụng. 
Tên của nó bắt nguồn từ "ubuntu"trong tiếng Zulu, có nghĩa là "tình người", mô tả triết lý 
ubuntu: "Tôi được là chínhmình nhờ có những 
người xung quanh," một khía cạnh tích cực của cộng đồng. Mục đích của Ubuntu bao gồm việc cung cấp 
một hệ điều hành ổn định,cập nhật cho người dùng thường, 
và tập trung vào sự tiện dụng và dễ dàng cài đặt. Ubuntu đã được đánh xếp hạng là bản phân phối Linux
thông dụng nhất chomáy tính để bàn, chiếm khoảng 30% số bản Linux được cài đặt trên máy tính để bàn năm 2007.
Ubuntu là phần mềm mã nguồn mở tự do, có nghĩa là người dùng được tự do chạy, sao chép, phân phối,
nghiên cứu, thay đổi và cải tiếnphần mềm theo điều khoản của giấy phép GNU GPL. Ubuntu được tài trợ bởi 
Canonical Ltd (chủ sở hữu là một người Nam Phi Mark Shuttleworth). Thay vì bán Ubuntu, Canonical tạo ra 
doanh thu bằng cách bán hỗ trợ kĩ thuật. Bằng việc để cho Ubuntu tự do và mở mã nguồn, Canonical có 
thể tận dụng tài năng của những nhà phát triển ở bên ngoài trong các thành phần cấu tạo của Ubuntu
mà không cần phải tự mình phát triển

``` 
## Cấu Hình Máy Tính Cần Thiết Để Cài Đặt Ubuntu 16.0.4 
- CPU : core dual tối thiểu 2 GHz hoặc cao hơn.
- RAM: 2GB trở lên.
- 25GB phân vùng trống đề cài đặt Ubuntu.
- Ổ quang đọc đĩa DVD/CD, cổng USB để cài đặt từ đĩa hoặc USB, các thiết bị ổ cứng gắn ngoài.
- Máy tính cần có kết nối internet để cập nhật, tải các phần mềm cài đặt.

# Cài đặt Ubuntu 16.0.4 trên VMware Worktation 12 pro

## Các bước cài đặt : 

-  Bật VMware Workstation 12 Pro lên , ở phần Home => Create a New Virtual Machine 

-  Ở giao diện Welcome, có 2 lựa chọn Typical và Customer  :
![](http://i.imgur.com/8BkAzbc.png)

## I.	PHẦN 1 : CÀI ĐẶT CƠ BẢN ( TYPICAL) : 

### Typical : cài đặt VMware Workstation 12 Pro trong một số bước đơn giản như :
#### Bước 1. 	Install from :  lựa chọn phân vùng ổ đĩa lưu trữ bản cài đặt
(*) Các máy tính mới hiện nay hầu như không trang bị ổ CD/DVD nữa và thường thì chúng ta sẽ chọn cài từ file ISO. 
  -	Installer disc
  - Installer disc image file (iso) => Browse => phân vùng lưu trữ OS => next
  - I will install the operationg system later : cài đặt hđh sau, máy ảo sẽ tạo được tạo trên một phân vùng ở đĩa trống.
 ![](http://i.imgur.com/CY0Yyub.png)

#### Bước 2 : Điền thông tin tên người sử dụng, username trong máy tính, password ( optional ) và confirm :
 ![](http://i.imgur.com/02RnFH8.png)
 
	  - Next
 
#### Bước 3 :Đặt tên cho máy ảo Ubuntu và lựa chọn khu vực lưu trữ máy ảo : 
 ![](http://i.imgur.com/a2nJn7h.png)
 
	  - Next


#### Bước 4 : Xác định dung lượng ổ đĩa : 
 -	Ở đây mình chọn 40GB ổ cứng để máy ảo hoạt động
   - Có 2 lựa chọn trong mục này :  
     - Store vitual disk as a single file : Lưu trữ ổ cứng ảo trên một file duy nhất. Với HDD thật mà dùng dịnh dạng ổ đỉa là
        NTFS thì bạn nên dùng tùy chọn này.
     - Split virtual disk into multiple files : chia ổ cứng ảo thành nhiều file khác nhau, với định dạng ổ cứng máy thật là FAT
      thì nên chọn tùy chọn này ( lựa chọn này có thể tạo điều kiện dễ dành để di chuyển máy ảo sang các máy tính khác nhưng có thể 
      giảm hiệu năng với những phân vùng ổ cứng lớn hoặc khi xóa nhầm 1 file con là hệ điều hành sẽ không hoạt động được )

      => Chọn Split virtual disk into multiple files => next
      
      ![](http://i.imgur.com/C0TvQ0T.png)

#### Bước 5 :Việc cài đặt đã gần hoàn thành :  chọn Customize Hardware để điều chỉnh Ram, Card mạng
![](http://i.imgur.com/aHPVnZY.png)
![Imgur](http://i.imgur.com/0SDefEq.png)

•	Ram : để mức lớn hơn hoặc bằng Recommended memory ( >= 1GB ) nhưng nên để 2GB trở lên thì máy sẽ chạy ổn định
•	Processors :  Mặc định là 1 , có thể chọn là 2 hoặc nhiều hơn để máy ảo hoạt động nhanh hơn
 - Number of processors :  số lượng vi xử lí ( chip ) sẽ cung cấp cho máy ảo
 - Number of Cores per processors :  số lượng nhân chạy trong mỗi chip 
 Workstation Pro hỗ trợ đến 16-way Virtual Symphric Multiprocessing (SMP) cho các hệ điều hành khách chạy trên các máy chủ đa
 xử lý. Bạn có thể gán nhân của bộ xử lý và mỗi bộ vi xử lý cho một máy ảo trên bất kỳ mà có ít nhất hai bộ xử lý logic.
•	Vitualization egine : 
- Automatic ( Tự động ) :  Workstation Pro chọn chế độ thực thi dựa trên hệ điều hành khách và CPU chủ
- Binary translation (Dịch nhị phân):
Workstation Pro sử dụng một kết hợp của mã khách trực tiếp thực hiện và dịch nhị phân để chạy hệ điều hành khách. 
lập bản đồ bộ nhớ của khách được thực hiện bằng cách sử dụng bảng trang bóng
Intel VT-x or AMD-V : Workstation Pro sử dụng phần mở rộng phần cứng để chạy và cô lập mã khách. Việc lập bản đồ bộ nhớ 
của khách được thực hiện bằng cách sử dụng bảng trang bóng.
- Intel VT-x / EPT hoặc AMD-V / RVI : Workstation Pro sử dụng phần mở rộng phần cứng để chạy và cô lập mã khách. Lập bản đồ bộ nhớ người dùng được thực hiện bằng cách sử dụng phân trang phần cứng

-	Một số lựa chọn khác : 

  => Disable accelebration for binary translation ( tắt tính năng tăng tốc cho việc biên dịch mã nhị phân ) : Trong những trường hợp
hiếm hoi, bạn có thể thấy rằng Workstation Pro dường như đóng băng khi bạn cài đặt hoặc chạy phần mềm bên trong một máy ảo. 
Vấn đề này thường xảy ra sớm trong việc thực hiện chương trình. Trong nhiều trường hợp, bạn có thể ngăn vấn đề bằng cách tạm thời
tắt tăng tốc trong máy ảo. Sau khi chương trình vượt qua thời điểm xảy ra sự cố, hãy bỏ chọn cài đặt này.

  => Virtualize Intel  VT-x/EPT or AMD-V/RVI: Nếu muốn chạy máy ảo trong máy ảo. Chế độ mở rộng địa chỉ vật lý (PAE) phải được bật để
sử dụng bộ vi xử lý AMD-V / RVI đã được ảo hóa.
Nếu chế độ thực thi không được hỗ trợ bởi hệ thống máy chủ lưu trữ, việc ảo hóa VT-x / EPT hoặc AMD / RVI sẽ không thực hiện. 
Nếu bạn di chuyển máy ảo sang một phần mèm VMware khác, ảo hóa VT-x / EPT hoặc AMD-V / RVI có thể không hoạt động.

  => Vitualize CPU performance counters : Bật tính năng này nếu bạn định sử dụng các ứng dụng giám sát hiệu suất như VTune hoặc 
OProfile để tối ưu hóa hoặc gỡ lỗi phần mềm chạy bên trong máy ảo.
Tính năng này chỉ khả dụng nếu tương thích máy ảo là Workstation 9 hoặc mới hơn.

![](http://i.imgur.com/MZuiMuR.png)
 
- New CD / DVD : Khu vực lựa chọn bộ cài đặt hệ điều hành => Chọn Use ISO image file
  •	Use Physical drive :  sử dụng ổ đĩa vật lý 
    - Auto select
    - D: 
    - Use ISO image file : => Browse => thư mục lưu trữ bản cài đặt hệ điều hành ( OS image )

- Network Adapter : 
  Khi cài đặt,  VMWare tự động tạo ra ở máy thật 2 card mạng ảo:
  
 ![](http://i.imgur.com/iqcvwK0.png)
  -	VMware Network Adapter VMnet1
  -	VMware Network Adapter VMnet8
    
  Hai card mạng này có thể được sử dụng để máy thật giao tiếp với các máy tính ảo. Khi “gắn” một card mạng vào một máy ảo, 
  card mạng này có thể được chọn 1 trong 3 loại sau:
  
    •	Bridge:
    
      o	Card Bridge trên máy ảo chỉ có thể giao tiếp với card mạng thật trên máy thật.
      o	Card mạng Bridge này có thể giao tiếp với mạng vật lý mà máy tính thật đang kết nối.
    •	NAT:
    
      o	Card NAT chỉ có thể giao tiếp với card mạng ảo VMnet8 trên máy thật.
      o	Card NAT chỉ có thể giao tiếp với các card NAT trên các máy ảo khác.
      o	Card NAT không thể giao tiếp với mạng vật lý mà máy tính thật đang kết nối.
      Tuy nhiên nhờ cơ chế NAT được tích hợp trong VMWare, 
      máy tính ảo có thể gián tiếp liên lạc với mạng vật lý bên ngoài.
      
    •	Host-only: 
      o	Card Host-only chỉ có thể giao tiếp với card mạng ảo VMnet1 trên máy thật.
      o	Card Host-only chỉ có thể giao tiếp với các card Host-only trên các máy ảo khác.
      o	Card Host-only không thể giao tiếp với mạng vật lý mà máy tính thật đang kết nối.
      
    •	Custom :  Lựa chọn card mạng theo mục đích riêng, có 2 lựa chọn Host-only và NAT
    
![](http://i.imgur.com/k1Q25wE.png)
</br>
![](http://i.imgur.com/rWKaUG6.png)


 
(*) Thông thường VMware Workstation sẽ gắn card VMnet 0 là card Bridge, vmnet1 là host-only và vmnet8 là NAT. Khi bạn chọn "Bridge", 
"host-only", hoặc "NAT" cho một adapter ảo nhất định, VMware sẽ ngầm lựa chọn VMnet0, VMnet1,
VMnet8 cho bạn. Hoặc bạn có thể chọn Custom, chọn 1 card mạng bất kì như VMnet 2 sau đó ra ngoài và chọn một chế độ card mạng
như host-only, khi đó VMnet 2 sẽ được coi như là một card mạng theo cơ chế host-only.
![](http://i.imgur.com/gTU3oBt.png)
</br>
•	LAN segment : Các phân đoạn mạng LAN này tương tự như một mạng tùy chỉnh mà bạn sẽ tạo ra nếu nó không có kết nối đến máy chủ và
nếu nó không có các dịch vụ DHCP từ Workstation.Ưu điểm của các phân đoạn LAN này là bạn có thể tạo bao nhiêu tùy thích 
(bạn không bị giới hạn bởi giới hạn số máy trạm Workstation VMnet 0-9).Các phân đoạn LAN là một giải pháp tuyệt vời cho phép bạn 
tạo ra nhiều mạng riêng ảo, cho một số lượng sử dụng hầu như không giới hạn.

![](http://i.imgur.com/fbhLdOr.png)

  -	Một khi bạn tạo ra phân đoạn LAN, bạn kết nối các máy ảo của bạn với nó, giống như bạn sẽ kết nối chúng với bất kỳ tùy chọn
mạng ảo khác trong Workstation
 
![](http://i.imgur.com/mDqlxZt.png)
</br>
  -	Một trong những lựa chọn tiên tiến nhất trong Workstation 9 là khả năng điều tiết băng thông mạng đến và đi cũng như tùy chọn để 
tạo ra một địa chỉ MAC Ethernet tuỳ chỉnh.

![](http://i.imgur.com/sJPe4w9.png)

 Như vậy tùy vào nhu cầu kiểm thử, bạn chọn loại card mạng để “gắn” vào máy ảo cho thích hợp. VMware có tính năng cấp IP động (DHCP),
bạn có thể click vào Edit -> chọn Virtual Network Editor trên thanh tool bar để cấu hình. Trong một số trường hợp bạn phải tắt tính
năng này để phù hợp với yêu cầu kiểm thử. 

•	Những cài đặt khác : 
  - Usb Controller :  tạo kết nối với US
  - Sound Card : card âm thanh
  - Printer : thiết lập liên kết với máy in
  - Display : 
    - 3D grahpics : đồ họa 3D
    - Monitor : màn hình
    - Graphics memory :  bộ nhớ dành cho đồ họa
    
(*) Sau khi thiết lập xong => Close

=> Finish để hoàn tất việc cài đặt
#### Bước 6. Máy ảo VMware tiến hành quá trình cài đặt. 

![](http://i.imgur.com/DE8MmFy.png)
 

#### Bước 7. Màn hình đăng nhập vào Ubuntu 16.0.4	:
![](http://i.imgur.com/Ddb8ZLO.png)
 
#### Bước 8. Sau khi đăng nhập vào Ubuntu :
 ![](http://i.imgur.com/D88pL0g.png)

(*) Người dùng tiến hành cài đặt thời gian , customize .
Hoàn tất quá trình cài đặt hệ điều hành Ubuntu 16.0.4  trên VMware Workstation 12 Pro.

## II.	CÀI ĐẶT THEO CHẾ ĐỘ TÙY BIẾN NÂNG CAO ( CUSTOM) : 

### Bước 1 : Lựa chọn phiên bản Workstation cài đặt

- Ở đây lựa chọn bản 12.x vì càng phiên bản càng mới càng có thêm nhiều tiện ích.
  </br>
 ![](http://i.imgur.com/izrPbhe.png)

###	Bước 2 : lựa chọn phân vùng ổ đĩa lưu trữ bản cài đặt => Chọn option 2
 ![](http://i.imgur.com/CY0Yyub.png) 
 </br>
(*) Các máy tính mới hiện nay hầu như không trang bị ổ CD/DVD nữa và thường thì chúng ta sẽ chọn cài từ file ISO. 
-	Installer disc
-	Installer disc image file (iso) => Browse => phân vùng lưu trữ OS => next
-	I will install the operationg system later : cài đặt hđh sau, máy ảo sẽ tạo được tạo trên một phân vùng ở đĩa trống.
### Bước 3: Điền thông tin tên người sử dụng, username trong máy tính, password ( optional ) và confirm :
 ![](http://i.imgur.com/02RnFH8.png)
	Next

###	Bước 4: Đặt tên cho máy ảo Ubuntu và lựa chọn khu vực lưu trữ máy ảo : 
  ![](http://i.imgur.com/a2nJn7h.png)
	Next
### Bước 5 : lựa chọn số nhân vi xử lí cho hệ điều hành :
 ![Imgur](http://i.imgur.com/WImyhvQ.png)

### Bước 6 : chọn dung lượng ram cho hệ điều hành 
 ![](http://i.imgur.com/gVANIpB.png)

###	Bước 7 : chọn chế độ mạng 
 ![](http://i.imgur.com/M0o2Z3l.png)
(*) Ở mục này, không có Lan segment như cài đặt trong chế độ Typical

### Bước 8: Chọn chế độ I/O Controller Types : LSI logic
VMware Workstation 12 Pro tự động tạo một vùng lựa chọn mà bộ điều khiển vSCSI sử dụng dựa trên trình điều khiển có sẵn trong phân phối
hệ điều hành ( LSI logic ).  Vì vậy hãy đảm bảo chọn Hệ điều hành phù hợp để bắt đầu.
-	Workstation cài đặt một bộ điều khiển IDE và bộ điều khiển SCSI trong máy ảo. Bộ điều khiển IDE luôn là ATAPI. Đối với bộ điều khiển
SCSI, bạn có thể chọn BusLogic, LSI Logic, hoặc LSI Logic SAS. Nếu bạn đang tạo một máy ảo từ xa trên một máy chủ ESX, bạn cũng có 
thể chọn một bộ điều hợp VMware Paravirtual SCSI (PVSCSI).
Bộ điều hợp BusLogic và LSI Logic có giao diện song song. Adapter LSI Logic SAS có một giao diện nối tiếp. Adapter LSI Logic đã cải
thiện hiệu năng và hoạt động tốt hơn với các thiết bị SCSI chung. Bộ chuyển đổi LSI Logic cũng được hỗ trợ bởi ESX Server 2.0 trở lên.
![](http://i.imgur.com/s5kZ0eU.png)
-	BusLogic : đây từng là một trong những bộ điều khiển vSCSI đầu tiên có mặt trên nền tầng VWware. Phiên bản nguyên thủy của Windows có sẵn driver đó, nó làm cho việc cài đặt một hệ điều hành cụ thể trở nên đơn giản hơn nhiều. Nó tuy không mạnh như driver LSI logic vì 
trình điều khiển của Windows đã bị giới hạn mức tải hàng đợi là 1, vì thế cho nên người dùng thường tự nạo LSI logic thay vì Buslogic. 
- LSI Logic Parallel (trước đây chỉ là LSI Logic) : đây là bộ điều khiển vSCSI mô phỏng khác có sẵn trong nền tảng VMware. 
Hầu hết cáchệ điều hành đều có trình điều khiển hỗ trợ chiều sâu hàng đợi là 32 và nó đã trở thành một sự lựa chọn rất phổ biến, nếu không phải là mặc định. 
- LSI Logic SAS - Đây là một sự tiến triển của trình điều khiển song song để hỗ trợ một tiêu chuẩn mới cho tương lai. Nó bắt đầu trở 
nên phổ biến khi Microsoft yêu cầu sử dụng nó cho MCSC trong Windows 2008 hoặc các phiên bản mới hơn.

###	Bước 9 : Lựa chọn loại ổ đĩa ảo : chọn SCSI
- IDE : Integrated Drive Electronics
Parallel ATA (PATA) hay còn được gọi là EIDE (Enhanced intergrated drive electronics) được biết đến như là 1 chuẩn kết nối ổ cứng thông
dụng hơn 10 năm nay. Tốc độ truyền tải dữ liệu tối đa là 100 MB/giây. Các bo mạch chủ mới nhất hiện nay gần như đã bỏ hẳn chuẩn kết nối này, tuy nhiên, người dùng vẫn có thể mua loại card PCI EIDE Controller nếu muốn sử dụng tiếp ổ cứng EIDE
- SCSI :  Small computer system interface
ổ cứng sử dụng giao diện SCSI để liên lạc với máy tính. Một giao diện, thực chất là một loại bus mở rộng phức tạp, trong đó bạn có thể 
cắm vào các thiết bị như ổ đĩa cứng, ổ đĩa CD ROM, máy quét hình và máy in laser. Thiết bị SCSI thông dụng nhất là ổ cứng SCSI có chứa
hầu hết các mạch điều khiển, nên đã làm cho giao diện SCSI trở nên tự do để thực hiện thông tin với các thiết bị ngoại vi khác. 
Tối đa có thể mắc bảy thiết bị SCSI vào một cổng SCSI. Tốc độ tối đa của chuẩn giao diện kết nối này là 160 MB/s trên giao diện Ultra160.
- SATA : Serial AT Attachment
Chuẩn kết nối mới trong công nghệ ổ cứng nhờ vào những khả năng ưu việt hơn chuẩn IDE về tốc độ xử lý và truyền tải dữ liệu.
SATA là kết quả của việc làm giảm tiếng ồn, tăng các luồng không khí trong hệ thống do những dây cáp SATA hẹp hơn 400% so với dây 
cáp IDE. Tốc độ truyền tải dữ liệu tối đa lên đến 150 - 300 MB/giây. Đây là lý do vì sao bạn không nên sử dụng ổ cứng IDE chung với 
ổ cứng SATA trên cùng một hệ thống. Ổ cứng IDE sẽ “kéo” tốc độ ổ cứng SATA bằng với mình, khiến ổ cứng SATA không thể hoạt động đúng
với “sức lực” của mình. Ngày nay, SATA là chuẩn kết nối ổ cứng thông dụng nhất và cũng như ở trên, ta có thể áp dụng card PCI SATA 
Controller nếu bo mạch chủ không hỗ trợ chuẩn kết nối này.
 
![](http://i.imgur.com/4PPaU4K.png)

###	Bước 10 : Chọn phân vùng ổ đĩa bạn muốn sử dụng để lưu hệ điều hành :  chọn Create a virtual disk
	  - Create a new virtual disk :  tạo một phân vùng ảo trên ổ cứng thật, hệ điều hành sẽ lưu trên đó.
	  - Use an existing virtual disk : trong trường hợp bạn đã tạo một phân vùng ổ cứng ảo trước đó bạn có thể sử dụng lại nó.
	  - Use a physical disk( for advance users) : chọn phương án này khi muốn máy ảo sử dụng luôn dung lượng ổ cứng vật lý thật trên
    ổ cứng máy tính.
![](http://i.imgur.com/YyNVwTF.png)

###	Bước 11 : cấp phát dung lượng ổ cứng :
Ngoài 2 lựa chọn cuối giống với Typical thì có thêm 1 option nữa là :  allcocate all disk space now 
	 => Điều này sẽ quy hoạch lại tổng thể dung lượng ổ cứng vật lý , có thể tăng hiệu suất của ổ cứng tuy nhiên tất cả dung lượng vật
lý đều phải được huy động ngay lúc đó. Nếu bạn không quy hoạch lại ổ đĩa thì với máy ảo dữ liệu càng nở ra bao nhiêu nó càng chiếm bấy nhiêu dung lượng của ổ đĩa thật.

![](http://i.imgur.com/GGxQ6PD.png)

###	Bước 12 : Tìm nơi lưu file cài đặt của hệ điều hành : 
 ![](http://i.imgur.com/PkXByp7.png)

### Bước 13: Customize hardware giống ở Typical
#### Bước 14. Máy ảo VMware tiến hành quá trình cài đặt. 

![](http://i.imgur.com/DE8MmFy.png)
 

#### Bước 15. Màn hình đăng nhập vào Ubuntu 16.0.4	:
![](http://i.imgur.com/Ddb8ZLO.png)
 
#### Bước 16. Sau khi đăng nhập vào Ubuntu :
 ![](http://i.imgur.com/D88pL0g.png)

(*) Người dùng tiến hành cài đặt thời gian , customize .
Hoàn tất quá trình cài đặt hệ điều hành Ubuntu 16.0.4  trên VMware Workstation 12 Pro.
Finish !
