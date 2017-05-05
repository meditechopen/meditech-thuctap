# Tìm hiểu NetworkManager và câu lệnh nmcli

## Mục lục

### 1. NetworkManager

### 2. Câu lệnh nmcli

-----

### <a name=""> 1. NetworkManager </a>

- Ở phiên bản gần đây của CentOS và  Red Hat Enterprise Linux (7), networking service mặc định được cung cấp bởi NetworkManager, đây là một công cụ quản lí network tự động và rất hữu ích. Bên cạnh đó, phương thức cấu hình truyền thống vẫn được giữ nguyên.
- Ở những phiên bản trước đó, phương thức cấu hình network mặc định là sử dụng `network script`.
- Bảng dưới đây sẽ miêu tả các công cụ của **NetworkManager** thường được dùng để quản lí networking

| Công cụ | Mô tả                                    |
| ------- | ---------------------------------------- |
| nmtui   | Cung cấp giao diện đơn giản cho NetworkManager |
| nmcli   | Công cụ command-line cho phép người dùng và script tương tác với NetworkManager |

NetworkManager có thể cấu hình các thông số liên quan đến network. Bên cạnh đó nó cũng cung cấp API thông qua D-Bus cho phép các ứng dụng có thể truy vấn và kiểm soát cấu hình cũng như trạng thái của network.

#### Cài đặt NetworkManager

- Đối với CentOS và  Red Hat Enterprise Linux, mặc định NetworkManager đã được cài đặt sẵn. Tuy nhiên với những bản phân phối khác, người dùng cần cài đặt mới có thể sử dụng

``` sh
~]# yum install NetworkManager
```

- NetworkManager daemon mặc định sẽ được cấu hình để khởi động cùng hệ thống. Để check trạng thái của nó, sử dụng câu lệnh:

``` sh
~]$ systemctl status NetworkManager
NetworkManager.service - Network Manager
   Loaded: loaded (/lib/systemd/system/NetworkManager.service; enabled)
   Active: active (running) since Fri, 08 Mar 2013 12:50:04 +0100; 3 days ago
```

- Trong trường hợp NetworkManager ở trạng thái inactive, sử dụng câu lệnh systemctl để kích hoạt và cho phép nó khởi động cùng hệ thống

``` sh
~]# systemctl start NetworkManager
~]# systemctl enable NetworkManager
```

#### Tương tác với NetworkManager

- Người dùng sẽ không tương tác trực tiếp với dịch vụ hệ thống này. Thay vào đó, ta sẽ sử dụng 2 công cụ đó là giao diện và command-line: `nmtui` và `nmcli`.

### <a name=""> 2. Câu lệnh nmcli </a>

- Là một công cụ của NetworkManager, nó cho phép người dùng quản lí và cấu hình network thông qua command-line.
- nmcli được dùng để tạo, hiển thị, xóa, sửa, active hay deactive các kết nối mạng cũng như điều khiển và hiển thị trạng thái các thiết bị mạng thay thế các công cụ truyền thống.
- Cấu trúc cơ bản của câu lệnh nmcli là:

`nmcli OPTIONS OBJECT { COMMAND | help }`

Trong đó, nmcli làm việc với 5 đối tượng (OBJECT) bảo gồm:
1. general: làm việc với các hoạt động, các trạng thái của NetworkManager.
2. networking: toàn bộ việc điều khiển mạng chung.
3. radio: quản lý radio switches.
4. connection: quản lý các kết nối (connections).
5. device: làm việc với các thiết bị mà NetworkManager quản lý.

Các options hay được sử dụng nhất đó là `-t`, `-p` và `-h`. 

Sử dụng `mcli help` để hiển thị ra những trợ giúp:

``` sh
~]$ nmcli help
Usage: nmcli [OPTIONS] OBJECT { COMMAND | help }

OPTIONS
  -t[erse]                                   terse output
  -p[retty]                                  pretty output
  -m[ode] tabular|multiline                  output mode
  -f[ields] <field1,field2,...>|all|common   specify fields to output
  -e[scape] yes|no                           escape columns separators in values
  -n[ocheck]                                 don't check nmcli and NetworkManager versions
  -a[sk]                                     ask for missing parameters
  -w[ait] <seconds>                          set timeout waiting for finishing operations
  -v[ersion]                                 show program version
  -h[elp]                                    print this help

OBJECT
  g[eneral]       NetworkManager's general status and operations
  n[etworking]    overall networking control
  r[adio]         NetworkManager radio switches
  c[onnection]    NetworkManager's connections
  d[evice]        devices managed by NetworkManager
  a[gent]         NetworkManager secret agent or polkit agent
  m[onitor]       monitor NetworkManager changes
```

