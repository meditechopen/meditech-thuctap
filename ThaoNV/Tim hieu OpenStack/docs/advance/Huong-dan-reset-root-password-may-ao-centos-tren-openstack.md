# Hướng dẫn reset root password của máy ảo CentOS 7 trên OpenStack

### Bước 1

Tại màn hình của GRUB menu, ấn `e` để chỉnh sửa kernel command-line

<img src="https://github.com/thaonguyenvan/meditech-thuctap/blob/master/ThaoNV/Tim%20hieu%20OpenStack/images/resetpasswdcentos1.png?raw=true">

<img src="https://github.com/thaonguyenvan/meditech-thuctap/blob/master/ThaoNV/Tim%20hieu%20OpenStack/images/resetpasswdcentos2.png?raw=true">

## Bước 2

Tại đây chúng ta thêm **rd.break enforcing=0** . Vì cloud image sẽ redirect console tới ttyS0 (serial console chứ không phải graphical console trên dashboard của OpenStack) nên phải bỏ **console=ttyS0** đi. Lưu ý rằng vẫn phải để lại **console=tty0**

<img src="https://github.com/thaonguyenvan/meditech-thuctap/blob/master/ThaoNV/Tim%20hieu%20OpenStack/images/resetpasswdcentos3.png?raw=true">

Sau khi kết thúc, nhấn `Ctrl + x` để boot.

<img src="https://github.com/thaonguyenvan/meditech-thuctap/blob/master/ThaoNV/Tim%20hieu%20OpenStack/images/resetpasswdcentos4.png?raw=true">

### Bước 3

Root file system sẽ được mount thành dạng read-only dưới /sysroot. Bạn có thể remount nó thành dạng read-write bằng câu lệnh `mount -o remount,rw /sysroot` và chroot nó bằng câu lệnh `chroot /sysroot`. Sau đó bạn có thể tiến hành đổi password cho user root bằng câu lệnh `passwd`

<img src="https://github.com/thaonguyenvan/meditech-thuctap/blob/master/ThaoNV/Tim%20hieu%20OpenStack/images/resetpasswdcentos5.png?raw=true">

### Bước 4

Sau khi đổi password, tiến hành chạy câu lệnh `touch /.autorelabel` để update SELinux, thoát chroot và reboot lại máy ảo.

<img src="https://github.com/thaonguyenvan/meditech-thuctap/blob/master/ThaoNV/Tim%20hieu%20OpenStack/images/resetpasswdcentos6.png?raw=true">

Có một cách khác để thực hiện điều này, đó là sử dụng [Nova rescue mode](https://docs.openstack.org/user-guide/cli-reboot-an-instance.html). Tuy nhiên đây thực chất là việc tạo mới máy ảo sử dụng cùng một image và gán ổ đĩa cũ vào. Nếu có bất cứ vấn đề nào xảy đến thì sẽ rất khó để recovery lại máy ảo.

**Link tham khảo:**

http://www.jpena.net/successfully-resetting-the-root-password-of-a-centos-7-vm-in-openstack/
