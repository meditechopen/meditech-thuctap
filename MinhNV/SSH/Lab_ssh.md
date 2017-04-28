# Mô hình 

<img src="http://i.imgur.com/Td5OyHw.png">

# Kịch bản 

- Từ máy client tạo ra 1 cặp key sử dụng thuật toán rsa 
- Sau đó copy file key public lên server

# Các bước 

## Bước 1: Từ máy client tạo 1 cặp key private và public sử dung thuật toán rsa với độ dài 1024 bit

```ssh-keygen -t rsa -b 1024```

## Bước 2: Copy file id_rsa.pub sang máy server 
- Sử dụng scp: 

<img src="http://i.imgur.com/ONnVnww.png">

## Bước 3: Tạo file authorized_keys chứa file .pub vừa copy từ máy client sang. 
- Tạo file /root/.ssh
- Tạo file /root/.ssh.authorized_key
- Cấp quyền cho 2 file vừa tạo
``sh
chmod 700 /root/.ssh
chmod 600 /root/.ssh.authorized_keys
``
- Copy .pub trong server vào authorized_keys

## Bước 4: Cấu hình file sshd_config trong server
 
Chú ý ta sẽ sửa thành như sau: 

```sh
RSAAuthentication yes / cho phép dùng key đăng nhập
PubkeyAuthentication yes
AuthorizedKeysFile     %h/.ssh/authorized_keys / đường đẫn file public
UsePAM no
PermitEmptyPasswords no /cho phép đăng nhập vào hệ thống mà không cần mật khẩu
```
## Bước 4: Từ máy client ssh đến máy server

<img src="http://i.imgur.com/1Ll14V7.png">

## Note 

- Nếu 2 máy cùng sử dụng hệ điều hành Ubuntu thì ta sử dụng câu lệnh để từ máy client copy public key sang máy server
- Trên máy client sử dụng lệnh: 
```ssh-copy-id user@IP_hostname```