``` sh
~]$ nmcli general help
Usage: nmcli general { COMMAND | help }

  COMMAND := { status | hostname | permissions | logging }

  status

  hostname [<hostname>]

  permissions

  logging [level <log level>] [domains <log domains>]
```

Sau đây là một vài ví dụ về việc sử dụng nmcli với 5 đối tượng khác nhau:

- Để hiển thị trạng thái chung của NetworkManager sử dụng câu lệnh:

`nmcli general status`

- Để kiểm soát log của NetworkManager:

`nmcli general logging`

- Để hiển thị tất cả kết nối:

`nmcli connection show`

- Để hiển thị những kết nối hiện đang chạy, thêm vào tùy chọn `-a` hoặc `--active`

`nmcli connection show --active`

- Để hiển thị các thiết bị được nhận định bởi NetworkManager và trạng thái của chúng:

`nmcli device status`

- Câu lệnh có thể được rút ngắn lại bằng việc sử dụng kí hiệu cua các tùy chọn, ví dụ câu lệnh: 

`nmcli connection modify id 'MyCafe' 802-11-wireless.mtu 1350`

có thể được rút ngắn thành:

`nmcli con mod MyCafe 802-11-wireless.mtu 1350`

hoặc như hai câu lệnh dưới đây:

`nmcli connection add type ethernet`

`nmcli c a type eth`

#### Bật và tắt cổng sử dụng nmcli

- nmcli có thể bật và tắt bất cử cổng mạng nào

``` sh
nmcli con up id bond0
nmcli con up id port0
nmcli dev disconnect bond0
nmcli dev disconnect ens3
```

Lưu ý: nên sử dụng `nmcli dev disconnect iface-name` thay vì `nmcli con down id id-string` bởi vì việc disconnect  sẽ đặt cổng mạng vào trạng thái `manual`, tức là cổng mạng ấy sẽ không có kết nối tự động trừ khi người dùng  cho phép NetworkManager khởi động lại kết nối.

#### Các options trong nmcli

- `type` : Loại kết nối. Các giá trị có thể sử dụng là: `adsl, bond, bond-slave, bridge, bridge-slave, bluetooth, cdma, ethernet, gsm, infiniband, olpc-mesh, team, team-slave, vlan, wifi, wimax`.

Mỗi một loại đều có một số các tùy chọn đi kèm. Ấn `tab` để xem danh sách các tùy chọn.

- `con-name` : Tên được gán cho cấu hình kết nối. Tên này hoàn toàn khác so với tên của các thiết bị (em1, eth0...). Có thể có rất nhiều cấu hình kết nối cho 1 thiết bị, thay vì phải chỉnh sửa lại cấu hình, bạn chỉ cần tạo sẵn chuyển đổi khi cần.

- `id` : ID của cấu hình kết nối.

#### Thiết lập kết nối sử dụng nmcli

- Để list các kết nối hiện có

``` sh
~]$ nmcli con show
NAME              UUID                                  TYPE            DEVICE
Auto Ethernet     9b7f2511-5432-40ae-b091-af2457dfd988  802-3-ethernet  --
ens3              fb157a65-ad32-47ed-858c-102a48e064a2  802-3-ethernet  ens3
MyWiFi            91451385-4eb8-4080-8b82-720aab8328dd  802-11-wireless wlan0
```

Lưu ý rằng NAME ở đây không phải là tên cổng kết nối dù chúng trông có vẻ giống nhau.

Việc thêm một kết nối ethernet thực chất là tạo ra cấu hình và gán nó cho một thiết bị nào đó. Để xem danh sách thiết bị hiện có:

``` sh
~]$ nmcli dev status
DEVICE  TYPE      STATE         CONNECTION
ens3    ethernet  disconnected  --
ens9    ethernet  disconnected  --
lo      loopback  unmanaged     --
```

#### Thêm kết nối tự động

Để thêm kết nối sử dụng DHCP, sử dụng câu lệnh sau:

`nmcli connection add type ethernet con-name connection-name ifname interface-name`

ví dụ:

``` sh
~]$ nmcli con add type ethernet con-name my-office ifname ens3
Connection 'my-office' (fb157a65-ad32-47ed-858c-102a48e064a2) successfully added.
```

