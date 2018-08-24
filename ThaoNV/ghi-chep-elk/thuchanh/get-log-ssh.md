# Hướng dẫn dùng ELK Stack để bắt log SSH, phân tích và gửi cảnh báo qua mail + slack

## Mục lục

- [1. Hướng dẫn tách log ssh khỏi log secure](#1)
- [2. Hướng dẫn cấu hình ELK lấy log SSH và filter](#2)
- [3. Hướng dẫn cảnh báo dùng ElasAlert](#3)
- [4. Hướng dẫn cấu hình geoip](#4)

### Lưu ý: Hướng dẫn này sử dụng ELK version 6 và OS CentOS 7

<a name="1"></a>
### 1. Hướng dẫn tách log ssh khỏi log secure

Mặc định log của ssh sẽ được lưu tại `/var/log/secure`. File này chứa các log liên quan tới bảo mật. Để thuận tiện hơn cho việc get log và filter, ta sẽ cấu hình để ssh ghi log sang file khác.

Chỉnh sửa file cấu hình ssh `/etc/ssh/sshd_config`

`SyslogFacility local3`

Chỉnh sửa lại file cấu hình rsyslog `/etc/rsyslog.conf`

```
# Log ssh
local3.*                                                /var/log/ssh
```

Restart lại `ssh` và `rsyslog`

Kiểm tra lại file log

<a name="2"></a>
### 2. Hướng dẫn cấu hình ELK lấy log SSH và filter

Tham khảo hướng dẫn cài đặt ELK version 6 trên CentOS 7 [tại đây](https://github.com/thaonguyenvan/meditech-thuctap/blob/master/ThaoNV/ghi-chep-elk/thuchanh/install-elk-get-log-ops.md)

Sau khi cài đặt logstash, tạo 3 file trong thư mục `/etc/logstash/conf.d/` như sau

`01-input.conf`

```
input {
  beats {
    port => 5044
    ssl => false
  }
}
```

`03-filter.conf`

```
filter {
    grok {
      match => {
        "message" => [
          "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?:? %{SSH_INVALID_USER:message}"
        ]
      }
      patterns_dir => "/etc/logstash/patterns/sshd"
      named_captures_only => true
      remove_tag => ["_grokparsefailure"]
      break_on_match => true
      add_tag => [ "SSH", "SSH_INVALID_USER" ]
      add_field => { "event_type" => "SSH_INVALID_USER" }
      overwrite => "message"
    }
}

# Grok Filter for SSH Failed Password
filter{
    grok {
      match => {
        "message" => [
          "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?:? %{SSH_FAILED_PASSWORD:message}"
        ]
      }
      patterns_dir => "/etc/logstash/patterns/sshd"
      named_captures_only => true
      remove_tag => ["_grokparsefailure"]
      break_on_match => true
      add_tag => [ "SSH", "SSH_FAILED_PASSWORD" ]
      add_field => { "event_type" => "SSH_FAILED_PASSWORD" }
      overwrite => "message"
    }
}

filter {
# Grok Filter for SSH Password Accepted

    grok {
      match => {
        "message" => [
          "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?:? %{SSH_ACCEPTED_PASSWORD}"
        ]
      }
      patterns_dir => "/etc/logstash/patterns/sshd"
      named_captures_only => true
      remove_tag => ["_grokparsefailure"]
      break_on_match => true
      add_tag => [ "SSH", "SSH_ACCEPTED_PASSWORD" ]
      add_field => { "event_type" => "SSH_ACCEPTED_PASSWORD" }
    }
}
```

`05-output.conf`

```
output {
#     stdout { codec => json }
     elasticsearch {
       hosts => ["localhost:9200"]
       sniffing => true
       index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
     }
}
```

**Lưu ý:**

Phần `stdout { codec => json }` dùng để debug kiểm tra filter. Khi không dùng có thể comment lại.

Tạo thư mục và file pattern

```
mkdir -p /etc/logstash/patterns/

cat << EOF >> /etc/logstash/patterns/sshd
SSH_FAILED_PASSWORD Failed password for %{USERNAME:username} from (?:%{IPV6:src_ipv6}|%{IPV4:src_ipv4}) port %{BASE10NUM:src_port} ssh2

SSH_INVALID_USER Failed password for invalid user %{USERNAME:username} from (?:%{IPV6:src_ipv6}|%{IPV4:src_ipv4}) port %{BASE10NUM:src_port} ssh2

SSH_ACCEPTED_PASSWORD Accepted password for %{USERNAME:username} from (?:%{IPV6:src_ipv6}|%{IPV4:src_ipv4}) port %{BASE10NUM:src_port} ssh2
EOF
```

Tiếp tục cài các thành phần còn lại.

Trên máy agent đẩy log về, sau khi cài filebeat, cấu hình file `/etc/filebeat/filebeat.yml` như sau

```
filebeat.prospectors:
- type: log
  paths:
    - /var/log/ssh
output.logstash:
  hosts: ["192.168.100.37:5044"]
logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat
  keepfiles: 7
  permissions: 0644
```

Sau khi start filebeat, trên phía ELK server, tiếp hành chạy lệnh sau để kiểm tra log đẩy về xem đã được filter đúng chưa

`/usr/share/logstash/bin/logstash "--path.settings" "/etc/logstash"`

**Lưu ý:**

Đặt `stdout { codec => json }` trong phần output để logstash đẩy kết quả ra console cho chúng ta kiểm tra.
Nếu log chưa filter đúng, hãy thử từng phần một để xem sai ở đâu.

Sau khi đã filter OK, tiến hành kiểm tra trên giao diện Kibana.

<img src="https://i.imgur.com/GbMDsdM.png">

<a name="3"></a>
### 3. Hướng dẫn cảnh báo dùng ElasAlert

- Cấu hình gửi mail, tham khảo [tại đây](https://github.com/thaonguyenvan/meditech-ghichep-omd/blob/master/docs/5.1.Send-Noitify.md)

- Cài đặt các packages requirements

```
yum install epel-release -y
yum install git python-pip python-devel gcc -y
```

- Clone ElasAlert repo

`git clone https://github.com/thaonguyenvan/elastalert.git`

- Install requirements

```
cd elastalert/
pip install -r requirements.txt
pip install elastalert
```

Nếu gặp lỗi version setuptools, chạy lệnh sau để upgrade versions rồi tiếp tục install requirements

`pip install --upgrade setuptools`

- Tạo file config

`cp config.yaml.example config.yaml`

- Sửa file config

```
rules_folder: alert_rules
run_every:
  minutes: 1
buffer_time:
  minutes: 15
es_host: localhost
es_port: 9200
writeback_index: elastalert_status
alert_time_limit:
  days: 2
```

Lưu ý: thay `es_host` nếu bạn chạy ElasAlert trên máy khác.

Tạo Index cho ElasAlert

`elastalert-create-index`

- Tạo folder chứa rule và file rule

```
mkdir -p /root/elastalert/alert_rules/

cat << EOF >> /root/elastalert/alert_rules/test.yml
# The following values need to be configured for your environment
es_host: 'localhost'
es_port: 9200

index: filebeat-*
name: SSH Authentication Failure
type: any

filter:
- query:
    query_string:
      query: "event_type:SSH_FAILED_PASSWORD OR event_type:SSH_INVALID_USER"

alert:
- "email"
- "slack"
email:
- "thaonv2610@gmail.com"

slack_webhook_url:
- "https://hooks.slack.com/services/xxxxx"
slack_channel_override: "#alerts-checkmk"
slack_username_override: "MDT-ALERT"

alert_text: |
    ElastAlert has detected a failed login attempt:
    Message: {0}
    Source IP: {1}
    Source Host: {2}
    Timestamp: {3}
alert_text_args:
  - "message"
  - "src_ipv4"
  - "syslog_hostname"
  - "syslog_timestamp"

alert_text_type: alert_text_only
EOF
```

- Test rule

`elastalert-test-rule /root/elastalert/alert_rules/test.yml`

- Chạy ElasAlert

`python -m elastalert.elastalert --config /root/elastalert/config.yaml --rule /root/elastalert/alert_rules/test.yml --verbose`

- Install zdaemon

`pip install zdaemon`

- Tạo file `zdaemon.conf`

```
<runner>
  program python -m elastalert.elastalert --config /root/elastalert/config.yaml --rule /root/elastalert/alert_rules/test.yml
  socket-name /tmp/elastalert.zdsock
  forever true
</runner>
```

- Start zdaemon

`zdaemon -C zdaemon.conf start`

- Stop zdaemon

`zdaemon -C zdaemon.conf stop`

- Kiểm tra

<img src="https://i.imgur.com/4anLetW.png">

<a name=""></a>
### 4. Hướng dẫn cấu hình geoip

Để cấu hình geoip, trước tiên ta cần filter được field source ip.

Tại phần cấu hình filter trên logstash, ta thêm những cấu hình sau:

```
filter {
    if [src_ipv4] {
     geoip {
       source => "src_ipv4"
       target => "geoip"
       database => "/opt/geoip/GeoLite2-City.mmdb"
       add_field => [ "[geoip][coordinates]", "%{[geoip][longitude]}" ]
       add_field => [ "[geoip][coordinates]", "%{[geoip][latitude]}" ]
    }
    mutate {
     convert => [ "[geoip][coordinates]", "float" ]
    }
    }
}
```

Tại phần cấu hình output cho logstash, ta để index mặc định là logstash-* .

Sau khi cấu hình xong, tiến hành add biểu đồ lên Kibana

<img src="https://i.imgur.com/V8FfTFo.png">

<img src="https://media1.giphy.com/media/1zSiX3p2XEZpe/giphy.gif">

**Link tham khảo**

https://github.com/locvx1234/Elastalert-docs/blob/master/Deployment.md

https://github.com/manankalra/elastalert-tutorial/blob/master/README.md

https://github.com/sohonetlabs/cise-elk/tree/master/sources/syslog

https://www.elastic.co/guide/en/logstash/current/plugins-outputs-stdout.html

https://elastalert.readthedocs.io/en/latest/index.html
