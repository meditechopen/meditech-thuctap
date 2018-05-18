# Hướng dẫn cài đặt ELK để lấy log từ hệ thống OpenStack

## Install java 8

`yum install java-1.8.0-openjdk -y`

Kiểm tra version :

`java -version`

## Cài đặt Elasticsearch
- Thêm repo

`rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch`

- Thêm file repo

```
cat <<EOF > /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
```

- Cài đặt elastic

`yum install elasticsearch -y`

- Start và enable service

```
systemctl daemon-reload
systemctl enable elasticsearch
systemctl start elasticsearch
```

- Thêm rule firewall

```
firewall-cmd --add-port=9200/tcp
firewall-cmd --add-port=9200/tcp --permanent
```

- Kiểm tra dịch vụ Elasticsearch

`curl -X GET http://localhost:9200`

## Cài đặt Logstash

- Thêm file repo :

```
cat << EOF > /etc/yum.repos.d/logstash.repo
[logstash-6.x]
name=Elastic repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
```

- Cài đặt Logstash

`yum install logstash -y`

## Có thể không cấu hình phần này

- Thêm SSL certificate dựa vào IP của ELK :

```
vi /etc/pki/tls/openssl.cnf
[ v3_ca ]
subjectAltName = IP: 192.168.100.36
```

- Tạo self-singed certificate cho 365 :

```
cd /etc/pki/tls
openssl req -config /etc/pki/tls/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt
```

## Cấu hình Logstash input, output và filter file :

```
cat << EOF > /etc/logstash/conf.d/02-logstash.conf
input {
  beats {
    port => 5044
    ssl => false
  }
}
filter {
     if "openstack" in [tags] {
      }
        grok {
         match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} %{DATA:pid} %{LOGLEVEL:log_level} %{GREEDYDATA:content}" }
        }

}
output {
     elasticsearch {
       hosts => ["localhost:9200"]
       sniffing => true
       index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
     }
}
EOF
```

- Start và enable service

```
systemctl daemon-reload
systemctl start logstash
systemctl enable logstash
```

- Cấu hình firewall cho phép Logstash nhận log từ client (port 5044)

```
firewall-cmd --add-port=5044/tcp
firewall-cmd --add-port=5044/tcp --permanent
```

## Cài đặt Kibana

- Tạo repo cài đặt Kibana :

```
cat <<EOF > /etc/yum.repos.d/kibana.repo
[kibana-6.x]
name=Kibana repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
```

- Cài đặt Kibana :

```
yum install kibana -y
sed -i 's/#server.host: "localhost"/server.host: "0.0.0.0"/'g /etc/kibana/kibana.yml
```

- Start và enable Kibana

```
systemctl daemon-reload
systemctl start kibana
systemctl enable kibana
```

- Cho phép truy cập Kibana web interface (port 5601)

```
firewall-cmd --add-port=5601/tcp
firewall-cmd --add-port=5601/tcp --permanent
```

- Chạy Kibana : http://192.168.0.29:5601

## Cài đặt Filebeat trên Client servers

## Cấu hình SSL, có thể bỏ qua
 - Copy SSL certificate từ server tới client :
scp /etc/pki/tls/certs/logstash-forwarder.crt root@192.168.0.100:/etc/pki/tls/certs/

 - import Elasticsearch pub GPG key tới rpm package manager :
rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch

## Cài đặt filebeat

- Tạo repo cho filebeat

```
vi /etc/yum.repos.d/filebeat.repo
[filebeat]
name=Filebeat for ELK clients
baseurl=https://packages.elastic.co/beats/yum/el/$basearch
enabled=1
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch
gpgcheck=1
```

## Tải gói filebeat

- Uubntu

```
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.2.3-amd64.deb
dpkg -i filebeat-6.2.3-amd64.deb
```

- Centos

```
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.2.4-x86_64.rpm
rpm -vi filebeat-6.2.4-x86_64.rpm
```

## Cấu hình filebeat : /etc/filebeat/filebeat.yml

```
mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.orig
touch /etc/filebeat/filebeat.yml
cat << EOF > /etc/filebeat/filebeat.yml
filebeat.prospectors:
- type: log
  paths:
    - /var/log/cinder/*.log
  fields:       {log_type: cinder}
- type: log
  paths:
    - /var/log/glance/*.log
  fields:       {log_type: glance}
- type: log
  paths:
    - /var/log/keystone/*.log
  fields:       {log_type: keystone}
- type: log
  paths:
    - /var/log/neutron/*.log
  fields:       {log_type: neutron}
- type: log
  paths:
    - /var/log/nova/*.log
  fields:       {log_type: nova}
- type: log
  paths:
    - /var/log/rabbitmq/*.log
  fields:       {log_type: rabbitmq}
- type: log
  paths:
    - /var/log/apache2/*.log
  fields:       {log_type: apache2}
- type: log
  paths:
    - /var/log/mysql/*.log
  fields:       {log_type: mysql}
- type: log
  paths:
    - /var/log/syslog
  fields:       {log_type: syslog}
- type: log
  paths:
    - /var/log/auth.log
  fields:       {log_type: ssh}
tags:
- openstack

output.logstash:
  hosts: ["172.17.40.60:5044"]
logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat
  keepfiles: 7
  permissions: 0644
EOF
```

- Start và enable Filebeat Centos

```
systemctl start filebeat
systemctl enable filebeat
```

- Start và enable Filebeat Ubuntu

```
service filebeat restart
update-rc.d filebeat defaults
```

- Kiểm tra filebeat

`curl -XGET 'http://localhost:9200/filebeat-*/_search?pretty'`
