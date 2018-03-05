# Hướng dẫn dựng mô hình ops ha với haproxy, pacemaker và corosync

## Mục lục

1. Mô hình

2. Hướng dẫn cấu hình

-----------------

## 1. Mô hình

<img src="">

Môi trường lab: KVM
Phiên bản OPS sử dụng: Pike

IP Planing

<img src="">

## 2. Hướng dẫn cấu hình

### 2.1 Cấu hình môi trường

- Cài đặt ip theo ip plan

- Set hostname trên cả 3 máy

```
hostnamectl set-hostname ctl1
hostnamectl set-hostname ctl2
hostnamectl set-hostname ctl3
```

- Tắt selinux và firewalld trên cả 3 node

```
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
systemctl disable firewalld
systemctl stop firewalld
```

- Cài đặt repo galera trên cả 3 node

```
echo '[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1' >> /etc/yum.repos.d/MariaDB.repo
yum -y update
```

- Cài đặt repo ops pike trên cả 3 node

```
yum -y install centos-release-openstack-pike
yum -y upgrade
yum -y install crudini wget vim
yum -y install python-openstackclient openstack-selinux python2-PyMySQL
yum -y update
```

- Khai báo host trên cả 3 node

```
echo "192.168.100.40 ctl1" >> /etc/hosts
echo "192.168.100.41 ctl2" >> /etc/hosts
echo "192.168.100.42 ctl3" >> /etc/hosts
```

- Cài đặt ntp server cho cả 3 node

```
yum -y install chrony
sed -i 's/server 0.centos.pool.ntp.org iburst/ \
server 1.vn.pool.ntp.org iburst \
server 0.asia.pool.ntp.org iburst \
server 3.asia.pool.ntp.org iburst/g' /etc/chrony.conf
sed -i 's/server 1.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
sed -i 's/server 2.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
sed -i 's/server 3.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
sed -i 's/#allow 192.168.0.0\/16/allow 192.168.100.0\/24/g' /etc/chrony.conf
systemctl enable chronyd.service
systemctl start chronyd.service
systemctl restart chronyd.service
chronyc sources
```

- Cài đặt memcached server trên cả 3 node


`yum install -y memcached`

Chỉnh sửa file `/etc/sysconfig/memcached`

```
PORT="11211"
USER="memcached"
MAXCONN="1024"
CACHESIZE="64"
OPTIONS=""
```

```
systemctl enable memcached.service
systemctl start memcached.service
```

- Khởi động lại cả 3 máy

`init 6`

### 2.2 Cài đặt mysql và rabbitmq cluster

