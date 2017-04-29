# Tìm hiểu về LVM
--------------------------------------------------
# Mục lục

## [I. Giới thiệu về LVM](#gt)
#### [1.1 Định nghĩa LVM](#11)
#### [1.2 Ưu nhược điểm LVM](#12)
#### [1.3 Vai trò của LVM](#13)
#### [1.4 Các thành phần trong LVM](#14)
## [II. Lab LVM trên Ubuntu Server](#lab)


----------------------------------------------

<a name=gt></a>
## I. Giới thiệu LVM

<a name=11></a>
### 1.1 Định nghĩa LVM
- Logical Volume Manager (LVM): là phương pháp cho phép ấn định không gian đĩa cứng thành những logical Volume khiến cho việc thay đổi kích thước trở nên dễ dàng hơn (so với partition). Với kỹ thuật Logical Volume Manager (LVM) bạn có thể thay đổi kích thước mà không cần phải sửa lại table của OS. Điều này thật hữu ich với những trường hợp bạn đã sử dụng hết phần bộ nhớ còn trống của partition và muốn mở rộng dung lượng của nó

<a name=12></a>
### 1.2 Ưu nhược điểm của LVM

**Ưu điểm:**
- Có thể gom nhiều đĩa cứng vật lý lại thành một đĩa ảo dung lượng lớn.
- Có thể tạo ra các vùng dung lượng lớn nhỏ tuỳ ý.
- Có thể thay đổi các vùng dung lượng một cách dễ dàng, linh hoạt

**Nhược điểm:**
- Các bước thiết lập phức tạp và khó khăn hơn
- Càng gắn nhiều đĩa cứng và thiết lập càng nhiều LVM thì hệ thống khởi động càng lâu.
- Khả năng mất dữ liệu cao khi một trong số các đĩa cứng bị hỏng.
- Windows không thể nhận ra vùng dữ liệu của LVM. Nếu Dual-boot ,Windows sẽ không thể truy cập dữ liệu trong LVM.

<a name=13></a>
### 1.3 Vai trò của LVM
- LVM là kỹ thuật quan lý việc thay đổi kích thước lưu trữ của ổ cứng.
- Không để hệ thống bị gián đoạn khi họat động.
- Không làm học dịch vụ.
- Có thể kết hợp với Hot Swapping

<a name=14></a>
### 1.4 Các thành phần trong LVM

Mô hình các thành phần trong LVM :

<img src=http://i.imgur.com/7od5v6b.png>

- Hard drives - Drives : Thiết bị lưu trữ dữ liệu, ví dụ như ổ cứng HDD,SSD,...
- Partion : Là các phân vùng của Hard drives. Mỗi Hard drives có thể chia được thành 4 phân vùng, trong đó có 2 loại phân vùng đó là Primary Partition và Extended Partition.
<ul>
<li>Primary Partition : Là phân vùng chính ,có thể khởi động . Mỗi đĩa cứng có thể chia được tối đa 4 phân vùng này.</li>
<li>Extended Partition : Phân vùng mở rộng, có thể tạo vùng luân lý.</li>
</ul>
- Physical Volumes : là một cách gọi khác của Partion trong kỹ thuật LVM, nó là những thành phần cơ bản được sử dụng bởi LVM. Một Physical Volume không thể mở rộng ra ngoài phạm vi một ổ đĩa. Chúng ta có thể kết hợp nhiều Physical Volume thành mọt Volume Groups.
- Volume Group : Nhiều Physical Volume trên những ổ đĩa khác nhau được kết hợp lại thành một Volume Group

<img src=http://i.imgur.com/IEw8o09.png>

Volume được sử dụng để tạo ra các Logical Volume, trong đó người dùng có thể tạo, thay đổi kích thước, lưu trữ, gỡ bỏ và sử dụng.

Một điểm cần lưu ý là boot loader không thể đọc được /boot khi nó nằm trên Logical Volume Group. Do đó không thể sử dụng kỹ thuật LVM với /boot mout point.
- Logical Volume : Volume Group được chia nhỏ thành nhiều Logical Volume, mỗi Logical Volume có ý nghĩa tương tự như các Partition . Nó được dùng các mout point và được format với những định dạng khác nhau như ext2, ext3, ext4,....

<img src=http://i.imgur.com/iuIaEbl.png>

Khi dung lượng của Logical Volume được sử dụng hết , ta có thể đưa thêm ổ đĩa mới bổ sung cho Volume Group và do đó tăng được dung lượng của Logical Volume .
- File Systems :
<ul>
<li>Tổ chức và kiểm soát các tệp tin</li>
<li>Được lưu trữ trên ổ đĩa cho phép truy cập nhanh chóng và an toàn</li>
<li>Sắp xếp dữ liệu trên đĩa cứng máy tính</li>
<li>Quản trị vât lý của mọi thành phần dữ liệu.</li>
</ul>

<a name=lab></a>
## II. Lab LVM trên Ubuntu Server 16

<a name=21></a>
### 2.1 Chuẩn bị

