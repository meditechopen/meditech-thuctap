# Tìm hiểu về các thông số kỹ thuật cơ bản của máy tính
-----------------------------------------------------------------------------
# Mục Lục
## [I. Tìm hiểu về RAM](#ram)
### [1.1 Định nghĩa RAM](#11)
### [1.2 Vai trò của RAM](#12)
### [1.3 Phân loại RAM](#13)
### [1.4 Cách kiểm tra các thông số RAM trên Linux](#14)
### [1.5 Các kiểm tra các thông số RAM trên Windows](#15)
## [II. Tìm hiều về CPUs](#cpu)
### [2.1 Định nghĩa CPU](#21)
### [2.2 Vai trò CPU](#22)
### [2.3 Các thành phần trong CPU](#23)
### [2.4 Cách kiểm tra các thông số CPU trên Linux](#24)
### [2.5 Cách kiểm tra các thông số CPU trên Windows](#25)
### [2.6 Kiểm tra các tiến trình chiếm dụng CPU](#26)
## [III. Tìm hiểu các thông số Disk I/O](#disk)
### [3.1 Thống kê các Disk I/O](#31)
### [3.2 Kiểm tra tốc độ đọc ghi các Disk I/O](#32)





-------------------------------------------------------------------------------
<a name=ram></a>
## I. Tìm hiểu về RAM

<a name=11></a>
### 1.1 Định nghĩa RAM
- RAM ( Randon Access Memory) - Là bộ nhớ truy cập ngẫu nhiên,khác với các bộ nhớ truy cập tuần tự là CPU có thể truy cập vào một địa chỉ nhớ bất kỳ mà không cần phải truy cập một cách tuần tự, điều này cho phép CPU đọc và ghi vào RAM vớ tốc độ nhanh hơn
- RAM nhanh hơn so với ổ đĩa cứng. Thậm chí ngay cả các ổ cứng thể rắn (solid state drives) mới nhất và tốt nhất cũng có tốc độ thấp hơn rất nhiều so với  RAM. Trong khi ổ cứng thể rắn (solid state drives) có thể đạt được tốc độ truyền tải hơn 1000 MB/s, module RAM hiện đại vượt qua tốc độ 15000 MB/s.
- Bộ nhớ RAM là môi trường "dễ bay hơi" (tạm thời). Bất kỳ dữ liệu nào được lưu trữ trên RAM đều sẽ bị mất ngay sau khi máy tính của bạn tắt. RAM hoạt động như bộ nhớ ngắn hạn, trong khi ổ đĩa cứng hoạt động giống như bộ nhớ dài hạn.
- RAM thường đắt hơn rất nhiều so với ổ đĩa cứng.

<a name=12></a>
### 1.2 Vai trò của RAM
- Khi một chương trình hoạt động (chẳng hạn như hệ điều hành, hay các ứng dụng) hoặc mở một tập tin (chẳng hạn như video, hình ảnh, nhạc, tài liệu...), nó sẽ được load tạm thời từ ổ đĩa cứng vào RAM. Sau khi được load vào RAM, chúng ta có thể truy cập chương trình, tập tin một cách dễ dàng.
- Nếu RAM bị hết, hệ điều hành của bạn sẽ bắt đầu “dump” một số chương trình mở và các tập tin thành paging file. Nếu paging file được lưu trữ quá nhiều sẽ khiến ổ đĩa cứng của bạn ngày một chậm dần. Do đó thay vì chạy mọi thứ trên RAM, một phần sẽ được truy cập từ ổ đĩa cứng.

<a name=13></a>
### 1.3 Phân loại RAM
- Trên thực tế, bản thân các loại RAM cũng có sự khác biệt. RAM thường có 3 loại: DDR 1, 2, và 3.
- RAM DDR1 thường có xung nhịp từ 266MHz tới 400MHz.
- RAM DDR2 và DDR3 (loại mới nhất) thường có xung nghiệp từ 400 - 800 MHz và từ 800 MHz - 1.6 GHz.
- Giá cả giữa DDR1, DDR2 và DDR3 chênh lệch nhau rất nhiều.

<a name=14></a>
### 1.4 Cách kiểm tra các thông số RAM trên Linux
- Kiểm tra các thông số về RAM đã sử dụng và tổng dung lượng RAM, dung lượng RAM còn trống,

```
# free
# free -m
# free -h
```

