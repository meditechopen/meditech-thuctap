# CIFS ( Common Internet File System )

CIFS được sử dụng để cung cấp dịch vụ chia sẻ file giữa người dùng trong mạng internet và intranet.

## 1. Tổng quan

- CIFS là giao thức sử dụng để chia sẻ file qua mạng. CIFS cho phép các máy windows chia sẻ file với nhau 
 và các tài nguyền khác. 
 
- Server Message Block (SMB) là một giao thức sử dụng cho việc truy cập tệp tin qua mạng và CIFS là một phiên bản 
công khai của SMB. 
	- SMB cho phép một máy tính truy cập các tệp và yêu cầu cá dịch vụ trên các máy tính khác trong  mạng LAN.
	
- Với sự mở rộng của các doanh nghiệp, dịch vụ chia sẻ file tăng lên dẫn đến hiệu suất giảm đi.
=> Cần thiết cải thiện hiệu suất truy cập các tập tin chia sẻ.

- Tính năng CIFS cho phép các máy khách Windows xác định và truy cập các tài nguyên được chia sẻ được 
cung cấp bởi hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T. 
	
	- Với CIFS, khách hàng có thể nhanh chóng đọc, viết và tạo các tệp trong hệ thống lưu trữ 
	OceanStor S2600T / S5500T / S5600T / S5800T / S6800T như trên các máy tính local. 
	Hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T mang lại hiệu năng cao, 
	giải quyết vấn đề giảm tốc độ truy cập và phản ứng chậm.
	
**Các ưu điểm của CIFS** :

- **High concurrency** ( hỗ trợ số lượng truy cập lớn ): CIFS hỗ trợ chia sẻ tập tin và các cơ chế khóa tập tin, 
cho phép nhiều khách hàng truy cập và cập nhật một tệp tin. Nhiều khách hàng có thể truy cập tệp cùng lúc, 
nhưng chỉ một khách hàng mới được phép cập nhật tệp mỗi lần.

- **High performance** ( hiệu xuất cao ) : Yêu cầu truy cập được gửi bởi khách hàng cho tệp được chia sẻ được 
lưu trữ trên bộ nhớ cache trên máy local nhưng không được gửi tới hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T. 
Khi khách hàng gửi yêu cầu truy cập cho các tệp chia sẻ một lần nữa, hệ thống trực tiếp đọc các tệp tin 
được chia sẻ trong bộ nhớ cache, cải thiện hiệu suất truy cập.

- **Data integrity** ( toàn vẹn dữ liệu ) : CIFS cung cấp chức năng cache, pre-read, và write back 
để đảm bảo tính toàn vẹn dữ liệu. Yêu cầu truy cập được gửi bởi khách hàng cho tệp được chia sẻ 
được lưu trữ cục bộ nhưng không được gửi tới hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T. 
Nếu các máy khách khác muốn truy cập tệp tin được chia sẻ, dữ liệu được lưu trữ sẽ được ghi vào hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T. 
Chỉ một tập tin sao chép được kích hoạt mỗi lần để ngăn ngừa xung đột dữ liệu.

- **Robust security** ( bảo mật cực tốt) : CIFS hỗ trợ chuyển file theo hình thức vô danh và chia sẻ quyền truy cập. 
Chức năng quản lý chứng thực kiểm soát quyền truy cập của người dùng, đảm bảo bảo mật dữ liệu.

- **Wide application** ( ứng dụng rộng rãi ) : bất kỳ người dùng nào sử dụng máy tính hỗ trợ giao thức CIFS đều 
có thể truy cập vào không gian chia sẻ CIFS.

- **Unified coding standard** (Tiêu chuẩn mã hoá thống nhất): CIFS hỗ trợ nhiều loại bộ ký tự, áp dụng cho các hệ thống ngôn ngữ khác nhau.


## 1.2 Đặc tả 

Bảng dưới liệt kê các chi tiết kỹ thuật của chia sẻ CIFS dựa trên một hệ thống lưu trữ 
OceanStor S2600T / S5500T / S5600T / S5800T / S6800T.

