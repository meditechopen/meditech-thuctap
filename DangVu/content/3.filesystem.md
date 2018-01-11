# Filesystem
filesystem trong Linux có cấu trúc cây bắt đầu với thư mục `root`, được kí hiệu là  `"/"`
### thư mục root
`/root` : chỉ có `root user` mới có quyền ghi trong thư mục này. chú ý `/root` là thư mục `home` của `root user` chứ không phải là `/.`



<img src="https://i.imgur.com/MfnI94f.png">

### thư mục /bin
`/bin` : chứa các chương trình thực thi. các chương trình chung được sử dụng bởi tất cả mọi người như lệnh như ls, grep, netstat...



<img src="https://i.imgur.com/lZr1nRO.png">

### thư mục /sbin
`/sbin` : chứa các chương trình thực thi như lệnh như Iptable, reboot, ifconfig... ==> các lệnh cho sysadmin
<img src="https://i.imgur.com/3QdA9yq.png">

### thư mục /etc
`/etc` : chứa các file config, chứa các shell script dùng để khởi động hoặc tắt các chương trình khác
<img src="https://i.imgur.com/Qo14KVQ.png">

### thư mục /dev
`/dev` : chứa các file thiết bị của hệ thống như usb, disk, ...

### thư mục /proc
`/proc` : chứa thông tin các process

### thư mục /var
<img src="https://i.imgur.com/fimHXwZ.png">



`/var` : chứa thông tin các biến, log, mail,...
Ví dụ:
system log files: `/var/log`
packages files: `/var/lib`
print queues: `/var/spool`
temp files: `/var/tmp`
ftp home directory: `/var/ftp`
web server directory: `/var/www`

### thư mục /tmp
`/tmp` : chứa các file tạm thời

### thư mục /usr
<img src="https://i.imgur.com/vi8NLCI.png">

`/usr` : chứa các thư viện, file thực thi... trong đó:
`/usr/bin` chứa các file thực thi của người dùng như: at, awk, cc, less... Nếu bạn không tìm thấy chúng trong /bin hãy tìm trong /usr/bin
`/usr/sbin` chứa các file thực thi của hệ thống dưới quyền của admin như: atd, cron, sshd... Nếu bạn không tìm thấy chúng trong /sbin thì hãy tìm trong thư mục này.
`/usr/lib` chứa các thư viện cho các chương trình trong /usr/bin và /usr/sbin
`/usr/local` chứa các chương tình của người dùng được cài từ mã nguồn. Ví dụ như bạn cài apache từ mã nguồn, nó sẽ được lưu dưới /usr/local/apache2
`/usr/include` các header files dùng để biên soạn các ứng dụng
`/usr/share` chứa các dữ liệu được chia sẻ và sử dụng bởi các ứng dụng, thường là các ứng dụng cấu trúc không phụ thuộc
`/usr/src` mã nguồn, thường sử dụng cho Linux kernel
`/usr/local` dữ liệu và chương trình cụ thể cho các máy nội vùng

### thư mục /home
`/home` : thư mục chứa tất cả các file cá nhân của người dùng

### thư mục boot
`boot` : chứa các file yêu cầu khi khởi động như initrd, vmlinux, grub...
Với mọi kernel được cài đặt trên hệ thống sẽ có 4 file quan trọng
`vmlinuz` là nhân linux đã được nén, sử dụng cho việc khởi động
`initramfs` là file hệ thống dữ liệu ram đầu vào, sử dụng cho việc khởi động
`config.is` là file cấu hình nhân, sử dụng để gỡ lỗi
`system.map` chứa các kí hiệu bảng của kernel, sử dụng để gỡ lỗi
mỗi file này có một phiên bản kernel được nối vào tên của nó

### thư mục /lib
`/lib` : chứa các thư viện hỗ trợ các file thực thi trong `/bin` và `/sbin`

### thư mục /opt
`/opt` : chứa các ứng dụng thêm vào từ các nhà cung cấp độc lập khác

### thư mục /mnt
`/mnt` : là thư mục tạm để `mount` các file hệ thống

### thư mục /media
`/media` : chứa các thiết bị như CdRom `/media/cdrom` hay các phân vùng đĩa cứng `/media/Data`

## các định dạng filesystem (ext2, ext3, ext4)
-Mỗi filesystem được lưu trên một phân vùng ổ đĩa (hard disk paritition). các phân vùng lưu dữ liệu
của ổ cứng tùy thuộc vào các dạng dữ liệu và mục đích sử dụng chúng. Ví dụ như một chương trình hệ
thống quan trọng thì phải được lưu trên phân vùng riêng chứ không thể được lưu cùng với phân vùng
các tập tin người dùng bình thường. Vì thế, sử dụng các phân vùng khác nhau để ghi dữ liệu thì nó sẽ
không ảnh hưởng đến tiến trình của hệ thống vì mỗi loại tập tin hệ thống được phân loại và lưu ở một
phân vùng riêng biệt
-Trước khi bạn sử dụng một filesystem, bạn cần liên kết nó tới một điểm của cây tập tin hệ thống gọi là 
`mountpoint`. Nó là một đường dẫn đơn giản (có thể có dữ liệu hoặc đang trống) nơi mà filesystem được
liên kết tới đó. đôi khi bạn cần tạo các thư mục mới nếu nói chưa tồn tại. Nếu bạn mount một filesystem
đến một thư mục chứa dữ liệu thì dữ liệu hiện tại trên thư mục đó sẽ bị đè lên bằng dữ liệu mới và không
thể sử dụng được cho đến khi đường dẫn `mount link` đó được gỡ bỏ. vì vậy mountpoint thường được trỏ đến
thư mục rỗng.
-Lệnh `mount` được sử dụng để liên kết các phân vùng ổ cứng tới một thư mục hệ thống. Ví dụ
`$ mount /dev/sda1 /mnt`
Câu lệnh trên khi thực thi sẽ tạo một liên kết từ phân vùng `sda1` của ổ đĩa cứng tới một mountpoint là thư mục `/mnt`.
Lưu ý khi muốn tạo các `mountpoint` thì chỉ có `root user` mới có quyền được tạo. Nếu bạn muốn tiến trình đó
tự động chạy khi khợi động hệ thống thì sửa file `/etc/fstab` - file cấu hình các filesystem
-Lệnh `unmount` dùng để xóa bỏ liên kết giữa `filesystem` và `mountpoint`
`$ unmount /mnt`

## Các lệnh xác định filesystem
1.Lệnh `df` để xem dung lượng đang sử dụng các phân vùng ổ cứng, loại filesystem, disk... với một số tùy chọn
cơ bản
<img src="https://i.imgur.com/E7lcRkw.png">

2.Lệnh `fsck` được sử dụng để sữa các lỗi về filesystem linux. ví dụ như khi phát hiện lỗi sai thông tin metadata.
bên cạnh đó lệnh còn hiển thị loại filesystem của các phân vùng ổ cứng cụ thể
<img src="https://i.imgur.com/N2sCTYF.png">

