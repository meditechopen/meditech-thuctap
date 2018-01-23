# Tổng quan về VLANs

## Phụ lục :
### [1. Định nghĩa](#dn)
### [2. Đặc điểm](#dd)
### [3. Cơ chế hoạt động](#cc)
#### [3.1 Phương thức tạo VLANs](#met)
#### [3.2 Các loại VLANs](#type)
#### [3.3 Hình thức truy cập](#way)
		
<hr>
		
### <a name="dn"> 1. Định nghĩa </a>

VLANs là các hệ thống mạng con nằm trên cùng 1 switch được chia ra từ một mạng gốc. Hiểu nôm na VLANs là một tập hợp các cổng của switch nằm trong cùng một broadcast domain. 

- Các cổng có thể được nhóm trên từng Vlan khác nhau trên từng SW và trên nhiều SW. Từ đó các máy trạm và máy chủ được nhóm vào một nhóm logic.
	
- Ở mỗi VLANs lại có thiết lập khác nhau tùy vào yêu cầu và mục đích sử dụng.
	
#### Ưu điểm: 

- Tiết kiệm băng thông : Vlan chia mạng LAN thành nhiều segment nhỏ, mỗi đoạn đó là một vùng quảng bá ( Broadcast domain), khi có gói tin broadcast , nó chỉ được truyền trong VLan tương ứng => tiết kiệm băng thông.
- Tăng tính bảo mật : Do các thiết bị ở các Vlans khác nhau không thể truy cập vào nhau nên thông tin ở các VLANs sẽ được bảo mật tốt hơn.
- Giảm giá thành : tiết kiệm các khoản nâng cấp hệ thống đường dây và băng thông bằng cách chia nhỏ hệ thống mạng, mỗi đường dây chỉ tải 1 đường subnet.
- Giảm tị lệ xảy ra bão Broadcast : chia thành các mạng con giúp tránh tình trạng 1 frame broadcast truyền tải qua lại giữa các switch gây bão broadcast. 
- Nâng cao chất lượng công việc của nhân viên : Các nhân viên ở các phòng ban khác nhau sẽ dùng mạng ở vlan khác nhau, tăng tính truy cập thuận tiện hơn .
- Dễ dàng thay đổi : thêm , bớt, sửa , xóa..


### <a name="dd"> 2. Đặc điểm </a>

#### Vlan ID

	**Normal Range ID** : 
	
		- Range IDs : "1- 1005"
		- "1002-1005" sử dụng cho Token Ring và FDDI Vlans
		- Vlan 1, 1002-1005 được tự động tạo và không thể xóa
		- Lưu trữ trong bộ nhớ vlan.dat file trong bộ nhớ flash của Switch
		- VLAN trunking Protocol ( VTP ) - quản lí file cấu hình giữa các Switches chỉ có thể lưu VLan Normal range ID và lưu trong VLSN database line.
	
	**Extended Range ID** :
	
		- Range ID : 1006-4094
		- Sử dụng cho nhà cung cấp dịch vụ
		- Có ít tùy chỉnh chức năng hơn Normal range
		- Lưu trong file cấu hình.
		- VTP không học dãy địa chỉ Vlan này.
		
### <a name="cc"> 3. Phương thức hoạt động </a>
#### <a name="met"> 3.1 Phương thức tạo VLANs </a>

##### a. Static VLANs :

- Gán bằng tay các cổng cho các VLAN có trong hệ thống mạng, cấu hình luôn giữ nguyên cho đến khi người quản trị thay đổi.
- Dùng cho mạng mà sự di rời vị trí của người dùng được kiểm soát chặt chẽ.
- Cài đặt và quản lí dễ dàng bằng tay
- Bảo mật cao
 
##### b. Dynamic VLANs :


- Các cổng của Switch được gán tự động vào các VLANs.
- VLANs động được cấu hình và gán bởi một server có tên là VMPS ( VLAN Membership Policy Server ) dựa trên địa chỉ MAC của thiết bị kết nối vào cổng.
- Mỗi thiết bị có một địa chỉ MAC, VMPS sẽ lưu địa chỉ MAC và VLAN đã gán cho địa chỉ đó vào. 
=> Tiện lợi với các người dùng hay phải di chuyển trong một hệ thống mạng ( từ sw này sang sw khác ). VMPS sẽ tự động gán VLAN cũ cho cổng mới mà người dùng mới cắm vào.
=> Người quản trị dễ dàng quản lí và cấu hình VLANs.

