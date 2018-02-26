# Hướng dẫn cấu hình cinder backup với backend là NFS

## Mục lục

1. Cấu hình NFS server

2. Cấu hình cinder backup

3. Hướng dẫn thực hiện tạo backup cho cinder và restore lại backup

--------------------

## 1. Cấu hình NFS server

Tham khảo hướng dẫn cấu hình NFS server làm backend cho cinder [tại đây](https://github.com/hocchudong/ghichep-OpenStack/blob/master/05-Cinder/docs/cinder-multiplebackdends-lvm-gfs-nfs.md)

## 2. Cấu hình cinder backup

Chỉnh sửa file `/etc/cinder/cinder.conf`

Thêm vào 2 dòng sau trong section [DEFAULT]

```
backup_driver=cinder.backup.drivers.nfs
backup_share=HOST:EXPORT_PATH
```

Trong đó `HOST:EXPORT_PATH` là địa chỉ của đường dẫn đã được thêm vào file `/etc/exports` ở bên nfs server

Ví dụ: `192.168.100.34:/mnt/nfs`

Khởi động dịch vụ cinder backup

```
systemctl enable openstack-cinder-backup.service
systemctl start openstack-cinder-backup.service
```

Kiểm tra tại node cinder xem đã được mount chưa bằng lệnh `df -h`

## 3. Hướng dẫn thực hiện tạo backup cho cinder và restore lại backup

Lưu ý: Để tạo được backup, volume phải ở trạng thái `available`. Do vậy nếu volume đang được attach vào máy ảo, cần phải gỡ nó ra.

Xem danh sách volume

`cinder list`

Show trạng thái volume `thao`

`cinder show thao`

Xem danh sách các backup

`cinder backup-list`

Tạo backup cho volume `thao`

`cinder backup-create --display-name thao_backup thao`

Kiểm tra lại bằng lệnh `cinder backup-list`

Sang phía nfs server để kiểm tra lại metadata file của backup được tạo ra.

Để restore lại volume về trạng thái lúc tạo backup, sử dụng lệnh sau

`cinder backup-restore --volume-id <volume-id> <backup-id>`

Để xóa một backup

`cinder backup-delete <backup-id>`
