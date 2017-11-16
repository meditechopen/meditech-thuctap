
# Hướng dẫn resize máy ảo

## Mục lục

1. Resize máy ảo boot từ local

2. Resize máy ảo boot từ volume

3. Một số lưu ý

-------------

## 1. Resize máy ảo boot từ local

- Cấu hình cold-migrate theo theo hướng dẫn [tại đây](./docs/migration.md)

- Thực hiện resize máy ảo bằng câu lệnh

`openstack server resize --flavor <flavor-name> <vm-name>`

- Đợi đến khi trạng thái máy ảo chuyển về “VERIFY_RESIZE” (dùng câu lệnh “openstack server show” để xem). Ta tiến hành xác nhận hoặc loại bỏ kết quả của việc resize máy ảo. Tiến hành xác nhận bằng câu lệnh sau

`openstack server resize --confirm <vm-name>`

- Nếu muốn quay trở về sử dụng máy ảo cũ, sử dụng câu lệnh sau

`openstack server resize --revert <vm-name>`

## 2. Resize máy ảo boot từ volume

- Cấu hình cold-migrate theo theo hướng dẫn [tại đây](./docs/migration.md)

- Tắt máy ảo

`openstack server stop <vm_name>`

- Xem danh sách các volume hiện có

`cinder list`

- Thay đổi trạng thái của volume muốn resize từ `in-use` sang `available`

`cinder reset-state --state available <volume-ID>`

- Tiến hành extend volume  

`cinder extend <volume-ID> <new-size-in-GB>`

- Thay đổi volume lại về trạng thái in-use

`cinder reset-state --state in-use <volume-ID>`

- Qua node block storge và kiểm tra bằng lệnh `lvdisplay` xem volume đã được extend hay chưa

- Resize máy ảo sang flavor mới với mức dung lương mong muốn (mức đặt cho volume)

`openstack server resize --flavor <flavor> <vm-name>`

- Confirm resize sau khi trạng thái máy ảo chuyển thành “VERIFY_RESIZE” (dùng câu lệnh “openstack server show” để xem)

`openstack server resize --confirm <vm-name>`

- Bật máy ảo lên, partition sẽ tự động được resize

## 3. Một số lưu ý

- Tùy chọn `allow_resize_to_same_host` trong file `/etc/nova/nova.conf` mặc định là `false`. Nếu bạn chỉnh thành True thì có nghĩa OPS sẽ cho phép bạn thêm host mà VM đang chạy vào trong options của các host mà máy ảo chạy.

(Allow destination machine to match source for resize. Useful when testing in single-host environments. By default it is not allowed to resize to the same host. Setting this option to true will add the same host to the destination options)

- Điều này có nghĩa bạn sẽ không thể buộc máy ảo sau khi resize phải được đặt ở trên cùng một host bằng cách sửa tùy chọn trên. Thay vào đó, có một cách khác để thực hiện điều này. Đó là stop dịch vụ nova-compute trên các host compute khác.
