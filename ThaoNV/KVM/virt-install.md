# Tìm hiểu câu lệnh virt-install

## Mục lục

### [I. Giới thiệu câu lệnh virt-install](#gioi-thieu)   

### [II. Các options khi tạo máy ảo với virt-install](#option)

----

### <a name = "gioi-thieu"> I. Giới thiệu câu lệnh virt-install </a>

- virt-install là công cụ command line dùng cho việc tạo máy ảo trên KVM sử dụng thư viện quản lí "libvirt".
- virt-install hỗ trợ cả dạng text lẫn đồ họa, người sử dụng có thể lựa chọn giữa VNC - SDL cho chế độ cài đồ họa hoặc text console. Bên cạnh đó, bạn cũng có thể lựa chọn cài đặt dùng 1 hoặc nhiều các thành phần như virtual disks, card mạng, ...
- virt-install có thể lấy các file cài đặt từ trên NFS, HTTP, FTP servers để tiến hành cài máy ảo. Bên cạnh đó, nó cũng cho phép sử dụng PXE booting hoặc file image.
- Chỉ cần bạn nhập đúng những dòng lệnh, virt-install sẽ tự động cài đặt máy ảo mà không cần sự giám sát. Nó cũng có chế độ tương tác với option `--prompt` nhưng virt-install sẽ chỉ yêu cầu những tùy chọn tối thiểu.

### <a name ="option"> II. Các options khi tạo máy ảo với virt-install </a>

- Hầu hết các options là không bắt buộc, virt-install chỉ yêu cầu 1 số thông số tối thiểu sau:
  <ul>
  <li>--name</li>
  <li>--ram</li>
  <li>--disk</li>
  <li>--filesystem or --nodisks</li>
  <li>Các tùy chọn cài đặt</li>
  </ul>

- **Các tùy chọn thông thường**
- `-h` hoặc `--help`: Show các tùy chọn
- `-n` hoặc `--name = TEN`: Tên của máy ảo muốn tạo, nó không được trùng với các máy ảo đang chạy.
- `-r` hoặc `--ram=RAM`: RAM cho máy ảo (theo megabytes)
- `--arch=ARCH` : Nếu bỏ qua tùy chọn này, kiến trúc CPU của máy chủ sẽ được sử dụng cho máy ảo
- `-u` hoặc `--uuid` : UUID cho máy ảo, nếu bỏ qua, UUID sẽ được sinh ngẫu nhiên.
- `--vcpus = VCPUS[, maxvcpus=MAX][, sockets=#][,cores=#][,threads=#]` : Số lượng CPU cho máy ảo, nếu `maxvcpus` được thiết lập, máy ảo sẽ có thể sử dụng tới số lượng tối đa CPU đã cho phép, tuy nhiên nó sẽ khởi động với số VCPUS ban đầu.
- `--cpuset=CPUSET` : Cho biết cpu vật lý nào sẽ được máy ảo sử dụng, nếu chọn `auto`, máy ảo sẽ tự động chọn lựa.
- `--cpu MODEL` : Lựa chọn CPU models, xem các model được liệt kê tại file `cpu_map.xml`  trong thư mục của `libvirt`.
  Ví dụ: `--cpu core2duo`

- `--description` : Mô tả cho máy ảo
- `--security type = TYPE[,label=LABEL][,relabel=yes|no]` : Thiết lập domain security driver, có thể chọn `dynamic` hoặc `static` .

- **Các tùy chọn cài đặt**
- `-c` hoặc `--cdrom=CDROM` : File hoặc thiết bị được sử dụng như ổ đĩa ảo để cài đặt máy ảo. Nó có thể là đường dẫn đến file ISO trong máy hoặc ổ địa, hoặc cũng có thể là đường link (giống với tùy chọn `--location`). Nếu cdrom đã được thiết lập thông qua `--disk` thì nó sẽ mặc định được sử dụng làm phương tiện cài đặt.
- `-l` hoặc `--location=LOCATION` : Đường dẫn tới file cài đặt từ trên internet

Một số đường dẫn tham khảo:

Fedora/Red Hat Based

http://download.fedoraproject.org/pub/fedora/linux/releases/10/Fedora/i386/os/

Debian/Ubuntu

http://ftp.us.debian.org/debian/dists/etch/main/installer-amd64/

Suse

http://download.opensuse.org/distribution/11.0/repo/oss/

Mandriva

ftp://ftp.uwsg.indiana.edu/linux/mandrake/official/2009.0/i586/

- `--pxe` : Sử dụng giao thức boot PXE để tiến hành cài đặt máy ảo
- `--import` : Bỏ qua phần cài đặt os cho máy ảo, dùng file image có sẵn thông qua tùy chọn `--disk` hoặc `filesystem`.
- `--os-type=OS_TYPE` : Chọn loại hệ điều hành (ví dụ như `linux` hoặc `window`). Mặc định, virt-install sẽ tự động xác định thông qua file cài đặt.
- `--os-variant=OS_VARIANT` : Là một optional command, cho biết xa hơn về loại hệ điều hành (ví dụ như `fedora8` hoặc `winxp`).
  Sử dụng `--os-variant list` để xem tất cả list os
  Một số các os variant thông dụng:

