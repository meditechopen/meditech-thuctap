# Các hình thức RAID

## 1. Định nghĩa :

RAID (Redundant Arrays of Inexpensive Disks) là hình thức ghép nhiều ổ đĩa cứng vật lý thành một hệ thống ổ đĩa cứng có chức 
gia tăng tốc độ đọc/ghi dữ liệu hoặc nhằm tăng thêm sự an toàn của dữ liệu chứa trên hệ thống đĩa hoặc kết hợp cả hai yếu tố trên.

- Có 3 lý do chính để áp dụng RAID:

	- Dự phòng
	- Hiệu quả cao
	- Giá thành thấp

-Sự dự phòng là nhân tố quan trọng nhất trong quá trình phát triển RAID cho môi trường máy chủ. 
Dự phòng cho phép sao lưu dữ liệu bộ nhớ khi gặp sự cố. Nếu một ổ cứng trong dãy bị trục trặc thì nó có thể hoán đổi sang 
ổ cứng khác mà không cần tắt cả hệ thống hoặc có thể sử dụng ổ cứng dự phòng. 
Phương pháp dự phòng phụ thuộc vào phiên bản RAID được sử dụng. 

- Có 3 hình thức RAID :
	- Software RAID
	- Hardware RAID
	- Host RAID

	
	
## 2. Software RAID:

- RAID phần mềm được cài đặt và sử dụng trên chính hệ điều hành của hệ thống để cung cấp các chức năng sau:
+ Sử dụng tài nguyên hệ thống của máy chủ.
+ Sử dụng bộ nhớ hệ thống của máy chủ.
+ Tất cả các chức năng của RAID đều được thực hiện trong trình điều khiển thiết bị của hệ điều hành ( device driver ).
 
- Raid mềm phụ thuộc vào hệ điều hành nên khi triển khai sẽ chiếm một phần tài nguyên hệ thống cho việc quản lý RAID.
-  Có thể thực hiện trên nhiều loại ổ cứng với dung lượng khác nhau. Trên một đĩa vật lý có thể có những partition với RAID0, RAID1 , RAID5.
 
**Ưu điểm:** Sử dụng cho các máy tính sử dụng các ổ cứng phổ thông nhưng vẫn nâng cao được hiệu năng cho máy tính.
 
**Nhược điểm:** Raid mềm chỉ là tập hợp con các tính năng của raid cứng, và nói về độ hư hại của raid mềm là rất lớn không có khả năng phuc hồi, vì raid mềm tích hợp trên mainboard, khi hỏng là hỏng main.


## 3. Hardware RAID:

- RAID cứng thiết lập mảng đĩa cho hệ điều hành sẵn trước khi cài đặt hệ điều hành
- Khi hệ điều hành sử dụng không tốn tài nguyên cho việc quản lý đĩa liên quan đến RAID
- Chỉ hỗ trợ một định dạng ổ cứng hay khi thiết lập yêu cầu phần cứng khắt khe hơn và không thực hiện được với các ổ cứng bình thường như ATA.
 
 
**Ưu điểm**: Độ ổn định cao, có ưu điểm là đẩy cao tốc độ của ổ cứng và có thể thay thế khi card raid hư vì nó không tích vào vào mainboard mà nó được cắm vào cổng PCI Express, nhưng vẫn đảm bảo được data khi chỉ hỏng card raid mà ổ cứng chứa dữ liệu vẫn còng nguyên không bị hư hại, bên cạnh đó còn có trình điều khiển và phần mềm quản lý, và phục hồi raid.

**Nhược điểm**: Giá thành cao, không sử dụng được cho các máy tính phổ thông (ví dụ: 1 pc bình thường)


### RAID 0:

