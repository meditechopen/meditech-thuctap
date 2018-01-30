# File Systems 

### 1.Journaling file system?

Khi khởi động, hệ điều hành luôn luôn dùng một chương trình để kiểm tra tính toàn vẹn của hệ thống file,
 đó là trình fsck. Nếu nó phát hiện hệ thống file có dấu hiệu bất thường hoặc chưa được unmount 
 do các nguyên nhân như mất điện hoặc hệ thống bị đứng đột ngột trong khi đang chạy, lúc đó fsck 
 sẽ quét lại toàn bộ hệ thống file để cố gắng khôi phục lại dữ liệu. Quá trình kiểm tra và khôi phục dữ 
 liệu (nếu có) nhanh hay chậm còn phụ thuộc vào dung lượng của ổ cứng, và với những hệ thống có dung lượng
 lưu trữ rất lớn như hiện nay (từ hàng chục đến hàng trăm gigabyte) thì phải mất hàng giờ để quét lại toàn 
 bộ hệ thống ổ cứng. Cách làm này được áp dụng trên các hệ thống file Unix chuẩn ufs (Sun & HP) hoặc ext2 mà 
 Linux đang sử dụng. Nếu hệ thống file có khả năng ghi lại (log) được các hoạt động mà hệ điều hành đã và đang thao tác trên dữ liệu thì hệ thống xác định được ngay những file bị sự cố mà không cần phải quét lại toàn bộ hệ thống file, giúp quá trình phục hồi dữ liệu trở nên tin cậy và nhanh chóng hơn. Hệ thống file như vậy được gọi là journaling file system.
 
Các định dạng file hệ thống :
 
- Ext
- Ext2
- Ext3
- Ext4
- Btrfs
- ReiserFS
- NTFS
- JFS
- XFS
- Swap


### 2. Các định dạng file hệ thống:

#### 2.1. Ext ( Extended File System )

 
- Định dạng file hệ thống đầu tiên dành riêng cho Linux.
- Nâng cấp từ file hệ thống Minix.
- Sử dụng 32-bit file poiters
- Maximal FS size :  2 GB / Độ dài filename : 255 chars/
 
**Hạn chế của Ext :**

- Ít hỗ trợ cho 3 timestamps :
   + Accessed, Inode Modified, Data Modified 
- Sử dụng danh sách liên kết  ( linked list ) để theo dõi các blocks/inodes
   + Giảm hiệu suất qa thời gian.
   + Các danh sách không được sắp xếp theo thứ tự.
   + Files bị phân mảnh trên ổ cứng.
- Không cung cấp các chức năng và phân vùng cho việc mở rộng sau này.
 
=>  Không đáp ứng được những tính năng phổ biến ngày nay và không nên sử dụng ext tại thời điểm này vì không còn được hỗ trợ trên nhiều distribution.
 
#### 2.2. Ext2 ( Second Extended File System ) 


 
- Được giới thiệu vào năm 1993 bởi Rémy Card
- Hỗ trợ dung lượng ổ cứng lên tới 2TB - 32TB
- Dung lượng file lớn nhất từ 16GB - 2TB
- Không sử dụng cơ chế journaling 
=> dùng ext2 cho các ổ đĩa dung lượng lớn với nhiều dữ liệu sẽ rất mất thời gian kiểm tra để phục hồi file nếu file bị hỏng.
- Tuy nhiên đối với ổ đĩa SSD, tốc độ đọc ghi rất cao vì vậy có thể không cần sử dụng chuẩn journaling trên chúng.
 
=> Các thiết bị nên dùng Ext2 là thiết bị flash drives, usb vì dung lượng nhỏ, tốc độ phục hồi dữ liệu sẽ nhanh khi xảy ra sự cố.


#### 2.3. Ext3 ( Third Extended File System )

 
- Được giới thiệu vào năm 2001, phát triển bởi Stephen Tweedie

- Từ phiên bản nhân Linux 2.4.15, ext3 đã được hỗ trợ, ext3 được hỗ trợ trên tất cả các phiên bản của Linux.

