# Ethernet Networking - Cách thức gói tin được truyền trong môi trường vật lý

**Ethernet là phương pháp tiếp cận truyền thông cho phép tất cả các máy chủ trong mạng có thể sử dụng cùng 1 băng thông của một liên kết vật lý. Ethernet rất phổ biến vì nó dễ triển khai, sửa chữa và tích hợp công nghệ mới khi cần thiết . Ví dụ như Fast-Ethernet, Gigabit Ethernet.
Ethernet sử dụng các thông số của tầng Data Link và Physical.**

Có 2 hình thức cơ bản để truy nhập vào các liên kết vật lý : **truy nhập ngẫu nhiên** và **truy nhập có điều kiện**. Trong đó có 3 phương pháp hay dùng nhất trong các mạng cục bộ hiện nay : **CSMA/CD , Token Bus, Token Ring.**
## 1.	CSMA/CD (Carrier Sense Multiple Access with Collision Detect (CSMA/CD) : phương pháp đa truy cập sử dụng sóng mang có phát hiện xung đột.
-	**Hoạt động** : khi một máy chủ muốn gửi thông điệp qua mạng, đầu tiên CSMA sẽ kiểm tra xem trong hệ thống mạng có tín hiệu số nào không. Nếu không có tín hiệu nào ( không có máy nào đang truyền dữ liệu) máy chủ đó sẽ bắt đầu tiến hành việc truyền. Trong quá trình truyền, phương pháp CSMA/CD còn kiểm soát đường truyền theo thời gian thực. Nếu phát hiện ra các tín hiệu khác trên đường truyền, nó sẽ gửi một tín hiệu jam đến các node trên segment để dừng việc gửi dữ liệu đó lại. Các node sẽ phản hồi lại tín hiệu jam bằng cách đợi trong 1 khoảng thời gian trước khi cố gắng gửi dữ liệu tiếp. Thuật toán Backoff giúp xác định thời điểm để gửi lại dữ liệu từ các trạm, sau 15 lần bị hoãn gửi thì việc truyền thông tin từ node đó sẽ bị hết hiệu lực và phải thiết lập một kết nối mới.
### a.	Half-duplex và Full-duplex Ethernet (chế độ bán song công và song công toàn phần) 
-**Hafl-duplex Ethernet**: được định nghĩa trong chuẩn 802.3 Ethernet và sử dụng chỉ một kết nối với một tín hiệu số chạy cả 2 chiều trên kết nối đó . 
*Ví dụ : Khi một gói tin từ đầu bên này gửi đi và bên đầu kia cũng gửi đi 1 gói tin, 2 gói tin sẽ cùng được truyền đi trên kết nối đó, khi chúng gặp nhau, 1 gói tin phải nhường đường cho gói tin kia đi rồi nó mới tiếp tục , điều này hay gây nên xung đột. Công nghệ này cũng sử dụng phương pháp CSMA/CD để chống xung đột và tiến hành gửi lại dữ liệu nếu xung đột xảy ra.*
   -	Nếu HUB được kết nối vào Switch, nó phải hoạt động ở chế độ Hafl-duplex  để xác định xung đột.
   -	Hafl-duplex Ethernet , đặc biệt trong mạng 10BaseT chỉ đạt mức hiệu quả 50-60% 
   -	Trong một mạng lớn 10BaseT, phương pháp half-duplex chỉ đảm bảo băng thông giao động ở mức 3-4Mbps.
    <br>
-   ***10BASE-T** là một công nghệ trong mạng [Ethernet] cho phép các [máy tính] trong mạng được nối với nhau thông qua cáp đôi xoắn. Tên gọi của 10BASE-T xuất phát từ một vài đặc điểm vật lý, trong đó 10 tương ứng với tốc độ truyền tối đa 10 [Megabit] trên giây (Mb/s), BASE là viết gọn của [baseband], T là loại cáp xoắn đôi (Twisted Pairs). Vì sử dụng cáp xoắn đôi nên nó có thẻ chạy song công toàn phần (Full duplex).*
</br>

-**Full-duplex Ethernet**: sử dụng 1 kết nối tuy nhiên tín hiệu được truyền theo cả 2 chiều kết nối đó thay vì chỉ 1 chiều .

   -	Sử dụng kết nối **point – to – point**  giữa bộ phận gửi ở thiết bị gửi với bộ phận nhận của thiết bị nhận (ví dụ :  1 cổng bên này sẽ gửi dữ liệu sang 1 cổng ở đầu kia, còn đầu kia sẽ gửi dữ liệu từ 1 cổng khác của mình sang bên này , máy bên này cũng sẽ nhận bằng 1 cổng khác). 
    
   -	**Không có xung đột** xảy ra trên đường truyền vì 2 chiều của tín hiệu được truyền trên 2 cặp dây khác nhau.
    
   -	Full-duplex Ethernet đạt mức *hiệu quả* truyền tải là *100%* ở cả 2 chiều đường truyền. Ví dụ bạn có thể có băng thông 20Mbps với đường truyền Ethernet 10Mbps sử dụng phương pháp Full-duplex.

