# Tìm hiểu bonding

## Mục lục

1. Giới thiệu về bonding

2. Các bonding options

3. Một số ghi chép về network bonding

--------

## 1. Giới thiệu về bonding

Linux bonding driver cung cấp phương pháp để "hợp nhất" nhiều network interface lại thành 1 đường logical "bond" interface duy nhất. Các thuộc tính của đường bond này sẽ phụ thuộc vào các mode hay nói cách khác mode cung cấp các dịch vụ cho bond. Bonding driver bắt đầu được sử dụng kể từ bản kernel 2.0.

Hầu hết các distro ngày nay đã được tích hợp sẵn bonding driver. Nếu distro của bạn chưa có, bạn sẽ phải complie bonding.

## 2. Các bonding driver options

Các tùy chọn cho bonding driver được đưa vào bonding module như là các parameters ở giai đoạn ban đầu khi boot OS hoặc cũng có thể được đưa vào sau thông qua sysfs.

Dưới đây là các bonding driver parameters hiện hành:

- active_slave:

Chỉ ra active slave cho mode hỗ trợ nó (active-backup, balance-alb và balance-tlb). Các giá trị có thể là bất cứ interface nào hoặc cũng có thể để trống, lúc này active slave sẽ được chọn tự động.

- ad_actor_sys_prio :

Parameters này chỉ được dùng ở mode 802.3ad. Nó chỉ ra độ ưu tiên cho hệ thống, giá trị có thể chọn từ 1-65535, mặc định sẽ là 65535.

- ad_actor_system:

Parameters này cũng chỉ được dùng ở mode 802.3ad. Nó chỉ ra địa chỉ MAC cho actor trong AD system.

- ad_select :

Chỉ ra phần lựa chọn kiểu nối trong mode 802.3ad, các giá trị có thể là:

  - stable or 0 :

  Là giá trị mặc định, nó sẽ chọn aggregator theo bandwith lớn nhất. Nó sẽ chỉ được chọn lại nếu tất cả các slave của aggregator đang active bị down hoặc aggregator không có slaves.

  - bandwidth or 1 :

  Cũng lựa chọn theo bandwith lớn nhất. Tuy nhiên nó sẽ chọn lại nếu slave được add hoặc remove khỏi bond, các thay đổi của slave cũng như nếu admin muốn thay đổi.

  - count or 2 :

  active aggregator được chọn theo số lượng ports lớn nhất.

- ad_user_port_key :

Trong ad system, port-key có 3 phần:

Bits   Use
00     Duplex
01-05  Speed
06-15  User-defined

- all_slaves_active :

Tùy chọn cho phép duplicate frames được sử dụng hay không, mặc định thì bonding sẽ drop duplicate frames, giá trị mặc định là 0.

- arp_interval :

ARP monitor làm việc theo chu kì để check slave xem nó gửi hay nhận nhưng traffic gần nhất. Tùy chọn này cho phép kích hoạt ARP monitoring, mặc định nó sẽ bị disabled, giá trị mặc định cũng là 0.

- arp_ip_target :

Chỉ ra địa chỉ IP sẽ dược dùng làm ARP monitoring khi mà giá trị `arp_interval` > 0.

- arp_all_targets :

số lượng arp_ip_targets được kết nối tới để ARP monitor kiểm tra slave nào đang bật . Tùy chọn này chỉ có ảnh hưởng đối với active-backup mode.

- downdelay:

Xác định thời gian theo  milliseconds để đợi trước khi hủy một slave sau khi nó bị down.

- fail_over_mac :

Xác định xem liệu active-backup mode có được set tất cả các slave có cùng 1 địa chỉ MAC không, ngoài ra nó cũng quản lí địa chỉ MAC cho bond khi được bật.

  - none hoặc 0 : Set tất cả các slaves có cùng địa chỉ mac. đay là giá trị mặc định.
  - active hoặc 1 :  địac chỉ MAC của bond sẽ là địa chỉ MAC của slave đang active, MAC của slave không thay đổi mà chỉ có MAC của bon thay đổi sau mỗi lần chuyển qua lại giữa các slaves. Tuy nhiên nó đòi hỏi các thiết bị trong hệ thông phải thường xuyên cập nhật bảng địa chỉ MAC
  - follow or 2 : địa chỉ MAC của slave đầu tiên sẽ được add cho bond.

