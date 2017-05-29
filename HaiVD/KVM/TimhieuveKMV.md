# Tìm hiểu về KMV

# Mục lục
##  [I.Giới thiệu](#gioithieu)
###   [1.1 Định nghĩa](#dinhnghia)
###   [1.2 Lịch sử ](#lichsu)
##  [II.Cấu trúc KVM](#cautruc)
### [2.1 Cấu trúc tổng quan](#tongquan)
### [2.2 Hiệu suất và cải tiến trong cấu trúc](#hieusuat)
### [2.3 Mô hình KVM Stack](#stack)
### [2.4 Mô hình KVM QEMU](#qemu)
##  [III. Cài đặt KVM trên Linux Mint](#caidat)
### [3.1 Cài đặt KVM](#cdkvm)
### [3.2 Hướng dẫn cài đặt máy ảo](#cdmayao)
## [IV. Tìm hiểu vể Virsh Command Line Interfaces](#vcli)
## [V. Hướng dẫn cài đặt Webvirt](#webvirt)
### [5.1 Mô hình](#mohinh)
### [5.2 Cấu hình và cài đặt máy webvirt](#maywebvirt)
### [5.3 Cấu hình và cài đặt máy KVM](#maykvm)
### [VI. Sử dụng Webvirt](#sd)
#### [
## [VII. Các chế độ card mạng KVM](#network)
### [7.1 NAT](#nat)
### [7.2 Public Bridging](#pubbr)
### [7.3 Private Bridging](#prbr)




-----------------------------------------

<a name="gioithieu"></a>
## I.Giới thiệu

<a name="dinhnghia"></a>
### 1.1 Định nghĩa

  - `KVM(Kernel-based Virtual Machine)` : là giải pháp ảo hóa toàn diện trên phần cứng x86 và hỗ trợ hầu hết các hệ điều hành của Linux và Windowws. KVM chuyển đổi một nhân Linux (Linux kernel) thành một bare metal hypervisor và thêm vào đó những đặc trưng riêng của các bộ xử lý Intel như Intel VT-X hay AMD như AMD-V.Nó có thể cài đặt các hệ điều hành khác nhau mà không cần phụ thuộc vào hệ điều hành của máy chủ vật lý.Hơn thế nữa, KVM còn tích hợp các đặc điểm bảo mật của Linux như SELinux hay các cơ chế bảo mật nhiều lớp, điều đó làm cho các máy ảo được bảo vệ tối đa và cách ly hoàn toàn.

  - KVM được phát triển trên nền tảng mã nguồn mở, chính vì thế nó ngày càng lớn mạnh và trở thành một lựa chọn hàng đầu cho doanh nghiệp và hơn thế nữa, nó còn được hỗ trợ từ những nhà sản xuất thiết bị phần cứng, đó là những công nghệ ảo hóa được tích hợp vào bộ vi xử lý như Intel VT-X hay AMD-V để gia tăng đáng kể hiệu suất, tính linh hoạt và khả năng bảo mật.
  - Ngoài ra, do hoạt động trên nền tảng hệ điều hành Linux hay nói đúng hơn là KVM được tải thẳng vào bên trong Linux kernel nên KVM đạt hiệu suất rất cao, cùng một cấu hình, KVM có thể tạo được số lượng máy ảo tương đương nhiều hơn so với VMware.

<a name="lichsu"></a>
### 1.2 Lịch sử
  - KVM ra đời phiên bản đầu tiên vào năm 2007 bởi công ty Qumranet tại Isarel, KVM được tích hợp sẵn vào nhân của hệ điều hành Linux bắt đầu từ phiên bản 2.6.20
  - Năm 2008, RedHat đã mua lại Qumranet và bắt đầu phát triển, phổ biến KVM Hypervisor.

<a name="cautruc"></a>
## II. Cấu trúc KVM

