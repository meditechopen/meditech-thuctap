# Hướng dẫn sử dụng grafana để hiển thị các metrics của Ceilometer

## Mục lục

1. Hướng dẫn cài đặt grafna trên CentOS 7

2. Hướng dẫn cấu hình kết hợp gnocchi và grafna

---------------

## 1. Hướng dẫn cài đặt grafna trên CentOS 7

- Thêm file repo `/etc/yum.repos.d/grafana.repo`

```
[grafana]
name=grafana
baseurl=https://packagecloud.io/grafana/stable/el/7/$basearch
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packagecloud.io/gpg.key https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
```

- Cài đặt grafana

`yum -y install grafana`

- Khởi động grafna và cho phép khởi động cùng hệ thống

```
systemctl daemon-reload
systemctl start grafana-server
systemctl enable grafana-server
```

- Lưu ý: Grafana chạy trên port 3000, đối với CentOS, bạn cần tạo rule cho phép port này được truy cập từ bên ngoài hoặc tắt firewalld.

Truy cập giao diện của grafana theo đường dẫn `http://ip-server:3000` với tài khoản và password mặc định `admin/admin`

<img src="https://i.imgur.com/Rb1DlCN.png">

- Tham khảo các cách cài đặt grafana trên các OS khác nhau [tại đây](http://docs.grafana.org/installation/)


## 2. Hướng dẫn cấu hình kết hợp gnocchi và grafna

Yêu cầu:

- Đã cài đặt và cấu hình ceilometer + gnocchi trên hệ thống OpenStack
- Đã cài đặt grafana

Lưu ý:

- Phiên bản OPS sử dụng cho bài lab này là pike
- Phiên bản grafana sử dụng là 5.0.4

**Thêm plugin cho grafana**

`grafana-cli plugins install gnocchixyz-gnocchi-datasource`

**Cấu hình CORS middleware trên phía OPS**

- Sửa file `/etc/gnocchi/gnocchi.conf`

```
[cors]
allowed_origin = http://192.168.30.35:3000
```

- Sửa file `/etc/keystone/keystone.conf`

```
[cors]
allowed_origin = http://192.168.30.35:3000
allow_methods = GET,PUT,POST,DELETE,PATCH
allow_headers = X-Auth-Token,X-Openstack-Request-Id,X-Subject-Token,X-Project-Id,X-Project-Name,X-Project-Domain-Id,X-Project-Domain-Name,X-Domain-Id,X-Domain-Name
```

- Restart httpd và gnocchi service

```
systemctl restart httpd
systemctl restart openstack-gnocchi-*
```

- Vào giao diện của grafana và thêm datasource

<img src="https://i.imgur.com/OOEMj62.png">

<img src="https://i.imgur.com/ldF7TnX.png">

- chọn `save & test`

<img src="https://i.imgur.com/vTxAMYV.png">

- Thêm dashboard mới và add các cấu lệnh query để hiển thị metrics

<img src="https://i.imgur.com/CdRqhds.png">
