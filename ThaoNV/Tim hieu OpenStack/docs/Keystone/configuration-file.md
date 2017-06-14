# Tìm hiểu file config của Keystone

## Mục lục

1. API configuration options


--------

### 1. API configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| admin_token = <None> | Giá trị của tùy chọn này là một đoạn mã dùng để khởi động Keystone thông qua API. Token này không được hiểu là user và nó có thể vượt qua hầu hết các phần check ủy quyền. |
| public_endpoint = <None> | Đầu mối liên lạc gốc của Keystone cho clients. Chỉ nên set option này trong trường hợp giá trị của base URL chứa đường dẫn mà Keystone không thể tự suy luận hoặc endpoint ở server khác |
| admin_endpoint = <None> | Chỉ nên set option này trong trường hợp giá trị của base URL chứa đường dẫn mà Keystone không thể tự suy luận hoặc endpoint ở server khác |
| max_project_tree_depth = 5 | Số lượng tối đa của cây project. Lưu ý: đặt giá trị cao có thể ảnh hưởng đến hiệu suất. |
| max_param_size = 64 | Giới hạn của user và project ID/names |
| max_token_size = 8192 | Giống max_param_size nhưng là cho token. Với PKI/PKIz giá trị là 8192, fernet là 255 và uuid là 32 |
| member_role_id = 9fe2ff9ee4384b1894a90878d3e92bab | Giống với member_role_name, diễn tả role mặc định được gán vào user với default projects trong v2 API. |
| member_role_name = _member_ | đi kèm với member_role_id |
| list_limit = <None> | Số lượng entities lớn nhất có thể được trả lại trong một collection. Với những hệ thống lớn nên set option này để tránh những câu lệnh hiển thị danh sách users, projects cho ra quá nhiều dữ liệu không cần thiết |
| domain_id_immutable = true | Set option này là false nếu bạn muốn cho phép users, projects, groups được di chuyển giữa các domains bằng cách update giá trị domain_id (không được khuyến khích) |
| strict_password_check = false | Nếu được set thành true, Keystone sẽ kiểm soát nghiêm ngặt thao tác với mật khẩu, nếu mật khẩu quá chiều dài tối đa, nó sẽ không được chấp nhận |
| driver = sql | backend driver cho dịch vụ của Keystone |
| return_all_endpoints_if_no_filter = True | Trả lại roàn bộ active endpoints nếu không có endpoints nào được tìm thấy theo yêu cầu |
| admin_bind_host = 0.0.0.0 | Địa chỉ IP của cổng mạng cho admin service lắng nghe |
| admin_port = 35357 | port mà admin service lắng nghe |
| admin_workers = None | Số lượng CPU phục vụ công việc quản trị |
| client_socket_timeout = 900 | Thời gian tồn tại kết nối bằng câu lệnh socket trên phía client. Giá trị "0" có nghĩa phải chờ mãi mãi |
| public_bind_host = 0.0.0.0 | Địa chỉ IP của cổng mạng cho public service lắng nghe |
| public_port = 5000 | port mà public service lắng nghe |
| public_workers = None | Số lượng CPU phục vụ các ứng dụng public |
| tcp_keepalive = False | Set true nếu muốn kích hoạt TCP_KEEPALIVE trên server sockets |
| tcp_keepidle = 600 | Chỉ áp dụng nếu tcp_keepalive = True |
| wsgi_keep_alive = True | Nếu set false, mọi kết nối sẽ bị đóng sau khi serving 1 request |
| max_request_body_size = 114688 | Kích thước tối đa cho mỗi request (tính bằng bytes) |
| config_file = keystone-paste.ini | Tên của file cấu hình cho biết những pipelines có sẵn |
| admin_project_domain_name = None | Tên của domain sở hữu admin_project_name |
| admin_project_name = None | Project đặc biệt cho việc thực hiện các tác vụ quản trị trên các remote services. |
| caching = True | Không có tác dụng cho tới khi global caching được kích hoạt |
| domain_name_url_safe = off |