<a name="tongquan"></a>
### 2.1 Cấu trúc tổng quan

  <img src="http://i.imgur.com/8XkZY4C.png">

   - Khi sử dụng KVM, máy ảo sẽ chạy như một tiến trình trên máy chủ Linux.
   - Các CPU ảo (Virtual CPUs) được xử lý như các luồng thông thường,được xử lý theo lập lịch của Linux.
   - Máy ảo được thừa kế các tính năng như NUMA (Non-uniform memory access) và HugePages trong linux.
   - Ổ đĩa, card mạng, thiết bị vào/ra ảnh của máy ảo sẽ ảnh hưởng một phần đến máy chủ vật lý.
   - Lưu lượng mạng thường đường truyền qua card Brige.

<a name="hieusuat"></a>
### 2.2 Hiệu suất và cải tiến :
  - `CPU/Kernel` : được thừa kế rất nhiều từ các nhà sản xuất :
  <ul>
  <li>`NUMA (Non-Uniform Memory Access)`: Truy cập bộ nhớ không đồng dạng NUMA là quá trình song song truy cập kiến trúc máy tính đi đôi với SMP (sysmetric multiprocessing: đa xử lý đối xứng) và MPP (massively parallel processing: xử lý song song “đồ sộ”) trong khả năng của nó để khai thác sức mạnh của hệ thống đa xử lý. </li>
  <li>`CFS (Completely Fair Scheduler)` : là một quá trình lập lịch đã được sáp nhập vào bản phát hành 2.6.23 của hạt nhân Linux và là lịch trình mặc định. Nó xử lý phân bổ nguồn lực CPU để thực hiện các quy trình, và nhằm mục đích tối đa hóa việc sử dụng CPU tổng thể đồng thời tối đa hóa hiệu suất tương tác.</li>
  <li>`RCU (Read Copy Update)` : Giúp xử lý tốt hơn các luồng dữ liệu chia sẻ. </li>
  <li>`Up to 160 VCPUs` : Hỗ trợ tối đa lên đến 160 Virtual CPUs</li>
  </ul>


  - `Memory- Bộ nhớ`
  Hỗ trợ HugePages( giúp quản lý và cải thiện hiệu suất đang kể cho bộ nhớ) và tối ưu hóa cho các môi trường đòi hỏi tiêu tốn bộ nhớ.

  - `Networking - Mạng`:
  <ul>
  <li>`Vhost-net` : chưa tìm hiểu được.</li>
  <li>`SR-IOV`: chưa tìm hiểu được.</li>
  </ul>


  - `Block I/O - Khối vào/ra` :
  <ul>
  <li>AIO (Asynchronous I/O) : Hỗ trợ xử lý các luồng I/O khác nhau hoạt động chồng chéo với nhau.</li>
  <li>MSI  : Ngắt kết nối thiết bị bus bus PCI </li>
  <li>Scatter Gather : Giúp cải tiến I/O để xử lý các bộ nhớ đệm dữ liệu</li>
  </ul>

<a name="stack"></a>
### 2.3 Mô hình KVM Stack

<img src="http://i.imgur.com/DHuQKkm.png">

Trong đó :
- `User-facing tools` : là các công cụ hỗ  trợ quản lý máy ảo.Có thể là Virt-manager (hỗ trợ giao diện) hoặc Virsh(dòng lệnh) hoặc Virt-tools(công cụ quản lý trung tâm dữ liệu).
- `Mgmt layer` : Lớp này là thư viện libvirt cung cấp API để các công cụ quản lý máy ảo hoặc các hypervisor tương tác với KVM thực hiện các thao tác quản lý tài nguyên ảo hóa.
- `Virtual machine` :  Chính là các máy ảo người dùng tạo ra. Thông thường, nếu không sử dụng các công cụ như virsh hay virt-manager thì sử dụng QEMU.
- `Kernel support` : Chính là KVM, cung cấp một module làm hạt nhân cho hạ tầng ảo hóa (kvm.ko) và một module kernel đặc biệt hỗ trợ các vi xử lý VT-x hoặc AMD-V (kvm-intel.ko hoặc kvm-amd.ko).

