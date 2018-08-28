# Hướng dẫn đẩy data từ checkmk sang mysql

## Lưu ý:

Hướng dẫn này dùng cho check mk raw ver 1.5

## 1. Cấu hình trên cả 2 node

Cài mariadb

`yum install -y mariadb mariadb-server mariadb-devel`

Cài các gói bổ trợ

`yum install gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel xinetd unzip httpd php php-fpm curl vim -y`

Copy file cp sysctl.conf

`cp /etc/sysctl.conf /etc/sysctl.conf_backup`

Chỉnh cấu hình

```
sed -i '/msgmnb/d' /etc/sysctl.conf
sed -i '/msgmax/d' /etc/sysctl.conf
sed -i '/shmmax/d' /etc/sysctl.conf
sed -i '/shmall/d' /etc/sysctl.conf
printf "\n\nkernel.msgmnb = 131072000\n" >> /etc/sysctl.conf
printf "kernel.msgmax = 131072000\n" >> /etc/sysctl.conf
printf "kernel.shmmax = 4294967295\n" >> /etc/sysctl.conf
printf "kernel.shmall = 268435456\n" >> /etc/sysctl.conf
sysctl -e -p /etc/sysctl.conf
```

## 2. Cấu hình trên node mysql

start mariadb

```
systemctl start mariadb.service
systemctl enable mariadb.service
```

Đặt pass

`/usr/bin/mysqladmin -u root password 'mypassword'`

Tạo db

`mysql -u root -p'mypassword'`

```
CREATE DATABASE nagios DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER 'ndoutils'@'%' IDENTIFIED BY 'ndoutils_password';
GRANT USAGE ON *.* TO 'ndoutils'@'%' IDENTIFIED BY 'ndoutils_password' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;
GRANT ALL PRIVILEGES ON nagios.* TO 'ndoutils'@'%' WITH GRANT OPTION ;
\q
```


## 3. Cấu hình trên node check mk

Tải và giải nén

```
cd /tmp
wget -O ndoutils.tar.gz https://github.com/NagiosEnterprises/ndoutils/releases/download/ndoutils-2.1.3/ndoutils-2.1.3.tar.gz
tar xzf ndoutils.tar.gz
```

Configure

```
cd /tmp/ndoutils-2.1.3/
./configure --prefix=/omd/sites/manager/usr/local/nagios/ --enable-mysql --disable-pgsql --with-ndo2db-user=manager -with-ndo2db-group=manager
make all
```

`make install`

Configure db

```
cd db/
./installdb -u 'ndoutils' -p 'ndoutils_password' -h '192.168.100.39' -d nagios
cd ..
```

`echo 'show databases;' | mysql -u ndoutils -p'ndoutils_password' -h 192.168.100.39`

`make install-config`

`su manager`

```
chmod 766 config/ndo2db.cfg-sample config/ndomod.cfg-sample
cp /tmp/ndoutils-2.1.3/src/ndomod-3x.o ~/usr/local/nagios/bin/ndomod.o
cp /tmp/ndoutils-2.1.3/src/ndo2db-3x ~/usr/local/nagios/bin/ndo2db
chmod 0744 ~/usr/local/nagios/bin/ndo*
cp config/ndo2db.cfg-sample ~/usr/local/nagios/etc/ndo2db.cfg
cp config/ndomod.cfg-sample ~/usr/local/nagios/etc/ndomod.cfg
```


`vi ~/usr/local/nagios/etc/ndo2db.cfg`

```
db_user=ndoutils
db_pass=ndoutils_password
```

`make install-init`

```
printf "\n\n# NDOUtils Broker Module\n" >> /omd/sites/manager/etc/nagios/nagios.cfg
printf "broker_module=/omd/sites/manager/usr/local/nagios/bin/ndomod.o config_file=/omd/sites/manager/usr/local/nagios/etc/ndomod.cfg\n" >> /omd/sites/manager/etc/nagios/nagios.cfg
```

```
systemctl enable ndo2db.service
systemctl start ndo2db.service
```

`omd restart manager`

`grep ndo /omd/sites/manager/var/log/nagios.log`


if OK

[1535371000] ndomod: NDOMOD 2.1.3 (2017-04-13) Copyright (c) 2009 Nagios Core Development Team and Community Contributors
[1535371000] ndomod: Successfully connected to data sink.  0 queued items to flush.
[1535371000] ndomod registered for process data
[1535371000] ndomod registered for timed event data
[1535371000] ndomod registered for log data'
[1535371000] ndomod registered for system command data'
[1535371000] ndomod registered for event handler data'
[1535371000] ndomod registered for notification data'
[1535371000] ndomod registered for service check data'
[1535371000] ndomod registered for host check data'
[1535371000] ndomod registered for comment data'
[1535371000] ndomod registered for downtime data'
[1535371000] ndomod registered for flapping data'
[1535371000] ndomod registered for program status data'
[1535371000] ndomod registered for host status data'
[1535371000] ndomod registered for service status data'
[1535371000] ndomod registered for adaptive program data'
[1535371000] ndomod registered for adaptive host data'
[1535371000] ndomod registered for adaptive service data'
[1535371000] ndomod registered for external command data'
[1535371000] ndomod registered for aggregated status data'
[1535371000] ndomod registered for retention data'
[1535371000] ndomod registered for contact data'
[1535371000] ndomod registered for contact notification data'
[1535371000] ndomod registered for acknowledgement data'
[1535371000] ndomod registered for state change data'
[1535371000] ndomod registered for contact status data'
[1535371000] ndomod registered for adaptive contact data'
[1535371000] Event broker module '/omd/sites/manager/usr/local/nagios/bin/ndomod.o' initialized successfully.
