# HAProxy Stats

## Mục lục

1. Cấu hình Stats cho HAProxy

2. Các thông số trên web browser

-----------------

## 1. Cấu hình Stats cho HAProxy

- Để cho phép HAProxy hiển thị số liệu thống kê, thêm một số dòng sau vào trong file config ở setcion default

``` sh
stats enable
stats uri /monitor
stats auth root:meditech2017
```

- Trong đó `stats uri` là đường dẫn tới trang hiển thị số liệu thống kê và `stats auth` là thông tin tài khoản và mật khẩu để tuy cập.

- Để theo dõi HAProxy Stats, tiến hành truy cập vào địa chỉ http://ipaddress/monitor với username là `root` và mk là `meditech2017`

<img src="">

## 2. Các thông số trên web browser

Như ta thấy trong hình thì phần phía trên là thông tin chung về process của HAProxy.

Một số thông tin đáng chú ý ở đây đó là `pid` (process id), `uptime` thời gian uptime kể từ lần restart cuối cùng, `current conns` số connection đang kết nối tới server.

Bên cạnh đó là các phần giải thích cho trạng thái của các frontend và backend mà HAProxy đnag quản lí.

Phía dưới là phần 
