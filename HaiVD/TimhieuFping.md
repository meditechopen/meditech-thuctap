#      Tìm hiểu về Fping
=======================================
# Mục lục
## [I. Định nghĩa](#dn)
## [II. Các tùy chọn cú pháp](#tc)
## [III. Một số ví dụ](#vd)

<a name=dn></a>
## I. Định nghĩa
- Fping là một chương trình gần giống Ping, sử dụng các yêu cầu bằng các gói ICMP để xác định xem một máy chủ đích có đáp ứng yêu cầu hay không. Fping khác với Ping ở chỗ : bạn có thể ping đến nhiều mục tiêu hoặc có thể ping đến tất cả các mục tiêu trong một file chỉ định có sẵn.Thay vì gửi đến mục tiêu cho đến khi nó trả lời hoặc hết thời gian trả lời, Fping sẽ gửi gói ping và chuyển sang mục tiêu kế tiếp theo kiểu vòng tròn robin.Trong chế độ mặc định,nếu một mục tiêu trả lời, nó sẽ ghi chú và xóa khỏi các mục tiêu trong danh sách cần kiểm tra.Nếu một mục tiêu không trả lời trong một thời gian nhất định hoặc trong giới hạn thử lại của nó thì nó sẽ được chỉ định là mục tiêu đó không thể truy cập được. Fping cũng hỗ trợ gửi một số lượng ping cụ thể đến một mục tiêu,hoặc lặp lại vô thời hạn như Ping.Fping được sử dụng trong các kịch bản,vì vậy dữ liệu ra của nó thể được thiết kế  các cú pháp phân tích một cách dễ dàng.

<a name=tc></a>
## II. Các tùy chọn cú pháp
- -4, --ipv4 : Giới hạn phân giải tên miền và IPs là IPv4
- -6, --ipv6 : Giới hạn phân giải tên miền và IPs là IPv6
- -a , --alive : Chỉ hiện thị các hệ thống còn hoạt động.
- -A, --addr : Hiển thị địa chỉ IP thay cho Tên miền, có thể kết hợp -d để hiển thị cả địa chỉ, cả tên miền.
- -b, --size= BYTES : Dung lượng gói ping để gửi. Gói ping bé nhất thường là 12 bytes cung cấp các thông tin như (số sequence,nhãn thời gian).Gói tin nhận được có kích cỡ bé nhất là 40 bytes trong đó có 20 bytes IP Header, 8 bytes ICMP Header. Mặc định là 56 bytes giống như Ping. Dung lượng lớn nhất theo lý thuyết là 64kb . Tuy nhiên một số hệ thống giới có giới hạn bé hơn.
- B , --backoff=N : Trong chế độ mặc định, Fping gửi một số yêu cầu đến một mục tiêu trước khi bỏ cuộc, chờ lâu hơn cho mỗi hồi đáp kế tiếp.Tham số này chính là giá trị như là thời gian chờ (-t) được nhận trên mỗi yêu cầu kế tiếp. giá trị phải để ở dạng chấm động (x,y). Mặc định là 1,5.
- -c, --vcount=N : số lượng yêu cầu được gửi cho mỗi đối tượng.Trong chế độ này, một dòng được hiển thị cho mỗi gói tin phản hồi nhận được.Ngoài ra, số liệu thống kê về phản hồi cho mỗi đối tượng được hiển thị khi tất cả các yêu cầu đã được gửi(hoặc bị gián đoạn).
- −C, −−vcount=N : Cũng giống như -c, nhưng số liệu thống kê cho mỗi mục tiêu được hiển thị theo một định dạng được thiết kế cho việc thu thập số liệu thống kê thời gian đáp ứng tự động. Ví dụ như :

  ```
  $ fping −C 5 −q somehost
  somehost : 91.7 37.0 29.2 − 36.8
  ```
  Cho thấy thời gian phản hồi của từng yêu cầu trong 5 yêu cầu được gửi đi. Dấu "-" cho biết yêu cầu thứ 4 không được đáp ứng.
