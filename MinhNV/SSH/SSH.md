
# Tìm hiểu về SSH
## 1. Khái niệm 
- SSH (tiếng Anh: Secure Shell) là 1 giao thức mạng dùng để thiết lập kết nối mạng 1 cách bảo mật.
- SSH hoạt động ở lớp trên trong mô hình phân lớp TCP/IP.
- Các công cụ SSH (như là OpenSSH, PuTTy,…) cung cấp cho người dùng cách thức để thiết lập kết nối mạng được mã hoá để tạo 1 kênh kết nối riêng tư.
- Hơn nữa tính năng tunneling (hoặc còn gọi là port forwarding) của các công cụ này cho phép chuyển tải các giao vận theo các giao thức khác.
- Mỗi khi dữ liệu được gửi bởi 1 máy tính vào mạng, SSH tự động mã hoá nó. Khi dữ liệu được nhận vào, SSH tự động giải mã nó.
- Kết quả là việc mã hoá được thực hiện trong suốt.

**Ưu điểm**: SSH là một chương trình tương tác giữa máy chủ và máy khách có sử dụng cơ chế mã hoá đủ mạnh nhằm ngăn chặn các hiện tượng nghe trộm, đánh cắp thông tin trên đường truyền. Các chương trình trước đây: telnet, rlogin không sử dụng phương pháp mã hoá. Vì thế bất cứ ai cũng có thể nghe trộm thậm chí đọc được toàn bộ nội dung của phiên làm việc bằng cách sử dụng một số công cụ đơn giản. Sử dụng SSH là biện pháp hữu hiệu bảo mật dữ liệu trên đường truyền từ hệ thống này đến hệ thống khác.

## Các đặc điểm chính của giao thức ssh
- Tính bảo mật (Privacy): mã hoá dữ liệu dựa trên khoá ngẫu nhiên. (AES, DES, 3DES, ARCFOUR ...)
- Tính toàn vẹn (integrity): đảm bảo thông tin không bị biến đổi bằng phương pháp kiểm tra toàn vẹn mật mã (MD5 và SHA-1.).
- Chứng minh xác thực (authentication): kiểm tra định danh của ai đó để xác định đúng là người đó hay không
- Giấy phép (authorization) :dùng để điều khiển truy cập đến tài khoản.Quyết định ai đó có thể hoặc không thể làm gì.
- Chuyển tiếp (forwarding) hoặc tạo đường hầm (tunneling) để mã hoá những phiên khác dựa trên giao thức TCP/IP.
 
SSH hỗ trợ 3 kiểu chuyển tiếp :

 -  TCP port forwarding: SSH dùng TCP/IP làm cơ chế truyền, thường dùng port 22 trên máy server khi nó mã hoá và giải mã lưu lượng đi trên mạng. Ở đây chúng ta nói đến một đặc điểm mã hoá và giải mã lưu lựong TCP/IP thuộc về ứng dụng khác, trên cổng TCP khác dùng SSH. Tiến trình này gọi là port forwarding, nó có tính trong suốt cao va khá mạnh. Telnet, SMTP, NNTP, IMAP và những giao thức không an toàn khác chạy TCP có thể được bảo đảm bằng việc chuyển tiếp kết nối thông qua SSH. Port forwarding đôi khi được gọi là tunneling bởi vì kết nối SSH cung cấp một “đường hầm” xuyên qua để kết nối TCP khác có thể đi qua. Giả sử bạn có một máy H ở nhà đang chạy IMAP và bạn muốn kết nối đến một IMAP server trên máy S để đọc và gửi mail. Bình thường thì việc kết nối này không đảm bảo an toàn, tài khoản và mật khẩu mail của bạn được truyền đi dưới dạng clear text giữa chương trình mail của bạn và server. Đối với SSH port forwarding, bạn có thể định tuyến lại trong suốt kết nối IMAP ( tìm cổng TCP 143 trên server S) để truyền đi thông qua SSH, mã hoá bảo đảm dữ liệu truyền đi trên kết nối. Máy IMAP server phải chạy một SSH server cho port forwarding để cung cấp việc bảo đảm đó. Tuy nhiên, SSH port forwarding chỉ hoạt động trên giao thức TCP và không làm việc được trên các giao thức khác như UDP hay AppleTalk

 -  Forwarding : X là một hệ thống window phổ biến đối với các trạm làm việc Unix, một trong những đặc điểm tốt nhất của nó là tính trong suốt. Sử dụng X bạn có thể chạy ứng dụng X từ xa để mở các cửa sổ của chúng trên màn hình hiển thị cục bộ của bạn

 -  Agent forwarding : SSH client có thể làm việc với một SSH agent trên cùng một máy. Sử dụng một đặc trưng gọi là agent forwarding, client cũng có thể liên lạc với các agent trên những máy từ xa. Điều thuận lợi là nó cho phép client trên nhiều máy làm việc với một agent và có thể tránh vấn đề liên quan đến tường lửa.

