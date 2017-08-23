# Tổng quan về VOIP (Voice over Internet Protocol) 
## 1. VoIP là gì? 
### Lịch sử hình thành 
Đầu năm 1995 công ty VOCALTEC đưa ra thị trường sản phẩm phần mềm thực hiện cuộc thoại qua Internet đầu tiên trên thế giới. Sau đó có nhiều công ty đã tham gia vào lĩnh vực này. Tháng 3 năm 1996, VOLCALTEC kết hợp với DIALOGIC tung ra thị trường sản phẩm kết nối mạng PSTN và Internet. Hiệp hội các nhà sản xuất thoại qua mạng máy tính đã sớm ra đời và thực hiện chuẩn hoá dịch vụ thoại qua mạng Internet. Việc truyền thoại qua internet đã gây được chú ý lớn trong những năm qua và đã dần được ứng dụng rộng rãi trong thực tế. 
### Khái niệm
VoIP viết tắt của cụm từ  `Voice over Internet Protocol` là một công nghệ cho phép truyền thoại sử dụng giao thức mạng IP, trên cơ sở hạ tầng sẵn có của mạng Internet. VoIP là một trong những công nghệ viễn thông đang được quan tâm nhất hiện nay không chỉ đối với các nhà khai thác, các nhà sản xuất mà còn cả với người sử dụng dịch vụ. VoIP có thể vừa thực hiện cuộc gọi thoại như trên mạng điện thoại kênh truyền thống (PSTN) đồng thời truyền dữ liệu trên cơ sở mạng truyền dữ liệu. Như vậy, nó đã tận dụng được sức mạnh và sự phát triển vượt bậc của mạng IP vốn chỉ được sử dụng để truyền dữ liệu thông thường. 
### Ưu điểm và nhược điểm của điện thoại IP
- Ưu điểm 
	+ Giảm chi phí cuộc gọi
	+ Tích hợp mạng thoại, mạng số liệu và mạng báo hiệu
	+ Khả năng mở rộng, có nhiều tính năng mới
	+ Không cần thông tin điều khiển để thiết lập kênh truyền vật lý
	+ Khả năng multimedia tức là vừa nghe gọi vừa có thể chia sẻ dữ liệu
- Hạn chế
	+ Kỹ thuật phức tạp 
	+ Vấn đề bảo mật
Qua đó điện thoại IP chứng tỏ nó là một loại hình dịch vụ rất có tiềm năng.
### Các mô hình giao tiếp qua IP
#### Mô hình PC to PC 

<img src="http://i.imgur.com/V2KPU6v.png">

Trong mô hình này, mỗi máy tính cần được trang bị một sound card, một microphone, một speaker và được kết nối trực tiếp với mạng Internet thông qua modem hoặc card mạng. Mỗi máy tính được cung cấp một địa chỉ IP và hai máy tính đã có thể trao đổi các tín hiệu thoại với nhau thông qua mạng Internet. Tất cả các thao tác như lấy mẫu tín hiệu âm thanh, mã hoá và giải mã, nén và giải nén tín hiệu đều được máy tính thực hiện. Trong mô hình này chỉ có những máy tính nối với cùng một mạng mới có khả năng trao đổi thông tin với nhau. 
#### Mô hình PC to Phone 

<img src="http://i.imgur.com/5OHNTIW.png">

Mô hình PC to Phone là một mô hình được cải tiến hơn so với mô hình PC to PC. Mô hình này cho phép người sử dụng máy tính có thể thực hiện cuộc gọi đến mạng PSTN thông thường và ngược lại. Trong mô hình này mạng Internet và mạng PSTN( mạng điện thoại công cộng) có thể giao tiếp với nhau nhơ một thiết bị đặc biệt đó là Gateway. 
#### Mô hình Phone to Phone 

<img src="http://i.imgur.com/ORpaFsy.png">

