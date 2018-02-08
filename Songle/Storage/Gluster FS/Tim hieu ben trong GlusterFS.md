# Tìm hiểu GlusterFS

## 1. FUSE

GlusterFS là một userspace filesystem (tham khảo: http://www.linfo.org/kernel_space.html). 

Là một userspace filesystem , để  giao tiếp với kernel VFS, GlusterFS phải sử dụng FUSE (File system in userspace).
FUSE được phát triển với mục đích tạo môi trường cho việc thực thi các filesystem trên userspace.

- FUSE là một mô đun kernel hỗ trợ cho việc tương tác giữa kernel VFS với những ứng dụng của 
người dùng thường và nó có một API mà có thể truy cập từ userspace. Sử dụng API đó, mọi kiểu filesystem 
có thể được ghi bằng hầu hết các ngôn ngữ mà bạn mong muốn bởi có một mối liên kết mật thiết 
giữa FUSE và các ngôn ngữ khác.

![Imgur](https://i.imgur.com/jkAT0Kf.png)

*Mô hình cấu trúc của FUSE*

Hình trên thể hiện một filesystem "hello world" được biên dịch để tạo một dãy nhị phân "hello". Nó 
được thực thi với một filesystem mount point `/tmp/fuse`. Sau đó người dùng sử dụng một lệnh 
`ls -l` trên mount point `/tmp/fuse`. Lệnh này sẽ đi đến VFS qua thư viện glibc và vì `/tmp/fuse` tương tác 
với FUSE base filesystem cho nên VFS sẽ chuyển lệnh đó đến FUSE mô đun. FUSE kernel mô đun sẽ 
liên lạc với filesystem binary hiện tại "hello" sau khi đi qua thư viện glibc và thư viện FUSE trong 
userspace(libuse). Kết quả trả về là "hello" trên thư mục đó vởi lệnh ls -l.

Sự giao tiếp giữa mô đun FUSE kernel và thư viện FUSE (libuse) thông qua một file descriptor đặc biệt cái mà 
được tạo ra bởi việc mở `/dev/fuse`. File đó có thể được mở nhiều lần và nó được chuyển đến 
mount syscall để đồng bộ với descriptor của mounted filesystem.

*file descriptor: hiểu nôm na khi bạn mở 1 file trên os, os sẽ tạo một entry để thể hiện file đó và lưu thông 
tin về nó. Nếu bạn mở 100 files thì sẽ có 100 entries trên OS, những entries đó được thể hiện bằng các số nguyên 
như 100, 101, 102..., nhưng entry number ấy gọi là file descriptor.*



## Translator

- Translator chuyển đổi requests từ những người dùng thành requests đến bộ phận lưu trữ.
	
	- Có 3 hình thức chuyển đổi : one to one, one to many, one to zero ( ví dụ: caching).
	
	![Imgur](https://i.imgur.com/kGOfFip.png)
	
- Translator có thể thay đổi các yêu cầu trên đường đi qua:

	- Chuyển đổi một kiểu yêu cầu thành một kiểu khác ( trong lúc các requests đi qua lại giữa các translators)
	nó có thể bị sửa đường dẫn, flags, và có thể là cả dữ liệu. ( ví dụ: việc mã hóa).
	
	- Translator có thể ngăn chặn hoặc block hoặc sinh ra các requests. ( ví dụ access control ,pre-fetch).

**Translator hoạt động thế nào?**

- Chia sẻ Objects.
- Tự động được nạp vào dựa trên 'volfile'.
- Các quy ước cho việc xác nhận/chuyển lựa chọn.
- Cấu hình của các translators (từ GlusterFS 3.1) được quản lý trong gluster bằng cli(command line interface), vì thế 
bạn không cần phải nắm được việc mô tả các translators với nhau theo thứ tự thế nào.

### Các loại Translator

|Translator type|Chức năng|
|---------------|---------|
|Storage|Translator thấp cấp nhất, thực hiện tác vụ lưu trữ và truy cập dữ liệu từ local file system|
|Debug|Cung cấp giao diện và phân tích lỗi để gỡ lỗi|
|Cluster|Xử lý việc phân chia và sao lưu dữ liệu vì nó liên quan đến việc ghi và đọc dữ liệu từ các node, brick|
|Encryption|Translator mở rộng cho hoạt động mã hóa/giải mã dữ liệu của dữ liệu đã được lưu trữ|
|Protocol|Translator mở rộng cho việc giao tiếp giữa client/server|
|Performance|Tùy chỉnh translators để phù hợp với workload và I/O|
|Bingdings|Bổ sung khả năng mở rộng, ví dụ Python interface viết bởi Jeff Darcy để mở rộng API tương tác với GlusterFS|
|System|Translator truy cập hệ thống, ví dụ việc giao tiếp với trình quản lý truy cập file system|
|Scheduler|I/O schedulers xác định cách để phân phối việc ghi dữ liệu trong hệ thống cluster|
|Features| Bổ sung tính năng như Qoutas, Filters, Locks, ...|


**Mô hình phân cấp của translators trong vol files:**

![Imgur](https://i.imgur.com/fXuHLHm.png)

Tất cả translators đều móc nối với nhau để thực hiện các chức năng được gọi là biểu đồ (graph). Phần 
bên trái của translators thể hiện **Client-stack** còn bên phải là **Server-stack**.

**GlusterFS translators có thể được chia nhỏ thành nhiều category, nhưng 2 category quan trọng nhất là
 Cluster và Performance :**

1. **Cluster Translators:**

- DHT(Distributed Hash Table).
- AFR(Automatic File Replication).

2. **Performance translators:**

- io-cache
- io-threads 
- md-cache
- O-B (open behind)
- QR (quick read)
- r-a (read-ahead)
- w-b (write-behind)

Một số **Translators nổi bật** gồm:

- changelog
- locks - GlusterFS có locks translator cung cấp các cơ chế khóa như `inodeld`, `entrylk` được sử dụng bởi afr để 
đạt được sự đồng bộ trên các tập tin hoặc thư mục có xung đột với nhau.
- marker
- qouta


**Debug Translators**:

- trace - theo dõi các bản ghi lỗi tạo ra trong quá trình truyền thông giữa các translators.
- io-stats

#### DHT Translator 

##### DHT là gì?

DHT (Distributed Hash Table) là một thành phần cực kỳ quan trọng đối với GlusterFS về mặt kết hợp khả năng lưu trữ và 
hiệu suất của hệ thống trong môi trường multiple servers. Nó đảm nhận nhiệm vụ đặt các file vào đúng subvolumes, không 
giống như cơ chế replication hay striping. DHT có chức năng là routing ( dẫn đường) chứ không phải là chia file hay sao chép.

##### DHT hoạt động thế nào?

Phương pháp cơ bản được sử dụng trong DHT là consistent hashing (*hàm băm ổn định :  là hàm băm mà việc thêm hoặc bớt 
một khối dữ liệu (slot) không làm thay đổi đáng kể ánh xạ từ khóa tới các khối dữ liệu*). Mỗi 
subvolume (brick) được gán cho một khoảng 32-bit hash space (không gian gán), bao phủ toàn bộ subvolume mà không có lỗ hổng hay 
phần nào bị đè lên. Sau đó mỗi file được gán một giá trị trên space đó bằng thuật toán hashing tên file đó.
Một brick sẽ được gán chính xác một khoảng space bao gồm giá trị hash của file, vì thế mà file đó đã được quy định 
vị trí lưu trên brick đó. Tuy nhiên có nhiều trường hợp có thể xảy ra như việc các bricks thay đổi hoặc một cái 
gần đầy, nhưng DHT đã có những phương pháp để khắc phục chúng.

Khi bạn sử dụng hàm `open()`, distribute translator sẽ gửi đi một mẩu thông tin vào brick để tìm file của bạn theo tên. Để 
xác định file đó ở đâu, translator chuyển đổi tên đó thành 1 đoạn mã bằng hashing algorithm, sau khi có mã rồi nó sẽ kiểm tra trong bảng DHT 
và tìm đến vị trí của file.

**Một số quan sát về việc gán mã của DHT:**

1. Việc gán các hash range cho các brick được xác định bởi các thuộc tính mở rộng lưu trên các đường dẫn đó, vì thế distribution chính là 
việc cụ thể hóa đường dẫn. 

2. Consistent hashing thường được hiểu là hashing quanh một vòng tròn, nhưng trong GlusterFS thì nó lại theo kiểu 
tuyến tính hơn (linear). 
![Imgur](https://i.imgur.com/FdrUh3l.jpg)

3. Nếu một brick bị mất, sẽ xuất hiện 1 hole trên hash space. Trường hợp xấu hơn, nếu hash ranges được gán lại trong khi một brick đang 
offline thì một số range mới có thể đè lên range đã lưu trên brick đó, tạo ra một số khó khăn cho việc tìm file sau này.

##### AFR (automatic file replication) Translator

AFR translator trong GlusterFS sử dụng các thông số của đặc tính mở rộng (extended attributes) để theo dõi hoạt động của file. Nó đảm 
nhận nhiệm vụ cho việc sao lưu dữ liệu trên các bricks.

**Nhiệm vụ của AFR**

1.  Duy trì việc sao lưu dữ liệu  sao cho dữ liệu trên mỗi brick trong volume đều như nhau.
2. Cung cấp giải pháp phục hồi dữ liệu trong trường hợp lỗi xảy ra miễn sao vẫn còn 1 brick chứa dữ liệu chuẩn.
3. Cung cấp dữ liệu chính xác nguyên bản cho hoạt động `read/stat/readdir`.

**Geo-Replication**

Geo-Replication cung cấp việc đồng bộ dữ liệu tập trung xuyên qua các khu vực địa lý. Nó làm việc chủ yếu trong mạng WAN và 
được dùng cho mục đích dự phòng toàn bộ dữ liệu phục vụ việc phục hồi sau thảm họa.

Geo-replication sử dụng mô hình master-slave, có nghĩa rằng việc sao lưu sẽ diễn ra giữa **Master** - GlusterFS volume và **Slave** - có thể là 
local directory hoặc một GlusterFS volume.(Slave được truy cập bởi SSH tunnel).

Geo-replication cung cấp cơ chế sao lưu trong nhiều mô hình mạng : LAN, WAN, và lớn hơn nữa.

**Geo-Replication trong mạng LAN** :

Bạn có thể cấu hình Geo-Replication để sao lưu dữ liệu qua mạng LAN:

![Imgur](https://i.imgur.com/ZmIH35o.png)

**Geo-Replication trong mạng WAN** :

![Imgur](https://i.imgur.com/QZyOabi.png)

**Geo-Replication qua internet**

![Imgur](https://i.imgur.com/GO5NhyU.png)

**Multi-site cascading Geo-Replication**

![Imgur](https://i.imgur.com/HfPlEbx.png)

Có 2 lĩnh vực chính khi đồng bộ sao lưu dữ liệu:

1. **Change detection** ( xác định thay đổi) : Việc này bao gồm thông tin chi tiết hoạt động của file. Có 2 phương pháp để đồng bộ 
nhưng thay đổi đó:

- Changelogs - Changelogs là một translator ghi lại những thông tin quan trọng phòng khi có sự cố xảy ra. Những 
thay đổi có thể được ghi bằng định dạng nhị phân hoặc ASCII. Có 3 loại và mỗi loại lại được ghi dữ liệu vào 1 file changelog riêng :

	**Entry** -  create(), mkdir(), mknod(), symlink(), link(), rename(), unlink(), rmdir()
	
	**Data** - write(), truncate(), ftruncate()
	
	**Meta** - setattr(), fsetattr(), etxattr(), fsetxattr(), removexattr(), fremovexattr()
	
Để ghi lại các hoạt động và các thực thể đã trải qua, một loại nhận dạng được sử dụng. Bình thường 
thực thể mà hoạt động được thực hiện trên nó sẽ được xác định bởi tên đường dẫn (pathname), nhưng ta chọn sử dụng 
định danh tệp tin nội bộ GlusterFS interal file identifier (GFID). Do đó, định dạng của bản ghi cho ba loại hoạt động có thể tóm tắt như sau:
	
Entry - GFID + FOP + MODE + UID + GID + PARGFID/BNAME [PARGFID/BNAME]

Meta - GFID of the file

Data - GFID of the file


GFID tương tự như các inodes. Dữ liệu và Meta fops ghi lại GFID của thực thể mà thao tác đã được thực hiện, do đó ghi lại sự thay đổi 
data/metadata trên inode. Entry fops ghi lại ít nhất một bộ sáu hoặc 7 bản ghi (phụ thuộc vào loại thao tác), mà đủ để xác định loại hoạt động mà 
thực thể vừa trải qua. Thông thường , bản ghi này bao gồm GFID của thực thể, loại hoạt động của tệp (là một số nguyên ) và GFID cha, tên cơ bản.

Changelog file sau đó được xem qua sau một khoảng thời gian cụ thể. Sau đó người quản trị sẽ chuyển đổi nó 
sang định dạng có thể hiểu và đọc được, giữ một bản sao riêng của changelog. Thư viện sau đó sẽ dùng những logs đó và phục vụ các yêu cầu của ứng dụng.

ii. Trình dịch vụ Xsync - Marker duy trì một thuộc tính mở rộng "xtime" cho mỗi tệp và thư mục. Bất cứ khi nào xảy ra bất kỳ cập nhật nó sẽ cập nhật các 
thuộc tính xtime của tập tin đó và tất cả các tổ tiên của nó. Vì vậy, sự thay đổi được truyền từ node 
(nơi thay đổi đã xảy ra) bằng mọi cách đến root.

![Imgur](https://i.imgur.com/9X7MZ43.png)

Tham khảo cấu trúc thư mục ở trên, ở thời điểm T1 master và slave đã đồng bộ lẫn nhau.

![Imgur](https://i.imgur.com/Bb0rtcX.jpg)

Ở thời điểm T2, một file file2 mới được tạo. Điều này sẽ kích hoạt dấu xtime (nơi xtime là timestamp hiện tại) từ File2 đến thư mục gốc, tức là 
xtime của File2, Dir3, Dir1 và cuối cùng là Dir0 tất cả sẽ được cập nhật.

Geo - replication daemon thu thập thông tin về hệ thống tập tin dựa trên điều kiện xtime (master)> xtime (slave). Do đó, trong ví dụ của chúng ta, 
nó sẽ chỉ thu thập dữ liệu phần bên trái của cấu trúc thư mục vì phần bên phải của cấu trúc thư mục vẫn có timestamp bằng nhau. 
Mặc dù thuật toán thu thập thông tin nhanh nhưng ta vẫn cần thu thập thông tin một phần tốt của cấu trúc thư mục.

2. **Replication** - ta sử dụng rsync để nhân rộng dữ liệu. Rsync là một tiện ích bên ngoài mà sẽ tính toán diff 
của hai tập tin và gửi sự khác biệt này từ nguồn để đồng bộ.


### Tổng thể hoạt động của GlusterFS 

Khi GlusterFS được cài đặt trên node server, một tiến trình nhị phân ẩn (daemon binary) của gluster management gọi là `glusterd` được tạo. 
Daemon này nên được chạy trên tất cả các node tham gia trong cluster. Sau khi khởi động `clusterd`, một trusted server pool (TSP) có thể 
được tạo ra gòm tất cả các server nodes (TSP có thể chỉ chứa 1 node riêng lẻ). Bây giờ các brick 
có thể được tạo như là export directories trong các server đó. Bất kỳ số brick nào từ TSP này có thể được nối với nhau để tạo thành một volume.

Khi một volume được tạo, một tiến trình glusterd khởi động trong mỗi brick tham gia vào nó. Cùng với đó, 
các file cấu hình (vol files) sẽ được xuất ra trong thư mục `/var/lib/glusterd/vols/`. Sẽ có những file cấu hình tương tác với mỗi brick trong volume.
Chúng sẽ chứa tất cả thông tin chi tiết về brick đó. Configuration files được yêu cầu bởi một tiến trình của client sẽ được tạo ra. Bây giờ filesystem của ta 
đã sẵn sàng để sử dụng. Ta có thể mount volume đó trên máy client rất dễ dàng và sử dụng nó như một bộ phận lưu trữ local:

`mount.glusterfs <IP or hostname>:<volume_name> <mount_point>`

IP hoặc hostname có thể là của bất cứ node nào trong TSP.

Khi ta mount volume trên client, tiến trình glusterfs trên client sẽ giao tiếp với tiến trình glusterd trên server.
Server glusterd gửi một file cấu hình (vol file) gồm danh sách các translators của client và những file khác sẽ chứa các thông tin của mỗi brick trong volume
với sự giúp đỡ của tiến trình glusterfs trên client bây giờ có thể liên lạc trực tiếp với các tiến trình glusterfs trên mỗi brick.
Việc cài đặt đã hoàn thành và bây giờ volume đã sẵn sàng để client sử dụng.

![Imgur](https://i.imgur.com/PTI9pC1.png)

Khi có yêu cầu từ hệ thống (file operation hay Fop) được tạo bởi client trên thư mục mount, VFS (xác định loại của filesystem là glusterfs) sẽ gửi 
yêu cầu đến FUSE kernel module. FUSE kernel module sẽ có trách nhiệm gửi nó đến GlusterFS trong 
userspace của client node qua `/dev/fuse`. GlusterFS hoạt động trên client gồm một bộ các translator gọi là client 
translators, chúng sẽ xác định các file cấu hình (vol file) được gửi từ tiến trình glusterd của Storage server. 
Translator đầu tiên là FUSE, nó chứa FUSE library (libfuse). Mỗi translator có những hàm tương thích với mỗi tác vụ hoặc fop được hỗ trợ bởi glusterfs.
Yêu cầu sẽ gọi tới các hàm đó trên các translators. 
Các translators chính trên client gồm:
	- FUSE translator
	- DHT translator - ánh xạ các yêu cầu đến đúng brick chứa file hoặc directory được yêu cầu.
	- AFR translator - nhận yêu cầu từ translator trước đó và nếu loại volume là replicate, nó sẽ nhân đôi yêu cầu đó và chuyển 
	nó tới Prototcol translator của client.
	- Prototcol Client translator - là translator cuối cùng trong client translator stack. Nó được chia thành nhiều threads nhỏ hơn, mỗi thread cho một brick trong volume.
	Nó sẽ giao tiếp trực tiếp với glusterd của mỗi brick.

Trong storage server node, yêu cầu lại đi qua một loạt các translators trên server, sau đây là những cái chính :

	- Protocol server translator
	- POSIX translator.
	
Yêu cầu cuối cùng sẽ đến VFS và sau đó sẽ liên lạc với hệ thống tập tin gốc. Phản hồi sẽ lặp lại cùng một đường dẫn.

### Tham khảo

1. http://docs.gluster.org/en/latest/Quick-Start-Guide/Architecture/
2. https://vi.wikipedia.org/wiki/H%C3%A0m_b%C4%83m_%E1%BB%95n_%C4%91%E1%BB%8Bnh
3. https://www.slideshare.net/GlusterCommunity/glusterfs-architectur-roadmap-linuxcon-eu-2013
4. https://vngeek.com/cong-nghe/2017/06/glusterfs-la-gi/
5. https://www.itzgeek.com/how-tos/linux/centos-how-tos/install-and-configure-glusterfs-on-centos-7-rhel-7.html
6. https://github.com/libfuse/libfuse
