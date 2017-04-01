# Cung cấp key cho người dùng
## Tạo khóa RSA bằng lệnh 

```ssh-keygen -t rsa -b 1024```

Tại đây ta đặt tên file và mật khẩu cho người thứ nhất muốn truy cập vào máy chủ. Ví dụ ở đây mình đặt tên file là meditech và mật khẩu truy cập file là meditech

<img src="http://i.imgur.com/X5rLthO.png">

key sẽ được lưu trong thư mục /home/meditech/.ssh

Trong file cấu hình ta cài đặt như sau :

```sh
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile     %h/.ssh/authorized_keys
UsePAM no
PermitEmptyPasswords no
```


Sau đó copy file meditech ra ngoài máy remote (dùng winSPC)
**SCP là gì?**

- SCP (Secure Copy – Sao chép an toàn) là một ứng dụng sử dụng SSH để mã hóa toàn bộ quá trình chuyển tập tin.
- SCP là lệnh dùng để di chuyển file dữ liệu giữa các máy tính chạy hệ điều hành Linux từ xa chỉ cần biết địa chỉ ip
- SCP dùng ssh để di chuyển dữ liệu, có chế độ bảo mật giống như ssh.
 

và dùng mobaxterm để load file để tạo key đăng nhập.

<img src="http://i.imgur.com/VG4044w.png">

**note**

- Trong file sshd_config bỏ comment đường dẫn đến nơi lưu key public 
- Trong đường dẫn mặc định là /.ssh/authorized_key nên chúng ta cần phải tạo thêm thư mục ~/.ssh/authorized để copy đoạn mã hóa của file pulic vào.

```sh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_key
```
- Chú ý độ dài bit mặc định trong file sshd_config 
vào tool trong mobaxterm chọn 

<img src="http://i.imgur.com/rASGWIe.png">

- Chọn file chứa key private ra và nhập pass của file đó. Sau khi load xong ta lưu lại private key với đuôi .ppk
- Copy đoạn mã file public vào thư mục ~/ssh/authorized_key trong server. 

<img src="http://i.imgur.com/euAve5p.png">

Mở mobaxterm lên chọn các thông số như địa chỉ host và chọn đường dẫn file .ppk vừa tạo.

<img src="http://i.imgur.com/TTYAFO5.png">

Kết quả:

<img src="http://i.imgur.com/V50xrHt.png">


