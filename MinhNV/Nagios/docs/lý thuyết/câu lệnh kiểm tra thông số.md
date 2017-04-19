# Thông số về hệ thống 
## RAM

Lệnh kiểm tra thông số RAM

``free -m``

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/free%20-m.PNG?raw=true">

- used: dung lượng ram đã dùng
- free: dung lượng ram còn trống 
- cached và buffers: Cả Cached và Buffers đều có ý nghĩa là vùng lưu trữ tạm, nhưng mục đích sử dụng thì khác nhau, tổng quan thì có một số điểm sau:

	+ Mục đích của cached là tạo ra một vùng nhớ tốc độ cao nhằm tăng tốc quá trình đọc/ghi file ra đĩa, trong khi buffers là tạo ra 1 vùng nhớ tạm có tốc độ bình thường, mục đích để gom data hoặc giữ data để dùng cho mục đích nào đó.
	+ Cached được tạo từ static RAM (SRAM) nên nhanh hơn dynamic RAM (DRAM) dùng để tạo ra buffers.
	+ Buffers thường dùng cho các tiến trình input/output, trong khi cached chủ yếu được dùng cho các tiến trình đọc/ghi file ra đĩa
	+ Cached có thể là một phần của đĩa (đĩa có tốc độ cao) hoặc RAM trong khi buffers chỉ là một phần của RAM (không thể dùng đĩa để tạo ra buffers)
- shared: Đây là bộ nhớ chia sẻ giữa các tiến trình, bộ nhớ đang được sử dụng như các bộ đệm (lưu trữ tạm thời) bởi hạt nhân 

## CPU 
Cài đặt chương trình sysstat

``yum install sysstat``

Kiểm tra tài nguyên CPU được sử dụng ở đâu

``sar -u 3 10``

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/sar%20-u.PNG?raw=true">

Trước hết với lệnh sar -u 3 10, bạn có thể hiểu là: với lệnh này server sẽ tiến hành kiểm tra 10 lần, mỗi lần cách nhau 3s, bên cạnh đó còn cần chú ý thêm các thông số quan trọng khác ở đây, đó là:
 - %user : đây là lượng chiếm dụng CPU khi một user khởi tạo tiến trình
 - %nice: đây là lượng chiếm dụng CPU khi tiến trình được tạo bởi user với độ ưu tiên là nice
 - %system: đây là lượng chiếm dụng CPU khi tiến trình được tạo ra bởi kernel (hệ thống)
 - %iowait: đây là lượng chiếm dụng CPU khi cpu đang trong trạng thái idle ở thời điểm phát sinh I/O request
 - %idle: : đây là lượng chiếm dụng CPU khi cpu đang trong trạng thái idle ở thời điểm không có I/O request
 
 ## Disk 
 
 Xem thông tin file hệ thống ở GB
 
 ``df -h``
 
 <img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/df%20-h.PNG?raw=true">
 
 - Size: Tổng kích thước dung lượng
 - Used: Dung lượng đã sử dụng
 - Avail: Dung lượng trống còn lại
 - %use: Phần trăm dung lượng đã sử dụng
 - Mounted on: Đường dẫn khởi tạo

 
 <a href="https://tailieu.123host.vn/kb/vps/kiem-tra-luu-luong-mang-tren-vps-linux-voi-iftop.html">Xem thêm cách sử dụng lệnh df</a>
 
 ## Network traffic
 
 Tải iftop về centos 
 
 ```sh 
 yum install epel-release
 yum install iftop
 ```
 
 Gõ lệnh iftop trên terminal với quyền root để hiển thị mức sử dụng băng thông của interface đầu tiên.
 
 ``iftop``
 
 <img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/iftop.PNG?raw=true">
 
 Trên đỉnh của màn hình được sử dụng để chỉ việc sử dụng băng thông của mỗi kết nối mạng được liệt kê dưới đây.
Thông tin trên đỉnh màn hình cho băng thông mỗi kết nối mạng đang sử dụng.
Ở trung tâm, một danh sách của tất cả các kết nối mạng trên giao diện giám sát được hiển thị. Các mũi tên ở cuối mỗi dòng chỉ ra hướng đi của lưu lượng ra và vào.

Ba cột cuối cùng cho thấy việc sử dụng băng thông trung bình cho mỗi kết nối trong 2, 10, và 40 giây cuối cùng.
Phần ở dưới cùng của màn hình hiển thị số liệu thống kê lưu lượng tổng thể bao gồm cả lưu lượng được truyền Tx, lưu lượng được nhận Rx và giá trị TOTAL thể hiện tổng lưu lượng của cả Tx và Rx.

<a href="https://tailieu.123host.vn/kb/vps/kiem-tra-luu-luong-mang-tren-vps-linux-voi-iftop.html">Cách sử dụng iftop</a>

