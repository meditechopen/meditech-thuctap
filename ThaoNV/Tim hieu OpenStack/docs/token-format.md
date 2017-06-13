# Tìm hiểu về các loại Token trong keystone

## Mục lục

1. Lịch sử của token trong keystone

2. UUID Tokens

3. PKI Tokens

4. Fernet Tokens

--------

### 1. Lịch sử của token trong keystone

Vào những ngày đầu, Keystone hỗ trợ UUID token. Đây là loại token gồm 32 kí tự được dùng để xác thực và ủy quyền. Lợi ích mà loại token này mang lại đó là nó nhỏ gọn và dễ sử dụng, nó có thể được thêm trực tiếp vào câu lệnh cURL. Tuy nhiên nó lại không thể chứa đủ thông tin để thực hiện việc ủy quyền. Các services của OpenStack sẽ luôn phải gửi lại token này lại cho Keystone để xác thực xem hành động có hợp lệ không. Điều này khiến Keystone trở thành trung tâm cho mọi hoạt động của OpenStack.

Trong nỗ lực kiếm tìm một loại token mới để khắc phục những nhược điểm của UUID token, nhóm phát triển đã tạo ra PKI token. Token này chứa đủ thông tin để xác thực và ủy quyền và đồng thời nó cũng chứa cả danh mục dịch vụ. Bên cạnh đó, token này được gán vào và các dịch vụ có thể cache lại nó để dử dụng cho đến khi nó hết hiệu lực hoặc bị hủy. Loại token này vì thế cũng khiến lượng traffic tới Keystone server ít hơn. Tuy nhiên kích cỡ của nó có thể lên tới 8k và điều này làm việc gán vào HTTP header trở nên khó khăn hơn. Rất nhiều các web server mặc định sẽ không cho phép điều này nếu chưa được config lại. Thêm vào đó, loại token này cũng rất khó được sử dụng trong câu lệnh cURL. Vì những hạn chế mà các nhà phát triển đã cố gắng sửa đổi và ra mắt một phiên bản khác đó là PKIz, tuy nhiên theo đánh giá của cộng đồng thì loại token này vẫn rất lớn về kích thước.

Điều này buộc Keystone team phải đưa ra một loại mới và đó là Fernet token. Fernet token khá nhỏ (255 kí tự) tuy nhiên nó lại chưa đủ thông tin để ủy quyền. Bên cạnh đó, việc nó chứa đủ thông tin cũng không khiến token database phải lưu dữ liệu token nữa. Các nhà vận hành thường phải dọn dẹp Keystone token database để hệ thống của họ hoạt động ổn định. Mặc dù vậy, Fernet token có nhược điểm đó là symmetric keys được dùng để tạo ra token cần được phân phối và xoay vòng. Các nhà vận hành cần phải giải quyết vấn đề này, tuy nhiên họ có vẻ thích thú với việc này hơn là sử dụng những loại token khác.

### 2. UUID Tokens

UUID là token format đầu tiên của keystone, nó đơn giản chỉ là một chuỗi UUID gồm 32 kí tự được generate random. Nó được xác thực bởi identity service. Phương thức hexdigest() được sử dụng để tạo ra chuỗi kí tự hexa. Điều này khiến token URL trở nên an toàn và dễ dàng trong việc vận chuyển đến các môi trường khác.

UUID token bược phải được lưu lại trong một backend (thường là database). Nó cũng có thể được loại bỏ bằng các sử dụng DELETE request với token id. Tuy nhiên nó sẽ không thực sự bị loại bỏ khỏi backend mà chỉ được đánh dấu là đã được loại bỏ. Vì nó chỉ có 32 bytes nên kích thước của nó trong HTTP header cũng sẽ là 32 bytes.

Loại token này rất nhỏ và dễ sử dụng quy nhiên nếu sử dụng nó, Keystone sẽ là "cổ chai" của hệ thống bởi mọi cuộc giao tiếp đều cần tới keystone để xác thực token.

Method dùng để sinh ra UUID token:

``` sh
def _get_token_id(self, token_data):
 return uuid.uuid4().hex
```

**Token Generation Workflow**

<img src="">

- User request tới keystone tạo token với các thông tin: user name, password, project name
- Chứng thực user, lấy User ID từ backend LDAP (dịch vụ Identity)
- Chứng thực project, thu thập thông tin Project ID và Domain ID từ Backend SQL (dịch vụ Resources)
- Lấy ra Roles từ Backend trên Project hoặc Domain tương ứng trả về cho user, nếu user không có bất kỳ roles nào thì trả về Failure(dịch vụ Assignment)
- Thu thập các Services và các Endpoints của các service đó (dịch vụ Catalog)
- Tổng hợp các thông tin về Identity, Resources, Assignment, Catalog ở trên đưa vào Token payload, tạo ra token sử dụng hàm uuid.uuid4().hex
- Lưu thông tin của Token và SQL/KVS backend với các thông tin: TokenID, Expiration, Valid, UserID, Extra

### 3. PKI Tokens

Token này chứa một lượng khá lớn thông tin ví dụ như: thời gian nó được tạo, thời gian nó hết hiệu lực, thông tin nhận diện người dùng, project, domain, thông tin về role cho user, danh mục dịch vụ,... Tất cả các thông tin này được lưu ở trog phần payload của file định dạng JSON. Phần payload được mã hóa bằng cryptographic message syntax (CMS). Với PKIz thì phần payload được nén sử dụng `zlib`.