-	Khi một cổng Full-duplex Ethernet đươc bật, nó sẽ kết nối tới điểm đầu và cuối của liên kết FastEthernet. Cơ chế này gọi là chế độ tự động phát hiện. Đầu tiên nó sẽ kiểm tra khả năng tải của đường dây trên cả 2 đầu để xem nó có đáp ứng được 10-100Mbps không để tiến hành truyền thông tin theo phương pháp Full-duplex. Nếu không nó sẽ sử dụng phương pháp Hafl-duplex. 

### b.	Ehternet ở Tầng Liên Kết Dữ Liệu ( Data Link Layer) : 
Ethernet ở tầng Data Link đảm nhận về địa chỉ Ethernet hay địa chỉ vật lí MAC. 
Ethernet cũng đảm nhiệm việc đóng gói các packet dữ liệu từ tầng Network xuống thành các frame lớn hơn để chuẩn bị cho việc truyền dữ liệu vào hệ thống mạng qua phương pháp truyền thông.
Có 4 loại gói dữ liệu Ethernet ( Frame) :
-	Ethernet_II
-	IEEE 802.3
-	IEEE 802.2
-	SNAP

#### Ethernet Addressing (địa chỉ Ethernet) :
-	Việc gán địa chỉ Ethernet sử dụng địa chỉ MAC ( Media Access Control ) – địa chỉ được gắn cứng trên các thiết bị card mạng. 
    o	Địa chỉ MAC (địa chỉ truy nhập môi trường - địa chỉ phần cứng ) được viết ở một chuẩn riêng biệt để chắc chắn rằng không có địa chỉ nào trùng nhau. 
    o	Địa chỉ MAC là một số 48 bit được biểu diễn bằng 12 số hexa (hệ số thập lục phân), trong đó 24bit đầu (MM:MM:MM) là mã số của NSX (Linksys, 3COM...) và 24 bit sau (SS:SS:SS) là số seri của từng card mạng được NSX gán.
    
 ![Imgur](http://i.imgur.com/aIrzw7m.png)
 
*Bit 46 là 0 nếu nó là bit được chỉ định trên toàn cầu từ nhà sản xuất và 1 nếu nó được quản trị cục bộ từ quản trị viên mạng.*

**Ethernet Frames ( Các Khung Ethernet)**

-	Tầng Data Link đảm nhận nhiệm vụ gộp các bits thành các bytes và từ các byte thành các frames. Các khung frames được sử dụng ở tầng Data Link để đóng gói các packets được truyền từ tầng Network xuống . 
-	Có 3 phương pháp truy nhập truyền thông : contention – giải quyết tranh chấp tài nguyên ( Ethernet) , token passing -phương pháp điều khiển luồng dùng kĩ thuật chuyển thẻ bài (Token Ring and FDDI), and polling (IBM Mainframes and 100VGAnylan).
-	Một khung frame Ethernet bắt đầu với một tiêu đề, trong đó có chứa các địa chỉ MAC nguồn và đích. Phần giữa của khung là dữ liệu thực tế. Khung kết thúc với một trường gọi là  Kiểm tra trạng thái frame (FCS- frame check sequence).

#### 802.3 Frame :

-	Cấu trúc khung Ethernet được định nghĩa trong tiêu chuẩn IEEE 802.3. Đây là một biểu diễn đồ họa của một khung Ethernet và mô tả của mỗi trường trong khung:

![Imgur](http://i.imgur.com/lJ971J5.png)

 
 - 	  - **Preamble** - thông báo cho hệ thống nhận biết rằng một khung đang bắt đầu và cho phép đồng bộ hóa.
   	  - **SFD (Start Frame Delimiter)**: chỉ ra rặng khu vực đặt địa chỉ MAC đích sẽ ở byte tiếp theo.
   	  - **DA – Destination address:** định danh địa chỉ máy đích
      - **SA – Source address**: định danh địa chỉ máy gửi.
     
#### 802.2 and SNAP :
Chuẩn 802.3 Ethernet frame không thể tự nó định danh được giao thức sử dụng ở tầng trên ( tầng Network), mà cần sự giúp đỡ từ chuẩn 802.2 LLC để cung cấp chức năng này. 

# Tham khảo thêm : 

( 2 phương pháp dưới hiện tại không còn phổ biến trong truyền thông qua mạng )

## 2. Phương pháp Token BUS (phương pháp bus với thẻ bài)
  - Phương pháp truy nhập có điểu khiển dùng kỹ thuật “chuyển thẻ bài” để cấp phát quyền truy nhập đường truyền. Thẻ bài (Token) là một đơn vị dữ liệu đặc biệt, có kích thước và có chứa các thông tin điều khiển trong các khuôn dạng 
      • Nguyên lý: Để cấp phát quyền truy nhập đường truyền cho các trạm đang có nhu cầu truyền dữ liệu,một thẻ bài được lưu chuyển trên một vòng logic thiết Các phương pháp truy nhập đường truyền vật lý lập bởi các trạm đó. Khi một trạm nhận được thẻ bài thì nó có quyền sử dụng đường truyền trong một thời gian định trước. Trong thời gian đó nó có thể truyền một hoặc nhiều đơn vị dữ liệu. Khi đã hết dữ liệu hay hết thời đoạn cho phép, trạm phải chuyển thẻ bài đến trạm tiếp theo trong vòng logic. Như vậy công việc phải làm đầu tiên là thiết lập vòng logic (hay còn gọi là vòng ảo) bao gồm các trạm đang có nhu cầu truyền dữ liệu được xác định vị trí theo một chuỗi thứ tự mà trạm cuối cùng của chuỗi sẽ tiếp liền sau bởi trạm đầu tiên. Mỗi trạm được biết địa chỉ của các trạm kề trước và sau nó. Thứ tự của các trạm trên vòng logic có thể độc lập với thứ tự vật lý. Các trạm không hoặc chưa có nhu cầu truyền dữ liệu thì không được đưa vào vòng logic và chúng chỉ có thể tiếp nhận dữ liệu.
      
      ![Imgur](http://i.imgur.com/j7SfbUq.png)
      
  - Trong hình vẽ, các trạm A, E nằm ngoài vòng logic, chỉ có thể tiếp nhận dữ liệu dành cho chúng.
  • Vấn đề quan trọng là phải duy trì được vòng logic tuỳ theo trạng thái thực tế của mạng tại thời điểm nào đó. Cụ thể cần phải thực hiện các chức năng sau: 
  • Bổ sung một trạm vào vòng logic: các trạm nằm ngoài vòng logic cần được xem xét định kỳ để nếu có nhu cầu truyền dữ liệu thì bổ sung vào vòng logic. 
  - Loại bỏ một trạm khỏi vòng logic: Khi một trạm không còn nhu cầu truyền dữ liệu cần loại nó ra khỏi vòng logic để tối ưu hoá việc điều khiển truy nhập bằng thẻ bài
  • Quản lý lỗi: một số lỗi có thể xảy ra, chẳng hạn trùng địa chỉ (hai trạm đều nghĩ rằng đến lượt mình) hoặc “đứt vòng” (không trạm nào nghĩ đến lượt mình)
  • Khởi tạo vòng logic: Khi cài đặt mạng hoặc sau khi “đứt vòng”, cần phải khởi tạo lại vòng. • Các giải thuật cho các chức năng trên có thể làm như sau:
  • Bổ sung một trạm vào vòng logic, mỗi trạm trong vòng có trách nhiệm định kỳ tạo cơ hội cho các trạm mới nhập vào vòng. Khi chuyển thẻ bài đi, trạm sẽ gửi thông báo “tìm trạm đứng sau” để mời các trạm (có địa chỉ giữa nó và trạm kế tiếp nếu có) gửi yêu cầu nhập vòng. Nếu sau một thời gian xác định trước mà không có yêu cầu nào thì trạm sẽ chuyển thẻ bài tới trạm kề sau nó như thường lệ. Nếu có yêu cầu thì trạm gửi thẻ bài sẽ ghi nhận trạm yêu cầu trở thành trạm đứng kề sau nó và chuyển thẻ bài tới trạm mới này. Nếu có hơn một trạm yêu cầu nhập vòng thì trạm giữ thẻ bài sẽ phải lựa chọn theo giải thuật nào đó.
• Loại một trạm khỏi vòng logic: Một trạm muốn ra khỏi vòng logic sẽ đợi đến khi nhận được thẻ bài sẽ gửi thông báo “nối trạm đứng sau” tới trạm kề trước nó yêu cầu trạm này nối trực tiếp với trạm kề sau nó 
• Quản lý lỗi: Để giải quyết các tình huống bất ngờ. Chẳng hạn, trạm đó nhận được tín hiệu cho thấy đã có các trạm khác có thẻ bài. Lập tức nó phải chuyển sang trạng thái nghe (bị động, chờ dữ liệu hoặc thẻ bài). Hoặc sau khi kết thúc truyền dữ liệu, trạm phải chuyển thẻ bài tới trạm kề sau nó và tiếp tục nghe xem trạm kề sau đó có hoạt động hay đã bị hư hỏng. Nếu trạm kề sau bị hỏng thì phải tìm cách gửi các thông báo để vượt qua trạm hỏng đó, tìm trạm hoạt động để gửi thẻ bài. 
• Khởi tạo vòng logic: Khi một trạm hay nhiều trạm phát hiện thấy đường truyền không hoạt động trong một khoảng thời gian vượt quá một giá trị ngưỡng (time out) cho trước - thẻ bài bị mất (có thể do mạng bị mất nguồn hoặc trạm giữ thẻ bài bị hỏng). Lúc đó trạm phát hiện sẽ gửi đi thông báo “yêu cầu thẻ bài” tới một trạm được chỉ định trước có trách nhiệm sinh thẻ bài mới và chuyển đi theo vòng logic.
## 3. Phương pháp Token Ring
• Phương pháp này dựa trên nguyên lý dùng thẻ bài để cấp phát quyền truy nhập đường truyền. Thẻ bài lưu chuyển theo vòng vật lý chứ không cần thiết lập vòng logic như phương pháp trên 
• Thẻ bài là một đơn vị dữ liệu đặc biệt trong đó có một bít biểu diễn trạng thái sử dụng của nó (bận hoặc rôĩ). Một trạm muốn truyền dữ liệu thì phải đợi đến khi nhận được một thẻ bài rỗi. Khi đó nó sẽ đổi bít trạng thái thành bận và truyền một đơn vị dữ liệu cùng với thẻ bài đi theo chiều của vòng. Giờ đây không còn thẻ bài rỗi trên vòng nữa, do đó các trạm có dữ liệu cần truyền buộc phải đợi. Dữ liệu đến trạm đích sẽ được sao lại, sau đó cùng với thẻ bài đi tiếp cho đến khi quay về trạm nguồn. Trạm nguồn sẽ xoá bỏ dữ liệu, đổi bít trạng thái thành rỗi cho lưu chuyển tiếp trên vòng để các trạm khác có thể nhận được quyền truyền dữ liệu.

![Imgur](http://i.imgur.com/j7SfbUq.png)

• Sự quay về trạm nguồn của dữ liệu và thẻ bài nhằm tạo một cơ chế nhận từ nhiên: trạm đích có thể gửi vào đơn vị dữ liệu các thông tin về kết quả tiếp nhận dữ liệu của mình.
• Trạm đích không tồn tại hoặc không hoạt động
• Trạm đích tồn tại nhưng dữ liệu không sao chép được
• Dữ liệu đã được tiếp nhận
• Phương pháp này cần phải giải quyết hai vấn đề có thể gây phá vỡ hệ thống:
• Mất thẻ bài: trên vòng không còn thẻ bài lưu chuyển nữa
• Một thẻ bài bận lưu chuyển không dừng trên vòng
• Giải quyết: Đối với vấn đề mất thẻ bài, có thể quy định trước một trạm điều khiển chủ động. Trạm này sẽ phát hiện tình trạng mất thẻ bài bằng cách dùng cơ chế ngưỡng thời gian (time out) và phục hồi bằng cách phát đi một thẻ bài “rỗi” mới.
Đối với vấn đề thẻ bài bận lưu chuyển không dừng, trạm monitor sử dụng một bit trên thẻ bài (gọi là monitor bit) để đánh dấu đặt giá trị 1 khi gặp thẻ bài bận đi qua nó. Nếu nó gặp lại một thẻ bài bận với bít đã đánh dấu đó thì có nghĩa là trạm nguồn đã không nhận lại được đơn vị dữ liệu của mình và thẻ bài “bận” cứ quay vòng mãi. Lúc đó trạm monitor sẽ đổi bit trạng thái của thẻ thành rỗi và chuyển tiếp trên vòng. Các trạm còn lại trên trạm sẽ có vai trò bị động: chúng theo dõi phát hiện tình trạng sự cố của trạm
Các phương pháp truy nhập đường truyền vật lý
5/6
monitor chủ động và thay thế vai trò đó. Cần có một giải thuật để chọn trạm thay thế cho trạm monitor hỏng.




