# Mục lục

## [I.Stress](#stress)
## [II.Stress-ng](#stressng)


<a name=stress></a>
## Làm thế nào để áp dụng CPU Load và Stress Test trên Linux sử dụng công cụ 'Stress-ng'

Với tư cách là Quản trị viên hệ thống, bạn có thể muốn kiểm tra và giám sát tình trạng của các hệ thống Linux khi chúng đang quá tải. Đây có thể là một cách hay để các Quản trị viên Hệ thống và Lập trình:
- Điều chỉnh các hoạt động trên một hệ thống.
- Giám sát các giao diện hạt nhân hệ điều hành.
- Kiểm tra các phần cứng trên Linux như CPU, bộ nhớ, đĩa và nhiều thứ khác để quan sát hiệu suất của chúng trong điều kiện căng thẳng.
- Đo điện năng tiêu thụ khác nhau trên cùng hệ thống tải.

Trong hướng dẫn này, chúng ta sẽ xem xét hai công cụ quan trọng, Stress và Stress-ng để kiểm tra các quá tải trong các hệ thống Linux của bạn.

1. Stress : Là một công cụ tạo lượng làm việc được thiết kế để đo được CPU,bô nhớ , I/O và sự quá tải của đĩa trong hệ thống của bạn.
2. Stress-ng : là phiên bản cập nhật của Stress giúp đo được các thông tin sau :
- Tính toán CPU
- Thiết bị cân bằng
- Đồng bộ I/O
- Luồng I/O
- Tràn bộ đệm
- Cân bằng VM
- Câng bằng kết nối
- Tiến trình tạo và kết thúc
- Chuyển đổi tính chất các trường hợp

Mặc dù công cụ này là tốt cho việc kiểm tra hệ thống nhưng họ không nên sử dụng chúng bởi bất kì người dùng hệ thống nào.

Quan trọng : Chúng tôi khuyên bạn nên sử dụng công cụ này với quyền root, vì nó có thể cân bằng thiết bị Linux của bạn nhanh hơn và tránh được các lỗi thiết kế kém trên phần cứng.

## Làm thế nào để cài đặt công cụ Stress trên Linux :

```
$ sudo apt-get install stress
```


<img src=http://i.imgur.com/FeNVrDx.gif>

Để cài đặt Stress trên RHEL/CentOS và Fedora Linux, bạn cần bật kho  EPEL và sau đó gõ lệnh yum sau đây để cài đặt :

```
# yum install stress
```

Cấu trúc chung để sử dụng Stress là :

```
# yum install stress
```

Câu lệnh chung dùng cho Stress là :

```
$ sudo stress option argument
```

Một số tùy chọn bạn có thể dùng cho stress :
- Để tạo N việc lặp lại trong hàm sqrt(), sử dụng tùy chọn -cpu N và theo dõi .
- Để tạo N việc lặp lại trong hàm sync(), sử dụng tùy chọn -io N và theo dõi.
- Để tạo N việc lặp lại trong hàm malloc()/free(), sử dụng tùy chọn -vm N
- Để cấp phát bộ nhớ cho mỗi vm, sử dụng -vm-bytes N
- Thay vì giải phóng và phân bổ lại tài nguyên bộ nhớ, bạn có thể làm lại bộ nhớ bằng cách sử dụng tùy chọn -vm-keep.
- Đặt thời gian ngủ là N giây trước khi giải phóng bộ nhớ bằng cách sử dụng tùy chọn -vm-hang N
- Để tạo ra N việc lặp lại trong hàm write()/unlink(),sử dụng -hdd N.
- Bạn có thể thiết lập timeout sau khi N việc đang được dùng, sử dụng -timeout N.
- Thiết lập hệ số đợi của N theo micro giây trước khi các việc bắt đầu, sử dụng -backoff N và theo dõi.
- Để hiển thị nhiều thông tin tùy chọn hơn khi sử dụng stress, sử dụng tùy chọn -v.
Sử dụng tùy chọn help để xem trang quản lý.

## Làm thế nào để sử dụng Stress trên hệ điều hành Linux ?

1. Để kiểm tra hiệu lực của mỗi thời gian câu lệnh chạy, đầu tiên chạy câu lệnh `uptime` và chú ý mức trung bình tải.

Tiếp theo  sử dụng stress để tạo ra 8 việc lặp lại trong sqrt() cùng với timeout là 20 giây.Sau đó chạy stress , chạy lại câu lệnh uptime và so sánh trung bình tải.

```
hai@haikma ~ $ uptime
hai@haikma ~ $ sudo stress --cpu  8 --timeout 20
hai@haikma ~ $ uptime
```

Ví dụ đầu ra :

