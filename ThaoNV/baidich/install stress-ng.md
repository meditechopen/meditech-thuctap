# Cách cài đặt High CPU Load and Stress Test trên Linux sử dụng ‘Stress-ng’

Với tư cách là một người quản trị hệ thống, bạn có thể sẽ muốn kiểm tra và giám sát tình trạng của hệ thống Linux trong trường hợp mức tải của CPU vượt ra ngoài những cách thức sử dụng bình thường. Điều này sẽ giúp nhân viên quản trị hệ thống và lập trình:

- Điều chỉnh các hoạt động trên hệ thống
- Giám sát các interface của kernel
- Kiểm thử các thành phần phần cứng của Linux như CPU, RAM, ổ đĩa, ... để xem phản ứng của chúng khi ở những điểm cao bất thường
- Đo điện năng tiêu thụ khác nhau tải trên một hệ thống.

Ở bài này, chúng ta sẽ sử dụng 2 công cụ là `stress` và `stress-ng` để kiểm tra hệ thống Linux:

1. **stress** : Là công cụ tạo ra một khối lượng công việc để người dùng kiểm tra mức độ hoạt động dưới áp lực nhất định của CPU, RAM, và ổ đĩa.
2. **stress-ng** : Là phiên bản cập nhật, nó có thể test được:

- CPU compute
- drive stress
- I/O syncs
- Pipe I/O
- cache thrashing
- VM stress
- socket stressing
- process creation and termination
- context switching properties

Dù những công cụ này rất hữu ích cho việc kiểm tra hệ thống, tuy nhiên nó không nên được sử dụng bởi bất cứ một user hệ thống nào. Tốt hơn hết hãy chỉ cho phép user `root` được dùng để tránh việc hệ thống bị quá tải.

### Hướng dẫn cài đặt công cụ `stress` trên Linux

- Hướng dẫn này sử dụng hệ điều hành Ubuntu Server
- Để tiến hành cài đặt, chạy câu lệnh sau:

`$ sudo apt-get install stress`

Lưu ý để cài đặt trên các máy chủ sử dụng HĐH RHEL/CentOS hoặc Fedora, bạn cần kích hoạt EPEL Repository lên trước. Xem hướng dẫn tại [đây](https://www.tecmint.com/how-to-enable-epel-repository-for-rhel-centos-6-5/)

**Câu lệnh chung của stress là:**

`$ sudo stress option argument`

Sau đây là một số các options có thể dùng với stress:

- Để tạo ra N công việc cho hàm sqrt(), dùng `-cpu N`.
- Để tạo ra N công việc cho hàm sync(), dùng `-io N`.
- Để tạo ra N công việc cho hàm malloc()/free(), dùng `-vm N`.
- Để phân bổ bộ nhớ cho mỗi công việc, dùng `–vm-bytes N`
- Thay vì giải phóng và phân bổ lại tài nguyên bộ nhớ, bạn có thể làm lại bộ nhớ bằng cách sử dụng tùy chọn `-vm-keep`.
- Để đặt thời gian sleep là N giây trước khi giải phóng bộ nhớ, dùng `–vm-hang N`
- Để tạo ra N công việc cho hàm write()/unlink(), dùng `–hdd N`.
- Bạn có thể đặt thời gian chờ sau N giây bằng cách sử dụng tùy chọn `timeout N`.
- Để đặt khoảng thời gian đợi trước khi bắt đầu công việc theo microseconds, dùng  `–backoff N`.
- Để hiển thị thêm thông tin chi tiết khi chạy stress, hãy sử dụng tùy chọn -v.
- Sử dụng `-help` để xem trợ giúp sử dụng công cụ này.

### Sử dụng stress trên hệ thống Linux

1. Để kiểm tra tác động của câu lệnh, đầu tiên hãy sử dụng `upload` để xem mức độ tải trung bình của máy chủ bạn đang dùng. Sau đó tiến hành chạy câu lệnh của stress để tạo ra 8 lượng công việc cho hàm sqrt() trong 20 giây. Cuối cùng sử dụng lại `uptime` và so sánh:

``` sh
tecmint@tecmint ~ $ uptime
tecmint@tecmint ~ $ sudo stress --cpu  8 --timeout 20
tecmint@tecmint ~ $ uptime
```

Ví dụ mẫu:

``` sh
tecmint@tecmint ~ $ uptime    
17:20:00 up  7:51,  2 users,  load average: 1.91, 2.16, 1.93     [<-- Watch Load Average]
tecmint@tecmint ~ $ sudo stress --cpu 8 --timeout 20
stress: info: [17246] dispatching hogs: 8 cpu, 0 io, 0 vm, 0 hdd
stress: info: [17246] successful run completed in 21s
tecmint@tecmint ~ $ uptime
17:20:24 up  7:51,  2 users,  load average: 5.14, 2.88, 2.17     [<-- Watch Load Average]
```

2. Để hiển thị thêm thông tin chi tiết, sử dụng them tùy chọn `-v`:

``` sh
tecmint@tecmint ~ $ uptime
17:27:25 up  7:58,  2 users,  load average: 1.40, 1.90, 1.98     [<-- Watch Load Average]
tecmint@tecmint ~ $ sudo stress --cpu 8 -v --timeout 30s
stress: info: [17353] dispatching hogs: 8 cpu, 0 io, 0 vm, 0 hdd
stress: dbug: [17353] using backoff sleep of 24000us
stress: dbug: [17353] setting timeout to 30s
stress: dbug: [17353] --> hogcpu worker 8 [17354] forked
stress: dbug: [17353] using backoff sleep of 21000us
stress: dbug: [17353] setting timeout to 30s
stress: dbug: [17353] --> hogcpu worker 7 [17355] forked
stress: dbug: [17353] using backoff sleep of 18000us
stress: dbug: [17353] setting timeout to 30s
stress: dbug: [17353] --> hogcpu worker 6 [17356] forked
stress: dbug: [17353] using backoff sleep of 15000us
stress: dbug: [17353] setting timeout to 30s
stress: dbug: [17353] --> hogcpu worker 5 [17357] forked
stress: dbug: [17353] using backoff sleep of 12000us
stress: dbug: [17353] setting timeout to 30s
stress: dbug: [17353] --> hogcpu worker 4 [17358] forked
stress: dbug: [17353] using backoff sleep of 9000us
stress: dbug: [17353] setting timeout to 30s
stress: dbug: [17353] --> hogcpu worker 3 [17359] forked
stress: dbug: [17353] using backoff sleep of 6000us
stress: dbug: [17353] setting timeout to 30s
stress: dbug: [17353] --> hogcpu worker 2 [17360] forked
stress: dbug: [17353] using backoff sleep of 3000us
stress: dbug: [17353] setting timeout to 30s
stress: dbug: [17353] --> hogcpu worker 1 [17361] forked
stress: dbug: [17353] tecmint@tecmint ~ $ uptime
17:27:59 up  7:59,  2 users,  load average: 5.41, 2.82, 2.28     [<-- Watch Load Average]
```

