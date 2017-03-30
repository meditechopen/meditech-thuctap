# Tìm hiểu về nestat commands 
**Netstat** là một công cụ hữu ích của Linux cho phép bạn kiểm tra những dịch vào nào đang kết nối đến hệ thống của bạn. Nó rất hữu ích trong việc phân tích cái gì đang xảy ra trên hệ thống của bạn khi bạn cố gắng ngăn chặn một cuộc tấn công nhằm vào nó. Bạn có thể tìm thêm thông tin như có bao nhiêu kết nối được tạo ra trên một cổng, địa chỉ IP nào đang kết nối đến và nhiều thông tin khác nữa. Netstat đi kèm trong hầu hết các bản phân phối của Linux vì vậy nó nên được cài đặt trên hệ thống của bạn. 

### Sử dụng netstat để liệt kê các port ở cả 2 trạng thái TCP và UDP 

```netstat -aut ```

Trong đó
 
-a: all- tất cả các kết nối trong hệ thống.

-u: liệt kê các port ở trạng thái UDP.

-t: liệt kê các port ở trạng thái TCP.

<img src="http://i.imgur.com/tUTr9Yz.png">

- Proto: Tên giao thức
- Recv-Q: là dữ liệu mà chưa được kéo từ 
bộ đệm socket bởi ứng dụng. 
- Send-Q: Số byte không được máy chủ từ xa thừa nhận
- Local Address: Địa chỉ IP của hệ thống và port kết nối
- Foreign Address: Địa chỉ dịch vụ đang được kết nối đến và số port
- State: Trạng thái port
|-------------|---------------------------------------|
| ESTABLISHED | Ổ cắm có kết nối đã được thiết lập.|
| SYN_SENT | Ổ cắm đang tích cực cố gắng thiết lập kết nối. |
| SYN_RECV | Đã nhận được yêu cầu kết nối từ mạng. |
| FIN_WAIT1 | Ổ cắm đã được đóng, và kết nối đang tắt. |
| FIN_WAIT2 | Kết nối đã được đóng lại, và ổ cắm đang chờ tắt máy từ đầu xa. |
| TIME_WAIT | Các ổ cắm đang chờ đợi sau khi gần xử lý các gói tin vẫn còn trong mạng. |
| CLOSE | Ổ cắm không được sử dụng. |
| CLOSE_WAIT | The remote end has shut down, waiting for the socket to close. |
 |LAST_ACK | The remote end has shut down, and the socket is closed. Waiting for acknowledgement. |
| LISTEN | Ổ cắm đang lắng nghe cho các kết nối đến. Các ổ cắm này không được hiển thị trong đầu ra, trừ khi bạn chỉ định tùy chọn --listening ( -l ) hoặc --all ( -a ). |
| CLOSING | Cả hai ổ cắm đều bị đóng lại nhưng chúng tôi vẫn không có tất cả dữ liệu của chúng tôi được gửi. |
| UNKNOWN | Không xác định. |



#### Sử dụng netstat để liệt kê các port TCP 

```netstat -at```

#### Sử dụng netstat để liệt kê các port UDP 

```netstat -au```

### Liệt kê các port ở trạng thái Listening 

```netstat -l```

### Thống kê giao thức 

Thống kê theo từng giao thức. Mặc định sẽ hiển thị thống kê theo TCP, UDP, ICMP, và IP. Sử dụng tùy chọn-s để xác định một giao thức cụ thể muốn thống kê.

VD ```netstat -st``` thống kê giao thức TCP


### Hiển thị service name với PID

```netstat -p```

### Kiểm tra các dịch vụ kết nối đến các port của hệ thống

```nestat -tulnp```

- l: listen - các port của hệ thống đang mở cho phép các kết nối đến
- n: numeric - output trả về các số
- t: tcp - các kết nối dùng giao thức tcp
- u: udp - các kết nối dùng giao thức udp
- p: program - các chương trình đang kết nối đến

### Tìm cổng ứng với một chường trình đang chạy

```netstat  -ap | grep ssh```

```netstat  -ap | grep httpd```

### Tìm chương trình đang chạy trên cổng

```netstat  -an | grep :80```

```netstat  -an | grep :22```



