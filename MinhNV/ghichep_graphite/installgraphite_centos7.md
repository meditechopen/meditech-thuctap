#  Mô hình

Đây là mô hình bộ giải pháp graphite và collectD:

<img src="http://i.imgur.com/Kq22Bk3.png">

IP planning

<img src="http://i.imgur.com/0YZuSEQ.png">

## Các bước cài đặt:

Cài đặt epel-release:

```sh
sudo yum -y install epel-release
sudo yum -y update
```

## Bước 1: Cài đặt Graphite và Carbon
- Tải các gói cài đặt

``sudo yum install httpd mod_wsgi python-pip python-devel git pycairo libffi-devel``

- Tải graphite-web và carbon từ Github

```sh
cd /usr/local/src
sudo git clone https://github.com/graphite-project/graphite-web.git
sudo git clone https://github.com/graphite-project/carbon.git
```

- Kiểm tra requirements:

``python /usr/local/src/graphite-web/check-dependencies.py``

Màn hình sẽ hiển thị tương tự nội dung sau đây

```sh
[REQUIRED] Unable to import the 'whisper' or 'ceres' modules, please download this package from the Graphite project page and install it.

    . . .

    6 optional dependencies not met. Please consider the optional items before proceeding.
    5 necessary dependencies not met. Graphite will not function until these dependencies are fulfilled.
```
- Cài đặt các mô-dun còn thiếu

Install gcc

``sudo yum install gcc``

Install modules

``sudo pip install -r /usr/local/src/graphite-web/requirements.txt``

Kiểm tra phiên bản gói ``django-tagging``

``pip show django-tagging``

Nếu phiên bản cũ hơn bản 0.3.4 thì chạy câu lệnh sau để update

``sudo pip install -U django-tagging``

Kiểm tra lại requirements lần nữa

``python /usr/local/src/graphite-web/check-dependencies.py``

Bây giờ bạn sẽ thấy kết quả sau:

```sh
[OPTIONAL] Unable to import the 'ldap' module, do you have python-ldap installed for python 2.7.5? Without python-ldap, you will not be able to use LDAP authentication in the graphite webapp.
[OPTIONAL] Unable to import the 'python-rrdtool' module, this is required for reading RRD.
2 optional dependencies not met. Please consider the optional items before proceeding.
All necessary dependencies are met.
```

- Cài đặt Carbon:

```sh
cd /usr/local/src/carbon/
sudo python setup.py install
```

- Cài đặt Graphite-web

```sh
cd /usr/local/src/graphite-web/
sudo python setup.py install
```

## Bước 2: Cấu hình ứng dụng Graphite-Web

Graphite-Web là ứng dụng web Django chạy dưới Apache / mod_wsgi.

- Sao chép tệp local_settings.py.example:

``sudo cp /opt/graphite/webapp/graphite/local_settings.py.example /opt/graphite/webapp/graphite/local_settings.py``

- Mở tệp để chỉnh sửa:

``sudo vi /opt/graphite/webapp/graphite/local_settings.py``

 Bỏ commend chỉnh sửa giống 2 dòng sau đây. Phần KEY có thể nhập tùy chọn theo ý mình muốn.

```sh
SECRET_KEY = 'enter_your_unique_secret_key_here'
TIME_ZONE = 'Asia/Ho_Chi_Minh'
```

- Dùng script khời tạo một database mới:

```sh
cd /opt/graphite
sudo PYTHONPATH=/opt/graphite/webapp/ django-admin.py migrate --run-syncdb  --settings=graphite.settings
```

- Chạy lệnh sau để thu thập tất cả các tệp tĩnh trong một thư mục:

``sudo PYTHONPATH=/opt/graphite/webapp/ django-admin.py collectstatic --settings=graphite.settings``

Chọn  ``yes`` sau đó phân quyền sở hữu cho các thư mục sau:

```sh
sudo chown -R apache:apache /opt/graphite/storage/
sudo chown -R apache:apache /opt/graphite/static/
sudo chown -R apache:apache /opt/graphite/webapp/
```

- Copy 2 file mẫu dưới đây

```sh
sudo cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
sudo cp /opt/graphite/examples/example-graphite-vhost.conf /etc/httpd/conf.d/graphite.conf
```
- Mở tệp để chỉnh sửa:

``sudo vi /etc/httpd/conf.d/graphite.conf``

- Điển địa chỉ ip vào sau dòng ``ServerName`` và thêm vào sau dòng ``Alias /static/ /opt/graphite/static/``

```sh
<Directory /opt/graphite/static/>
   Require all granted
</Directory>
```

- Chạy Graphite-web

```sh
sudo systemctl start httpd
sudo systemctl enable httpd
```
- Mở filewall:

```sh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
```

## Bước 3: Cấu hình carbon

- Ta sẽ cần phải chỉnh sửa storage-schemas.conf để cấu hình tần số datapoint trong whisper. Đầu tiên, tạo một bản sao của tệp ví dụ:

``sudo cp /opt/graphite/conf/storage-schemas.conf.example /opt/graphite/conf/storage-schemas.conf``

- Mở tệp và chỉnh sửa

``sudo vi /opt/graphite/conf/storage-schemas.conf``

Theo mặc định nó sẽ có 2 phần:

```sh
[carbon]
pattern = ^carbon\.
retentions = 60:90d

[default_1min_for_1day]
pattern = .*
retentions = 60s:1d
```
Thêm 1 tùy chọn

```sh
[collectd]
pattern = ^collectd.*
retentions = 10s:1h,1m:1d,10m:1y
```

- Khời động Carbon

- Đầu tiên, sao chép chúng vào /etc/init.d/ để làm cho chúng thực thi:

```sh
sudo cp /usr/local/src/carbon/distro/redhat/init.d/carbon-* /etc/init.d/
sudo chmod +x /etc/init.d/carbon-*
```

- Start carbon-cache

``sudo systemctl start carbon-cache``
``sudo systemctl enable carbon-cache``

## Bước 4: cài đặt collectD client

- Trên centos7

``sudo yum install collectd``

- Trên ubuntu 14

``sudo apt-get install collectd collectd-utils``

- Chỉnh sửa file cấu hình collectD để metric ghi thông tin vào filesystem trong graphite-server

``vi /etc/collectd.conf`` trên centos7

``vi /etc/collectd/collectd.conf`` trên Ubuntu14

Thêm plugin write_graphite

```sh
LoadPlugin write_graphite
<Plugin write_graphite>
  <Node "localhost">
    Host "localhost"
    Port "2003"
  Protocol "tcp"
 LogSendErrors true
  Prefix "collectd."
    # Postfix "collectd"
  StoreRates true
   AlwaysAppendDS false
  EscapeCharacter "_"
  </Node>
</Plugin>
```
- Trường hợp này mình cài collectD trên localhost
- Nếu cài trên client thì :

  + Note: < hostname client >
  + Host: < ip graphite-server >
  + Nhớ mở port 2003 trên graphite-server

Khởi động lại collectD

- Ubuntu14

``sudo service collectd restart``

- Centos7

``sudo systemctl start collectd.service``

## Bước 5: Truy cập vào web-interface

http://ip_graphite_server

## Sửa lỗi khi cài đặt 

### Lỗi không start được carbon-cache : 
Ở bước tải project/carbon hãy tải thư mục carbon trên git của mình ``https://github.com/nguyenminh12051997/meditech-thuctap/tree/master/MinhNV/ghichep_graphite``
### Lỗi k start được http
Tắt firewall, selinux và khởi động lại máy sau đó mới start httpd