Lưu ý rằng NetworkManager sẽ thiết lập tham số `autoconnect` tự động là `yes` và đồng thời nó cũng sẽ thiết lập trong file cấu hình `/etc/sysconfig/network-scripts/ifcfg-my-office`có `ONBOOT = yes`. 

- Để bật kết nối vừa tạo:

``` sh
~]$ nmcli con up my-office
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/5)
```

Xem lại trạng thái của kết nối

``` sh
~]$ nmcli device status
DEVICE  TYPE      STATE         CONNECTION
ens3    ethernet  connected     my-office
ens9    ethernet  disconnected  --
lo      loopback  unmanaged     --
```

- Để tạo ra kết nối sử dụng DHCP bằng giao diện tương tác:

``` sh
~]$ nmcli con edit type ethernet con-name ens3

===| nmcli interactive connection editor |===

Adding a new '802-3-ethernet' connection

Type 'help' or '?' for available commands.
Type 'describe [<setting>.<prop>]' for detailed property description.

You may edit the following settings: connection, 802-3-ethernet (ethernet), 802-1x, ipv4, ipv6, dcb
nmcli> describe ipv4.method

=== [method] ===
[NM property description]
IPv4 configuration method.  If 'auto' is specified then the appropriate automatic method (DHCP, PPP, etc) is used for the interface and most other properties can be left unset.  If 'link-local' is specified, then a link-local address in the 169.254/16 range will be assigned to the interface.  If 'manual' is specified, static IP addressing is used and at least one IP address must be given in the 'addresses' property.  If 'shared' is specified (indicating that this connection will provide network access to other computers) then the interface is assigned an address in the 10.42.x.1/24 range and a DHCP and forwarding DNS server are started, and the interface is NAT-ed to the current default network connection.  'disabled' means IPv4 will not be used on this connection.  This property must be set.

nmcli> set ipv4.method auto
nmcli> save
Saving the connection with 'autoconnect=yes'. That might result in an immediate activation of the connection.
Do you still want to save? [yes] yes
Connection 'ens3' (090b61f7-540f-4dd6-bf1f-a905831fc287) successfully saved.
nmcli> quit
~]$
```

#### Tạo kết nối tĩnh

- Để tạo một kết nối ethernet với cấu hình IPv4 tĩnh, sử dụng câu lệnh sau:

``` sh
nmcli connection add type ethernet con-name connection-name ifname interface-name ip4 address gw4 address
```

Note: Nếu là IPv6, sử dụng `ip6` và `gw6`. Mặc định NetworkManager sẽ thiết lập 2 tham số `ipv4.method` thành `manual` và `connection.autoconnect` thành `yes`

Ví dụ: 

``` sh
~]$ nmcli con add type ethernet con-name test-lab ifname ens9 ip4 10.10.10.10/24 \
gw4 10.10.10.254
```

``` sh
~]$ nmcli con add type ethernet con-name test-lab ifname ens9 ip4 10.10.10.10/24 \
gw4 10.10.10.254 ip6 abbe::cafe gw6 2001:db8::1
Connection 'test-lab' (05abfd5e-324e-4461-844e-8501ba704773) successfully added.
```

- Để thiết lập địa chỉ dns, sử dụng câu lệnh:

`~]$ nmcli con mod test-lab ipv4.dns "8.8.8.8 8.8.4.4"`

Lưu ý rằng nó sẽ thay thế hoàn toàn những địa chỉ đã được set trước đó, nếu bạn chỉ muốn thêm địa chỉ dns vào, sử dụng tiền tố `+`:

`~]$ nmcli con mod test-lab +ipv4.dns "8.8.8.8 8.8.4.4"`

- Để bật kết nối vừa tạo, sử dụng câu lệnh:

``` sh
~]$ nmcli con up test-lab ifname ens9
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/6)
```

- Xem thông tin trạng thái của thiết bị và kết nối:

``` sh
~]$ nmcli device status
DEVICE  TYPE      STATE      CONNECTION
ens3    ethernet  connected  my-office
ens9    ethernet  connected  test-lab
lo      loopback  unmanaged  --
```

- Để xem thông tin chi tiết của kết nối vừa tạo:

``` sh
~]$ nmcli -p con show test-lab
===============================================================================
                     Connection profile details (test-lab)
===============================================================================
connection.id:                          test-lab
connection.uuid:                        05abfd5e-324e-4461-844e-8501ba704773
connection.interface-name:              ens9
connection.type:                        802-3-ethernet
connection.autoconnect:                 yes
connection.timestamp:                   1410428968
connection.read-only:                   no
connection.permissions:                 
connection.zone:                        --
connection.master:                      --
connection.slave-type:                  --
connection.secondaries:                 
connection.gateway-ping-timeout:        0
[output truncated]
```