- −d, −−rdns : Sử dụng DNS để tra cứu địa chỉ IP của gói tin trả về. Điều này cho phép bạn đưa vào danh sách IP và trả về là Domain của các IP đó.
- −D, −−timestamp : Thêm nhãn thời gian trước các dòng đầu ra, được tạo bằng các chế độ lặp hoặc đếm( (−l, −c, or −C).
- −e, −−elapsed : Hiển thị thời gian trôi qua(1 vòng) của những gói tin.
- −f, −−file : Đọc các đối tượng trong một file.Tùy chọn này chỉ được dùng với quyền root.
- −g, −−generate addr/mask : Sinh ra một list các địa chỉ đích nằm trong dải mạng đưa ra, hoặc từ địa chỉ bắt đầu đến địa chỉ kết thúc của dải đã cho.
  Ví dụ :

  ```
  $ fping −g 192.168.1.0/24
  or

  $ fping −g 192.168.1.1 192.168.1.254
  ```
- −h, −−help : In ra trợ giúp cấu trúc.
- −H, −−ttl=N : Thiết lập trường IP ttl
- −i, −−interval= MSEC : Thời gian tối thiểu ( tính bằng mili giây) giữa việc gửi gói tin tới bất kì đối tượng nào (mặc định là 10, tối thiểu là 1).
- −I, −−iface= IFACE : thiết lập giao diện ( Yêu cầu SO_BINDTODEVICE hỗ trợ).
- −l, −−loop : Lặp lại không giới hạn các gói tin đến từng đích. Có thể ngắt băng Ctrl + C.
- −m, −−all : Gửi Ping đến mỗi đối tượng trong nhiều đối tượng. ( nên sử dụng tùy chọn -A ).
- −M, −−dontfrag : Đặt bit "Don’t Fragment" trong IP Header(Sử dụng với mục đích kiểm tra MTU).
- -n, --name : Nếu mục tiêu là địa chỉ IP thì nó sẽ tra cứu ngược lại DNS.
- −N, −−netdata : định dạng đầu ra của dữ liệu mạng (-l -Q là bắt buộc).
- −o, −−outage : Tính toán thời gian gián đoạn dựa trên số lượng ping bị mất và khoảng thời gian sử dụng.
- −O, −−tos=N : Thiết lập cờ dịch vụ(TOS). N có thể là định dạng thập phân hoặc thập lục phân.
- −p, −−period= MSEC : Thiết lập trong các chế độ lặp hoặc đếm (−l, −c, or −C) , tham số này đơn vị là mili giây để Fping đợi giữa các gói tin kế tiếp với một mục tiêu riêng lẻ. Mặc định là 1000, tối thiểu là 10.
- −q, −−quet : Không hiển thị kết quả thăm dò, nhưng chỉ là bản tóm tắt cuối cùng. Cũng không hiển thi thông báo lỗi ICMP.
- −Q, −−squiet= SECS : Giống như -q nhưng hiển thị kết quả tóm tắt mỗi n giây.
- −r, −−retry=N : Số lần thử giới hạn, mặc định là 3 .Đây là số lần cố gắng ping đến một mục tiêu sẽ được thực hiện, không báo gồm lần thử đầu tiên.
- −R, −−random : Thay vì sử dụng tất cả các số 0 là dữ liệu gói thì tùy chọn này sẽ tạo ra các byte ngẫu nhiên.
- −s, −−src : In ra các số liệu thống kê khi kết thúc.
- −S, −−src=addr : cài đặt địa chỉ đích.
- −t, −−timeout= MSEC : Thời gian chờ đầu tiên tính theo mili giây.
- −u, −−unreach : Hiển thị các đối tượng không phản hồi.
- −v, −−version : hiển thị thông tin phiên bản.

<a name=vd></a>
## III. Một số  ví dụ
  - Fping tới một địa chỉ

```
    hai@hai-SVE14A15FXS ~ $ fping 8.8.8.8

    8.8.8.8 is alive

```
 - Fping đến một dải mạng và in ra kết quả :

```
    hai@hai-SVE14A15FXS ~ $ fping -s -g 192.168.100.0/24

    254 targets
      21 alive
     233 unreachable
       0 unknown addresses

       0 timeouts (waiting for response)
     422 ICMP Echos sent
      21 ICMP Echo Replies received
     278 other ICMP received

     0.06 ms (min round trip time)
     6.36 ms (avg round trip time)
     58.4 ms (max round trip time)
       10.585 sec (elapsed real time)



```
- FPing từ một file :  Tạo 1 file ping.txt ở Desktops có nội dung như sau :


```
192.168.100.30
192.168.100.26
192.168.100.44
```

  Tiến hành ping từ file ping.txt :

```
hai@hai-SVE14A15FXS ~/Desktop $ fping < ping.txt
192.168.100.30 is alive
ICMP Host Unreachable from 192.168.100.126 for ICMP Echo sent to 192.168.100.26
ICMP Host Unreachable from 192.168.100.126 for ICMP Echo sent to 192.168.100.30
ICMP Host Unreachable from 192.168.100.126 for ICMP Echo sent to 192.168.100.44
ICMP Host Unreachable from 192.168.100.126 for ICMP Echo sent to 192.168.100.26
ICMP Host Unreachable from 192.168.100.126 for ICMP Echo sent to 192.168.100.44
ICMP Host Unreachable from 192.168.100.126 for ICMP Echo sent to 192.168.100.26
ICMP Host Unreachable from 192.168.100.126 for ICMP Echo sent to 192.168.100.30
ICMP Host Unreachable from 192.168.100.126 for ICMP Echo sent to 192.168.100.44
192.168.100.26 is unreachable
192.168.100.44 is unreachable
```

   Trong 3 địa chỉ trên chỉ có địa chỉ 192.168.100.30 đang hoạt động.