- Cài đặt galera cluster

  - Cài đặt packages

  `yum -y install mariadb-server rsync xinetd crudini`

  - Sao lưu file cấu hình của mariadb

  `cp /etc/my.cnf.d/server.cnf  /etc/my.cnf.d/server.cnf.orig`

  - Khởi động mysql

  `systemctl start mariadb`

  - Đặt password cho MariaDB

  ```
  password_galera_root=Welcome123
  cat << EOF | mysql -uroot
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$password_galera_root';FLUSH PRIVILEGES;
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$password_galera_root';FLUSH PRIVILEGES;
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'ctl3' IDENTIFIED BY '$password_galera_root';FLUSH PRIVILEGES;
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY '$password_galera_root';FLUSH PRIVILEGES;
  EOF
  ```

  - Sửa file cấu hình trên ctl1

  ```
  cat << EOF >> /etc/my.cnf.d/server.cnf
  [galera]
  wsrep_on=ON
  binlog_format=ROW
  default-storage-engine=innodb
  innodb_autoinc_lock_mode=2
  innodb_locks_unsafe_for_binlog=1
  query_cache_size=0
  query_cache_type=0
  bind-address=192.168.100.40
  datadir=/var/lib/mysql
  innodb_log_file_size=100M
  innodb_file_per_table
  innodb_flush_log_at_trx_commit=2
  wsrep_provider=/usr/lib64/galera/libgalera_smm.so
  wsrep_cluster_address="gcomm://192.168.100.40,192.168.100.41,192.168.100.42"
  wsrep_cluster_name='galera_cluster'
  wsrep_node_address="192.168.100.40"
  wsrep_node_name='ctl1'
  wsrep_sst_method=rsync
  max_connections = 10240
  #max_allowed_packet = 16M
  skip-name-resolve
  #key_buffer = 16M
  #thread_stack = 192K
  #thread_cache_size = 8
  #innodb_buffer_pool_size = 64M
  EOF
  ```

  - Sửa file cấu hình trên ctl2

  ```
  cat << EOF >> /etc/my.cnf.d/server.cnf
  [galera]
  wsrep_on=ON
  binlog_format=ROW
  default-storage-engine=innodb
  innodb_autoinc_lock_mode=2
  innodb_locks_unsafe_for_binlog=1
  query_cache_size=0
  query_cache_type=0
  bind-address=192.168.100.41
  datadir=/var/lib/mysql
  innodb_log_file_size=100M
  innodb_file_per_table
  innodb_flush_log_at_trx_commit=2
  wsrep_provider=/usr/lib64/galera/libgalera_smm.so
  wsrep_cluster_address="gcomm://192.168.100.40,192.168.100.41,192.168.100.42"
  wsrep_cluster_name='galera_cluster'
  wsrep_node_address="192.168.100.41"
  wsrep_node_name='ctl2'
  wsrep_sst_method=rsync
  max_connections = 10240
  #max_allowed_packet = 16M
  skip-name-resolve
  #key_buffer = 16M
  #thread_stack = 192K
  #thread_cache_size = 8
  #innodb_buffer_pool_size = 64M
  EOF
  ```

  - Sửa file cấu hình trên ctl3

  ```
  cat << EOF >> /etc/my.cnf.d/server.cnf
  [galera]
  wsrep_on=ON
  binlog_format=ROW
  default-storage-engine=innodb
  innodb_autoinc_lock_mode=2
  innodb_locks_unsafe_for_binlog=1
  query_cache_size=0
  query_cache_type=0
  bind-address=192.168.100.42
  datadir=/var/lib/mysql
  innodb_log_file_size=100M
  innodb_file_per_table
  innodb_flush_log_at_trx_commit=2
  wsrep_provider=/usr/lib64/galera/libgalera_smm.so
  wsrep_cluster_address="gcomm://192.168.100.40,192.168.100.41,192.168.100.42"
  wsrep_cluster_name='galera_cluster'
  wsrep_node_address="192.168.100.42"
  wsrep_node_name='ctl3'
  wsrep_sst_method=rsync
  max_connections = 10240
  #max_allowed_packet = 16M
  skip-name-resolve
  #key_buffer = 16M
  #thread_stack = 192K
  #thread_cache_size = 8
  #innodb_buffer_pool_size = 64M
  EOF
  ```

  - Tắt mariadb trên node đã bật

  `systemctl stop mariadb`

  - Tạo cluster, thực hiện trên 1 node bất kỳ

  `galera_new_cluster`

  - Bật mysql trên 2 node còn lại

  `systemctl start mariadb`

- Cấu hình để haproxy check dịch vụ mysql

  - Cài đặt git

  `yum install git -y`

  - Tải script

  ```
  git clone https://github.com/olafz/percona-clustercheck
  cp percona-clustercheck/clustercheck /usr/local/bin
  ```

  - Tạo file `/etc/xinetd.d/mysqlchk`

  ```
  service mysqlchk
  {
        disable = no
        flags = REUSE
        socket_type = stream
        port = 9200             # This port used by xinetd for clustercheck
        wait = no
        user = nobody
        server = /usr/local/bin/clustercheck
        log_on_failure += USERID
        only_from = 0.0.0.0/0
        per_source = UNLIMITED
  }
  ```

  - Thêm service

  `echo 'mysqlchk      9200/tcp    # MySQL check' >> /etc/services`

  - Tạo user cho mysql và phân quyền

  ```
  mysql> GRANT PROCESS ON *.* TO 'clustercheckuser'@'localhost' IDENTIFIED BY 'clustercheckpassword!';
  mysql> FLUSH PRIVILEGES;
  ```

  - Check lại script

  ```
  $ /usr/local/bin/clustercheck > /dev/null
  $ echo $?
  0
  ```

  Nếu ok, kết quả trả về sẽ là `0`

  - Bật xinetd

  ```
  systemctl start xinetd
  systemctl enable xinetd
  ```

