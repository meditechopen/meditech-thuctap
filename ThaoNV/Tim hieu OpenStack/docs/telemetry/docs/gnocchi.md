# Hướng dẫn cấu hình ceilometer kết hợp gnocchi

## Mục lục

1. Tổng quan về gnocchi

2. Hướng dẫn cấu hình

3. Một số câu lệnh thường dùng

4. Hướng dẫn cấu hình lấy thêm một số metric

-------------------

## 1. Tổng quan về gnocchi

Gnocchi là một time-series db được dùng để lưu các metrics hệ thống. Đầu tiên nó được phát triển nhằm thay thế cho mongodb trong ceilometer. Sau này nó được tách riêng ra để trở thành một project độc lập, hỗ trợ không chỉ ceilometer.

Gnocchi có một số thành phần:

- HTTP REST API
- stats daemon
- gnocchi-metricd

Dữ liệu được lấy từ HTTP REST API hoặc stats daemon, gnocchi-metricd sẽ thực hiện các tác vụ còn lại (tính toán, dọn dẹp...). Các thành phần này đều có thể scale theo chiều ngang vì thế nó phục vụ tốt hơn cho các bài toán yêu cầu cao về HA cũng như mở rộng hệ thống.

<img src="https://i.imgur.com/FvcHNP9.png">

- Gnocchi hỗ trợ 1 số loại backend để lưu metrics:

  - File (mặc định)
  - Ceph (preferred)
  - OpenStack Swift
  - Amazon S3
  - Redis

- Đối với việc lưu trữ các index cũng như một số thông tin khác thì gnocchi sử dụng sql db.

  - PostgreSQL (khuyên dùng)
  - MySQL (từ bản 5.6.4)

- Archive policy sẽ định nghĩa cách mà các metrics thu thập được tính toán và số lượng aggregate sẽ được giữ.

- Gnocchi sử dung 3 backend để lưu dữ liệu: một cho các measures mới, một để lưu aggregates và một cho indexing data. Thường thì 2 cái đầu sẽ được lưu cùng nhau.

- Trong OPS, gnocchi-api được chạy bằng Apache httpd mod_wsgi.

## 2. Hướng dẫn cấu hình

**Cấu hình Gnocchi**

- Tạo user, gán quyền

```
openstack user create --domain default --project service --password servicepassword gnocchi
openstack role add --project service --user gnocchi admin
```

- Tạo service

`openstack service create --name gnocchi --description "Metric Service" metric `

- Tạo endpoints

```
export controller=192.168.100.40
openstack endpoint create --region RegionOne metric public http://$controller:8041
openstack endpoint create --region RegionOne metric internal http://$controller:8041
openstack endpoint create --region RegionOne metric admin http://$controller:8041
```

- Tạo db

```
mysql -u root -p
create database gnocchi;
grant all privileges on gnocchi.* to gnocchi@'localhost' identified by 'Welcome123';
grant all privileges on gnocchi.* to gnocchi@'%' identified by 'Welcome123';
flush privileges;
exit
```

- Cài packages

`yum -y install openstack-gnocchi-api openstack-gnocchi-metricd python2-gnocchiclient`

- Sửa file cấu hình

```
mv /etc/gnocchi/gnocchi.conf /etc/gnocchi/gnocchi.conf.org
vi /etc/gnocchi/gnocchi.conf
```

```
# create new
[DEFAULT]
log_dir = /var/log/gnocchi

[api]
auth_mode = keystone

[database]
backend = sqlalchemy

# MariaDB connection info
[indexer]
url = mysql+pymysql://gnocchi:password@10.0.0.30/gnocchi

[storage]
driver = file
file_basepath = /var/lib/gnocchi

# Keystone auth info
[keystone_authtoken]
auth_uri = http://10.0.0.30:5000/v3
auth_url = http://10.0.0.30:35357
memcached_servers = 10.0.0.30:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = gnocchi
password = servicepassword
service_token_roles_required = true
```

`vi /etc/httpd/conf.d/10-gnocchi_wsgi.conf`

