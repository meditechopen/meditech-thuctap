# Router cisco

## 1. Định nghĩa

-  Router có chức năng gửi các gói dữ liệu mạng giữa 2 hoặc nhiều mạng, từ một tới nhiều điểm đích đến cuối 
cùng từ router.

- Mỗi một mạng mà router kết nối đến thì yêu cầu các interface riêng rẽ. Những interfaces này được sử dụng để
kết nối một hệ thống gồm cả LANs và WANs. 

- Chức năng chính của Router là : 

	+ Tìm đường đi nhanh nhất đến đích cho gói tin
	+ Chuyển tiếp các gói tin đến đích của chúng

- Cấu tạo của Router:

	+ CPU
	+ RAM
	+ ROM
	+ FLASH Memory
	+ NVRAM

## 2. Các thành phần của ROUTER


#### 2.1. CPU

- CPU thực hiện các công việc của hệ điều hành, chẳng hạn như khởi tạo hệ thống, các chức năng định tuyến, 
và các chức năng chuyển mạch.

#### 2.2. RAM

- Lưu trữ các chỉ dẫn và dữ liệu cần thiết phục vụ cho CPU. RAM được sử dụng để lưu trữ những thành phần sau:

	- Operating system: Cisco IOS ( Internet Operating System) được sao chép vào RAM trong quá trình khởi động.

	- Running Configuration File: các file cấu hình lưu các lệnh mà Router đang xử dụng tại thời điểm đó. 
	Với vài ngoại lệ, tất cả các lệnh được cấu hình trên router đều được lưu trữ trong running-config file, được gọi là run-config.
	quá trình boot router,  switch thực hiện qua những bước nào, hiểu tối đa từng bước .

	- IP Routing Table: file này lưu thông tin về các kết nối trực tiếp và kết nối mạng từ xa tới Router. Nó được 
	dùng để xác định đường đi tốt nhất cho việc chuyển tiếp gói tin.
	
	- ARP cache: bộ nhớ đệm này lưu trữ các địa chỉ IPv4 ánh xạ với địa chỉ MAC, giống với ARP cache trên PC. ARP cache 
	được dùng trên Router có cổng giao tiếp LAN như cổng Ethernet.
	
- Bộ nhớ RAM được chia ra bởi IOS(hệ điều hành của ROUTER) gồm :
	
	- Main : bộ nhớ chính dung để lưu các file như running-config, routing tables, switching cache, ARP tables …
	
	- Shared memory : dùng làm buffer cho tiến trình đang xử lý.
	
- RAM là bộ nhớ tạm thời, mất dữ liệu khi mất điện hoặc hệ thống khởi động lại. Tuy nhiên router cũng có một bộ nhớ cứng là ROM, flash và NVRAM.

#### 2.3. ROM

- ROM là một bộ nhớ cứng, không mất dữ liệu khi mất điện hoặc khởi động lại. Các thiết bị Cisco dùng ROM để lưu:

	- Bootstrap instruction: Kiểm tra thanh ghi thiết bị. Khi bật nguồn chúng làm nhiệm vụ kiểm tra lỗi của các thiết bị (bạn có thể thấy PC test RAM, bàn phím... & báo lỗi nếu có), 
	sau đó tìm kiếm hệ điều hành (OS) (đ/v PC tìm trên FDD, CD, HDD...) (đ/v Router thì tìm IOS trên Flash, TFTP & ROM), 
	tiếp theo là nạp OS vào RAM và chuyển quyền điều khiển cho hệ điều hành.
	
	- IOS phụ ( Có thể được dùng như một hệ điều hành dự phòng nếu IOS chính bị lỗi ).
	
	- Chương trình Power-on diagnonstics kiểm tra phần cứng.

- ROM sử dụng firmware ( phần mềm được nhúng vào trong bảng mạch tích hợp ). Firmware bao gồm phần mềm 



#### 2.4. Flash Memory

- Là bộ nhớ chứa IOS chính có 2 loại : nén và không nén.

- FLASH chứa IOS dưới dạng nén và khi khỏi động nó được bung vào RAM giải nén ra để chạy.

- Các đời ROUTER cũ 2500 thì IOS được chạy trực tiếp trên FLASH. Ngày nay thì nó chạy trên RAM

- Flash gồm SIMMs hoặc PCMCIA card, có thể nâng cấp để tăng dung lượng bộ nhớ lên.

- Flash memory là bộ nhớ không bay hơi ( nonvolatile) nên không mất dữ liệu khi mất điện hay khởi động lại.