<a name="qemu"></a>
### 2.4 Mô hình KVM & QEMU
Mô hình :

<img src=http://i.imgur.com/XVHHuxq.jpg>

QEMU có thể tận dụng KVM khi chạy một kiến ​​trúc mục tiêu tương tự như kiến ​​trúc lưu trữ. Chẳng hạn, khi chạy qemu-system-x86 trên một bộ xử lý tương thích x86, bạn có thể tận dụng tăng tốc KVM - mang lại lợi ích cho máy chủ và hệ thống máy ảo của bạn.

<a name="caidat"></a>
## III. Cài đặt KVM trên Linux Mint

<a name="cdkvm"></a>
### 3.1 Cài đặt KVM
- Bước 1 : KVM chỉ làm việc nếu CPU hỗ trợ ảo hóa phần cứng, Intel VT-x hoặc AMD-V. Để xác định CPU có những tính năng này không, thực hiện lệnh sau:

  `egrep -c '(svm|vmx)' /proc/cpuinfo`

  <img src=http://i.imgur.com/4j11OYS.png>

  Giá trị 0 chỉ thị rằng CPU không hỗ trợ ảo hóa phần cứng trong khi giá trị khác 0 chỉ thị có hỗ trợ. Người dùng có thể vẫn phải kích hoạt chức năng hỗ trợ ảo hóa phần cứng trong BIOS của máy kể cả khi câu lệnh này trả về giá trị khác 0.Ở đây giá trị của mình là 4.
- Bước 2 : Sử dụng lệnh sau để cài đặt KVM và các gói phụ   trợ. Virt-Manager là một ứng dụng có giao diện đồ họa dùng để quản lý máy ảo. Ta có thể dùng lệnh kvm trực tiếp nhưng libvirt và Virt-Manager giúp đơn giản hóa các bước hơn.
   Đối với Lucid (10.04) hoặc phiên bản sau :

    `sudo apt-get install qemu-kvm libvirt-bin bridge-utils virt-manager`

   Đối với Karmic (9.10) hoặc phiên bản trước :

    `sudo aptitude install kvm libvirt-bin ubuntu-vm-builder bridge-utils`

    <ul>
    <li>libvirt-bin : cung cấp libvirt mà bạn cần quản lý qemu và kvm bằng libvirt</li>
    <li>ubuntu-vm-builder : Công cụ dưới dạng dòng lệnh giúp quản lý các máy ảo.</li>
    <li>qemu-kvm : Phần phụ trợ cho KVM</li>
    <li>bridge-utils: Cung cấp mạng kết nối bắc cầu từ máy ảo ra internet.</li>
    <li>virt-manager : Virtual Machine Manager</li>
    </ul>

- Bước 3 : Chỉ quản trị viên (root user) và những người dùng thuộc libvirtd group có quyền sử dụng máy ảo KVM. Chạy lệnh sau để thêm tài khoản người dùng vào libvirtd group:

   Đối với Karmic (9.10) và phiên bản sau (nhưng không phải 14.04 LTS)

  `sudo add Username libvirtd`

   Đối với phiên bản phát hành trước Karmic (9.10) :

   `$ groups`

   `$ sudo adduser Username kvm`

   `$ sudo adduser Username libvirtd`



   <img src=http://i.imgur.com/SoHk9rO.png>

- Bước 4 : Sau khi chạy lệnh này, đăng xuất rồi đăng nhập trở lại. Nhập câu lệnh sau sau khi đăng nhập:

  `virsh --connect qemu:///system list`

  Một danh sách máy ảo còn trống xuất hiện. Điều này thể hiện mọi thứ đang hoạt động đúng.

  <img src=http://i.imgur.com/nyYZFgJ.png>


  Như vậy là cài đặt xong.Để cài đặt một hệ điều hành trên KVM chúng ta tiến hành cài đặt nó trên Phần mềm Virtual Machine Manager.

