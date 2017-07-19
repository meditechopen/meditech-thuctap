# Tìm hiểu về migrate máy ảo trong OpenStack

## Mục lục

1. Giới thiệu về tính năng migrate trong OpenStack

2. Các kiểu migrate hiện có trong OPS và workflow của chúng

3. So sánh ưu nhược điểm giữa cold và live migrate

4. Hướng dẫn cấu hình cold migrate trong OpenStack

5. Hướng dẫn cấu hình live migrate (block migration) trong OpenStack

---------

## 1. Giới thiệu về tính năng migrate trong OpenStack

<img src="http://i.imgur.com/vFgXoEK.png">

Migration là quá trình di chuyển máy ảo từ host vật lí này sang một host vật lí khác. Migration được sinh ra để làm nhiệm vụ bảo trì nâng cấp hệ thống. Ngày nay tính năng này đã được phát triển để thực hiện nhiều tác vụ hơn:

- Cân bằng tải: Di chuyển VMs tới các host khác kh phát hiện host đang chạy có dấu hiệu quá tải.
- Bảo trì, nâng cấp hệ thống: Di chuyển các VMs ra khỏi host trước khi tắt nó đi.
- Khôi phục lại máy ảo khi host gặp lỗi: Restart máy ảo trên một host khác.

Trong OpenStack, việc migrate được thực hiện giữa các node compute với nhau hoặc giữa các project trên cùng 1 node compute.

## 2. Các kiểu migrate hiện có trong OPS và workflow của chúng

OpenStack hỗ trợ 2 kiêu migration đó là:

- Cold migration : Non-live migration
- Live migration :
  - True live migration ((shared storage or volume-based)
  - Block live migration

**Workflow khi thực hiện cold migrate**

- Tắt máy ảo (giống với virsh destroy) và ngắt kết nối với volume
- Di chuyển thư mục hiện tại của máy ảo (instance_dir ->
instance_dir_resize)
- Nếu sử dụng QCOW2 với backing files (chế độ mặc định) thì image sẽ được convert thành dạng flat
- Với shared storage, di chuyển thư mục chứa máy ảo. Nếu không, copy toàn bộ thông qua SCP.
