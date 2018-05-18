#Hướng dẫn sử dụng ELK để lấy log từ switch Cisco

## Yêu cầu:

- SW hỗ trợ đẩy log thông qua giao thức syslog

## Hướng dẫn cài đặt ELK

Tham khảo cách cài đặt ELK 6.x [tại đây]()

Lưu ý: Thay phần filter của logstash bằng nội dung như sau:

```
input {
  udp {
    port => "8514"
    type => "syslog-cisco"
  }

  tcp {
    port => "8514"
    type => "syslog-cisco"
  }
}

filter {
  if [type] == "syslog-cisco" {
    grok {
      match => [
        "message", "%{CISCOTIMESTAMPTZ:log_date}: %%{DATA:facility}-%{INT:severity_level}-%{DATA:facility_mnemonic}: %{GREEDYDATA:message}",
        "message", "%{CISCOTIMESTAMPTZ2:log_date}: %%{DATA:facility}-%{INT:severity_level}-%{DATA:facility_mnemonic}: %{GREEDYDATA:message}"
      ]
      overwrite => [ "message" ]
      add_tag => [ "cisco" ]

    }
  }

}

output {
    elasticsearch {
      hosts           => ["localhost:9200"]
      index           => "switchlog-%{+YYYY.MM.dd}"
      sniffing        => true
    }
}
```

- Thêm đoạn 2 patterns sau vào file `grok-patterns`. Trong CentOS nằm ở `/usr/share/logstash/vendor/bundle/jruby/2.3.0/gems/logstash-patterns-core-4.1.2/patterns`

```
CISCOTIMESTAMPTZ %{MONTH}  %{MONTHDAY} %{TIME}
CISCOTIMESTAMPTZ2 %{MONTH} %{MONTHDAY} %{TIME}
```

Lưu ý: Tùy từng log của các dòng sw khác nhau mà ta có những filter khác nhau. Trên đây chỉ là ví dụ.

## Hướng dẫn cấu hình trên SW

Trên phía sw, ta cần cấu hình để đẩy qua syslog. Một số sw mặc định đã bật logging. Nếu chưa có, ta cần enable nó lên. Ở đây ta lấy log severity từ level 6.

```
logging enable
logging trap notifications
logging host 192.168.30.25 transport udp port 8514
```

Ở đây ta đẩy log qua port 8514 sử dụng giao thức udp với `192.168.30.25` là địa chỉ của ELK.

Lưu ý: một số dòng sw chỉ hỗ trợ đẩy log qua port 514 udp mặc định của syslog.

Như vậy trên phía logstash ta cần thay port listen từ 8514 sang 514, tuy nhiên bạn phải cấu hình để logstash có quyền listen trên port này. Hoặc bạn cũng có thể dùng iptables để nat từ 514 sang 8514 bằng câu lệnh sau:

```
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 514 -j REDIRECT --to-port 8514
iptables -A PREROUTING -t nat -i eth0 -p udp --dport 514 -j REDIRECT --to-port 8514
```


## Hướng dẫn cấu hình SW lưu lại log login

Để SW lưu lại log login, sử dụng câu lệnh sau:

```
login on-success log
login on-failure log
login block-for 120 attempts 3 within 60
```

Lưu ý: SW phải được cấu hình để lưu lại log và đẩy log từ trước đó, đồng thời đã được cấu hình username/password.
