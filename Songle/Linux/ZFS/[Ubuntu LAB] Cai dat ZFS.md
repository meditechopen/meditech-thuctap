## Thực hành cài đặt ZFS trên Ubuntu

### 1. Yêu cầu :

- Định dạng filesystem : ext4
- Ubuntu phiên bản 64-bit

**Mô hình** :

	- 4 ổ đĩa
	- Ubuntu 16.0.4 server LTS 64-bit

### 2. Cài đặt :

#### 2.1 Cài đặt ZFS cơ bản với định dạng RAID 0:


- Bắt đầu cài zfs bằng lệnh :

`
$ sudo apt install zfs -y
`

- Sau khi cài xong, kiểm tra xem kernel đã được tải vào và khởi chạy chưa bằng lệnh  `dmesg | grep ZFS`

```
[  216.925716] ZFS: Loaded module v0.6.5.6-0ubuntu16, ZFS pool version 5000, ZFS filesystem version 5

```

- Kiểm tra các ổ đĩa trên hệ thống bằng lệnh : `fdisk -l | grep /dev/`

```
root@ubuntu:~# fdisk -l | grep /dev/
Disk /dev/sda: 20 GiB, 21474836480 bytes, 41943040 sectors
/dev/sda1  *        2048 37750783 37748736  18G 83 Linux
/dev/sda2       37752830 41940991  4188162   2G  5 Extended
/dev/sda5       37752832 41940991  4188160   2G 82 Linux swap / Solaris
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk /dev/sdc: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk /dev/sdd: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk /dev/sde: 20 GiB, 21474836480 bytes, 41943040 sectors

```

- Tạo zpool với các ổ đĩa : sdb, sdc, sdd, sde :

`
$ sudo zpool create -f  ZFS-demo /dev/sdb /dev/sdc /dev/sdd /dev/sde
`

+ Tùy chọn " -f " sẽ ghi đè lên bất cứ lỗi nào xuất hiện như trên đĩa đã có dữ liệu ..
+ ZFS-demo là tên của pool

- Sau khi đã tạo xong pool, kiểm tra nó bằng lệnh `df` hoặc `sudo zfs list` :


```
$ df -h /ZFS-demo

Filesystem      Size  Used Avail Use% Mounted on

ZFS-demo         78G     0   78G   0% /ZFS-demo
```

+ Như bạn có thể thấy, ZFS-demo đã được tự động mount vào thư mục /ZFS-demo và sẵn sàng để sử dụng.

- Nếu bạn muốn xem những ổ đĩa nào đang được sử dụng trong pool , dùng lệnh ` sudo zpool status` :

