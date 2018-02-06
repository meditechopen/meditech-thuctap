# Lab GlusterFS

## Yêu cầu:

Bài lab thực hành trên mô hình glusterFS với 2 server storage và 1 client sẽ sử dụng Volume của cụm 
gluster để lưu trữ. 
- Thực hiện lab trên KVM, ổ `/dev/sda` là ổ thêm vào để tạo các brick trên mỗi server.
- Mode: replicated gluster.

|Hostname|IP Address|OS|RAM|Disk|Mục đích|
|--------|----------|--|----|----|--------|
|gluster1.songle.local|192.168.100.101|CentOS 7|2GB|/dev/sda(10GB)|Node lưu trữ 1|
|gluster2.songle.local|192.168.100.102|CentOS 7|2GB|/dev/sda(10GB)|Node lưu trữ 2|
|client.songle.local|192.168.100.103|CentOS 7|2GB|NA|NA|Máy client|

## Thực hành


### Cấu hình DNS:

Các thành phần trong GlusterFS sử dụng DNS để phân giải tên miền, vì thế cấu hình DNS hoặc host entry để 
chúng giao tiếp được với nhau. Nếu bạn không cài DNS server, **thay đổi** file `/etc/hosts` để cập nhật 
tên miền và ip cho các node và client.

```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.100.101  gluster1.songle.local  gluster1
192.168.100.102  gluster2.songle.local  gluster2
192.168.100.103  client.songle.local client
```
### Thêm link trỏ về kho lưu trữ cho GlusterFS:

Trước khi cài đặt, ta cần cấu hình GlusterFS Reposistory ở cả 2 storage nodes.

#### RHEL 7:

```
vi /etc/yum.repos.d/Gluster.repo

[gluster38]
name=Gluster 3.8
baseurl=http://mirror.centos.org/centos/7/storage/$basearch/gluster-3.8/
gpgcheck=0
enabled=1
```

#### CentOS 7:

Cài đặt gói `centos-release-gluster` , nó sẽ cung cấp những gói YUM reposistory cần thiết.

```
yum install -y centos-release-gluster
```

### Cài đặt GlusterFS:

Sau khi thêm repo thành công, bạn đã có đủ các thứ cần thiết để cài đặt GlusterFS.
Cài đặt gói GlusterFS bằng lệnh sau trên cả 2 node:

`yum install -y glusterfs-server` 

Khởi động dịch vụ trên cả 2 node:

`systemctl start glusterd`

Kiểm tra tình trạng của dịch vụ:

```
[root@localhost ~]#  systemctl status glusterd
● glusterd.service - GlusterFS, a clustered file-system server
   Loaded: loaded (/usr/lib/systemd/system/glusterd.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2018-02-06 02:22:12 EST; 12s ago
  Process: 8576 ExecStart=/usr/sbin/glusterd -p /var/run/glusterd.pid --log-level $LOG_LEVEL $GLUSTERD_OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 8577 (glusterd)
   CGroup: /system.slice/glusterd.service
           └─8577 /usr/sbin/glusterd -p /var/run/glusterd.pid --log-level INFO

Feb 06 02:22:12 localhost.localdomain systemd[1]: Starting GlusterFS, a clustered file....
Feb 06 02:22:12 localhost.localdomain systemd[1]: Started GlusterFS, a clustered file-....
Hint: Some lines were ellipsized, use -l to show in full.
```

Enable `glusterd` để khởi động dịch vụ khi hệ điều hành khởi động.

`systemctl enable glusterd`

### Cấu hình tường lửa:

Bạn cần phải tắt `firewall` hoặc `configure firewall` để cho phép các kết nối trong gluster với nhau.

```
Mặc định, glusterd sẽ lắng nghe trên tcp/24007 nhưng mở cổng này thì không đủ cho các node gluster. Mỗi lần bạn tạo thêm 1 brick, nó sẽ mở một port mới 
( bạn có thể sử dụng "gluster volumes status" để kiểm chứng)
```