- Để tiến hành cấu hình kết nối ethernet tĩnh sử dụng giao diện tương tác:

``` sh
~]$ nmcli con edit type ethernet con-name ens3

===| nmcli interactive connection editor |===

Adding a new '802-3-ethernet' connection

Type 'help' or '?' for available commands.
Type 'describe [>setting<.>prop<]' for detailed property description.

You may edit the following settings: connection, 802-3-ethernet (ethernet), 802-1x, ipv4, ipv6, dcb
nmcli> set ipv4.addresses 192.168.122.88/24
Do you also want to set 'ipv4.method' to 'manual'? [yes]: yes
nmcli>
nmcli> save temporary
Saving the connection with 'autoconnect=yes'. That might result in an immediate activation of the connection.
Do you still want to save? [yes] no
nmcli> save
Saving the connection with 'autoconnect=yes'. That might result in an immediate activation of the connection.
Do you still want to save? [yes] yes
Connection 'ens3' (704a5666-8cbd-4d89-b5f9-fa65a3dbc916) successfully saved.
nmcli> quit
~]$
```

- Để cấu hình định tuyến tĩnh:

`~]# nmcli connection modify eth0 +ipv4.routes "192.168.122.0/24 10.10.10.1"`

hoặc dùng giao diện tương tác :

``` sh
~]$ nmcli con edit type ethernet con-name ens3

===| nmcli interactive connection editor |===

Adding a new '802-3-ethernet' connection

Type 'help' or '?' for available commands.
Type 'describe [>setting<.>prop<]' for detailed property description.

You may edit the following settings: connection, 802-3-ethernet (ethernet), 802-1x, ipv4, ipv6, dcb
nmcli> set ipv4.routes 192.168.122.0/24 10.10.10.1
nmcli>
nmcli> save persistent
Saving the connection with 'autoconnect=yes'. That might result in an immediate activation of the connection.
Do you still want to save? [yes] yes
Connection 'ens3' (704a5666-8cbd-4d89-b5f9-fa65a3dbc916) successfully saved.
nmcli> quit
~]$
```

#### Thêm kết nối Wi-fi

- Để xem các Wi-Fi access points hiện có:

``` sh
~]$ nmcli dev wifi list
  SSID            MODE  CHAN  RATE     SIGNAL  BARS  SECURITY
  FedoraTest     Infra  11    54 MB/s  98      ▂▄▆█  WPA1
  Red Hat Guest  Infra  6     54 MB/s  97      ▂▄▆█  WPA2
  Red Hat        Infra  6     54 MB/s  77      ▂▄▆_  WPA2 802.1X
* Red Hat        Infra  40    54 MB/s  66      ▂▄▆_  WPA2 802.1X
  VoIP           Infra  1     54 MB/s  32      ▂▄__  WEP
  MyCafe         Infra  11    54 MB/s  39      ▂▄__  WPA2
```

- Để thêm kết nối wi-fi:

``` sh
~]$ nmcli con add con-name MyCafe ifname wlan0 type wifi ssid MyCafe \
ip4 192.168.100.101/24 gw4 192.168.100.1
```

- Để thay đổi mật khẩu WPA2 cho wi-fi "caffeine" : 

``` sh
~]$ nmcli con modify MyCafe wifi-sec.key-mgmt wpa-psk
~]$ nmcli con modify MyCafe wifi-sec.psk caffeine
```

- Thay đổi trạng thái của wi-fi:

`~]$ nmcli radio wifi [on | off ]`

- Để thay đổi một số thông số, ví dụ như `mtu`:

``` sh
~]$ nmcli connection show id 'MyCafe' | grep mtu
802-11-wireless.mtu:                     auto
~]$ nmcli connection modify id 'MyCafe' 802-11-wireless.mtu 1350
~]$ nmcli connection show id 'MyCafe' | grep mtu
802-11-wireless.mtu:                     1350
```

**Link tham khảo:**

1. https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Networking_Guide/sec-Using_the_NetworkManager_Command_Line_Tool_nmcli.html
2. https://docs.fedoraproject.org/en-US/Fedora/22/html/Networking_Guide/sec-Using_the_NetworkManager_Command_Line_Tool_nmcli.html
3. https://1hosting.com.vn/he-dieu-hanh-centos-7-co-gi-moi-va-khac-voi-centos-6-phan-6-nmcli/
4. https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Networking_Guide/sec-Introduction_to_NetworkManager.html