win7 : Microsoft Windows 7
vista : Microsoft Windows Vista
winxp64 : Microsoft Windows XP (x86_64)
winxp : Microsoft Windows XP
win2k8 : Microsoft Windows Server 2008
win2k3 : Microsoft Windows Server 2003
freebsd8 : FreeBSD 8.x
generic : Generic
debiansqueeze : Debian Squeeze
debianlenny : Debian Lenny
fedora16 : Fedora 16
fedora15 : Fedora 15
fedora14 : Fedora 14
mes5.1 : Mandriva Enterprise Server 5.1 and later
mandriva2010 : Mandriva Linux 2010 and later
rhel6 : Red Hat Enterprise Linux 6
rhel5.4 : Red Hat Enterprise Linux 5.4 or later
rhel4 : Red Hat Enterprise Linux 4
sles11 : Suse Linux Enterprise Server 11
sles10 : Suse Linux Enterprise Server
ubuntuoneiric : Ubuntu 11.10 (Oneiric Ocelot)
ubuntunatty : Ubuntu 11.04 (Natty Narwhal)
ubuntumaverick : Ubuntu 10.10 (Maverick Meerkat)
ubuntulucid : Ubuntu 10.04 (Lucid Lynx)
ubuntuhardy : Ubuntu 8.04 LTS (Hardy Heron)

- `boot = BOOTOPTS` : Thiết lập những cài đặt cơ bản trước khi boot. Tùy chọn này cho phép người dùng đặt thứ tự thiết bị boot.
  Ví dụ: `--boot cdrom,fd,hd,network,menu=on`
- **Các tùy chọn lưu dữ liệu**
- `--disk=DISKOPTS` : Thiết lập nơi lưu dữ liệu của máy ảo.
  Format chung: `--disk tuychon1=giatri1,tuychon2=giatri2,...`
- Các tùy chọn đi kèm với `--disk`:
  <ul>
  <li> "path" :  Đường dẫn tới nơi dùng để chứa dữ liệu, thông thường đây là nơi chưa có dữ liệu, KVM sẽ tạo 1 storage mới.</li>
  <li> "pool" : Một pool (nơi chứa các storage) của libvirt đã được tạo sẵn, tại đây, KVM có thể tạo các storage mới. Tùy chọn "size" là bắt buộc</li>
  <li> "device" : Loại ổ đĩa  </li>
  <li> "bus" : Loại bus, có thể là "ide", "scsi", "usb", "virtio" hoặc "xen"</li>
  <li> "perms" : Quyền truy cập ổ đĩa. Mặc định là "rw"(Read/Write). Một số tùy chọn khác là "ro" (Readonly) và "sh" (Shared Read/Write)</li>
  <li> "sparse" : Liệu có bỏ qua việc phân bố toàn bộ dung lượng của storage mới hay không. Người dùng có thể chọn "true" hoặc "false". Mặc định sẽ là "true"</li>
  <li> "cache": Chế độ bộ nhớ cache được sử dụng, người dùng có thể chọn "none", "writethrough" hoặc "writeback"</li>
  <li> "format" : Định dạng file được dùng nếu tạo ổ đĩa, một số định dạng thông dụng là "raw", "qcow2", "vmdk", ...</li>
  <li> "error_policy" : Những hành động mà máy ảo có thể làm trong trường hợp ghi lỗi. Người dùng có thể chọn "none", "stop" hoặc "enospace"</li>
  <li> "serial": Số seri của ổ đĩa ảo</li>
  </ul>
  
- `--filesystem` : Thư mục trên máy chủ được dùng để lưu trữ máy ảo
- `--nodisks` : Không sử dụng ổ cứng nào, thường thì những máy ao này sẽ chạy theo file image hoặc tải từ trên mạng.
- `-f` hoặc `--file` : giống với `--disk path=DISKFILE`
- `-s DISKSIZE`, hoặc `--file-size=DISKSIZE`
- **Các tùy chọn Network**
- `w` hoặc `--network=NETWORK` : Chọn chế độ kết nối tới máy chủ. Có 3 chế độ đó là:
  <ul>
  <li>` bridge=BRIDGE` </li>
  <li>` network=NAME`</li>
  <li>` user`</li>
  </ul>
Một vài tùy chọn khác có thể dùng đi kèm đó là `model` và `mac`

- `nonenetworks` : Không sử dụng card mạng
- `-b` hoặc `--bridge=BRIDGE` : Giống với `--network bridge = bridge_name`

- **Các tùy chọn đồ họa**
- `--graphics` : Đi kèm với các tùy chọn sau
  <ul>
  <li> "type": Loại đồ họa. Có thể chọn "vnc" hoặc "sdl", "spice" và "none" </li>
  <li> "port": nếu người dùng sử dụng vnc hoặc spice thì sẽ phải khai báo port cố định cho dịch vụ này</li>
  <li>Một vài tùy chọn khác như "listen", "password"</li>
  </ul>
  
- **Các tùy chọn ảo hóa**
- `-v` hoặc `--hvm` : Ảo hóa toàn bộ
- `-p` hoặc `--paravirt`: Ảo hóa song song
- `--virt-type` : Chọn hypervisor sẽ cài đặt lên (KVM, WEMU hoặc XEN...)
- **Các tùy chọn thiết bị**
- `--host-device=HOSTDEV`: gán các thiết bị vật lý cho máy ảo
- `--serial` : Thiết bị kết nối cho máy ảo
- `--console` : Kết nối text console giữa máy ảo và máy chủ
- **Một số tùy chọn khác**
- `--atutostart`
- `--print-xml`
- `wait`
- `--force`
- `--check-cpu`
- `-q` hoặc `--quiet`