#### 2.5. NVRAM

- NVRAM ( nonvolatile Ram) không mất dữ liệu khi mất điện.

- Lưu các file cấu hình khởi động (startup-config). 

	- Các thay đổi trong cấu hình được lưu trong running-config file trong RAM, và đôi khi IOS thực thi nó 
	trực tiếp. Để lưu các thay đổi này phòng khi Router bị khởi động lại hoặc mất điện, running-config file phải được 
	sao chép vào NVRAM.
	
	
#### 2.6. Internet Operating System (IOS)

- IOS quản lí phần cứng và phần mềm của router, bao gồm việc phân vùng bộ nhớ, quản lí tiến trình,
 bảo mật và các file hệ thống.
	- Cisco IOS là một hệ điều hành đa chức năng: chỉ đường, chuyển  mạch, kết nối mạng và giao tiếp qua mạng.
	
- Một số dòng Router cung cấp IOS với giao diện người dùng, tuy nhiên việc thực hiện bằng lệnh vẫn phổ biến hơn cả.

- Khi khởi động, file startup-config trong NVRAM được sao chép vào RAM và được lưu như running-config file. Mọi thay đổi
 do người quản trị tạo ra được lưu và running-config và được thực thi ngay tức thì bởi IOS .
 
 
## 3. Hoạt động của Router 

### 3.1. Quá trình khởi động của Router

Có 4 phiên chính trong quá trình khởi động của Router:

1. Khởi chạy tiến trình POST ( Power-On Self Test).
2. Nạp chương trình bootstrap vào RAM.
3. Định vị và nạp các phần mềm của Cisco IOS.
4. Định vị và nạp các startup-config file hoặc truy cập vào chế độ cài đặt.

