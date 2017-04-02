# Tìm hiểu về công cụ TCPdump
=================================================
# Mục lục
## [I. Định nghĩa](#dn)
## [II. Định dạng chung của một dòng giao thức](#ddc)
## [III. Các tùy chọn](#options)
## [VI. Một số bộ lọc cơ bản](#boloc)
## [V. Một số ví dụ TCPdump](#vidu)
## [VI . Tài liệu tham khảo](#tltk)


<a name=dn></a>
## I.Định nghĩa

  Tcpdump là phần mềm bắt gói tin trong mạng làm việc trên hầu hết các phiên bản hệ điều hành unix/linux. Tcpdump cho phép bắt và lưu lại những gói tin bắt được, từ đó chúng ta có thể sử dụng để phân tích.

  Tcpdump xuất ra màn hình nội dung các gói tin (chạy trên card mạng mà máy chủ đang lắng nghe) phù hợp với biểu thức logic chọn lọc mà khách hàng nhập vào. Với  từng loại tùy chọn khác nhau khách hàng có thể xuất những mô tả về gói tin này ra một file “pcap” để phân tích sau, và có thể đọc nội dung của file “pcap” đó với option –r của lệnh tcpdump, hoặc sử dụng các phần mềm khác như là : Wireshark.

  Trong trường hợp không có tùy chọn, lệnh tcpdump sẽ tiếp tục chạy cho đến khi nào nó nhận được một tín hiệu ngắt từ phía khách hàng. Sau khi kết thúc việc bắt các gói tin, tcpdump sẽ báo cáo các cột sau:
  - Packet capture: số lượng gói tin bắt được và xử lý.
  - Packet received by filter: số lượng gói tin được nhận bởi bộ lọc.
  - Packet dropped by kernel: số lượng packet đã bị dropped bởi cơ chế bắt gói tin của hệ điều hành.

<a name=ddc></a>
## II. Định dạng chung của một dòng giao thức
  Một dòng giao thức trong TCPdump thường có định dạng sau :

```
time-stamp src > dst:  flags  data-seqno  ack  window urgent options
```
  Trong đó :
  - `Time-stamp` : hiển thị thời gian gói tin được capture.
  - `Src và dst` : hiển thị địa IP của người gởi và người nhận.
  - Cờ `Flags` thì bao gồm các giá trị sau:
  <ul>
  <li>S(SYN):  Được sử dụng trong quá trình bắt tay của giao thức TCP.</li>
  <li>A(ACK):  Được sử dụng để thông báo cho bên gửi biết là gói tin đã nhận được dữ liệu thành công.</li>
  <li>F(FIN): Được sử dụng để đóng kết nối TCP.</li>
  <li>P(PUSH): Thường được đặt ở cuối để đánh dấu việc truyền dữ liệu.</li>
  <li>R(RST): Được sử dụng khi muốn thiết lập lại đường truyền.</li>
  </ul>
  - `Data-sqeno` : Số sequence number của gói dữ liệu hiện tại.
  - `ACK` : Mô tả số sequence number tiếp theo của gói tin do bên gởi truyền (số sequence number mong muốn nhận được).
  - `Window` : Vùng nhớ đệm có sẵn theo hướng khác trên kết nối này.
  - `Urgent` : Cho biết có dữ liệu khẩn cấp trong gói tin.

<a name=tc></a>
## III. Một số tùy chọn trong TCPdump
  TCPdump có các tùy chọn thông dụng sau :
  - `-i` : Sử dụng option này khi khách hàng muốn chụp các gói tin trên một interface được chỉ định.
  - `-D`: Khi sử dụng option này, tcpdump sẽ liệt kê ra tất cả các interface đang hiện hữu trên máy tính mà nó có thể capture được.
  - `-c N` : khi sử dụng option này, tcpdump sẽ dừng hoạt động sau khi capture N gói tin.
  - `-n`: Khi sử dụng option này, tcpdump sẽ không phân giải từ địa chỉ IP sang hostname.
  - `-nn`: Tương tự như option –n, tuy nhiên tcpdump sẽ không phân giải cả portname.
  - `-v`: Tăng số lượng thông tin về gói tin mà bạn có thể nhận được, thậm chí có thể tăng thêm với option –vv hoặc –vvv.
  - `-s`: Định nghĩa snaplength (kích thước) gói tin sẽ lưu lại, sử dụng 0 để mặc định.
  - `-q`: Khi sử dụng option này thì lệnh tcpdump sẽ hiển thị ít thông tin hơn.
  - `-w filename`: Khi sử dụng option này tcpdump sẽ capture các packet và lưu xuống file chỉ định.
  - `-r filename`: Sử dụng kèm với option –w, dùng để đọc nội dung file đã lưu từ trước.
  - `-x`: Hiển thị dữ liệu của gói tin capture dưới dạng mã Hex.
  - `-xx`: Tương tự option –x tuy nhiên sẽ chuyển đổi cả ethernet header.
  - `-X`: Hiển thị dữ liệu của gói tin capture dưới dạng mã Hex và ASCII.
  - `-A`: Hiển thị các packet được capture dưới dạng mã ACSII.
  - `-S`: Khi tcpdump capture packet, thì nó sẽ chuyển các số sequence number, ACK thành các relative sequense number, relative ACK. Nếu sử dụng option –Snày thì nó sẽ không chuyển mà sẽ để mặc định.
  - `-F`  filename: Dùng để filter các packet với các luật đã được định trước trong tập tin filename.
  - `-e`: Khi sử dụng option này, thay thì hiển thị địa chỉ IP của người gửi và người nhận, tcpdump sẽ thay thế các địa chỉ này bằng địa chỉ MAC.
  - `-t`: Khi sử dụng option này, tcpdump sẽ bỏ qua thời gian bắt được gói tin khi hiển thị cho khách hàng.
  - `-tt`: Khi sử dụng option này, thời gian hiển thị trên mỗi dòng lệnh sẽ không được format theo dạng chuẩn.
  - `-ttt`: Khi sử dụng option này, thời gian hiển thị chính là thời gian chênh lệnh giữa thời gian tcpdump bắt được gói tin của gói tin và gói tin đến trước nó.
  - `-tttt`: Khi sử dụng option này, sẽ hiển thị thêm ngày vào mỗi dòng lệnh.
  - `-ttttt`: Khi sử dụng option này, thời gian hiển thị trên mỗi dòng chính là thời gian chênh lệch giữa thời gian tcpdump bắt được gói tin của gói tin hiện tại và gói tin đầu tiên.
  - `-K`: Với option này tcpdump sẽ bỏ qua việc checksum các gói tin.
  - `-N`: Khi sử dụng option này tcpdump sẽ không in các quality domain name ra màn hình.
  - `-B` size: Sử dụng option này để cài đặt buffer_size .
  - `-L`: Hiển thị danh sách các datalink type mà interface hỗ trợ.
  - `-y`: Lựa chọn datalinktype khi bắt các gói tin.

