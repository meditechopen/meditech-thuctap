# Mục lục
- [1. Một số tùy chọn trong file cấu hình collectd](#1)
- [2. Một số plugin metric hệ thống](#2)
- [3. Một số plugin khác](#3)

<a name=1></a>
# 1.Một số tùy chọn trong file cấu hình collectd
## BaseDir <đường dẫn thư mục>
- Thiết lập thư mục cơ sở. Đây là thư mục lưu các file RRD được tạo ra. Trong đó mỗi node được lưu thành 1 file, trong các file đó chia thành từ loại file theo tên của plugin thu thập metric. Đây cũng là thư mục làm việc cho daemon.
## LoadPlugin <tên plugin>
- LoadPlugin có thể là một câu lệnh cấu hình đơn giản hoặc một khối với các tùy chọn bổ sung, ảnh hưởng đến việc hoạt động của LoadPlugin
- Ví dụ:
	+ 1 câu lệnh đơn giản như : ``LoadPlugin cpu``, ``LoadPlugin email`` ...
	+ 1 Khối các tùy chọn 
	```sh
	<LoadPlugin perl>
		Interval 60
	</LoadPlugin>
	```
``Interval Seconds``: Đặt khoảng thời gian cụ thể cho plugin để thu thập số liệu. Điều này sẽ ghi đè cài đặt Interval chung. Nếu plugin cung cấp hỗ trợ riêng cho việc xác định khoảng thời gian, cài đặt đó sẽ được ưu tiên.
## AutoLoadPlugin
Ở phiên bản 5.4 thì AutoLoadPlugin tùy chọn cho phép tự động tải các plugin mà có cấu hình được tìm thấy.
## CollectInternalStats false|true
- Nếu đặt là true, các thống kê khác nhau về daemon thu thập sẽ được thu thập với "collectd" như là tên của plugin. Mặc định là false
- Số liệu sau đây được báo cáo:
``collectd-write_queue/queue_length``
Số lượng các số liệu hiện có trong write queue. Bạn có thể giới hạn chiều dài hàng đợi với các tùy chọn WriteQueueLimitLow và WriteQueueLimitHigh.
``collectd-write_queue/derive-dropped``
Số lượng chỉ số bị giảm do giới hạn độ dài hàng đợi. Nếu giá trị này không bằng không, hệ thống của bạn không thể xử lý tất cả các số liệu đến và tự bảo vệ chính mình trước tình trạng quá tải bằng cách giảm số liệu.
``collectd-cache/cache_size``
Số lượng các phần tử trong bộ nhớ cache chỉ số liệu
## Include
- Nếu Đường dẫn dẫn đến một tệp, hãy bao gồm tệp đó. Nếu Đường dẫn dẫn đến một thư mục, đệ quy bao gồm tất cả các tệp nằm trong thư mục đó và các thư mục con của nó. Nếu chức năng wordexp có sẵn trên hệ thống của bạn, các ký tự đại diện giống như vỏ được mở rộng trước khi các tệp được đưa vào. Điều này có nghĩa là bạn có thể sử dụng câu lệnh như sau:
`` Include "/etc/collectd.d/*.conf"``
- Ví dụ trường hợp cụ thể: Ngoài file collectd.conf bạn có thể thêm 1 file thresholds.conf trong đó khai báo khối các tùy chọn plugin.
## PIDFile <File>
- Đặt nơi để ghi tệp PID vào. Tập tin này sẽ bị ghi đè khi nó tồn tại và bị xóa khi chương trình dừng lại. Một số init-scripts có thể ghi đè cài đặt này bằng tùy chọn -P
## PluginDir Directory
- Đường dẫn đến các plugin (đối tượng chia sẻ) của collectd.
## ReadThreads và WriteThreads 
- Số luồng để bắt đầu để đọc các plugin. Giá trị mặc định là 5, nhưng bạn có thể muốn tăng giá trị này nếu bạn có nhiều hơn 5 plugin cần nhiều thời gian để đọc.
## WriteQueueLimitHigh HighNum và WriteQueueLimitLow LowNum
- Số liệu được đọc bởi các chủ đề đã đọc và sau đó đưa vào một hàng đợi để được xử lý bởi các chuỗi ghi. Nhưng khi số liệu trong hàng đợi phát triển sẽ ảnh hưởng đến hiệu suất hoạt động của máy chủ. Để tránh trường hợp như vậy, bạn có thể giới hạn kích thước của hàng đợi này.
- Theo mặc định, không có giới hạn và bộ nhớ có thể phát triển vô hạn định. Đây không phải là vấn đề đối với client, nghĩa là các trường hợp chỉ xử lý các số liệu trên local. Đối với các máy chủ, bạn nên đặt giá trị này vào một giá trị khác không.
- Bạn có thể thiết lập các giới hạn bằng cách sử dụng WriteQueueLimitHigh và WriteQueueLimitLow. Mỗi tùy chọn khia báo một số là số lượng các chỉ số trong hàng đợi. Nếu có số liệu trong hàng đợi lớn hơn chỉ số HighNum, bất kỳ chỉ số mới nào sẽ bị loại bỏ. Nếu có ít hơn số liệu LowNum trong hàng đợi, tất cả số liệu mới sẽ được thêm vào.
- Nếu WriteQueueLimitHigh được đặt khác không và WriteQueueLimitLow không được đặt, giá trị mặc định sẽ bằng một nửa WriteQueueLimitHigh.
- Nếu bạn không muốn đặt ngẫu nhiên các giá trị khi kích thước hàng đợi giữa LowNum và HighNum, hãy đặt WriteQueueLimitHigh và WriteQueueLimitLow với cùng một giá trị.
- Kích hoạt tùy chọn CollectInternalStats là sự trợ giúp tuyệt vời để tìm ra các giá trị để đặt WriteQueueLimitHigh và WriteQueueLimitLow
## FQDNLookup true|false
- Nếu Tên máy chủ được xác định tự động, cài đặt này sẽ kiểm soát xem daemon có cố gắng tìm ra "tên miền đủ điều kiện", FQDN hay không. Điều này được thực hiện bằng cách sử dụng một tra cứu tên trả về bởi gethostname. Tùy chọn này được kích hoạt theo mặc định.

<a name=2></a>
# 2. Một số plugin metric hệ thống 
## Memory Plugin
- Memory plugin thu thập thông tin về bộ nhớ vật lý của máy ví dụ như cached, free, used và buffered.
- Có thể cấu hình để collectd có thể hiện thị thông số thu thập được dưới dạng phần trăm (%).

```sh
<Plugin memory>
		  ValuesAbsolute false "hiển thị theo dung lượng nếu là true"
          ValuesPercentage true
</Plugin>
```
- used(graphite) = used - buffered- cached

## Plugin df
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

## Plugin disk

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

## Interface Plugin

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

## Plugin CPU
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

## Load Plugin
- Load plugin thu thập dữ liệu về tải hệ thống. Những con số này đưa ra một cái nhìn tổng quán về việc sử dụng máy.
- Thông sổ hiện thị là tải hệ thống chia cho số lõi của CPU có sẵn:
```sh
<Plugin load>
  ReportRelative true
</Plugin>
```
- Biểu đồ hiển thị 3 thông số tải hệ thống trong longterm, midterm, shortterm tương ứng với trung bình tải trong 15 phút, 5 phút, 1 phút
- load-relative xuất hiện khi cấu hình trong file collectd.conf 'ReportRelative true'
## TCPconns Plugin
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
## Plugin users
- Users plugin thống kê tổng số người dùng đăng nhập vào hệ thống.
## Plugin libvirt
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

<a name=3></a>
# 3. Một số Plugin khác
## Plugin aggregation
Plugin aggregation để tổng hợp nhiều giá trị vào một tập hợp các chức năng sử dụng như sum, average, min và max. iều này có thể được sử dụng rộng rãi, ví dụ: Trung bình và tổng số thống kê CPU cho toàn hệ thống.
## Plugin ping 
- Plugin ping gửi các gói tin "ping" ICMP tới các host được định cấu hình theo định kỳ và đo độ trễ của mạng.
- Các tùy chọn cấu hình có sẵn:
	+ Host IP-address: Host để ping định kì. Tùy chọn này có thể được lặp lại nhiều lần để ping nhiều máy.
	+ Interval Seconds: Thiết lập khoảng thời gian để gửi các gói tin ICMP echo tới các máy tính được định cấu hình. Default: 1.0
	+ Timeout Seconds: Thời gian chờ phản hồi từ máy chủ mà gói tin ICMP đã được gửi đi. Default: 0.9
	+ TTL: Đặt Time-To-Live cho gói ICMP
	+ Size: Đặt kích thước của tải dữ liệu trong gói tin ICMP theo kích thước đã chỉ định (nó sẽ được lấp đầy với mẫu ASCII thông thường). Nếu không được thiết lập, mặc định chuỗi 56 byte được sử dụng để gói tin gói tin ICMPv4 là chính xác 64 byte, tương tự như hành vi của lệnh ping thông thường.
	+ SourceAddress: Thiết lập địa chỉ nguồn để sử dụng. 
	+ Device: Thiết lập thiết bị mạng gửi đi được sử dụng. Tên phải chỉ định tên giao diện (ví dụ: eth0). Điều này có thể không được hỗ trợ bởi tất cả các hệ điều hành.
	
## Plugin postgresql
- Các plugin postgresql truy vấn số liệu thống kê từ cơ sở dữ liệu PostgreSQL. 	
## Plugin powerdns
- Dùng để thống kê truy vấn từ một  PowerDNS nameserver 
## Plugin processes
- Process name 
Chọn thống kê chi tiết hơn về các tiến trình phù hợp với tên máy. Các thống kê được thu thập cho các quy trình được lựa chọn này là kích cỡ của user and system-time used, number of processes và number of threads, io data.
- ProcessMatch name regex
Tương tự với tùy chọn Process điều này cho phép bạn chọn các thống kê chi tiết hơn về các quy trình phù hợp với regex đã chỉ định 
- CollectContextSwitch Boolean
Collect context switch của một tiến trình.
## Plugin protocols
- Thu thập rất nhiều thông tin về các giao thức mạng khác nhau, chẳng hạn như IP, TCP, UDP, v.v .
- option Value: 
	+ Chọn có hoặc không chọn một giá trị cụ thể. Chuỗi được kết hợp có dạng "Protocol: ValueName" , ở đó Protocol sẽ được sử dụng như là cá thể plugin và ValueName sẽ được sử dụng như một cá thể kiểu. Một ví dụ của chuỗi đang được sử dụng sẽ là Tcp: RetransSegs.
	+ Bạn có thể sử dụng biểu thức chính quy để khớp với một số lượng lớn các giá trị chỉ với một tùy chọn cấu hình. Để chọn tất cả các giá trị TCP "mở rộng", bạn có thể sử dụng câu lệnh sau: `Value "/^TcpExt:/"`
## Plugin python
Plugin này nhúng một trình thông dịch Python vào bộ sưu tập và cung cấp một giao diện cho hệ thống plugin của collectd.
## Plugin AMQP
Các plugin AMQP có thể được sử dụng để giao tiếp với các trường hợp khác của collectd hoặc ứng dụng của bên thứ ba bằng cách sử dụng thông báo AMQP. 
## Plugin apache
- Thu thập số liệu thống kê từ mod_status module của Apache
- Để cấu hình apache-plugin, trước tiên bạn cần cấu hình chính xác Apache server. Apache-plugin mod_status cần phải được nạp và làm việc và các chỉ thị ExtendedStatus cần phải được kích hoạt. 
## Plugin apcups 
- Đọc các số liệu thống kê khác nhau về một nguồn điện liên tục không bị gián đoạn (UPS)
## Plugin battery
- Thu thập thông tin về pin, dòng điện ra và điện áp của pin
## Plugin barometer
- Plugin này đọc áp suất không khí tuyệt đối bằng cảm biến đo lưu lượng kỹ thuật số trên một bus I2C.
## Plugin bind 
- Bắt đầu với BIND 9.5.0, phần mềm máy chủ DNS được sử dụng rộng rãi nhất cung cấp số liệu thống kê phong phú về truy vấn, phản hồi và nhiều thông tin khác. Plugin bind lấy thông tin này được mã hoá trong XML và được cung cấp qua HTTP và gửi giá trị để collectd.
## Plugin ceph
- Plugin ceph thu thập các giá trị từ dữ liệu JSON được phân tích cú pháp bởi libyajl.
## Plugin cgroups
- Plugin này thu thập thời gian người dùng/hệ thống CPU cho mỗi cgroup bằng cách đọc các tệp tin cpuacct.stat trong cpuacct-mountpoint đầu tiên (thường là /sys/fs/cgroup/cpu.cpuacct trên các máy sử dụng systemd).
## Plugin chrony
- Plugin chrony thu thập dữ liệu ntp từ máy chủ chronyd, chẳng hạn như clock skew
## Plugin conntrack
- Plugin này thu thập số liệu thống kê IP conntrack.
## Plugin cpufreq
- Plugin này không có bất kỳ tùy chọn nào. Nó đọc /sys/devices /system/cpu/cpu0/cpufreq/scaling_cur_freq (dành cho CPU đầu tiên được cài đặt) để có được tần số CPU hiện tại. Nếu tập tin này không tồn tại hãy chắc chắn cpufreqd hoặc một công cụ tương tự đã được cài đặt
## Plugin cpusleep 
- Plugin này không có bất kỳ tùy chọn nào. Nó đọc CLOCK_BOOTTIME và CLOCK_MONOTONIC và báo cáo sự khác biệt giữa các đồng hồ này.
## Plugin curl 
- Plugin curl đọc các dòng bằng cách sử dụng net-misc/curl và sau đó phân tích chúng theo cấu hình
## Plugin curl_json
- Truy vấn dữ liệu đối tượng JavaScript (JSON) bằng cách sử dụng net-misc/curl và phân tích nó theo cấu hình của người dùng bằng cách sử dụng dev-libs/yajl
## Plugin curl_xml
- Đọc các tệp sử dụng net-misc / curl và phân tích nó như là Extensible Markup Language (XML)
## Plugin exec
- Các plugin Exec thực hiện các kịch bản / ứng dụng và đọc các giá trị trở lại được in đến STDOUTbởi chương trình đó. Điều này cho phép bạn mở rộng daemon một cách dễ dàng và linh hoạt.
Nhược điểm là thực hiện các chương trình bên ngoài là rất không hiệu quả 
## Plugin nfs
- Thu thập thông tin về việc sử dụng Network File System (NFS)
## Plugin nginx
- Thu thập số yêu cầu xử lý và số lượng kết nối hiện tại bằng trạng thái kết nối bởi nginx daemon