```
#Disbale FirewallD
systemctl stop firewalld
systemctl disable firewalld

hoặc

# Chạy lệnh dưới trên node mà bạn cho phép tất cả các kết nối đến nó từ một địa chỉ cụ thể
firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="<ipaddress>" accept'
firewall-cmd --reload

```

### Thêm Storage:

Ngoài việc có 1 ổ cứng để lưu hệ điều hành, ta thêm 1 ổ cứng nữa để tạo các brick, ở đây là ổ `sda`.

```
[root@localhost ~]# lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   20G  0 disk
sr0              11:0    1  792M  0 rom
vda             252:0    0   30G  0 disk
├─vda1          252:1    0    1G  0 part /boot
└─vda2          252:2    0   29G  0 part
  ├─centos-root 253:0    0   27G  0 lvm  /
  └─centos-swap 253:1    0    2G  0 lvm  [SWAP]
```

Tạo phân vùng trên ổ cứng ở cả 2 node để sử dụng:

`fdisk /dev/sda`

```
[root@localhost ~]# fdisk /dev/sda
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0xf0f1b3eb.

Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p):
Using default response p
Partition number (1-4, default 1):
First sector (2048-41943039, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-41943039, default 41943039): +10G
Partition 1 of type Linux and of size 10 GiB is set

Command (m for help): p

Disk /dev/sda: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0xf0f1b3eb

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048    20973567    10485760   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
```

Định dạng phân vùng vừa tạo với filesystem mà bạn muốn sử dụng, ở đây tôi chọn `ext4`:

`mkfs.ext4 /dev/sda1`

Tiến hành mount phân vùng đến thư mục gọi là `/data/gluster` để sử dụng làm brick cho mỗi node:

```
mkdir -p /data/gluster
mount /dev/sda1 /data/gluster
```

Thêm thông số cho **/etc/fstab** để hệ điều hành giữ phân vùng mount mỗi khi khởi động lại.

`echo "/dev/sda1 /data/gluster ext4 defaults 0 0" | tee --append /etc/fstab`

### Cấu hình GlusterFS trên CentOS 7:

Trước khi tạo một volume, ta cần tạo một pool lưu trữ với độ tin cậy cao (trusted storage pool) 
bằng cách thêm **gluster2.songle.local**. Bạn có thể chạy lệnh cấu hình GlusterFS trên bất kể server nào trong 
cluster.

Ở đây tôi chạy trên node **gluster1.songle.local**: 

```
[root@localhost ~]# gluster peer probe gluster2.songle.local
peer probe: success.
```
Nếu không muốn peer 2 node với nhau :

```
# gluster peer detach gluster2.songle.local
```
Kiểm tra trạng thái của trusted storage pool:

```
[root@localhost ~]# gluster peer status
Number of Peers: 1

Hostname: gluster2.songle.local
Uuid: f0a9778d-1e0a-4c17-b617-112f1204c49a
State: Peer in Cluster (Connected)
```

Liệt kê danh sách storage pool:

```
[root@localhost ~]# gluster pool list
UUID                                    Hostname                State
f0a9778d-1e0a-4c17-b617-112f1204c49a    gluster2.songle.local   Connected
309587ed-7177-473f-91a4-0d898cde9df3    localhost               Connected
```

### Cài đặt GlusterFS Volume:

Tạo một brick (directory) gọi là **gv0** trên 2 thư mục mount đã tạo trên cả 2 node:

`mkdir -p /data/gluster/gv0`

Vì ta sẽ sử dụng **replicated volume** nên ta sẽ tạo một volume có tên **gv0** với 2 bản sao (replicas).
(chỉ cần dùng lệnh này trên 1 trong 2 node)
```
[root@localhost ~]# gluster volume create gv0 replica 2 gluster1.songle.local:/data/gluster/gv0 gluster2.songle.local:/data/gluster/gv0
```

*Chọn "y" để tạo gv0*

Khởi động volume:

```
[root@localhost ~]# gluster volume start gv0
volume start: gv0: success
```

Kiểm tra trạng thái của volume vừa tạo:

```
[root@localhost ~]# gluster volume info gv0

Volume Name: gv0
Type: Replicate
Volume ID: c2f8954f-4b3d-4a25-8e23-3a9846ca8164
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x 2 = 2
Transport-type: tcp
Bricks:
Brick1: gluster1.songle.local:/data/gluster/gv0
Brick2: gluster2.songle.local:/data/gluster/gv0
Options Reconfigured:
transport.address-family: inet
nfs.disable: on
performance.client-io-threads: off
```

### Cài đặt GlusterFS Client:

Cài đặt gói **glusterfs-client** để hỗ trợ việc mount các GlusterFS filesystems. Chạy tất 
cả các lệnh dưới với quyền **root**.

```
### CentOS / RHEL ###
yum install -y glusterfs-client

### Ubuntu / Debian ###
apt-get install -y glusterfs-client
```

Tạo thư mục để mount GlusterFS filesystem, phục vụ cho việc lưu trữ dữ liệu của client trên server.

`mkdir -p /mnt/glusterfs`

Tiến hành mount:

`mount -t glusterfs gluster1.songle.local:/gv0 /mnt/glusterfs`

Nếu bạn thấy có lỗi xảy ra phía dưới:

`Mount failed. Please check the log file for more details.`

Xem lại các cài đặt Firewall rules cho máy client để cho phép các kết nối đến các node.
Sử dụng lệnh sau:

```
systemctl stop firewalld
systemctl disable firewalld

hoặc

firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="clientip" accept'
```

Bạn cũng có thể sử dụng **gluster2.songle.local** thay vì **gluster1.songle.local** với lệnh trên.

Kiểm tra rằng GlusterFS Filesystem đã được mount thành công:

```
[root@localhost ~]# df -hP /mnt/glusterfs
Filesystem                  Size  Used Avail Use% Mounted on
gluster1.songle.local:/gv0  9.8G   37M  9.2G   1% /mnt/glusterfs
```

Bạn cũng có thể dùng lệnh dưới để chứng thực hệ thống GlusterFS đã tạo và hoạt động tốt:

```
[root@localhost ~]# cat /proc/mounts
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,seclabel,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs rw,seclabel,nosuid,size=930752k,nr_inodes=232688,mode=755 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev/shm tmpfs rw,seclabel,nosuid,nodev 0 0
devpts /dev/pts devpts rw,seclabel,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,seclabel,nosuid,nodev,mode=755 0 0
tmpfs /sys/fs/cgroup tmpfs ro,seclabel,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/net_cls,net_prio cgroup rw,nosuid,nodev,noexec,relatime,net_prio,net_cls 0 0
cgroup /sys/fs/cgroup/hugetlb cgroup rw,nosuid,nodev,noexec,relatime,hugetlb 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpuacct,cpu 0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/perf_event cgroup rw,nosuid,nodev,noexec,relatime,perf_event 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/pids cgroup rw,nosuid,nodev,noexec,relatime,pids 0 0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
/dev/mapper/centos-root / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
selinuxfs /sys/fs/selinux selinuxfs rw,relatime 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=33,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=11427 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
mqueue /dev/mqueue mqueue rw,seclabel,relatime 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,seclabel,relatime 0 0
/dev/vda1 /boot xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
tmpfs /run/user/0 tmpfs rw,seclabel,nosuid,nodev,relatime,size=188364k,mode=700 0 0
gluster1.songle.local:/gv0 /mnt/glusterfs fuse.glusterfs rw,relatime,user_id=0,group_id=0,default_permissions,allow_other,max_read=131072 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
[root@localhost ~]#
```

Thêm entry đến **/etc/fstab** để hệ thống tự động mount trong lúc khởi động.

`echo "gluster1.songle.local:/gv0 /mnt/glusterfs glusterfs  defaults,_netdev 0 0" >> /etc/fstab`