![Imgur](https://i.imgur.com/xOBMrJ5.gif)

-  Raid 0 phổ biến và được nhiều người sử dụng hiện nay do có khả năng nâng cao hiệu suất tốc độc đọc ghi trao đổi dữ liệu của ổ cứng.
- Server cần tối thiểu 2 ổ đĩa (Disk 0, Disk 1) để setup.
- Cơ chế lưu trữ: Lưu dữ liệu lên 2 ổ đĩa, mỗi ổ 1 nửa. Giả sử bạn có 1 file A dung lượng 100MB. Khi tiến hành lưu trữ thay vì file A sẽ được lưu vào 1 ổ cứng duy nhất, Raid 0 sẽ giúp lưu vào 2 ổ đĩa disk 0, disk 1 mỗi ổ 50MB (Striping)  giúp giảm thời gian đọc ghi xuống 1 nửa so với lý thuyết .
**Ưu điểm:** Tốc độ đọc ghi nhanh (gấp đôi bình thường theo lý thuyết).
**Nhược điểm:** tiềm ẩn rủi ro về dữ liệu. Lý do dữ liệu được chia đôi lưu trên 2 ổ đĩa.Trường hợp 1 trong 2 ổ đĩa bị hỏng thì nguy cơ mất dữ liệu rất cao. Về ổ cứng yêu cầu phải 2 ổ cùng dung lượng, nếu 2 ổ khác dung lượng thì lấy ổ thấp nhất.
- **Đối tượng sử dụng:** Thích hợp với những dịch vụ cần lưu trữ và truy xuất với tốc độ cao. Chẳng hạn như dịch vụ video streaming, chạy cơ sở dữ liệu... 
 
### RAID 1:

![Imgur](https://i.imgur.com/rRYFwqr.jpg)
 
- Raid1 cơ bản được sử dụng khá nhiều hiện nay do khả năng đạt an toàn về dữ liệu. 
- Server cần tối thiểu 2 ổ cứng để lưu trữ và tiến hành setup.
- Không giống như Raid 0, Raid 1 đảm bảo an toàn hơn về dữ liệu do dữ liệu được ghi vào 2 ổ giống hệt nhau (Mirroring).

**Ưu điểm:** An toàn về dữ liệu, trường hợp 1 trong 2 ổ đĩa bị hỏng thì dữ liệu vẫn có khả năng đáp ứng dịch vụ.

**Nhược điểm:** 

- Hiệu suất không cao
- Nâng cao chi phí (giả sử khách hàng sử dụng 2 ổ cứng 500GB. Khi sử dụng Raid 1 thì dung lượng lưu trữ có thể sử dụng chỉ được 500GB).
- Ổ cứng yêu cầu phải 2 ổ cùng dung lượng, nếu 2 ổ khác dung lượng thì lấy ổ thấp nhất.

**Đối tượng sử dụng:** Các dịch vụ lưu trữ, các website vừa và nhỏ không yêu cầu quá cao về tốc độ đọc ghi (in/out) của ổ cứng. Các đối tượng yêu cầu sự an toàn về dữ liệu như các dịch vụ kế toán,lưu trữ thông tin khách hàng, bất động sản v.v…

### RAID 5:

![Imgur](https://i.imgur.com/PplFy0Q.gif)

Raid 5 cũng là một loại Raid được phổ biến khá rộng rãi. Nguyên tắc cơ bản của Raid 5 cũng gần giống với 2 loại raid lưu trữ truyền thống là Raid 1 và Raid 0. Tức là cũng có tách ra lưu trữ các ổ cứng riêng biệt và vẫn có phương án dự phòng khi có sự cố phát sinh đối với 1 ổ cứng bất kì trong cụm.

- Raid 5 ta cần tối thiểu 3 ổ cứng để setup. 

- Cơ chế :Theo như hình minh họa phương án lưu trữ của Raid 5 như sau. Giả sử có 1 file A thì khi lưu trữ sẽ tách ra 3 phần A1, A2, A3. Ba phần nãy sẽ tương ứng lưu trên ổ đĩa Disk 0, Disk 1, Disk 2, còn ổ đĩa Disk 3 sẽ giữ bản sao lưu backup của 3 phần này. Tương tự các file sau cũng vậy và tùy theo tiến trình thực hiện mà bản sao lưu có thể được lưu ở bất kì 1 trong những ổ trong cụm Raid.

**Ưu điểm:** Nâng cao hiệu suất, an toàn dữ liệu, tiết kiệm chi phí hơn so với hình thức lưu trữ Raid 10.

**Nhược điểm:** Chi phí phát sinh thêm 1 ổ so với hình thức lưu trữ thông thường. (tổng dung lượng ổ cứng sau cùng sẽ bằng tổng dung lượng đĩa sử dụng trừ đi 1 ổ. Giả sử bạn có 4 ổ 500GB thì dung lượng sử dụng sau cùng khi triển khai Raid 5 bạn chỉ còn 1500GB).

**Đối tượng sử dụng:** Tất cả những website, dịch vụ, ứng dụng có số lượng truy cập và yêu cầu tài nguyên từ nhỏ đến vừa và lớn.


### RAID 10:
 
![Imgur](https://i.imgur.com/cw0GIJS.png)
 
Raid 10 là sự kết hợp giữa 2 loại raid phổ biến và Raid 1 và Raid 0. 

- Để setup Raid 10 cần sử dụng tối thiểu 4 ổ cứng (Disk 0, Disk 1, Disk 2, Disk 3).

- Đối với Raid 10 dữ liệu sẽ được lưu đồng thời vào 4 ổ cứng. 2 ổ dạng Striping (Raid 0) và 2 ổ (Mirroring) Raid 1.

**Ưu điểm:** Đây là 1 hình thức lưu trữ nhanh nhẹn và an toàn, vừa nâng cao hiệu suất mà lại đảm bảo dữ liệu không bị thất thoát khi 1 trong số 4 ổ cứng bị hỏng.

**Nhược điểm:** Chi phí cao. Đối với Raid 10 dung lượng sẵn sàng sử dụng chỉ bằng ½ dung lượng của 4 ổ. (giống như raid 1).

**Đối tượng sử dụng:** Raid 10 thích hợp với tất cả các đối tượng sử dụng (từ những yêu cầu về hiệu suất đến việc đảm bảo an toàn dữ liệu). Về ổ cứng yêu cầu phải 4 ổ cùng dung lượng, nếu 4 ổ khác dung lượng thì lấy ổ thấp nhất.


### RAID 01:

![Imgur](https://i.imgur.com/b9LB0mP.png)

Sự kết hợp giữa RAID0 và RAID1

- Dữ liệu được lưu trên các ổ đĩa theo hình thức Stripe RAID0 ở mỗi cụm. Sau đó các cụm sẽ được kết hợp lại bằng RAID1 với cơ chế Mirror.

**Ưu điểm:** Đảm bảo an toàn dữ liệu và hiệu suất cao.

**Nhược điểm:** Giá thành cao.

### RAID Z:

![Imgur](https://i.imgur.com/zIOkI9E.gif)
 
RAID-Z : Một bản nâng cấp từ RAID 5

- Tránh được "Write hole" bằng cách sử dụng COW - Copy on write ( khi mất điện đột ngột lúc đang ghi dữ liệu, sẽ có trường hợp không thể biết được data blocks hoặc parity blocks nào vừa được ghi trùng với dữ liệu đã được ghi trong các ổ stripes, và không xác định được là dữ liệu nào đã bị lỗi, đó gọi là hiện tượng "write hole" ).

- Số đĩa cần : >= 3 đĩa 

=> Vẫn đảm bảo tốc độ đọc/ghi bằng stripe 

=> Khi một trong 3 ổ đĩa hỏng, dữ liệu vẫn được phục hồi. Trừ khi cả 3 ổ cùng hỏng.

- Nếu muốn thêm an toàn, có thể dùng RAID 6 ( RAID-Z2 trên cơ sở của ZFS) để có 2 lần dự phòng.

### RAID Z2:

![Imgur](https://i.imgur.com/dUufg91.gif)

- Raid Z2 hầu như giống với Raid Z và tương tự như RAID 6. Trong RAID Z2, hai ổ cứng có thể cùng lúc xuống và dữ liệu của bạn sẽ vẫn an toàn và có thể tiếp cận được. Giống như RAID Z, RAID Z2 vượt trội so với RAID 6 vì nó có nhiều tính năng khác. 
- Số lượng ổ đĩa tối thiểuvới RAID Z2 là 4.
 
**Ưu điểm:**

- 2 ổ đĩa có  thể hỏng cùng lúc mà dữ liệu vẫn an toàn.

- Thừa hưởng tất cả các điểm mạnh từ RAID Z.
 
**Nhược điểm:**

- Vì sử dụng 2 ổ đĩa để lưu parity nên một dung lượng bộ nhớ lớn sẽ bị giảm đi của cả hệ thống.

- Chỉ hỗ trợ nền tảng Solaris OS như Open Solaris hoặc Nexenta và BSD như FreeBSD.
 
 
### RAID Z3:

![Imgur](https://i.imgur.com/UmYH2sz.png)
 
Về cơ bản giống RAIDZ, nhưng yêu cầu tối thiểu 5 ổ đĩa để cài đặt và sử dụng 3 ổ đĩa lưu parity.

- Hỗ trợ 3 ổ đĩa cùng lúc bị down mà dữ liệu vẫn an toàn.

=> Sử dụng trong môi trường có nhiều dữ liệu quan trọng và đảm bảo độ high avalability cao.


## 3. Host RAID:

rường hợp khi ta gắn một số ổ cứng ngoài vào hệ thống để cài đặt RAID, khi đó hệ thống RAID này vẫn sử dụng tài nguyên của máy tính để quản lí và hoạt động. 
- Tuy nhiên ở đây các thiết bị được gắn vào là card rời, nó sử dụng firmware nhận diện/ đánh giá ổ cứng trước khi HĐH được khởi động. 
Và sau khi HĐH khởi động xong (lấy quyền kiểm soát lại từ Bios) thì khi đó nó giao quyền điều khiển RAID cho OS luôn. Vì thế mà nó có tên gọi Host RAID.


### Parity

Yếu tố cơ bản để giúp cho ta có thể phục hồi dữ liệu trực tuyến (tức lúc máy chủ vẫn đang vận hành)
trong trường hợp một đĩa cứng bị hư hỏng bằng cách sử dụng một hình thức dự phòng được gọi là parity. Để nói cho bình dân đơn giản hơn , 
parity là phần bổ sung của tất cả các ổ đĩa được sử dụng trong cái Raid đó. Khi ta muốn tạm đọc dữ liệu từ một HDD bị hư nào đó 
(tôi nói tạm là vì khi ấy tốc độ truy xuất dữ liệu của toàn mảng Raid sẽ rất chậm, chúng chỉ được phục hồi tốc độ khi đã được thay bằng một ổ cứng mới), 
Raid sẽ thực hiện bằng cách đọc các dữ liệu tốt còn lại và kiểm tra nó bằng cách đối chiếu lại với dữ liệu pairty được lưu trữ trong mảng.

Tôi lấy ví dụ đơn giản để các bạn đễ hình dung Raid đã tính parity như thế nào.

Giả sử ta có 4 ổ cứng tạo nên Raid và lần lượt các ổ cứng này chứa các dữ liệu mang giá trị cũng lần lượt là 1, 2, 3, và 4. 
Khi đó Raid sẽ gán giá trị của parity là 10 (giả sử thôi chứ thực tế không phải vậy đâu)

1 + 2 + 3 + 4 = 10

Khi ổ thứ 3 bị toi thì ta sẽ có

1 + 2 + X + 4 = 10

Để biết cái ổ cứng thứ 3 trước đó có chứa dữ liệu gì, khi đó Raid sẽ tính

7 + X = 10 hay X = 10 -7 hay X = 3.

Cũng vì tính toán dài dòng như vậy nên, nếu các bạn để ý, khi một ổ bị tèo trong Raid 5 chẳng hạn, đồng ý là vẫn không có một dữ liệu nào bị mất, nhưng tốc độ truy xuất bị chậm hẳn đi.

Lưu ý parity chỉ được sử dụng ở các cấp độ RAID 2 , 3, 4 , và 5.

RAID 1 không sử dụng parity bởi vì tất cả dữ liệu là hoàn toàn sao chép ( nhân đôi).

Còn RAID 0 chỉ được sử dụng để tăng hiệu suất truy xuất. Vì không trang bị chức năng dự phòng dữ liệu nên nó không có parity .


### Tham khảo :

(1). http://genk.vn/may-tinh/tim-hieu-ve-raid-tren-o-cung-may-tinh-20140113144618737.chn