```
# create new
Listen 8041
<VirtualHost *:8041>
  DocumentRoot /var/www/cgi-bin/gnocchi

  <Directory /var/www/cgi-bin/gnocchi>
    AllowOverride None
    Require all granted
  </Directory>

  CustomLog /var/log/httpd/gnocchi_wsgi_access.log combined
  ErrorLog /var/log/httpd/gnocchi_wsgi_error.log
  SetEnvIf X-Forwarded-Proto https HTTPS=1
  WSGIApplicationGroup %{GLOBAL}
  WSGIDaemonProcess gnocchi display-name=gnocchi_wsgi user=gnocchi group=gnocchi processes=6 threads=6
  WSGIProcessGroup gnocchi
  WSGIScriptAlias / /var/www/cgi-bin/gnocchi/app
</VirtualHost>
```

- Phân quyền và tạo wsgi

```
chmod 640 /etc/gnocchi/gnocchi.conf
chgrp gnocchi /etc/gnocchi/gnocchi.conf
mkdir /var/www/cgi-bin/gnocchi
cp /usr/lib/python2.7/site-packages/gnocchi/rest/app.wsgi /var/www/cgi-bin/gnocchi/app
chown -R gnocchi. /var/www/cgi-bin/gnocchi
chown -R gnocchi. /var/www/cgi-bin/gnocchi
```

- Upgrade

`su -s /bin/bash gnocchi -c "gnocchi-upgrade"`

- Khởi chạy

```
systemctl start openstack-gnocchi-metricd
systemctl enable openstack-gnocchi-metricd
systemctl restart httpd
```

**Cấu hình ceilometer trên ctl**

- Tạo user, gán quyền, tạo service

```
openstack user create --domain default --project service --password servicepassword ceilometer
openstack role add --project service --user ceilometer admin
openstack service create --name ceilometer --description "OpenStack Telemetry Service" metering
```

- Cài packages

```
yum -y install openstack-ceilometer-central openstack-ceilometer-notification python2-ceilometerclient
```

- Sửa file cấu hình

```
mv /etc/ceilometer/ceilometer.conf /etc/ceilometer/ceilometer.conf.org
vi /etc/ceilometer/ceilometer.conf
```

```
# create new
[DEFAULT]
# RabbitMQ connection info
transport_url = rabbit://openstack:password@10.0.0.30

[api]
auth_mode = keystone

[dispatcher_gnocchi]
filter_service_activity = False

# Keystone auth info (with gnocchi user)
[keystone_authtoken]
auth_uri = http://10.0.0.30:5000/v3
auth_url = http://10.0.0.30:35357
memcached_servers = 10.0.0.30:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = gnocchi
password = servicepassword

# Keystone auth info (with ceilometer user)
[service_credentials]
auth_uri = http://10.0.0.30:5000/v3
auth_url = http://10.0.0.30:35357
memcached_servers = 10.0.0.30:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = ceilometer
password = servicepassword
```

- Phân quyền

```
chmod 640 /etc/ceilometer/ceilometer.conf
chgrp ceilometer /etc/ceilometer/ceilometer.conf
```

- Đồng bộ db

`su -s /bin/bash ceilometer -c "ceilometer-upgrade --skip-metering-database"`

- Khởi chạy

```
systemctl start openstack-ceilometer-central openstack-ceilometer-notification
systemctl enable openstack-ceilometer-central openstack-ceilometer-notification
```

**Cấu hình ceilometer trên compute**

- Cài packages

`yum -y install openstack-ceilometer-compute`

- Sửa file cấu hình

```
mv /etc/ceilometer/ceilometer.conf /etc/ceilometer/ceilometer.conf.org
vi /etc/ceilometer/ceilometer.conf
```

```
# create new
[DEFAULT]
# RabbitMQ connection info
transport_url = rabbit://openstack:password@10.0.0.30

[service_credentials]
auth_uri = http://10.0.0.30:5000/v3
auth_url = http://10.0.0.30:35357
memcached_servers = 10.0.0.30:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = ceilometer
password = servicepassword
```

