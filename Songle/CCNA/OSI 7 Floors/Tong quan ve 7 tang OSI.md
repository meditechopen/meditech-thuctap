
# Tổng quan về 7 tầng OSI
![Imgur](http://i.imgur.com/NRoz0u5.jpg)

## Mục lục :
### A. Nền tảng của truyền thông
	1.Cách thức làm việc của mạng LAN, WAN, Internet trong truyền thông
	2. Tìm hiểu về giao thức ( protocol ) trong truyền thông
	3. Các bước truyền thông qua mạng trong mô hình OSI
### B. Tổng quan về mô hình OSI
	1. Định nghĩa
		a. Mô hình OSI là gì?
		b. Tại sao phải phân lớp?
	2. Cái nhìn khái quát về 7 tầng OSi : đặc điểm, chức năng mỗi tầng
		2.1. Tầng Ứng dụng ( Application Layer )
		2.2. Tầng Phiên dịch ( Presentation Layer )
		2.3. Tầng Phiên ( Session Layer )
		2.4. Tầng Giao vận ( Traansport Layer )
		2.5. Tầng Mạng ( Network Layer)
		2.6. Tầng Liên kết dữ liệu ( Datalink Layer )
		2.7. Tầng Vật lý ( Physical Layer )
	

## A. Nền tảng của truyền thông: 
Để các máy tính và các thiết bị trong mạng truyền thông được với nhau thì hệ thống mạng phải có phần cứng và phần mềm. Từ phần cứng và phần mềm ta chia thành 4 thành phần: 
- Thiết bị đầu cuối: máy tính, laptop, Server, điện thoại. Các thiết bị này đều phải cài đặt Hệ điều hành hoặc phần mềm.
- Đường truyền: dây, Switch, Router, Modem được kết nối lại với nhau. Để kết nối gần ta dùng dây cáp đồng, kết nối xa thì dùng dây cáp quang hoặc dùng sóng vệ tinh.
- Thông tin: nội dung website, thư điện tử, nội dung chat... Dữ liệu này này sẽ được chia thành các mảnh để đưa vào đường truyền gọi là Segment. Để trao đổi được thông tin thì phải có người gửi và người nhận. 
- Giao thức (rule): cho phép truy cập tới dịch vụ gì, được đi theo đường nào, dữ liệu được tải ra sao,giao thức nào được áp dụng là gì. Vd: truyền theo Web phải sử dụng theo port 80 hoặc 443.

### 1. Cách thức làm việc của mạng LAN, WAN, Internet trong truyền thông: 

+ Trong mạng LAN: Các PC, Switch, Router giao tiếp với nhau bằng địa chỉ MAC.

+ Dữ liệu từ mạng LAN đi ra ngoài internet phải thông qua Modem hoặc Router.

+ Từ Router ở công ty sẽ gửi tới router của nhà cung cấp dịch vụ. 

+ Các nhà cung cấp dịch vụ sẽ liên kết Router lại với nhau để chuyển đi quốc tế.

+ Trên Các Router có bảng định tuyến để định đúng đường đi. 

### 2. Tìm hiểu về giao thức (Protocol) trong truyền thông: 

+ Giao thức dùng để định dạng cấu trúc của gói tin. Gói tin đi theo Web thì phải theo định dạng của Web,

Mail định dạng theo Mail... Do đó trên tầng ứng dụng có thể dùng cùng lúc nhiều dịch vụ mà không sợ xung đột nhau.

+ Cho phép truy cập tới đâu: thông qua giao thức chúng ta có thể điều hướng người dùng truy cập tới Server 

trong công ty hay truy cập ra Server bên ngoài internet. Truy cập tới dịch vụ này hay tới dịch vụ khác.

+ Được tải những phần dữ liệu nào: trong hệ thống có nhiều phòng ban, dựa vào giao thức ta có thể 

phân quyền truy cập tài nguyên. Người dùng có thể copy dữ liệu trên phòng ban của mình hoặc cả phòng ban khác.

+ Cho phép truyền hoặc tải bao nhiêu dữ liệu qua đường truyền: đường truyền là 100Mbps/s chúng ta có thể giới 

hạn tải xuống 20Mbps hoặc 50Mbps.
### 3. Các bước truyền thông qua mạng trong mô hình OSI: 

- Xét trường hợp cụ thể là truy cập vào trang Google.

=> Bước 1: mở trình duyệt IE hoặc Firefox trên máy tính gõ : http://google.com. Do IE là phần mềm sử dụng giao thức http, https (port 80, 443). Bộ giao thức này nằm ở tầng Application. Ai muốn viết phần mềm hoặc lập trình web thì phải tuân thủ.

=> Bước 2:  yêu cầu được nhập vào là ký tự trên bàn phím, máy tính sẽ chuyển đổi ra tín hiệu nhị phân (bit 0, 1) để cho máy tính hiểu. 
Để chuyển đổi được thì máy tính có hẳn riêng một bộ phận làm phiên dịch là tầng Presentation.

=> Bước 3: Trước yêu cầu được truyền đi máy tính sẽ có một bộ phận đàm phán phiên để truyền gọi là Session. Session ở đây nó sẽ tạo ra một kết nối trực tiếp tới Server google, được Server google đồng ý nó mới truyền yêu cầu. Sau khi kết thúc phiên nó sẽ đóng kết nối.

=> Bước 4: Để yêu cầu đi được (yêu cầu là dữ liệu) thì phải có bộ phận đóng gói dữ liệu đó là tầng Transport. Transport sẽ nhận dữ liệu từ Port 80 của giao thức http đi từ tầng Application xuống rồi đóng thêm giao thức để truyền thông là TCP hay UDP để truyền. Giao thức TCP ở tầng Transport có nhiệm vụ băm nhỏ dữ liệu ra thành các Segment (data và header). Trong header có cổng nguồn và cổng đích. Các Segment sẽ chuyển xuống tầng Network để xử lý (dữ liệu từ tầng này trở lên là độc lập với đường truyền). 

=> Bước 5: Tầng Network sẽ sử dụng IPv4 và IPv6 nhưng chủ yếu là IPv4. Khi các Segment đưa xuống sẽ đóng vào gói Data lớn hơn. Trong này sẽ có IP nguồn và IP đích (địa chỉ máy gửi là máy mình và địa chỉ máy nhận là địa chỉ Server Google). Sau đó sẽ đưa xống bên dưới là tầng Data Link.

=> Bước 6: Data link đóng vào địa chỉ MAC ( MAC nguồn và MAC đích). MAC của máy PC1 và MAC cổng Gateway. Data link sẽ đóng vào đầu là Header và cuối là Trailer. Sau đó đưa xuống đường vật lí (physical).

=> Bước 7: Đường vật lí là tín hiệu điện 0,1 được gửi đi (tín hiệu điện này khác với tín hiệu điện dữ liệu)

=> Bước 8: Sau khi gửi ra Router thì nó sẽ nhận các tín hiệu và đóng gói rồi phân tích địa chỉ MAC. Router sẽ xem địa chỉ MAC đích là ai nếu đúng nó sẽ xác định để xử lý. Nếu đúng nó tách ra và đưa lên tầng Network để xác định địa chỉ IP của đích tới. Sau khi xác định xong sẽ đóng gói lại và chuyển ra cổng bên ngoài. Router sẽ sử dụng bảng định tuyến để gửi ra đúng cổng cần chuyển. Tương tự các thiết bị Router kế tiếp sẽ nhận và gửi đi sau đó gửi tới đích là Server Google.

=> Bước 9: Sau khi xử lý Server sẽ gửi lại dữ liệu yêu cầu vào đường truyền. 

=> Bước 10: Sau khi dữ liệu tới đích nó sẽ gửi lên cửa sổ IE và kết thúc quá trình truyền thông.


## B. Tổng quan Mô hình 7 tầng OSI :

### 1. Định nghĩa :

#### a. Mô hình OSI là gì?

Open System Interconnection, tạm dịch là Mô hình tham chiếu kết nối các hệ thống mở, là một mô hình phân lớp nổi tiếng. Được phác thảo vào năm 1971 và hoàn thiện vào năm 1984. Mô hình này chia thành 7 lớp: Application, Presentation, Session, Transport, Network, Data link, Physical.
#### b. Tại sao lại phân lớp? 
Để truyền thông được chúng ta phải xây dựng một hệ thống mạng. Trong hệ thống mạng bao gồm thiết bị vật lý, đường truyền, dữ liệu và các giao thức. Một công ty không thể sản xuất và thiết kế được hết bấy nhiêu chức năng, nên người ta phải phân ra các lớp công việc để phát triển phù hợp.

- Các ưu điểm khi phân lớp:

	=> Giảm tải độ phức tạp của hệ thống khi truyền dữ liệu. Khi phân lớp người ta không phải sản xuất từ trên xuống dưới mà chỉ cần làm một phần công việc. Sản phẩm sẽ tốt hơn, tương thích với nhiều thành phần của các dòng sản phẩm khác nhau. <br>
	=> Trong mô hình OSI người ta phân ra thành các lớp chuẩn. Người sản xuất phải dựa vào chuẩn đó để xây dựng và phát triển. Do đó các lớp sẽ giao tiếp được với nhau. Từ đó tạo ra sự chuẩn hóa của các dòng sản phẩm <br>
	=> Do có sự chuẩn hóa về sản phẩm nên nó sẽ tương thích về công nghệ. Ngày này máy IBM có thể truyền tới máy HP <br>
	=> Thúc đẩy kỹ thuật module hóa: ai mạnh về lớp nào sẽ sản suất chuyên môn lớp đó. => Thúc đẩy phát triển của công nghệ <br>
	=> Người dùng dễ học hơn: không phải học hết cả 7 lớp một lúc mà học lần lượt đều được.	<br>

## 7 tầng OSI chia thành 2 phần:
**-Phần 1: gồm 3 tầng trên cùng sẽ đảm bảo công việc thiết lập giao tiếp giữa người dùng với máy tính, máy tính với máy tính.**
![Imgur](http://i.imgur.com/OQyt1QT.png)
<br>
**-Phần 2: gồm 4 tầng dưới cùng đảm nhận việc truyền tải dữ liệu , đảm bảo độ chính xác, an toàn cũng như gán các địa chỉ máy nguồn máy đích để gói tin đi đúng nơi.**
![Imgur](http://i.imgur.com/DNSLuYq.png)

![](http://i.imgur.com/VbZQJEv.png)
### 2. Cái nhìn tổng quan về 7 tầng OSI : đặc điểm, chức năng 

#### 2.1.	Tầng Ứng Dụng – Application Layer:

![Imgur](http://i.imgur.com/ZWsh1jb.jpg)

-	Là tầng người dùng giao tiếp với máy tính.
-	Chịu trách nhiệm xác định, thiết lập các kết nối cho người dùng tới những dịch vụ mà họ mong muốn tồn tại.
-	Việc truyền tải thông tin giữa các tổ chức hiện nay được mở rộng, yêu cầu các ứng dụng kết nối mạng như :
      - World wide web : Kết nối tới vô số các server . Các dữ liệu cơ bản như đồ họa, chữ, video, âm thanh.
      - Email – Gateways: linh hoạt trong việc sử dụng SMTP hoặc tiêu chuẩn X.400 để chuyển thư giữa các ứng dụng thư điện tử khác nhau.
      - Electronic Data Enterchange ( EDI)
	  

#### 2.2.	Tầng Phiên Dịch – Presentation Layer: 

![Imgur](http://i.imgur.com/jtwNY81.jpg) 

-	Trình bày dữ liệu : mã hóa, giải mã chuyển đổi mã hóa dữ liệu => chuyển dữ liệu người dùng nhập vào thành các chuẩn để các máy tính khác hiểu được trước khi đưa vào đường truyền. Đảm bảo dữ liệu gửi đi thì tầng ứng dụng của các máy khác sẽ đọc được.
- Một số chuẩn mã hóa của tầng phiên dịch :
  	*	PICT : định dạng cho ảnh
  	*	TIFF : định dạng cho tập tin đồ họa các độ phân giải cao
 	*	JPEG : định dạng chuẩn cho tập tin ảnh
 	*	MIDI : định dạng nhạc số
  	*	MPEG : điịnh dạng video cho đĩa CD với bit-rate lên tới 1.5Mbps
  	*	QuickTime: quản lí các ứng dụng chạy nhạc, video.

#### 2.3.	Tầng Phiên – Session Layer:

![Imgur](http://i.imgur.com/bq75Irf.jpg)

-	Chịu trách nhiệm thiết lập, quản lí và hủy các phiên làm việc với các máy khách. 
-	Cung cấp trình kiểm soát hộp thoại giữa các thiết bị số hoặc các chốt. Tầng này tạo các kết nối giữa các hệ thống khác nhau và thiết lập việc giao tiếp bằng 3 modes : simplex, hafl-duplex, full-duplex.
  *	Hafl- duplex ( bán lưỡng truyền) : dữ liệu truyền đi và về trên cùng đường truyền, khi đầu này gửi gói tin đi và đầu bên kia cũng gửi gói tin, khi đến nơi giao nhau, 1 gói tin phải nhường cho gói tin kia đi trước rồi nó mới có thể tiếp tục được truyền tải tiếp, có thể xảy ra xung đột
  *	Full- duplex ( lưỡng truyền)  : dữ liệu truyền đi và về trên cùng một đường truyền tuy nhiên theo 2 chiều khác nhau và hoàn toàn không liên quan gì đến nhau, do vậy không xảy ra xung đốt => tốc độ truyền nhanh hơn.
  *	Simplex ( đơn truyền ) : dữ liệu chỉ được truyền đi hoặc về .
- Một số ví dụ về giao thức ở tầng Phiên và giao diện : 
  	*	Network File System ( NFS) : cho phéo truy cập ẩn danh vào các tài nguyên ở xa.
 	*	Structured Query Language ( SQL ) : cung cấp cho người dùng cách thức đơn giản để xác định thông tin cần thiết ở cả hệ thống nội bộ và bên ngoài.
 	*	Remote Procedure Call ( RPC ) 
 	*	AppleTalk Session Protocol (ASP) : thiết lập và duy trì phiên làm việc giữa các máy khách của Appletalk và máy chủ.
  #### 2.4.	Tầng Giao vận – Transport Layer :
 
 ![Imgur](http://i.imgur.com/6kgB8Mv.jpg)

-	Các Segment và các dữ liệu cần lắp ráp lại từ các tầng ứng dụng ở trên gửi xuống sẽ được đựa vào 1 đường truyền chung. 
-	Cung cấp dịch vụ giao vận đầu – cuối và thiết lập các kết nối vật lí giữa máy gửi và máy nhận trong một khu vực mạng.
-	Sử dụng giao thức giao vận tin cậy ( TCP ) hoặc truyền thông không tin cậy ( UDP )
-	Chịu trách nhiệm cung cấp cơ chế hoạt động cho các dịch vụ ở các tầng ứng dụng ở trên như tạo phiên, hủy các kết nối ảo. Nó cũng ẩn các thông tin chi tiết phụ thuộc của  các tầng trên bằng cách cung cấp cơ chế truyền tải trong suốt.
##### a. Kiểm soát lưu lượng: 
Ngăn chặn việc máy chủ gửi dữ liệu đến máy khách khỏi việc quá tải , điều có thể gây mất dữ liệu. Việc truyền tải dữ liệu tin cậy sẽ yêu cầu các kết nối định hướng giữa các hệ thống, và các giao thức mà đảm bảo được những điều sau đây sẽ đủ tiêu chuẩn để truyền tải tin cậy :
  * Các phân đoạn đã được truyền đi được xác nhận lại cho người gửi khi máy khách nhận được.
  * Bất kỳ đoạn nào không được thừa nhận sẽ được truyền lại
  * Các đoạn được sắp xếp theo thứ tự đúng khi đến đích.
  * Một luồng dữ liệu quản lý được duy trì để tránh tình trạng tắc nghẽn, quá tải, và mất dữ liệu
  
##### b. Truyền thông hướng kết nối :
Trong truyền thông tin cậy ,khi 2 máy muốn kết nối với nhau , mỗi máy sẽ thông báo tới hệ thống của mình là 1 kết nối sắp được thiết lập, 2 hệ điều hành sẽ kết nối bằng cách gửi tin nhắn xác nhận cho nhau thông qua mạng về việc chuẩn bị kết nối. Khi mà việc yêu cầu đồng bộ giữa 2 bên hoàn thành, một kết nối sẽ được thiết lập và dữ liệu bắt đầu truyền. Đây gọi là quá trình BẮT TAY 3 BƯỚC. 

  - 	Trong khi dữ liệu được truyền giữa các máy, 2 máy sẽ kiểm tra định kì việc truyền tải của máy kia bằng phần mềm kiểm tra giao thức để chắc chắn mọi việc đều diễn ra ổn định và dữ liệu không bị thay đổi.
  ![Imgur](http://i.imgur.com/A7RacyL.png)
  
  *•	Phân đoạn 1 : Phần "thỏa thuận kết nối" đầu tiên là yêu cầu đồng bộ hóa
  •	Phân đoạn 2,3 : Các phân đoạn thứ hai và thứ ba thừa nhận yêu cầu và 
  thiết lập các thông số kết nối giữa các máy chủ
  •	Phân đoạn cuối : các yêu cầu được thừa nhận. Nó thông báo cho máy chủ đích
  rằng thỏa thuận kết nối được chấp nhận và kết nối thực tế đã được thiết lập.
  Việc truyền dữ liệu bây giờ có thể bắt đầu.*
  
   - Trong quá trình truyền dữ liệu có thể xảy ra tắc nghẽn do máy tính có tốc độ cao gửi dữ liệu vào đường truyền có trải trọng thấp, hoặc là có quá nhiều kết nối từ nhiều máy tới một gateway (freeway bottleneck). Khi một máy nhận quá nhiều dữ liệu trong thời gian ngắn, nó sẽ lưu tạm vào một bộ nhớ đệm. Bộ nhớ đệm sẽ có tác dụng đối với các luồng flood dữ liệu cường độ nhỏ, đối với các luồng quá lớn dẫn đến quá tải,thì máy đó sẽ ngừng không nhận thêm bất cứ dữ liệu  nào truyền vào.
   - Điều này sẽ được giải quyết bằng một chức năng của tầng transport. Mỗi khi dữ liệu đến máy nhận, máy nhận sẽ gửi một tín hiệu báo cho máy gửi tiếp tục gửi dữ liệu sang.Cứ như vậy cho đến khi truyền xong.
   ![Imgur](http://i.imgur.com/ZVzXn8P.png)
   
##### c. Windowing - cửa sổ trượt : 
Dữ liệu truyền qua đường truyền bằng giao thức truyền thông tin cậy sẽ phải chờ máy khách đã nhận dữ liệu, rồi mới gửi tiếp các segment khác. Tuy nhiên quá trình đó sẽ mất nhiều thời gian và tốc độ không cao, vì vậy hình thành nên giao thức gửi dữ liệu bằng *windowing*. 
  - 	Với mỗi lần gửi, nó cho phép nhiều hơn một segment được gửi đi trước khi thông báo nhận được dữ liệu từ máy khách được gửi lại. Vì vậy dữ liệu sẽ được gửi nhiều hơn trong thời gian nhanh hơn.
  ![Imgur](http://i.imgur.com/slJToQm.png)
  
  **Bản Tin ACK ( Acknowledgement) : bản  tin xác nhận**
  - Sử dụng cách thức : *positive acknowledgment with retransmission* – truyền thông tin xác nhận
  - Khi bất cứ segment nào được gửi đi, phương pháp đó sẽ gửi một xác nhận tới máy gửi rằng nó đã nhận được hay chưa, được rồi thì máy nhận sẽ gửi segment tiếp theo, nếu chưa thì gửi lại segment vừa rồi.
![Imgur](http://i.imgur.com/CPIC5EW.png)

 #### 2.5.Tầng Mạng – Network Layer : Thiết bị hoạt động ở lớp 3 - Router
 ![Imgur](http://i.imgur.com/IqU2F5X.gif)
 
-	Lớp Mạng có trách nhiệm định tuyến thông qua mạng và địa chỉ mạng. Điều này có nghĩa là lớp Mạng có trách nhiệm truyền tải lưu lượng giữa các thiết bị không nằm trong vùng mạng nội bộ. 
-	Routers hoặc các thiết bị khác ở lớp 3 hoạt động và cung cấp dịch vụ định tuyến ở tầng này.
-	Cơ chế : khi một packet được router nhận , nó sẽ kiểm tra địa chỉ IP đích của gói tin. Nếu gói tin có địa chỉ đích không phải nó, router sẽ tra cứu trong bảng định tuyến của mình. Khi kiểm tra có địa chỉ IP đó, packet sẽ được chuyển xuống tầng Datalink của Router để gắn địa chỉ MAC thành frame, và gửi ra ngoài mạng nội bộ để truyền tới các router khác. Nếu nó kiểm tra trong bảng định tuyến không thấy IP đích, gói tin đó sẽ bị vứt bỏ.
-	Có 2 loại gói tin ( packets) được sử dụng ở lớp Network :
 
 **Data Packets** : Được sử dụng để vận chuyển dữ liệu người dùng thông qua mạng, và các giao thức được sử dụng để hỗ trợ lưu lượng dữ liệu được gọi là các giao thức định tuyến. VD : IP và IPX </br>
  **Route update packets :** được sử dụng để cập nhật dữ liệu cho các router lân cận về các kết nối đã được thiết lập trong hệ thống mạng. Giao thức dùng để gửi các gói tin này được gọi là giao thức định tuyến, ví dụ như RIP, EIGRP, OSPF.. Gói tin này được sử dụng để xây dựng và duy trì các bảng định tuyến trên mỗi router.
![Imgur](http://i.imgur.com/naAakVn.png)
  
  **Các thông tin trên bảng định tuyến :**
	Network Address : Địa chỉ mạng cụ thể theo giao thức. Một router phải duy trì một bảng định tuyến cho các giao thức định tuyến riêng lẻ vì mỗi giao thức định tuyến theo dõi một mạng với một sơ đồ địa chỉ khác nhau
  •	Địa chỉ đích của mạng, mạng con hoặc hệ thống.
  •	Địa chỉ IP của router chặng kế tiếp phải đến.
  •	Mặt nạ mạng của địa chỉ đích
  • Interface: Giao tiếp vật lí phải sử dụng để đi đến Router kế tiếp.
• Metric : Khoảng cách đến đích (ví dụ: số lượng chặng để đến đích).
•Thời gian (tính theo giây):  từ khi Router cập nhật lần cuối

**Một số lưu ý về Router :**
</br>
  *
   -	Theo mặc định, các router sẽ không chuyển tiếp bất kỳ gói tin broadcast hoặc multicast nào </br>
   -	Router sử dụng địa chỉ logic trong header của một lớp mạng để xác định điểm tiếp theo để chuyển tiếp các gói tin đến. </br>
   -	Router có thể sử dụng danh sách truy cập do quản trị viên tạo ra để kiểm soát bảo mật trên các gói đang cố gắng xâm nhập hoặc thoát một cổng kết nối.</br>
   -  Router có thể cung cấp các chức năng cầu nối tầng 2 nếu cần và có thể đồng thời định tuyến qua cùng một giao diện.</br>
   -  Các thiết bị lớp 3 (trong trường hợp này là router) cung cấp các kết nối giữa các Virtual LANs (VLANs)</br>
   -  Router có thể cung cấp Chất lượng Dịch vụ (QoS) cho các loại lưu lượng mạng cụ thể.*
  

 #### 2.6.	Tầng liên kết dữ liệu – Data Link Layer : Thiết bị hoạt động ở lớp 2 - Switch
![Imgur](http://i.imgur.com/49Urdvb.png)

**Chức năng :** 
   -	Đảm bảo gói tin sẽ được gửi tới đúng thiết bị và phiên dịch các gói tin đó thành các bit 1 0 0 1 để truyền xuống tầng vật lý.
   - 	Các packets từ tầng Network sẽ được đóng gói vào các đơn vị lớn hơn gọi là Frame. Địa chỉ MAC nguồn và MAC đích sẽ được gắn vào frame.
   - 	Để thực hiện được nhiệm vụ đó thì tầng Data link dùng 2 giao thức là LLC (logical link control) và MAC (Media Access Control ) được nằm trong bộ tiêu chuẩn Ethernet:
          - LLC : 802.2 dùng để liên kết dữ liệu với bên trên đồng thời bắt đầu xây dựng frame và chỉ định giao thức hoạt động ở tầng mạng (IP, IPX, Apple talk).
                - Header của LLC cho biết Tầng liên kết dữ liệu phải làm gì khi nhận được gói tin. Ví dụ máy chủ nhận được một frame, nó sẽ dò tìm trong header của LLC để biết rằng gói tin này được thiết kế cho giao thức IP ở tầng Network. LLC có thể cung cấp điều khiển luồng và sắp xếp các bit điều khiển
     - MAC : 802.3 dùng để hoàn thiện xây dựng Frame bằng việc thêm vào các địa chỉ, mã bắt đầu và mã kết thúc của một Frame (MAC này khác địa chỉ MAC).
                -	Quy định đường dây, thông báo lỗi (không sửa chữa), yêu cầu phân phối frame và điều khiển luồng tùy chọn cũng có thể được sử dụng tại lớp con này.
            

**Switch và Bridges ở tầng Liên kết dữ liệu :**
  - Switch và Bridge đều làm việc ở tầng Data Link, thuộc layer 2 và sử dụng địa chỉ vật lý MAC. 
  - Switch Layer 2 được coi là cầu nối dựa trên phần cứng vì nó sử dụng một phần cứng chuyên dụng gọi là mạch tích hợp ứng dụng cụ thể (ASICs). ASIC có thể chạy ở tốc độ gigabit với độ trễ rất thấp.
  - Bridges và switches đọc mỗi frame đi qua mạng,sau đó sẽ lưu địa chỉ MAC nguồn vào 1 bảng filter và ghi nhớ cổng đã nhận frame đó vào, điều này sẽ cho nó biết thiết bị đó ở switch hoặc ở [phân đoạn mạng](https://github.com/Skyaknt/CCNA-basic-/blob/master/Phân%20đoạn%20mạng%20-%20Network%20Segment.md) nào.
   - Sau khi bảng filter được tạo ở switch, switch sẽ chỉ chuyển tiếp các frames đến đến các phân đoạn mạng đích mà địa chỉ MAC đích của nó đã quy định tới. Nếu frame đó thuộc vào một phân đoạn mạng (network segment) đã biết từ trước thì switch sẽ khóa và ngăn nó truyền tới các segment khác. Còn trường hợp đích là các network segments khác, không phải segment đó, thì frame đó sẽ vẫn chỉ được truyền tới tất cả các segments . Điều này được gọi là transparent bridging.
   - Khi thiết bị lớp 2 nhận một frame và địa chỉ MAC của nó chưa được lưu trên bảng filter, nó sẽ chuyển frame đó tới tất cả các segments đang lưu thông trong đường truyền. Nếu tại một thiết bị nào đó nó trả lời lại việc chuyển tiếp frame đó của thiết bị gửi, thì nó sẽ lưu địa chỉ MAC của thiết bị mới này vào bảng filter. Tuy nhiên thì trong một số trường hợp địa chỉ đích của việc chuyển tiếp frame có thể là địa chỉ broadcast.
    - Lợi ích lớn nhất của Switch thay vì hub là trong hệ thống mạng nội bộ, mỗi cổng của switch có riêng miền xung đột của nó ( collision domain) trong khi hub lại tạo nên một miền xung đột tổng. Vì thế mà switch sẽ có thể cho phép nhiều mạng cùng kế nối trong 1 thời điểm còn hub chỉ có 1.
    - Một lợi ích khác của chuyển mạch LAN ( LAN switching ) so với hub là mọi frame truyền qua switch sẽ được chuyển tiếp ngay lập tức vì mỗi frame đều có miền xung đột riêng.
    - Switch không thể phiên dịch các loại truyền thông khác nhau. Có nghĩa là nếu một thiết bị kết nối vào switch phải sử dụng một loại Ethernet frame riêng. Nếu muốn kết nối vào mạng hình sao hoặc mạng Lan thì cần router để cung cấp dịch vụ phiên dịch.

#### 2.7.	Tầng Vật Lý – Physical Layer :
![Imgur](http://i.imgur.com/ozzdFZy.gif)

-	Chức năng : gửi và nhận bits 0,1
-	Mỗi loại thông tin truyền thông sử dụng các định dạng bit khác nhau.
-	Các đặc tính của Lớp Vật lý xác định yêu cầu về điện, cơ, thủ tục và chức năng để kích hoạt, duy trì và tắt một liên kết vật lý giữa các hệ thống đầu cuối.
-	Tại lớp Vật lý, giao diện giữa Thiết bị đầu cuối dữ liệu (Data Terminal Equipment - DTE) và Thiết bị Ngắt kết nối Dữ liệu ( DCE - Data Circuit-Terminating Equipment), được xác định. DCE thường nằm ở nhà cung cấp dịch vụ, trong khi DTE là Thiết bị đính kèm. Các dịch vụ có sẵn cho DTE thường được truy cập thông qua Một modem hoặc đơn vị dịch vụ kênh / đơn vị dịch vụ dữ liệu (CSU / DSU)
-	Các kết nối vật lý và cơ chế vật lý khác nhau được định nghĩa bởi chuẩn OSI như là , cho phép các hệ thống giao tiếp có thể giao tiếp với nhau dễ dàng.


**Hub ở tầng Vật Lý**


Hub là một bộ lặp có nhiều cổng. Một bộ lặp nhận các tín hiệu số và khuếch đại hoặc tái tạo chúng , sau đó chuyển chúng đến các cổng đang kết nối với nó mà không cần kiểm tra. Điều đó có nghĩa rằng tất cả các thiết bị kết nối với hub sẽ nằm chung trong một miền xung đột cũng như chung một miền quảng bá. 
Hub tạo ra một mạng vật lý mà nó là trung tâm và các cáp kết nối từ nó đến tất cả các hướng tạo thành hệ thống mạng hình sao. Tuy nhiên thì mạng Ethernet sử dụng một cơ chế bus hợp lí hơn, có nghĩa là tín hiệu sẽ phải đi từ điểm đàu tới điểm cuối của mạng, mỗi thiết bị kết nối vào hub phải lắng nghe khi có một thiết bị phát tín hiệu.



  
