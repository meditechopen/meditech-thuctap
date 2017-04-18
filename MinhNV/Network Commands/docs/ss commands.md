# Tìm hiểu lệnh SS
## Mục Lục 
- [1. Giới thiệu](#gioithieu)
- [2. Các option trong ss](#option)
- [3. Một số ví dụ](#vidu) 
- [4. Tài liệu tham khảo](#tailieu)

## 1. SS là gì?
<a name="gioithieu"></a>

- `ss` là cụm từ viết tắt của `socket statistics` là câu lệnh có khả năng hiển thị nhiều thông tin hơn so với câu lẹnh `netstat` và nó nhanh hơn so với `netstat`. Bởi câu lệnh `netstat` chỉ đọc các file tiến trình để tổng hợp các thông tin, nó sẽ mắc phải những điểm yếu khi mà cố hiển thị thông tin về các kết nối thất bại. Chính điều này làm cho `netstat` trở lên chậm

- Câu lệnh `ss` nhận các thông tin về socket statistics một cách trực tiếp từ nhân hệ điều hành. Các tùy chọn đi kèm với ss command thì đơn giản hơn so với netstat khiến ss command có thể thay thế cho netstat một cách dễ dàng

- Câu lệnh ``ss`` là một câu lệnh khá mới và vô cùng hữu ích, hiệu quả ( so sánh với netstat command ) cho việc theo dõi các kết nối TCP và sockets. ss command cung cấp các thông tin về:
	+ Tất cả TCP sockets
	+ Tất cả UDP sockets
	+ Tất cả các kết nối ssh/ ftp/ http/ https đã thiết lập
	+ Tất cả các tiến trình local kết nối tới một server X
	+ Cho phép lọc các trạng thái kết nối như connected, synchronized, .. theo các địa chỉ, ports

<a name="options"></a>
## 2. Các option trong ss
- Cấu trúc câu lệnh ss :

`` ss [option] [filter]``

- Các option bao gồm :

	+ -n, --numeric: Không cần thiết phải phân giải tên dịch vụ

	+ -r, --resolve: Phân giải tên dịch vụ thành địa chỉ/ ports

	+ -a, --all: Hiển thị cả trạng thái listening và non-listening sockets

	+ -l, --listening: Chỉ hiển thị các sockets có trạng thái listening (default)

	+ -e, --extended: Hiển thị chi tiết về socket

	+ -m, --memory: Hiển thị bộ nhớ mà sockets sử dụng

	+ -p, --processes: Hiển thị tiến trình đang sử dụng socket

	+ -i, --info: Hiển thị thông tin TCP nội bộ

	+ -s, --summary: In số liệu thống kê một cách tổng quan.

	+ -4, --ipv4: Chỉ hiện thị các socket IPv4

	+ -6, --ipv6: Chỉ hiển thị các socket IPv6

	+ -0, --packet: Hiển hị các packet sockets

	+ -o, --options: Hiển thị thời gian tồn tại, kết nối.

	+ t, --tcp: Hiển thị TCP sockets.

	+ u, --udp: Hiển thị UDP sockets.

	+ d, --dccp: Hiển thị DCCP sockets.

	+ w, --raw: Hiển thị RAW sockets.

	+ x, --unix: Hiển thị Unix domain sockets

	+ -F, --filter=FILE read filter information from FILE

	+ FILTER := [ state TCP-STATE ] [ EXPRESSION ]

<a name="vidu"></a>
3. Các ví dụ

- Liệt kê tất cả các cổng 

``ss | less``

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Network%20Commands/images/ss.PNG?raw=true">

- Lọc kết nối TCP, UDP hoặc Unix

	+  lọc kết nối tcp: 
	
	``ss -t``
	
	<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Network%20Commands/images/ss1.PNG?raw=true">
	
	để liệt kê ra tất cả các cổng đang kết nối và không kết nối: ss -t -a
	
	``ss -t -a``
	
	<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Network%20Commands/images/ss2.PNG?raw=true">

	+ lọc kết nối UDP
	
	``ss -au``
	
	<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Network%20Commands/images/ss3.PNG?raw=true">
	
	+ lọc kết nối unix

	``ss - ax``
	
	<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Network%20Commands/images/ss4.PNG?raw=true">
	
 
- Lọc kết nối theo địa chỉ và số cổng: Ngoài các trạng thái socket tcp, lệnh ss cũng hỗ trợ lọc theo địa chỉ và số cổng
	
	
	ss -nu dst :443 or dst :80
	ss -nt dst 192.168.20.10
	ss -nt dport :=80

- Liệt kê tất cả các cổng đang kết nối ( hiển thị số cổng không hiển thị tên )
	
	``ss -nt``
	
	<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Network%20Commands/images/ss%20--nt.PNG?raw=true">

- Liệt kê tất cả các cổng đang listen
	
	``ss -ntl``
	
	<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Network%20Commands/images/ss%20-ntl.PNG?raw=true"?>

- In ra thống kế tổng các ports


	``ss -s``
	
	<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Network%20Commands/images/ss%20-s.PNG?raw=true">
	
- Hiển thị tên tiến trình cà pid 
	
	`` ss -p``

	<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Network%20Commands/images/ss-p.PNG?raw=true">

<a name="tailieu"></a>
4. Tài liệu tham khảo 

- http://www.binarytides.com/linux-ss-command/
	





	
