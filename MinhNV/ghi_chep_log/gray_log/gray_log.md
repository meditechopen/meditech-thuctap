
# Tìm hiểu graylog

## I.Tìm hiểu chung

- <b>`Graylog`</b> là phần mềm mã nguồn mở được tạo ra với mục đích là thu thập log có thể chạy trên linux

- Link trang chủ : <b><u>https://www.graylog.org/</u></b>

- Phiên bản mới <b>`Graylog`</b> nhất là `v2.0.3` ra đời ngày `20/06/2016`

- <b>`Graylog`</b> tạo bỏi <b>`Lennart Koopman`</b> vào năm `2010` với tên bản `beta`(phiên bản `0.x.x`) là <b>`Graylog2`</b>

- `2/2014`, phát hành <b>`Graylog2`</b> `V0.20.0 Final`.

- 19/02/2015, ra mắt bản chính thức tên <b>`Graylog`</b> phiên bản `1.0.0`

- <b>`Graylog`</b> viết bằng ngôn ngữ <b>`java`</b>

- Từ bản `1.0.0` đến bản mới nhất có `21` phiên bản chính thức

- Ứng dung <b>`Graylog`</b> trong `cloud computing`:

	+ SSH: Thống kê `user`, `ip` đăng nhập, số lần đăng nhập `SSH` thành công, thất bại, tổng số lần đăng nhập.
	+ VPN: Thống kê `user`, `ip` đăng nhập , `ip` được cấp `VPN` trên hệ thống Lab và hệ thống thực.
	+ OpenStack : Thống kê user, số lần đăng nhập dashboard thành công và thật bại, số máy ảo được tạo, xóa, hỏng.

## II. Đặc điểm nổi bật

Việc triển khai và cài đặt dễ dàng.

- Graylog có thể nhận log từ rất nhiều khác nhau : log của các server Linux, Window, thiết bị mạng như router, switch, firewall, các thiết bị lưu trữ như CEPH.
- Sử dụng công cụ chuyên dụng để tìm kiếm là Elastisearch, giúp việc tìm kiếm các bản tin log đuọc dễ dàng, nhanh chóng và chính xác.
- Phân tích các số liệu các được từ các file log thành dạng số liệu, biểu đồ thống kê, tổng hợp lại trong các dashboard.
- Cơ chế cảnh báo qua Email, Slack.
- Khả năng tích hợp mạnh mẽ với các phần mềm khác bằng cách sử dụng cơ chế plugin, bạn có thể dễ dàng tích hợp Graylog với các LDAP, Graphite/Ganglia, Logstash, NetFlow...

Đặc biệt, không chỉ tự mình thu thập log, từ phiên bản 2.0, Graylog có thể đóng vai trò quản lý và trung gian. Với các server có sẵn có chế thu thập log như nx-log, hay logstash, bạn có thể thu thập log từ chính các cơ chế có sẵn này. Graylog còn có thể làm trung gian, đẩy log thu được tới bên thứ 3 sử dụng.

## III.Kiến trúc Graylog

<img src="https://github.com/vietstacker/Monitor-Logging-OpenStack/raw/master/images/i4.png">

Trong mô hình Graylog2-server sẽ nhận log từ các log source từ các Log Source qua các giao thức mạng là TCP,UDP,HTTP

Có 4 thành phần chính:

- Graylog-server: thực hiện xử lý log, kết nối ,truyền thông tới Mongodb và Elasticsearch, và quản lý Web-interface nên bị ảnh hưởng bởi CPU
- Elasticsearch thực hiện lưu trữ tìm kiếm log nên bị ảnh hưởng bởi tốc độ I/O,RAM,tốc độ ổ đĩa
- Mongodb lưu trữ cấu hình người dùng,metadata nên cần cấu hình thấp
- Web-interface cung cấp giao diện trên web cho người dùng

### 1.Sự tương tác giữa các thành phần

#### 1.1Tương tác Graylog-server với Elasticsearch

<img src="https://i.imgur.com/KQsHzlS.png">

- `Graylog-server` được coi như là một `Node` trong `Elasticsearch Cluster` tương tác `Node` qua `API` cụ thể là `Discovery-zen-ping`
- Graylog-server sẽ phải khai báo như là một Node để kết nối với Elasticsearch Cluster
- Phiên bản Elasticsearch với Graylog-server