- Cài đặt rabbitmq server

  - Cài đặt package trên cả 3 node

    `yum -y install rabbitmq-server`

  - Trên node ctl1

    ```
    cat > /etc/rabbitmq/rabbitmq-env.conf << EOF
    NODE_IP_ADDRESS=192.168.100.40
    EOF

    systemctl start rabbitmq-server
    systemctl stop rabbitmq-server
    scp -p /var/lib/rabbitmq/.erlang.cookie ctl2:/var/lib/rabbitmq
    scp -p /var/lib/rabbitmq/.erlang.cookie ctl3:/var/lib/rabbitmq
    ```

  - Trên 2 node còn lại

    ```
    chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie

    cat > /etc/rabbitmq/rabbitmq-env.conf << EOF
    NODE_IP_ADDRESS=192.168.100.4x
    EOF
    ```

  - Start dịch vụ trên tất cả các node

    ```
    systemctl enable rabbitmq-server.service
    systemctl start rabbitmq-server.service
    ```

  - Thực hiện trên 2 node ctl2 và 3

    ```
    rabbitmqctl stop_app
    rabbitmqctl join_cluster rabbit@ctl1
    rabbitmqctl start_app
    ```

  - Kiểm tra lại trạng thái của cluster

    `rabbitmqctl cluster_status`

  - Set ha mode, thực hiện trên 1 node bất kì

    `rabbitmqctl set_policy ha-all '^(?!amq\.).*' '{"ha-mode": "all"}'`

  - Thêm user và phân quyền, thực hiện trên 1 node bất kì

    ```
    rabbitmqctl add_user openstack Welcome123
    rabbitmqctl set_permissions openstack ".*" ".*" ".*"
    ```

### 2.3 Cấu hình haproxy + pacemaker

- Tải packages

`yum install pacemaker corosync haproxy pcs fence-agents-all resource-agents psmisc policycoreutils-python -y`

- Cho phép VIP

```
echo "net.ipv4.ip_nonlocal_bind=1" >> /etc/sysctl.conf
```

- Đặt password cho hacluster (thực hiện giống nhau trên cả 3 node)

`passwd hacluster`

- Enable dịch vụ và start trên cả 3 node

```
systemctl enable pcsd.service pacemaker.service corosync.service haproxy.service
systemctl start pcsd.service
```

- Thực hiện xác thực trên 1 node bất kì

`pcs cluster auth ctl1 ctl2 ctl3`

- Set up cluster

```
pcs cluster setup --start --name ops-cluster ctl1 ctl2 ctl3
```

- Enable cluster

`pcs cluster enable --all`

- Kiểm tra

`pcs status`

- Set properties

```
pcs property set stonith-enabled=false
pcs property set default-resource-stickiness="INFINITY"
```

- Tạo resource VIP và haproxy

```
pcs resource create Virtual_IP ocf:heartbeat:IPaddr2 ip=192.168.100.45 cidr_netmask=24 op monitor interval=30s
pcs resource create HAproxy systemd:haproxy op monitor interval=5s
```

- Thêm rule

```
pcs constraint colocation add HAproxy Virtual_IP INFINITY
pcs constraint order Virtual_IP then HAproxy
```

- Cấu hình cho file `/etc/haproxy/haproxy.cnf` trên cả 3 node

