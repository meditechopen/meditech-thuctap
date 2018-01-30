


## Xác thực 2 bước khi SSH sử dụng Google Authenticator’s Two-Factor 


#### Bước 1: Install Google Authenticator

- Ubuntu14:

`apt-get -y install libpam-google-authenticator`

- Centos7

install EPEL:

`yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm`

install `ibpam-google-authenticator`:

`yum install google-authenticator`

#### Bước 2: Tạo key 

`google-authenticator`

Sau đó sẽ trả về kết quả:

<img src="https://i.imgur.com/oc1hoET.png">

```sh
Do you want me to update your "/root/.google_authenticator" file (y/n) y

Do you want to disallow multiple uses of the same authentication
token? This restricts you to one login about every 30s, but it increases
your chances to notice or even prevent man-in-the-middle attacks (y/n) y

By default, tokens are good for 30 seconds and in order to compensate for
possible time-skew between the client and the server, we allow an extra
token before and after the current time. If you experience problems with poor
time synchronization, you can increase the window from its default
size of 1:30min to about 4min. Do you want to do so (y/n) y

If the computer that you are logging into isn't hardened against brute-force
login attempts, you can enable rate-limiting for the authentication module.
By default, this limits attackers to no more than 3 login attempts every 30s.
Do you want to enable rate-limiting (y/n) y
```

#### Bước 3: Sử dụng điện thọai tải app `Google Authenticator` 

Cách 1: Scan barcode - Xác thực bằng mã QR vừa gen ra.
Cách 2: Manual entry - Sử dụng secret key được gen ra. 

#### Bước 4: Chỉnh sửa file cấu hình ssh phía server 

- Thêm vào file cấu hình `/etc/pam.d/sshd` dòng sau 

    ``auth required pam_google_authenticator.so``

- Chỉnh sửa option `ChallengeResponseAuthentication` thành `yes`

- Khởi động lại service ssh 

    ``service ssh restart``

#### Bước 5: SSH tới server của bạn 

```sh
$ssh root@192.168.100.93
Password: 
Verification code: 
```

Sau khi nhập password xong ta mở ứng dụng `Google Authenticator` ở điện thoại ra lấy mã code để xác thực. 


 
