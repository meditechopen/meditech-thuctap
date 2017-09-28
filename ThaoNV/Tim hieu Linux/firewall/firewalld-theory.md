# Lý thuyết về firewalld

## Mục lục

[1.  firewalld là gì và để làm gì?](#1)

[2. Lợi ích khi sử dụng firewalld](#2)

[3. Các tính năng chính của firewalld](#3)

[4. Cơ chế hoạt động của firewalld](#4)

[5. Các câu lệnh của firewalld](#5)

------------------

<a name="1"></a>
## 1. firewalld là gì và để làm gì?

firewalld là userland interface mới dành cho các phiên bản distro linux gần đây, nó thay thế cho iptables interface và cũng kết nối tới netfilter kernel code. Mục đích chính của nó là cải thiện việc quản lý rules bằng cách cho phép thay đổi các cấu hình mà các kết nối hiện tại không bị ngắt.

Firewalld cung cấp cơ chế quản lí dynamically với sự hỗ trợ dành cho network/firewall zones cho phép người dùng định nghĩa mức độ "tin tưởng" đối với các kết nối.

<a name="2"></a>
## 2. Lợi ích khi sử dụng firewalld

- Các thay đổi có thể được thực hiện ngay lập tức mà không cần phải restart daemon or service

- Với việc sử dụng D-Bus interface, các dịch vụ, ứng dụng, người dùng rất dễ dàng để thực hiện các cấu hình đối với firewall.

- Việc phân chia ra các cấu hình thành 2 loại là runtime và permanent khiến chúng ta dễ dàng thực hiện kiểm tra thử. Cấu hình runtime chỉ có tác dụng cho tới lần reload service tiếp theo hoặc khởi động lại hệ thống. Trong khi đó các cấu hình permanent sẽ được load lại một lần nữa.

<a name="3"></a>
## 3. Các tính năng chính của firewalld

- Complete D-Bus API
- IPv4, IPv6, bridge and ipset support
- IPv4 and IPv6 NAT support
- Firewall zones
- Predefined list of zones, services and icmptypes
- Simple service, port, protocol, source port, masquerading, port forwarding, icmp filter, rich rule, interface and source address handlig in zones
- Simple service definition with ports, protocols, source ports, modules (netfilter helpers) and destination address handling
- Rich Language for more flexible and complex rules in zones
- Timed firewall rules in zones
- Simple log of denied packets
- Direct interface
- Lockdown: Whitelisting of applications that may modify the firewall
- Automatic loading of Linux kernel modules
- Integration with Puppet
- Command line clients for online and offline configuration
- Graphical configuration tool using gtk3
- Applet using Qt4

**Các distro đang sử dụng firewalld**

- RHEL 7, CentOS 7
- Fedora 18 và 1 vài distro khác

**Các ứng dụng và thư viện đang support firewalld**

- NetworkManager
- libvirt
- docker
- fail2ban

<a name="4"></a>
## 4. Cơ chế hoạt động của firewalld

**Concepts**

firewalld có 2 layer đó là core layer và D-Bus:

- Core layer chịu trách nhiệm xử lí các cấu hình và các backends như iptables, ip6tables, ebtables, ipset and the module loader.

- D-Bus interface cho phép người dùng có thể thay đổi và tạo ra các cấu hình firewall mới. Nó được sử dụng bởi tất cả những công cụ mà firewalld đưa ra như firewall-cmd, firewallctl, firewall-config and firewall-applet.

<img src="https://i.imgur.com/CEkTaXC.png">

- firewall-offline-cmd không nói chuyện trực tiếp với firewall nhưng nó có thể thực hiện thay đổi cấu hình bằng các file config kết nối trực tiếp với firewalld core thông qua IO handlers. Công cụ này không được khuyến khích sử dụng khi firewalld đang chạy.

- firewalld thường đi kèm với NetworkManager. Tất nhiên nó không phụ thuộc vào nhau nhưng nếu không có NetworkManager thì firewalld sẽ bị hạn chế một số tính năng ví dụ như nếu có sự thay đổi về tên của network device thì firewalld sẽ không thể nhận biết được, khi đó thì interface sẽ không thể được add vào zone một cách tự động.

**Thư mục chứa cấu hình**

firewalld có 2 thư mục chứa cấu hình:

- `/usr/lib/firewalld` là thư mục chứa cấu hình mặc định
- `/etc/firewalld` là thư mục chứa các cấu hình của hệ thống cũng như người dùng. File này sẽ overload các file cấu hình mặc định

- Các cấu hình của firewalld được lưu dưới dạng file xml
- File `firewalld.conf` được lưu trong `/etc/firewalld` cung cấp cấu hình cơ bản cho firewalld. Sau đâu là các giá trị mặc định của firewalld:
  - DefaultZone=public
  - MinimalMark=100
  - CleanupOnExit=yes
  - Lockdown=no (nếu được set bằng yes thì các kết nối tới D-bus sẽ bị limit theo file lockdown-whitelist.xml)
  - LogDenied=off

<a name="5"></a>
## 5. Các câu lệnh của firewalld

Tham khảo [tại đây](https://fedoraproject.org/wiki/Firewalld?rd=FirewallD#Working_with_firewalld)

**Link tham khảo**

http://www.firewalld.org/documentation/
