# Package management systems
package management system được dùng để cài đặt hầu hết các ứng dụng
Mỗi gói tin chứa các tập tin và hướng dẫn cài đặt phần mềm đó trên hệ thống
có 2 phương thức quản lí các gói package là `dpkg` và `rmp` cùng cung cấp các đặc tính như sau

<img src="https://i.imgur.com/QMbywu0.png">

Tất cả package management systems cung cấp 2 cấp độ công cụ quản lí
1. Low-level tool (`dpkg` hay `rpm`) : giải nén các gói dữ liệu, chạy script, đảm bảo phầm 
mềm cài đặt chính xác
2. High-level tool (`apt-get` hay `yum`, `zypper`) làm việc với các nhóm packages, tải
packages từ nhà cung cấp
Thông thường người dùng chỉ cần sử dụng High-level tool
Dependency tracking là theo dõi sự phụ thuộc là một đặc điểm quan trọng của High-level tool
vì nó sẽ tìm và cài đặt thêm các phần đi kèm, bổ trợ cho packages
một packages khi cặt đặt thường có thêm 1 số các phần bổ trợ đi kèm

<img src="https://i.imgur.com/2PbO2iC.png">