Giá trị mặc định là none, trừ khi slave đầu tiên không thể thay đổi địa chỉ MAC của nó.

- max_bonds :

Số lượng bonding devices tạo ra. Ví dụ nếu max_bonds là 3 và bonding driver chưa được load thì bond0, bond1 và bond2 sẽ được tạo. Giá trị mặc định là 1, giá trị 0 sẽ load bonding nhưng không tạo ra device.

- miimon :

Chỉ ra khoảng thời gian kiểm tra MII link trong milliseconds. Trạng thái của link sẽ được cập nhật để phát hiện link failures.

- min_links :

Số lượng nhỏ nhất của links buộc phải được active trước khi bond device được bật.

- mode : chỉ ra mode mà bonding chạy, xem thêm [tại đây]()

- packets_per_slave :

Số lượng packets để truyền qua slave trước khi chuyển qua cái tiếp theo. Khi set bằng 0 thì slave sẽ được chọn random. Tùy chọn này chỉ có tác dụng ở mode balance-rr.

- primary :

Các card mạng sẽ được lựa chọn để làm primary device. Card mạng nào được chọn thì nó sẽ luôn là active slave nếu thời điểm đó nó available. Tùy chọn này chỉ có tác dụng ở mode 1, 5, và 6.

- primary_reselect :

Chỉ ra làm thế nào để chọn primary slave làm active slave khi mà active slave hiện tại bị down.
  - always or 0 (default) : Primary slave sẽ trở thành active slave bất cứ khi nào nó quay trở lại.
  - better or 1 : primary slave sẽ trở thành active slave khi nó quay lại và tốc độ của slave này lớn hơn tốc độ của active slave hiện tại.
  - failure or 2: primary slave trở thành active slave chỉ khi slave hiện tại bị down và primary slave đang up.

- updelay :

Số thời gian (theo milliseconds) để đợi trước khi kích hoạt slave.

- resend_igmp :

Số lượng IGMP membership reports được gửi đi sau khi mà failover event diễn ra.

## 3. Một số ghi chép về network bonding

- Tùy chọn `STARTMODE` trong file cấu hình bonding có thể chọn:
  - onboot: Khởi động theo HĐH
  - manual: chỉ khởi động khi bạn gọi đến nó
  - off hoặc ignore: cấu hình bị ignore

- Tùy chọn `BONDING_MASTER='yes'` chỉ ra đó là bonding master device
- Trong tùy chọn `BONDING_MODULE_OPTS` không nên đưa vào `max_bonds` bởi nó làm hệ thống confuse trong trường hợp bạn có nhiều bond.
- Để tắt bond device, trước tiên phải làm nó down sau đó mới remove driver modules.

``` sh
# ifconfig bond0 down
# rmmod bonding
```

- Bạn có thể dùng Sysfs để cấu hình bonding.
  - Nếu bạn muốn thêm bond `foo`

  `# echo +foo > /sys/class/net/bonding_masters`

  - Nếu muốn gỡ bond `bar`

  `# echo -bar > /sys/class/net/bonding_masters`

  - Xem các bond hiện tại

  `# cat /sys/class/net/bonding_masters`

  - Thêm slave eth0 vào bond0

  ```sh
  # ifconfig bond0 up
  # echo +eth0 > /sys/class/net/bond0/bonding/slaves
  ```
  - gỡ slave eth0 từ bond0

  `# echo -eth0 > /sys/class/net/bond0/bonding/slaves`

  - Kích hoạt tùy chọn miinon với giá trị 1 giây:

  `# echo 1000 > /sys/class/net/bond0/bonding/miimon`

- Mỗi một bonding devices có 1 file read-only trong thư mục `/proc/net/bonding`. Nội dung file chứa thông tin cấu hình, options và trạng thái của các slaves.


**Link tham khảo:**

https://www.kernel.org/doc/Documentation/networking/bonding.txt
