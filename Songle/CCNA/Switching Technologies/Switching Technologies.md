# Tổng quan về công nghệ Chuyển mạch ( Switching Technologies )
## Nội dung chính của bài : 
-	Mô tả switch layer 2
-	Mô tả việc học địa chỉ trên switch layer 2
-	Nắm được khi nào switch layer 2 sẽ chuyển tiếp hoặc ngăn chặn 1 frame
-	Mô tả vấn đề vòng lặp trong mạng ở tầng mạng của switch layer 2
-	Mô tả giao thức phân nhánh cây ( spanning-Tree protocol )
-	Các loại chuyển mạnh trong mạng LAN và cách chúng làm việc với switch layer 2

## 1.	Layer-2 Switching ( Chuyển mạch lớp 2 )
### a.	Tổng quan : 
-	Layer-2 Switching hoạt động dựa trên địa chỉ phần cứng ( MAC address ) từ card mạng của máy chủ ( NIC card – Network Interface Card )
-	Sử dụng bộ vi mạch tích hợp chuyên dụng ( ASICs- Application-Specific Integrated Circuits ) để dựng và duy trì các bảng bộ lọc ( filter tables )
-	Layer-2 Switching có tốc độ rất nhanh vì nó không phải kiểm tra địa chỉ IP của gói tin mà chỉ quan tâm đến địa chỉ phần cứng ( MAC Address ) trước khi quyết định chuyển tiếp hay hủy gói tin ( frame ). Layer-2 Switching chỉ có chức năng sửa đổi địa chỉ phần cứng của các frame để chuyển tiếp đến trạm tiếp theo vì thế mà tốc độ sẽ nhanh hơn nhiều lần đồng thời ít lỗi phát sinh hơn so với việc định tuyến.
-	Layer-2 Switching cung cấp :
    - Cầu nối dựa trên phần cứng ( MAC Address )
    - Tốc độ cao ( wire speed )
    - Độ trễ thấp (  Low latency )
    - Giá cả thấp ( low cost )
-	Sử dụng Layer-2 Switching cho các mạng doanh nghiệp, các phân đoạn mạng (  Network Segments ). Layer-2 Switching giúp tăng băng thông cho mỗi người dùng vì mỗi 1 kết nối đến switch sẽ có miền xung đột riêng của nó, vì thế mà Layer-2 Switching sẽ có thể kết nối nhiều thiết bị cùng lúc tại nhiều port khác nhau.

### b.	Hạn chế của Layer-2 Switching :
-	Hệ thống mạng cầu nối ( Brigde Networks ) giúp phá vỡ các miền xung đột vì chúng sẽ tạo các kết nối khác nhau sao cho các thông tin không gặp nhau tại một thời điểm. Tuy nhiên Layer-2 Switching không thể phá vỡ miền quảng bá ( broadcast domain) , điều mà có thể gây ra các vấn đề về hiệu suất cũng như hạn chế đi kích thước của mạng. 

-	Broadcasts và multicasts cùng với việc hội tụ chậm của giao thức spanning tree có thể tạo ra các vấn đề xấu khi hệ thống mạng ngày càng phát triển hơn.

-	Chính vì những vấn đề đó mà Layer-2 Switching vẫn chưa thể thay thế được routers.

### c.	Bridging với LAN Switching.

