# Các lệnh cơ bản thường dùng trong Glance

- Hiển thị danh sách image

`openstack image list` hoặc `glance image-list`

- Show image

`openstack image show <tên hoặc ID của image>`

- Tạo image

``` sh
openstack image create "<tên image>" \
--file <file image cần upload> \
--disk-format qcow2 --container-format bare \
--public
```

- Trong trường hợp ta tạo ra một image mới và rỗng, ta cần upload dữ liệu cho nó, sử dụng câu lệnh

`glance image-upload --file file_name image_id`

- Xóa image

`openstack image delete <tên hoặc ID của image>`

Xem thêm về các câu lệnh [tại đây](https://docs.openstack.org/python-openstackclient/latest/cli/command-list.html)
