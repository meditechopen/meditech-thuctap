# Tìm Hiểu MTR
===========================================
# Mục lục
## [I. MTR](#mtr)
### [1.1 Định nghĩa MTR](#11)
### [1.2 Các tùy chọn trong MTR](#12)
### [1.3 Ví dụ ](#13)
### [1.4 Tài liệu tham khảo](#14)
<a name=mtr></a>
## I. MTR

<a name=11></a>
### 1.1 Định nghĩa MTR
 `MTR` là sự kết hợp giữa Traceroute và Ping thành một công cụ chuẩn đoán mạng.

 Khi MTR bắt đầu, nó kiểm tra kết nối giữa MTR host và HOSTNAME bằng cách gửi các gói tin với các low TTLs.Nó sẽ tiếp tục gửi các gói tin low TTLs và ghi chép lại thời gian phản hồi,phần trăm gói tin bị mất và thời gian đáp ứng của từng router trên đường đi.

 Đơn vị báo cáo thường ở dạng mili giây hoặc phần trăm.

<a name=12></a>
### 1.2 Các tùy chọn trong MTR
  - `-h, --help` : In ra cấu trúc tổng quan của các lệnh.
  - `-v , --version` : Hiển thị thông tin phiên bản MTR.
  - `-4 ` : Chỉ sử dụng các gói tin IPv4.
  - `-6` : Chỉ sử dụng các gói tin IPv6 (IPv4 được dùng làm DNS lookups).
  - `-F FILENAME, --filename FILENAME`
  - `-r , --report` : MTR sẽ chuyển thành chế độ báo cáo,MTR sẽ chạy với số chu kì được chỉ định bởi `-c` và in ra các số liệu thống kê và thoát.
  - `-w, --report-wide` : MTR sẽ chuyển vào chế độ mở rộng. Trong chế độ này MTR sẽ không cắt các hostnames trong báo cáo.
  - `-x, --xml` : xuất báo cáo dưới dạng file xml.
  - `-t, --curses` : xuất báo cáo dưới dạng Terminal.
  - `-g, --gtk` : sử dụng gtk+ dựa trên cửa sổ X11.
  - ` -l, --raw` : Xuất file báo cáo dưới dạng raw.
  - ` -C, --csv`
  - `-p, --split` : thiết lập MTR đưa ra các giao diện từng phần.
  - `-n, --no-dns` : hiển thị các hostnames dưới dạng địa chỉ IP.
  - ` -b, --show-ips` : Hiển thị cả Hosnames và địa chỉ IP.
  - `-o FIELDS, --order FIELDS` : sử dụng các tùy chọn hiển thị đặc biệt. Các fields khả dụng :
  <ul>
  <li>L : tỉ lệ bị mất</li>
  <li>D : Các gói tin bị mất</li>
  <li>R : Các gói tin nhận</li>
  <li>S : Các gói tin gửi</li>
  <li>N : RTT mới nhất (ms)</li>
  <li>B : RTT nhỏ nhất(ms)</li>
  <li>A : trung bình cộng RTT(ms)</li>
  <li>W : RTT lỗi nhất(ms)</li>
  <li>V : Độ lệch tiêu chuẩn</li>
  <li>G : phương pháp trung bình</li>
  <li>J : Jitter hiện tại</li>
  <li>M : Trung bình các Jitter</li>
  <li>X : Jitter bị mất</li>
  </ul>
  
  - `-y n, --ipinfo n`.
  
  - `-z, --aslookup`.
  
  - ` -i SECONDS, --interval SECONDS` : thông báo thời gian (s) lớn hơn hoặc bằng 0  giữa các yêu cầu ICMP.Có 2 tùy chọn 0 và 1.
  - `-c COUNT, --report-cycles COUNT` :  Đếm các gói tin gửi thành công trong vòng 1 giây.
  - `-s PACKETSIZE, --psize PACKETSIZE` : Đưa ra kích cỡ của Header gói tin.
  - ` -B NUM, --bitpattern NUM`: Chỉ định mẫu bit được sử dụng trong payload . Tùy chọn từ 0- 255. Nếu để 255 thì nó sẽ tự động chọn 1 tham số bất kì.
  - `-Q NUM, --tos NUM` : Tùy chọn loại dịch vụ trong IP Header. Tham số từ 0-255.
  - `-e, --mpls` : tùy chọn các thông tin mở rộng trong ICMP cho MPLS trong việc giải mã các phản hồi.
  - `-a ADDRESS, --address ADDRESS` : sử dụng để buộc tất cả các gói tin đều có đích là địa chỉ nào đó.
  - ` -f NUM, --first-ttl NUM` : chỉ định nơi TTLs bắt đầu,mặc định là 1.
  - `-u, --udp` : sử dụng các gói tin UDP thay cho ICMP ECHO.
  - `-T, --tcp` : Sử dụng gói tin TCP SYN thay cho ICMP ECHO.
  - `-P PORT, --port PORT` : Port của đối tượng đích.
  - ` -Z SECONDS, --timeout SECONDS` : Số giây chờ đảm bảo kết nối TCP.
  - ` -M MARK, --mark MARK`

<a name=13></a>
### 1.3 Ví dụ

  Ví dụ khi Sử dụng lệnh : `mtr facbook.com` ta sẽ có thông tin sau :

  <img src=http://i.imgur.com/aGflzGM.png>

  Trong đó :
  - Loss% : Phần trăm các gói tin bị mất.
  - Last : độ trễ của gói tin cuối cùng.
  - Avg : Độ trễ  trung bình của tất cả gói tin .
  - Best : Độ trễ nhỏ nhất.
  - Wrst : Độ trễ lớn nhất
  - StDev : Tiêu chuẩn độ trễ  từng router.
  
  <a name=14></a>
  ### 1.4 Tài liệu tham khảo 
  
  http://manpages.ubuntu.com/manpages/xenial/man8/mtr.8.html 