#### <a name="type"> 3.2 Các loại VLANs </a>

##### a. Default VLAN :

- VLAN mặc định ban đầu với tất cả cổng giao tiếp trên thiết bị chuyển mạch.
- VLAN 1 có thể hiểu là Default Vlan. Data Vlan, Native Vlan, Management Vlan đều là thành phần con của Default Vlan

##### b. Data VLAN :

- Chứa các thông tin về tài khoản người dùng thành từng nhóm dựa trên thuộc tính, đặc thù công việc hay vị trí vật lý.
- vd : phòng Marketing sử dụng Vlan 10, phòng Giám sát sử dụng Vlan quản trị.

##### c. Native VLAN :

Dùng để cấu hình Trunking cho các thiết bị không tương thích với nhau.
- Các Frame đi qua đường Trunking đều được gắn tag của giao thức 802.1Q hoặc ISL, trừ frame của VLAN 1 .
- Native Vlan thường được ngầm định là VLAN1.
Cấu hình Native VLAN :

```
Switch#config terminal  
Switch(config)#interface fastethernet slot/port_number 
Switch(config-if)#switchport trunk native vlan vlan-id
```

##### d. Management VLAN :

- Người quản trị dùng để giám sát các thiết bị từ xa bằng telnet.
      - Gán 1 địa chỉ cho người quản trị ở trong VLAN để quản trị từ xa.      
      - Được cấp một số quyền quản trị 
      - Khi mạng có vấn đề : hội tụ STP , Broadcast storm , Management VLAN vẫn cho phép nhà quản trị truy cập vào để sửa lỗi.
	  
	  

##### e. Voice VLAN :

- Một công nghệ của Cisco, Voice VLAN được cấu hình riêng biệt và tách rời khỏi các hệ thống khác ( Voice Traffic ).
- Dùng cho hệ thống điện thoại, dữ liệu đi từ client qa Cisco IP Phone ( máy điện thoại )  bằng một VLan, sau đó sẽ đươc chuyển tiếp tới thiết bị đích bằng một VLAN khác ( thường là data VLAN )
 
		Đảm bảo băng thông cho chất lượng cuộc gọi
		+ Truyền dữ liệu được ưu tiên bởi dùng riêng 1 đường mạng.
		+ Có thể định tuyến xung qua một hệ thống mạng quá tải.
		+ Thời gian delay rất ngắn ( <150mms)
		
#### <a name="way"> 3.3 Hình thức truy cập </a>

##### a. Acess Links :

- Sử dụng cho mạng nội vùng
- Các thiết bị truy cập vào Access Link sẽ nằm trong Native VLANs( Vlan nội vùng )
- Chúng không cần quan tâm tới các thành viên khác trong cùng Broadcast domain
- Khi frame từ nơi khác qua đường Trunking đến Switch, nó sẽ loại bỏ các thông tin VLAN trên frame đó rồi dựa trên địa chỉ MAC mà chuyển tiếp frame đến máy đích trong mạng nội vùng của nó.


##### b. Trunk Links :

- Kết nối và truyền dữ liệu giữa các Switches, Routers hoặc Servers .
   + Trunk links được sử dụng để vận chuyển VLANs giữa các thiết bị ( đường đi ra ngoài mạng của các mạng nội vùng ).
- Hỗ trợ Fast/ Gigabit Ethernet.


##### c. Frame Tagging :

- Sử dụng cho frame được vận chuyển tới các mạng nội vùng bằng đường Trunk. 
- VLAN tag sẽ bị xóa khỏi frame trước khi nó ra khỏi đường trunk. 
- Mỗi Switch nhận được frame sẽ phải xác định VLAN ID của frame đó, và kiểm tra trong bảng địa chỉ MAC của máy đích để chuyển tới.
   + Máy đích nhận frame sẽ không biết được các thông tin về VLAN của nó.
- Nếu trong Switch đó còn một đường Trunk link đi ra mạng khác, nó sẽ chuyển tiếp frame đó ra cổng trunk.