<a name=boloc></a>
## VI. Một số bộ lọc cơ bản
- `dst A`: Khi sử dụng option này, tcpdump sẽ chỉ capture các gói tin có địa chỉ đích là “A”, có thể sử dụng kèm với từ khóa net để chỉ định một dãy mạng cụ thể.
- `src A`: Tương tự như option dst, nhưng thay vì capture các gói tin có địa chỉ đích cụ thể thì nó sẽ capture các gói tin có địa chỉ nguồn như quy định.
- `host A`: Khi sử dụng option này, tcpdump sẽ chỉ capture các gói tin có địa chỉ nguồn hoặc địa chỉ đích là “A”.
- `port / port range`: Khi sử dụng option này, tcpdump sẽ chỉ capture các gói tin có địa chỉ port được chỉ định rõ, hoặc nằm trong khoảng range định trước. Có thể sử dụng kèm với option dst hoặc src.
- `less`: Khi sử dụng từ khóa này, tcpdump sẽ lọc (filter) các gói tin có dung lượng nhỏ hơn giá trị chỉ định.
- `greater`: Khi sử dụng từ khóa này, tcpdump sẽ lọc (filter) các gói tin có dung lượng  cao hơn giá trị chỉ định.
- `(ether | ip) broadcast`: Capture các gói tin ip broadcast hoặc ethernet broadcast.
- `(ether | ip | ip6) multicast`: Capture các gói tin ethernet, ip , ipv6 multicast.
- Ngoài ra, tcpdump còn có thể capture các gói tin theo các protocol như : udp, tcp, icmp, ipv6  (chỉ cần gõ trực tiếp các từ khóa vào là được). Ví dụ: tcpdump icmp.

  Một số kết hợp trong TCP dump:
  - `AND`: Sử dụng từ khóa and hoặc &&.
  - `OR`: Sử dụng từ khóa or hoặc ||.
  - `EXCEPT`: sử dụng từ khóa not hoặc !.
  - Ngoài ra để gom nhóm các điều kiện ta có thể dùng cặp từ khóa ‘’.  Ví dụ: tcpdump –i eth0 ‘dst host 192.168.1.1 or 192.168.1.10 or 192.168.1.11’.

<a name=vidu></a>
## V. Một số ví dụ TCPdump
 - Hiển thị tất cả các interface trên máy tính mà tcpdump có thể lắng nghe được:
```
tcpdump -D
```
 - Lọc các gói tin trên card mạng eth0, có địa chỉ đích là 192.168.1.0 hoặc địa chỉ nguồn là 192.168.1.0 :
```
# tcpdump –i eth0 host 192.168.1.0
# tcpdump –i eth0 src 192.168.1.0 or host 192.168.1.0
```
 - Lọc các gói tin ARP chạy trên card mạng eth0, xuất phát từ dãy mạng 192.168.1.0/24 :
```
# tcpdump –i eth0 arp src net 192.168.1.0/24
```
 - Lọc các gói tin ICMP chạy trên mạng eth0,  đi đến máy đích có địa chỉ MAC là 00-23-14-43-E8-08. Khi xuất ra màn hình không cho phân giải tên miền, cũng như không sử dụng số relative sequence. Lưu output vào file test.cap. Khi đọc file đó lên: không hiển thị số sequence number, không phân giải hostname :

```
# tcpdump –i eth0 –w test.cap eth0 dst host 00:23:14:42:E8:08
# tcpdump –Snnr test.cap
```
 ....

<a name=tltk></a>
## VI . Tài liệu tham khảo

 - https://vinahost.vn/ac/knowledgebase/248/TCPDUMP-va-cac-th-thut-s-dng.html
 - http://www.tcpdump.org/tcpdump_man.html
