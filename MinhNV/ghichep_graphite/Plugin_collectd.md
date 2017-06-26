# Plugin aggregation
Plugin aggregation để tổng hợp nhiều giá trị vào một tập hợp các chức năng sử dụng như sum, average, min và max. iều này có thể được sử dụng rộng rãi, ví dụ: Trung bình và tổng số thống kê CPU cho toàn hệ thống.
# Memory Plugin
- Memory plugin thu thập thông tin về bộ nhớ vật lý của máy ví dụ như cached, free, used và buffered.
- Có thể cấu hình để collectd có thể hiện thị thông số thu thập được dưới dạng phần trăm (%).

```sh
<Plugin memory>
		  ValuesAbsolute false "hiển thị theo dung lượng nếu là true"
          ValuesPercentage true
</Plugin>
```
- used(graphite) = used - buffered- cached

# Plugin df
- df plugin thu thập thông tin về việc sử dụng hệ thống file. Ví dụ trong một phân vùng, người dùng đã sử dụng hết bao nhiêu không gian và bao nhiêu không gian có sẵn để sử dụng.
- Trên mỗi thư mụcngười dùng có thể thấy các thông số:

Trong đó total = free + reserved + used

- Để collectd có thể thu thập dữ liệu từ tất cả các file hệ thống, người dùng cấu hình trên file collectd.conf như sau:

```sh
<Plugin "df">
  IgnoreSelected true
</Plugin>
```

- Để collectd chỉ có thể lấy dữ liệu từ một phân vùng, cấu hình trong file collectd.conf:

```sh
<Plugin "df">
  # ở đây người dùng có thể thay đổi phân vùng để lấy dữ liệu
  Device "/dev/hda1"
  MountPoint "/home"
  FSType "ext3"
  IgnoreSelected false
  ReportInodes false
  # Only in Version 4 since 4.9
  #ReportReserved false
</Plugin>
```

# Plugin disk

- Plugin disk thu thập thông tin hiệu suất của ổ đĩa.
- Trên mỗi phân vùng, người dùng có thể nhìn thấy tốc độ đọc ghi của:
  + merged (Operations/s)
  + octets (Bytes/s)
  + operation (Operations/s)
  + time (Seconds/s)
 - Để collectd có thể lấy dữ liệu từ sda, cấu hình trong file collectd.conf:
 ```sh
 <Plugin "disk">
  # có thể thay sda= sdb nếu như máy có nhiều ổ đĩa
  Disk "sda"
  Disk "/^hd/"
  IgnoreSelected false
</Plugin>
```

# Interface Plugin

- Interface plugin thu thập dữ liệu về lưu lượng truy cập, số lượng gói trên mỗi giây và lỗi xảy ra trên các card mạng.
- Trên mỗi card mạng, người dùng có thể thu thập thông tin :
  + errors (errors/s) : số lỗi trên một giây.
  + octets (bit/s) tốc độ gửi và nhận dữ liệu trên một card mạng.
  + packets (packets/s): số package gửi và nhận trên mỗi card mạng.
- Để collectd thu thập dữ liệu từ một card mạng, cấu hình trên file collectd.conf như sau:
```sh
<Plugin "interface">
  Interface "eth0"
  IgnoreSelected false
</Plugin>
```
- Để collectd thu thập dữ liệu trên tất cả các card mạng, cấu hình:
```sh
<Plugin "interface">
  Interface "lo"
  Interface "sit0"
  IgnoreSelected true
</Plugin>
```

# Plugin CPU
- Plugin CPU dùng để hiển thị tình trạng CPU
```sh
<Plugin cpu>
  ReportByCpu false
  ReportByState true
  ValuesPercentage true
</Plugin>
```
  + ReportByCpu false : Hiển thị CPU chung khi máy chủ có nhiều CPU
  + ReportByState true : Hiển thị tất cả các tham số về tình trạng sử dụng.
  + ValuesPercentage true : Hiển thị theo phần trăm (%) thay vì hiển thị mặc định