<a name=cdmayao></a>
### 3.2 Hướng dẫn cài đặt máy ảo
  Bài hướng dẫn này mình thực hiện trên Linux Mint 17.3 nên cần phải có đủ tất các gói phụ trợ.

  Đầu tiên kiểm tra xem đã có đầy đủ tất cả các gói phụ trợ hay chưa :
  <img src="http://i.imgur.com/FaRnGB3.png">

   Có tổng cộng tất cả 11 gói :
   - gir1.2-spice-client-glib-2.0
   - gir1.2-spice-client-gtk-2.0
   - gir1.2-spice-client-gtk-3.0
   - libspice-client-glib-2.0-8:amd64
   - libspice-client-gtk-2.0-4:amd64
   - libspice-client-gtk-3.0-4:amd64
   - libspice-server1:amd64
   - python-spice-client-gtk
   - spice-client-glib-usb-acl-helper
   - spice-client-gtk
   - spice-vdagent

Nếu thiếu gói nào thì các bạn hãy cài đặt gói ấy để tránh xảy ra một số lỗi .
Bây giờ chúng ta sẽ tiến hành cài đặt
  - Bước 1 : Mở Virtual Machine Manager lên xuất hiện hộp thoại, Chọn File/ New Virtual Machine xuất hiện hộp thoại  :
  <img src=http://i.imgur.com/QnxOEvn.png>

  - Bước 2 : Trỏ Browse đến file iso hệ điều hành cần cài đặt :
  <img src=http://i.imgur.com/XZjrYsK.png>

  - Bước 3 : Tùy chỉnh thông số máy ảo RAM,CPU :

  <img src=http://i.imgur.com/eW4c5x6.png>

  - Bước 4 : Tùy chọn dung lượn ổ cứng:

  <img src=http://i.imgur.com/zlVlrCa.png>

  - Bước 5 : Đặt tên cho máy ảo và tùy chọn cấu hình, card mạng:
  <img src=http://i.imgur.com/I8lc7bL.png>

  - Bước 6 : Tiến hành cài đặt hệ điều hành như bình thường :
  <img src=http://i.imgur.com/LY4pA7o.png>

  - Sau khi cài đặt xong :

  <img src=http://i.imgur.com/SJfiiE8.png>

   Theo mình cảm nhận so với VMware thì tốc độ xử lý nhanh hơn rất nhiều.

<a name=vcli></a>
## IV. Tìm hiểu về Virsh Command Line Interfaces
  Hiểu một cách đơn giản nhất Virsh CLI là công cụ quản lý KVM bằng giao diện dòng lệnh.

  Các tùy chọn quản lý cơ bản :
  - help :  Hiển thị trợ giúp
  - list :  Hiển thị danh sách các domains
  - creat :   Thiết lập 1 domain từ thư mục XML
  - start :   Khởi động một domain đã hoạt động trước đó.
  - destroy :   Xóa đi một domain
  - define :  Định nghĩa một domain (không phải như start)
  - domid :   chuyển từ dạng domain name hoặc UUID sang domain id
  - domuuid :   chuyển đổi từ domain name hoặc domain id sang UUID
  - domname :   chuyển đổi từ domain id hoặc UUID sang domain name.
  - dominfo : thông tin về domain
  - domstate : trạng thái của domain
  - quit : thoát khỏi Virsh CLI
  - reboot : khởi động lại domain
  - restore : quay lại một trạng thái nào đó của domain
  - resum : tiếp tục hoạt động một domain sau khi tạm ngưng
  - save : lưu trạng thái domain
  - shutdown : tắt domain
  - suppend : tạm ngưng hoạt động domain
  - undefine : Bỏ định nghĩa domain

Các tùy chọn quản lý tài nguyên :
  - setmem : thay đổi cấp phát bộ nhớ
  - setmaxmem : thay đổi dung lượng bộ nhớ tối đa
  - setvcpus : thay đổi số virtual CPUs
  - vcpuinfo : thông tin Virtual CPUs của domain
  - vcpupin : kiểm soát mối liên hệ giữa các vCPUs.