Dưới đây là một ví dụ về JSON token payload:

``` sh
{
    "token": {
      "domain": {
          "id": "default",
          "name": "Default"
        },
        "methods": [
        "password"
        ],
        "roles": [
            {
              "id": "c703057be878458588961ce9a0ce686b",
              "name": "admin"
            }
        ],
        "expires_at": "2014-06-10T21:52:58.852167Z",
        "catalog": [
            {
                "endpoints": [
                    {
                         "url": "http://localhost:35357/v2.0",
                         "region": "RegionOne",
                         "interface": "admin",
                         "id": "29beb2f1567642eb810b042b6719ea88"
                    },
                    {
                         "url": "http://localhost:5000/v2.0",
                         "region": "RegionOne",
                         "interface": "internal",
                         "id": "87057e3735d4415c97ae231b4841eb1c"
                    },
                    {
                         "url": "http://localhost:5000/v2.0",
                         "region": "RegionOne",
                         "interface": "public",
                         "id": "ef303187fc8d41668f25199c298396a5"
                    }
                ],
                "type": "identity",
                "id": "bd7397d2c0e14fb69bae8ff76e112a90",
                "name": "keystone"
              }
        ],
        "extras": {},
        "user": {
            "domain": {
                "id": "default",
                "name": "Default"
              },
                "id": "3ec3164f750146be97f21559ee4d9c51",
                "name": "admin"
              },
              "audit_ids": [
                  "Xpa6Uyn-T9S6mTREudUH3w"
              ],
              "issued_at": "2014-06-10T20:52:58.852194Z"
           }
        }
```

Token chứa toàn bộ những thông tin mà service cần. Các service cũng có thể cache và thực hiện xác thực cũng như ủy quyền mà không cần liên lạc với keystone server. Để vận chuyển qua HTTP, file JSON được thu gọn lại dưới dạng base64 với một vài chỉnh sửa nhỏ. Dưới đây là ví dụ của token được dùng để vận chuyển:
``` sh
MIIDsAYCCAokGCSqGSIb3DQEHAaCCAnoEggJ2ew0KICAgICJhY2QogICAgICAgI...EBMFwwVzELMAkGA
1UEBhMCVVMxDjAMBgNVBAgTBVVuc2V0MCoIIDoTCCA50CAQExCTAHBgUrDgMQ4wDAYDVQQHEwVVbnNldD
EOMAwGA1UEChM7r0iosFscpnfCuc8jGMobyfApz/dZqJnsk4lt1ahlNTpXQeVFxNK/ydKL+tzEjg
```

Kích cỡ của token nếu có 1 endpoints trong danh mục dịch vụ đã rơi vào khoảng 1700 bytes. Với những hệ thống lớn, kích cỡ của nó sẽ vượt mức cho phép của HTTP header (8KB). Ngay cả khi được nén lại trong PKIz format thì vấn đề cũng không được giải quyết khi mà nó chỉ làm kích thước token nhỏ đi khoảng 10%.

Mặc dù PKI và PKIz token có thể được cache, nó vẫn có một vài khuyết điểm. Sẽ là khá khó để cấu hình token sử dụng loại token này. Thêm vào đó, kích thước lớn của nó cũng ảnh hưởng đến các service khác và rất khó khi sử dụng với cURL. Ngoài ra, keystone cũng phải lưu những token này trong backend vì thế người dùng vẫn sẽ phải flushing the Keystone token database thường xuyên.

Dưới đây là method để sinh ra PKI token:

``` sh
def _get_token_id(self, token_data):
    try:
         token_json = jsonutils.dumps(token_data, cls=utils.PKIEncoder)
         token_id = str(cms.cms_sign_token(token_json,
                                           CONF.signing.certfile,
                                           CONF.signing.keyfile))
         return token_id
     except environment.subprocess.CalledProcessError:
         LOG.exception(_LE('Unable to sign token'))
         raise exception.UnexpectedError(_('Unable to sign token.'))
```

### Fernet Tokens

Đây là loại token mới nhất, nó được tạo ra để khắc phục những hạn chế của các loại token trước đó. Thứ nhất, nó khá nhỏ với khoảng 255 kí tự, lớn hơn UUID nhưng nhỏ hơn rất nhiều so với PKI. Token này cũng chứa vừa đủ thông tin để cho phép nó không cần phải được lưu trên database.

Fernet tokens chứa một lượng nhỏ dữ liệu ví dụ như thông tin để nhận diện người dùng, project, thời gian hết hiệu lực,...Nó được sign bởi symmetric key để ngăn ngừa việc giả mạo. Cơ chế hoạt động của loại token này giống với UUID vì thế nó cũng phải được validate bởi Keystone.

Một trong những vấn đề của loại token này đó là nó dùng symmetric key để mã hóa token và các keys này buộc phải được phân phối lên tất cả các vùng của OpenStack. Thêm vào đó, keys cũng cần được rotated.

Keystone cung cấp công cụ cấu hình để cài đặt symmetric encryption keys.

`$ keystone-manage fernet_setup`

Thêm vào đó, keys cũng nên được rotated bằng câu lệnh:

`$ keystone-manage fernet_rotate`
