# Tìm hiểu tổng quan về keystone

## Mục lục

[I. Giới thiệu tổng quan về chức năng và lợi ích khi sử dụng keystone](#overview)

- [1. 3 chức năng chính của keystone](#functions)

    - [1.1 Identity](#identity)
    - [1.2 Authentication](#authentication)
    - [1.3 Access Management (Authorization)](#authorization)

- [2. Các lợi ích chính khi sử dụng keystone](#benefits)

[II. Keystone Concepts](#concepts)

- [1. Project](#project)
- [2. Domain](#domain)
- [3. Users and User Groups (Actors)](#actors)
- [4. Roles](#roles)
- [5. Assignment](#assignment)
- [6. Targets](#target)
- [7. Token](#token)
- [8. Catalog](#catalog)

[III. Identity](#identity2)

- [1. SQL](#sql)
- [2. LDAP](#ldap)
- [3. Multiple Backends](#multiple)
- [4. Identity Providers](#provider)
- [5. Use Cases for Identity Backends](#usecase)

[III. Authentication](#authentication2)

- [1. Password](#password)
- [2. Token](#token2)

[IV. Access Management and Authorization](#authorization2)

[V. Backends and Services](#services)

------

### <a name="overview"> I. Giới thiệu tổng quan về chức năng và lợi ích khi sử dụng keystone </a>

Môi trường cloud theo mô hình dịch vụ Infrastructure-as-a-Service layer (IaaS) cung cấp cho người dùng khả năng truy cập vào các tài nguyên quan trọng ví dụ như máy ảo, kho lưu trữ và kết nối mạng. Bảo mật vẫn luôn là vấn đề quan trọng đối với mọi môi trường cloud và trong OpenStack thì keystone chính là dịch vụ đảm nhiệm công việc ấy. Nó sẽ chịu trách nhiệm cung cấp các kết nối mang tính bảo mật cao tới các nguồn tài nguyên cloud.

#### <a name="functions"> 1. 3 chức năng chính của keystone </a>

<a name="identity"> **1.1 Identity** </a>

- Nhận diện những người đang cố truy cập vào các tài nguyên cloud
- Trong keystone, identity thường được hiểu là User
- Tại những mô hình OpenStack nhỏ, identity của user thường được lưu trữ trong database của keystone. Đối với những mô hình lớn cho doanh nghiệp thì 1 external Identity Provider thường được sử dụng.

<a name="authentication"> **1.2 Authentication** </a>

- Là quá trình xác thực những thông tin dùng để nhận định user (user's identity)

- keystone có tính pluggable tức là nó có thể liên kết với những dịch vụ xác thực người dùng khác như LDAP hoặc Active Directory.

- Thường thì keystone sử dụng Password cho việc xác thực người dùng. Đối với những phần còn lại, keystone sử dụng tokens.

- OpenStack dựa rất nhiều vào tokens để xác thực và keystone chính là dịch vụ duy nhất có thể tạo ra tokens

- Token có giới hạn về thời gian được phép sử dụng. Khi token hết hạn thì user sẽ được cấp một token mới. Cơ chế này làm giảm nguy cơ user bị đánh cắp token.

- Hiện tại, keystone đang sử dụng cơ chế bearer token. Có nghĩa là bất cứ ai có token thì sẽ có khả năng truy cập vào tài nguyên của cloud. Vì vậy việc giữ bí mật token rất quan trọng.


<a name="authorization"> **1.3 Access Management (Authorization)** </a>

- Access Management hay còn được gọi là Authorization là quá trình xác định những tài nguyên mà user được phép truy cập tới.

- Trong OpenStack, keystone kết nối users với những Projects hoặc Domains bằng cách gán role cho user vào những project hoặc domain ấy.

- Các projects trong OpenStack như Nova, Cinder...sẽ kiểm tra mối quan hệ giữa role và các user's project và xác định giá trị của những thông tin này theo cơ chế các quy định (policy engine). Policy engine sẽ tự động kiểm tra các thông tin (thường là role) và xác định xem user được phép thực hiện những gì.

#### <a name="benefits"> 2. Các lợi ích chính khi sử dụng keystone </a>

- Cung cấp giao diện xác thực và quản lí truy cập cho các services của OpenStack. Nó cũng đồng thời lo toàn bộ việc giao tiếp và làm việc với các hệ thống xác thực bên ngoài.

- Cung cấp danh sách đăng kí các containers (“Projects”) mà nhờ vậy các services khác của OpenStack có thể dùng nó để "tách" tài nguyên (servers, images,...)

- Cung cấp danh sách đăng kí các Domains được dùng để định nghĩa các khu vực riêng biệt cho users, groups, và projects khiến các khách hàng trở nên "tách biệt" với nhau.

- Danh sách đăng kí các Roles được keystone dùng để ủy quyền cho các services của OpenStack thông qua file policy.

- Assignment store cho phép users và groups được gán các roles trong projects và domains.

- Catalog lưu trưc các services của OpenStack, endpoints và regions, cho phép người dùng tìm kiếm các endpoints của services mà họ cần.

### <a name="concepts"> II. Keystone Concepts </a>

#### <a name="projects"> 1. Projects </a>

- Trong Keystone, Project được dùng bởi các services của OpenStack để nhóm và cô lập các nguồn tài nguyên. Nó có thể được hiểu là 1 nhóm các tài nguyên mà chỉ có một số các user mới có thể truy cập và hoàn toàn tách biệt với các nhóm khác.

- Ban đầu nó được gọi là tenants sau đó được đổi tên thành projects.

- Mục đích cơ bản nhất của keystone chính là nơi để đăng kí cho các projects và xác định ai được phép truy cập projects.

- Bản thân projects không sở hữu users hay groups mà users và groups được cấp quyền truy cập tới project sử dụng cơ chế gán role.

- Trong một vài tài liệu của OpenStack thì việc gán role cho user còn được gọi là "grant".

#### <a name="domains"> 2. Domains </a>

- Trong thời kì đầu, không có bất cứ cơ chế nào để hạn chế sự xuất hiện của các project tới những nhóm user khác nhau. Điều này có thể gây ra những sự nhầm lẫn hay xung đột không đáng có giữa các tên của project của các tổ chức khác nhau.

- Tên user cũng vậy và nó hoàn toàn cũng có thể dẫn tới sự nhầm lẫn nếu hai tổ chức có user có tên giống nhau.

- Vì vậy mà khái niệm Domain ra đời, nó được dùng để cô lập danh sách các Projects và Users.

- Domain được định nghĩa là một tập hợp các users, groups, và projects. Nó cho phép người dùng chia nguồn tài nguyên cho từng tổ chức sử dụng mà không phải lo xung đột hay nhầm lẫn.

#### <a name="actors"> 3. Users and User Groups (Actors) </a>

- Trong keystone, Users và User Groups là những đối tượng được cấp phép truy cập tới các nguồn tài nguyên được cô lập trong domains và projects.

- Groups là một tập hợp các users. Users và User Groups được gọi là Actors.

- Mối quan hệ giữa  domains, projects, users, và groups:

<img src="http://i.imgur.com/iYkqE5O.png">

#### <a name="roles"> 4. Roles </a>

Roles được dùng để hiện thực hóa việc cấp phép trong keystone. Một actor có thể có nhiều roles đối với từng project khác nhau.

#### <a name="assignment"> 5. Assignment </a>

- Role assignment là sự kết hợp của actor, target và role.
- Role assignment được cấp phát, thu hồi, và có thể được kế thừa giữa các users, groups, project và domains.

#### <a name="target"> 6. Targets </a>

- Projects và Domains đều giống nhau ở chỗ cả hai đều là nơi mà role được "gán" lên.

- Vì thế chúng được gọi là targets.

#### <a name="token"> 7. Token </a>

- Để user truy cập bất cứ OpenStack API nào thì user cần chúng minh họ là ai và họ được phép gọi tới API. Để làm được điều này, họ cần có token và "dán" chúng vào "API call". Keystone chính là service chịu trách nhiệm tạo ra tokens.
- Sau khi được xác thực thành công bởi keystone thì user sẽ nhận được token. Token cũng chứa các thông tin ủy quyền của user trên cloud.
- Token có cả phần ID và payload. ID được dùng để đảm bảo rằng nó là duy nhất trên mỗi cloud và payload chứa thông tin của user.

#### <a name="catalog"> 8. Catalog </a>

- Chứa URLs và endpoints của các services khác nhau.
- Nếu không có Catalog, users và các ứng dụng sẽ không thể biết được nơi cần chuyển yêu cầu để tạo máy ảo hoặc lưu dữ liệu.
- service này được chia nhỏ thành danh sách các endpoints và mỗi một endpoint sẽ chứa admin URL, internal URL, and public URL.

### <a name="identity2"> III. Identity </a>

Identity service trong keystone cung cấp các Actors. Nó có thể tới từ nhiều dịch vụ khác nhau như SQL, LDAP, và Federated Identity Providers.

#### <a name="sql"> 1. SQL </a>

- Keystone có tùy chọn cho phép lưu trữ actors trong SQL. Nó hỗ trợ các database như MySQL, PostgreSQL, và DB2.
- Keystone sẽ lưu những thông tin như tên, mật khẩu và mô tả.
- Những cài đặt của các database này nằm trong file config của keystone.
- Về bản chất, Keystone sẽ hoạt động như 1 Identity Provider. Vì thế đây sẽ không phải là lựa chọn tốt nhất trong một vài trường hợp, nhất là đối với các khách hàng là doanh nghiệp.

- Sau đây là ưu nhược điểm:

Ưu điểm:

- Dễ set up
- Quản lí users, groups thông qua OpenStack APIs.

Nhược điểm:

- Keystone không nên là  một Identity Provider
- Hỗ trợ cả mật khẩu yếu
- Hầu hết các doanh nghiệp đều sử dụng LDAP server
- Phải ghi nhớ username và password.

#### <a name="ldap"> 2. LDAP </a>

- Keystone cũng có tùy chọn cho phép lưu trữ actors trong Lightweight Directory Access Protocol (LDAP).
- Keystone sẽ truy cập tới LDAP như bất kì ứng dụng khác (System Login, Email, Web Application, etc.).
- Các cài đặt kết nối sẽ được lưu trong file config của keystone. Các cài đặt này cũng bao gồm tùy chọn cho phép keystone được ghi hoặc chỉ đọc dữ liệu từ LDAP.
- Thông thường LDAP chỉ nên cho phép các câu lệnh đọc, ví dụ như tìm kiếm user, group và xác thực.
- Nếu sử dụng LDAP như một read-only Identity Backends thì Keystone cần có quyền sử dụng LDAP.
- Một số ưu nhược điểm:

Ưu điểm:

- Không cần sao lưu tài khoản người dùng.
- Keystone không hoạt động như một Identity Provider.

Nhược điểm:

- Account của các dịch vụ sẽ lưu ở đâu đó và người quản trị LDAP không muốn có tài khoản này trong LDAP.
- Keystone có thể thấy mật khẩu người dùng, lúc mật khẩu được yêu cầu authentication.

#### <a name="multiple"> 3. Multiple Backends </a>

- Kể từ bản Juno thì Keystone đã hỗ trợ nhiều Identity backends cho V3 Identity API. Nhờ vậy mà mỗi một domain có thể có một identity source (backend) khác nhau.
- Domain mặc định thường sử dụng SQL backend bởi nó được dùng để lưu các host service accounts. Service accounts là các tài khoản được dùng bởi các dịch vụ OpenStack khác nhau để tương tác với Keystone.
- Việc sử dụng Multiple Backends được lấy cảm hứng trong các môi trường doanh nghiệp, LDAP chỉ được sử dụng để lưu thông tin của các nhân viên bởi LDAP admin có thể không ở cùng một công ty với nhóm triển khai OpenStack. Bên cạnh đó, nhiều LDAP cũng có thể được sử dụng trong trường hợp công ty có nhiều phòng ban.
- Sau đây là một số ưu nhược điểm:

Ưu điểm:

- Cho phép việc sử dụng nhiều LDAP để lưu tài khoản người dùng và SQL để lưu tài khoản dịch vụ
- Sử dụng lại LDAP đã có.

Nhược điểm:

- Phức tạp trong khâu set up
- Xác thực tài khoản người dùng phải trong miền scoped

#### <a name="provider"> 4. Identity Providers </a>

- Kể từ bản Icehouse thì Keystone đã có thể sử dụng các liên kết xác thực thông qua module Apache cho các  Identity Providers khác nhau.
- Cơ bản thì Keystone sẽ sử dụng một bên thứ 3 để xác thực, nó có thể là những phần mềm sử dụng các backends (LDAP, AD, MongoDB) hoặc mạng xã hội (Google, Facebook, Twitter).

- Ưu nhược điểm:

Ưu điểm:

- Có thể tận dụng phần mềm và cơ sở hạ tầng cũ để xác thực cũng như lấy thông tin của users.
- Tách biệt keystone và nhiệm vụ định danh, xác thực thông tin.
- Mở ra cánh cửa mới cho những khả năng mới ví dụ như single signon và hybrid cloud
- Keystone không thể xem mật khẩu, mọi thứ đều không còn liên quan tới keystone.

Nhược điểm:

- Phức tạp nhất về việc setup trong các loại.

#### <a name="usecase"> 5. Các trường hợp sử dụng trong thực tế cho các backends. </a>

| Identity Source | Use Cases |
|-----------------|-----------|
| SQL | - Testing hoặc developing với OpenStack <br> - Ít users <br> - OpenStack-specific accounts (service users) |
| LDAP | - Nếu có sẵn LDAP trong công ty <br> - Sử dụng một mình LDAP nếu bạn có thể tạo service accounts trong LDAP |
| Multiple Backends | - Được sử dụng nhiều trong các doanh nghiệp <br> - Dùng nếu service user không được cho phép trong LDAP |
| Identity Provider | - Nếu bạn muốn có những lợi ích từ cơ chế mới Federated Identity <br> - Nếu đã có sẵn identity provider <br> - Keystone không thể kết nối tới LDAP <br> - Non-LDAP identity source |


### <a name="authentication2"> III. Authentication </a>

Có rất nhiều cách để xác thực với Keystone service, trong đó 2 phương thức được dùng nhiều nhất là password và token.

#### <a name="password"> 1. Password </a>

- Phương thức phổ biến nhất cho user hoặc service để xác thực đó là dùng password. Đoạn payload phía dưới là ví dụ cho POST request tới Keystone. Người dùng có thể nhận được những thông tin cần thiết cho việc xác thực.

<img src ="http://i.imgur.com/vWQrqIQ.png">

- Payload phải chưa đủ thông tin để tìm kiếm, xác thực users và lấy danh sách catalog service (tùy chọn) dựa theo quyền của user trên project cụ thể.

- user section nhận diện thông tin domain trừ khi user’s globally unique ID được sử dụng để tránh nhầm lẫn giữa các user trùng tên.

- scope section là tùy chọn nhưng thường được sử dụng để user thu thập service catalog. Scope được sử dụng để xác định project nào user được làm việc. Nếu user không có role on the project, request sẽ bị loại bỏ. Tương tự như user section, scope section phải có đủ information về project để tìm nó, domain phải được chỉ định, bởi project name cũng có thể trùng nhau giữa các domain khác nhau. Trừ khi cung cấp project ID(duy nhất trên tất cả các domain), khi đó không cần thông tin domain nữa.

- User request token bằng username, password và project scope. Token sau đó sẽ được sử dụng ở các OpenStack service khác.

<img src="http://i.imgur.com/PIyPsWF.png">

#### <a name="token2"> 2. Token </a>

- Giống như password, user có thể yếu cầu 1 token mới từ token hiện tại. Payload của POST request này sẽ ít code hơn của password.

<img src="http://i.imgur.com/ukesVZq.png">

<img src="http://i.imgur.com/R4r6VHM.png">

### <a name="authorization2"> IV. Access Management and Authorization </a>

Quản lí truy cập và quy định users được sử dụng APIs nào là một trong những yếu tố quyết định khiến Keystone trở nên quan trọng trong OpenStack. Về bản chất, Keystone sẽ tạo ra Role-Based Access Control (RBAC) policytrên mỗi một public APIs endpoints. Các policies này nằm trên file policy.json.

Dưới đây là một ví dụ về file policy.json, chứa targets và rules. Targets nằm bên trái và rules nằm ở phía bên phải. Trên đầu file, targets được thiết lập để xác định admin, owner và những user khác.

<img src="http://i.imgur.com/i0QhfdT.png">

Mỗi rule sẽ bắt đầu với `identity:` và xác định 1 controller có quyền quản lí API. Những targets đã được thiết lập được dùng để bảo vệ những targets mới. Bảng dưới đây mô tả việc mapping và bảo vệ giữa target và API.

<img src="http://i.imgur.com/y2KgF0o.png">

### <a name="services"> V. Backends and Services </a>

Hình dưới đây là bản tóm tắt cho các services và backends đi kèm. Phần màu xanh lá cây thường sử dụng SQL. Phần màu đỏ là backend thường sử dụng LDAP hoặc SQL, phần màu xanh da trời thường sử dụng SQL hoặc Memcache. Còn policy service sẽ được lưu dưới dạng file. Ngoài ra Keystone còn có thêm các services khác tuy nhiên đây là những services được dùng phổ biến nhất.

<img src="http://i.imgur.com/cf8VpxI.png">
