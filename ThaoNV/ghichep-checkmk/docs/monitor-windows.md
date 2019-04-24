# Một số vấn đề khi monitor các máy chủ windows

## Log

Check_mk hỗ trợ mặc định theo dõi log trên windows. Nó sẽ tự detect các log error và cảnh báo. Tuy nhiên, nếu có nhiều ứng dụng, bạn nên chia ra theo các trường như event id hoặc string của từng log mà bạn cho là nó critical.

Việc này sẽ mất thời gian, nhưng nó sẽ hiệu quả đối với các hệ thống chạy nhiều ứng dụng.

<img src="https://i.imgur.com/C1HYwUL.png">

Lưu ý các rule sẽ được apply từ trên xuống.

<img src="https://i.imgur.com/C4c0Thq.png">

Có thể dùng câu lệnh sau để tạo log thử

`eventcreate /L APPLICATION /t ERROR /id 500 /so testevenviewer /d
"testeventviewer CHECKMK"`

Sau khi detect được log error, check_mk sẽ cảnh báo. Khi xử lí xong, bạn cần open log trên check_mk và clear log thì status của service mới có thể trở lại bình thường.

<img src="https://i.imgur.com/X4gFPkn.png">

## Service

Windows có rất nhiều service cần được giám sát, để xác định xem check_mk đang thấy những service nào đang chạy, sử dụng câu lệnh sau:

`OMD[mysite]:~$ cmk -d w2012tst1 | fgrep -A 500 '<<<services>>>' | grep -i running`

Ta lấy tên service muốn giam sát rồi vào manual check -> windows services
Tạo 1 rule mới

<img src="https://i.imgur.com/wUDb3Er.png">

Sau đó discovery lại host.

## MSSQL

Đối với các máy chủ mssql ko dùng pass (trusted authentication) thì ko cần cấu hình gì thêm, đối với những máy chủ có user và pass riêng thì cần gán quyền cho user mà checkmk agent đang chạy (thường là Administrator) hoặc tạo 1 file `mssql.ini` trong thư mục config trên máy client. Nội dung file

```
[auth]
type = db
username = monitoring
password = secret-pw
```

Ở đây tôi ko cần cấu hình gì, chỉ cần thực hiện các bước sau:

- Copy file `mssql.vbs` từ checkmk server tới thư mục `C:\Program Files
(x86)\check_mk\plugins`

- Restart lại agent

- discovery và active changes

Kết quả:

<img src="https://i.imgur.com/cneIejN.png">