Các tùy chọn giám sát và khắc phục sự cố :
  - version : hiển thị phiên bản
  - dumpxml : thông tin domain trong XML
  - noteinfo : thông tin về note

<a name=webvirt)></a>
## V. Hướng dẫn cài đặt webvirt

<a name=mohinh></a>
### 5.1 Mô hình triển khai

  Chúng ta có thể triển khai Werbvirt theo 3 cách :
  - Mô hình 1 : Triển khai máy KVM và Webvirt trên 1 máy
  - Mô hình 2 : Triển khai máy KVM và Webvirt trên 2 máy khác nhau
  - Mô hình 3 : Triển khai máy Webvirt ngay trên máy ảo của KVM.

  Ở bài này mình sẽ hướng dẫn các bạn cài trên mô hình thứ 2. và là mô hình phổ biến nhất hiện nay.
  Nó giúp các nhà quản trị dễ dàng quản lý các máy ảo một các tập trung, dễ quản lý.

  Mô hình triển khai gồm 2 node :
  - Webvirt Host : Máy cài đặt Webvirt.
  - Host Server : Máy cài đặt KVM .

  <img src=http://i.imgur.com/0DLjkq1.png>

Cả 2 máy đều cài đặt UbuntuServer 14.04 và đều nằm cùng một dải mạng.

<a name=maywebvirt>
### 5.2 Cấu hình và cài đặt máy Webvirt

- Cài đặt các gói cần thiết :

  ```
  sudo apt-get install git python-pip python-libvirt python-libxml2 novnc supervisor nginx
  ```

  <ul>
  <li>Git : Gói cài đặt phần mềm git cho linux</li>
  <li>Python-pip : gói trình quản lý và cài đặt các chương trình python </li>
  <li>Python-libvirt : Gói các chương trình python cài đặt thư viện libvirt</li>
  <li>Python-libxml2 : Gói các chương trình python cài đặt thư viện libxml2</li>
  <li>Novnc : là một chương trình gần giống như remote desktop nhưng sử dụng HTML 5 để quản lý các Client</li>
  <li>Supervisor : là một tiến trình quản lý ,hỗ trợ máy chủ Webvirt quản lý các tiến trình máy ảo</li>
  <li>Nginx : Gói cài đặt HTTP Server hay Revert Proxy hoặc IMAP/POP3 server.Gói này giúp cấu hình phần webserver cho Webvirt.</li>
  </ul>

 - Cài đặt Python và các chương trình cần thiết hỗ trợ cho Django - xây dựng nền tảng web :

 ```
 cd ~/
 git clone git://github.com/retspen/webvirtmgr.git
 cd webvirtmgr
 sudo pip install -r requirements.txt
 ./manage.py syncdb
```
  Tiến hành cài đặt username , email, mật khẩu cho webvirt.

  ```
  You just installed Django's auth system, which means you don't have any superusers defined.
Would you like to create one now? (yes/no): yes (Put: yes)
Username (Leave blank to use 'admin'): admin (Put: your username or login)
E-mail address: username@domain.local (Put: your email)
Password: xxxxxx (Put: your password)
Password (again): xxxxxx (Put: confirm password)
Superuser created successfully.
```
Có thể cài quyền quản trị cao nhất Supper user như sau
```
./manage.py createsuperuser
```
- Cấu hình Nginx :

  Tạo thêm thư mục `/var/www/` : ```sudo mkdir /var/www/```

- Chuyển thư mục Webvirt :

  ```
  sudo mv ~/webvirtmgr /var/www/webvirtmgr

  ```

- Thêm file cấu hình `webvirtmgr.conf` tại `/etc/nginx/config.d/webvirtmgr.conf` và thêm nội dung cho file webvirtmgr.conf :

