# Hướng dẫn monitor weblogic


Tạo ra 1 user mới rồi phân quyền sudo

```
useradd thaonv
passwd thaonv
usermod -aG wheel thaonv
```

Cần cài GNOME cho centos 7, theo hướng dẫn tại link sau:

https://www.server-world.info/en/note?os=CentOS_7&p=x&f=1

Sau đó cài x11 `yum install xorg-x11-* -y`

Chỉnh sửa file sau để start gnome bằng user thường

```
~]# cat /etc/pam.d/xserver  
#%PAM-1.0  
auth       sufficient   pam_rootok.so  
auth       sufficient   pam_console.so  
auth       sufficient   pam_permit.so  
account    sufficient   pam_permit.so  
session    optional     pam_keyinit.so force revoke
```

Reboot lại máy và Login bằng tài khoản `thaonv`

Chạy câu lệnh `startx` để truy cập giao diện

- Cài weblogic theo link sau:

http://www.oracle.com/webfolder/technetwork/tutorials/obe/fmw/wls/12c/12_2_1/01-02-002-InstallWLSGeneric/installwlsgeneric.html#section2

Lưu ý: Sau khi thực hiện xong các bước tải jdk và weblogic về, dùng câu lệnh sau để cài và làm theo hướng dẫn

`jdk1.8.0_181/bin/java -Djava.awt.headless=true -jar fmw_12.2.1.0.0_wls.jar`

- Sau khi cài xong, nếu dịch vụ ko tự start, tiến hành start dịch vụ bằng cách truy cập vào thư mục cài đặt rồi chạy script sau:

<img src="https://i.imgur.com/6cKUHQg.png">

- Đợi dịch vụ start xong, truy cập giao diện quản trị console ở địa chỉ `http://xxx:7001/console`

- Tiến hành cài agent và thêm host trên phía check mk bình thường

- Copy 2 file `jolokia.cfg` và `mk_jolokia` để vào lần lượt `/etc/check_mk/` và `/usr/lib/check_mk_agent/plugins/`.

<img src="https://i.imgur.com/jPgrZph.png">

Chỉnh sửa file jolokia.cfg để phù hợp, ví dụ:

```
server = "127.0.0.1"
user = "None"
password = "None"
mode = "digest"
suburi = "jolokia"
instance = None
port = 7001
```

- Tải jolokia.war tại link Sau

https://jolokia.org/download.html

- Deploy thông qua giao diện web:

<img src="https://i.imgur.com/K2m50LG.png">

- Tiến hành chạy thử script đặt tại `/usr/lib/check_mk_agent/plugins/`. Nếu chưa được, kiểm tra lại phần cấu hình.