```
global
    daemon
    group  haproxy
    log  /dev/log local0
    log /dev/log    local1 notice
    maxconn  16000
    pidfile  /var/run/haproxy.pid
    stats  socket /var/lib/haproxy/stats
    tune.bufsize  32768
    tune.maxrewrite  1024
    user  haproxy

defaults
    log  global
    maxconn  8000
    mode  http
    option  redispatch
    option  http-server-close
    option  splice-auto
    retries  3
    timeout  http-request 20s
    timeout  queue 1m
    timeout  connect 10s
    timeout  client 1m
    timeout  server 1m
    timeout  check 10s

listen stats
    bind 192.168.100.45:8080
    mode http
    stats enable
    stats uri /stats
    stats realm HAProxy\ Statistics

listen mysqld
    bind 192.168.100.45:3306
    balance  leastconn
    mode  tcp
    option  httpchk
    option  tcplog
    option  clitcpka
    option  srvtcpka
    timeout client  28801s
    timeout server  28801s
    server ctl1 192.168.100.40:3306 check port 9200 inter 5s fastinter 2s rise 3 fall 3 backup
    server ctl2 192.168.100.41:3306 check port 9200 inter 5s fastinter 2s rise 3 fall 3 backup
    server ctl3 192.168.100.42:3306 check port 9200 inter 5s fastinter 2s rise 3 fall 3


listen keystone-5000
    bind 192.168.100.45:5000
    option  httpchk
    option  httplog
    option  httpclose
    balance source
    server ctl1 192.168.100.40:5000  check inter 5s fastinter 2s downinter 2s rise 3 fall 3
    server ctl2 192.168.100.41:5000  check inter 5s fastinter 2s downinter 2s rise 3 fall 3
    server ctl3 192.168.100.42:5000  check inter 5s fastinter 2s downinter 2s rise 3 fall 3

listen keystone-35357
    bind 192.168.100.45:35357
    option  httpchk
    option  httplog
    option  httpclose
    balance source
    server ctl1 192.168.100.40:35357  check inter 5s fastinter 2s downinter 2s rise 3 fall 3
    server ctl2 192.168.100.41:35357  check inter 5s fastinter 2s downinter 2s rise 3 fall 3
    server ctl3 192.168.100.42:35357  check inter 5s fastinter 2s downinter 2s rise 3 fall 3

#listen nova-api-8773
#    bind 10.3.10.6:8773
#    timeout server  600s
#    server ctl1 10.3.10.1:8773  check
#    server ctl2 10.3.10.2:8773  check
#    server ctl3 10.3.10.3:8773  check

listen nova-api-8774
    bind 192.168.100.45:8774
    option  httpchk
    option  httplog
    option  httpclose
    timeout server  600s
    server ctl1 192.168.100.40:8774  check inter 5s fastinter 2s downinter 3s rise 3 fall 3
    server ctl2 192.168.100.41:8774  check inter 5s fastinter 2s downinter 3s rise 3 fall 3
    server ctl3 192.168.100.42:8774  check inter 5s fastinter 2s downinter 3s rise 3 fall 3

listen nova-metadata-api
    bind 192.168.100.45:8775
    option  httpchk
    option  httplog
    option  httpclose
    server ctl1 192.168.100.40:8775  check inter 5s fastinter 2s downinter 3s rise 3 fall 3
    server ctl2 192.168.100.41:8775  check inter 5s fastinter 2s downinter 3s rise 3 fall 3
    server ctl3 192.168.100.42:8775  check inter 5s fastinter 2s downinter 3s rise 3 fall 3

listen nova-novncproxy
    balance source
    option tcpka
    maxconn 10000
    bind 192.168.100.45:6080
    balance  roundrobin
    option  httplog
    capture request header X-Auth-Project-Id len 50
    capture request header User-Agent len 50
    server ctl1 192.168.100.40:6080  check inter 2000 rise 2 fall 5
    server ctl2 192.168.100.41:6080  check inter 2000 rise 2 fall 5
    server ctl3 192.168.100.42:6080  check inter 2000 rise 2 fall 5

listen glance-api
    bind 192.168.100.45:9292
    option  httpchk /versions
    option  httplog
    option  httpclose
    timeout server  11m
    server ctl1 192.168.100.40:9292  check inter 5s fastinter 2s downinter 3s rise 3 fall 3
    server ctl2 192.168.100.41:9292  check inter 5s fastinter 2s downinter 3s rise 3 fall 3
    server ctl3 192.168.100.42:9292  check inter 5s fastinter 2s downinter 3s rise 3 fall 3

listen glance-registry
    bind 192.168.100.45:9191
    timeout server  11m
    server ctl1 192.168.100.40:9191  check
    server ctl2 192.168.100.41:9191  check
    server ctl3 192.168.100.42:9191  check

listen neutron
    bind 192.168.100.45:9696
    option  httpchk
    option  httplog
    option  httpclose
    balance source
    server ctl1 192.168.100.40:9696  check inter 5s fastinter 2s downinter 3s rise 3 fall 3
    server ctl2 192.168.100.41:9696  check inter 5s fastinter 2s downinter 3s rise 3 fall 3
    server ctl3 192.168.100.42:9696  check inter 5s fastinter 2s downinter 3s rise 3 fall 3

listen cinder-api
    bind 192.168.100.45:8776
    option  httpchk
    option  httplog
    option  httpclose
    server ctl1 192.168.100.40:8776 check inter 5s fastinter 2s downinter 3s rise 3 fall 3
    server ctl2 192.168.100.41:8776 backup check inter 5s fastinter 2s downinter 3s rise 3 fall 3
    server ctl3 192.168.100.42:8776 backup check inter 5s fastinter 2s downinter 3s rise 3 fall 3


listen horizon
    bind 192.168.100.45:80
    balance  source
    mode  http
    option  forwardfor
    option  httpchk
    option  httpclose
    option  httplog
    stick  on src
    stick-table  type ip size 200k expire 30m
    timeout  client 3h
    timeout  server 3h
    server ctl1 192.168.100.40:80  weight 1 check
    server ctl2 192.168.100.41:80  weight 1 check
    server ctl3 192.168.100.42:80  weight 1 check
```