- Sử dụng cơ chế journaling => điểm mạnh lớn nhất của ext3
  
	+ Journal có một khu vực chuyên dụng trong hệ thống tập tin, nơi mà tất cả các thay đổi được theo dõi và ghi lại. Khi hệ thống xảy ra sự cố, những file bị hỏng, hoặc đang bị gián đoạn cho qá trình ghi dữ liệu sẽ được khắc phục bởi journaling.

- Dung lượng lớn nhất của 1 file từ 16GB- 2TB

- Dung lượng toàn bộ file hệ thống ext3 có thể từ 2TB - 32 TB

- Thư mục đường dẫn ( directory ) có thể chứa tối đa 32,000 subdirectories.

- Có 3 kiểu journaling trong hệ thống ext3 file system :

	+ **Journal** : siêu dữ liệu ( metadata ) và nội dung được lưu trong journal => tốc độ thấp khi recover lại file.

	+ **Ordered** :  chỉ có siêu dữ liệu được lưu trong journal. Metadata được ghi lại chỉ sau khi nội dụng file được ghi vào đĩa.

	+ **Writeback** : chỉ có siêu dữ liệu được lưu vào journal. Metadata có thể được ghi lại trước hoặc sau khi nội dung của file được ghi vào đĩa.

- Bạn có thể chuyển đổi định dạng file ext2 sang ext3 một cách trực tiếp mà không cần backup và restore lại.
 
=> **Ext3 hoạt động nhanh, ổn định , phù hợp sử dụng cho các ổ đĩa của người dùng cá nhân.**

- **Đối với máy chủ thì không phù hợp vì không có tính năng tạo disk snapshot.**
  

#### 2.4. Ext4 ( Fourth Extended File System ) 
 
- Được giới thiệu vào năm 2008, bắt đầu được sử dụng từ phiên bản 2.6.19 của Linux Kernel.

- Hỗ trợ dung lượng file đơn lẫn dung lượng tổng số file rất lớn. 

	+ Dung lượng lớn nhất 1 file ext4 từ 16GB - 16 TB.

	+ Dung lượng toàn bộ file lên tới 1 BE ( exabyte ) . 1 BE = 1024 PB ( petabyte ), 1 PB = 1024 TB ( Terabyte ) , 1 TB = 1024 GB.

- Thư mục đường dẫn có thể chứa tối đa 64,000 thư mục con ( subdirectories ) so với 32,000 của ext3.

- Bạn có thể mount một file ext3 sang ext4 mà không cần phải nâng cấp nó.

- Có thể cấu hình lựa chọn bật hoặc tắt tính năng journaling trên ext4.

- Giảm tình trạng phân mảnh ổ đĩa, sử dụng cơ chế phân bổ chậm  ( delayed allocation ) để kéo dài tuổi thọ thiết bị flash memory. 
 
=> Thích hợp với ổ SSD so với Ext3, tốc độ hoạt động nhanh hơn so với 2 phiên bản Ext trước đó, cũng khá phù hợp để hoạt động trên server, nhưng lại không bằng Ext3.
 

#### 2.5. Btrfs ( Butter or Better or B-tree File System )

 
- Thế hệ tiếp theo của File System trên Linux.

- Xây dựng dựa trên hệ thống tập tin COW B-tree, hiện vẫn đang giai đoạn phát triển bởi Oracle.
 
- Btrfs giải quyết các vấn đề còn thiếu trên các hệ thống tập tin cũ như: snapshot, 
checksum dữ liệu, phân vùng và mở rộng trực tiếp ... 
Mặc dù theo nhiều nguồn thì BtrFS không hoạt động ổn định trên 1 số nền tảng distro nhất định, 
nhưng với những tính năng ưu việt như trên thì nó vẫn sẽ là sự thay thế cho Ext4 trong tương lai. 

- BtrFS phù hợp để hoạt động với server với hiệu suất làm việc cao, khả năng tạo snapshot nhanh chóng 
cũng như hỗ trợ nhiều tính năng đa dạng khác. Hiện tại có 1 vài distro đã sử dụng Btrfs mặc định như Fedora 18, openSUSE 13.2 ..
 
