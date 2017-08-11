# Cài đặt SSMTP trên Ubuntu 14.04
- Update Ubuntu Repository

``apt-get update``

- Cài đặt SSMTP 

``apt-get install ssmtp``

- Sửa file cấu hình 

``vi /etc/ssmtp/ssmtp.conf``

Thay đổi thông tin như sau 

```sh
# Config file for sSMTP sendmail
#
# The person who gets all mail for userids < 1000
# Make this empty to disable rewriting.
#root=postmaster
root=MyEmailAddress@gmail.com

# The place where the mail goes. The actual machine name is required no
# MX records are consulted. Commonly mailhosts are named mail.domain.com
#mailhub=mail
mailhub=smtp.gmail.com:587

AuthUser=MyEmailAddress@gmail.com
AuthPass=MyPassword
UseTLS=YES
UseSTARTTLS=YES

# Where will the mail seem to come from?
# rewriteDomain=
rewriteDomain=localhost

# The full hostname
#hostname=MyMediaServer.home
hostname=localhost

# Are users allowed to set their own From: address?
# YES - Allow the user to specify their own From: address
# NO - Use the system generated From: address
FromLineOverride=YES
```

- Trong đó : 
	+ Mailhub:  Nếu dùng tài khoản Office365 thì ta điền vào là "smtp.office365.com:587" và đối với tài khoản Gmail sử dụng "smtp.gmail.com:587".
	+ AuthUser và AuthPass: nên là địa chỉ email và mật khẩu thực của bạn cho tài khoản Gmail hoặc Office365.
	+ hostname và rewriteDomain để là localhost
- Test gửi mail

``echo "Test message from Linux server using ssmtp" | sudo ssmtp -vvv <mail muốn gửi>``

Ví dụ minh họa: 

```sh
root@server:~#  echo "Test message from Linux server using ssmtp" | sudo ssmtp -vvv nguyenvanminhkma@gmail.com
[<-] 220 smtp.gmail.com ESMTP 8sm25212407pge.65 - gsmtp
[->] EHLO localhost
[<-] 250 SMTPUTF8
[->] STARTTLS
[<-] 220 2.0.0 Ready to start TLS
[->] EHLO localhost
[<-] 250 SMTPUTF8
[->] AUTH LOGIN
[<-] 334 VXNlcm5hbWU6
[->] cG9pc29ub3VzMTIwNUBnbWFpbC5jb20=
[<-] 334 UGFzc3dvcmQ6
[<-] 235 2.7.0 Accepted
[->] MAIL FROM:<root@localhost>
[<-] 250 2.1.0 OK 8sm25212407pge.65 - gsmtp
[->] RCPT TO:<nguyenvanminhkma@gmail.com>
[<-] 250 2.1.5 OK 8sm25212407pge.65 - gsmtp
[->] DATA
[<-] 354  Go ahead 8sm25212407pge.65 - gsmtp
[->] Received: by localhost (sSMTP sendmail emulation); Tue, 30 May 2017 18:34:34 +0700
[->] From: "root" <root@localhost>
[->] Date: Tue, 30 May 2017 18:34:34 +0700
[->] Test message from Linux server using ssmtp
[->]
[->] .
[<-] 250 2.0.0 OK 1496144079 8sm25212407pge.65 - gsmtp
[->] QUIT
[<-] 221 2.0.0 closing connection 8sm25212407pge.65 - gsmtp
```

Kết quả: 

<img src="http://i.imgur.com/ZqldOYo.png">

- Ví dụ 2:

``ssmtp <mail người nhận>``

sau đó sẽ có khoảng trắng cho mình nhập :

```sh
To: nguyenvanminhkma@gmail.com
From: poisonous1205@gmail.com
Subject: test email

hello world!
```
Nhấn ctrl D để gửi mail và kết quả như sau 

<img src="http://i.imgur.com/I0tgQxK.png">

- 