**Cấu hình cho các thành phần của ops**

Tham khảo [tại dây](https://docs.openstack.org/ceilometer/pike/install/index.html)


## 3. Một số câu lệnh thường dùng

- Lấy danh sách các resource

`openstack metric resource list`

- Xem các metric của resource

`openstack metric resource show <id>`

- Xem thông tin chi tiết về các thông số lấy được của metric

`openstack metric measures show <id>`

## 4. Hướng dẫn cấu hình lấy thêm một số metric

- Mặc định thì ceilometer chỉ lấy được những metrics nhất định.

Tham khảo những thông số này [tại đây]()

- Để lấy được một số các thông số khác như mức độ sử dụng cpu của host compute thì ta cần cấu hình thêm snmp trên node compute

`yum -y install net-snmp net-snmp-utils`

```
mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.orig
vi /etc/snmp/snmpd.conf
```

```
# Map 'idv90we3rnov90wer' community to the 'ConfigUser'
# Map '209ijvfwer0df92jd' community to the 'AllUser'
#       sec.name        source          community
com2sec ConfigUser      default         idv90we3rnov90wer
com2sec AllUser         default         209ijvfwer0df92jd
# Map 'ConfigUser' to 'ConfigGroup' for SNMP Version 2c
# Map 'AllUser' to 'AllGroup' for SNMP Version 2c
#                       sec.model       sec.name
group   ConfigGroup     v2c             ConfigUser
group   AllGroup        v2c             AllUser
# Define 'SystemView', which includes everything under .1.3.6.1.2.1.1 (or .1.3.6.1.2.1.25.1)
# Define 'AllView', which includes everything under .1
#                       incl/excl       subtree
view    SystemView      included        .1.3.6.1.2.1.1
view    SystemView      included        .1.3.6.1.2.1.25.1.1
view    AllView         included        .1
# Give 'ConfigGroup' read access to objects in the view 'SystemView'
# Give 'AllGroup' read access to objects in the view 'AllView'
#                       context model   level   prefix  read            write   notify
access  ConfigGroup     ""      any     noauth  exact   SystemView      none    none
access  AllGroup        ""      any     noauth  exact   AllView         none    none
```

```
systemctl start snmpd
systemctl enable snmpd
```

- Chỉnh sửa thêm để poll được các metrics mới

`vi /etc/ceilometer/polling.yaml`

```
---
sources:
    - name: some_pollsters
      interval: 60
      meters:
        - cpu
        - cpu_l3_cache
        - memory.usage
        - memory.resident
        - network.incoming.bytes
        - network.incoming.packets
        - network.outgoing.bytes
        - network.outgoing.packets
        - disk.read.bytes
        - disk.usage
        - disk.capacity
        - disk.allocation
        - disk.read.requests
        - disk.write.bytes
        - disk.write.requests
        - disk.device.capacity
        - disk.device.allocation
        - disk.device.usage

    - name: some_pollsters2
      resources:
          - snmp://192.168.100.41
      interval: 60
      meters:
        - hardware.cpu.util
        - hardware.cpu.load.1min
        - hardware.cpu.load.5min
        - hardware.cpu.load.15min
        - hardware.memory.used
        - hardware.memory.total
        - hardware.memory.buffer
        - hardware.memory.cached
        - hardware.memory.swap.avail
        - hardware.memory.swap.total
        - hardware.system_stats.io.outgoing.blocks
        - hardware.system_stats.io.incoming.blocks
        - hardware.network.ip.incoming.datagrams
        - hardware.network.ip.outgoing.datagrams
```

Restart lại dịch vụ và kiểm tra lại danh sách các resource trên node controller xem metrics đã được poll lên chưa.


**Link tham khảo**

https://www.server-world.info/en/note?os=CentOS_7&p=openstack_pike3&f=2

https://gnocchi.xyz/intro.html

https://docs.openstack.org/ceilometer/pike/install/index.html