![Imgur](https://i.imgur.com/UOJAusV.png)


*a: số người dùng và miền truy cập của người dùng trên một hệ thống lưu trữ không thể lớn hơn 3000, 
và số lượng nhóm người dùng cũng không được quá 3000.*

*b: số lượng các liên kết trực tuyến quy chiếu từ số lượng người dùng trực tuyến.*

*c: mỗi hệ thống NAS engine node hỗ trợ nhiều nhất 400 active links.

## 1.3 Tính khả dụng 

- **License Requirement** : để sử dụng dịch vụ CIFS cần phải có giấy phép.

- **Applicable version** ( phiên bản ứng dụng ):

![Imgur](https://i.imgur.com/ClaQdfV.png)

- **Yêu cầu hệ thống mạng**: 

	- Chức năng chia sẻ trên CIFS  hỗ trợ IPv4 nhưng không hỗ trợ IPv6.
	- Khi tính năng chia sẻ CIFS được áp dụng cho domain enviroment, bạn cần phải cấu hình domain controller. 
	Các mục cấu hình được mô tả trong Bảng dưới.
	
	![Imgur](https://i.imgur.com/1FWXiWH.png)


- **Tính năng phụ thuộc** :

Bảng dưới mô tả sự phụ thuộc giữa tính năng chia sẻ CIFS với các tính năng khác.

![Imgur](https://i.imgur.com/5oFw6YK.png)

- **Hiệu suất của hệ thống** :

Chức năng chia sẻ của CIFS có những ảnh hưởng sau đến hiệu suất của hệ thống:

	- Hệ thống này hỗ trợ chia sẻ hệ thống tập tin thông qua CIFS, NFS, FTP và HTTP. 
	Khi hệ thống tập tin được truy cập bởi các khách hàng bằng cách sử dụng các giao thức khác nhau, 
	hiệu suất hệ thống tổng thể sẽ bị giảm đi một chút.

	- Các hệ thống tệp khác nhau cung cấp dịch vụ chia sẻ thông qua CIFS hoặc NFS. 
	Nếu một tính năng chia sẻ đang được sử dụng, hiệu suất của tính năng chia sẻ kia sẽ bị giảm đi.
	
	- Hiệu suất của hệ thống sẽ giảm nếu khách hàng truy cập một số lượng lớn các tệp tin nhỏ trong phần 
	 CIFS sau khi hệ thống tệp tin công nghệ mới (NTFS) được bật vì hệ thống 
	lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T sẽ phải dành một khoảng thời gian lớn cho việc xác thực. 
	Vì vậy, bạn nên không cho phép NTFS được bật trong CIFS.
	
	- Hiệu suất của hệ thống bị giảm đi nếu snapshots được tạo sau khi CIFS Nomal Share được tạo cho các file hệ thống.
	
## 1.4 Ngữ cảnh của ứng dụng

Chia sẻ CIFS chủ yếu áp dụng cho việc chia sẻ tệp tin của khách hàng Windows. 
CIFS được chia thành 2 loại hình thức chia sẻ file : CIFS Nomal và CIFS Homedir.

### CIFS Nomal SHare trong Môi trường không có miền quảng bá (Non - Domain Enviroment)

- Với sự mở rộng liên tục của các doanh nghiệp, ngày càng nhiều dữ liệu cần được chia sẻ trong các doanh nghiệp. 
Do đó, các doanh nghiệp đòi hỏi phải có không gian chia sẻ lớn để người dùng lưu trữ dữ liệu được chia sẻ và quản lý không gian chia sẻ đơn giản.

Hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T chia sẻ hệ thống tệp tin cho tất cả người dùng của doanh nghiệp ở chế độ CIFS bình thường. 
Hệ thống tệp chia sẻ sẽ xuất hiện dưới dạng thư mục. Tất cả người dùng có thể truy cập thư mục chia sẻ. 
Bên cạnh đó, quản lý sự cho phép dựa trên local group cho phép các doanh nghiệp kiểm soát quyền của người dùng đối với thư mục chia sẻ. 
Trong khi đó, hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T cho phép các 
doanh nghiệp thiết lập hạn ngạch không gian chung cho các phòng ban và người sử dụng. 
Quản lý hạn ngạch người dùng đảm bảo rằng tất cả người dùng có thể thực hiện các thao tác đọc 
và ghi trong hệ thống tệp bằng cách ngăn không cho một số người dùng chiếm quá nhiều không gian chia sẻ.

- Trong hình 1-1, tất cả local user có thể truy cập không gian chia sẻ được cung cấp bởi hệ thống 
lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T ở chế độ CIFS bình thường. 
Tuy nhiên, local user thuộc các local group khác nhau và mỗi nhóm có các quyền khác 
nhau cho không gian dùng chung. Vì vậy, một số local user đã được phép đọc / ghi cho 
không gian dùng chung, trong khi một số local user chỉ có quyền truy cập chỉ đọc cho 
không gian dùng chung. Hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T 
có thể thiết lập một hạn ngạch không gian dùng chung cho mỗi local user.


Hình 1-1 Chia sẻ tệp trong CIFS Chế độ bình thường trong môi trường không thuộc miền.

![Imgur](https://i.imgur.com/3MLUlu3.png)

### CIFS Homedir Share trong môi trường không thuộc miền quảng bá

Số lượng người dùng tăng lên, nhu cầu lưu trữ cá nhân xuất hiện và những không gian riêng tư như vậy không cho phép 
những người dùng khác truy cập vào.

Hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T chia sẻ hệ thống tệp tin với người dùng ở chế độ CIFS Homedir. 
Hệ thống tệp chia sẻ sẽ xuất hiện dưới dạng thư mục. Tên thư mục giống với tên người dùng. Người dùng này chỉ có thể truy cập vào thư mục chia sẻ của riêng mình. 
Trong khi đó, hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T cho phép các doanh nghiệp thiết lập hạn ngạch 
không gian chung cho các phòng ban và người sử dụng. Quản lý hạn ngạch người dùng đảm bảo rằng tất cả người dùng đều có thể truy cập 
hệ thống tập tin và các tệp bằng cách ngăn không cho một số người dùng chiếm quá nhiều không gian chia sẻ.

Trong hình 1-2, mỗi local user chỉ có thể truy cập thư mục chia sẻ có tên giống với tên người dùng. 
Hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T có thể thiết lập một hạn ngạch không 
gian dùng chung cho mỗi local user. Hạn ngạch của local user có thể lớn hơn khả năng của hệ thống tệp sở hữu của local user.

![Imgur](https://i.imgur.com/GFc7NMz.png)

### CIFS chia sẻ bình thường trong miền AD

Với việc phát triển của mạng LAN và mạng WAN, nhiều doanh nghiệp sử dụng miền AD để quản lý mạng trên Windows một cách đơn giản và linh hoạt.

Hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T có thể được thêm vào một miền AD như một máy khách, 
cụ thể là nó có thể được tích hợp liền mạch với miền AD. Bộ điều khiển miền AD lưu thông tin về tất cả các máy khách và nhóm trong miền. 
Tất cả khách hàng trong miền AD có thể truy cập chia sẻ CIFS Normal được cung cấp bởi hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T. 
Trước khi truy cập, họ cần phải được chứng thực bởi bộ điều khiển miền AD. Quản trị viên miền AD có thể thực hiện quản lý cho phép tệp cụ thể. 
Các máy khách khác nhau có quyền truy cập khác nhau cho mỗi thư mục chia sẻ.

Trong hình 1-3, tất cả các máy khách miền có thể truy cập không gian chia sẻ được cung cấp bởi hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T. 
Trước khi truy cập vào không gian dùng chung, các máy khách miền cần chứng thực bởi bộ điều khiển tên miền AD.
Trước khi truy cập vào không gian dùng chung, các máy khách miền cần chứng thực bởi bộ điều khiển tên miền AD. 
Hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T có thể thiết lập một hạn ngạch không gian dùng chung cho mỗi máy khách miền.

![Imgur](https://i.imgur.com/z8pX1WD.png)

###  CIFS chia sẻ Homedir trong miền AD 

Hệ thống lưu trữ OceanStor S2600T / S5500T / S5600T / S5800T / S6800T có thể được thêm vào một miền AD như một máy khách, cụ thể là nó có thể được tích hợp liền mạch với miền AD. 
Bộ điều khiển miền AD lưu thông tin về tất cả các máy khách và nhóm trong miền. Một khách hàng trong miền AD chỉ có thể truy cập thư mục có tên giống với tên khách hàng, 
như thể hiện trong hình 1-4.

![Imgur](https://i.imgur.com/eVaE8Wf.png)

## 1.5 Hệ thống quản lý các chế độ lưu trữ

Hệ thống lưu trữ S2900T / S5500T / S5600T / S5800T / S6800T của OceanStor hỗ trợ giao diện người dùng đồ họa (GUI) và các tùy chọn giao diện dòng lệnh (CLI). 
Trình Quản lý Lưu trữ tích hợp (Integrated Storage Manager - ISM) cung cấp quản lý dựa trên GUI. CLI cung cấp quản lý dòng lệnh. 
Để dễ dàng quản lý hệ thống lưu trữ của người dùng ở các mức khác nhau, tài liệu này giải thích làm thế nào để cấu hình tính năng trên ISM và cách quản lý, 
và duy trì tính năng trên CLI.