### Kiểm tra GlusterFS Replication và cơ chế High-Availability của hệ thống:

#### Trên GlusterFS Server

Để kiểm tra tính dự phòng của hệ thống Replication, mount GlusterFS volume đã tạo lên trên cùng node đó.

`[root@gluster1 ~]# mount -t glusterfs gluster2.songle.local:/gv0 /mnt`

`[root@gluster2 ~]# mount -t glusterfs gluster1.songle.local:/gv0 /mnt`

Dữ liệu trong thư mục `/mnt` ở cả 2 nodes đều giống nhau (replication).

#### Gluster Client side:

Tạo một số file trên thư mục mount trên máy client để kiểm tra.

```
touch /mnt/glusterfs/file1
touch /mnt/glusterfs/file2
```

Kiểm tra file đã tạo thành công chưa:

```
[root@client glusterfs]# ls -l
total 0
-rw-r--r--. 1 root root 0 Feb  6 03:28 file1
-rw-r--r--. 1 root root 0 Feb  6 03:28 file2
```

Kiểm tra cả 2 node GlusterFS để xem chúng có cùng dữ liệu trong thư mục */mnt* hay không.

Trên node 1:

```
[root@gluster1 ~]# cd /mnt
[root@gluster1 mnt]# ls -l
total 0
-rw-r--r--. 1 root root 0 Feb  6 03:28 file1
-rw-r--r--. 1 root root 0 Feb  6 03:28 file2
```

Trên node 2:

```
[root@gluster2 ~]# cd /mnt
[root@gluster2 mnt]# ls -l
total 0
-rw-r--r--. 1 root root 0 Feb  6 03:28 file1
-rw-r--r--. 1 root root 0 Feb  6 03:28 file2
```

**Chúng ta vừa tạo một hệ thống GlusterFS volume từ `gluster1.songle.local` trên `client.songle.local`, bây giờ 
ta sẽ kiểm tra tính sẵn sàng (high-availability) của volume bằng cách tắt đi một node.

`[root@gluster1 ~]# poweroff`

Bây giờ kiểm tra xem tính dự phòng của hệ thống, liệu rằng bạn có thấy 2 file vừa tạo trên client khi 1 node vừa bị tắt.

```
[root@client glusterfs]# ls -l /mnt/glusterfs/
total 0
-rw-r--r--. 1 root root 0 Feb  6 03:28 file1
-rw-r--r--. 1 root root 0 Feb  6 03:28 file2
```

*Khi kiểm tra file trên client có thể sẽ mất 1 thời gian chờ bởi vì GlusterFS đang trỏ tới gluster2.songle.local khi mà
 client.songle.local không thể trỏ tới gluster1.songle.local*
 
Tạo thêm một số file trên client để kiểm tra:

```

[root@client glusterfs]# ls -l
total 0
-rw-r--r--. 1 root root 0 Feb  6 03:28 file1
-rw-r--r--. 1 root root 0 Feb  6 03:28 file2
-rw-r--r--. 1 root root 0 Feb  6 03:39 file3
-rw-r--r--. 1 root root 0 Feb  6 03:39 file4
````
 
Vì **gluster1** đang tắt, tất cả dữ liệu sẽ được ghi lên **gluster2.songle.local** bởi cơ chế replication. Bây giờ 
bật node1 lên (**gluster1.songle.local**).

Kiểm tra **/mnt** trên **gluster1.songle.local** ; bạn sẽ thấy 4 files vừa tạo trên client trong thư mục mount, điều 
này cho thấy replication đang hoạt động như dự định.

```
[root@gluster1 gv0]# ls -l
total 16
-rw-r--r--. 2 root root 0 Feb  6 03:28 file1
-rw-r--r--. 2 root root 0 Feb  6 03:28 file2
-rw-r--r--. 2 root root 0 Feb  6 03:39 file3
-rw-r--r--. 2 root root 0 Feb  6 03:39 file4
```

Hệ thống đã tạo thành công!