<img src=http://i.imgur.com/BsqeIAh.png>

 Trong đó :
 - total : Tổng RAM vật lý,(không bao gồm một bit nhỏ mà hạt nhân thường dự trữ cho chính nó lúc khởi động).
 - used : Bộ nhớ được sử dụng bởi hệ điều hành.
 - free : Bộ nhớ đang trống, chưa được sử dụng.
 - shared/buffers/cached : Điều này cho biết sử dụng bộ nhớ cho các mục đích cụ thể, các giá trị này được bao gồm trong giá trị sử dụng.
 - swap : cung cấp thông tin về việc sử dụng không gian hoán đổi (tức là các nội dung bộ nhớ đã tạm thời được chuyển sang đĩa).

Các thông tin khác về RAM :

```
sudo dmidecode --type 17
```

<img src=http://i.imgur.com/J69PzBE.png>

<a name=15></a>
### 1.5 Các kiểm tra các thông số RAM trên Windows
- Có nhiều cách để xem các thông số RAM trên Windows. Nhưng để xem chi tiết nhất thì nên sư dụng phần mềm CPUz :

<img src=http://i.imgur.com/7HZj7et.png>

- Type: loại RAM mà máy bạn đang sử dụng.
- Size: dung lượng RAM của máy bạn.
- Channels #: Số lượng RAM cắm trên máy Single hoặc Dual hoặc Triple...
- Frequency: tốc độ chuẩn của RAM.

<a name=cpu></a>
## II.Tìm hiểu về CPUs

<a name=21></a>
### 2.1 Định nghĩa CPU
- CPU viết tắt của chữ Central Processing Unit (tiếng Anh): bộ xử lý trung tâm, là các mạch điện tử trong một máy tính, thực hiện các câu lệnh của chương trình máy tính bằng cách thực hiện các phép tính số học, logic, so sánh và các hoạt động nhập/xuất dữ liệu (I/O) cơ bản do mã lệnh chỉ ra.
- CPU có nhiều kiểu dáng khác nhau. Ở hình thức đơn giản nhất, CPU là một con chip với vài chục chân. Phức tạp hơn, CPU được ráp sẵn trong các bộ mạch với hàng trăm con chip khác.
- CPU là một mạch xử lý dữ liệu theo chương trình được thiết lập trước. Nó là một mạch tích hợp phức tạp gồm hàng triệu transistor.

<a name=22></a>
### 2.2 Vai trò của CPU
- CPU đóng vai trò như não bộ của một chiếc Máy tính, tại đó mọi thông tin, thao tác, dữ liệu sẽ được tính toán kỹ lưỡng và đưa ra lệnh điều khiển mọi hoạt động của Laptop.
- Nhiệm vụ chính của CPU là xử lý các chương trình vi tính và dữ kiện.

<a name=23></a>
### 2.3 Các thành phần trong CPU

<img src=http://i.imgur.com/Ovgra9N.jpg>

CPU có 3 khối chính là :
- Bộ điều khiển: Là các vi xử lí có nhiệm vụ thông dịch các lệnh của chương trình và điều khiển hoạt động xử lí,được điều tiết chính xác bởi xung nhịp đồng hồ hệ thống. Mạch xung nhịp đồng hồ hệ thống dùng để đồng bộ các thao tác xử lí trong và ngoài CPU theo các khoảng thời gian không đổi.Khoảng thời gian chờ giữa hai xung gọi là chu kỳ xung nhịp.Tốc độ theo đó xung nhịp hệ thống tạo ra các xung tín hiệu chuẩn thời gian gọi là tốc độ xung nhịp – tốc độ đồng hồ tính bằng triệu đơn vị mỗi giây-Mhz. Thanh ghi là phần tử nhớ tạm trong bộ vi xử lý dùng lưu dữ liệu và địa chỉ nhớ trong máy khi đang thực hiện tác vụ với chúng.
-  Bộ số học-logic: Có chức năng thực hiện các lệnh của đơn vị điều khiển và xử lý tín hiệu. Theo tên gọi,đơn vị này dùng để thực hiện các phép tính số học( +,-,/ )hay các phép tính logic (so sánh lớn hơn,nhỏ hơn…)
- Các thanh ghi : Là các bộ nhớ có dung lượng nhỏ nhưng tốc độ truy cập rất cao, nằm ngay trong CPU, dùng để lưu trữ tạm thời các toán hạng, kết quả tính toán, địa chỉ các ô nhớ hoặc thông tin điều khiển. Mỗi thanh ghi có một chức năng cụ thể. Thanh ghi quan trọng nhất là bộ đếm chương trình (PC - Program Counter) chỉ đến lệnh sẽ thi hành tiếp theo.

