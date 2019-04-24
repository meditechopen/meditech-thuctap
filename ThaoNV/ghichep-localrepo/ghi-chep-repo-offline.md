# Ghi chép về repo offline trên CentOS 7

## Mục đích

- Xây dựng repo offline để tải các gói cần cài đặt thường xuyên
- Dùng cho việc backup & restore các cấu hình

## Hướng dẫn cấu hình

### Trên máy local repo

- Tải về các gói cần thiết

`yum install yum-plugin-downloadonly yum-utils createrepo http -y`

- Khởi động httpd

```
systemctl start httpd
systemctl enable httpd
```

- Thêm rule firewalld

```
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload
```

- Disable selinux

`setenforce 0`

- Tạo thư mục chứa các gói cài đặt

`mkdir /var/www/html/thaonv`

- Đặt các package cần cài đặt vào trong thư mục này. Ta có thể keepcache ở những máy cần cài đặt hoặc sử dụng câu lệnh yum downloadonly để lấy package.

`yum install --downloadonly --downloaddir=[directory] [package]`

- Sau đó ta sử dụng câu lệnh sau để tạo ra repo

`createrepo -v /var/www/html/thaonv/`

### Trên máy client

- Khai báo repo

```
echo '[thaonv]
name = Local Repository
baseurl = http://<ip-local-repo-server>/thaonv
gpgcheck=0
enabled=1
```

Thay ip của local repo cho phù hợp.

- Sử dụng câu lệnh sau để list toàn bộ repo

`yum repolist`

- Xóa cache và update lại repolist

```
yum clean all
yum update
```

- Ta có thể dùng câu lệnh sau để disable các repo mà bạn không muốn tải gói từ đó.

`yum-config-manager --disable <tên repo>`

hoặc disable all

`yum-config-manager --disable \*`

Sau đó Enable repo offline vừa thêm

`yum-config-manager --enable thaonv`

- Hoặc ta có thể dùng cách sau khi tải gói để chỉ tải gói từ repo offline

`yum install --disablerepo="*" --enablerepo="thaonv" httpd`

### Lưu ý:

Khi cần thêm gói vào repo, ta sẽ move thẳng gói đó vào thư mục chứa package của repo offline.
Sau đó dùng lệnh sau để update lại repo

`createrepo --update /var/www/html/thaonv/`

Ở phía client ta cũng sẽ cần clean cache và update lại repolist

```
yum clean all
yum update
```

Rồi tiến hành tải gói như bình thường.


**Tham khảo**

https://www.tecmint.com/setup-yum-repository-in-centos-7/

https://www.unixmen.com/setup-local-yum-repository-centos-7/

https://linuxtechlab.com/offline-yum-repository-for-lan/

https://unix.stackexchange.com/questions/259640/how-to-use-yum-to-get-all-rpms-required-for-offline-use
