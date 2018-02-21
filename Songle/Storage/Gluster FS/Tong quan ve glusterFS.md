# GlusteFS

## GlusteFS là gì?

GlusterFS là một hệ thống tập tin mạng có thể mở rộng. Sử dụng phần cứng thông thường, 
bạn có thể tạo ra các giải pháp lưu trữ lớn, phân tán cho phương tiện truyền thông, 
phân tích dữ liệu và các công việc đòi hỏi nhiều dữ liệu và băng thông khác. 
GlusterFS là phần mềm miễn phí và mã nguồn mở.

### Các thành phần trong hệ thống lưu trữ GlusteFS

- **Node** : các máy chủ vật lý hoặc máy chủ ảo ( Virtual Private Server) được cài đặt GlusterFS.
- **Brick** : Trong tiếng Việt Brick có nghĩa là viên gạch, bác bạn có thể hiểu để xây nên một cái nhà, 
cần những viên gạch để ghép lại gắn kết bằng xi măng. Thì Brick trong GlusterFS cũng vậy, 
là một đơn vị lưu trữ cơ bản, bản chất nó là một thư mục được Export ra từ một máy chủ nào đó.

	- Ví dụ đây là một **Brick**: server1.vngeek.com:/folder/brick/
	Các bạn có thể hiểu server1.songle.com chính là máy chủ được cài đặt GlusterFS, 
	và thư mục lưu trữ là /folder/brick/. Sau này hệ thống GlusterFS sẽ 
	lưu trữ những tập tin tại thư mục này trên server này khi nó tham gia vào hệ thống

- **Volume** : Gộp các Brick lại, bằng một cách nào đó theo bạn muốn (Giống như Raid trên các ổ cứng). 
Volume đóng vai trò quản lý các Brick được thêm vào nó. Và tất nhiên sau này bạn sẽ làm việc với Volume, 
bạn có thể coi nó là thư mục đích để lưu trữ dữ liệu vào đó.

- **Client** : Client là máy khách, các máy tính kết nối với hệ thống GlusterFS và thực hiện lưu trữ hoặc truy cập đến dữ liệu của GlusterFS. 
Khi bạn mount một Volume nào đó và sử dụng nó để lưu trữ, thì bạn là một Client rồi đó.

### Ưu điểm của GlusteFS

- **Khả năng mở rộng** : GluserFS có khả năng tương thích linh hoạt với mức độ tăng trưởng của dữ liệu, 
có khả năng lưu trữ đến hàng nghìn Petabyte và lớn hơn.

- **Tính linh hoạt** :  GlusterFS có thể sử dụng nhiều định dạng lưu trữ hệ thống như ext4, xfs…

- **Đơn giản** :  Việc quản lý GlusterFS rất dễ dàng, được tách biệt khỏi kernel space và thực thi trên user space.

- **Chi phí** : GlusterFS có thể triển khai trên các hệ thống phần cứng thông thường mà không yêu cầu bất kỳ một thiết bị chuyên biệt nào.

- **Mã nguồn mở** : Hiện nay mã nguồn của GlusterFS vẫn được công khai và điều hành bởi Red Hat Inc.

## Các dạng Volume của GlusteFS

- Bạn có thể tạo 9 loại Volume khác nhau trông GlusteFS.

### 1. Distributed ( Dạng phân tán )

Với concept này, các files (data) sẽ được phân tán, lưu trữ rời rạc (distributed) trong các bricks khác nhau . 
Ví dụ, bạn có 100 files: file1, file2, file3…, file100. Thì file1, file2 lưu ở brick1, file3,4lưu ở brick2, etc. 
Việc phân bố các files trên brick dựa vào thuật toán hash, kiểu concept này tương tự JBOD