Đây là mô hình mở rộng của mô hình PC to Phone sử dụng Internet làm phương tiện liên lac giữa các mạng PSTN. Tất cả các mạng PSTN đều kết nối với mạng Internet thông qua các gateway. Khi tiến hành cuộc gọi mạng PSTN sẽ kết nối đến gateway gần nhất. Tại gateway địa chỉ sẽ được chuyển đổi từ địa chỉ PSTN sang địa chỉ IP để có thể định tuyến các gói tin đến được mạng đích. Đồng thời gateway nguồn có nhiệm vụ chuyển đổi tín hiệu thoại tương tự thành dạng số sau đó mã hoá, nén, đóng gói và gửi qua mạng. Mạng đích cũng được kết nối với gateway và tại gateway đích, địa chỉ lại được chuyển đổi trở lại thành địa chỉ PSTN và tín hiệu được giải nén, giải mã chuyển đổi ngược lại  thành tín hiệu tương tự gửi vào mạng PSTN đến đích. 
### 2. Thành phần trong hệ thống VoIP

<img src="http://i.imgur.com/HhAMiiY.jpg">

Một hệ thống VoIP bao gồm: Gateway, PBX server, VoIP Server, IP network và End User Equipments

- Gateway: là thiết bị chuyển đổi analog signal sang digital signal (và ngược lại).

- PBX server: Máy chủ PBX là tương tự như một máy chủ proxy: các máy khách SIP, có thể là điện thoại dạng phần mềm hay phần cứng, đăng ký với máy chủ PBX và khi chúng muốn thực hiện cuộc gọi, chúng yêu cầu máy IP PBX thiết lập kết nối. Máy chủ PBX có một danh mục tất cả mọi điện thoại/người dùng và địa chỉ SIP tương ứng của họ và do vậy có khả năng kết nối cuộc gọi trong mạng hay dẫn hướng cuộc gọi từ bên ngoài thông qua máy VoIP gateway hay một nhà cung cấp dịch vụ VoIP.

- VoIP server: là các máy chủ trung tâm có chức năng định tuyến và bảo mật cho các cuộc gọi VoIP. Trong mạng H.323 chúng được gọi là gatekeeper. Trong mạng SIP các server được gọi là SIP server.

- Thiết bị đầu cuối (End user equipments): Có thể sử dụng Softphone hoặc thiết bị phần cứng. Softphone được cài trên máy tính cá nhân như: Skype, Ekiga, GnomeMeeting, Microsoft Netmeeting, SIPSet, Cisco IP Communication… Phần cứng thì sử dụng những điện thoại IP Phone thuần chuyên về VoIP.

- IP phone: là các điện thoại dùng riêng cho mạng VoIP. Các IP phone không cần VoIP Adapter bởi chúng đã được tích hợp sẵn bên trong để có thể kết nối trực tiếp với các VoIP server.

## 2. Các giao thức trong mạng VoIP
### H323
#### Khái niệm 
Giao thức H.323 là chuẩn do ITU-T phát triển cho phép truyền thông đa phương tiện qua các hệ thống dựa trên mạng chuyển mạch gói, ví dụ như Internet. Tiêu chuẩn H.323 bao gồm báo hiệu và điều khiển cuộc gọi, truyền và điều khiển đa phương tiện và điều khiển băng thông cho hội nghị điểm - điểm và đa điểm. 
#### Tiêu chuẩn H.323 bao gồm các giao thức 
|Tính năng|Giao thức|
|---------|---------|
|Call Signalling|H.225| 
|Media Control|H.245| 
|Audio Codecs|G.711, G.722, G.723, G.728, G.729| 
|Video Codecs|H261, H263| 
|Data Sharing|T.120| 
|Media Transport|RTP/RTCP|
#### Các thành phần của H.323

<img src="http://i.imgur.com/E2ei7Kh.png">