- Khởi động lại lần lượt các server để nhận cấu hình. Lưu ý reset từng con một. Kiểm tra xem đã nhận ip vip chưa. Kiểm tra trang dashboard ở địa chỉ `http://192.168.100.45:8080/stats`

### 2.4 Cấu hình dịch vụ keystone

- Tạo db, thực hiện trên 1 node

```
mysql -u root -pWelcome123
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
IDENTIFIED BY 'Welcome123';
exit;
```

- Cài đặt package trên cả 3 node

`yum install openstack-keystone httpd mod_wsgi -y`

- Sửa các cấu hình để bind ip cho từng host
  - Trên ctl1

  ```
  cp /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/
  sed -i -e 's/VirtualHost \*/VirtualHost 192.168.100.40/g' /etc/httpd/conf.d/wsgi-keystone.conf
  sed -i -e 's/Listen 5000/Listen 192.168.100.40:5000/g' /etc/httpd/conf.d/wsgi-keystone.conf
  sed -i -e 's/Listen 35357/Listen 192.168.100.40:35357/g' /etc/httpd/conf.d/wsgi-keystone.conf
  sed -i -e 's/^Listen.*/Listen 192.168.100.40:80/g' /etc/httpd/conf/httpd.conf
  ```
  - Trên ctl2

  ```
  cp /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/
  sed -i -e 's/VirtualHost \*/VirtualHost 192.168.100.41/g' /etc/httpd/conf.d/wsgi-keystone.conf
  sed -i -e 's/Listen 5000/Listen 192.168.100.41:5000/g' /etc/httpd/conf.d/wsgi-keystone.conf
  sed -i -e 's/Listen 35357/Listen 192.168.100.41:35357/g' /etc/httpd/conf.d/wsgi-keystone.conf
  sed -i -e 's/^Listen.*/Listen 192.168.100.41:80/g' /etc/httpd/conf/httpd.conf
  ```

  - Trên ctl3

  ```
  cp /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/
  sed -i -e 's/VirtualHost \*/VirtualHost 192.168.100.42/g' /etc/httpd/conf.d/wsgi-keystone.conf
  sed -i -e 's/Listen 5000/Listen 192.168.100.42:5000/g' /etc/httpd/conf.d/wsgi-keystone.conf
  sed -i -e 's/Listen 35357/Listen 192.168.100.42:35357/g' /etc/httpd/conf.d/wsgi-keystone.conf
  sed -i -e 's/^Listen.*/Listen 192.168.100.42:80/g' /etc/httpd/conf/httpd.conf
  ```

- Sửa file cấu hình `/etc/keystone/keystone.conf` trên cả 3 node

