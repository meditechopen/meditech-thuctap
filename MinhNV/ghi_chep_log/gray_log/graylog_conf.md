## Properties
### General

`is_master = true`

- Nếu bạn đang chạy nhiều hơn một node thuộc Graylog server thì bạn phải chọn một node làm master. Node này sẽ điều khiển các node còn lại.

- Các node sẽ là slave nếu đã có một node master.

`node_id_file = /etc/graylog/server/<node-id>`

- ID của node sẽ được gen tự động và được lưu trong đường dẫn thư mục và đọc nó sau khi restart.

`password_secret = <secret>`

- Bạn phải đặt một chuỗi kí tự bí mật dùng để mã hóa mật khẩu và salting. Graylog sẽ không start được nếu không có nó và được sử dụng ít nhất 64 kí tự. 
- Nếu bạn sử dụng nhiều node graylog-server hãy chắc chắn bạn sử dụng `password_secret` giống nhau cho chúng

VD để gen một secret `pwgen -N 1 -s 96`

`root_username = admin`

- Mặc định user root sẽ sử dụng tên admin 

`root_password_sha2 = <SHA2>`

- Một SHA2 hash mật khẩu của bạn sẽ sử dụng để đăng nhập lúc đầu.  

VD để gen được một mã SHA2 `echo -n yourpassword | shasum -a 256`

*Lưu ý* Bạn phải chỉ định một hash password cho user root. Password này không thể thay đổi bằng cách sử dụng API hoặc trên dashboard. Nếu bạn muốn thay đổi nó thì phải thay đổi trong file cấu hình

`root_email = ""`

- Địa chỉ email cho user root. Mặc định để trống.

`root_timezone = UTC` 

- Thiết lập thời gian cho user root. Mặc định là UTC

`plugin_dir = plugin`

- Đặt thư mục plugin ở đây 

`rest_listen_uri = http://127.0.0.1:9000/api/`

- API URI của REST API. Phải có thể truy cập được bởi các node máy chủ Graylog khác nếu bạn chạy một cluster.

- Khi sử dụng Graylog Collectors URI này sẽ được sử dụng để nhận các heartbeat messages và phải có thể truy cập được tất các các collector.

`rest_transport_uri = http://192.168.1.1:9000/api/`

- Địa chỉ vận chuyển REST API. 

- Exception: Nếu `rest_listen_uri` được thiết lập là `0.0.0.0` thì địa chỉ non-loopback IPv4 đầu tiên được sử dụng.

`rest_enable_cors = false`

- Enable CORS headers cho REST API. Điều này cần thiết cho JS-client truy cập vào máy chủ trực tiếp.

- Nếu disabled, các trình duyệt hiện tại sẽ không thể truy xuất các tài nguyên từ máy chủ.

`rest_enable_gzip = false`

- Enable GZIP hỗ trợ cho REST API 

`rest_enable_tls = true`

- Enable HTTPS hỗ trợ cho REST API 

`rest_tls_cert_file = /path/to/graylog.crt`

- Tệp chứng chỉ X.509 trong định dạng PEM để sử dụng để bảo vệ REST API.

`rest_tls_key_file = /path/to/graylog.key`

- file private key PKCS#8 trong PEM sử dụng để bảo vệ cho REST API

`rest_tls_key_password = secret`

- Password để mở khóa private key 

`rest_max_header_size = 8192`

- Kích thước tối đa của HTTP request headers tính bằng bytes.

`rest_max_initial_line_length = 4096`

- Độ dài lớn nhất của dòng HTTP / 1.1 ban đầu tính bằng byte.

`rest_thread_pool_size = 16`

- Kích thước của bộ chủ đề dành riêng cho việc phục vụ REST API.

`trusted_proxies = 127.0.0.1/32, 0:0:0:0:0:0:0:1/128`

- Danh sách các proxy tin cậy được tách bằng dấu phẩy được phép đặt địa chỉ máy khách với tiêu đề X-Forwarded-For. Có thể là subnet hoặc host.

### Web

`web_enable = true`

- Enable graylog web interface.

`web_listen_uri = http://127.0.0.1:9000/`

- Web interface listen URI.

- Cấu hình một đường dẫn cho URI ở đây.

`web_endpoint_uri =`

- Web interface endpoint URI. 

### Elasticsearch

`elasticsearch_hosts = http://node1:9200,http://user:password@node2:19200`

- Danh sách các host Elasticsearch graylog nên kết nối.

- Cần phải được chỉ định như là một danh sách các URI hợp lệ được phân tách bằng dấu phẩy cho các cổng http của các nút elasticsearch của bạn.

- Nếu một hoặc nhiều máy của bạn cần xác thực, hãy bao gồm các thông tin xác thực trong mỗi URI yêu cầu xác thực.

`elasticsearch_connect_timeout = 10s`

- Thời gian tối đa để kết nối thành công tới port Elasticsearch HTTP

`elasticsearch_socket_timeout = 60s`

- Thời gian chờ tối đa để đọc phản hồi từ Elasticsearch server. 

`elasticsearch_idle_timeout = -1s`

- Thời gian idle cho một kết nối Elasticsearch. Nếu vượt quá, kết nối này sẽ bị tore down.

`elasticsearch_max_total_connections = 20`

- Số lượng tối đa kết nối đến Elasticsearch.

`elasticsearch_max_total_connections_per_route = 2`

- Số lượng tối đa tổng số kết nối cho mỗi tuyến Elasticsearch (thông thường nghĩa là mỗi máy chủ elasticsearch).

`elasticsearch_max_retries = 2`

- Số lần tối đa mà Graylog sẽ thử lại các yêu cầu thất bại đối với Elasticsearch.

### Rotation