- Tạo máy ảo trên VMware, ở đây mình cài HĐH Ubuntu Server 16
- Tiến hành thêm các ổ cứng vào như hình :

<img src=http://i.imgur.com/IIS4GdE.png>

<a name=22></a>
### 2.2 Tạo Logical Volume trên LVM
- B1. Kiểm tra các Hard Drives có trên hệ thống

Bạn có thể kiểm tra xem có những Hard Drives nào trên hệ thống bằng cách sử dụng câu lệnh lsblk.

```
# lsblk
```

<img src=http://i.imgur.com/v8QFTMo.png>

Trong đó sdb, sdc là các Hard Drives mà mình mới thêm vào.

- B2. Tạo Partition

Từ các Hard Drives trên hệ thống, bạn tạo các partition. Ở đây, từ sdb, mình tạo các partition bằng cách sử dụng lệnh sau `fdisk /dev/sdb`

<img src=http://i.imgur.com/CyjC2rh.png>

Trong đó :
<ul>
<li>Chọn **n** để bắt đầu tạo partition</li>
<li>Chọn **p** để tạo partition primary</li>
<li>Chọn **1** để tạo partition primary 1</li>
<li>Tại **First sector (2048-20971519, default 2048)** để mặc định</li>
<li>Tại **Last sector, +sectors or +size{K,M,G} (2048-20971519, default 20971519)** bạn chọn **+1G** để partition bạn tạo ra có dung lượng 1 G</li>
<li>chọn **w** để lưu lại và thoát</li>
</ul>


Tiếp theo bạn thay đổi định dạng của partition vừa mới tạo thành LVM

<img src=http://i.imgur.com/0alWP6g.png>

<ul>
<li>Bạn chọn **t** để thay đổi định dạng partition</li>
<li>Bạn chọn **8e** để đổi thành LVM</li>
<li>chọn **w** để lưu lại và thoát.</li>
</ul>

Tương tự, thay đổi ở cả sdc, ta có như sau :

<img src=http://i.imgur.com/eVwrI8w.png>

- B3. Tạo Physical Volume

Tạo các Physical Volume là /dev/sdb1 ,/dev/sdb2và /dev/sdc1, /dev/sdc2 bằng các lệnh sau:

```
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

```
# vgs

# vgdisplay
```

<img src=http://i.imgur.com/xI8qL88.png>

- B5. Tạo Logical Volume

Từ một Volume Group, chúng ta có thể tạo ra các Logical Volume bằng cách sử dụng lệnh sau:

```
# lvcreate -L 1G -n lv-demo1 vg-demo1
```

Trong đó :
<ul>
<li>L: Chỉ ra dung lượng của logical volume</li>
<li>-n Chỉ ra tên logical volume</li>
<li>lv-demo1 là tên Logical Volume</li>
<li>vg-demo1 là Volume Group mà mình vừa tạo ở bước trước</li>
</ul>

- Lưu ý là chúng ta có thể tạo nhiều Logical Volume từ 1 Volume Group

- Có thể sử dụng câu lệnh sau để kiểm tra lại các Logical Volume đã tạo :

```
# lvs
# lvdisplay
```

<img src=http://i.imgur.com/UsqIfzK.png>

- B6. Định dạng Logical Volume :

Để format các Logical Volume thành các định dạng như ext2, ext3, ext4, ta có thể làm như sau:

```
# mkfs -t ext4 /dev/vg-demo1/lv-demo1
```

<img src=http://i.imgur.com/n0Qbh0J.png>

- B7. Mount và sử dụng

Tạo một thư mục để mount Logical Volume đã tạo vào thư mục đó.Sau đó tiến hành mount logical volume.

```
# mkdir demo1
# mount /dev/vg-demo1/lv-demo1 demo1

```

- Kiểm tra lại dung lượng của thư mục đã được mount:

```
# df -h
```

<img src=http://i.imgur.com/QzHHYUS.png>

<a name=23></a>
### 2.3 Thay đổi dung lượng Logical Volume trên LVM

- Trước khi thay đổi dung lượng thì chúng ta nên kiểm tra lại một lần :

```
# vgs
# lvs
# pvs
```

<img src=http://i.imgur.com/jUSpHmk.png>

- Để tăng kích thước Logical Volume ta sử dụng câu lệnh sau:

```
# lvextend -L +50M /dev/vg-demo1/lv-demo1
```

- Với -L là tùy chọn để tăng kích thước.
- Sau khi tăng kích thước cho Logical Volume thì Logical Volume đã được tăng nhưng file system trên volume này vẫn chưa thay đổi, bạn phải sử dụng lệnh sau để thay đổi.

```
# resize2fs /dev/vg-demo1/lv-demo1
```

<img src=http://i.imgur.com/zypYSSh.png>

- Để giảm kích thước của Logical Volume, trước hết các bạn phải umount Logical Volume mà mình muốn giảm

```
# lvreduce -L 20M /dev/vg-demo1/lv-demo1
# mkfs.ext4 /dev/vg-demo1/lv-demo1
```

- Kiểm tra kết quả : 