![Imgur](https://i.imgur.com/qo1J4UG.png)

**Ưu điểm:** Mở rộng được dung lượng lưu trữ nhanh chóng và dễ dàng, tổng dung lượng lưu trữ của volume bằng tổng dung lượng của các brick.

**Nhược điểm:** Khi một trong các brick bị ngắt kết nối, hoặc bị lỗi thì dữ liệu sẽ bị mất hoặc không truy vấn được.

**Câu lệnh để tạo**: 

`gluster volume create NEW-VOLNAME [transport [tcp | rdma | tcp,rdma]] NEW-BRICK...`

Ví dụ, tạo một distributed volume với 4 server lưu trữ sử dụng TCP:

```
gluster volume create test-volume server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4
Creation of test-volume has been successful
Please start the volume to access data
```

Hiển thị thông tin volume:

```
#gluster volume info
Volume Name: test-volume
Type: Distribute
Status: Created
Number of Bricks: 4
Transport-type: tcp
Bricks:
Brick1: server1:/exp1
Brick2: server2:/exp2
Brick3: server3:/exp3
Brick4: server4:/exp4
```

### 2. Replicated GluserFS Volume

Với concept này, dữ liệu sẽ được copy sang các bricks trong cùng một volume. 
Nhìn vào concept này chúng ta thấy rõ ưu điểm đó là dữ liệu sẽ có tính sẵn sàng 
cao và luôn trong trạng thái dự phòng tương tự Raid 1.

![Imgur](https://i.imgur.com/0YiZAgK.png)

Tổng dung lượng của volume sẽ chỉ bằng một dung lượng của một brick trong volume.

**Tạo Replicated Volume**

`gluster volume create NEW-VOLNAME [replica COUNT] [transport [tcp | rdma | tcp,rdma]] NEW-BRICK...`

Ví dụ, tạo replicated volume với 2 servers lưu trữ:

```
# gluster volume create test-volume replica 2 transport tcp server1:/exp1 server2:/exp2
Creation of test-volume has been successful
Please start the volume to access data
```

### 3. Striped Glusterfs Volume

Nhìn vào hình ảnh trên bạn có thể thấy, Tập tin cần lưu trữ được chia nhỏ thành nhiều phần, và mỗi phần nhỏ được lưu lần lượt trên các server tham gia vào hệ thống. 
Không có sự trùng lặp nào. Hầu hết được sử dụng trong trường hợp lưu trữ một tập tin lớn và cần sự truy xuất dữ liệu nhanh.

![Imgur](https://i.imgur.com/ZVJbtUP.png)

**Ưu điểm:** Phù hợp với việc lưu trữ mà dữ liệu cần truy xuất với hiệu năng cao, 
đặc biệt là truy cập vào những tệp tin lớn.

**Nhược điểm:** Khi một trong những brick trong volume bị lỗi, thì volume đó không thể hoạt động được

**Tạo Striped Volume**:

`gluster volume create NEW-VOLNAME [stripe COUNT] [transport [tcp | dma | tcp,rdma]] NEW-BRICK...`

Ví dụ, tạo striped volume với 2 servers lưu trữ:

```
# gluster volume create test-volume stripe 2 transport tcp server1:/exp1 server2:/exp2
Creation of test-volume has been successful
Please start the volume to access data
```

### 4. Distributed Striped Volume


![Imgur](https://i.imgur.com/DNFQ4IW.png)

Nhìn vào hình trên bạn có thể thấy File 1 được chia nhỏ (Strip) và lưu trữ lần lượt trên mỗi Brick thuộc Server 1. Tương tự File 2 được chia nhỏ và lưu trữ lần lượt trên mỗi Brick thuộc server 2. 
File 1 và File 2 được lưu trữ phân tán trên 2 server. Phương pháp sử dụng cho các tập tin lớn được lưu trữ đồng thời trong hệ thống. Tận dụng được tiềm lực lưu trữ tối đa của mỗi máy chủ tham gia. 
Nhưng với mỗi Brick hỏng nó sẽ ảnh hưởng đến chính tập tin đã được Striped lưu trữ trên chính server đó.

- Lệnh cấu hình: 
**# gluster volume create NEW-VOLNAME [stripe COUNT] [transport tcp | rdma | tcp,rdma] NEW-BRICK...**

- Ví dụ với 4 servers:

```
# gluster volume create test-volume stripe 2 transport tcp server1:/exp1 server1:/exp2 server2:/exp3 server2:/exp4
```
### 5. Distributed Replicated Volumes

![Imgur](https://i.imgur.com/oJCasHz.png)

Các tập tin được lưu trữ phân tán, trên mỗi Volume Replicated chính bản thân tập tin lại được sao lưu trên các Brick 
của Volume Replicated. Mô hình trên sử dụng cho các tập tin quan trọng và cần hệ thống để có thể mở rộng lưu trữ dễ dàng, 
giúp truy xuất nhanh chóng đến các tập tin.

**Tạo distributed replicated volume**:

`# gluster volume create NEW-VOLNAME [replica COUNT] [transport [tcp | rdma | tcp,rdma]] NEW-BRICK...`

Ví dụ, 4 node distributed (replicated) volume với 2 giải mirror:

```
# gluster volume create test-volume replica 2 transport tcp server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4
Creation of test-volume has been successful
Please start the volume to access data
```

### 6. Striped Replicated Volumes

![Imgur](https://i.imgur.com/91v9DZO.png)

Nếu không chú ý kỹ, bạn có thể nhầm lẫn giữa các loại Volume trong GlusterFS. Đối với Striped Replicated Volumes. 
Tập tin lưu trữ thường rất lớn,  nó vừa được chia nhỏ rải rác trên các Brick, đồng thời được sao lưu với mỗi phần được chia nhỏ. 
Điều này đảm bảo an toàn để lưu trữ tập tin có khối lượng lớn cũng như tốc độ truy xuất đến tập tin.

**# gluster volume create NEW-VOLNAME [stripe COUNT] [replica COUNT] [transport tcp | rdma | tcp,rdma] NEW-BRICK...**

ví dụ: 

- Trên 4 servers 
```
gluster volume create test-volume stripe 2 replica 2 transport tcp server1:/exp1 server2:/exp3 server3:/exp2 server4:/exp4
```
- Trên 6 servers 
```
 gluster volume create test-volume stripe 3 replica 2 transport tcp server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4 
 server5:/exp5 server6:/exp6
 ```
 
### 7. Distributed Replicated Striped Volume 

Hình thức glusterfs này vẫn đang trong quá trình thử nghiệm và chưa hỗ trợ hoàn toàn 
các nền tảng của Red Hat.

![Imgur](https://i.imgur.com/AhacLXE.png)

- Cấu hình với 4 server:

**gluster volume create NEW-VOLNAME [stripe COUNT] [replica COUNT] [transport tcp | rdma | tcp,rdma] NEW-BRICK...**

- Ví dụ:

```
gluster volume create test-volume stripe 2 replica 2 transport tcp server1:/exp1 server1:/exp2 server2:/exp3 server2:/exp4 
server3:/exp5 server3:/exp6 server4:/exp7 server4:/exp8
```