# Hướng dẫn backup và restore node Controller trong môi trường OPS đơn giản

## Mục lục

1. Mô hình và những lưu ý
2. Những file cần phải backup từ controller
3. Hướng dẫn cấu hình và restore controller từ những file backup

------------------------------

## 1. Mô hình

<img src="https://i.imgur.com/NtxxvC3.png">

**Một số lưu ý**

- Môi trường LAB: KVM
- Distro: CentOS 2 NIC (1 bridge + 1 hostonly)
- OPS version: PIKE
- Mô hình sử dụng Linux Bridge, không có HA và chỉ cài đặt các project: keystone, glance, neutron, nova
- Không áp dụng cho tất cả các mô hình OPS

Các bạn có thể tham khảo và sử dụng script sau để cài đặt OPS

https://github.com/congto/openstack-tools/tree/master/scripts/OpenStack-Pike-No-HA

## 2. Những file cần backup từ controller

- All packages dùng để cài đặt, các bạn có thể cache lại nó trong lần tải về đầu tiên bằng cách chỉnh sửa trong file `/etc/yum.conf`:

`keepcache=0`

Các file mà các bạn tải về sẽ được lưu tại `/var/cache/yum`

**Lưu ý**

Bạn sẽ phải cài bằng cách thủ công đối với các packages của OPS

Hoặc các bạn có thể dùng 1 con apt-cacher-ng để lưu lại cache (ở đây mình sử dụng cách này)

- `/etc/yum.repos.d/MariaDB.repo` (optional)
- `/etc/hosts`
- `/etc/chrony.conf`
- `/etc/sysconfig/memcached`
- `/etc/my.cnf.d/openstack.cnf`
- All databases

`mysqldump -u root -pWelcome123 --all-databases > all_db.sql`

- `/etc/keystone/keystone.conf`
- `/etc/glance/glance-api.conf`
- `/etc/glance/glance-registry.conf`
- Toàn bộ thư mục chứa image `/var/lib/glance/images`
- `/etc/nova/nova.conf`
- `/etc/httpd/conf.d/00-nova-placement-api.conf`
- `/etc/neutron/neutron.conf`
- `/etc/neutron/plugins/ml2/ml2_conf.ini`
- `/etc/neutron/plugins/ml2/linuxbridge_agent.ini`
- `/etc/neutron/dhcp_agent.ini`
- `/etc/neutron/metadata_agent.ini`
- `/etc/neutron/l3_agent.ini`
- `/var/www/html/index.html` (optional)
- `/etc/openstack-dashboard/local_settings`
- `/root/admin-openrc`
- `/root/demo-openrc`

## 3. Hướng dẫn cấu hình và restore controller từ những file backup

**Bước 1: Cấu hình preparation cho Controller**

- Set up ip giống với Controller cũ

``` sh
nmcli con modify eth0 ipv4.addresses 192.168.100.32
nmcli con modify eth0 ipv4.gateway 192.168.100.1
nmcli con modify eth0 ipv4.dns 8.8.8.8
nmcli con modify eth0 ipv4.method manual
nmcli con modify eth0 connection.autoconnect yes

nmcli con modify eth1 ipv4.addresses 10.10.10.32
nmcli con modify eth1 ipv4.method manual
nmcli con modify eth1 connection.autoconnect yes

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl stop NetworkManager
sudo systemctl disable NetworkManager
sudo systemctl enable network
sudo systemctl start network
init 6
```

- Set hostname

`hostnamectl set-hostname controller`

- Khai báo local repo

``` sh
echo "proxy=http://192.168.100.121:3142" >> /etc/yum.conf
yum -y update
```

- Cài đặt repo mariadb

Copy file `/etc/yum.repos.d/MariaDB.repo`

`yum -y update`

- Cài đặt Repo cho OPS

``` sh
yum -y install centos-release-openstack-pike
yum -y upgrade
yum -y install crudini wget vim
yum -y install python-openstackclient openstack-selinux python2-PyMySQL
yum -y update
```

- Khai báo host

copy file `/etc/hosts`

- Cài đặt NTP server

`yum -y install chrony`

Copy file `/etc/chrony.conf`

Bật dịch vụ

``` sh
systemctl enable chronyd.service
systemctl start chronyd.service
systemctl restart chronyd.service
chronyc sources
```

- Cài đặt memacached

`yum -y install memcached python-memcached`

