# Tìm hiểu aodh

## Mục lục

[1. Giới thiệu](#)

[2. Kiến trúc tổng quan](#)

[3. Hướng dẫn cấu hình](#)

[4. Một số câu lệnh cơ bản](#)

--------------------------------------

<a name="1"></a>
## 1. Giới thiệu

Aodh là project nhỏ dùng để cảnh báo trong project Telemetry, trước đây nó thuộc về Ceilometer, tuy nhiên do một số hạn chế nên tới bản Liberty thì nó được tách riêng ra. Nó cung cấp các daemons để tính toán cũng như đưa ra các cảnh báo dựa vào các rules được định nghĩa từ trước.

Hiện tại aodh chỉ hỗ trợ 3 laoji action đối với alarm output:

- HTTP callback: Cung cấp 1 url để aodh đẩy một đoạn post request tới. Phần nội dung của đoạn request này chứa tất cả nội dung vì sao cảnh báo được đưa ra.
- log: Sử dụng chủ yếu để debug, lưu trữ dữ liệu trong 1 log file
- zaqar: Gửi thông báo tới messaging service thông qua zaqar api.

<a name="2"></a>
## 2. Kiến trúc tổng quan

Aodh bao gồm một số thành phần chính:

- API server (aodh-api): cung cấp api để lấy thông tin về cảnh báo
- alarm evaluator (aodh-evaluator): Có nhiệm vụ xác định xem khi nào thì cảnh báo được bật.
- notification listener (aodh-listener): đánh giá khả năng cảnh báo. Nó lắng nghe từ queue và ước lượng việc cảnh báo nếu sự kiện cho cảnh báo được nhận.
- alarm notifier (aodh-notifier): gửi các thông tin cảnh báo với các trangj thái của từng cảnh báo (ok, alarm, insufficient data). Service này cần kết nối tới AMQP.


<a name="3"></a>
## 3. Hướng dẫn cấu hình

Lưu ý: Yêu cầu đã cấu hình xong ceilometer và gnocchi. Phiên bản sử dụng ở bài này là pike

- Tạo user và add role

```
openstack user create --domain default --project service --password Welcome123 aodh
openstack role add --project service --user aodh admin
```

- Tạo service

`openstack service create --name aodh --description "Telemetry Alarming" alarming`

- Tạo endpoints

```
export controller=192.168.100.40
openstack endpoint create --region RegionOne alarming public http://$controller:8042
openstack endpoint create --region RegionOne alarming internal http://$controller:8042
openstack endpoint create --region RegionOne alarming admin http://$controller:8042
```

- Tạo db

```
mysql -u root -p
create database aodh;
grant all privileges on aodh.* to aodh@'localhost' identified by 'Welcome123';
grant all privileges on aodh.* to aodh@'%' identified by 'Welcome123';
flush privileges;
exit
```

- Cài packages

`yum -y install openstack-aodh-api openstack-aodh-evaluator openstack-aodh-notifier openstack-aodh-listener openstack-aodh-expirer python2-aodhclient`

- Chỉnh file cấu hình

```
mv /etc/aodh/aodh.conf /etc/aodh/aodh.conf.org
```

- Tạo file `/etc/aodh/aodh.conf` mới


```
# create new
[DEFAULT]
log_dir = /var/log/aodh
# RabbitMQ connection info
transport_url = rabbit://openstack:password@10.0.0.30

[api]
auth_mode = keystone
gnocchi_external_project_owner = service

[database]
# MariaDB connection info
connection = mysql+pymysql://aodh:password@10.0.0.30/aodh

# Keystone auth info
[keystone_authtoken]
www_authenticate_uri = http://10.0.0.30:5000
auth_url = http://10.0.0.30:5000
memcached_servers = 10.0.0.30:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = aodh
password = servicepassword

[service_credentials]
auth_url = http://10.0.0.30:5000/v3
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = aodh
password = servicepassword
interface = internalURL
```

- Tạo file `/etc/httpd/conf.d/20-aodh_wsgi.conf`


```
# create new
Listen 8042
<VirtualHost *:8042>
    DocumentRoot "/var/www/cgi-bin/aodh"
    <Directory "/var/www/cgi-bin/aodh">
        AllowOverride None
        Require all granted
    </Directory>

    CustomLog "/var/log/httpd/aodh_wsgi_access.log" combined
    ErrorLog "/var/log/httpd/aodh_wsgi_error.log"
    SetEnvIf X-Forwarded-Proto https HTTPS=1
    WSGIApplicationGroup %{GLOBAL}
    WSGIDaemonProcess aodh display-name=aodh_wsgi user=aodh group=aodh processes=6 threads=3
    WSGIProcessGroup aodh
    WSGIScriptAlias / "/var/www/cgi-bin/aodh/app"
</VirtualHost>
```

- Phân quyền và tạo wsgi để chạy aodh api

```
chmod 640 /etc/aodh/aodh.conf
chgrp aodh /etc/aodh/aodh.conf
mkdir /var/www/cgi-bin/aodh
cp /usr/lib/python2.7/site-packages/aodh/api/app.wsgi /var/www/cgi-bin/aodh/app
chown -R aodh. /var/www/cgi-bin/aodh
```

- Sync database

`su -s /bin/bash aodh -c "aodh-dbsync"`

- start dịch vụ

```
systemctl start openstack-aodh-evaluator openstack-aodh-notifier openstack-aodh-listener
systemctl enable openstack-aodh-evaluator openstack-aodh-notifier openstack-aodh-listener
systemctl restart httpd
```

<a name="4"></a>
## 4. Một số câu lệnh cơ bản

- tạo một alarm cảnh báo nếu ram usage lên trên mức 500MB và đẩy cảnh báo ra file log

```
aodh alarm create \
  --name memory_hi2 \
  --type gnocchi_resources_threshold \
  --description 'instance running hot' \
  --metric memory.usage \
  --threshold 500.0 \
  --comparison-operator gt \
  --aggregation-method mean \
  --granularity 60 \
  --evaluation-periods 1 \
  --alarm-action 'log://' \
  --ok-action 'log://' \
  --resource-id b9cfbf49-ec5f-4c2b-9599-fcb463d5c5d2 \
  --resource-type instance
```

Log chứa cảnh báo `/var/log/aodh/notifier.log`

<img src="https://i.imgur.com/wubE8dr.png">

- Tạo một alarm cảnh báo nếu cpu được sử dụng trên 70% và đẩy cảnh báo qua http call callback

```
aodh alarm create \
  --name cpu_hi \
  --type gnocchi_resources_threshold \
  --description 'CPU High Average' \
  --metric cpu_util \
  --threshold 70.0 \
  --comparison-operator gt \
  --aggregation-method mean \
  --granularity 60 \
  --evaluation-periods 1 \
  --alarm-action http://localhost:1234 \
  --ok-action http://localhost:1234 \
  --resource-id b9cfbf49-ec5f-4c2b-9599-fcb463d5c5d2 \
  --resource-type instance
```

Sau khi tạo xong có thể dùng netcat để bắt post request vì ở trên mình gửi tới localhost, nó là một đoạn mã json chứa thông tin cảnh báo

<img src="https://i.imgur.com/1UxZEiY.png">

- Xem các cảnh báo đang có

`openstack alarm list`

- Xem lịch sử của alarm

`openstack alarm-history show 04f4bf40-1caf-4b6c-a5f7-9aff0e3584fa`

- Xem thêm về alarm [tại đây](https://docs.openstack.org/aodh/latest/admin/telemetry-alarms.html)

**Link tham khảo**

https://www.server-world.info/en/note?os=CentOS_7&p=openstack_queens3&f=7

https://docs.openstack.org/aodh/pike/admin/telemetry-alarms.html
