# Tìm hiểu file config của Keystone

## Mục lục

[1. Cấu trúc file config](#structure)

[2. API configuration options](#api)

[3. Assignment configuration options](#assignment)

[4. Authorization configuration options](#authorization)

[5. CA and SSL configuration options](#ca)

[6. Catalog configuration options](#atalog)

[7. Common configuration options](#common)

[8. Credential configuration options](#credential)

[9. Logging configuration options](#logging)

[10. Domain configuration options](#domain)

[11. Federation configuration options](#federation)

[12. Fernet tokens configuration options](#fernet)

[13. Identity configuration options](#identity)

[14. KVS configuration options](#kvs)

[15. Mapping configuration options](#mapping)

[16. Memcache configuration options](#memcache)

[17. OAuth configuration options](#oauth)

[18. Policy configuration options](#policy)

[19. Revoke configuration options](#revoke)

[20. Role configuration options](#role)

[21. Token configuration options](#token)

[22. Trust configuration options](#trust)


--------
<a name = "structure"></a>
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

<a name = "api"></a>
### 2. API configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [DEFAULT] | |
| admin_token = \<None> | Giá trị của tùy chọn này là một đoạn mã dùng để khởi động Keystone thông qua API. Token này không được hiểu là user và nó có thể vượt qua hầu hết các phần check ủy quyền. |
| public_endpoint = \<None> | Đầu mối liên lạc gốc của Keystone cho clients. Chỉ nên set option này trong trường hợp giá trị của base URL chứa đường dẫn mà Keystone không thể tự suy luận hoặc endpoint ở server khác |
| admin_endpoint = \<None> | Chỉ nên set option này trong trường hợp giá trị của base URL chứa đường dẫn mà Keystone không thể tự suy luận hoặc endpoint ở server khác |
| max_project_tree_depth = 5 | Số lượng tối đa của cây project. Lưu ý: đặt giá trị cao có thể ảnh hưởng đến hiệu suất. |
| max_param_size = 64 | Giới hạn của user và project ID/names |
| max_token_size = 8192 | Giống max_param_size nhưng là cho token. Với PKI/PKIz giá trị là 8192, fernet là 255 và uuid là 32 |
| member_role_id = 9fe2ff9ee4384b1894a90878d3e92bab | Giống với member_role_name, diễn tả role mặc định được gán vào user với default projects trong v2 API. |
| member_role_name = _member_ | đi kèm với member_role_id |
| list_limit = \<None> | Số lượng entities lớn nhất có thể được trả lại trong một collection. Với những hệ thống lớn nên set option này để tránh những câu lệnh hiển thị danh sách users, projects cho ra quá nhiều dữ liệu không cần thiết |
| domain_id_immutable = true | Set option này là false nếu bạn muốn cho phép users, projects, groups được di chuyển giữa các domains bằng cách update giá trị domain_id (không được khuyến khích) |
| strict_password_check = false | Nếu được set thành true, Keystone sẽ kiểm soát nghiêm ngặt thao tác với mật khẩu, nếu mật khẩu quá chiều dài tối đa, nó sẽ không được chấp nhận |
| [endpoint_filter] | |
| driver = sql | backend driver cho dịch vụ của Keystone |
| return_all_endpoints_if_no_filter = True | Trả lại roàn bộ active endpoints nếu không có endpoints nào được tìm thấy theo yêu cầu |
| [eventlet_server] | |
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

<a name = assignment></a>
### 3. Assignment configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [assignment] | |
| driver = None | (String) nếu không được specified thì mặc định sẽ sử dụng SQL |
| prohibited_implied_role = admin | (List) danh sách các role bị cấm trở thành implied role |

<a name = "authorization"></a>
### 4. Authorization configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [auth] | |
| external = None | (String) Entrypoint cho auth plugin module, driver mặc định sẽ là DefaultDomain |
| methods = external, password, token, oauth1 | (List) danh sách các phương thức được cho phép sử dụng để xác thực |
| oauth1 = None | (String) Entrypoint cho oAuth1.0 auth plugin module |
| password = None | (String) Entrypoint cho the password auth plugin module |
| token = None | (String) Entrypoint cho token auth plugin module |

<a name = "ca"></a>
### 5. CA and SSL configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [eventlet_server_ssl] | |
| ca_certs = /etc/keystone/ssl/certs/ca.pem | (String) đường dẫn tới file CA cert cho SSL |
| cert_required = False | (boolean) yêu cầu client certificate. |
| certfile = /etc/keystone/ssl/certs/keystone.pem | (String) đường dẫn tới certfile cho SSL |
| enable=False | (boolean) nút kích hoạt SSL support trên Keystone eventlet servers |
| keyfile = /etc/keystone/ssl/private/keystonekey.pem | (String) Đường dẫn keyfile cho SSL |
| [signing] | |
| ca_certs = /etc/keystone/ssl/certs/ca.pem | (String) Đường dẫn của CA cho token signing |
| ca_key = /etc/keystone/ssl/private/cakey.pem | (String) Đường dẫn của CA key cho token signing |
| cert_subject = /C=US/ST=Unset/L=Unset/O=Unset/CN=www.example.com | (String) Certificate subject (auto generated certificate) cho token signing |
| certfile = /etc/keystone/ssl/certs/signing_cert.pem | (String) Đường dẫn tới certfile cho token signing |
| key_size = 2048 | (integer) Kích cỡ của key (bits) cho token  signing cert (auto generated certificate) |
| keyfile = /etc/keystone/ssl/private/signing_key.pem | (String) Đường dẫn tới keyfile cho token signing |
| valid_days = 3650 | (Integer) Số ngày mà token signing cert có hiệu lực |
| [ssl] | |
| ca_key = /etc/keystone/ssl/private/cakey.pem | (String) Đường dẫn tới CA key file cho SSL |
| cert_subject = /C=US/ST=Unset/L=Unset/O=Unset/CN=localhost | (String) SSL certificate subject (auto generated certificate) |
| key_size = 1024 | (Integer) kích cỡ ssl key |
| valid_days = 3650 | (Integer) số ngày mà certificate có hiệu lực cho một lần sign |

<a name = "catalog"></a>
### 6. Catalog configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [catalog] | |
| cache_time = None | (Integer) thời gian để cache dữ liệu catalog (theo giây). Tùy chọn này sẽ không có hiệu lực cho đến khi global và catalog caching được kích hoạt |
| caching = True | (Boolean) Nút kích hoạt catalog caching, nó sẽ không có tác dụng cho tới khi global caching được kích hoạt |
| driver = sql | (String) Entrypoint cho catalog backend driver. Các driver hỗ trợ là kvs, sql, templated, and endpoint_filter.sql |
| list_limit = None | (Integer) Số lượng giới hạn của entities trả lại trong catalog collection |
| template_file = default_catalog.templates	 | (String) Catalog template file name để sử dụng với template catalog backend. |

<a name = "common"></a>
### 7. Common configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [DEFAULT] | |
| executor_thread_pool_size = 64	| (Integer) Kích thước của executor thread pool. |
| insecure_debug = False | (Boolean) Nếu là true, server sẽ trả lại thông tin bằng HTTP responses cho phép cả user đã được hoặc chưa xác thực có thể biết thêm thông tin chi tiết hơn bình thường. Điều này giúp ích hơn cho việc debug nhưng lại kém bảo mật |

<a name = "credential"></a>
### 8. Credential configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [credential] | |
| driver = sql | (String) Entrypoint cho credential backend driver |

<a name = "logging"></a>
### 9. Logging configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [audit] | |
| namespace = openstack | (String) namespace prefix cho generated id |

<a name = "domain"></a>
### 10. Domain configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [domain_config] | |
| cache_time = 300 | (Integer) TTL để cache domain config data |
| caching = True | (Boolean) Nút kích hoạt domain config caching |
| driver = sql | (String) Entrypoint cho domain config backend driver |

<a name = "federation"></a>
### 11. Federation configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [federation] | |
| assertion_prefix = | Giá trị được sử dụng trong quá trình filtering assertion parameters từ môi trường |
| driver = sql |  |
| federated_domain_name = Federated | Domain name được dành riêng để cho phép các federated ephemeral users có chung một domain concept. Admin sẽ không thể tạo dmain với tên này hoặc sửa các domain khác sang tên này |
| remote_id_attribute = None | (String) Giá trị được dùng để lấy ID của Identity Provider |
| sso_callback_template = /etc/keystone/sso_callback_template.html | (String) Nơi chứ Single Sign-On callback handler, sẽ trả lại token cho dashboard |
| trusted_dashboard = \[] | (Multi-valued) Danh sách trusted dashboard hosts. |

<a name = "fernet"></a>
### 12. Fernet tokens configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [fernet_tokens] | |
| key_repository = /etc/keystone/fernet-keys/ | (String) Thư mục chứa Fernet token keys |
| max_active_keys = 3 | (Integer) Số lượng keys cho phép để rotate |

<a name = "identity"></a>
### 13. Identity configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [identity] | |
| cache_time = 600 | (Integer) Thời gian để cache identity data (giây). |
| caching = True | |
| default_domain_id = default | (String) Domain để sử dụng cho tất cả identity API v2 requests. Domain với ID này sẽ được tạo bằng keystone-manage db_sync. Nó không thể bị xóa trên v3 API. |
| domain_config_dir = /etc/keystone/domains | (String) Đường dẫn cho Keystone lưu domain configuration files nếu domain_specific_drivers_enabled được thiết lập là true |
| domain_configurations_from_database = False | (Boolean) Thực thi các tùy chọn cấu hình cho domain được lưu trong backend. Mặc định nó sẽ không được kích hoạt |
| domain_specific_drivers_enabled = False | (Boolean) Một tập hợp các domains có riêng identity driver, mỗi một domain trong số ấy có những tùy chọn cấu hình riêng, được lưu tại resource backend hoặc trong file tại thư mục chưa file cấu hình (phụ thuộc vào domain_configurations_from_database) |
| driver = sql | |
| list_limit = None |
| max_password_length = 4096 | |

<a name = "kvs"></a>
### 14. KVS configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [kvs] | |
| backends = | (List) |
| config_prefix = keystone.kvs | (String) Không nên thay đổi trừ khi có một dogpile.cache region khác với cùng configuration name. |
| default_lock_timeout = 5 | (Integer) Thời gian khóa mặc định |
| enable_key_mangler = True | Vì mục đích debug, tùy chọn này được luôn được recommend set true |

<a name = "mapping"></a>
### 15. Mapping configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [identity_mapping] | |
| backward_compatible_ids = True | (Boolean) Chỉ nên set nó là False khi cấu hình fresh installation |
| driver = sql | |
| generator = sha256 | (String) ID generator |

<a name = "memcache"></a>
### 16. Memcache configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [memcache] | |
| servers = localhost:11211 | (String) Memcache servers |
| socket_timeout = 3 | (Integer) Timeout cho mỗi lần call tới server |

<a name = "oauth"></a>
### 17. OAuth configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [oauth1] | |
| access_token_duration = 86400 | Thời gian (giây) cho việc tiếp nhận Token. |
| driver = sql | |
| request_token_duration = 28800 | Thời gian (giây) cho việc request Token. |

<a name = "policy"></a>
### 18. Policy configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [policy] | |
| driver = sql | |
| list_limit = None | |

<a name = "revoke"></a>
### 19. Revoke configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [revoke] | |
| cache_time = 3600 | |
| caching = True | |
| driver = sql | |
| expiration_buffer = 1800 | Giá trị này (theo giây) được thêm vào thơi gian token hết hiệu lực trước khi revocation event bị remove ra khỏi backend |

<a name = "role"></a>
### 20. Role configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [role] | |
| cache_time = None | |
| caching = True | |
| driver = None | |
| list_limit = None | |

<a name = "token"></a>
### 21. Token configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [token] | |
| allow_rescope_scoped_token = True | (Boolean) Cho phép tái sử dụng scoped token |
| bind = | (List) Cơ chế xác thực bên ngoài thêm bind information vào token vd kerberos,x509. |
| cache_time = None | |
| caching = True | |
| driver = sql | |
| enforce_token_bind = permissive | (String) Sử dụng cho các token có bind information. Các tùy chọn đó là disabled, permissive, strict, required hoặc bind mode cụ thể ví dụ như kerberos hoặc x509 |
| expiration = 3600 | (Integer) Thời gian token có hiệu lực (theo giây) |
| hash_algorithm = md5 | (String) thuật toán sử dụng cho PKI token. Những algorithm trong hashlib đều được hỗ trợ. |
| infer_roles = True | (Boolean) Thêm role vào token chưa được thêm |
| provider = uuid | (String) Kiểm soát các cơ chế tạo, xác thực, gỡ bỏ token. Hiện tại có 4 provider đó là [fernet|pkiz|pki|uuid]. |
| revoke_by_id = True | (Boolean) Cho phép hủy token bằng token id |

<a name = "trust"></a>
### 22. Trust configuration options

| Configuration option = Default value | Description |
|--------------------------------------|-------------|
| [trust] | |
| allow_redelegation = False | (Boolean) Kích hoạt tính năng redelegation |
| driver = sql | |
| enabled = True | (Boolean) Kích hoạt các tính năng delegation và impersonation |
| max_redelegation_count = 3 | |