```
hai@haikma ~ $ uptime    
17:20:00 up  7:51,  2 users,  load average: 1.91, 2.16, 1.93     [<-- Watch Load Average]
hai@haikma ~ $ sudo stress --cpu 8 --timeout 20
stress: info: [17246] dispatching hogs: 8 cpu, 0 io, 0 vm, 0 hdd
stress: info: [17246] successful run completed in 21s
hai@haikma ~ $ uptime
17:20:24 up  7:51,  2 users,  load average: 5.14, 2.88, 2.17     [<-- Watch Load Average]
```

2. Thúc đẩy 8 việc lặp lại trong hàm sqrt() với gian gian chờ 30s, hiển thị thông tin chi tiết về hoạt động, chạy câu lệnh này  :

```
hai@haikma ~ $ uptime
17:27:25 up  7:58,  2 users,  load average: 1.40, 1.90, 1.98     [<-- Watch Load Average]
hai@haikma ~ $ sudo stress --cpu 8 -v --timeout 30s
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
3. Thúc đẩy 1 việc của hàm malloc() và free() cùng với thời gian chờ là 60s, chạy lệnh sau :

```
hai@haikma ~ $ uptime
hai@haikma ~ $ sudo stress --vm 1 --timeout 60s
hai@haikma ~ $ uptime
```

Ví dụ đầu ra

```
hai@haikma ~ $ uptime
17:34:07 up  8:05,  2 users,  load average: 1.54, 2.04, 2.11     [<-- Watch Load Average]
hai@haikma ~ $ sudo stress --vm 1 --timeout 60s
stress: info: [17420] dispatching hogs: 0 cpu, 0 io, 1 vm, 0 hdd
stress: info: [17420] successful run completed in 60s
hai@haikma ~ $ uptime
17:35:20 up  8:06,  2 users,  load average: 2.45, 2.24, 2.17     [<-- Watch Load Average]
```

4. Thúc đẩy 4 việc lặp lại trên sqrt(), 2 việc lặp lại trên sync(),2 việc trên malloc()/free() cùng với thơi gian chờ là 20s và phân bổ bộ nhớ 256MB mỗi việc, chạy lệnh dưới đây

```
hai@haikma ~ $ uptime
hai@haikma ~ $ sudo stress --cpu 4 --io 3 --vm 2 --vm-bytes 256M --timeout 20s
hai@haikma ~ $ uptime
```

<a name=stressng></a>
# Làm thế nào để cài đặt công cụ 'stress-ng' trên Linux

Để cài đặt stress-ng sử dụng câu lệnh :

```
$ sudo apt-get install stress-ng             [on Debian based systems]
# yum install stress-ng                      [on RedHat based systems]
```

<img src=http://i.imgur.com/nlbi18r.gif>

Cú pháp chung để sử dụng stress-ng là :

```
$ sudo stress-ng option argument
```

Một số tùy chọn bạn có thể dùng cùng với stress-ng :

- Để bắt đầu N trường hợp của mỗi kiểm tra stress, sử dụng -all N
- Để bắt đầu quá trình N để thực hiện CPU bằng cách làm việc tuần tự qua tất cả các phương pháp kiểm tra stress khác nhau của CPU, hãy sử dụng tùy chọn -cpu N.
- Để sử dụng một phương pháp kiểm tra stress cho CPU, hãy sử dụng phương pháp -cpu-method. Có rất nhiều phương pháp có sẵn mà bạn có thể sử dụng, để xem các manpage để xem tất cả các phương pháp để sử dụng.
- Để ngăn chặn quá trình stress của CPU sau khi hoạt động N bogo, sử dụng tùy chọn -cpu-ops N.
- Để bắt đầu N I / O quá trình thử nghiệm stress, sử dụng tùy chọn -io N.
- Để ngăn chặn quá trình stress io sau khi hoạt động N bogo, sử dụng tùy chọn -io-ops N.
- Để bắt đầu quá trình kiểm tra stress Nvm, hãy sử dụng tùy chọn -vm N.
- Để xác định số lượng bộ nhớ trên mỗi quá trình vm, hãy sử dụng tùy chọn -vm-bytes N.
- Để ngăn chặn các quá trình stress vm sau các thao tác N bogo, hãy sử dụng tùy chọn -vm-ops N.
- Sử dụng tuỳ chọn -dd N để bắt đầu quá trình thực hiện các luyện tập trên đĩa cứng.
- Để dừng quá trình stress hdd  sau khi hoạt động N bogo, hãy sử dụng tùy chọn -hdd-ops N.
- Bạn có thể đặt thời gian chờ sau N giây bằng cách sử dụng tùy chọn timeout N.
- Để tạo ra một báo cáo tóm tắt sau khi hoạt động bogo, bạn có thể sử dụng -metrics hoặc -metrics-brief tùy chọn.
- Bạn cũng có thể bắt đầu các tiến trình N sẽ tạo và xóa các thư mục sử dụng mkdir và rmdir bằng cách sử dụng tùy chọn -dir N.
- Để dừng quá trình hoạt động của thư mục sử dụng tùy chọn -dir-ops N.
- Bạn có thể dừng các thao tác chmod bằng tùy chọn -chmod-ops N.
- Bạn có thể sử dụng tùy chọn -v để hiển thị thêm thông tin về các hoạt động đang diễn ra.
- Sử dụng -h để xem trợ giúp cho stress-ng.

Làm thế nào để sử dụng `stress-ng` trong hệ thống Linux ?

1. Để chạy 8 stressor CPU cùng với thời gian chờ là 60s và tóm tắt các hoạt động khi kết thúc.

```
hai@haikma:~$ uptime
hai@haikma:~$ sudo stress-ng --cpu 8 --timeout 60 --metrics-brief
hai@haikma:~$ uptime
```

Ví dụ đầu ra :

```
hai@haikma:~$ uptime
18:15:29 up 12 min,  1 user,  load average: 0.00, 0.01, 0.03     [<-- Watch Load Average]
hai@haikma:~$ sudo stress-ng --cpu 8 --timeout 60 --metrics-brief
stress-ng: info: [1247] dispatching hogs: 8 cpu
stress-ng: info: [1247] successful run completed in 60.42s
stress-ng: info: [1247] stressor      bogo ops real time  usr time  sys time   bogo ops/s   bogo ops/s
stress-ng: info: [1247]                          (secs)    (secs)    (secs)   (real time) (usr+sys time)
stress-ng: info: [1247] cpu              11835     60.32     59.75      0.05       196.20       197.91
hai@haikma:~$ uptime
18:16:47 up 13 min,  1 user,  load average: 4.75, 1.47, 0.54     [<-- Watch Load Average]
```

2. Để chạy 4 FFT stressor CPU  với một thời gian chờ 2 phút.

```
hai@haikma:~$ uptime
hai@haikma:~$ sudo stress-ng --cpu 4 --cpu-method fft --timeout 2m
hai@haikma:~$ uptime
```

Ví dụ mẫu :

```
hai@haikma:~$ uptime
18:25:26 up 22 min,  1 user,  load average: 0.00, 0.26, 0.31     [<-- Watch Load Average]
hai@haikma:~$ sudo stress-ng --cpu 4 --cpu-method fft --timeout 2m
stress-ng: info: [1281] dispatching hogs: 4 cpu
stress-ng: info: [1281] successful run completed in 120.01s
hai@haikma:~$ uptime
18:27:31 up 24 min,  1 user,  load average: 3.21, 1.49, 0.76     [<-- Watch Load Average]

