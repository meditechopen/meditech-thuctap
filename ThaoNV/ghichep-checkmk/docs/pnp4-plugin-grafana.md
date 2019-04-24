# Hướng dẫn sử dụng pnp4 plugin để hiển thị dữ liệu lên grafana

### Bước 1: Cài đặt grafana

```
cat > /etc/yum.repos.d/grafana.repo <<'EOF'
[grafana]
name=grafana
baseurl=https://packagecloud.io/grafana/stable/el/7/$basearch
gpgkey=https://packagecloud.io/gpg.key https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana
enabled=0
gpgcheck=1
EOF
```

```
yum install epel-release -y
yum --enablerepo=grafana -y install grafana initscripts fontconfig
```

```
systemctl start grafana-server
systemctl enable grafana-server
```

### Bước 2

Cài đặt thêm plugin pnp

```
grafana-cli plugins install sni-pnp-datasource
systemctl restart grafana-server
```

### Bước 3: Trên phía check mk server

```
cd /opt/omd/versions/<version-you-use>/share/pnp4nagios/htdocs/application/controllers
wget "https://github.com/lingej/pnp-metrics-api/raw/master/application/controller/api.php"
```

Sửa file `config.php` nằm trong thư mục `/opt/omd/sites/<sitename>/etc/pnp4nagios`

```
$conf['auth_enabled'] = FALSE;
$conf['auth_multisite_enabled']  = FALSE;
```

Truy cập thư mục `/opt/omd/sites/<sitename>/etc/pnp4nagios/config.d`

Đổi tên 2 file `authorisation.php` và `cookie_auth.php` thành `cookie_auth.php_old` và `authorisation.php_old`

Restart lại site `omd restart <site-name>`

### Bước 4: Add datasource trên phía grafana

<img src="https://i.imgur.com/SkZmorY.png">

<img src="https://i.imgur.com/c5NDQXt.png">

**Tham khảo:**

https://grafana.com/plugins/sni-pnp-datasource

https://lists.mathias-kettner.de/pipermail/checkmk-en/2019-January/026912.html
