
<img src="http://i.imgur.com/Ae5gQJZ.png" height="45" width="200" />

# Hướng dẫn cài đặt seyren để gửi mail cảnh báo cho graphite trên Ubuntu 14.04

- Điều kiện tiên quyết
	+ Đã cài đặt graphite và collectd. Tham khảo <a href="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/ghichep_graphite/installgraphite_centos7.md">tại đây</a>
	+ Cài đặt <a href="http://docs.mongodb.org/manual/installation/#installation-guides">MongoDB</a>
- Tải project seyren về 
``wget https://github.com/scobal/seyren/releases/download/1.5.0/seyren-1.5.0.jar``
- Khai báo các thông tin 
	```sh
	export SEYREN_URL="http://<IP>/seyren" / điền ip của host cài đặt seyren
	export SEYREN_LOG_PATH="/var/log/seyren" / đường dẫn file log seyren
	export GRAPHITE_URL="http://ip:80" / điền địa chỉ ip của graphite server
	SMTP_HOST="smtp.gmail.com" 
	SMTP_PORT="587" 
	SMTP_FROM="địa chỉ email của bạn" 
	SMTP_USERNAME="địa chỉ email của bạn" 
	SMTP_PASSWORD="mật khẩu" 
	SMTP_PROTOCOL="SMTP" 
	```
- Lưu ý với khai báo SMTP_USERNAME và PASSWORD của gmail
	+ Thứ nhất bạn phải bật less-security của gmail
	+ Thứ hai bạn phải bật IPOP và IMAP
	+ Thứ 3 cài đặt mật khẩu ứng dụng của gmail và dùng nó làm password cho khai báo ở trên (nhớ bật xác thực 2 bước trong trường hợp taoh mật khẩu ứng dụng)
- Chạy seyren 

``java -jar seyren-1.5.0.jar``

- Vào trình duyệt và truy cập đến http://ip_seyren:8080
- Tích vào check ====> create check sẽ hiện 1 bảng điền thông tin
	+ Phần name bạn có thể đặt tên ví dụ:  CPU load trong 1 phút
	+ Phần Taget bạn điền metric muốn theo dõi theo graph graphite. Ví dụ bạn muốn đặt cảnh báo cho thông số `shortterm` của plugin `load` của host `localhost` thì đường dẫn khai báo trong target sẽ là như sau:
			``collectd.localhost.load.load.shortterm``
	  Ta để ý phần khai báo này theo thứ tự tích vào bảng bên trái của giao diện web graphite
	+ Đặt ngưỡng trong warn level và error level 	  
	+ Create check
- Add subscription
	+ Target chọn địa chỉ email muốn gửi cảnh báo tới
	+ Giữ nguyên Email 
	+ Chỉnh thời gian gửi mail
	+ Chọn test để kiểm tra xem đã thành công chưa
	+ Vào gmail kiểm tra tin nhắn
