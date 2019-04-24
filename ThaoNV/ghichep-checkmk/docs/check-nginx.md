#

Đối với nginx có sử dụng ssl, thực hiện tạo file cấu hình `/etc/check_mk/nginx_status.cfg`

```
servers = [
     {
        "address"  : "localhost",
        "protocol" : "https",
        "port"     : "443",
     },
]
```

Sau đó sử dụng script [tại đây](./scripts/check-nginx.md)
