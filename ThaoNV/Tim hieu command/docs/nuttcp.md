## Tìm hiểu công cụ Nuttcp

## Mục lục

[1. Nuttcp là gì và để làm gì?](#def)

[2. Các options chính](#opts)

[3. Lab cài đặt và sử dụng Nuttcp](#lab)

------------

<a name ="def"></a>
## 1. Nuttcp là gì và để làm gì?

Nuttcp là một công cụ đo lường hiệu năng mạng được sử dụng bởi các nhà quản lý mạng và hệ thống. Việc sử dụng cơ bản nhất của nó là xác định thông lượng mạng TCP (hoặc UDP) thô bằng cách truyền memory buffers từ một hệ thống nguồn qua mạng kết nối tới hệ thống đích, truyền dữ liệu cho một khoảng thời gian nhất định hoặc chuyển một số lượng cụ thể các bytes.

Ngoài việc báo cáo luồng dữ liệu đạt được trong Mbps, nuttcp cũng cung cấp thêm thông tin hữu ích liên quan đến việc truyền dữ liệu như người sử dụng, hệ thống, wall-clock time, mức độ sử dụng của CPU, tỷ lệ mất mát dữ liệu (đối với UDP).

Nuttcp dựa trên nttcp. Nttcp được nâng cấp từ ttcp.Ttcp được viết bởi Mike Muuss vào năm 1984 để so sánh hiệu năng của TCP stacks. Nuttcp có một số tính năng hữu ích ngoài các tính năng ttcp / nttcp cơ bản, chẳng hạn như chế độ máy chủ, tỷ lệ giới hạn, nhiều luồng song song và sử dụng bộ đếm thời gian. Những thay đổi gần đây bao gồm hỗ trợ IPv6, multicast IPv4 và khả năng thiết lập kích thước phân đoạn tối đa hoặc bit TOS / DSCP. Nuttcp đang tiếp tục phát triển để đáp ứng các yêu cầu mới phát sinh và để thêm các tính năng mới mong muốn. Nuttcp đã được xây dựng thành công và chạy trên nhiều hệ thống Solaris, SGI, và PPC / X86 Linux, và có thể hoạt động tốt trên hầu hết các distributions của Unix. Nó cũng đã được sử dụng thành công trên các phiên bản khác nhau của hệ điều hành Windows.

<a name ="opts"></a>
## 2. Các options chính

Có 2 mode cơ bản.

- Mode classic là mode transmitter/receiver, nó cũng chính là mode mà ttcp và nttcp hoạt động. Ở mode này máy nhận được khởi tạo trước bằng câu lệnh `nuttcp -r` sau đó máy gửi sẽ phải được start bằng câu lệnh `nuttcp -t`. Mode này hiện đã không được khuyến khích sử dụng nữa.

- Mode đang được khuyến khích sử dụng đó là mode client/server. Với mode này, server sẽ được start với câu lệnh `nuttcp -S` (hoặc "nuttcp -1") và sau đó clent có thể truyền dữ liệu (sử dụng "nuttcp -t") hoặc nhận dữ liệu (sử dụng "nuttcp -r") từ phía server. Tất cả các thông tin cung cấp bởi nuttcp sẽ được thông báo trên phía client.

| Options | Descriptions |
|---------|--------------|
| -h | Các options có thể sử dụng |
| -V | Hiển thị thông tin về phiên bản |
| -t | Chỉ định máy transmitter |
| -r | Chỉ định máy receiver |
| -S | Chỉ định máy server |
| -1 | Giống với '-S' |
| -b | Định dạng output theo kiểu one-line |
| -B | Buộc receiver phải đọc toàn bộ buffer |
| -u | Sử dụng UDP (mặc định là TCP) |
| -v | Cung cấp thêm thông tin |
| -w | window size |
| -p | port sử dụng để kết nối dữ liệu, mặc định là 5001 |
| -P | với mode client-server, đây là port để kiểm soát kết nối, mặc định là 5000 |
| -n | Số lượng bufers |
| -N | Số lượng luồng dữ liệu truyền |
| -R | Tốc độ truyền |
| -l | packet length |
| -T | thời gian, mặc định là 10 giây |
| -i | thời gian gửi báo cáo (giây) |


<a name ="lab"></a>
## 3. Lab cài đặt và sử dụng Nuttcp

**Cài đặt nuttcp**

Đối với CentOS

`yum install nuttcp`

Đối với Ubuntu

`apt-get install nuttcp`

**Một vài kịch bản test cơ bản**

Server

`nuttcp -S`

Client

`nuttcp <serverhost>`

Câu lệnh này sử dụng phương thức test mặc định đó là gửi các gói tin tcp trong vòng 10 giây

``` sh
[root@thaonv ~]# nuttcp 172.16.69.239
 1986.7500 MB /  10.00 sec = 1666.2098 Mbps 59 %TX 55 %RX 0 retrans 1.13 msRTT
```

%TX và %RX là mức độ sử dụng CPU trên transmitter và receiver.


Server

`nuttcp -S`

Client

`nuttcp -w6m <serverhost>`

Gần giống câu lệnh trên nhưng window size sẽ được đẩy lên cao hơn


Server

`nuttcp -S`

Client

`nuttcp -u -i -Ri50m <serverhost>`

Thường sử dụng để test số lượng packet bị mất. Câu lệnh trên sẽ truyền trong 10 giây các gói tin udp với tốc độ 50 Mbps. Nó sẽ trả về 1 report mỗi giây.

``` sh
[root@thaonv ~]# nuttcp -u -i -Ri50m 172.16.69.239
    5.8740 MB /   1.00 sec =   49.2634 Mbps     0 /  6015 ~drop/pkt  0.00 ~%loss
    5.8672 MB /   1.00 sec =   49.2243 Mbps     0 /  6008 ~drop/pkt  0.00 ~%loss
    5.7988 MB /   1.00 sec =   48.6393 Mbps    40 /  5978 ~drop/pkt  0.67 ~%loss
    5.8281 MB /   1.00 sec =   48.8904 Mbps     8 /  5976 ~drop/pkt  0.13 ~%loss
    5.8330 MB /   1.00 sec =   48.9331 Mbps     0 /  5973 ~drop/pkt  0.00 ~%loss
    5.8613 MB /   1.00 sec =   49.1726 Mbps     0 /  6002 ~drop/pkt  0.00 ~%loss
    5.7812 MB /   1.00 sec =   48.4886 Mbps    79 /  5999 ~drop/pkt  1.32 ~%loss
    5.8408 MB /   1.00 sec =   49.0039 Mbps    12 /  5993 ~drop/pkt  0.20 ~%loss
    5.8398 MB /   1.00 sec =   48.9850 Mbps     0 /  5980 ~drop/pkt  0.00 ~%loss

   58.3477 MB /  10.00 sec =   48.9496 Mbps 99 %TX 9 %RX 139 / 59887 drop/pkt 0.23 %loss
```

Client

`nuttcp -w1m 127.0.0.1`

Dùng để test tốc độ bên trong của host.

``` sh
[root@thaonv ~]# nuttcp -w1m 127.0.0.1
21836.0000 MB /  10.00 sec = 18317.4542 Mbps 98 %TX 92 %RX 0 retrans 0.18 msRTT
```

**Link tham khảo:**

http://nuttcp.net/Welcome%20Page.html

https://www.systutorials.com/docs/linux/man/8-nuttcp/

http://nuttcp.net/nuttcp/5.1.3/examples.txt

https://fasterdata.es.net/performance-testing/network-troubleshooting-tools/nuttcp/
