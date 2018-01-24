### Prepare
yum install java-1.8.0-openjdk-headless.x86_64 -y
yum install epel-release -y
yum install pwgen -y

#### disable and stop firewalld 
systemctl stop firewalld
systemctl disbale firewalld

#### disable selinux 
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/selinux/config
setenforce 0

#### install MongoDB
cat << EOF > /etc/yum.repos.d/mongodb-org-3.2.repo
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc
EOF
yum install mongodb-org -y
chkconfig --add mongod
systemctl daemon-reload
systemctl enable mongod.service
systemctl start mongod.service

### install elasticsearch
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat << EOF > /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-5.x]
name=Elasticsearch repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
yum install elasticsearch -y
sed -i 's/# cluster.name: my-application/cluster.name: graylog/g' /etc/elasticsearch/elasticsearch.yml
chkconfig --add elasticsearch
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl restart elasticsearch.service

### install graylog 2.4
rpm -Uvh https://packages.graylog2.org/repo/packages/graylog-2.4-repository_latest.rpm
yum install graylog-server -y

### setup file config graylog  
echo -e "\033[32m  ##### Enter IP for Graylog server (Nhap IP cho Graylog) ##### \033[0m"
read -r IPADD
sleep 3
echo -e "\033[32m  ##### Enter password for Graylog server (Nhap password cho Graylog) ##### \033[0m"
read -r adminpass
pass_secret=$(pwgen -s 96)
sed -i -e 's|password_secret =|password_secret = '$pass_secret'|' /etc/graylog/server/server.conf
admin_hash=$(echo -n $adminpass | sha256sum | awk '{print $1}')
sed -i -e "s|root_password_sha2 =|root_password_sha2 = $admin_hash|" /etc/graylog/server/server.conf
sed -i 's|#root_timezone = UTC|root_timezone = Asia/Ho_Chi_Minh|' /etc/graylog/server/server.conf
sed -i "s|rest_listen_uri = http:\/\/127.0.0.1:9000\/api\/|rest_listen_uri = http:\/\/$IPADD:9000\/api\/|g" /etc/graylog/server/server.conf
sed -i "s|#web_listen_uri = http:\/\/127.0.0.1:9000\/|web_listen_uri = http:\/\/$IPADD:9000|" /etc/graylog/server/server.conf
sed -i -e 's|elasticsearch_shards = 4|elasticsearch_shards = 1|' /etc/graylog/server/server.conf
sed -i 's|retention_strategy = delete|retention_strategy = close|' /etc/graylog/server/server.conf
rm -f /etc/init/graylog-server.override
chkconfig --add graylog-server
systemctl daemon-reload
systemctl enable graylog-server.service
systemctl start graylog-server.service