```
[DEFAULT]
[assignment]
[auth]
[cache]
[catalog]
[cors]
[credential]
[database]
connection = mysql+pymysql://keystone:Welcome123@192.168.100.45/keystone
[domain_config]
[endpoint_filter]
[endpoint_policy]
[eventlet_server]
[federation]
[fernet_tokens]
[healthcheck]
[identity]
[identity_mapping]
[ldap]
[matchmaker_redis]
[memcache]
[oauth1]
[oslo_messaging_amqp]
[oslo_messaging_kafka]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
[oslo_messaging_zmq]
[oslo_middleware]
[oslo_policy]
[paste_deploy]
[policy]
[profiler]
[resource]
[revoke]
[role]
[saml]
[security_compliance]
[shadow_users]
[signing]
[token]
provider = fernet
[tokenless_auth]
[trust]
```

- Đồng bộ db trên 1 node

`su -s /bin/sh -c "keystone-manage db_sync" keystone`

- Set up fernet key

```
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
```

- Copy 2 thư mục là `/etc/keystone/credential-keys` và `/etc/keystone/fernet-keys` sang 2 con ctl còn lại. Hoặc ta có thể dùng rsync hoặc nfs, miễn sao 2 thư mục này được đồng bộ trên cả 3 node.

- Bootstrap keystone

```
keystone-manage bootstrap --bootstrap-password Welcome123 \
  --bootstrap-admin-url http://192.168.100.45:35357/v3/ \
  --bootstrap-internal-url http://192.168.100.45:5000/v3/ \
  --bootstrap-public-url http://192.168.100.45:5000/v3/ \
  --bootstrap-region-id RegionOne
```

- Bật httpd trên cả 3 node

```
systemctl start httpd
systemctl enable httpd
```

- Cấu hình các biến môi trường

```
export OS_USERNAME=admin
export OS_PASSWORD=Welcome123
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://192.168.100.45:35357/v3
export OS_IDENTITY_API_VERSION=3
```

- Tạo project

```
openstack project create --domain default \
  --description "Service Project" service

openstack project create --domain default \
  --description "Demo Project" demo
```

- Tạo user demo, role và gán role

```
openstack user create --domain default \
  --password Welcome123 demo

openstack role create user
openstack role add --project demo --user demo user
```

- unset 2 biến môi trường

`unset OS_AUTH_URL OS_PASSWORD`

- Request thử token

```
openstack --os-auth-url http://192.168.100.45:35357/v3 \
  --os-project-domain-name Default --os-user-domain-name Default \
  --os-project-name admin --os-username admin token issue
```

- Tạo file `admin-openrc`

```
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=Welcome123
export OS_AUTH_URL=http://192.168.100.45:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
```

- Tạo file `demo-openrc`

```
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=Welcome123
export OS_AUTH_URL=http://192.168.100.45:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
```

- Dùng thử script

`. admin-openrc`

`openstack token issue`

### 2.5 Cấu hình dịch vụ glance

- Tạo db, thực hiện trên 1 node

```
mysql -u root -pWelcome123

CREATE DATABASE glance;

GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
  IDENTIFIED BY 'Welcome123';

GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
  IDENTIFIED BY 'Welcome123';
```

- Tạo user, gán quyền admin và tạo service, thực hiện trên 1 node

```
. admin-openrc
openstack user create --domain default --password Welcome123 glance
openstack role add --project service --user glance admin
openstack service create --name glance \
  --description "OpenStack Image" image
```

- Tạo endpoints trên 1 node

```
openstack endpoint create --region RegionOne \
  image public http://192.168.100.45:9292

openstack endpoint create --region RegionOne \
  image internal http://192.168.100.45:9292

openstack endpoint create --region RegionOne \
  image admin http://192.168.100.45:9292
```

- Cài đặt packages trên cả 3 node

```
yum install -y openstack-glance
```

- Cấu hình file `/etc/glance/glance-api.conf` trên cả 3 node.

Lưu ý: Thay `bind_host` trong section `[DEFAULT]` với ip của máy chủ tương ứng