### SIP
#### Khái niệm 
SIP là giao thức điều khiển báo hiệu thuộc lớp ứng dụng, được phát triển như là một chuẩn mở RFC 2543 của IEFT. Khác với H.323, nó dựa trên nguồn gốc Web (HTTP) và có thiết kế kiểu modul, đơn giản và dễ dàng mở rộng với các ứng dụng thoại SIP. SIP là một giao thức báo hiệu để thiết lập, duy trì và kết thúc các phiên đa phương tiện như : thoại IP, hội nghị và các ứng dụng tương tự khác liên quan đến việc truyền thông tin đa phương tiện. 
#### Các thành phần của SIP

<img src="http://i.imgur.com/IX5IeGO.jpg">

- User Agent: Là 1 ứng dụng để khởi tạo, nhận và kết thúc cuộc gọi. 
	+ User Agent Clients (UAC): Khởi tạo cuộc gọi. 
	+ User Agent Server (UAS): Nhận cuộc gọi. 
	+ Cả UAC và UAS đều có thể kết thúc cuộc gọi. 
- Proxy Server: Là 1 chương trình tức thời hoạt động vừa là client vừa là server. Chương trình này được sử dụng để tạo ra các yêu cầu (requests) thay cho các client. Một proxy server đảm bảo chức năng định tuyến và thực hiện các quy tắc (policy) (ví dụ như đảm bảo người dùng có được phép gọi hay không). Proxy Server có thể biên dịch khi cần thiết, sửa đổi 1 phần của bản tin yêu cầu trước khi chuyển đi. 
- Location Server: Được sử dụng bởi SIP redirect hoặc proxy server để lấy thông tin về địa điểm của người được gọi.
- Redirect Server: Là server nhận các yêu cầu SIP, sắp xếp các địa chỉ và trả địa chỉ về phía client. Khác với Proxy Server, Redirect server không tự khởi tạo ra các yêu cầu SIP của riêng nó. Đồng thời nó cũng không chấp nhận hay huỷ cuộc gọi giống như User Agent Server. 
- Registrar Server: Là server chấp nhận các yêu cầu REGISTER, server này có thể hỗ trợ them tính năng xác thực, đồng thời hoạt động với proxy hoặc redirect server để đưa ra các dịch vụ khác. Trong hình trên, User Agent là thiết bị đầu cuối trong mạng SIP, có thể là một máy điện thoại SIP, có thể là máy điện thoại SIP, có thể là máy tính chạy phần mềm đầu cuối SIP. 
#### Các bản tin của SIP
SIP gồm có các bản tin sau:

- INVITE : bắt đầu thiết lập cuộc gọi bằng cách gửi bản tin mời đầu cuối khác tham gia 
- ACK : bản tin này khẳng định máy trạm đã nhận được bản tin trả lời bản tin INVITE
- BYE : bắt đầu kết thúc cuộc gọi 
- CANCEL : hủy yêu cầu nằm trong hàng đợi 
- REGISTER : đầu cuối SIP sử dụng bản tin này để đăng ký với máy chủ đăng ký 
- OPTION : sử dụng để xác định năng lực của máy chủ 
- INFO : sử dụng để tải các thông tin như âm báo Dual Tone Multi Frequency (đa tần kép)

Giao thức SIP có nhiều điểm trùng hợp với giao thức HTTP. Các bản tin trả lời các bản tin SIP nêu trên gồm có : 

- 1xx (PROVISIONAL) –  các bản tin chung 
- 2xx (SUCCESS) – thành công 
- 3xx (REDIRECTION): chuyển địa chỉ 
- 4xx (CLIENT ERORR): yêu cầu không được đáp ứng 
- 5xx (SERVER ERORR): sự cố của máy chủ 
- 6xx (GLOBAL FAILURE): sự cố toàn mạng 
Các bản tin SIP có khuôn dạng text, tương tự như HTTP. Mào đầu của bản tin SIP cũng tương tự như HTTP và SIP cũng hỗ trợ MIME (một số chuẩn về email) 
#### Các bước thiết lập, duy trì và hủy cuộc gọi 
##### Thiết lập và hủy cuộc gọi SIP 
Trước tiên ta tìm hiểu hoạt động của máy chủ ủy quyền và máy chủ chuyển đổi 