Copy file /etc/sysconfig/memcached

Bật dịch vụ và khởi động lại

``` sh
systemctl enable memcached.service
systemctl start memcached.service
init 6
```

**Bước 2: Cấu hình mysql và rabbitmq**

- Cài đặt mariadb

`yum -y install mariadb mariadb-server python2-PyMySQL rsync xinetd crudini vim`

Copy file `/etc/my.cnf.d/openstack.cnf`

- Khởi động dịch vụ

``` sh
systemctl enable mariadb.service
systemctl start mariadb.service
```

- Cấu hình password

``` sh
cat << EOF | mysql -uroot
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'Welcome123' WITH GRANT OPTION ;FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'Welcome123' WITH GRANT OPTION ;FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY 'Welcome123' WITH GRANT OPTION ;FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.100.32' IDENTIFIED BY 'Welcome123' WITH GRANT OPTION ;FLUSH PRIVILEGES;
DROP USER ''@'controller';
DROP USER ''@'localhost';
DROP USER 'root'@'::1';
DROP USER 'root'@'controller';
EOF
```

- Copy file backup sql và bung file

`mysql -uroot -pWelcome123 < all_db.sql`

- Cài đặt rabbitmq

`yum -y install rabbitmq-server`

- Bật dịch vụ

``` sh
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
rabbitmq-plugins enable rabbitmq_management
systemctl restart rabbitmq-server
curl -O http://localhost:15672/cli/rabbitmqadmin
chmod a+x rabbitmqadmin
mv rabbitmqadmin /usr/sbin/
```

- Set up user

``` sh
rabbitmqctl add_user openstack Welcome123
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
rabbitmqctl set_user_tags openstack administrator
rabbitmqadmin list users
```

**Bước 3: Cài đặt và cấu hình keystone**

- Cài đặt package

`yum -y install openstack-keystone httpd mod_wsgi`

- Backup file

`mv /etc/keystone/keystone.conf /etc/keystone/keystone.conf.org`

- Copy file `/etc/keystone/keystone.conf`
- Phân quyền

`chown root:keystone /etc/keystone/keystone.conf`

- Sync database

``` sh
su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
```

- Bootstrap

``` sh
keystone-manage bootstrap --bootstrap-password Welcome123 \
--bootstrap-admin-url http://192.168.100.32:35357/v3/ \
--bootstrap-internal-url http://192.168.100.32:5000/v3/ \
--bootstrap-public-url http://192.168.100.32:5000/v3/ \
--bootstrap-region-id RegionOne
```

- Khởi động dịch vụ

``` sh
echo "ServerName controller" >> /etc/httpd/conf/httpd.conf
ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/
systemctl enable httpd.service
systemctl start httpd.service
```

- Copy 2 file source `/root/admin-openrc` và `/root/demo-openrc`
- Phân quyền

``` sh
chmod +x /root/admin-openrc
cat  /root/admin-openrc >> /etc/profile
chmod +x /root/demo-openrc
source /root/admin-openrc
```

- Kiểm tra lại

`openstack user list`

**Bước 3: Cài đặt glance*

- Cài đặt package

`yum -y install openstack-glance`

- Backup file

``` sh
mv /etc/glance/glance-api.conf /etc/glance/glance-api.conf.orig
mv /etc/glance/glance-registry.conf /etc/glance/glance-registry.conf.orig
```

- Copy `/etc/glance/glance-api.conf` và `/etc/glance/glance-registry.conf`
- Phân quyền

``` sh
chown root:glance /etc/glance/glance-api.conf
chown root:glance /etc/glance/glance-registry.conf
```

- Copy thư mục `/var/lib/glance/images`
- Phân quyền cho image

``` sh
cd /var/lib/glance/images/
chown glance:glance image_name
chmod 640 image_name
```
- Sync db

`su -s /bin/sh -c "glance-manage db_sync" glance`

- Khởi động dịch vụ

``` sh
systemctl enable openstack-glance-api.service
systemctl enable openstack-glance-registry.service
systemctl start openstack-glance-api.service
systemctl start openstack-glance-registry.service
```

- Kiểm tra lại

`openstack image list`

**Bước 4: Cài compute*

- Cài đặt package

``` sh
yum -y install openstack-nova-api openstack-nova-conductor \
openstack-nova-console openstack-nova-novncproxy \
openstack-nova-scheduler openstack-nova-placement-api
```