## Các thành phần trong SSH

<img src="http://docstore.mik.ua/orelly/networking_2ndEd/ssh/figs/ssh_0301.gif">

- Server : Một chương trình cho phép đi vào kết nối SSH với một bộ máy, trình bày xác thực, cấp phép, … Trong hầu hết SSH bổ sung của Unix thì server thường là sshd.
- Client : Một chương trình kết nối đến SSH server và đưa ra yêu cầu như là “log me in” hoặc “copy this file”. Trong SSH1, SSH2 và OpenSSH, client chủ yếu là ssh và scp.
- Session : Một phiên kết nối giữa một client và một server. Nó bắt đầu sau khi client xác thực thành công đến một server và kết thúc khi kết nối chấm dứt. Session có thể được tương tác với nhau hoặc có thể là một chuyến riêng.
## key
### Khái niệm:
Key : Một lượng dữ liệu tương đối nhỏ, thông thường từ mười đến một hoặc hai ngàn bit. Tính hữu ích của việc sử dụng thuật toán ràng buộc khoá hoạt động trong vài cách để giữ khoá: trong mã hoá, nó chắc chắn rằng chỉ người nào đó giữ khoá (hoặc một ai có liên quan) có thể giải mã thông điệp, trong xác thực, nó cho phép bạn kiểm tra trễ rằng người giữ khoá thực sự đã kí hiệu vào thông điệp.

 Có hai loại khóa: khoá đối xứng hoặc khoá bí mật và khoá bất đối xứng hoặc khóa công khai. Một khoá bất đối xứng hoặc khoá công khai có hai phần: thành phần công khai và thàn phần bí mật.

### Các kiểu key:
- User key : Là một thực thể tồn tại lâu dài, là khoá bất đối xứng sử dụng bởi client như một sự chứng minh nhận dạng của user ( một người dùng đơn lẻ có thể có nhiều khoá).

- Host key : Là một thực thể tồn tại lâu dài, là khoá bất đối xứng sử dụng bới server như sự chứng minh nhận dạng của nó, cũng như được dùng bởi client khi chứng minh nhận dạng host của nó như một phần xác thực đáng tin. Nếu một bộ máy chạy một SSH server đơn, host key cũng là cái duy nhất để nhận dạng bộ máy đó. Nếu bộ máy chạy nhiều SSH server, mỗi cái có thể có một host key khác nhau hoặc có thể dùng chung. Chúng thường bị lộn với server key.

- Server key : Tồn tại tạm thời, là khoá bất đối xứng dùng trong giao thức SSH-1. Nó đựợc tái tạo bởi server theo chu kỳ thường xuyên ( mặc định là mỗi giờ) và bảo vệ session key. Thường bị lộn với host key. Khoá này thì không bao giờ được lưu trên đĩa và thành phần bí mật của nó không bao giờ được truyền qua kết nối ở bất cứ dạng nào, nó cung cấp “perfect forward secrecy” cho phiên SSH-1.

- Session key : Là một giá trị phát sinh ngẫu nhiên, là khoá đối xứng cho việc mã hoá truyền thông giữa một SSH client và SSH server. Nó được chia ra làm 2 thành phần cho client và server trong một loại bảo bật trong suốt quá trình thiết lập kết nối SSH để kẻ xấu không phát hiện được nó.

- Key generator : Một chương trình tạo ra những loại khoá lâu dài( user key và host key) cho SSH. SSH1, SSH2 và OpenSSH có chương trình ssh-keygen.

- Agent : Một chương trình lưu user key trong bộ nhớ. Agent trả lời cho yêu cầu đối với khoá quan hệ hoạt động như là kí hiệu một giấy xác thực nhưng nó không tự phơi bày khoá của chúng. Nó là một đặc điểm rất có ích. SSH1, SSH2 và OpenSSH có agent ssh-agent và chương trình ssh-add để xếp vào và lấy ra khoá được lưu.

- Signer : Một chương trình kí hiệu gói chứng thực hostbased.

- Random seed : Một dãy dữ liệu ngẫu nhiên đựoc dùng bởi các thành phần SSH để khởi chạy phần mềm sinh số ngẫu nhiên.

- Configuration file : Một chồng thiết lập để biến đổi hành vi của một SSH client hoặc SSH server. Không phải tất cả thành phần đều được đòi hỏi trong một bản bổ sung của SSH. Dĩ nhiên những server, client và khoá là bắt buộc nhưng nhiều bản bổ sung không có agent và thậm chí vài bản không có bộ sinh khoá.



Khi tạo ra một SSH Key, bạn cần biết sẽ có 3 thành phần quan trọng như sau:

