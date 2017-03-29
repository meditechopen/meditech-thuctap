# Tìm hiểu commands mtr 

## 1. Giới thiệu:
- Lệnh mtr là sự kết hợp ping và tracepath trong một câu lệnh đơn lẻ. mtr sẽ gửi liên tục các gói và hiển thị thời gian ping cho mỗi nút mạng.
 - Lệnh tracepath cũng tương tự như traceroute nhưng nó không đòi hỏi các quyền quản trị. Nó cũng được cài đặt mặc định trên Ubuntu còn tracerout thì không. Lệnh tracepath lần dấu đường đi trên mạng tới một đích chỉ định và báo cáo về mỗi nút mạng (hop) dọc trên đường đi. Nếu gặp phải các vấn đề về mạng, lệnh tracepath có thể chỉ ra vị trí lỗi mạng.

- MTR hoạt động bằng cách gửi các gói tin ICMP bằng cách gia tăng giá trị TTL để tìm tuyến giữa nguồn và đích đến.

## 2. mtr commands cùng các tùy chọn

### ```mtr google.com``` kết quả trả ra màn hình
<img src="http://i.imgur.com/FL0ig8C.png"> 

Trong đó: 
<ul>
  <li>Lost% : Hiển thị% số gói bị mất tại mỗi bước nhảy.</li>
  <li>Snt : Cho biết số không: của: các gói được gửi đi.</li>
  <li>Last Lần cuối : độ trễ của gói tin cuối cùng được gửi</li>
  <li>AVG : Độ trễ trung bình của tất cả các gói.</li>
  <li>Best : Hiển thị thời gian quay vòng tốt nhất cho gói tin đến máy chủ lưu trữ này (RTT ngắn nhất).</li>
  <li>Wrst : Hiển thị thời gian quay vòng vòng tồi tệ nhất cho một gói tin đến máy chủ lưu trữ này (RTT dài nhất).</li>
  <li> StDev : Cung cấp độ lệch tiêu chuẩn của độ trễ cho mỗi máy chủ.</li>
</ul>

### ```-c```
 Ấn ctrl c để kết thúc. Nếu bạn muốn gửi n gói tin thì sử dụng tùy chọn ``-c``

```mtr -c 10 google.com```

### ```-f```
Cấu hình giá trị TTL( Time To Live - thời gian sống của gói tin) sử dụng tùy chọn ``-f``

```mtr -f 4 google.com```

### ```-m```
Cấu hình số lượng hop với tùy chọn ``-m``

```mtr -m 10 google.com```


### ```--report```
Trong chế độ báo cáo, mtr sẽ chạy cho số chu kỳ (mặc định 10), và sau đó in số liệu thống kê và thoát. Chế độ này sẽ hữu ích cho việc tạo statstics về chất lượng mạng.

## 3. Tài liệu tham khảo thêm

http://manpages.ubuntu.com/manpages/xenial/man8/mtr.8.html
<img src="http://i.imgur.com/dYZtL6e.png">

### ```--no-dns```
MTR tìm thấy tên máy của mỗi router / node bằng cách sử dụng Reverse DNS Lookup.

```mtr --no-dns --report google.com```

### ```-u```
Sử dụng datagram UDP thay vì ICMP ECHO : 

``mtr -u google.com``