|Graylog version|Elasticsearch version|
|---------------|---------------------|
|1.2.0-1.2.1|1.7.1|
|1.3.0-1.3.3|1.7.3|
|1.3.4|1.7.5|
|2.0.0|2.3.1|
|2.0.1-2.0.3|2.3.2|

#### 1.2Tương tác Mongodb với Graylog-server 

<img src="https://i.imgur.com/9bk0eQG.png">

- `Graylog-server` tương tác với `Mongodb` theo cơ chế `client-server` với `Graylog-server` là `client` được cài `Mongodb client driver` và `Mongodb` là `server`

### 2. Elasticsearch

- Cluster: Một tập hợp Nodes (servers) chứa tất cả các dữ liệu.
- Node: Một server duy nhất chứa một số dữ liệu và tham gia vào cluster’s indexing and querying.
- Index: Hãy quên SQL Indexes đi. Mỗi ES Index là 1 tập hợp các documents.

	+ Invert index: là kĩ thuật thay vì index theo đơn vị row(document) giống như mysql thì chúng ta sẽ tiến hành index theo đơn vị term. Cụ thể hơn, Inverted Index là một cấu trúc dữ liệu, nhằm mục đích map giữa term, và các document chứa term đó
	+ Khi sử dụng inverted index, nó có thể tìm kiếm thông qua terms như một binary tree (sử dụng thứ tự chữ cái) làm giảm thời gian tìm kiếm.
	+ Cho phép query nhiều index một lúc
	+ Ví dụ về index và invert index:
	
Ta có 3 document là D1, D2, D3

D1 = "hom nay troi mua"

D2 = "hom nay troi nang"

D3 = "mot ngay dep troi"

Theo đó ta sẽ có inverted index của 3 document trên là

"hom" = {D1, D2}

"nay" = {D1, D2}

"troi" = {D1, D2, D3}

"mua" = {D1}

"nang" = {D2}

"mot" = {D3}

"ngay" = {D3}

"dep" = {D3}

Nhìn vào kết quả của inverted index trên ta có thể thấy việc search full text sẽ diễn ra rất dễ dàng và nhanh chóng. nó chỉ là việc tính toán của các term. Ví dụ khi muốn query từ “hom nay” (tùy theo việc là query theo kiểu and hay or thì phép tính toán sẽ khác đi. ở đây mình sẽ lấy ví dụ là query theo kiểu and.) thì phép toán là

{D1, D2} ∩ {D1, D2} = {D1, D2}

Kết quả thu được chính là document 1 và 2(D1 and D2).

- Shards: Tập con các documents của 1 Index. Một Index có thể được chia thành nhiều shard.

	+ Shard được tạo ra với mục đích quản lý khối lượng nội dung theo chiều ngang(horizontally),phân phát và thực hiện đồng bộ qua shard do đó dẫn đến nâng cao hiệu năng chương trình
	+ Shard dùng để lưu trữ dữ liệu có hai loại là primary shard và replica shard
	+ Primary Shard Nếu hình dung quan hệ master-slave như MySQL thì primary shard là master. Dữ liệu được lưu tại 1 primary shard, được đánh index ở đây trước khi chuyển đến replica shard
	+ Replica Shard có thể có hoặc không có, dùng để backup dữ liệu cho primary shard để bảo toàn dữ liệu khi gặp sự cố,đồng thời ngăn chặn truy cập vào node gặp sự cố và tự động chuyển node

- Type: Một định nghĩa về schema of a Document bên trong một Index (Index có thể có nhiều type).
- Document: Một JSON object với một số dữ liệu. Đây là basic information unit trong ES.

### Đường đi của bản tin log 

Trên server:

log message => input => Journal => Process chain => Output 

<img src="https://i.imgur.com/llOGHYt.png">

- Bước 1: Journal

Message được spooling vào disk chuẩn bị quán trình bufer

- Bước 2: Input Buffer

Message được lấy từ disk, đẩy vào Input Bufer( Ring + Processor) nhiệm vụ lọc, định tuyến mesage cho các Stream

- Bước 3: Output Buffer

Mesage đã lọc tiếp tục đẩy vào Output Buffer để phân loại đóng index và đẩy ra Output