<a name=24></a>
### 2.4 Cách kiểm tra các thông số CPUs trên Linux
- Thông tin về CPU bao gồm các chi tiết về bộ vi xử lý, như kiến ​​trúc, tên nhà cung cấp, mô hình, số lõi, tốc độ của mỗi lõi.

Có nhều cách kiểm tra các thông số trên :


```
$ cat /proc/cpuinfo
```

<img src=http://i.imgur.com/xDxZ2p4.png>

<img src=http://i.imgur.com/nFBhmJE.png>

- Mỗi bộ vi xử lý hoặc lõi được liệt kê riêng biệt các chi tiết khác nhau về tốc độ, kích thước bộ nhớ cache và tên mô hình được bao gồm trong mô tả.

```
$ lscpu
```

<img src=http://i.imgur.com/X3s6hJe.png>

<a name=25></a>
### 2.5 Cách kiểm tra các thông số CPUs trên Windows
Sử dụng CPUz để kiểm tra các thông số một cách chi tiết :

<img src=http://i.imgur.com/aFydKvW.png>

- Name: Tên của chip xử lý – vd: Core 2 Duo E6700, Core i3 320M…
- Code name: Tên của kiến trúc CPU hay còn gọi là thế hệ của CPU – vd: Wolfdale, Sandy Bridge, Ivy Bridge…
- Packpage: Là dạng socket của CPU – vd: 478, 775, 1155… thông số này rất quan trọng khi bạn có ý định nâng cấp CPU của mình.
- Core Speed: Đây là xung nhịp của chip CPU, hay thường được gọi là tốc độ của CPU
- Level 2: Thông số về bộ nhớ đệm, thông số này càng cao thì CPU càng ít bị tình trạng nghẽn dữ liệu khi xử lý (hiện tượng thắt cổ chai). Một số CPU còn có bộ nhớ Level 3… số level càng lớn, kèm theo dùng lượng càng cao, cpu của bạn chạy càng nhanh.
- Cores và Threads: đây là số nhân và số luồng của CPU. Số này thường là số chẵn và còn được biết đến với cách gọi kiểu như: CPU 2 nhân, CPU 4 nhân, CPU 6 nhân…

<a name=26></a>
### 2.6 Cách kiểm tra tiến trình chiếm dụng

**Trên Linux sử dụng Sysstat:**

- Trên Linux hay bất cứ hệ điều hành nào , khi có một tiến trình nào đó hoạt động thì CPU đều cung cấp tài nguyên hệ thống để tiến trình đó hoạt động.Tuy nhiên có một số tiến trình yêu cầu quá  nhiều tài nguyên một cách đột ngột, khiến hệ thống bị treo. Người quản trị cần phải tìm ra các tiến trình đó để xử lý một cách nhanh nhất, tránh ảnh hưởng đến hệ thống.
- Với Linux thì sử dụng công cụ `SysStat`.Để cài đặt chương trình này dùng câu lệnh : `yum install sysStat`.
- Trong ví dụ đầu tiên, chúng ta sẽ cần tìm ra rằng thực sự tài nguyên CPU đang được sử dụng ở đâu, bạn hãy thử với dòng lệnh này:

```
haikma@hai # sar -u 3 10
Linux 4.4.0-53-generic (haikma) 	04/25/2017 	_x86_64_	(4 CPU)

04:41:33 PM     CPU     %user     %nice   %system   %iowait    %steal     %idle
04:41:36 PM     all      3,19      0,00      0,67      0,84      0,00     95,30
04:41:39 PM     all      3,42      0,00      1,17      0,58      0,00     94,83
04:41:42 PM     all      4,69      0,00      1,09      0,42      0,00     93,81
04:41:45 PM     all      4,29      0,00      1,26      0,34      0,00     94,11
04:41:48 PM     all      3,95      0,00      1,51      3,45      0,00     91,08
04:41:51 PM     all      3,20      0,00      0,84      0,42      0,00     95,54
04:41:54 PM     all      4,38      0,00      1,18      0,84      0,00     93,60
04:41:57 PM     all      3,27      0,00      0,75      1,17      0,00     94,80
04:42:00 PM     all      3,43      0,00      0,75      0,25      0,00     95,56
04:42:03 PM     all      3,36      0,00      0,67      1,18      0,00     94,79
Average:        all      3,72      0,00      0,99      0,95      0,00     94,34
```

