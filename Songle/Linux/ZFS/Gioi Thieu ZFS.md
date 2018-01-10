# Tìm hiểu ZFS ( Z - Filesystem ) 


## Mục lục 

### [1. Định nghĩa](#dn)

### [2. Đặc điểm](#dd)

[2.1 ZFS Pooled Storage](#ps)

[2.2 Checksums and Self- Healing Data](#cs)

[2.3 Transactional Semantics](#ts)

[2.4 Unparalelled Scalability](#us)

[2.5 ZFS Snapshots](#sn)

[2.6 Simplified Administration](#sa)

### [3. Cơ chế](#cc)

### [4. Mở rộng](#mr)

[4.1 ZFS Intent Logs (ZIL)](#il)

[4.2 ZFS Cache Drives](#cd)

[4.3 ZFS File systems](#fs)

[4.4 ZFS Clones](#clo)

[4.5 ZFS Send and Recieve](#sar)

[4.6 ZFS Deduplication](#ded)

[4.7 ZFS Pool Scrubling](#psc)

[4.8 ZFS Compression](#com)

### [Tham khảo](#tk)

<hr>

### <a name="dn"> 1. Định nghĩa : </a>

- ZFS là một trình quản lí ổ đĩa mà các lvm kết hợp với công nghệ RAID với chức năng đảm bảo tính toàn vẹn cho dữ liệu. 
Mỗi block dữ liệu (block of data) được đọc/ghi bởi cơ chế ZFS dều được kiểm tra tính toàn vẹn và khôi phục lại nếu có 
lỗi xảy ra.

- ZFS có thể cài đặt trên hầu hết các hệ thống của Linux như Debain/Ubuntu và Red Hat/CentOS.
- Các thiết bị ZFS ảo ( ZFS Vitual Devices - ZFS VDEVs) : Một VDEV là một thiết bị siêu dữ liệu có thể đại diện cho một hoặc nhiều thiết bị . **ZFS hỗ trợ 7 loại VDEV :**
	
	- File ( Tệp được gán trước )
	- Thiết bị vật lý ( HDD, SSD, PCIe, NVME, etc )
	- Các bản sao ( Mirror) 
	- Phần mềm ZFS  như raid1 , raid2, raid3 cùng với các phân vùng parity dựa trên cơ chế RAID
	- Các phần thiết bị bổ trợ kịp thời ( Hot Spare ) dùng cho các phần mềm ZFS
	- Cache - Một thiết bị sử dụng cho cấp độ 2 ( ZFS L2ARC )
	- Log - thông số log ZFS ( ZFS ZIL)



### <a name="dd"> 2. Đặc điểm : </a>

#### <a name="ps">2.1 ZFS Pooled Storage </a>

- Quản lí bộ nhớ vật lí bằng hình thức storage pools .
- Gộp các thiết bị lưu trữ thành 1 hoặc nhiều pool . Trong Pool sẽ hiển thị các đặc tính vật lí của bộ nhớ ( vị trí thiết bị, dữ liệu còn trống.. )
- Tất cả các tập tin đều chia sẻ bộ nhớ trong pool với nhau. 
- Không cần xác định trước kích thước tập tin, các tập tin hệ thống giãn nở trong diện tích dung lượng của pool.
- Khi một thiết bị lưu trữ mới được thêm vào pool thì các file systems sẽ tự động sử dụng luôn không gian đĩa mới cho các tiến trình mà không 
	cần phải cấu hình bằng lệnh .

#### <a name="cs"> 2.2 Checksums and Self- Healing Data </a>

- Với ZFS, tất cả dữ liệu và siêu dữ liệu ( metadata ) được phê duyệt bằng thuật toán người dùng có thể chọn để kiểm tra.
	
- ZFS checksums được lưu trữ với hình thức tất cả lỗi sẽ được phát hiện và có thể khôi phục lại files một cách cẩn thận.
	+ Sử dụng cơ chế **scrub** để kiểm tra lỗi của các dataset bằng thuật toán **Fletcher 4** checksum.
	
	+ Tất cả hoạt động kiểm duyệt checksum và khôi phục dữ liệu được thực hiện ở lớp tệp hệ thống và trong suốt đối với các ứng dụng.
		
- ZFS cung cấp một cơ chế tự phục hồi dữ liệu. Nó lưu dữ liệu với rất nhiều bản sao khác nhau trong pool, khi một bản bị bad blocks, 
nó sẽ lấy dữ liệu chính xác từ một bản sao dự phòng khác và sửa chữa lại file bị hỏng.
	
#### <a name="ts"> 2.3 Transactional Semantics </a>

- ZFS là một dạng file hệ thống tệp giao dịch
	
- Sử dụng cơ chế COW ( copy on write ) để quản lí bằng cách sử dụng các bản sao của filesystem gốc.

		
	+ Dữ liệu gốc không bị ghi đè lên.
	
	+ Những sự thay đổi trên filesystem gốc sẽ được sao ra một bản mới và sửa trên bản  mới đó.
		
	+ Khi xảy ra sự cố như mất điện, hệ thống treo.. file system gốc sẽ không bị ảnh hưởng,
		chỉ mất đi các thông tin mới được chỉnh sửa trên bản sao của nó.
		
 ![Imgur](https://i.imgur.com/Ibs6UQr.png)
 
Ví dụ :
	
- Có một process A và file gốc là AS. từ A có các process con là A1, A2, A3.. 
Nếu không sử dụng COW, mỗi process con sẽ có riêng resource và sử dụng bộ nhớ và tài nguyên rất lớn. 
Với COW, tất cả các process con sinh ra đều trỏ vào resource nguồn là AS, 
sau này process nào cần sửa chữa dữ liệu thì nó sẽ copy AS ra một bản mới, và sửa chữa trên đó.  
 
		
		
#### <a name="us"> 2.4 Unparalelled Scalability </a>

- Khả năng mở rộng tuyệt vời.
	
- Hệ thống tập tin chính là 128-bit và có thể mở rộng đến 256-bit.
	
- Dữ liệu metadata được phân bổ động, không cần phải quy định trước các inodes để lưu dữ liệu và giới hạn bộ nhớ của tập tin.

- Thư mục có thể mở rộng đến 256 ( 256 nghìn tỉ ) mục, và số lượng các file là không giới hạn trong một file hệ thống. 
	
#### <a name="sn"> 2.5 ZFS Snapshots </a>

- Một snapshot là một bản sao chỉ có thể đọc của một system file hoặc volume.
	
- Được tạo ra nhanh và dễ dàng, ban đầu sẽ không tiêu tốn thêm tài nguyên nào của bộ nhớ.
	
Tuy nhiên khi dữ liệu trong thư mục gốc thay đổi, bản snapshot sẽ sử dụng thêm bộ  nhớ để lưu những thay đổi đó.
=> snapshot sẽ ngăn chặn việc dữ liệu bị giải phóng trở lại pool.

- Ví dụ : tạo snapshot cho file project trong pool "mypool" :

`$ sudo zfs snapshot -r mypool/projects@snap1`

+ Xem danh sách snapshot :

```
$ sudo zfs list -t snapshot
NAME                     USED  AVAIL  REFER  MOUNTPOINT
mypool/projects@snap1   8.80G      -  8.80G  -
```
+ Giả sử trường hợp xảy ra sự cố và mất file, ta khôi phục lại từ snapshot bằng cách :

```
$ rm -rf /mypool/projects
$ sudo zfs rollback mypool/projects@snap1
```
+ Xóa snapshot :

`$ Sudo zfs destroy mypool/projects@snap1`


	
#### <a name="sa"> 2.6 Simplified Administration </a>

- ZFS cung cấp một mô hình quản lí đơn giản hóa và khoa học :
		
	+ Dễ dàng tạo và quản lí hệ thống tập tin mà không yêu cầu nhiều lệnh hoặc file cấu hình.
		
	+ Dễ dàng tạo các quy tắc, quản lí các mountpoint.. bằng một lệnh duy nhất.
		
	+ Kiểm tra, thay thế các thiết bị mà không cần biết lệnh.
		
	+ Gửi và nhận các snapshots.
 
- ZFS quản lí hệ thống tập tin thông qua một mô hình phân cấp.
		
	+ Các file hệ thống là trung tâm của việc kiểm soát.
		
	+ Filesystems cũng như các file bình thường, không có dung lượng quá lớn vì vậy bạn có thể 
	tạo các filesystem cho mỗi user, project, workspace..
	
		
		
### <a name="cc"> 3. Cơ chế : </a>

**ZFS cung cấp một phương pháp đọc/ghi dữ liệu với nhiều mountpoints, dàn đều trên các ổ đĩa. Các ổ đĩa có thể được gộp lại 
thành các nhóm khác nhau để phù hợp với các cơ chế :**

*( VDEVs : Virtual Devices)*

- **Mirrored VDEVs** : Dữ liệu sẽ được sao lưu như nhau trên các ổ đĩa - tương tự như RAID 1. Đây chỉ đơn giản là một bản sao của một 
đĩa khác mỗi khi dữ liệu bị thay đổi.
	+ Số đĩa cần : >= 2
	=> Đảm bảo an toàn cho dữ liệu (  backup plan), nhưng cần nhiều dung lượng ổ đĩa.
	
`$ sudo zpool create example mirror /dev/sdb /dev/sdc`

- **Striped VDEVs** : Dữ liệu lưu trên tất cả các đĩa có sẵn cùng lúc - tương đương RAID 0. Trong một mảng có 2 ổ đĩa, một nửa dữ liệu
lưu trên đĩa 1, một nửa nằm trên đĩa 2.
	+ Số đĩa cần : >=2 đĩa
	=> Tốc độ cao nhưng không có phương án dự phòng. Một ổ hỏng là dữ liệu sẽ bị hỏng.
	
`$ sudo zpool create example /dev/sdb /dev/sdc /dev/sdd /dev/sde`

- **Striped Mirrored VDEVs** : Giống với hình thức RAID 10, tạo các cặp thiết bị sau đó đọc/ghi dữ liệu theo hình thức stripe lên bản sao.
Ví dụ, tạo một mirrored pool 2x2 theo hình thức striped :

`sudo zpool create example mirror /dev/sdb /dev/sdc mirror /dev/sdd /dev/sde`

hoặc

```
sudo zpool create example mirror /dev/sdb /dev/sdc
sudo zpool add example mirror /dev/sdd /dev/sde
```

	
- **RAID-Z** : Một bản nâng cấp từ RAID 5
	
	![Imgur](https://i.imgur.com/iQhLaYW.gif)
	
	+ Tránh được "Write hole" bằng cách sử dụng COW - Copy on write ( khi mất điện đột ngột lúc đang ghi dữ liệu, 
	sẽ có trường hợp không thể biết được data blocks hoặc parity blocks nào vừa được ghi trùng với dữ liệu đã được
	ghi trong các ổ stripe, và không xác định được là dữ liệu nào đã bị lỗi, đó gọi là hiện tượng "write hole" ).
	+ Số đĩa cần : >= 3 đĩa 
	=> Vẫn đảm bảo tốc độ đọc/ghi bằng stripe
	=> Khi một trong 3 ổ đĩa hỏng, dữ liệu vẫn được phục hồi. Trừ khi cả 3 ổ cùng hỏng.
	+ Nếu muốn thêm an toàn, có thể dùng RAID 6 ( RAID-Z2 trên cơ sở của ZFS) để có 2 lần dự phòng.

- **RAID-Z 2** và **RAID-Z 3** : Về cơ bản gống RAID-Z tuy nhiên sẽ có 2 - 3 ổ đĩa được dùng để dự phòng parity.
	
	![Imgur](https://i.imgur.com/EfR6V1S.gif)	
	
	- **RAID-Z 2** : 
	Số đĩa cần : >= 4
	+ **RAID-Z 3** :
	Số đĩa cần : >= 5
	=> Sử dụng trong môi trường có dữ liệu quan trọng.
	
- **Nested RAIDZ** : Giống với hình thức RAID50, RAID60, Striped RAIDZ nhưng cho hiệu quả cao hơn RAIDZ với giá thành thấp hơn. 
Ví dụ, 2 X RAIDZ :

```
$ sudo zpool create example raidz /dev/sdb /dev/sdc /dev/sdd /dev/sde
$ sudo zpool add example raidz /dev/sdf /dev/sdg /dev/sdh /dev/sdi
```


### <a name="mr"> 4. Mở rộng : </a>

#### <a name="il"> 4.1 ZFS Intent Logs (ZIL): </a>

![Imgur](https://i.imgur.com/YeApSv4.png)

- ZIL có thể được thêm vào ZFS pool để tăng tốc độ ghi cho các cơ chế ZFS RAID.

- ZIL thực chất là một cơ chế lưu lại các dữ liệu sẽ được đưa vào bộ nhớ ổ cứng , sau đó dữ liệu ấy khi hệ thống xảy ra sự cố, dữ liệu trong RAM bị mất do mất điện, thì ZFS sẽ truy xuất các dữ liệu đang lưu vào ZIL nhằm phục hồi lại những file đang nằm trong RAM.
Tham khảo các hình thức của ZIL: https://pthree.org/2013/04/19/zfs-administration-appendix-a-visualizing-the-zfs-intent-log/

- Ví dụ : Tạo phân vùng ổ SSDs cho pool "mypool" : 

`$ sudo zpool add mypool log /dev/sdg -f`

#### <a name="cd"> 4.2 ZFS Cache Drives </a>

- Bộ nhớ cache cung cấp một lớp bộ nhớ đệm nữa giữa ổ đĩa và dữ liệu. Nó rất hữu dụng cho việc cải thiện tốc độ đọc dữ liệu tĩnh( dữ liệ fixed cứng và không thể extend).

- Ví dụ, để thêm bộ nhớ cache với ổ đĩa sử dụng là sdd ta dùng lệnh :

`$ sudo zpool add mypool cache /dev/sdh`

#### <a name="fs"> 4.3 ZFS File systems </a> 

- ZFS cho phép tạo mỗi pool tối đa là 2^64 file systems. 
- Ví dụ : tạo 2 file systems trong pool "mypool":

```
sudo zfs create mypool/tmp
sudo zfs create mypool/projects
```

+ xóa file:
`sudo zfs destroy mypool/tmp`

- Mỗi ZFS file systems có thể điều chỉnh các đặc tính, ví dụ điều chinhr dung lượng lớn nhất của file là 10GB :
` sudo zfs set quota=10G mypool/projects`

+  hoặc đặt chế độ nén file :

`sudo zfs set compression=on mypool/projects`

#### <a name="clo"> 4.4 ZFS Clones </a> 

- Một ZFS clone là một bản ghi có thể ghi được của một hệ thống tập tin với nội dung ban đầu của clone được giống hệt với hệ thống tập tin gốc.

- Một **ZFS clone** chỉ có thể được tạo ra từ **ZFS snapshot** và **snapshot** không thể bị xóa cho đến khi các **clone** được tạo ra từ nó cũng bị phá hủy.

- Ví dụ : để clone file projects từ pool "mypool", ta tạo **snapshot** cho nó sau đó **clone** :

```
$ sudo zfs snapshot -r mypool/projects@snap1
$ sudo zfs clone mypool/projects@snap1 mypool/projects-clone
```

#### <a name="sar"> 4.5 ZFS Send and Receive

- ZFS send sẽ gửi một snapshot của filesystem tới một máy khác. 

- ZFS receive nhận file và tạo ra một bản sao của snapshot đó thành ZFS filesystem ở máy nó.

=> Thuận tiện cho việc backsup hoặc gửi những bản sao của filesystem từ máy này qua máy kia

- Ví dụ : tạo snapshot và lưu nó thành một zfs file :

```
$ sudo zfs snapshot -r mypool/projects@snap2
$ sudo zfs send mypool/projects@snap2 > ~/projects-snap.zfs
```
+  Nhận nó lại :

`
sudo zfs receive -F mypool/projects-copy < ~/projects-snap.zfs
`

#### <a name="ded"> 4.6 ZFS Deduplication </a>

- ZFS dedup sẽ loại bỏ các khối giống hệt với các khối hiện tại và thay vào đó sẽ sử dụng một tham chiếu đến khối hiện tại.
- Điều này tiết kiệm không gian trên thiết bị nhưng có chi phí lớn cho bộ nhớ.
- Bảng dedup trong bộ nhớ sử dụng ~ 320 byte cho mỗi block. Các bảng lớn hơn là kích thước, hiệu suất viết chậm hơn sẽ trở thành
- Ví dụ : Khởi chạy tiến trình dedup ở  **mypool/projects** :

` $ sudo zfs set dedup=on mypool/projects`

#### <a name="psc"> 4.7  ZFS Pool Scrubling </a>

- Để kiểm tra tính toàn vẹn dữ liệu trong pool. Nó sẽ kiểm tra các block dữ liệu bằng các thuật toán checksum, nếu block nào bị lỗi nó sẽ sửa chữa lại block đó bằng cách lấy 1 block mirror ở ổ đĩa khác và khôi phục lại block gốc bị lỗi.

` $ sudo zpool scrub mypool`

+ Kiểm tra tính trạng thái pool :

` $ sudo zpool status -v mypool`


#### <a name="com"> 4.8 ZFS Compression ( nén file ) </a>

- System Files có thể nén một cách tự động
- Hình thức nén file mặc định là **lz4** ( link 8 tham khảo ) . lz4 nhanh hơn đáng kể so với các tùy chọn khác trong khi vẫn hoạt động tốt; lz4 là sự lựa chọn an toàn nhất.
- Ví dụ :
+ Thay đổi level nén :

` $ sudo zfs set compression=gzip-9 mypool `

+ Đổi hình thức nén :

` $sudo zfs set compression=lz4 mypool `

+ Kiểm tra cấp độ nén :

`sudo zfs get compressratio`



## <a name="tk"> Tham khảo : </a>

(1) https://viblo.asia/p/tan-man-ve-copy-on-write-WrJvYKXBeVO
	
(2) http://aptech.fpt.edu.vn/chitiet.php?id=198
	
(3) http://www.geekyprojects.com/storage/what-is-raid-levels-and-types/

(4) https://docs.oracle.com/cd/E23824_01/html/821-1448/gbciq.html

(5) https://wiki.ubuntu.com/Kernel/Reference/ZFS

(6) https://pthree.org/2013/04/19/zfs-administration-appendix-a-visualizing-the-zfs-intent-log/

(7) https://constantin.glez.de/2011/07/27/zfs-to-dedupe-or-not-dedupe/

(8) https://github.com/lz4/lz4
