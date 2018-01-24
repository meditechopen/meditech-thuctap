# Hướng dẫn sử dụng apt-cacher làm local repository

Về cơ bản, apt-cacher có cơ chế hoạt động giống với apt-cacher-ng. Nó là phiên bản đi trước của apt-cacher-ng.

Ngữ cảnh sử dụng:

- Bạn cần một server để cache lại các packages đã tải về cho những lần cài đặt sau
- Bạn có một số lượng các packages và muốn import nó vào một repo server để các máy khác có thể tới lấy về

## Hướng dẫn cài đặt trên server

- Cài package

`sudo apt-get install apt-cacher apache2`

- Bật apt-caher ở mỗi lần khởi động

`vi /etc/default/apt-cacher`

Chỉnh thông số `autostart` thành `1`.

- Restart apache2

`sudo service apache2 restart`

- Chỉnh file `sudo service apache2 restart`

Bỏ comment dòng sau

`allowed_hosts = *`

- Restart lại apt-cacher

`sudo service apt-cacher restart`

- Truy cập vào địa chỉ sau và kiểm tra `http://ip-of-server:3142/apt-cacher`

## Hướng dẫn import packages vào apt-cacher

- Giả sử thư mục chứa các packages của bạn là `/var/cache/apt/archives/`

- Tiến hành thay đổi quyền truy cập sang user của apt-cacher là `www-data`

`chown www-data:www-data /var/cache/apt/archives/*`

- Sử dung script để import package vào apt-cacher

`sudo /usr/share/apt-cacher/apt-cacher-import.pl -l /var/cache/apt/archives`

- Kiểm tra lại ở thư mục `/var/cache/apt-cacher`

## Hướng dẫn khai báo ở máy client

Có 2 cách để bạn khai báo local repo ở client

**Cách 1**

Sử dụng như một proxy

`echo 'Acquire::http { Proxy "http://ip-server:3142";; };' > /etc/apt/apt.conf.d/01proxy`

**Cách 2**

Sửa file `/etc/apt/sources.list`

Thêm vào mỗi soure list địa chỉ ip của server

Ví dụ:

`deb http://archive.ubuntu.com/ubuntu/ precise main restricted`

Trở thành

`deb http://apt-cacher-server:3142/archive.ubuntu.com/ubuntu/ precise main restricted`

Sau khi thay đổi file source list, tiến hành chạy `apt-get update` để update lại source list. Lưu ý trong quá trình chạy update thì apt-cacher của bạn phải có kết nối internet.


**Link tham khảo**

https://help.ubuntu.com/community/Apt-Cacher-Server
