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

  - Tạo cluster, thực hiện trên 1 node bất kỳ

  `galera_new_cluster`

  - Bật mysql trên 2 node còn lại

  `systemctl start mysql`

- Cấu hình để haproxy check dịch vụ mysql

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

- 
