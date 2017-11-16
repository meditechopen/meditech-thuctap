# RPM/YUM

## Tại sao chúng ta cần RPM package?

Ban đầu tất cả các phần mềm được sử dụng trong Linux đều có sẵn dưới dạng tệp tin tar, tệp tin tar sẽ chứa tất cả các tệp có liên quan đến phần mềm. Người dùng sẽ extract file tar biên dịch phần mềm và sau đó cài đặt nó. Có 2 nhược điểm

- Một khi phần mềm được cài đặt nó khó để theo dõi tất cả các tập tin được cài đặt trong các đường dẫn khác nhau trong hệ thống tập tin và không dễ dàng để gỡ bỏ và cập nhật phần mềm.
- Nếu ứng dụng có một số phụ thuộc thì bạn cần tự cài đặt nó trước khi cài đặt ứng dụng của mình.

### RPM package là gì?

- Vấn đề này được giải quyết bằng cách đóng gói tất cả các phần mềm và metadata của nó trong một gói gọi là RPM.
- RPM package chưa phiên bản, danh sách các file, các gói phụ thuộc và mô tả của một gói...

=>> Dễ dàng theo dõi được phiên bản phần mềm và các file liên quan.

### RPM commands

#### 1. Hiển thị tất cả danh sách các gói RPM đã cài đặt trong hệ thống 

``rpm -qa``

#### 2. Kiểm tra các gói RPM cụ thể đã cài đặt

``rpm -qa httpd``

#### 3. Để biết những package nào dựa vào đường dẫn cụ thể 

``rpm -qf /etc/yum.conf	``

#### 4. Hiển thị tất cả các file trong một package

``rpm -ql yum``

#### 5.  Hiển thị log khi thay đổi 1 package

``rpm -q --changelog yum | less``

## Lệnh YUM

*Yellowdog Updater, Modified* (yum) là một lệnh quản lý các RPM package và repositories.

#### 1. Install RPM package

``yum install httpd``

Lệnh này sẽ cài đặt gói httpd với tất cả các gói liên quan. Nếu thiếu nó sẽ báo lỗi.

Trong quá trình cài đặt xuất hiện `Is this ok [y/d/N]`. Ở đây tùy chọn d là chỉ download và nó chỉ định rpm sẽ tải xuống và lưu trong thư mục `/var/cache/rpm`

#### 2. Remove RPM package

``yum erase httpd``

#### 3. Update RPM package

- Một gói

``yum update httpd``

- Toàn bộ

``yum update``

#### 4. Lấy thông tin về 1 package

``yum info httpd``

#### 5. Hiển thị history của lệnh YUM

``yum history``

#### 6. Hiển thị các repositories 

``yum repolist``

#### 7. Xóa dữ liệu cache được tích lũy trong thư mục `/var/cache/yum`

``yum clean all``

### Các tạo một yum repository


