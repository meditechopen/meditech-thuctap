# Tìm hiểu file network xml trong KVM

## Mục lục

- [1. Tìm hiểu file network xml](#gioi-thieu)

- [2. Hướng dẫn tạo virtual network từ file xml](#tao-network)

----------

## <a name="gioi-thieu"> 1. Tìm hiểu về file network xml </a>

- Giống như domain, mỗi một virtual network trong kvm sẽ được định nghĩa bằng 1 file có định dạng xml, mặc định lưu tại `/var/lib/libvirt/networks`
- File virtual network mặc định của KVM là `default.xml`, trong file này chứa các thông tin giúp KVM tạo mạng ảo với chế độ mặc định là `NAT`
- Ví dụ về file network xml:

<img src="http://i.imgur.com/hyMBdjX.png">

### Các thành phần chính trong file network xml

- Thẻ không thể thiếu trong file network xml là `network`

**General Metadata**

<img src="http://i.imgur.com/0e8Lsos.png">

- `name` : Tên của virtual network
- `uuid` : uuid của virtual network

**Connectivity**

<img src="http://i.imgur.com/z9BRjPZ.png">

- `bridge` : Bao gồm các tham số 
  <ul>
  <li>name : tên của bridge</li>
  <li>stp : tùy chọn bật hoặc tắt Spanning Tree Protocol</li>
  <li>delay : thiết lập thời gian delay theo giây, mặc định là 0</li>
  <li>macTableManager : Thiết lập quản lí bảng địa chỉ MAC, mặc định sẽ là "kernel"</li>
  </ul>

- `mtu` : tham số bắt buộc là `size` : khai báo kích cỡ của Maximum Transmission Unit (MTU) 
- `domain` : Là thẻ tùy chọn, chỉ được sử dụng với những network có thẻ `<foward>`.
  <ul>
  <li>name : khai báo DNS domain của DHCP server</li>
  </ul>

- `foward` : Thẻ `foward` cho biết mạng ảo sẽ được kết nối với mạng vật lí, nếu không có thẻ này, virtual network sẽ ở trạng thái `isolated`. Tham số `mode` cho biết phương pháp forward dữ liệu ra bên ngoài, mặc định sẽ là `nat`. 

Các method:

- `nat` : Các máy ảo sẽ kết nối ra ngoài internet theo phương thức NAT. Thẻ con `address` sẽ xác định range của địa chỉ cấp cho các máy ảo, bao gồm `start` và `end`. Ngoài `address`, người dùng cũng có thể set port range.

<img src="http://i.imgur.com/v5r8ljX.png">

- `route`: Dữ liệu sẽ được forward tới card vật lí nhưng không thông qua giao thức NAT. Các rules của firewall sẽ được thiết lập để hạn chế việc truyền dữ liệu.
- `open` : giống như `route` nhưng sẽ không có rules nào của firewall được thiết lập.
- `bridge` : sử dụng network bridge, có thể là linux bridge hoặc Open vSwitch.

**Quality of service**

<img src="http://i.imgur.com/4X7PDAP.png">

- `bandwidth` : Thiết lập băng thông
  <ul>
  <li>average : Tốc độ bit trung bình (kilobytes/giây)</li>
  <li>peak : Tham số tùy chọn, xác định tốc độ tối đa mà bridge có thể gửi dữ liệu (kilobytes/giây)</li>
  </ul>

**Static Routes**

<img src="http://i.imgur.com/kVNyu3j.png">

**1. Addressing**

<img src="http://i.imgur.com/JyMwVCK.png">

- `mac` : Địa chỉ mac của bridge, tham số bắt buộc là `address`
- `dns` : DNS server của virtual network. Các thẻ thành phần phụ của thẻ `<dns>` bao gồm `fowarder`, `txt`, `host`, `srv`.
  Thẻ `forwarder` khai báo dns server, có thể khai báo bằng địa chỉ ip (address) hoặc tên domain.
  Thẻ `txt` khai báo bản ghi DNS TXT, nó có 2 giá trị, 1 là `name` sẽ được truy vấn qua dns, 2 là `value` được trả lại khi truy vấn thành công.
  Thẻ `host` sẽ chỉ định những máy nào được sử dụng dịch vụ dns, tham số của nó là `ip`, nó cũng có thể sử dụng thẻ phụ `hostname` để khai báo bằng tên máy.
  Thẻ `server` khai báo bản ghi DNS SRV có 2 tham số bắt buộc là `name` và `protocol`.

- `ip` : Thiết lập địa chỉ ip. Bao gồm các thẻ nhỏ: `dhcp` (bao gồm thẻ range và host) và `tftp`

## <a name=""> 2. Hướng dẫn tạo virtual network từ file xml </a>

- Để tạo virtual network, tiến hành tạo 1 file xml với nội dung như sau:

Ở đây mình muốn tạo 1 mạng hostonly, mình tạo file `isolated.xml`

```sh
<network>
<name>isolated</name>
</network>
```

- Tiến hành define network từ file xml bằng câu lệnh `virsh net-define isolated.xml`

<img src="http://i.imgur.com/YQWwgu0.png">

- Sau khi đã define, bạn có thể sử dụng câu lệnh `virsh net-list --all` để xem network available:

<img src="http://i.imgur.com/ZQStMFe.png">

`isolated` đã xuất hiện, tuy nhiên nó vẫn chưa được active

- Sau khi define, libvirt sẽ tự động add thêm một số thành phần vào file xml bạn vừa tạo và lưu nó tại `/etc/libvirt/qemu/networks/`

<img src="http://i.imgur.com/oBzSYMV.png">

- Bạn có thể chỉnh sửa file xml bằng lệnh `virsh net-edit isolated` . Bên cạnh đó, bạn cũng có thể dùng lệnh `virsh net-dumpxml netname` để xem chi tiết cấu hình trong các file network xml của Linux Bridge.

<img src="http://i.imgur.com/R3i0ZFN.png">

- Sau khi cấu hình xong, ta tiến hành start virtual network vừa tạo bằng câu lệnh 

`virsh net-start isolated`

<img src="http://i.imgur.com/e5vs4IZ.png">

Như vậy, `isolated` đã được start và có thể sử dụng. Dùng virt-manager để xem:

<img src="http://i.imgur.com/UgAqy3B.png">

- Trong trường hợp người dùng muốn thay đổi cấu hình, tiến hành chỉnh sửa trong file xml rồi dùng lệnh `virsh net-destroy` và `virt net-start` để reset lại virtual network.