# Spanning Tree Protocol
Giao Thức Phân nhánh chống vòng lặp 

### Mục lục

#### I. Tổng quan về STP

[1. Định nghĩa](#dn)

[2. Chuyển mạnh chống loop](#cm)

#### II. Hoạt động

[1. Bầu chọn Root Bridge](#rb)
  
[2. Bàu chọn Root Port](#rp)
 
[3. Bàu chọn Designated Port](#des)

#### III. Các loại Spanning Tree

[1. Độc quyền Cisco](#dq)

[2. Theo chuẩn IEEE](#ie)
   
#### IV. Các khái niệm 
[1. Port ID](#id)
[2. Port Fast](#fast)

<hr>   
   
## I. Tổng quan về STP
### <a name="dn"> 1. Định nghĩa </a> 

Spanning Tree Protocol (STP) là một giao thức ngăn chặn sự lặp vòng, cho phép các bridge truyền thông với nhau để phát hiện vòng lặp vật lý trong mạng. Sau đó giao thức này sẽ định rõ một thuật toán mà bridge có thể tạo ra một topology luận lý chứa loop-free. Nói cách khác STP sẽ tạo một cấu trúc cây của free-loop gồm các lá và các nhánh nối toàn bộ mạng lớp 2.

### <a name="cm"> 2. Chuyển mạch chống loop </a>
  
Một Switch layer 2 chỉ thuộc về một miền broadcast, và chỉ chuyển đi các gói tin broadcast và multicast ra ngoài bằng cổng một cổng chính .
Khi hiện tượng Vòng lặp trong chuyển mạch xảy ra, một cơn bão broadcast phá hoại sẽ xuất hiện chỉ trong 1 vài giây. Bão tin broadcast xảy ra khi mà các bản tin broadcast được gửi đi không ngừng giữa các Switch và tạo thành một vòng lặp giữa chúng. Bão Broadcast sẽ ngăn chặn hoàn toàn các kết nối lưu thông trong hệ thống mạng.
Cùng xem ví dụ sau : 

![Imgur](https://i.imgur.com/9JIilov.png)

- Nếu HostA gửi đi bản tin Broadcast , SwitchD sẽ chuyển tiếp bản tin Broadcast ra tất cả các cổng của nó trên cùng 1 VLAN, bao gồm cả cổng trunk kết nối vào SwitchB và SwitchE. Sau đó, cả 2 Switch B và E cũng sẽ chuyển tiếp gói tin Broadcast đó ra tất cả các cổng, bao gồm cả cổng trunk kết nối tới SwitchA và C.

- Gói tin Broadcast sẽ đi theo một vòng lặp giữa các Switch mà không dừng lại. Thực tế, ở đây sẽ có 2 cơn bão Broadcast đi theo 2 chiều đối ngược nhau trong vòng lặp ở hệ thống các Switch này.  Chỉ khi tắt các Switch đi hoặc tác động vật lí vào các Switch thì mới ngăn chặn được cơn bão.

- Chính vì vậy , **Spanning Tree Protocol** ( STP) được tạo ra để ngăn chặn các cơn bão Broadcast gây ra bởi vòng lặp chuyển mạch ( Switching loops ). STP tiêu chuẩn được định nghĩa trong chuẩn **IEEE 802.1D**.

- Hệ thống chuyển mạch sử dụng STP sẽ xâu dựng một bản đồ hoặc **Một mô hình thiết kế  ( Topology )** của hệ thống mạng chuyển mạch lớp 2 hiện tại. STP sẽ xác định xem trong mạng này có vòng lặp nào không, và sau đó sẽ vô hiệu hóa hoặc khóa các cổng nếu cần thiết để loại bỏ các vòng lặp trong  mô hình đó.

- Một cổng bị khóa có thể sẽ được kích hoạt trở lại nếu các cổng khác bị trục trặc. Điều này cho phép STP có thể duy trì các liên kết dự phòng cũng như khắc phục sự cố khi cần.

- Tuy nhiên, vì các cổng bị khóa là để loại bỏ hiện tượng vòng lặp, STP sẽ không hỗ trợ cân bằng tải cho nó trừ khi kết nối **Etherchannel** được sử dụng . 

- Các Switches STP trao đổi với nhau gói tin **Bridge Protocol Data Units (BPDU’s)** để xây dựng lên cơ sở dữ liệu cho mô hình mạng đó. BPDU’s được chuyển tiếp đến tất cả các cổng **sau mỗi 2s** , đến một  địa chỉ *multicast MAC* chuyên dụng là *0180.c200.0000*. 

Việc xây dựng mô hình STP là một quá trình hội tụ đa tầng, gồm các bước :
-	Bầu chọn **Root Bridge** 
-	Bầu chọn **Root Ports**
-	Chọn **Designated Port**
-	Các cổng được để ở chế độ khóa ( **blocking** ) là để loại bỏ vòng lặp

**The Root Bridge** đóng vai trò là điểm tham chiếu trung tâm cho topo STP.
Một khi các topo đầy đủ được xác định, và các vòng được loại bỏ, các thiết bị chuyển mạch được coi là mạng hội tụ .
STP được **kích hoạt** mặc định trên tất cả các thiết bị chuyển mạch của Cisco, cho tất cả các VLAN

<hr>

## II. Hoạt động 


### <a name="rb"> 1. Bầu chọn Root Bridge </a> 

Bước đầu tiên trong quá trình hội tụ STP là bầu chọn **Root Bridge** , cái mà sẽ là điểm tham chiếu trung tâm cho mô hình mạng. 
Một Root Bridge được bầu dựa trên **chỉ số ID ( Bridge ID)** của nó, chính là sự kết hợp giữa 2 thành phần trong chuẩn 802.1D:
-	16-bit **Bridge priority**
-	48-bit **MAC address** 
Chỉ số ưu tiên mặc định cho các Bridge	là **32,768**  và thiết bị nào có **priority thấp nhất** trong mạng sẽ được bầu. Nếu các thiết bị trong mạng đều có cùng priority thì **địa chỉ MAC bé nhất** sẽ được sử dụng như là vòng cuối cùng (tie-breaker) để chọn ra **Root Bridge** .

Cùng xem ví dụ sau : 

![Imgur](https://i.imgur.com/ZmoEI2j.png)


Các Switch gửi cho nhau các bản tin BPDU’s để tiến hành cuộc bầu chọn, và thiết bị Bridge có ID nhỏ nhất sẽ được làm Root Bridge :
-	SwitchB, SwitchC, và SwitchE có priority mặc định là 32,768.
-	SwitchA và D có cùng priority là 100, vì vậy chúng sẽ phải tiến hành thêm vòng loại tiếp theo – so sánh địa chỉ MAC.
-	SwitchA có địa chỉ **MAC nhỏ hơn B**, vì vậy nó sẽ được chọn làm **Root Bridge** 
Theo mặc định, một Switch sẽ luôn nghĩ nó là Root Bridge cho đến khi nó nhận bản tin BPDU từ một  Switch có số Bridge ID nhỏ hơn. Đây được gọi là **BPDU cấp trên ( superior BPDU )**. Quá trình bầu cử liên tục - nếu một Switch  mới với Bridge ID thấp nhất được thêm vào topo, nó sẽ được bầu làm Root Bridge.

### <a name="rp"> 2. Bầu chọn Root Port </a> 

Bước thứ 2 trong quá trình hội tụ STP là xác định **Root Ports**. Root port ở mỗi Switch sẽ có chỉ số root **path cost** thấp nhất đi tới **Root Bridge**  .
Mỗi Switch chỉ có thể có **1 root port** . Root Bridge **không có** root port vì root port chính là **trỏ** từ **unroot Switch** tới **Root Bridge** . 
**Path cost (chi phí đường truyền )** là chi phí tích lũy cho để đến được Root Bridge , dựa trên băng thông của các liên kết. Băng thông càng cao, chi phí đường truyền càng thấp : 

![Imgur](https://i.imgur.com/nnfGmfV.png)

**Chi phí đường truyền thấp hơn sẽ luôn được ưu tiên sử dụng hơn :**

![Imgur](https://i.imgur.com/JUi6tIX.png)


Mỗi một liên kết 1Gbps  có chi phí ( path cost ) là 4. SwitchA có chi phí tích lũy đường truyền là 0 vì nó là **Root Bridge** . Vì vậy, khi Switch A gửi gói tin BPDU’s của nó đi, bản tin đó sẽ quảng bá path cost của Switch	A là 0.


**Switch B** có 2 đường đi để đến được Root Bridge :
-	Một đường trực tiếp đến Switch A, với path cost là 4
-	Một đường khác phải đi qua Switch D, với path  cost là 16.
Chỉ số tích lũy chi phí đường truyền thấp nhất sẽ được ưu tiên cao hơn (superior) và vì thế mà cổng kết nối trực tiếp vào Switch A sẽ trở thành root port. Một BPDU từ một Switch mà thông tin trong nó cho thấy chỉ số path cost cao hơn thì được coi là BPDU cấp độ ưu tiên thấp hơn ( **inferior BPDU** ).
**Switch D** cũng có 2 đường dẫn đến Root Bridge : 
-	Một đường đi qua Switch B, có path cost là 8.
-	Một đường đi qua Switch E, có path cost là 12.
=>	Cổng đi qua SwitchB sẽ được chọn trở thành root port.
**Nhắc lại** , Root Bridge sẽ quảng bá bản tin BPDU của nó với chỉ số path cost là 0. Khi bản tin đó được truyền xuống các Switch khác, chúng sẽ thêm path cost vào cổng vừa nhận bản tin BPDU, và gửi bản tin tích lũy chi phí đường truyền đó đến các Switch hàng xóm của nó.
**Ví dụ**, SwitchC sẽ nhận bản tin BPDU với path cost là 0 từ Root Bridge ( Switch A) . Switch C sẽ thêm path cost vào cổng mà nó vừa nhận bản tin, do đó cumulative path cost của SwitchC sẽ là 4.
Switch C sẽ truyền bá bản tin BPDU của nó với path cost là 4 tới Switch E, và tiếp tục Switch E sẽ thêm path cost vào cổng mà nó vừa nhận bản tin từ Switch C, có nghĩa là sau đó chỉ số cumulative path cost sẽ là 8.


**Path cost** có thể điều chỉnh bằng tay trên mỗi cổng bằng lệnh : 
```
SwitchD(config)# int gi2/22 
SwitchD(config-if)# spanning-tree vlan 101 cost 42
```

### <a name="des"> 3. Bầu chọn Designated Port </a> 

- Bước thứ 3 là là xác định designated ports. Mỗi một phân vùng mạng sẽ có duy nhất 1 cổng được chỉ định để chuyển tiếp bản tin BPDUs và các frames đến phân vùng mạng đó.

- Nếu 2 cổng đều đáp ứng đủ yêu cầu để trở thành designated port thì nó sẽ tạo ra vòng lặp **(loop)**. Một trong số 2 cổng đó sẽ bị khóa ( placed in a blocking state) để loại bỏ vòng lặp.

- Cũng giống như Root port, desiganted port được xác định bởi chỉ số tích lũy chi phí đường truyền thấp nhất trở tới Root Bridge. Một designated port sẽ không bao giờ bị đặt ở chế độ khóa ( blocking state ) trừ khi có một sự thay đổi trong mô hình chuyển mạch và có những cổng khác có chỉ số tích lũy thấp hơn được chọn.

**Chú ý** : Một cổng không bao giơ có thể là designated port và root port, chỉ có thể là 1 trong 2.

Tham khảo ví dụ sau : 

![Imgur](https://i.imgur.com/AzF7zAk.png)

- Các cổng trên Root Bridge không được đặt ở chế độ khóa. Vì thế 2 cổng trên Switch A sẽ tự động trở thành designated ports.
**Nhớ rằng**, mỗi phân vùng mạng phải có một designated port, kể cả khi đã tồn tại 1 root port trên phân vùng mạng đó. 

- Vì thế, các phân cùng mạng giữa SwitchB và SwitchD , và giữa C với E , tất cả đều yêu cầu phải có designated port. Cổng trên SwitchD và E đã được chỉ định sẵn là root port vì thế mà 2 cổng còn lại trên Switch B và C sẽ trở thành các designated port.

- Trong mô hình này, phân vùng mạng giữa Switch D và E không có root port .

- Bởi vì 2 cổng trên phân vùng này đều có đủ điều kiện để trở thành designated port , và STP phát hiện ra rằng ở đây xuất hiện một vòng lặp. Một trong 2 cổng phải được chọn là designated port, và cổng còn lại sẽ ở trạng thái bị khóa ( blocking state ).
Thông thường, bất cứ Switch  nào có chỉ số cumulative path cost thấp nhất thì cổng của nó sẽ trở thành designated port  và ngược lại, Switch có chỉ số đó cao nhất thì cổng nối ở Switch đó sẽ bị block.

- Trong ví dụ ở trên, sẽ phải có một vòng cuối quyết định để xem đâu là designated port, trong segment của Switch D và E,cả 2 đều có cùng cumulative path cost trỏ đến Root Bridge  bằng 12.

- Vì vậy mà **chỉ số Bridge ID thấp nhất** sẽ được lựa chọn trong vòng tiebreaker. Switch D có chỉ số ưu tiên là 100, trong khi E là 32,768. Vì thế cổng trên SwitchD sẽ được chọn làm designate port, cổng trên SwitchE sẽ bị khóa ( blocking state ).

- Giống như việc bầu chọn ra Root Bridge , nếu mà ở vòng so sánh priority vẫn hòa nhau, thì thiết bị có **địa chỉ MAC thấp nhất** sẽ được chọn .

*Ghi nhớ :  bất cứ cổng nào nếu không được chọn làm root hay designated port thì đều sẽ bị ở trạng thái khóa.*


### III. Các loại Spanning Tree Protocol :

#### <a name="dq"> 1. Độc quyền Cisco </a>

##### 1.1 PVST ( Per VLan Spanning Tree):

- Một version độc quyền của Cisco. Mỗi vlan sẽ chạy một tiến trình STP riêng biệt và không bị phụ thuộc lẫn nhau . 

- Ưu điểm :

    - Giảm kích thước của STP topology , chia ra làm các topology nhỏ hơn , dẫn đến thời gian converge của STP giảm xuông . 
    - Cung cấp thêm khả năng load balancing .
    - Cung cấp các phần mở rộng như BackboneFast, UplinkFast, PortFast
    
- Khuyết điểm :

    - Sử dụng nhiều tài nguyên của CPU trong việc quản lí nhiều vlan . 
    
##### 1.2 PVST+ 

- Cisco tung ra một version khác của STP là PVST+ nhằm giải quyết vấn đề tương thích giữa CST và PVST . 
- PVST+ đảm nhiệm vai trò như là một translator giữa PVST và CST .
- PVST+ có thể giao tiếp với PVST qua kết nối ISL trunking , ngược lại PVST+ có thể giao tiếp với CST qua kết nối dot1q trunking .
- Tại biên giới của PVST và PVST+ sẽ diễn ra việc mapping STP one-to-one . Tại biên giới của PVST+ và CST sẽ diễn ra việc mapping giữa một STP của CST và một PVST trong PVST+ ( STP trong CST chỉ có một mà thôi ) . 

##### 1.3 Rapid-PVST+ 

- Phiên bản nâng cao của PVST+
- Dựa trên chuẩn IEEEE802.1w
- Tốc độ hội tụ chuyển machj nhanh hơn chuẩn 802.D

#### <a name="ie"> 2. Theo chuẩn IEEE </a>    

##### 2.1 RSTP

- Giới thiệu vào năm 1982, cung cấp khả năng hội tụ chống loop nhanh hơn chuẩn 802.D
- Chạy được các phiên bản chung của các phần mở rộng STP độc quyền của Cisco
- IEEE đã kết hợp RSTP vào 802.1D, xác định đặc điểm kỹ thuật như IEEE 802.1D-2004

##### 2.2 MSTP

- Cho phép nhiều VLAN được ánh xạ tới cùng một cá thể spanning tree, giảm số lượng các trường hợp cần thiết để hỗ trợ một số lượng lớn các VLAN.
- MSTP được lấy cảm hứng từ các giao thức STP (MISTP) độc quyền của Cisco và là sự tiến triển của STP và RSTP.
- Chuẩn IEEE 802.1Q-2003 hiện bao gồm MSTP. MSTP cung cấp nhiều đường chuyển tiếp cho lưu lượng dữ liệu và cho phép cân bằng tải.

###  IV. Các khái niệm

#### <a name="id"> 1. PortID </a>

- Khi bầu root và designated port, rất có thể sẽ xảy ra trường hợp mà cả 2 chỉ số path cost và Bridge ID bằng nhau giữa 2 thiết bị. Tham khảo ví dụ sau :

![Imgur](https://i.imgur.com/RfYfqSU.png)


- Nhìn lên ví dụ ta thấy băng thông và path cost của cả 2 kết nối đều bằng nhau giữa 2 thiết bị. Vậy thì cổng nào sẽ trở thành root port trên Switch B? Bình thường Bridge ID thấp nhất sẽ được chọn tuy nhiên trong trường hợp này thì không được.

- **PortID**  sẽ được sử dụng như là vòng loại cuối cùng,  bao gồm 2 thành phần sau :

    -	4-bit **port priority**
    -	12-bit **port number**, được lấy ra từ số thứ tự port vật lí trên thiết bị.

- Theo mặc định, port priority của một cổng là 128, và chỉ số thấp hơn sẽ được ưu tiên hơn. Nếu trong trường hợp này , thì số thứ tự port thấp nhất sẽ được chọn, ở đây là port gi2/23.
Port number là chỉ số cố định không thay đổi được, tuy nhiên thì port priority có thể thay đổi được bằng lệnh sau : 

```
Switch(config)# int gi2/11
Switch(config-if)# spanning-tree vlan 101 port-priority 32
```

**Chú ý** : trong một số tài liệu có thể ghi Port ID là tổ hợp của 2 chỉ số : 8-bit priority và 8-bit port number thì điều này vẫn đúng trong chuẩn nguyên bản của 802.1D.
    - Tuy nhiên ở chuẩn **IEEE 802.1t** lại định lại chỉ số này là 12-bit port number để chấp nhận thiết bị chuyển mạch mô đun với mật độ cổng cao.
    - Thậm chí nhiều rắc rối hơn - một số trang trên trang web của Cisco sẽ xác định port ID  là một sự kết hợp của priority port và địa chỉ MAC, thay vì port number. Điều này không chính xác trong việc triển khai STP hiện đại.

![Imgur](https://i.imgur.com/LwPWFnf.png)


**Ghi nhớ** : Port ID là vòng cuối cùng để STP cân nhắc . STP xác định root và designated port dựa trên những chỉ số sau :  
-	**Chi phí đường đi thấp nhất đến Root Bridge** (Lowest path cost to the Root Bridge)
-	**Chỉ số Bridge ID thấp nhất**  (Lowest bridge ID)
-	**Chỉ số port ID của thiết bị gửi thấp nhất** ( Lowest sender port ID)
**Bridge ID thấp nhất luôn được sử dụng để xác định Root Bridge.**


#### <a name="fast"> 2. Port Fast </a>

- PortFast tạo ra một hoạt động chuyển mạch hoặc trunk port để vào trạng thái chuyển tiếp cây spanning ngay lập tức, bỏ qua các trạng thái **listening** và **learning**.
- Bạn có thể sử dụng PortFast trên các cổng switch hoặc trunk được kết nối với một máy trạm, switch hoặc server duy nhất để cho phép các thiết bị kết nối với mạng ngay lập tức, thay vì chờ cổng chuyển từ trạng thái **listening** và **learning** sang trạng thái **forwarding** .


## Tham khảo :
(1). http://www.vnpro.org/forum/forum/ccnp®-và-ccdp®/switch-bcmsn/7514-các-loại-spanning-tree

(2). https://www.cisco.com/c/en/us/support/docs/lan-switching/spanning-tree-protocol/24248-147.html

(3). https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst4000/8-2glx/configuration/guide/stp_enha.html

(4). http://www.vnpro.vn/bpdu-guard-la-gi-loopguard-la-gi/
