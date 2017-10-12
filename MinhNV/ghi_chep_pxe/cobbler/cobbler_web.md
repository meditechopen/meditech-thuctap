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
