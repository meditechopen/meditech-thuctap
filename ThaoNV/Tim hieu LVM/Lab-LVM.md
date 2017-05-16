# Lab LVM

## Mục lục

- [1. Các câu lệnh sử dụng trong LVM](#commands)
  <ul>
  <li>[1.1 Physical volume](#physical)</li>
  <li>[1.2 Volume group](#group)</li>
  <li>[1.3 Logical volume](#logical)</li>
  </ul>

- [2. Lab LVM](#lab)
  <ul>
  <li>[2.1. Tạo Logical Volume trên LVM](#create)</li>
  <li>[2.2 Thay đổi dung lượng Logical Volume trên LVM][#change-group]</li>
  <li>[2.3 Thay đổi dung lượng Volume Group trên LVM][#change-logical]</li>
  </ul>


## <a name = "commands"> 1. Các câu lệnh sử dụng trong LVM </a>

Đây là những câu lệnh thông dụng để làm việc với LVM

### <a name ="physical"> 1.1 Physical volume: </a>

- Câu lệnh với cú pháp `pv...` đây là những câu lệnh làm việc với physical volume

- Tạo 1 physical volume
  `pvcreate`

- Hiển thị thuộc tính của physical volume

`pvdisplay`

- Điều chỉnh dụng lượng của physical volume

`pvresize`

- Xóa physical volume

`pvremove`

- Quét tất cả ổ đĩa là physical volume

`pvscan`

- Hiển thị các thông số của physical volume

`pvs`

### <a name ="group"> 1.2 Volume group </a>

- Các câu lệnh làm việc với volume group với cú pháp `vg`.

- Tạo volume:

`vgcreate [tên các pv để tạo volume group]`

- Hiển thị các thuộc tính của volume group

`vgdisplay`

- Mở rộng volume group

`vgextend [tên pv]`

- Xóa các physical volume ra khỏi volume group

`vgreduce [tên pv]`

- Xóa volume group

`vgremove`

- Xem các thông số của volume group

`vgs`

### <a name ="logical"> 1.3 Logical volume </a>

- Các câu lệnh làm việc với logical volume với cú pháp `lv`

- Tạo logical volume

`lvcreate`

- Hiển thị các thuộc tính của logical volume

`lvdisplay`

- Mở rộng logical volume. Lưu ý: chỉ mở rộng khi volume group còn dung lượng trống

`lvextend`

- Xóa logical volume khỏi volume group

`lvremove`

- Thay đổi dung lượng logical volume

`lvresize`

## <a name ="lab"> 2. Lab LVM </a>

- Sử dụng VMware, HĐH Ubuntu Server 14.04
- Tiến hành thêm các ổ cứng vào như hình :

<img src="http://i.imgur.com/oE9Za8N.png">

### <a name ="create"> 2.1. Tạo Logical Volume trên LVM </a>

- B1. Kiểm tra các Hard Drives có trên hệ thống

Bạn có thể kiểm tra xem có những Hard Drives nào trên hệ thống bằng cách sử dụng câu lệnh lsblk.

`# lsblk`

<img src="http://i.imgur.com/LpF3E0r.png">

Trong đó sdb, sdc là các Hard Drives mà mình mới thêm vào.

- B2. Tạo Partition

Từ các Hard Drives trên hệ thống, bạn tạo các partition. Ở đây, từ sdb, mình tạo các partition bằng cách sử dụng lệnh sau `fdisk /dev/sdb`

<img src="http://i.imgur.com/Y2eqa63.png">

<img src="http://i.imgur.com/miW2eBX.png">

- Trong đó :
  <ul>
  <li>Chọn **n** để bắt đầu tạo partition</li>
  <li>Chọn **p** để tạo partition primary</li>
  <li>Chọn **1** để tạo partition primary 1</li>
  <li>Tại **First sector (2048-20971519, default 2048)** để mặc định</li>
  <li>Tại **Last sector, +sectors or +size{K,M,G} (2048-20971519, default 20971519)** bạn chọn **+10G** để partition bạn tạo ra có dung lượng 10G</li>
  <li>chọn **w** để lưu lại và thoát</li>
  </ul>


Tiếp theo bạn thay đổi định dạng của partition vừa mới tạo thành LVM

<img src=http://i.imgur.com/9HgH86Y.png>

- Trong đó:
  <ul>
  <li>Bạn chọn **t** để thay đổi định dạng partition</li>
  <li>Bạn chọn **8e** để đổi thành LVM</li>
  <li>chọn **w** để lưu lại và thoát.</li>
  </ul>

Tương tự, thay đổi ở cả sdc, ta có như sau :

<img src=http://i.imgur.com/Bclpoxz.png>

- B3. Tạo Physical Volume

Tạo các Physical Volume là /dev/sdb1 ,/dev/sdb2và /dev/sdc1, /dev/sdc2 bằng các lệnh sau:

``` sh
# pvcreate /dev/sdb1
# pvcreate /dev/sdb2
# pvcreate /dev/sdc1
# pvcreate /dev/sdc2
```

Có thể kiểm tra các Physical Volume bằng câu lệnh pvs hoặc có thể sử dụng lệnh pvdisplay.

- B4. Tạo Volume Group

Tiếp theo, nhóm các Physical Volume thành 1 Volume Group bằng cách sử dụng câu lệnh sau:

```
# vgcreate vg-demo1 /dev/sdb1 /dev/sdb2 /dev/sdc1 /dev/sdc2
```

Trong đó vg-demo1 là tên của Volume Group

Có thể sử dụng câu lệnh sau để kiểm tra lại các Volume Group đã tạo

``` sh
# vgs

# vgdisplay
```

<img src=http://i.imgur.com/ZJQGQRf.png>

- B5. Tạo Logical Volume

Từ một Volume Group, chúng ta có thể tạo ra các Logical Volume bằng cách sử dụng lệnh sau:

`# lvcreate -L 1G -n lv-demo1 vg-demo1`

- Trong đó :
  <ul>
  <li>L: Chỉ ra dung lượng của logical volume</li>
  <li>-n Chỉ ra tên logical volume</li>
  <li>lv-demo1 là tên Logical Volume</li>
  <li>vg-demo1 là Volume Group mà mình vừa tạo ở bước trước</li>
  </ul>

- Lưu ý là chúng ta có thể tạo nhiều Logical Volume từ 1 Volume Group

- Có thể sử dụng câu lệnh sau để kiểm tra lại các Logical Volume đã tạo :

``` sh
# lvs
# lvdisplay
```

<img src=http://i.imgur.com/AX28X7X.png>

- B6. Định dạng Logical Volume :

Để format các Logical Volume thành các định dạng như ext2, ext3, ext4, ta có thể làm như sau:

`# mkfs -t ext4 /dev/vg-demo1/lv-demo1`

<img src=http://i.imgur.com/UmMkCLA.png>

- B7. Mount và sử dụng

Tạo một thư mục để mount Logical Volume đã tạo vào thư mục đó.Sau đó tiến hành mount logical volume. Lưu ý: đây là kiểu mount mềm, sẽ bị mất nếu máy khởi động lại. Để có thể sử dụng ngay cả khi reboot máy, bạn cần phải mount cứng.

``` sh
# mkdir demo1
# mount /dev/vg-demo1/lv-demo1 demo1
```

- Kiểm tra lại dung lượng của thư mục đã được mount:

```
# df -h
```

<img src=http://i.imgur.com/CMsiBB0.png>

### <a name ="change-logical"> 2.2 Thay đổi dung lượng Logical Volume trên LVM </a>

- Trước khi thay đổi dung lượng thì chúng ta nên kiểm tra lại một lần để xem trạng thái hiện tại có cho phép thay đổi không. `VG status` đang ở trạng thái `resizeable` như trong hình.

`vgdisplay`

<img src=http://i.imgur.com/36c5Ufh.png>

- Để tăng kích thước Logical Volume ta sử dụng câu lệnh sau:

`# lvextend -L +50M /dev/vg-demo1/lv-demo1`

- Với `-L` là tùy chọn để tăng kích thước.
- Sau khi tăng kích thước cho Logical Volume thì Logical Volume đã được tăng nhưng file system trên volume này vẫn chưa thay đổi, bạn phải sử dụng lệnh sau để thay đổi.

`# resize2fs /dev/vg-demo1/lv-demo1`

<img src=http://i.imgur.com/btPLCHc.png>

- Để giảm kích thước của Logical Volume, trước hết các bạn phải umount Logical Volume mà mình muốn giảm

``` sh
# lvreduce -L 20M /dev/vg-demo1/lv-demo1
# mkfs.ext4 /dev/vg-demo1/lv-demo1
```

### <a name ="group"> 2.3 Thay đổi dung lượng Volume Group trên LVM </a>

- Phần này sẽ tiến hành thêm dung lượng Volume Group bằng cách thêm một ổ cứng mới, sau đó thêm dung lượng ổ cứng đó vào Lolume Group.

- Trước tiên, các bạn cần kiểm tra lại các partition và Volume Group

``` sh
# vgs
# lsblk
```

<img src=http://i.imgur.com/lOklFrK.png>

- Tiếp theo, nhóm thêm 1 partition vào Volume Group:

`# vgextend /dev/vg-demo1 /dev/sdb3`