```
  server {
    listen 80 default_server;
server_name $hostname;
#access_log /var/log/nginx/webvirtmgr_access_log;

location /static/ {
    root /var/www/webvirtmgr/webvirtmgr; # or /srv instead of /var
    expires max;
}

location / {
    proxy_pass http://127.0.0.1:8000;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-for $proxy_add_x_forwarded_for;
    proxy_set_header Host $host:$server_port;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_connect_timeout 600;
    proxy_read_timeout 600;
    proxy_send_timeout 600;
    client_max_body_size 1024M; # Set higher depending on your needs
}

}
```
- Chỉnh sửa file cấu hình Nginx :

  `sudo vi /etc/nginx/sites-enabled/default`

- Chỉnh sửa nội dung file cấu hình Nginx như sau:

```
# You should look at the following URL's in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# http://wiki.nginx.org/Pitfalls
# http://wiki.nginx.org/QuickStart
# http://wiki.nginx.org/Configuration
#
# Generally, you will want to move this file somewhere, and start with a clean
# file but keep this around for reference. Or just disable in sites-enabled.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

# Default server configuration
#
#server {
#	listen 80 default_server;
#	listen [::]:80 default_server;

	# SSL configuration
	#
	# listen 443 ssl default_server;
	# listen [::]:443 ssl default_server;
	#
	# Note: You should disable gzip for SSL traffic.
	# See: https://bugs.debian.org/773332
	#
	# Read up on ssl_ciphers to ensure a secure configuration.
	# See: https://bugs.debian.org/765782
	#
	# Self signed certs generated by the ssl-cert package
	# Don't use them in a production server!
	#
	# include snippets/snakeoil.conf;

#	root /var/www/html;

	# Add index.php to the list if you are using PHP
#	index index.html index.htm index.nginx-debian.html;

#	server_name _;

#	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
#		try_files $uri $uri/ =404;
#	}

	# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
	#
	#location ~ \.php$ {
	#	include snippets/fastcgi-php.conf;
	#
	#	# With php7.0-cgi alone:
	#	fastcgi_pass 127.0.0.1:9000;
	#	# With php7.0-fpm:
	#	fastcgi_pass unix:/run/php/php7.0-fpm.sock;
	#}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	#location ~ /\.ht {
	#	deny all;
	#}
#}


# Virtual Host configuration for example.com
#
# You can move that to a different file under sites-available/ and symlink that
# to sites-enabled/ to enable it.
#
#server {
#	listen 80;
#	listen [::]:80;
#
#	server_name example.com;
#
#	root /var/www/example.com;
#	index index.html;
#
#	location / {
#		try_files $uri $uri/ =404;
#	}
#}

```
- Tiến hành Restart lại Nginx

  `sudo service nginx restart`

- Kích hoạt supervisord khi khởi động:
<ul>
<li>Với Ubuntu 14</li>

```
sudo -i
curl https://gist.github.com/howthebodyworks/176149/raw/88d0d68c4af22a7474ad1d011659ea2d27e35b8d/supervisord.sh > /etc/init.d/supervisord
chmod +x /etc/init.d/supervisord
update-rc.d supervisord defaults
service supervisord stop
service supervisord start

exit

```
<li>Với Ubuntu 16</li>

```
sudo systemctl enable supervisor
sudo systemctl start supervisor

```
</ul>

- Cấu hình Supervisor :
  Cấu hình novnc

```
  sudo -i

  cat << EOF > /etc/insserv/overrides/novnc
#!/bin/sh
### BEGIN INIT INFO
# Provides:          nova-novncproxy
# Required-Start:    $network $local_fs $remote_fs $syslog
# Required-Stop:     $remote_fs
# Default-Start:     
# Default-Stop:      
# Short-Description: Nova NoVNC proxy
# Description:       Nova NoVNC proxy
### END INIT INFO
EOF

service novnc stop
insserv -r novnc

```
  Thay đổi quyền sở hữu :

```
chown -R www-data:www-data /var/www/webvirtmgr
```

  Thêm cấu hình tại : `/etc/supervisor/conf.d/webvirtmgr.conf`