![Imgur](https://i.imgur.com/1HrEOh2.png)

### d.	3 chức năng của Layer-2 Switching : 

-	Address learning ( học địa chỉ mạng ) : Layer-2 Switches ghi nhớ địa chỉ của máy đích của mỗi frame nó nhận dược trên đường truyền và lưu nó vào bảng dữ liệu tài liệu MAC.
-	Forward/filter decisions ( Quyết định Chuyển tiếp / Ngăn chặn 1 gói tin ): Khi 1 frame được tiếp nhận trên một cổng, switch nhìn vào địa chỉ phần cứng đích và xác định cổng ra cho frame dựa trên trong cơ sở dữ liệu MAC trong bảng Mac Table.
-	Loop avoidance (Tránh hiện trượng vòng lặp ) : Nếu nhiều kết nối giữa các thiết bị chuyển mạch được tạo ra để dự phòng, các vòng lặp trong mạng có thể xảy ra. Giao thức Spanning-Tree (STP) được sử dụng để ngăn chặn các vòng lặp mạng.

#### Address learning ( học địa chỉ mạng ) :

Khi một Switch được bật lên, bảng địa chỉ MAC ( MAC filtering table )của nó chưa có gì. Khi một thiết bị trong mạng truyền tin, gói tin đó sẽ đi đến một cổng kết nối giữa thiết bị với switch ( có thể là port từ 1, 2 ,3 .. ) . Switch sau đó sẽ kiểm kiểm tra frame đó, bao gồm cả địa chỉ MAC nguồn và MAC đích của frame, nó sẽ lưu địa chỉ đó vào bảng bộ lọc đồng thời lưu luôn cổng nào đã nhận frame đó vào. Điều này giúp cho Switch có thể biết được vị trí của thiết bị gửi tin ở đâu ( MAC addresss ) đồng thời biết được đường đi của gói tin từ thiết bị đó qua switch sẽ đi theo cổng nào. 
Trường hợp trong bảng bộ lọc của Layer-2 Switch chưa có địa chỉ MAC của máy đích, nó sẽ gửi frame đó đến tất cả các cổng của nó trừ cổng đã nhận frame đó vào. Nếu thiết bị nào trả lời lại và gửi 1 frame trở lại cho switch thì nó sẽ lưu địa chỉ MAC của máy đó vào. Khi đó Switch đã có địa chỉ MAC của cả máy gửi và máy nhận trên bảng bộ lọc , sau này nó sẽ căn cứ vào đó mà thiết lập các kết nối trực tiếp giữa 2 máy ( point – to -  point ), frames chỉ được truyền giữa 2 thiết bị. Chính điều này làm tăng tốc độ và hiệu quả của việc truyền gói tin, tạo nên sự khác biệt giữa Switch với Hubs. Trong mạng Hub, tất cả frame được chuyển tiếp tới tất cả các cổng ở mọi thời điểm.

![Imgur](https://i.imgur.com/VVH6TZ0.png)

Trong hình trên, có 4 máy chủ kết nối vào Switch. Khi Switch được bật lên, nó vẫn chưa có gì trong bảng địa chỉ MAC của nó.
1.	Máy 1 gửi một frame đến máy 3. Địa chỉ MAC của máy 1 là 0000.8c01.1111; của máy 3 là 0000.8c01.2222
2.	Switch nhận frame đó trên cổng E0 và lưu địa chỉ MAC nguồn của máy 1 trên bảng địa chỉ
3.	Vì trên bảng địa chỉ chưa có địa chỉ của máy đích nên Switch gửi bản tin đó đến tất cả các máy trong mạng
4.	Máy 3 nhận được frame và phản hồi lại cho máy 1. Switch nhận frame phản hồi đó trên cổng E2 và kiểm tra frame, lưu địa chỉ MAC của máy 3 cũng như cổng đã nhận frame từ máy 3 vào là E2.
5.	Máy 1 và máy 3 bây giờ có thể tạo các kết nối trực tiếp ( point – to – point ) đến nhau và máy 2 , máy 4 không nhận được frame đó.
Nếu 2 thiết bị không giao tiếp với nhau trong một khoảng thời gian thông qua Switch , nó sẽ xóa thông tin đã lưu trong bảng địa chỉ để tránh đầy bộ nhớ .

#### Forward/filter decisions ( Quyết định Chuyển tiếp / Ngăn chặn 1 gói tin ):
Khi một frame được chuyển đến một cổng của Switch, địa chỉ đích của gói tin sẽ được so sánh trên bảng bộ lọc địa chỉ MAC. Nếu đã có sẵn địa chỉ đó trong bảng và cổng kết nối của máy đích, thì frame đó sẽ được gửi luôn qua cổng đó đến máy đích. Việc này sẽ đảm bảo cho băng thông của đường truyền trên các phân vùng mạng khác và được gọi là **Bộ lọc Frame ( Frames Filtering ).**
Broadcast và Multicast frames không có địa chỉ MAC cụ thể nào. Địa chỉ nguồn luôn là địa chỉ của máy gửi, tuy nhiên địa chỉ đích có thể sẽ là dãy nhị phân 1s tới tất cả các kết nối ( Broadcast – tất cả số địa chỉ nhị phân là 1 ) hoặc dãy nhị phân 1s tới các khu vực mạng con đã được chỉ định sẵn.

![Imgur](https://i.imgur.com/mAoc5us.png)

**Chú ý:**
*- Tất cả các gói tin broadcast thì số địa chỉ nhị phân đều là 1 : 11111111. 11111111. 11111111. 11111111 ; còn muticasts chỉ gửi đến một khu vực mạng nhất định thì địa chỉ có thể sẽ khác, và không nhất thiết phải luôn là 1s, vd : 10011100. 10011111. 11111111. 11111111
- Khi Switch nhận những frames như trên, mặc định  nó sẽ nhanh chóng gửi chúng tới tất cả các cổng đang hoạt động. Nếu muốn các gói tin multicast và broadcast chỉ gửi tới một khu vực cụ thể nào đó thì ta sẽ thiết lập khu vực mạng LAN ảo (VLAN -  Virtual LAN ).*

#### Loop avoidance (Tránh hiện trượng vòng lặp ):
Redundant Links ( Link dự phòng ) là một phương pháp hữu ích giữa các Switches, chúng được tạo để kết nối giữa các Switches với nhau, trong trường hợp 1 kết nối bị lỗi hay hỏng hóc, Switch  sẽ lập tức dùng các kết nối dự phòng này để chuyển dữ liệu đi. 
Mặc dù Redundant Links rất hữu dụng tuy nhiên nó lại gây ra nhiều vấn đề hơn là lợi ích của chính nó. Các frames có thể được broadcast xuống tất cả cá Link dự phòng cùng lúc và sẽ gây ra các vòng lặp trong mang. Sau đây là một số vấn đề tiêu biểu :

1.	Nếu không có phương pháp Loop avoidance, các Switch sẽ luôn luôn đẩy tràn các bản tin broadcast vào trong mạng  - Hiện tượng Broadcast storm. Các frame broadcast sẽ luôn được gửi đi trong hệ thống mạng, tạo nên hiện tượng loop :

![Imgur](https://i.imgur.com/4EtG8vJ.png)


2.	Một thiết bị có thể nhận rất nhiều bản sao từ 1 frame vì frame đó có thể đến từ các phân vùng mạng khác nhau trong cùng 1 thời điểm.

![Imgur](https://i.imgur.com/R7NYPPk.png)

3.	Bảng bộ lọc địa chỉ MAC sẽ bị loạn khi không biết thiết bị nguồn nằm ở đâu vì Switch có thể nhận cùng 1 frame từ nhiều nguồn link. Switch sẽ có thể không chuyển tiếp được frame đó đến đúng nơi vì nó phải luôn cập nhật bảng bộ lọc MAC từ các nguồn địa chỉ phần cứng khác nhau. Điều này đươc gọi là thrashing the MAC table ( tra tấn/ hành hạ).
4.	Một trong những vấn đề lớn nhất là việc nhiều vòng lặp xảy ra cùng lúc trong mạng. Nó có nghĩa răng các vòng lặp có thể xảy ra trong các vòng lặp khác nữa ( vòng lặp kép ). Nếu một broadcast storm xảy ra, hệ thống mạng sẽ không thể thực hiện niệm vụ chuyển mạch các gói tin.
Giao thức [Spanning- Tree](https://github.com/Skyaknt/CCNA-basic-/blob/master/Spanning%20Tree%20Protocol.md) sẽ giải quyết các vấn đề này.

## CÁC LOẠI CHUYỂN MẠCH TRONG MẠNG NỘI BỘ ( LAN Switching Types )

Độ trễ chuyển mạch gói tin thông qua Switch phụ thuộc vào chế độ chuyển mạch đã chọn. Có ba chế độ chuyển đổi: 
- **Store and Forward** ( lưu trữ và chuyển tiếp ) : Khung dữ liệu hoàn chỉnh nhận được trên bộ nhớ đệm của Switch , một CRC được chạy và sau đó địa chỉ đích được tra cứu trong bảng lọc địa chỉ MAC  . 
- **Cut-through** : Switch chỉ đợi cho đến khi địa chỉ MAC đích được nhận và sau đó tra cứu địa chỉ đó trên bảng địa chỉ MAC.
- **FragmentFree** : mặc định cho thiết bị Catalyst 1900 switch, đôi khi nó được coi như là chế độ cut-through đã qua được phê chuẩn. Nó sẽ kiểm tra 64 bytes đầu của frame để xem có bị phân mảnh không ( trong quá trình xung đột với gói tin khác có thể dẫn đến tính toàn vẹn không được đảm bảo ) trước khi chuyển tiếp nó.


![Imgur](https://i.imgur.com/b2LtiF9.png)


### Store and Forward :
Thiết bị Switch ở mạng nội bộ sẽ sao chép frame hiện tại lên bộ nhớ đệm của nó và tính toán giá trị kiểm thử ( CRC ). Bởi vì nó là bản sao của frame hiện tại nên độ trễ khi đi qua Switch sẽ phụ thuộc vào độ dài của frame đó.
Frame sẽ bị loại bỏ nếu nó chứa đựng lỗi CRC, nếu nó quá ngắn ( nhỏ hơn 64bytes đã bao gồm CRC ) ,hoặc nó qá dài ( nhiều hơn 1518 bytes bao gồm cả CRC ). Nếu frame không có lỗi gì, thì Switch sẽ kiểm tra địa chỉ đích của nó trên bảng địa chỉ MAC và xác định đầu ra cho nó. Sau đó frame sẽ được chuyển đến nơi mà nó hướng đến.

### Cut-Through (Real Time)
Cắt qua chuyển đổi là loại chính khác của chuyển mạch LAN. Với phương pháp này, chuyển đổi mạng LAN chỉ sao chép địa chỉ đích (sáu byte đầu tiên sau lời mở đầu) vào bộ đệm trên máy bay của nó. Sau đó, nó tìm kiếm địa chỉ đích phần cứng trong bảng chuyển mạch MAC, xác định giao diện đi ra, và chuyển tiếp frame tới đích. Một công tắc cắt giảm cung cấp độ trễ giảm bởi vì nó bắt đầu chuyển tiếp khung ngay khi nó đọc địa chỉ đích và xác định giao diện đi ra.
Một số thiết bị chuyển mạch có thể được cấu hình để thực hiện chuyển mạch cắt qua trên cơ sở aper-port cho tới khi đạt được ngưỡng lỗi do người dùng xác định. Tại thời điểm đó, chúng sẽ tự động chuyển sang chế độ lưu trữ và chuyển tiếp để chúng sẽ ngừng chuyển tiếp các lỗi. Khi tỷ lệ lỗi trên cổng rơi xuống dưới ngưỡng, cổng sẽ tự động trở lại chế độ cắt.

### FragmentFree (Modified Cut-Through)
FragmentFree là một dạng chuyển đổi cắt qua sửa đổi, trong đó công tắc chờ đợi cho cửa sổ va chạm (64 byte) để vượt qua trước khi chuyển tiếp. Nếu một gói có lỗi, nó gần như luôn luôn xảy ra trong 64 byte đầu tiên. Chế độ phân mảnh Miễn phí kiểm tra lỗi tốt hơn chế độ cắt thông qua thực tế không tăng độ trễ. Đây là phương pháp chuyển đổi mặc định cho thiết bị chuyển mạch 1900