- Public Key (dạng file và string) – Bạn sẽ copy ký tự key này sẽ bỏ vào file ~/.ssh/authorized_keys trên server của bạn.
- Private Key (dạng file và string) – Bạn sẽ lưu file này vào máy tính, sau đó sẽ thiết lập cho PuTTY, WinSCP, MobaXterm,..để có thể login.
- Keypharse (dạng string, cần ghi nhớ) – Mật khẩu để mở private key, khi đăng nhập vào server nó sẽ hỏi cái này.

## Cơ chế hoạt động:

Một phiên làm việc của SSH2 đều phải trải qua 4 bước

 - Thiết lập kết nối ban đầu (SSH-TRANS)
 - Tiến hành xác thực (SSH-AUTH)
 - Mở phiên kết nối để thực hiện các dịch vụ (SSH-CONN)
 - Chạy các ứng dụng SSH (Có thể là SSH-SFTP, SCP)


SSH-TRANS: là khối xây dựng cơ bản cung cấp kết nối ban đầu, ghi chép giao thức, xác thực server, mã hóa cơ bản và bảo toàn dữ liệu. Sau khi thiết lập kết nối, client có một kết nối độc lập và bảo mật

Sau đó, client dùng SSH-AUTH để xác thực đến server. SSH-AUTH yêu cầu một phương thức: Public key với thuật toán DSS. Ngoài ra, sử dụng mật khẩu và hostbased

Sau khi xác thực, SSH client yêu cầu SSH-CONN để cung cấp một kênh riêng biệt qua SSH-TRANS

Ngoài ra, còn cung cấp các dịch vụ như Remote Login and Command Execution, agent fowarding, files transfer, TCP port fowarding, X fowarding,...

Cuối cùng, một ứng dụng có thể sử dụng SSH-SFTP hoặc SCP truyền file hoặc thao tác remote từ xa

## Một số thuật toán trong SSH

### Thuật toán Public-keys (Khóa công khai)

- RSA: là thuật toán mã hóa bất đối xứng, dùng cho mã hóa và chữ ký
- DSA: dùng chữ ký số
- Thuật toán thỏa thuận Diffie-Hellman: cho phép 2 bên lấy được khóa được chia sẻ trên một kênh mở
### Thuật toán Private-keys (Khóa bí mật)

- AES: là một thuật toán mã hóa khối, chiều dài có thể là 128 đến 256bit.
- DES: là một thuật toán mã hóa bảo mật
- 3DES: cải tiến của DES, tăng độ dài của khóa để đạt độ bảo mật cao hơn
- RC4: Kiểu mã hóa nhanh, nhưng kém bảo mật
Blowfish: là một thuật toán mã hóa miễn phí, có tốc độ mã hóa nhanh hơn DES, nhưng chậm hơn RC4. Độ dài của key từ 32 đến 448bit.
### Hàm băm (HASH)

- CRS-32: Băm dữ liệu nhưng không mã hóa. Chỉ sử dụng để kiểm tra tính toàn vẹn của gói tin, tránh thay đổi thông tin trên đường truyền
- MD5: Hàm băm có độ an toàn cao vì được mã hóa dữ liệu, với chiều dài là 128bit.
- SHA-1: Một cải tiến của MD5, với chiều dài là 160bit.

# SSH truy nhập từ xa để quản trị máy chủ
- Cài đặt SSH:
 
sử dụng lệnh ``sudo apt-get install openssh-server``

- Khởi động SSH

sử dụng lệnh ``sudo /etc/init.d/ssh start``

- Cấu hình SSH trong file hệ thống sshd.conf`

``sudo vi /etc/ssh/sshd_config``

<img src="http://i.imgur.com/ga3Djrh.png">

Trong đó:
ListenAddress 0.0.0.0 : Chỉ cho phép đăng nhập SSH từ một IP cố định.

RSAAuthentication yes : xác thực bằng thuật toán rsa

PubkeyAuthentication yes : xác thực khóa công khai

AuthorizedKeysFile  %h/.ssh/authorized_keys : đường dẫn file authorized key (file chứa public-key)

Port 22 : cổng mặc định của SSH Server

PermitRootLogin no : cho phép user root đăng nhập qua kết nối SSH

PasswordAuthentication yes : cho phép đăng nhập bằng password.

- Sau đó lưu thay đổi lại ``` sudo /etc/init.d/ssh restart ```

## CÁCH TẠO KẾT NỐI QUẢN TRỊ SERVER TỪ XA
Chúng ta sẽ dùng SSH Client tạo kết nối đến SSH Server để làm việc với máy chủ.

trong máy Ubuntu client gõ lệnh 

```ssh <host name server>@<địa chỉ IP server>```

server sẽ yêu cầu cung cấp mật khẩu. Sau khi nhập mật khẩu ta sẽ điều khiển máy server

<img src="http://i.imgur.com/I8UqCt1.png">