```
cat << EOF > /etc/supervisor/conf.d/webvirtmgr.conf
[program:webvirtmgr]
command=/usr/bin/python /var/www/webvirtmgr/manage.py run_gunicorn -c /var/www/webvirtmgr/conf/gunicorn.conf.py
directory=/var/www/webvirtmgr
autostart=true
autorestart=true
stdout_logfile=/var/log/supervisor/webvirtmgr.log
redirect_stderr=true
user=www-data

[program:webvirtmgr-console]
command=/usr/bin/python /var/www/webvirtmgr/console/webvirtmgr-console
directory=/var/www/webvirtmgr
autostart=true
autorestart=true
stdout_logfile=/var/log/supervisor/webvirtmgr-console.log
redirect_stderr=true
user=www-data
EOF
```

  Khởi động lại Supervisor :

  ```
  sudo service supervisor stop
  sudo service supervisor start
  exit
  ```

<a name=maykvm></a>
### 5.3 Cấu hình và cài đặt máy KVM

- Thực hiện trên máy Server Host (KVM).Trước khi cài đặt KVM lên node này, cần kiểm tra xem bộ xử lý của máy có hỗ trợ ảo hóa không (VT-x hoặc AMD-V). Nếu thực hiện lab trên máy thật cần khởi động lại máy này vào BIOS thiết lập chế độ hỗ trợ ảo hóa. Tuy nhiên bài lab này thực hiện trên VMWare nên trước khi cài đặt cần thiết lập cho máy ảo hỗ trợ ảo hóa như sau:

<img src="http://i.imgur.com/XwwRHUl.png">

- Cài đặt KVM :

```
  sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils

Thêm user của phiên làm việc hiện tại vào libvirtd :

  sudo adduser `id -un` libvirtd
```
- Cấu hình libvirt:

```
sudo -i

cat << EOF > /etc/libvirt/libvirtd.conf
listen_tls = 0
listen_tcp = 1
listen_addr = "0.0.0.0"
unix_sock_group = "libvirtd"
unix_sock_ro_perms = "0777"
unix_sock_rw_perms = "0770"
auth_unix_ro = "none"
auth_unix_rw = "none"
auth_tcp = "none"
EOF

cat << EOF > /etc/default/libvirt-bin
start_libvirtd="yes"
libvirtd_opts="-l -d"
EOF

```
- Khởi động lại libvirt :
```
 service libvirt-bin restart
```
- Kiểm tra cài đặt :

```
ps ax | grep [l]ibvirtd
netstat -pantu | grep libvirtd
virsh -c qemu+tcp://127.0.0.1/system
```

 Nếu thực hiện các câu lệnh trên mà xuất hiện các thông số thì việc cài đặt thành công :

 <img src=http://i.imgur.com/J6o9dgm.png>

 - Bước tiếp theo : cài đặt card mạng KVM : Tham khảo phần 7

 Sau khi đã tiến hành cài đặt card mạng 1 trong 3 cách,chúng ta tiến hành coppy một file iso của một hệ điều hành bất kì vào máy KVM để tiến hành cài đặt (Có thể sử dụng WinSCP trên windows hoặc sử dụng SCP trên Linux):
 - Tại máy KVM , tạo file lưu trữ file iso :

 ```
mkdir -p /var/www/webvirtmgr/images
 ```
 - Tiến hành coppy file iso bất kì vào thư mục trên.

<a name=sd></a>
## VI. Sử dụng Webvirt
- Trên trình duyệt, tiến hành gõ địa chỉ ip của máy chủ cài đặt Webvirt. Giao diện Webvirt hiện ra. Click vào Add Connection để tiến hành tạo một kết nối đến máy KVM :

<img src=http://i.imgur.com/09koSpE.png>

Lưu ý : tài khoản đăng nhập là tài khoản của máy KVM.

- Click vào đường dẫn kvm-154 vừa tạo, Chọn `Storages/New Storage` để tiến hành tạo thư mục ổ đĩa và thư mục chưa file iso cho KVM :

<img src=http://i.imgur.com/F2GCqF1.png>

Lưu trữ file iso :

<img src=http://i.imgur.com/dpPzW7C.png>

