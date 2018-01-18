# Cấu tạo ổ cứng

Bài viết miêu tả ổ cứng dung lượng 1TB với kích thước 3.5 inch.

![Imgur](https://i.imgur.com/L1lXc32.png)

- Khu vực bảng linh kiện màu xanh được gọi là Bảng mạch in ( printed circuit board - PCB ).
PCB chứa các thiết bị kiểm soát hoạt động của ổ cứng. 

- Khu vực hộp màu đen được gọi là Hard Disk Assembly - Khu cực cấu thành các thành phần đọc ghi vật lý của 
ổ đĩa.

## 1. Printed Circuit Board (Bảng mạch in)

Trong khu vực trung tâm của PCB là Bộ vi xử lý ( Mirco controller unit - MCU hoặc CPU). 
CPU trong HDD bao gồm mã chương trình quản lý và các chức năng như kênh Đọc/Ghi mà chuyển đổi 
tín hiệu bit 0 1 từ đầu từ thành các thông tin có cấu trúc. Cổng truy xuất dữ liệu MCU IO
 gửi dữ liệu đến và đi từ giao diện SATA tới bo mạch chủ của máy tính.
 
![Imgur](https://i.imgur.com/iMjl1Hg.png)


##### Bộ nhớ tạm ( Hard disk memory hay Cache)
- Chíp nhớ tạm DDR SDRAM như trong hình là chip của Samsung với dung lượng 32MB.
- Chức năng: Khi dữ liệu được lấy từ ổ cứng ra, cache sẽ lưu đồng thời những dữ liệu xung quanh sector vừa được truy xuất,
 nó dựa trên cơ chế đoán biết, dựa trên việc sử dụng dữ liệu của cpu, vì những dữ liệu gần với dữ liệu vừa được lấy ra rất 
 có thể sẽ được sử dụng tới ở tiến trình sau đó.
- Cache trên HDD có dung lượng trung bình từ 8 - 128 MB.
 
##### Bộ điều khiển Voice Coil Motor (VCM)

VCM điều khiển động cơ trục chính xoay các tấm đĩa và điều khiển động cơ đầu từ.

##### Flash Chip

- Bộ nhớ flash chip lưu firmware của ổ đĩa. Khi nguồn điện được cung cấp cho MCU, MCU đọc dữ liệu từ 
flash chip để khởi động ổ cứng.

- **Firmware:** Phần mềm nội bộ đảm bảo công việc của ổ cứng là thích hợp  để truyền đến thiết bị cấp cao hơn và hệ điều hành. 
Để phân biệt nó với các phần mềm sử dụng, chúng ta thường gọi nó là "firmware". 
Firmware là phần mềm nội bộ của ổ đĩa cứng và chạy bởi CPU của ổ đĩa cứng.


##### Shock Sensor

- Shock sensor xác định các tác động mạnh tới ổ cứng trong quá trình đọc ghi và gửi các construction đến bộ điều 
khiển VCM nhằm cho dừng hoạt động của đầu từ.

##### Thiết bị triệt xung đột biến điện (Transient Voltage Suppression)

- TVS diode bảo vệ các thiết bị điện tử của ổ đĩa chống lại các đợt sung điện điện mạnh bất thường.

## 2. Hard Drive Assembly ( hộp chứa các thiết bị vật lý đọc/ghi dữ liệu)

![Imgur](https://i.imgur.com/XuJ5y5N.png)



![Imgur](https://i.imgur.com/Go7t1tQ.png)

Nắp đậy bộ giữ một miếng đệm (màu vàng) bảo vệ ổ cứng.

![Imgur](https://i.imgur.com/A2ZQML4.png)

Dữ liệu được lưu trong các tấm đĩa xoay quanh trục đồng nhất (platters) 

- Đĩa từ : Bên trong ổ đĩa gồm nhiều đĩa cứng được làm bằng nhôm hoặc hợp chất gốm thuỷ tinh, đĩa được phủ một lớp từ và lớp bảo vệ ở cả 2 mặt, 
các đĩa được xếp chồng và cùng gắn với một trục mô tơ quay nên tất cả các đĩa đều quay cùng tốc độ, các đĩa quay nhanh trong suốt phiên dùng máy.

![Imgur](https://i.imgur.com/D6PZZl3.png)


#### Cấu tạo đĩa và các đầu từ

 - Đầu từ đọc – ghi : Mỗi mặt đĩa có một đầu đọc & ghi vì vậy nếu một ổ có 2 đĩa thì có 4 đầu đọc & ghi.

 - Mô tơ hoặc cuộn dây điều khiển các đầu từ : giúp các đầu từ dịch chuyển ngang trên bề mặt đĩa để chúng có thể ghi hay đọc dữ liệu .
 
#### Cấu trúc bề mặt đĩa

![Imgur](https://i.imgur.com/3RclQxz.jpg)

- Ổ đĩa cứng gồm nhiều đĩa quay với vận tốc 5400 đến 7200 vòng/phút , trên các bề mặt đĩa là các đầu từ di chuyển để đọc và ghi dữ liệu.
- Dữ liệu được ghi trên các đường tròn đồng tâm gọi là **Track** hoặc **Cylinder**, mỗi Track lại chia thành nhiều cung – gọi là **Sector** và 
mỗi Sector ghi được **512 Byte** dữ liệu.

##### Track

![Imgur](https://i.imgur.com/6V45ZBF.jpg)

- Track là các rãnh ghi dữ liệu, là các vòng tròn đồng tâm tiếp nối nhau.
- Track không cố định mà có thể thay đổi vị trí khi định dạng ổ cứng cấp thấp. 

*Định dạng ổ cứng cấp thấp* (low level hdd format): 

```
Low Level Format là quá trình định dạng lại ổ cứng có can 
thiệp sâu đến lớp từ tính có trên mặt đĩa, 
vì vậy nó có thể gây ảnh hưởng cho lớp từ tính này. 
Còn kiểu định dạng thông thường chỉ tác động 
lên phần dữ liệu có trên đĩa mà không gây ảnh hưởng đến cấu trúc vật lý của đĩa.
```

- Với mỗi đĩa cứng khoảng 10G => có khoảng 7000 đường track trên mỗi bề mặt đĩa và mỗi trách chia thành khoảng 200 sector.

- Để tăng dung lượng của đĩa thì trong các đĩa cứng ngày nay, các Track ở ngoài được chia thành nhiều sector hơn và mỗi 
mặt đĩa được chia thành nhiều Track hơn => Thiết bị phải có độ chính xác rất cao.

#### Nguyên tắc lưu trữ từ trên đĩa cứng:

-  Trên bề mặt đĩa phủ một lớp mỏng có từ tính, ban đầu các hạt từ tính không có hướng, khi chúng bị ảnh hưởng 
bởi từ trường của đầu từ lướt qua, các hạt có từ tính được sắp xếp thành các hạt có hướng.

- Đầu từ ghi - đọc được cấu tạo bởi một lõi thép hình chứ U, một cuộn dây quấn trên lõi thép để đưa dòng điện 
vào ( khi ghi) hay lấy ra ( khi đọc ), khe hở là khe từ lướt trên bề mặt đĩa với khoảng cách rất gần, bằng 1/10 sợi tóc.

![Imgur](https://i.imgur.com/oI5UDdA.png)

- Trong quá trình ghi, tín hiệu điện ở dạng tín hiệu số 0,1 được đưa vào đầu từ ghi lên bề mặt đĩa thành các nam châm rất 
nhỏ và đảo chiều tùy theo tín hiệu đưa vào là 0 hay 1.

- Trong qá trình phát, đầu từ đọc lướt qa bề mặt đãi dọc theo các đường Track đã được ghi tín hiệu, tại điểm giao nhau của các nam châm 
có từ trường biến đổi và cảm ứng lên cuộn dây tạo thành một xung điện, xung điện này rất yếu được đưa vào khuếch đại 
để lấy tín hiệu 0,1 ban đầu. 

- Trong các ổ mới hiện nay, người ta thay thế cơ chế ghi từ tính theo chiều dọc bằng một quá trình gọi là perpendicular magnetic recording (ghi từ tính trực giao). Trong kiểu ghi này các phần tử được sắp xếp vuông góc với bề mặt platter. Do đó chúng có thể được gói gần nhau hơn với mật độ lớn, lưu trữ được nhiều dữ liệu hơn. Mật độ bit trong mỗi inch dày hơn có nghĩa là thông lượng của các dòng dữ liệu dưới đầu đọc (ghi) sẽ nhanh hơn. 

![Imgur](https://i.imgur.com/Ug96473.gif)