Trước hết với lệnh `sar -u 3 10`, bạn có thể hiểu là: với lệnh này server sẽ tiến hành kiểm tra 10 lần, mỗi lần cách nhau 3s, bên cạnh đó còn cần chú ý thêm các thông số quan trọng khác ở đây, đó là:
- %user : đây là lượng chiếm dụng CPU khi một user khởi tạo tiến trình
- %nice: đây là lượng chiếm dụng CPU khi tiến trình được tạo bởi user với độ ưu tiên là nice.
- %system: đây là lượng chiếm dụng CPU khi tiến trình được tạo ra bởi kernel (hệ thống).
- %iowait: đây là lượng chiếm dụng CPU khi cpu đang trong trạng thái idle ở thời điểm phát sinh I/O request.
- %idle: : đây là lượng chiếm dụng CPU khi cpu đang trong trạng thái idle ở thời điểm không có I/O request.

Lệnh tiếp theo sẽ cho phép chúng ta tìm ra được cụ thể rằng tiến trình nào đang chiếm dụng CPU:

```
ps -eo pcpu,pid,user,args | sort -r -k1 | less
```

<img src=http://i.imgur.com/xGJu56y.png>

- Sau khi đã tìm ra nguyên nhân tiến trình nào đã chiếm dụng CPU, bạn có thể thực hiện Kill nó thông qua PID, hoặc điều chỉnh lại các thông số cho phù hợp hơn nếu cần thiết.

**Trên Windows sử dụng cộng cụ Task Manager :**

Trên Windows 8 :

<img src=http://i.imgur.com/9ldM1XO.png>

Trên Windows 7 :

<img src=http://i.imgur.com/CEM1qKp.png>

 Nếu thấy tiến trình nào yêu cầu quá nhiều tài nguyên dẫn đến tình trạng treo máy thì cần ngắt tiến trình đó ngay :

 <img src=http://i.imgur.com/GBnyaPs.png>s

- Kiểm tra mức độ sử dụng CPU và RAM tổng thể : thẻ Performance để xem mức độ sử dụng CPU và bộ nhớ RAM của Windows. Mục CPU Usage History cho thấy thông tin tổng hợp về quá trình sử dụng CPU, bên cạnh các biểu đồ riêng cho từng nhân của CPU.

<img src=http://i.imgur.com/8sMC94T.png>

<a name=disk></a>
## III. Tìm hiểu các thông số Disk I/O

<a name=31></a>
### 3.1 Thống kê các Disk I/O
- Sử dụng IoStat là công cụ đơn giản để thu thập và hiển thị số liệu input/oput của thiết bị lưu trữ. Công cụ này thường được sử dụng để lần vết các vấn đề liên quan tới hiệu năng lưu trữ bao gồm thiết bị, ổ đĩa cục bộ, ổ đĩa từ xa như NFS.
- Cài đặt : `yum instal iostat`
- Thống kê :

```
# iostat

Linux 4.4.0-53-generic (haikma) 	04/25/2017 	_x86_64_	(4 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.60    3.65    1.04    4.29    0.00   88.42

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
cciss/c0d0       17.79       545.80       256.52  855159769  401914750
cciss/c0d0p1      0.00         0.00         0.00       5459       3518
cciss/c0d0p2     16.45       533.97       245.18  836631746  384153384
cciss/c0d0p3      0.63         5.58         3.97    8737650    6215544
cciss/c0d0p4      0.00         0.00         0.00          8          0
cciss/c0d0p5      0.63         3.79         5.03    5936778    7882528
cciss/c0d0p6      0.08         2.46         2.34    3847771    3659776
```

<a name=32></a>
### 3.2 Kiểm tra tốc độ đọc ghi các I/O

- Sử dụng công cụ Iotop, cũng rất giống với lệnh TOP và Htop nhưng tính năng chính của nó là giám sát và hiển thị tiến trình và Disk I/O theo thời gian thực. Công cụ này hữu ích trong việc tìm ra chính xác tiến trình nào đang thao tác đọc/ghi đĩa.
- Cài đặt : `yum install iotop`
- Hiển thị :

<img src=http://i.imgur.com/qhfpqiw.png>

**Trên Windows:**
- Windows cung cấp các công cụ có sẵn nhằm kiểm tra và giám sát các hoạt động Disk I/O, hiệu suất, nhiệt độ trong hệ thống :

<img src=http://i.imgur.com/WFuftzE.png>