Sau khi tạo được 1 mục chứa các phân vùng đĩa và một mục chứa các file iso . Chúng ta tiến hành tạo Network

- Chuyển sang tab Network :

Có thể cài NAT hoặc Brigde hoăc OVS tùy theo cách cấu hình và nhu cầu sử dụng :


<img src=http://i.imgur.com/2emKN6C.png>

hoặc NAT

<img src=http://i.imgur.com/YuPkihG.png>

- Sau khi cài đặt mạng, tiến hành tạo img cho hệ điều hành muốn cài .Vào `Storages/Add Images`:

<img src=http://i.imgur.com/sHMUVgE.png>

- Tiếp theo chúng ta tiến hành cài đặt . Vào `Instances/New Instance/Custom Instance` :

<img src=http://i.imgur.com/nNhlYYl.png>

- Tiến hành add file iso và connect hệ điều hành cho máy vừa tạo :

<img src=http://i.imgur.com/Zz8NP5q.png>

- Chuyển sang tab Start và Console máy vừa tạo

<img src=http://i.imgur.com/pNTb9dI.png>

<img src=http://i.imgur.com/73wo3xT.png>

- noVNC hiện lên, tiến hành cài hệ điều hành như bình thường.

<img src=http://i.imgur.com/ejuIfPp.png>


<a name=network></a>
## VII. Các chế độ card mạng của KVM

<a name=nat></a>
### 7.1 : NAT

  Đây là cấu hình card mạng mặc định của KVM.

  NAT (Network Address Translation) giống như một Router, chuyển tiếp các gói tin giữa những lớp mạng khác nhau trên một mạng lớn. NAT dịch hay thay đổi một hoặc cả hai địa chỉ bên trong một gói tin khi gói tin đó đi qua một Router, hay một số thiết bị khác. Thông thường NAT thường thay đổi địa chỉ thường là địa chỉ riêng (IP Private) của một kết nối mạng thành địa chỉ công cộng (IP Public).

<a name=pbbr></a>
### 7.2: Public Bridging

  Nếu bạn chỉ có một NIC trên máy chủ KVM, trong khi bạn muốn các Guest của mình cũng được truy cập vào cùng dải mạng vật lý thì phải thiết lập một bridge kết nối thông qua cổng eth0 của máy vật lý.

  - Thiết lập 1 card Bridge và gán nó cho eth0:
  ```
  # ip link add br0 type bridge
  # brctl addbr br0
  # brctl addif br0 eth0
  ```

  - Cấu hình /etc/network/interfaces.Comment eth0 và cấu hình cho br0.
  ```
  #auto eth0
  #iface eth0 inet dhcp

  auto br0
  iface br0 inet dhcp
          bridge_ports eth0
          bridge_stp off
          bridge_fd 0
          bridge_maxwait 0
  ```
   Các thông số kèm theo :
  <ul>
  <li>*ports eth0* : gán port brigde cho eth0</li>
  <li>*stp* : giao thức chống lặp gói tin trong mạng</li>
  <li>*fd*  : chuyển tiếp dữ liệu từ máy ảo tới bridge </li>
  <li> *maxwait* :Thời gian chờ lớn nhất nhận cổng </li>
  </ul>

<a name=prbr></a>
### 7.3: Private Bridging

  Các này tạo một card bridge sử dụng một dải ip riêng dùng để giao tiếp với các guest KVM thông qua công eth0 mà không ảnh hưởng tới địa chỉ của KVM host.Chính vì vậy không cần tham số  `bridge_ports` và cũng không cần comment `eth0` :

  ```
  # The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet static
    address 192.168.0.101
    netmask 255.255.255.0
    network 192.168.0.0
    broadcast 192.168.0.255
    gateway 192.168.0.1

# The private bridge
auto br0 inet static
    address 172.16.0.1
    netmask 255.255.255.0
    network 172.16.0.0
    broadcast 172.16.0.255
    bridge_ports none
    bridge_stp off
    bridge_fd 0
    bridge_maxwait 0
  ```

Trên đây là 3 cách cấu hình card mạng.
