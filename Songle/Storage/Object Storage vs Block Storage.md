# Object Storage vs. Block Storage Services

### Giới thiệu:

Linh hoạt và khả năng mở rộng là nền tảng cần thiết cho hầu hết các ứng dụng và dịch vụ đang được 
phát triển với các kỹ thuật và công cụ hiện đại. Việc lưu trữ những thông tin khác nhau cũng cần những 
phương pháp và mức độ khác nhau.

Những nhà cung cấp dịch vụ lưu trữ đám mây cung cấp nhiều hình thức lưu trữ, tuy nhiên có 2 hình 
thức là phổ biến nhất hiện nay : **object storage** ( lưu trữ theo đối tượng ) và **block storage** (
lưu trữ theo các khối ).

![Imgur](https://i.imgur.com/YWhpAuk.png)

## Block Storage là gì?

- Dịch vụ lưu trữ **block storage** khá quen thuộc với chúng ta. Nhà cung cấp dịch vụ sử dụng 
các thiết bị block storage truyền thống như ổ cứng để phục vụ cho việc lưu trữ qua mạng. 

- Nhà cung cấp dịch vụ đám mây có những ứng dụng để giám sát thiết bị block device ở bất cứ kích 
thước nào và gắn nó vào trong máy ảo của bạn. Nôm na bạn sẽ sử dụng ổ cứng của nhà cung cấp như là ổ cứng 
trên máy local của bạn và họ có thể quản lý các ổ cứng đó.

- Bạn có thể định dạng cho ổ cứng và lưu trữ dữ liệu lên nó, gộp nhiều thiết bị thành một mảng RAID 
hoặc cấu hình cho dữ liệu ghi trực tiếp lên block device, tránh cho việc filesystem trên máy cá nhân bị quá tải.

**Ưu điểm của block storage device gán qua mạng so với ổ cứng trên máy local:**

	- Bạn có thể tạo nột snapshot của toàn bộ thiết bị cho việc phục hồi lại dữ liệu sau này.
	- Block storage device có thể thay đổi kích thước theo nhu cầu.
	- Bạn có thể dễ dàng gỡ và di chuyển block device giữa các máy khác nhau.

**Ưu điểm của block storage**

- Là mô hình quen thuộc, con người và phần mềm giao tiếp với nhau trên các tệp và tệp hệ thống một cách 
đồng nhất.

- Block device được hỗ trợ rất tốt, mọi ngôn ngữ lập trình đều dễ dàng đọc và ghi files.

- Phân quyền filesystem và việc kiểm soát truy cập rất dễ hiểu và quen thuộc.

- Block storage device cung cấp độ trễ của IO thấp, vì vậy phù hợp để sử dụng lưu trữ dữ liệu.

**Nhược điểm của block storage**

- Storage bị gán vào một server trong một thời điểm, vì vậy những máy ở server khác không thể sử dụng nó.

- Các block và filesystems có một số lượng giới hạn các metadata về các thông tin dữ liệu mà chúng 
đang lưu trữ (`ngày khởi tạo, chủ sở hữu, kích thước` ). Mọi thông tin khác về dữ liệu sẽ được xử lý 
ở cấp độ ứng dụng và cơ sở dữ liệu.

- Bạn phải trả phí cho tất cả các block device mà bạn đang nắm giữ, kể cả bạn không sử dụng nó.

- Bạn chỉ có thể truy cập vào block storage qua một server đang hoạt động.

- Block storage có nhiều công đoạn làm việc và cài đặt với object storage ( lựa chọn filesystem, phân quyền, 
phiên bản sử dụng, phương án dự phòng ..)

Vì có IO nhanh nên dịch vụ block storage  phù hợp với việc lưu trữ dữ liệu theo cách truyền thống. Các ứng 
dụng chuẩn sẽ yêu cầu các filesystem cơ bản sẽ cần sử dụng một thiết bị block storage.

Nếu nhà cung cấp của bạn không cung cấp dịch vụ block storage bạn có thể tự chạy bằng cách sử dụng 
`OpenStack Cinder, Ceph, hoặc dịch vụ tích hợp iSCSI` có sẵn trên nhiều thiết bị NAS.


## Object Storage là gì?


Trong thế giới của điện toán đám mây, object storage là kiểu lưu trữ các data và metadata không có cấu trúc 
sử dụng một HTTP API. (*API nôm na là phần mềm bổ trợ giúp phần mềm giao tiếp được với phần cứng, người dùng giao tiếp được với phần mềm ).

Thay vì đưa files lưu trong các blocks ( lưu trên các ổ đĩa sử dụng các định dạng filesystem) thì ta sẽ làm việc 
với toàn bộ object. Các object đó có thể là một file ảnh, logs, HTML files hoặc một số file chỉ có vài byte. Chúng là những file không 
có cấu trúc vì không có một chuẩn định dạng nào bắt chúng phải tuân theo.

Object storage rất phát triển vì nó làm đơn giản hóa thao tác của nhà phát triển. Các API bao gồm 
các chuẩn HTTP request, thư viện được phát triển một cách nhanh chóng cho hầu hết các ngôn ngữ lập trình. 

- Việc lưu một mẩu dữ liệu trở nên dễ dàng bằng cách gửi một yêu cầu HTTP PUT đến object store. 
- Truy xuất đến một file và metadata của nó bằng một yêu cầu `GET` bình thường.

Hầu hết các dịch vụ object storage có thể cung cấp các files một cách công khai cho những người dùng của bạn, 
loại bỏ công đoạn duy trì web server cho việc lưu trữ dữ liệu tĩnh. 

Hơn hết, dịch vụ object storage chỉ phải trả cho dung lượng mà bạn sử dụng ( một số trả phí cho mỗi HTTP request hoặc 
transfer bandwidth).
=> Phù hợp cho các công ty nhỏ với kinh phí có hạn mà vẫn đảm bảo việc sử dụng tài nguyên một cách hiệu quả.

**Ưu điểm của Object Storage**

- HTTP API đơn giản với clients có sẵn cho tất cả các hệ điều hành và ngôn ngữ lập trình phổ biến.
- Dùng bao nhiêu trả bấy nhiêu.
- Việc phục vụ lưu trữ các dữ liệu tĩnh bạn có thể sẽ tự điều hành bằng một server nhỏ.
- Một số object cung cấp dịch vụ tích hợp CDN ( built-in content delivery network ), nó sẽ lưu các dữ liệu của bạn 
dưới dạng cache trên khắp thế giới để tiện cho việc tải nhanh hơn cho người dùng của bạn.
- Optional versioning có nghĩa là bạn có thể truy xuất lại phiên bản trước của object để khôi phục lại nếu dữ liệu của bạn 
bị ghi đè lên.
- Linh hoạt trong việc tăng giảm dung lượng tùy vào nhu cầu người sử dụng mà không yêu cầu nhà phát triển phải huy động thêm những nguồn 
khác để xử lý.
- Sử dụng object storage đồng nghĩa với việc bạn không cần phải bảo dưỡng và duy trì các ổ đĩa, mảng RAID vì nó sẽ 
là việc của nhà cung cấp.
- Việc có thể lưu trữ các metadata cùng với dữ liệu của bạn có thể làm đơn giản hóa kiến trúc ứng dụng.

**Nhược điểm của Object Storage**

- Bạn không thể sử dụng dịch vụ object storage để sao lưu cơ sở dữ liệu truyền thống do có độ trễ cao.
- Object storage không cho phép bạn sửa một phần nhỏ dữ liệu của cả object mà phải đọc/ghi toàn bộ đối tượng cùng 1 lúc => giảm hiệu suất.
vd : Ví dụ, trên một hệ thống tập tin, bạn có thể dễ dàng nối thêm một dòng vào cuối một log file. 
Trên một hệ thống lưu trữ đối tượng, bạn cần phải lấy ra đối tượng, thêm dòng mới, và viết toàn bộ đối tượng trở lại. 
Điều này làm cho lưu trữ đối tượng không lý tưởng cho dữ liệu thay đổi rất thường xuyên.
- Hệ điều hành không thể dễ dàng gán một object giống như với một ổ đĩa bình thường. Có một số clients và adapters hỗ trợ việc này,
nhưng nhìn chung sử dụng object store là không hề đơn giản.

=> Object storage phù hợp cho việc lưu các dữ liệu tĩnh, lưu các dữ liệu người dùng như phim ảnh, backup files, logs..



 