# Load Plugin
- Load plugin thu thập dữ liệu về tải hệ thống. Những con số này đưa ra một cái nhìn tổng quán về việc sử dụng máy.
- Thông sổ hiện thị là tải hệ thống chia cho số lõi của CPU có sẵn:
```sh
<Plugin load>
  ReportRelative true
</Plugin>
```
- Biểu đồ hiển thị 3 thông số tải hệ thống trong longterm, midterm, shortterm tương ứng với trung bình tải trong 15 phút, 5 phút, 1 phút
- load-relative xuất hiện khi cấu hình trong file collectd.conf 'ReportRelative true'
# TCPconns Plugin
- TCPconns plugin thu thập dữ liệu về tổng số lượng kết nối TCP trên một port cụ thể hoặc tất cả các port.
- Lấy giữ liệu về tổng số kết nối tcp trên tất cả các port
```sh
<Plugin tcpconns>
	AllPortsSummary true
</Plugin>
```
- Trên biểu đồ hiển thị:

 + tcp_connections-CLOSED: các kết nối tcp đã đóng
 + tcp_connections-CLOSE_WAIT: các kết nối tcp đang chờ để đóng
 + tcp_connections-CLOSING: các kết nối tcp đang đóng
 + tcp_connections-ESTABLISHED: cổng đã sẵn sàng nhận/ gửi dữ liệu với tcp
 + tcp_connections-FIN_WAIT1: các kết nối đang ở trạng thái chờ đợi 1 ACK cho một FIN đã gửi hoặc là chờ đợi một yêu cầu kết thúc kết nối
 + tcp_connections-FIN_WAIT2: các kết nối đã nhận được một ACK cho yêu cầu của mình để chấm dứt kết nối
 + tcp_connections-LAST_ACK: các kết nối đã gửi FIN riêng của mình và đang chờ đợi 1 ACK.
 + tcp_connections-LISTEN: đang đợi yêu cầu kết nối từ một TCP và cổng bất kỳ.
 + tcp_connections-SYN_RECV: đang đợi tcp ở xa gửi lại một tin báo nhận sau khi đã gửi cho TCP ở xa đó một tin báo nhận kết nối.
 + tcp_connections-SYN_SENT:  đang đợi TCP ở xa gửi lại một gói tin TCP với các cờ SYN và ACK được bật
 + tcp_connections-TIME_WAIT: đang đợi qua đủ thời gian để chắc chắn là TCP ở xa nhận được tin nhắn được tín báo nhận về yêu cầu kết thúc của nó.
- Thay vì thu thập số lượng các kết nối TCP trên tất cả các cổng người dùng có thể cấu hình để collectd có thể thu thập các kết nối TCP từ một port

```sh
<Plugin "tcpconns">
	ListeningPorts false # Không lấy dữ liệu từ tất cả các port
	LocalPort "22" #tính số kêt nối trên port nội bộ (25 : port của mail)
	RemotePort "22" #tính số kêt nối trên port bên ngoài
</Plugin>
```
# Plugin users
- Users plugin thống kê tổng số người dùng đăng nhập vào hệ thống.
# Plugin libvirt
- Plugin libvirt sử dụng API libvirt để thu thập thông tin các máy ảo. Bằng cách này bạn có thể thu thập thông tin hệ thống máy ảo mà không cần cài đặt collectd lên từng máy ảo.
- Kết nối tới máy chủ
  + `Connection "xen:///"` : ví dụ sử dụng xen
  + `Connection "qemu:system///"` : ví dụ trường hợp sử dụng KVM
- `RefreshInterval seconds` :
  + Làm mới danh sách domain và thiết bị mỗi giây . Mặc định là 60 giây.
  + Làm mới các thiết bị đặc biệt là hoạt động khá tốn kém, vì vậy nếu thiết lập ảo hóa của bạn là tĩnh bạn có thể xem xét. Nếu tùy chọn này được đặt thành 0, làm mới được tắt hoàn toàn.
```sh
Domain name
BlockDevice name:dev
InterfaceDevice name:dev
IgnoreSelected true|false
```
  + Chọn tên miền và thiết bị được thu thập.
  + Nếu IgnoreSelected không được cung cấp hoặc false sau đó các tên miền được liệt kê và thiết bị chỉ thu thập được đĩa và mạng.
  + Nếu IgnoreSelected là true thì test sẽ bị đảo ngược và các tên miền được liệt kê và các thiết bị đĩa / mạng bị bỏ qua, trong khi phần còn lại được thu thập.
- 1 ví dụ
```sh
<Plugin "virt">
  Connection "xen:///"
  RefreshInterval 60
  #Domain "name"
  #BlockDevice "name:device"
  #InterfaceDevice "name:interface"
  #IgnoreSelected false
  HostnameFormat "name"
</Plugin>
```
