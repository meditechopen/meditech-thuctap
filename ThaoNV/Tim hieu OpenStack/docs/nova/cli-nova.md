# Các lệnh cơ bản thường dùng trong Nova

- Tạo mới 1 flavor

`openstack flavor create --id auto --ram <dung lượng ram> --disk <dung lượng disk> --vcpu <số lượng cpu> --public <tên flavor>`

dung lượng ram tính theo đơn vị MB
dung lượng disk tính theo đơn vị GB

- Liệt kê flavors

`openstack flavor list`

- show chi tiết 1 flavor

`openstack flavor show <tên hoặc ID của flavor>`

- Xóa bỏ 1 flavor

`openstack flavor delete <name or id của flavor>`

- Tạo keypair

``` sh
openstack keypair create
    [--public-key <file> | --private-key <file>]
    <name>
```

- List tất cả các key pair có trong openstack.

`openstack keypair list`

- Xóa bỏ 1 keypair

`openstack keypair delete <tên keypair>`


- Tạo máy ảo từ image

``` sh
openstack server create --flavor <tên flavor> --image <tên image> \
--nic net-id=<id của network> --security-group <tên security group> \
--key-name <tên keypair> <tên vm>
```

- Tạo máy ảo từ volume

``` sh
openstack server create --flavor <tên flavor> --volume <tên volume> \
--nic net-id=<id của network> --security-group <tên security group> \
--key-name <tên keypair> <tên vm>
```

-  Xóa máy ảo

`openstack server delete <tên VM>`

- Tắt máy ảo

`openstack server stop <tên VM>`

- Bật máy ảo

`openstack server start <tên VM>`

- reboot một VM đang chạy.

`openstack server reboot <tên VM>`

- List tất cả VM

`openstack server list`

- Tạo mới snapshot

`openstack snapshot create <tên snapshot> <tên máy ảo>`

- Hiển thị danh sách các snapshot

`openstack snapshot list`

- Xóa snapshot

`openstack snapshot delete <tên hoặc ID của snapshot>`

- Xem danh sách các hypervisor

`openstack hypervisor list`