```
[DEFAULT]
bind_host = 192.168.100.40
registry_host = 192.168.100.45
[cors]
[database]
connection = mysql+pymysql://glance:Welcome123@192.168.100.45/glance
[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/
[image_format]
[keystone_authtoken]
auth_uri = http://192.168.100.45:5000
auth_url = http://192.168.100.45:35357
memcached_servers = 192.168.100.40:11211,192.168.100.41:11211,192.168.100.42:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = glance
password = Welcome123
[matchmaker_redis]
[oslo_concurrency]
[oslo_messaging_amqp]
[oslo_messaging_kafka]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
[oslo_messaging_zmq]
[oslo_middleware]
[oslo_policy]
[paste_deploy]
flavor = keystone
[profiler]
[store_type_location_strategy]
[task]
[taskflow_executor]
```

- Cấu hình file `/etc/glance/glance-registry.conf` trên cả 3 node
Lưu ý: Thay `bind_host` trong section `[DEFAULT]` với ip của máy chủ tương ứng

```
[DEFAULT]
bind_host = 192.168.100.40
[database]
connection = mysql+pymysql://glance:Welcome123@192.168.100.45/glance
[keystone_authtoken]
auth_uri = http://192.168.100.45:5000
auth_url = http://192.168.100.45:35357
memcached_servers = 192.168.100.40:11211,192.168.100.41:11211,192.168.100.42:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = glance
password = Welcome123
[matchmaker_redis]
[oslo_messaging_amqp]
[oslo_messaging_kafka]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
[oslo_messaging_zmq]
[oslo_policy]
[paste_deploy]
flavor = keystone
[profiler]
```

- Đồng bộ db, thực hiện trên 1 node

```
su -s /bin/sh -c "glance-manage db_sync" glance
```

- Bật dịch vụ

```
systemctl enable openstack-glance-api.service \
  openstack-glance-registry.service

systemctl start openstack-glance-api.service \
  openstack-glance-registry.service
```

- Khi ta tạo image, mặc định nó sẽ được lưu tại `/var/lib/glance/images/`. Chúng ta có thể cấu hình nfs server trên 1 node và share cho những node còn lại hoặc copy bằng tay mỗi khi tạo image sang 2 node còn lại.

- Download và tạo image cirros

```
. admin-openrc
wget http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img
openstack image create "cirros" \
  --file cirros-0.3.5-x86_64-disk.img \
  --disk-format qcow2 --container-format bare \
  --public
```

Để lấy id của image, sử dụng câu lệnh shadow_users

`openstack image list`

Sau khi có id của image, ta vào thư mục `/var/lib/glance/images/` trên cả 3 node và copy image có id vừa tạo sang 2 node còn lại.

### 2.6 Cấu hình dịch vụ nova

- Tạo db và gán quyền trên 1 node

```
mysql -u root -pWelcome123
CREATE DATABASE nova_api;
CREATE DATABASE nova;
CREATE DATABASE nova_cell0;
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'Welcome123';

GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \
  IDENTIFIED BY 'Welcome123';

GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'Welcome123';

GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \
  IDENTIFIED BY 'Welcome123';

GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'Welcome123';

GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' \
  IDENTIFIED BY 'Welcome123';
```

- Tạo user, gán quyền và tạo service

```
. admin-openrc
openstack user create --domain default --password Welcome123 nova
openstack role add --project service --user nova admin
openstack service create --name nova \
  --description "OpenStack Compute" compute

openstack endpoint create --region RegionOne \
  compute public http://192.168.100.45:8774/v2.1

openstack endpoint create --region RegionOne \
  compute internal http://192.168.100.45:8774/v2.1

openstack endpoint create --region RegionOne \
  compute admin http://192.168.100.45:8774/v2.1
```

```
openstack user create --domain default --password Welcome123 placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement

openstack endpoint create --region RegionOne placement public http://192.168.100.45:8778

openstack endpoint create --region RegionOne placement internal http://192.168.100.45:8778

openstack endpoint create --region RegionOne placement admin http://192.168.100.45:8778
```

- Cài packages trên cả 3 node

```
yum install -y openstack-nova-api openstack-nova-conductor \
  openstack-nova-console openstack-nova-novncproxy \
  openstack-nova-scheduler openstack-nova-placement-api
```

-