```

3. Để chạy 5 stressor hdd  và dừng lại sau khi 100000 bogo hoạt động, chạy lệnh này.

```
hai@haikma:~$ uptime
hai@haikma:~$ sudo stress-ng --hdd 5 --hdd-ops 100000
hai@haikma:~$ uptime
```

Ví dụ mẫu đầu ra :

```
hai@haikma:~$ uptime
18:29:32 up 26 min,  1 user,  load average: 0.43, 1.00, 0.67     [<-- Watch Load Average]
hai@haikma:~$ sudo stress-ng --hdd 5 --hdd-ops 100000
stress-ng: info: [1290] defaulting to a 86400 second run per stressor
stress-ng: info: [1290] dispatching hogs: 5 hdd
stress-ng: info: [1290] successful run completed in 136.16s
hai@haikma:~$ uptime
18:31:56 up 29 min,  1 user,  load average: 4.24, 2.49, 1.28     [<-- Watch Load Average]

```

4. Để chạy 8 stress CPU, 4 stress I/O và 1 bộ cảm biến bộ nhớ ảo sử dụng 1GB bộ nhớ ảo trong một phút, hãy chạy lệnh dưới đây.

```
hai@haikma:~$ uptime
hai@haikma:~$ sudo stress-ng --cpu 4 --io 4 --vm 1 --vm-bytes 1G --timeout 60s --metrics-brief
hai@haikma:~$ uptime
```

Ví dụ mẫu đầu ra :

```
hai@haikma:~$ uptime
18:34:18 up 31 min,  1 user,  load average: 0.41, 1.56, 1.10     [<-- Watch Load Average]
hai@haikma:~$ sudo stress-ng --cpu 4 --io 4 --vm 1 --vm-bytes 1G --timeout 60s --metrics-brief
stress-ng: info: [1304] dispatching hogs: 4 cpu, 4 iosync, 1 vm
stress-ng: info: [1304] successful run completed in 60.12s
stress-ng: info: [1304] stressor      bogo ops real time  usr time  sys time   bogo ops/s   bogo ops/s
stress-ng: info: [1304]                          (secs)    (secs)    (secs)   (real time) (usr+sys time)
stress-ng: info: [1304] cpu               1501     60.07      2.67     10.39        24.99       114.93
stress-ng: info: [1304] iosync          381463     60.01      0.00     12.90      6357.10     29570.78
hai@haikma:~$ uptime
18:35:36 up 32 min,  1 user,  load average: 4.66, 2.80, 1.59     [<-- Watch Load Average]
```
