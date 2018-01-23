# Partition Table

Các chuẩn quản lí ổ cứng.

### 1. MBR ( Master Boot Record ) :

 
Là chuẩn quản lí thông tin phân vùng ổ cứng vật lý.

- Hỗ trợ tối đa 4 phân vùng primary ( phân vùng chính ) .

	+ Nếu muốn tạo thêm phân vùng primary, phải tạo một phân vùng Extended ( phân vùng mở rộng ) trên MBR, sau đó tạo phân vùng kiểu Logical.

- Chỉ duy nhất sector đầu tiên chứa thông tin về ổ đĩa cứng như các cấu hình cho firmware, hệ điều hành, nếu sector này lỗi người dùng có thể  mất quyền truy cập vào ổ đĩa.

- Hỗ trợ các hệ điều hành 32bit và 64bit.

- Quản lí dung lượng tối đa 2TB.

- Có thể sử dụng trên cả máy tính dùng chuẩn BIOS hay UEFI.

### 2. GPT ( GUID Parittion Table Scheme )

*GUID :  Globallly Unique Identifiers )*
 
- GPT là chuẩn quản lý thông tin phân vùng ổ cứng mà thông tin ổ đĩa được nhân rộng nhiều hơn một , có nghĩa là nếu 1 sector chết ổ cứng vẫn lấy thông tin từ các sector khác được và hoạt động bình thường. \

- Hỗ trợ lên đến 128 phân vùng chính.

- Hỗ trợ dung lượng ổ cứng lên tới 9,4 ZB.

- Hỗ trợ phiên bản windows 64bit từ phiên bản windows 8, duy nhất windows 8 32bit hỗ trợ GPT.

- Hỗ trợ các máy tính dùng chuẩn UEFI.

### 3. Kiến thức mở rộng :


**BIOS và UEFI :**

- Đều là phần mềm cấp thấp (low-level software) bắt đầu chạy khi bạn khởi động máy tính trước khi hệ điều hành được tải. UEFI là một phiên bản hiện đại hơn của BIOS dành cho những hệ thống máy tính đời mới hiện nay, hỗ trợ ổ cứng lớn hơn, thời gian khởi động nhanh hơn, bảo mật tốt hơn cùng giao diện đồ họa, điều khiển bằng chuột.
 
##### 1. BIOS  ( Basic Input-Output System ) : 

- Phần mềm được lưu vào một con chip nằm trong bo mạch chủ ( mainboard hoặc motherboard ) trên máy tính và chạy khi người dùng bật máy.

- Đảm nhận nhiệm vụ đánh thức tất cả thành phần linh kiện trong máy, sau đó khởi chạy bootloader để nạp hệ điều hành ( Windows, Linux.. )

- Trong giao diện có các lựa chọn cài đặt ngày giờ, cấu hình phần cứng, thứ tự đọc ổ đĩa..

- Trước khi nạp hệ điều hành, BIOS trải qua quá trình POST ( Power-On Self Test ) giúp kiểm tra và đảm bảo các thiết lập phần cứng của bạn là hợp lệ và có  thể hoạt động bình thường. Nếu có vấn đề sẽ có lỗi hoặc tiếng bíp từ mainboard.

+ Sau khi kiểm tra thành công, BIOS kiểm tra MBR được ưu tiên trên thiết bị khởi động để kích hoạt bootloader.
 
- Hạn chế của BIOS : 

+ Chỉ hỗ trợ ổ cứng nhỏ hơn 2,1 TB

+ Hoạt động ở chế độ xử lí 16-bit với không gian bộ nhớ 1MB => gặp sự cố khi khởi tạo nhiều thiết bị phần cứng cùng lúc => tốc độ khởi động chậm.
 
 
##### 2. UEFI ( Unified Extended Firmware Interface Forum )
 
- Phần mềm cấp thấp thế hệ mới thay thế cho BIOS.

+ Được lưu trong một chip nhớ Flash  của mainboard.

- Khởi động được tối đa ổ cứng có dung lượng 9,4 ZB.

- Có thể chạy trên cả hệ thống 32bit và 64bit với giao diện hiện đại, có thể tao tác bằng chuột trên một số phiên bản .

- Tính năng Secure Boot giúp kiểm tra hệ điều hành khởi động một cách an toàn, đảm bảo không có bất cứ phần mềm độc hại nào can thiệp vào. 

+ Kết nối mạng cũng được tích hợp trong firmware UEFI, cho phép khắc phục sự cố và thiết lập từ xa. Với BIOS, bạn phải ngồi trước mặt máy tính để cấu hình nó.

- Để truy cập vào giao diện UEFI, phải vào từ giao diện tùy chọn boot của Windows thay vì ấn phím khi máy tính khởi động ở đa số các dòng máy.
 
Giải đáp về UEFI : http://www.uefi.org/faq