- Backup file

`mv /etc/nova/nova.conf /etc/nova/nova.conf.orig`

- Copy file `/etc/nova/nova.conf`
- Phân quyền

`chown root:nova /etc/nova/nova.conf`

- Copy file `/etc/httpd/conf.d/00-nova-placement-api.conf`

- Restart lại dịch vụ

`systemctl restart httpd`

- Đồng bộ db

``` sh
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage db sync" nova
```

- Kiểm tra lại

`nova-manage cell_v2 list_cells`

- Khởi động dịch vụ

``` sh
systemctl enable openstack-nova-api.service \
openstack-nova-consoleauth.service openstack-nova-scheduler.service \
openstack-nova-conductor.service openstack-nova-novncproxy.service

systemctl start openstack-nova-api.service \
openstack-nova-consoleauth.service openstack-nova-scheduler.service \
openstack-nova-conductor.service openstack-nova-novncproxy.service
```

- Kiểm tra lại

`openstack compute service list`

**Bước 5: Cài neutron**

- Cài packages

`yum -y update && yum -y install openstack-neutron openstack-neutron-ml2 openstack-neutron-linuxbridge ebtables`

- backup file

``` sh
ctl_neutron_conf=/etc/neutron/neutron.conf
ctl_ml2_conf=/etc/neutron/plugins/ml2/ml2_conf.ini
ctl_linuxbridge_agent=/etc/neutron/plugins/ml2/linuxbridge_agent.ini
ctl_dhcp_agent=/etc/neutron/dhcp_agent.ini
ctl_metadata_agent=/etc/neutron/metadata_agent.ini
ctl_l3_agent_conf=/etc/neutron/l3_agent.ini

mv $ctl_neutron_conf $ctl_neutron_conf.orig
mv $ctl_ml2_conf $ctl_ml2_conf.orig
mv $ctl_linuxbridge_agent $ctl_linuxbridge_agent.orig
mv $ctl_dhcp_agent $ctl_dhcp_agent.orig
mv $ctl_metadata_agent $ctl_metadata_agent.orig
mv $ctl_l3_agent_conf $ctl_l3_agent_conf.orig
```

- Copy file `/etc/neutron/neutron.conf`, `/etc/neutron/plugins/ml2/ml2_conf.ini`, `/etc/neutron/plugins/ml2/linuxbridge_agent.ini`, `/etc/neutron/dhcp_agent.ini`, `/etc/neutron/metadata_agent.ini`, `/etc/neutron/l3_agent.ini`

- Phân quyền

``` sh
chown root:neutron /etc/neutron/neutron.conf
chown root:neutron /etc/neutron/plugins/ml2/ml2_conf.ini
chown root:neutron /etc/neutron/plugins/ml2/linuxbridge_agent.ini
chown root:neutron /etc/neutron/dhcp_agent.ini
chown root:neutron /etc/neutron/metadata_agent.ini
chown root:neutron /etc/neutron/l3_agent.ini
```

- Đồng bộ db

``` sh
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
            --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
```

- Khởi động dịch vụ

``` sh
systemctl enable neutron-server.service
systemctl start neutron-server.service
systemctl enable neutron-linuxbridge-agent.service
systemctl start neutron-dhcp-agent.service
systemctl enable neutron-dhcp-agent.service
systemctl start neutron-linuxbridge-agent.service
systemctl enable neutron-metadata-agent.service
systemctl start neutron-metadata-agent.service
systemctl enable neutron-l3-agent.service
systemctl start neutron-l3-agent.service
```

- Kiểm tra lại

`openstack network agent list`

**Bước 6: Cài horizone

- Cài packages

`yum -y install openstack-dashboard`

- Copy file `/var/www/html/index.html`
- Backup file

`mv /etc/openstack-dashboard/local_settings /etc/openstack-dashboard/local_settings.orig`

- Copy file `/etc/openstack-dashboard/local_settings`

- Phân quyền

`chown root:apache /etc/openstack-dashboard/local_settings`

- Restart lại dịch vụ

`systemctl restart httpd.service memcached.service`

- Vào dashboard và kiểm tra.

**Link tham khảo**

https://github.com/congto/openstack-tools/tree/master/scripts/OpenStack-Pike-No-HA

https://www.ibm.com/support/knowledgecenter/en/SST55W_4.3.0/liaca/liaca_restore_single-region_controller.html
