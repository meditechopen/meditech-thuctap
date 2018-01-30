## Cài đặt local-repo bằng cách sử dụng lệnh rsync
Mô tả: Chúng ta sẽ thực hiện cài đặt một repo offline bằng cách đồng bộ tất cả các gói từ repo của hãng. Sau đó từ các máy client (các máy muốn tải các gói cài đặt) sẽ trỏ địa chỉ về repo offline để tải các gói cài đặt.
#### Bước 1: Cài đặt Apache httpd 

- Tham khảo link dưới đây:

https://www.server-world.info/en/note?os=CentOS_7&p=httpd&f=1

#### Bước 2: Cài đặt rsync 

`yum -y install rsync createrepo`

#### Bước 3: Tạo các thư mục repo trên local và copy dữ liệu từ repo chính thức của centos.

```sh
# Tạo thư mục lưu trữ trên repo local 
$ mkdir -p /var/www/repos/centos/7/{os,updates,extras}/x86_64 
$ chmod -R 755 /var/www/repos

# Tải dữ liệu từ repo chính thức về 

$ rsync -avz --delete --exclude='repodata' \
rsync://ftp.riken.jp/centos/7/os/x86_64/ \
/var/www/repos/centos/7/os/x86_64/

$ rsync -avz --delete --exclude='repodata' \
rsync://ftp.riken.jp/centos/7/updates/x86_64/ \
/var/www/repos/centos/7/updates/x86_64/

$rsync -avz --delete --exclude='repodata' \
rsync://ftp.riken.jp/centos/7/extras/x86_64/ \
/var/www/repos/centos/7/extras/x86_64/

# Tạo metada cho repositories

$ createrepo /var/www/repos/centos/7/os/x86_64/ 
$ createrepo /var/www/repos/centos/7/updates/x86_64/ 
$ createrepo /var/www/repos/centos/7/extras/x86_64/
```

#### Bước 4: Thực hiện đồng bộ dữ liệu vào hàng ngày bằng cách sử dụng crontab 

`vi /etc/cron.daily/update-repo`

Thêm vào nội dung sau: 

```sh
#!/bin/bash

VER='7'
ARCH='x86_64'
REPOS=(os updates extras)

for REPO in ${REPOS[@]}
do
    rsync -avz --delete --exclude='repodata' \
    rsync://ftp.riken.jp/centos/${VER}/${REPO}/${ARCH}/ /var/www/repos/centos/${VER}/${REPO}/${ARCH}/
    createrepo /var/www/repos/centos/${VER}/${REPO}/${ARCH}/
done
```

`chmod 755 /etc/cron.daily/update-repo`

#### Bước 5: Cấu hình http

``vi /etc/httpd/conf.d/repos.conf``

Thêm vào nội dung sau:

```sh
Alias /repos /var/www/repos
<directory /var/www/repos>
    Options +Indexes
    Require all granted
</directory>
```

``systemctl restart httpd ``

#### Bước 6: Bật firewall 

```sh
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
```

#### Trên client thay đổi địa chỉ url trong repo 

``vi /etc/yum.repos.d/CentOS-Base.repo``

```sh 
[base]
name=CentOS-$releasever - Base
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
baseurl=http://<IP_local_repo>/repos/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-$releasever - Updates
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates&infra=$infra
baseurl=http://<IP_local_repo>/repos/centos/$releasever/updates/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-$releasever - Extras
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras&infra=$infra
baseurl=http://<IP_local_repo>/repos/centos/$releasever/extras/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
```