Tham khảo : https://www.khuetu.vn/noi-dung/giai-phap-nas/tim-hieu-ve-chuan-file-he-thong-btrfs-tren-nas-synology


#### 2.6. ReiserFS 

Ý tưởng  : tối ưu hóa việc lưu trữ file nhỏ và tăng tốc độ truy cập đến các file này.
 
- Sử dụng phương pháp "B * trees* để tổ chức dữ liệu.

	+ Một thư mục có thể chứa 100,000 thư mục con.

	+ Có thể cấp phát động các inode : mỗi đối tượng chứa trong hệ thống file được đánh dấu bằng một chỉ số duy nhất,
	các hệ thống file khác thực hiện cấp phát inode tĩnh. 

- Cấp phát không cố điịnh dung lượng file theo 1kb hay 4kb mà nó sẽ cấp phát dung lượng chính xác so với kích thước của dữ liệu 
=> tiết kiệm và tối ưu hóa việc lưu trữ.

- Quá trình phát triển kha chậm chạp và vẫn chưa hỗ trợ đầy đủ các phiên bản của Linux kernel.
 
=> Reiserfs để lưu trữ và truy cập các file nhỏ là tối ưu, với tốc độ truy cập file tăng từ 8-15 lần và dung 
lượng tiết kiệm được khoảng trên 5% so với hệ thống ext2 với các loại file có kích thước dưới 1 KB.  Reiserfs hỗ trợ thực hiện journaling trên chỉ mục dữ liệu (journaling of meta-data only).


#### 2.7. JFS ( Journaled File System )
 
- Được phát triển bởi IBM cho hệ điều hành IBM AIX vào năm 1990, sau đó thì được sử dụng cho Linux.

- Sử dụng ít tài nguyên CPU, hoạt động tốt và hiệu suất cao cả trên file dung lượng lớn và nhỏ. 

- Phân vùng lưu trữ JFS có thể dễ dàng thay đổi kích thước nhưng không thể tách ra được.

- Hỗ trợ hầu hết các phiên bản Linux, tuy nhiên hiệu suất khi chạy trên Linux servers thì lại không mạnh bằng ext vì ban đầu nó được thiết kế cho AIX của IBM. 


#### 2.8. XFS 

- Được phát triển bởi Silicon Graphics từ năm 1994 để hoạt động trên hđh của họ, sau đó được dùng trên Linux vào năm 2001.

- Một số cơ chế giống với Ext4 như chống phân mảnh dữ liệu, không cho phép các snapshot tự kết hợp với nhau.

- Hoạt động tốt với các file dung lượng lớn, các file có thể thay đổi kích thước một cách dễ dàng , tuy nhiên không thể chia nhỏ ra được . 

= > Với những đặc điểm như vậy thì XFS khá phù hợp với việc áp dụng vào mô hình server media 
vì khả năng truyền tải file video rất tốt. Tuy nhiên, nhiều phiên bản distributor yêu cầu phân vùng /boot riêng biệt,
 hiệu suất hoạt động với các file dung lượng nhỏ không bằng được khi so với các định dạng file hệ thống khác, 
 do vậy sẽ không thể áp dụng với mô hình database, email và một vài loại server có nhiều file log. Nếu dùng với máy tính cá nhân, thì đây cũng 
 không phải là sự lựa chọn tốt nên so sánh với Ext, vì hiệu suất hoạt động không khả thi, ngoài ra cũng không có gì nổi trội về hiệu năng, quản lý so với Ext3/4.
 
#### 2.9. Swap 

- Là một lựa chọn khi định dạng một ổ đĩa, không thực sự là một file system. 

- Nó được sử dụng như là một bộ nhớ ảo chứ không có cấu trúc là một hệ thống file system. 
Swap được dùng như là một khu vực bộ nhớ riêng biệt, đề phòng khi RAM bị qá tải,
 lúc đó phân vùng Swap sẽ coi như là một thanh ram khác, dữ liệu được đưa vào đó lưu trữ tạm thời trước khi đưa vào bộ nhớ.

 + Trong một số trường hợp nó cũng được sử dụng phục vụ cho cơ chế hybernating.

 - Không thể mount để xem nội dung bên trong nó.
 