- Hoạt động của máy chủ ủy quyền (Proxy Server)

Client SIP A gửi bản tin INVITE cho B để mời tham gia cuộc gọi.
	
<img src="http://i.imgur.com/kxUUrjZ.png">

Các bước như sau: 
	
	+ Bước 1: A gửi bản tin INVITE cho B ở miền B, bản tin này đến proxy server SIP của miền B (Bản tin INVITE có thể đi từ Proxy server SIP của miền yahoo.com và được Proxy này chuyển đến Proxy server của miền hotmail.com). 
	+ Bước 2: Proxy server của miền hotmail.com sẽ tham khảo server định vị (Location server) để quyết định vị trí hiện tại của UserB. 
	+ Bước 3: Server định vị trả lại vị trí hiện tại của B. 
	+ Bước 4: Proxy server gửi bản tin INVITE tới B. Proxy server thêm địa chỉ của nó trong một trường của bản tin INVITE. 
	+ Bước 5: UAS của B đáp ứng cho server Proxy với bản tin 200 OK. 
	+ Bước 6: Proxy server gửi đáp ứng 200 OK trở về A 
	+ Bước 7: A gửi bản tin ACK cho B thông qua proxy server. 
	+ Bước 8: Proxy server chuyển bản tin ACK cho B 
	+ Bước 9: Sau khi cả hai bên đồng ý tham dự cuộc gọi, một kênh RTP/RTCP được  giữa hai điểm cuối để truyền tín hiệu thoại. 
	+ Bước 10: Sau khi quá trình truyền dẫn hoàn tất, phiên làm việc bị xóa bằng cách sử dụng bản tin BYE và ACK giữa hai điểm cuối. 

- Hoạt động của máy chủ chuyển đổi địa chỉ (Redirect Server) 
	
	<img src="http://i.imgur.com/JdwIATK.png">
	
  	+ Bước 1: Redirect server nhân được yêu cầu INVITE từ người gọi (Yêu cầu này có thể đi từ một proxy server khác). 
	+ Bước 2: Redirect server truy vấn server định vị địa chỉ của B. 
	+ Bước 3: Server định vị trả lại địa chỉ của B cho Redirect server. 
	+ Bước 4: Redirect server trả lại địa chỉ của B đến người gọi A. Nó không phát yêu cầu INVITE như proxy server. 
	+ Bước 5: User Agent bên A gửi lại bản tin ACK đến Redirect server để xác nhận sự trao đổi thành công. 
	+ Bước 6: Người gọi A gửi yêu cầu INVITE trực tiếp đến địa chỉ được trả lại bởi Redirect server (đến B). Người bị gọi B đáp ứng với chỉ thị thành công (200 OK), và người gọi đáp trả bản tin ACK xác nhận. Cuộc gọi được thiết lập. Ngoài ra SIP còn có các mô hình hoạt động liên mạng với SS7 (đến PSTN) hoặc là liên mạng với chồng giao thức H.323.
##### Tổng quát lại trong mạng SIP quá trình thiết lập và hủy một phiên kết nối: 
- Đăng ký, khởi tạo và xác định vị trí người sử dụng. 
- Xác định băng thong cần thiết được sử dụng. 
- Xác định sự sẵn sàng của phía được gọi, phía được gọi phải gửi 1 bản tin phản hồi thể hiện sự sẵn sàng để thực hiện cuộc gọi: chấp nhận hay từ chối. 
- Cuộc gọi được thiết lập. 
- Chỉnh sửa cuộc gọi (ví dụ như chuyển cuộc gọi) và duy trì. 
- Kết thúc cuộc gọi. 	
