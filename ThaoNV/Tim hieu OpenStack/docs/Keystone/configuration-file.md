# Tìm hiểu file config của Keystone

## Mục lục

1. Cấu trúc file config

2. API configuration options


--------

### 1. Cấu trúc file config

OpenStack sử dụng INI file format cho file config. INI file là một file text đơn giản thể hiện các options theo các cặp giá trị `key = value`, chúng được nhóm lại thành các section.

Section `DEFAULT` chứa hầu hết các tùy chọn cấu hình. Các dòng bắt đầu với kí tự `#` là các comments.

Các options có thể có các giá trị khác nhau, dưới đây là các loại thường được sử dụng bởi OpenStack:

- `boolean` : Giá trị cho phép lựa chọn là `true` và `fale`.

- `float` : Số thực (ví dụ 0.25 hoặc 1000)

- `interger` : số nguyên

- `list` : danh sách các values được phân tách nhau bởi dấu phẩy

- `muilti valued` : là một string value và có thể gán nhiều hơn 1 giá trị, tất cả sẽ đều được sử dụng.

- `string` : có thể có hoặc không đặt trong dấu `""` hoặc `''`

**Section**

Các tùy chọn cài đặt được nhóm lại thành các section. Thông thường hầu hết các file config của OpenStack đều có 2 section [DEFAULT] và [database]

**Substitution**

File config hỗ trợ variable substitution. Sau khi thiết lập, tùy chọn cấu hình đó có thể được dùng lại trong các giá tùy chọn khác bằng cách thêm dấu `$`, ví dụ như `rabbit_hosts = $rabbit_host:$rabbit_port`

Để tránh substitution, dùng `$$`. Ví dụ `ldap_dns_password = $$xkj432`

**Whitespace**

Để sử dụng khoảng trắng trong phần value, sử dụng dấu nháy đơn `''`. Ví dụ: `ldap_dns_passsword='a password with spaces'`

**Lưu ý:**

Hầu hết các service sẽ load file cấu hình. Để thay đổi nơi đặt file cấu hình, thêm tùy chọn `--config-file FILE` vào khi bạn start dịch vụ hoặc dùng câu lệnh `*-manage`

### 2. API configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [DEFAULT] | |
| admin_token = none | Giá trị của tùy chọn này là một đoạn mã dùng để khởi động Keystone thông qua API. Token này không được hiểu là user và nó có thể vượt qua hầu hết các phần check ủy quyền. |
| public_endpoint = none | Đầu mối liên lạc gốc của Keystone cho clients. Chỉ nên set option này trong trường hợp giá trị của base URL chứa đường dẫn mà Keystone không thể tự suy luận hoặc endpoint ở server khác |
| admin_endpoint = none | Chỉ nên set option này trong trường hợp giá trị của base URL chứa đường dẫn mà Keystone không thể tự suy luận hoặc endpoint ở server khác |
| max_project_tree_depth = 5 | Số lượng tối đa của cây project. Lưu ý: đặt giá trị cao có thể ảnh hưởng đến hiệu suất. |
| max_param_size = 64 | Giới hạn của user và project ID/names |
| max_token_size = 8192 | Giống max_param_size nhưng là cho token. Với PKI/PKIz giá trị là 8192, fernet là 255 và uuid là 32 |
| member_role_id = 9fe2ff9ee4384b1894a90878d3e92bab | Giống với member_role_name, diễn tả role mặc định được gán vào user với default projects trong v2 API. |
| member_role_name = _member_ | đi kèm với member_role_id |
| list_limit = \<None>\ | Số lượng entities lớn nhất có thể được trả lại trong một collection. Với những hệ thống lớn nên set option này để tránh những câu lệnh hiển thị danh sách users, projects cho ra quá nhiều dữ liệu không cần thiết |
| domain_id_immutable = true | Set option này là false nếu bạn muốn cho phép users, projects, groups được di chuyển giữa các domains bằng cách update giá trị domain_id (không được khuyến khích) |
| strict_password_check = false | Nếu được set thành true, Keystone sẽ kiểm soát nghiêm ngặt thao tác với mật khẩu, nếu mật khẩu quá chiều dài tối đa, nó sẽ không được chấp nhận |
| [endpoint_filter] | |
| driver = sql | backend driver cho dịch vụ của Keystone |
| return_all_endpoints_if_no_filter = True | Trả lại roàn bộ active endpoints nếu không có endpoints nào được tìm thấy theo yêu cầu |
| [eventlet_server | |
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
| [oslo_middleware] | |
| max_request_body_size = 114688 | Kích thước tối đa cho mỗi request (tính bằng bytes) |
| [paste_deploy] | |
| config_file = keystone-paste.ini | Tên của file cấu hình cho biết những pipelines có sẵn |
| [resource] | |
| admin_project_domain_name = None | Tên của domain sở hữu admin_project_name |
| admin_project_name = None | Project đặc biệt cho việc thực hiện các tác vụ quản trị trên các remote services. |
| caching = True | Không có tác dụng cho tới khi global caching được kích hoạt |
| domain_name_url_safe = off |


**Assignment configuration options**

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [assignment] | |
| driver = None | nếu không được specified thì mặc định sẽ sử dụng SQL |
| prohibited_implied_role = admin | danh sách các role bị cấm trở thành implied role |

**Authorization configuration options**

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [auth] | |
| external = None | Entrypoint cho auth plugin module, driver mặc định sẽ là DefaultDomain |
| methods = external, password, token, oauth1 | danh sách các
