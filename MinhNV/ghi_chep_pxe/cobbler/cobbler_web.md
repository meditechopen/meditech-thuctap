# Sử dụng web interface của cobbler cài đặt hệ điều hành 

Trước hết bạn cần cài đặt cobbler server. Tham khảo cách cài đặt <a href="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/ghi_chep_pxe/cobbler/install_cobbler_on_centos7.md">Cobbler</a>

### Bước 1: Truy cập vào cobbler-web

``https://<ip_server>/cobbler_web``

Đăng nhập tài khoản của bạn

### Bước 2: import file iso

<img src="https://i.imgur.com/JUrYbTp.png">

Trong phần khai báo :

- Pxefix: Tên của thư mục 
- Arch: 
- Breed: Khai báo distro rehat, ubuntu, deban...
- Path: Đường dẫn tới thư mục mình đã mount file iso 

### Bước 3: Kiểm tra lại distro và profile

- Trong tab distro: 

<img src="https://i.imgur.com/WWAPVWL.png">

Ta có thể click vào để xem, chỉnh sửa đường dẫn tới file kernel image, kickstart hoặc xóa distro

<img src="https://i.imgur.com/NlGfbMf.png">

- Trong tab profile:

<img src="https://i.imgur.com/T7CCuAa.png">

Ta cũng có thể xem, chỉnh sửa, xóa 

<img src="https://i.imgur.com/DX9gOdt.png">

Mặc định ban đầu file kickstart sẽ là default. Ta sẽ tùy chỉnh chọn đến file kickstart do mình tạo.

### Bước 4: Tạo file kickstart 

- Trong tab kickstart template :

<img src="https://i.imgur.com/PfodNWV.png">

Ta có thể thêm mới một file kickstart hoặc chỉnh sửa file kickstart sẵn có mà mình đã tạo ra.

### Bước 5: Tiến hành cài đặt hệ điều hành


# Một số option trong CLI sử dụng với cobbler

## Distro 

### Add/Edit Options

Ví dụ : ``cobbler distro add --name=string --kernel=path --initrd=path [options]``

- `` --name``:  Một chuỗi nhận diện bản phân phối của hệ điều hành ví dụ như "centos" 
- ``--kernel``: Đường dẫn tới kernel imgage 
- ``--initrd``: Đường dẫn tới initrd imgage 
- ``--boot-files``: Tùy chọn này được sử dụng để chỉ định các tệp bổ sung cần sao chép vào thư mục TFTP cho distro để chúng có thể được tìm nạp trong các giai đoạn đầu của quá trình cài đặt 
- ``--breed``: Khai báo tên distro mặc định rehat bao gồm fedora và centos
- ``--clobber``: 	Tùy chọn này cho phép "thêm" để ghi đè lên một distro hiện có cùng tên
- ``--fetchable-files``: Tùy chọn này được sử dụng để chỉ định một danh sách các tệp tin có thể tìm nạp thông qua máy chủ TFTP


## Profile 

### Add/Edit Options

Ví dụ: ``cobbler profile edit --name=CentOS7-x86_64 --kickstart=/var/lib/cobbler/kickstarts/CentOS7.ks``

Trong đó: 

- ``--name``: Tên mô tả được tạo ra sau khi import file iso
- ``--distro``: Tên của bản distro đã được định nghĩa từ trước 
- ``--boot-files``: Tùy chọn này được sử dụng để chỉ định các tệp bổ sung cần được sao chép vào thư mục TFTP cho distro để chúng có thể được tìm nạp trong các giai đoạn đầu của quá trình cài đặt.
- ``--clobber``: Options này cho phép thêm để ghi đèn lên một profile có cùng tên
- ``--dhcp-tag``: Các thẻ DHCP được sử dụng trong dhcp.template khi sử dụng dải mạng
- ``--kickstart``: Chỉ đường dẫn tới file kickstart local 
- ``--enable-menu``: Khi quản lí TFTP, cobbler sẽ ghi /pxelinux.cfg/default nơi chứa các mục của profile hay còn gọi là menu options khi boot 
