# Thông số về hệ thống 

- [RAM](#ram)
- [CPU](#cpu)
- [DISK](#disk)
- [NETWORK TRAFFIC](#network)
- [PROCESSES](#processes)
- [SECUIRITY](#security)

<a name="ram"></a>
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
- Swap Space: được sử dụng khi dung lượng bộ nhớ vật lý (RAM) đầy. Nếu hệ thống cần nhiều tài nguyên bộ nhớ hơn và bộ nhớ RAM đầy

### Cách xóa cache: Sử dụng câu lệnh

- Chỉ xóa cached

``sync; echo 1 > /proc/sys/vm/drop_caches``

- Xóa dentries và inodes.

``sync; echo 2 > /proc/sys/vm/drop_caches``

- Xóa PageCache, dentries và inodes.

``sync; echo 3 > /proc/sys/vm/drop_caches`` 

<a name="cpu"></a>
## CPU 

Sử dụng lệnh ``top`` hoặc sysstat

``top``

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/top.PNG?raw=true">

 bên cạnh đó còn cần chú ý thêm các thông số quan trọng khác ở đây, đó là:
 - %user(user cpu time) : đây là lượng chiếm dụng CPU khi một user khởi tạo tiến trình
 - %nice: đây là lượng chiếm dụng CPU khi tiến trình được tạo bởi user với độ ưu tiên là nice
 - %system (system cpu time): đây là lượng chiếm dụng CPU khi tiến trình được tạo ra bởi kernel (hệ thống)
 - %iowait(io wait cpu time): đây là lượng chiếm dụng CPU khi cpu đang trong trạng thái idle ở thời điểm phát sinh I/O request
 - %idle: : đây là lượng chiếm dụng CPU khi cpu đang trong trạng thái idle ở thời điểm không có I/O request
 - %steal(steal time): phần trăm do máy ảo sử dụng
 - %hi(hardware irq): phần trăm để xử lý gián đoạn phần cứng
 - %si(software irq): phần trăm để xử lý gián đoạn phần mềm
 
 <img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/top%202.PNG?raw=true">
 
- PID (process ID): ID của tiến trình.
- USER: Chủ nhân (owner) của tiến trình.
- PR (priority): Mức độ ưu tiên của tiến trình, từ -20 (rất quan trọng) đến 19 (không quan trọng).
- NI (nice value): Giá trị sửa đổi mức độ ưu tiên của tiến trình, giá trị này được gọi là nice bởi vì nó được coi là tốt hơn giá trị cũ ở cột PR.
- VIRT (virtual memory): Bộ nhớ ảo đã sử dụng, bộ nhớ ảo này là sự kết hợp giữa RAM và swap.
- RES (resident memory): Bộ nhớ vật lý (RAM) do tiến trình sử dụng, tính theo KB.
- SHR (shared memory): Bộ nhớ chia sẻ do tiến trình sử dụng, bộ nhớ chia sẻ là bộ nhớ dùng chung với các tiến trình khác.
- S: Trạng thái của tiến trình:

	+ R (running): đang chạy
	+ D (sleeping): đang tạm nghỉ, có thể không bị gián đoạn (interrupted)
	+ S (sleeping): đang tạm nghỉ, có thể bị gián đoạn (interrupted)
	+ T: đã dừng hẳn
	+ Z (zombie): chưa dừng hẳn (hoặc bị treo)
	
Các trạng thái này có liên quan đến thống kê số lượng các tác vụ ở phần trên.

%CPU: Phần trăm CPU do tiến trình sử dụng (trong lần cập nhật cuối – không phải thời gian thực).
%MEM: Phần trăm RAM do tiến trình sử dụng (trong lần cập nhật cuối – không phải thời gian thực).
TIME+: Thời gian cộng dồn mà tiến trình (gồm cả tiến trình con) đã chạy.
COMMAND: Tên của tiến trình hoặc đường dẫn đến lệnh dùng để khởi động tiến trình đó.
 Sử dụng câu lệnh uptime để hiển thị mức tải trung bình 
 
 ``uptime``
 
 #### load average
 load average được thể hiện trong ba khoảng thời gian khác nhau: trong 1, 5 và 15 phút. Giá trị lớn nhất của load average phụ thuộc vào số lõi (core) của CPU, nếu CPU có:

	 + 1 lõi: thì load average có giá trị lớn nhất là 1.00
	 + 2 lõi: là 2.00
	 + 8 lõi: là 8.00
	 
Hoặc cài đặt chương trình sysstat

``yum install sysstat``

Kiểm tra tài nguyên CPU được sử dụng ở đâu

``sar -u 3 10``

lệnh sar -u 3 10, bạn có thể hiểu là: với lệnh này server sẽ tiến hành kiểm tra 10 lần, mỗi lần cách nhau 3s

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/sar%20-u.PNG?raw=true">

	

#### Context switch	 

- Voluntary context switch: Tiến trình tự nguyện nhường lại CPU sau khi chạy hết thời gian dự kiến của nó hoặc nó yêu cầu sử dụng tài nguyên hiện không khả dụng.
- Involuntary context switch: Tiến trình bị gián đoạn và nhường lại CPU trước khi hoàn tất thời gian chạy theo lịch trình của nó do hệ thống xác định một tiến trình ưu tiên cao hơn cần thực thi. 

lệnh hiển thị context switch

``pidstat -w 10 1``

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/pidstat.PNG?raw=true">

- cswch/s

Total number of voluntary context switches the task made per second. A voluntary context switch occurs when a task blocks because it requires a resource that is unavailable.

- nvcswch/s

Total number of non voluntary context switches the task made per second. A involuntary context switch takes place when a task executes for the duration of its time slice and then is forced to relinquish the processor.

 <a name="disk"></a>
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
 
 <a name="network"></a>
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

- Ở trung tâm, một danh sách của tất cả các kết nối mạng trên giao diện giám sát được hiển thị. Các mũi tên ở cuối mỗi dòng chỉ ra hướng đi của lưu lượng ra và vào.

- Ba cột cuối cùng cho thấy việc sử dụng băng thông trung bình cho mỗi kết nối trong 2, 10, và 40 giây cuối cùng.
- Phần ở dưới cùng của màn hình hiển thị số liệu thống kê lưu lượng tổng thể bao gồm cả lưu lượng được truyền Tx, lưu lượng được nhận Rx và giá trị TOTAL thể hiện tổng lưu lượng của cả Tx và Rx.

**Đơn vị thường gặp**:

`KiB` (kibibytes = 1024 bytes), có thể sử dụng `b` (bytes), `KB` (Kilobytes = 1000 bytes), `MB` (Megabytes = 1000000 bytes), `M` hoặc `MiB` (Mebibytes = 1,048,576 bytes), `GB` (gigabytes = 1,000,000,000 bytes), `G` hoặc `GiB` (gibibytes = 1,073,741,824 bytes), `TB` (terabytes = 1,000,000,000,000 bytes), `T` hoặc `TiB` (tebibytes = 1,099,511,627,776 bytes)

<a href="https://tailieu.123host.vn/kb/vps/kiem-tra-luu-luong-mang-tren-vps-linux-voi-iftop.html">Cách sử dụng iftop</a>

- Sử dụng lệnh ``sysstat``

`` sar -n ALL 1 1 ``

```sh
[root@localhost ~]# sar -n ALL 1 1
Linux 3.10.0-514.el7.x86_64 (localhost.localdomain)     04/21/2017      _x86_64_        (1 CPU)

03:45:15 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
03:45:16 PM      ens3      3.00      1.00      0.13      0.09      0.00      0.00      0.00
03:45:16 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00

```

	+ IFACE: tên của giao diện mạng mà thống kê được báo cáo.
	+ Rxpck/s: tổng số gói tin nhận được mỗi giây.
	+ Txpck/s: tổng số gói được truyền mỗi giây.
	+ RxkB/s: tổng số kilobyte nhận được mỗi giây.
	+ TxkB/s: tổng số kilobyt truyền qua mỗi giây.
	+ Rxcmp/s: số lượng gói tin nén nhận được mỗi giây.
	+ Txcmp/s: số lượng gói tin nén được truyền đi mỗi giây.
	+ Rxmcst/s: số lượng các gói tin Multicast nhận được mỗi giây.

<a name="processes"></a>
## Processes

Dùng lệnh top để hiển thị lên màn hình 

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/top.PNG?raw=true">

Như chúng ta thế dòng tasks nằm ở vị trí thứ 2 hiển thị có 110 tiến trình, 1 tiến trình đang chạy, 109 tiến trình đang ngủ đông.

<a name="security"></a>
## Sercurity

- Tài khoản đang đăng nhập vào hệ thống 
	+ Sử dụng câu lệnh ``who`` để kiểm tra
	+ Sử dụng tùy chọn ``who | wc -l`` để kiểm tra số người đang đăng nhập
- Checksum of /etc/passwd: Checksum được sử dụng để đảm bảo tính toàn vẹn của một tập tin sau khi nó đã được truyền từ một thiết bị lưu trữ khác.

VD: Cách checksum 1 file với mã MD5

``md5sum [địa chỉ file]``

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/checksum.PNG?raw=true">

# Tài liệu tham khảo
- http://acegik.net/blog/java/performance/theo-doi-hieu-nang-cua-he-dieu-hanh.html
- https://saungon.com/thong-so-trong-lenh-top/
- http://sebastien.godard.pagesperso-orange.fr/man_pidstat.html
- http://www.tecmint.com/clear-ram-memory-cache-buffer-and-swap-space-on-linux/
- https://www.server-world.info/en/note?os=Ubuntu_14.04&p=sysstat&f=2
