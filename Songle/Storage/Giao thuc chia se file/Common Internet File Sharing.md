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

CIFS Nomal SHare trong Môi trường không có miền quảng bá (Non - Domain Enviroment)












