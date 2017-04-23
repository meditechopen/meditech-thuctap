# Tìm hiểu về SSH
================================
## Mục lục

### [1. Khái niệm](#khainiem)

### [2. Đặc điểm](#dacdiem)
  - [2.1 Tính bí mật](#bimat)
  - [2.2 Tính toàn vẹn](#toanven)
  - [2.3 Tính xác thực](#xacthuc)
  - [2.4 Giấy phép](#giayphep)
  - [2.5 Chuyển tiếp hoặc tạo đường hầm](#chuyentiep)


### [3. Cấu trúc](#cautruc)
### [4. Cơ chế hoạt động](#coche)
### [5. Một số thuật toán dùng trong SSH](#thuattoan)


======================================

 <a name="khainiem"></a>
### 1.Khái niệm

  `SSH (Secure Shell)` là một giao thức mạng dùng để kết nối mạng một cách bảo mật. SSH hoạt động ở các lớp trên trên mô hình TCP/IP. Các công cụ SSH như OpenSSH, Putty,...cung cấp cho người sử dụng cách thức để kết nối mạng được mã hóa để tạo một kênh kết nối riêng tư.Hơn nữa tính năng Tunneling ( hay còn gọi là Port forwarding) của các công cụ này cho phép truyền tải các giao vận theo các giao thức khác nhau.Do vậy khi xây dựng một hệ thống SSH ,chúng ta sẽ thấy như là đang xây dựng một hệ thống VPN đơn giản.

  Mỗi khi dữ liệu được đưa vào mạng, SSH sẽ tự động mã hóa nó, và khi dữ liệu đến đích, SSH sẽ tự động giải mã dữ liệu.Kết quả là việc mã hóa và giải mã được thực hiện một cách trong suốt và người dùng hoàn toàn không biết được các dữ liệu truyền đi của mình bị mã hóa và giải mã.

<a name="dacdiem"></a>
### 2.Đặc điểm

  SSH có 5 đặc điểm thuyết phục người dùng sử dụng nó :

<a name="bimat"></a>
#### 2.1 Tính bí mật(Privacy)
  Tính bí mật nghĩa là đảm bảo dữ liệu máy tính không bị lộ.SSH cũng cấp tính bí mật bằng cách mã hóa dữ liệu đi qua mạng.Đó là việc mã hóa hai đầu dựa trên khóa ngẫu nhiên(sinh ra để phục vụ cho một phiên kết nối và hủy đi khi phiên kết nối hoàn thành).SSH hỗ trợ nhiều chuẩn mã hóa dữ liệu: AES,DES,....

<a name="toanven"></a>
#### 2.2 Tính toàn vẹn (Intergity)
  Tính toàn vẹn có nghĩa là đảm bảo dữ liệu được truyền từ nguồn đến đích mà không bị thay đổi.SSH sử dụng phương thức kiểm tra toàn vẹn mật mã, phương pháp này giúp kiểm tra dữ liệu có được toàn vẹn hay không và xác định gói tin đến có đúng nguồn hay không.Nó sử dụng thuật toán mã hóa băm MD5, SHA-1.

<a name="xacthuc"></a>
#### 2.3 Tính xác thực (Authencation)
  Chứng minh, xác thực , định danh một ai đó có chính xác hay không.Mỗi phiên SSH bao gồm 2 việc xác thực : Client xác thực định danh của Server ( Server authencation) và Server xác thực định danh của người sử dụng (User authencation).
  Server authencation chắc chắn rằng SSH server là chính xác để tránh việc phòng kẻ tấn công gửi đến một kết nối đến máy khác.Đồng thời nó cũng đảm bảo việc không để có một máy tính nào đứng giữa Client SSH và Server SSH.
  User authencation thường là làm việc với mật khẩu.Để xác thực định danh thì người cần định danh phải đưa ra mật khẩu và rất dễ bị lấy cắp.Vì vật SSH hỗ trợ việc mã hóa mật khẩu, đảm bảo mật khẩu không ở dạng rõ khi lưu truyền trên mạng.Đây là điểm vượt trội so với các phương thức khác như Telnet hoặc FTP,...Tuy nhiên SSH còn cung cấp một cơ chế chứng thực mạnh hơn và dễ sử dụng hơn : mỗi user có nhiều chữ ký khóa công cộng ( per-user public key signature) và một cải tiến rlogin-style xác thực với định danh host được kiểm tra bằng khóa công khai.

<a name="giayphep"></a>
#### 2.4 Giấy phép(Authorization)
  Việc cấp giấy phép xác định ai có thể hay không thể làm gì lên một đối tượng nào đó.Và nó diễn ra ngay sau khi xác thực để xác định quyền hạn của người truy cập được thực hiện những gì lên hệ thống.

<a name="Chuyển tiếp"></a>
#### 2.5 Chuyển tiếp (Forwarding) hoặc tạo đường hầm (Tunneling)
  Chuyển tiếp hoặc tạo đường hầm là tóm lược dịch vụ TCP khác như là Telnet hoặc IMAP trong một phiên SSH mang lại hiệu quả bảo mật của SSH đến với các dịch vụ dựa trên TCP khác.
  SSH hỗ trợ 3 kiểu chuyển tiếp :
  <ul>
  <li>`TCP Forwading` : SSH dùng TCP/IP làm cơ chế truyền , thường dùng port 22 trên máy server khi nó mã hóa và giải mã lưu lượng đi trong mạng. Ở đây chúng ta đang nói đến một đặc điễm mã hóa và giải mã lưu lượng TCP/IP thuộc về ứng dụng khác, trên cổng TCP khác dùng SSH.Tiến trình này gọi là Port forwarding, nó có tính trong suốt cao và khá mạnh.
  Tuy nhiên , SSH port forwading chỉ hoạt động trên giao thức TCP và không làm việc được trên các giao thức khác như UDP hay Apple Talk.
  </li>
  <li>`X Forwading` : X là một hệ thống windows phổ biến đối với các trạm làm việc Unix, một trong những đặc điểm tốt nhất của nó là tính trong suốt, Sử dụng X bạn có thể chạy ứng dụng X từ xã để mở các của sổ của chúng ta trên màn hinh hiển thị cục bộ của bạn.</li>
  <li>`Agent Forwading` : SSH cliet có thể làm ciệc với một SSH agent trên cùng một máy. Sử dụng một đặc trưng gọi là Agent forwading , client cũng có thể liên lác với các agent trên những máy từ xa. Điều thuận lợi là nó cho phép client trên nhiều máy làm việc với một Agent và có thê tránh vấn đề liên quan đến tường lửa.</li>
  </ul>

<a name="cautruc"></a>
### 3. Cấu trúc
  <img src=http://i.imgur.com/ruzfhQ1.jpg>

Các thành phần trong SSH :
  - `Server`:  Một chương trình cho phép đi vào kết nối SSH với một bộ máy, trình bày xác thực, cấp phép,... Trong hầu hết SSH bổ sung của Unix thì server thường là SSHD.
  - `Client` : Một chương trình kết nối đến SSH server và đưa ra yêu cầu như là `log me in` hoặc `coppy this file` . Trong SSH1, SSH2 và OpenSSH, client chủ yếu là ssh và scp.
  -`Session` : Một phiên kết nối giữa một clien và một server. Nó bắt đầu sau khi clien xác thực thành công và kết thúc khi kết nối chấm dứt.Session có thể được tương tác với nhau hoặc có thể là một chuyến riêng.
  -`Key` : Một lượng dữ liệu tương đối nhỏ , thông thường từ mười đến một hoặc hai nghìn bít. Tính hữu tỉ của việc sử dụng thuật toán ràng buộc khóa hoạt động trong một vài cách để giữ khóa. Có 2 loại khóa : khóa đối xứng hoặc bất đối xứng hay còn gọi là khóa bí mật và khóa công khai.
  SSH đề cập đến 4 loại khóa

  - `User key` : là một thực thể tồn tại lâu dài, là khó bất đối xứn sử dụng bởi client như một sự chứng minh nhận dạng của user.
  - `Host key` : là một thưc thể tồn tại lâu dài, là khóa bất đối xứng sử dụng với server như sự chứng minh nhận dạng của nó, cũng như được dùng bởi client khi chứng minh nhận dạng của host của nó như một phần xác thực đáng tin.
  - `Server key` : Tồn tại tạm thời, là khoá bất đối xứng dùng trong giao thức SSH-1. Nó đựợc tái tạo bởi server theo chu kỳ thường xuyên ( mặc định là mỗi giờ) và bảo vệ session key. Thường bị lộn với host key. Khoá này thì không bao giờ được lưu trên đĩa và thành phần bí mật của nó không bao giờ được truyền qua kết nối ở bất cứ dạng nào, nó cung cấp. “perfect forward secrecy” cho phiên SSH-1.
  - `Session key` : Là một giá trị phát sinh ngẫu nhiên, là khoá đối xứng cho việc mã hoá truyền thông giữa một SSH client và SSH server. Nó được chia ra làm 2 thành phần cho client và server trong một loại bảo bật trong suốt quá trình thiết lập kết nối SSH để kẻ xấu không phát hiện được nó.
  - `Key generator` : Một chương trình tạo ra những loại khoá lâu dài( user key và host key) cho SSH. SSH1, SSH2 và OpenSSH có chương trình ssh-keygen.
  - `Agent` : Một chương trình lưu user key trong bộ nhớ. Agent trả lời cho yêu cầu đối với khoá quan hệ hoạt động như là kí hiệu một giấy xác thực nhưng nó không tự phơi bày khoá của chúng. Nó là một đặc điểm rất có ích. SSH1, SSH2 và OpenSSH có agent ssh-agent và chương trình ssh-add để xếp vào và lấy ra khoá được lưu.
  - `Signer` : Một chương trình kí hiệu gói chứng thực hostbased.
  - `Random seed` : Một dãy dữ liệu ngẫu nhiên đựoc dùng bởi các thành phần SSH để khởi chạy phần mềm sinh số ngẫu nhiên.
  - `Configuration file` : Một chồng thiết lập để biến đổi hành vi của một SSH client hoặc SSH server. Không phải tất cả thành phần đều được đòi hỏi trong một bản bổ sung của SSH. Dĩ nhiên những server, client và khoá là bắt buộc nhưng nhiều bản bổ sung không có agent và thậm chí vài bản không có bộ sinh khoá.

<a name="coche"></a>
### 4. Cơ chế hoạt động
Một phiên làm việc của SSH2 đều trải qua 4 bước :
  - Thiết lập kết nối ban đầu (SSH-TRANS)
  - Tiến hành xác thực(SSH-AUTH)
  - Mở phiên kết nối thực hiện các nhiệm vụ (SSH-CONN)
  - Chạy các ứng dụng (Có thể là SSH-SFTP, SCP)

SSH-TRANS là khối xây dựng cơ bản cung cấp kết nối ban đầu, ghi chép giao thức, xác thực Server, mã hóa cơ bản và bảo toàn dữ liệu. Sau khi thiết lập kết nối, client có một kết nối độc lập và bảo mật.

Sau đó, client dùng SSH-AUTH để xác thực đến Server, SSH-AUTH yêu cầu một phương thức: Public key với thuật toán DSS. Ngoài ra sử dụng mật khẩu và hostbase.

Sau khi xác thực, SSH client yêu cầu SSH-CONN để cung cấp một kênh riêng biết qua SSH-TRANS.

Ngoài ra , còn cung cấp các dịch vụ nư Remote Login and Command Execution, agent forwading, files transfer, TCP port Fowarding, X Fowarding,...

Cuối cùng, một ứng dụng có thể sử dụng SSH-SFTP hoặc SCP truyền file hoặc thao tác remote từ xa.

<a name="thuạttoan"></a>
### 5. Một số thuật toán trong SSH

`Thuật toán Public-keys (Khóa công khai)` :
  - RSA: là thuật toán mã hóa bất đối xứng, dùng cho mã hóa và chữ ký.
  - DSA: dùng chữ ký số.
  - Thuật toán thỏa thuận Diffie-Hellman: cho phép 2 bên lấy được khóa được chia sẻ trên một kênh mở.

`Thuật toán Private-keys (Khóa bí mật)` :
  - AES: là một thuật toán mã hóa khối, chiều dài có thể là 128 đến 256bit.
  - DES: là một thuật toán mã hóa bảo mật.
  - 3DES: cải tiến của DES, tăng độ dài của khóa để đạt độ bảo mật cao hơn.
  - RC4: Kiểu mã hóa nhanh, nhưng kém bảo mật.
  - Blowfish: là một thuật toán mã hóa miễn phí, có tốc độ mã hóa nhanh hơn DES, nhưng chậm hơn RC4. Độ dài của key từ 32 đến 448bit.

`Hàm băm (HASH)`:
  - CRS-32: Băm dữ liệu nhưng không mã hóa. Chỉ sử dụng để kiểm tra tính toàn vẹn của gói tin, tránh thay đổi thông tin trên đường truyền.
  - MD5: Hàm băm có độ an toàn cao vì được mã hóa dữ liệu, với chiều dài là 128bit.
  - SHA-1: Một cải tiến của MD5, với chiều dài là 160bit.