![Imgur](https://i.imgur.com/r2z9fWC.png)

- Chúng ta vừa tạo một pool gồm 4 ổ đĩa cứng với dung lượng là 78G theo hình thức striped pool. 
Trong ZFS, mặc định khi tạo pool , hình thức đọc/ghi dữ liệu sẽ là **stripe** ( khác với LVM là linear ) . 

+ Stripe có nghĩa là mọi dữ liệu đọc/ghi vào mountpoint đều dựa diễn ra đồng thời ở tất cả các ổ
cứng trong pool. Ví dụ ta tạo 1 file 3KB trên /ZFS-demo , 1 kb sẽ lưu trên sdb, 1 kb trên sdc, 1 kb trên sde.
Tốc độ đọc/ghi sẽ nhanh gấp 3 lần với hình thức Linear. 

#### 2.2 Tạo RAID-Z 

- Ở mô hình trên sử dụng RAID 0, khi một ổ trong 3 bị hỏng dữ liệu sẽ bị mất đi tính toàn vẹn và có thể sẽ không sử dụng
được nữa. Để khắc phục điều này, ta có một cơ chế khác : **RAID-Z pool** .

+ Đầu tiên, xóa bỏ zpool mới tạo là ZFS-demo :

*Đảm bảo rằng bạn không ở trong thư mục mountpoint và không có tiến trình nào đang sử dụng trong pool.*

`$ sudo zpool destroy ZFS-demo`

+  Sử dụng 3 ổ đĩa để tạo một RAID-Z pool .

`$ sudo zpool create -f ZFS-demo raidz /dev/sdb /dev/sdc /dev/sdd`

+ Sử dụng lệnh `df -h /ZFS-demo` để kiểm tra, kết quả như sau :

```
root@ubuntu:~# df -h /ZFS-demo
Filesystem      Size  Used Avail Use% Mounted on
ZFS-demo         39G     0   39G   0% /ZFS-demo
```
Như vậy, `df -h` chỉ ra rằng 78G ban đầu của Pool đã giảm xuống chỉ còn 39G , 37G sẽ được sử dụng để lưu giữ
các thông tin dự phòng ( parity information ).

`zpool status` cho ta thấy đã chuyển sang hình thức RAID-Z :

![Imgur](https://i.imgur.com/VcNrLp8.png)

- Việc thêm bộ nhớ vào ZFS pool rất dễ dàng : 

![Imgur](https://i.imgur.com/O0cQ3Ky.png)


### <a name="dr"> 3. Khôi phục dữ liệu từ zpool:
	
- Mô hình : 2 x 2 Mirror zpool ( RAID Z )

```
$ sudo zpool create mypool mirror /dev/sdc /dev/sdd mirror /dev/sde /dev/sdf -f
$ sudo zpool status
  pool: mypool
 state: ONLINE
  scan: none requested
config:

        NAME        STATE     READ WRITE CKSUM
        mypool      ONLINE       0     0     0
          mirror-0  ONLINE       0     0     0
            sdc     ONLINE       0     0     0
            sdd     ONLINE       0     0     0
          mirror-1  ONLINE       0     0     0
            sde     ONLINE       0     0     0
            sdf     ONLINE       0     0     0
```

- Tính toán dung lượng pool với một số dữ liệu và check sum dữ liệu :

```
$ dd if=/dev/urandom of=/mypool/random.dat bs=1M count=4096
$ md5sum /mypool/random.dat
f0ca5a6e2718b8c98c2e0fdabd83d943  /mypool/random.dat
```
- Mô phỏng việc mất dữ liệu bằng cách ghi đè lên một trong những thiết bị VDEV bằng 0 :

`$ sudo dd if=/dev/zero of=/dev/sde bs=1M count=8192`

- Kiểm tra tính toàn vẹn :

` $ sudo zpool scrub mypool`

- Kiểm tra trạng thái pool:

```
$ sudo zpool status
  pool: mypool
 state: ONLINE
status: One or more devices has experienced an unrecoverable error.  An
        attempt was made to correct the error.  Applications are unaffected.
action: Determine if the device needs to be replaced, and clear the errors
        using 'zpool clear' or replace the device with 'zpool replace'.
   see: http://zfsonlinux.org/msg/ZFS-8000-9P
  scan: scrub in progress since Tue May 12 17:34:53 2015
    244M scanned out of 1.91G at 61.0M/s, 0h0m to go
    115M repaired, 12.46% done
config:

        NAME        STATE     READ WRITE CKSUM
        mypool      ONLINE       0     0     0
          mirror-0  ONLINE       0     0     0
            sdc     ONLINE       0     0     0
            sdd     ONLINE       0     0     0
          mirror-1  ONLINE       0     0     0
            sde     ONLINE       0     0   948  (repairing)
            sdf     ONLINE       0     0     0
```

- Xóa thiết bị đó ra khỏi pool :

` $ sudo zpool detach mypool /dev/sde`

- Cắm nóng một thiết bị mới vào vị trí vừa xóa :

` $ sudo zpool attach mypool /dev/sdf /dev/sde  -f`

- Sử dụng scrub để khôi sửa chữa lại hệ thống 2x2 mirror :

`$ sudo zpool scrub mypool`