![Imgur](https://i.imgur.com/EA05smK.png)

#### 1. Khởi chạy tiến trình POST

- Tiến trình Power-On Self Test là một tiến trình phổ biến được thực thi trên hầu hết máy tính trong quá trình khởi động.

- Tiến trình POST dùng để kiểm tra phần cứng của Router.

	- Khi Router được bật, phần mềm trong chip nhớ gắn trên ROM khởi chạy POST.
	- Trong qá trình tự kiểm tra, router thực thi các trình phân tích từ ROM trên các thành phần của nó như CPU, RAM, NVRAM.
	- Sau khi POST hoàn thành, router tiến hành thực thi chương trình bootstrap.
	
#### 2. Nạp Bootstrap

- Sau POST, chương trình bootstrap được sao chép từ ROM và RAM. 
	- CPU tiến hành thực thi các chỉ dẫn trong bootstrap.
	- Nhiệm vụ chính của bootstrap là định vị Cisco IOS và nạp vào RAM.
	
- Ở thời điểm này, nếu bạn có kết nối console đến router, thì bạn có thể nhìn thấy output 
của các tiến trình trên màn hình.

#### 3. Định vị và nạp hệ điều hành

- Khi router khởi động, nó cần biết nó sẽ phải nạp phần mềm nào và file cấu hình nào để sử dụng. 
Nó xác định  những điều trên bằng cách chạy chương trình bootstrap tìm kiếm file cấu hình thanh ghi 
( configuration register) và file startup-configuration
 được lưu trong NVRAM.
 
	- Router kiểm tra cấu hình trên thanh ghi(configuration register) để xác định nơi để tìm Cisco IOS.
	- Sau khi IOS được nạp, nó sẽ tiến hành nạp các file cấu hình. 

- IOS được lưu trong Flash Memory, nhưng cũng có thể được lưu ở một nơi khác theo kiểu TFTP ( Trivial File Transfer Protocol) server.

- Khi nói đến khởi động của Router có nghĩa là nói đến 4 bits đầu tiên của thanh ghi

	- 4 bits đầu tiên là 0 0 0 0 = 0x2100 : Router sẽ luôn luôn vào hệ điều hành phụ trên ROM. rommon 1>
	- 4 bits đầu tiên là 0 0 0 1 = 0x2101 : Luôn luôn lấy HĐH đầu tiên của FLASH để chạy( đối với FLASH có nhiều IOS).
		- Khi không có IOS trên FLASH nó sẽ gửi broadcast(255.255.255.255) ra tất cả các cổng mạng LAN của nó để tìm TFTP server( là server lưu trữ IOS và các file cấu hình router...)
		- Để tìm có IOS trên TFTP server không để nó load gọi là boot qua mạng từ TFTP server
		- Nếu TFTP không có IOS thì nó sẽ quay về HĐH phụ trên ROM
	- 4 bits đầu tiên là 0 0 1 0 = 0x2102 : vào trong FLASH để load HĐH ra nhưng khác với ở trên nó sẽ lấy toàn bộ IOS trong FLASH ra để load. Cái nào load được thì nó sẽ lấy dùng
		- Tương tự như trên nếu không có IOS trên FLASH nó cũng sẽ broadcast --> tìm TFTP để load HĐH qua mạng --> nếu không có thì sẽ quay về HĐH phụ trên ROM 

- *Lưu ý*: TFTP server thường được dùng như một hệ thống dự phòng cho IOS nhưng nó có thể được sử dụng như là
trung tâm lưu trữ và khởi nạp IOS cho Router. 

- Một số dòng Cisco cũ chạy IOS trực tiếp từ Flash, nhưng những model hiện nay đã tiến hành sao chép IOS vào RAM 
để CPU thực thi các tác vụ.

- *Lưu ý*: Một khi IOS bắt đầu tải, bạn có thể thấy một chuỗi các dấu hiệu pounds (#),
 như thể hiện trong hình, khi mà IOS image đang được giải nén.
 

#### 4. Định vị và nạp file cấu hình

##### Locating the Startup Configuration File
- Sau khi IOS được nạp vào thành công, chương trình bootstrap tiếp tục truy xuất file cấu hình startup-config trên NVRAM.

- Startup-config file chứa các thông tin sau:

	- Địa chỉ interfaces ( interface address)
	- Thông tin định tuyến ( routing information)
	- Mật khẩu
	- Những cấu hình được đặt bởi người quản trị
	
- Nếu các file startup-configuration và startup-config được lưu trên  NVRAM, nó sẽ được sao chép lene RAM như là các file cấu hình.

- *Lưu ý*: Nếu các file cấu hình không có trong NVRAM, Router sẽ tìm kiếm trên TFTP server. Nếu Router xác định thấy có một link đang kết nối 
từ nó tới một router khác đã được cấu hình sẵn, nó sẽ gửi bản tin broadcast để tìm file cấu hình trên link đó. 
Trường hợp này sẽ dẫn đến Router phải tạm dừng và hiện lên trên output những thông tin sau:

```
<router pauses here while it broadcasts for a configuration file across an active link>

%Error opening tftp://255.255.255.255/network-confg (Timed out)
%Error opening tftp://255.255.255.255/cisconet.cfg (Timed out)
```

##### Executing the Configuration File

- Nếu startup-configuration file tìm thấy trên NVRAM, IOS sẽ nạp nó lên RAM như là file cấu hình và thực thi nó trên cửa sổ dòng lệnh, lần lượt từng dòng 1.

##### Enter Setup Mode

- Nếu không tìm thấy startup-configuration file , router sẽ đưa người dùng đến một chế độ `setup mode`.
	- Setup mode là một loạt các câu hỏi về các thông tin cấu hình để người dùng tự đặt. 
	- Chế độ này hiếm khi dùng để cấu hình trên router với các thông tin phức tạp.
	
- Khi khởi động router mà không tìm thấy startup-configuration file, bạn sẽ thấy câu hỏi dưới đây sau khi IOS load xong:

```
Would you like to enter the initial configuration dialog? [yes/no]: no 
```

- Khi **Setup mode** không được chọn, IOS sẽ tạo một file run-config mặc định với các cài đặt cơ bản từ nhà sản xuất bao gồm 
router interfaces, management interfaces, và các thông tin cơ bản. 
	- Default running-config không có interface addresses, routing information, passwords hay các cấu hình đặc biệt nào khác.
	
##### Command Line Interface

Phụ thuộc vào nền tảng và IOS, router có thể sẽ hỏi các câu hỏi trước khi hiển thị promt:

```
Would you like to terminate autoinstall? [yes]: <Enter>
Press the Enter key to accept the default answer. 
Router>
```

- *Lưu ý*: Nếu startup-configuration file không tìm thấy, run-config có thể sẽ bao gồm cả 
hostname và promt sẽ hiển thị hostname đó trên giao diện.

- Khi hiển thị dấu nhắc ( promt) , router hiện đang chạy IOS với tệp run-config hiện tại. 
Quản trị viên mạng bây giờ có thể bắt đầu sử dụng các lệnh IOS trên router này.

