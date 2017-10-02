
# Hướng dẫn resize máy ảo được boot từ volume

- Cấu hình cold-migrate như hướng dẫn bên trên

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
