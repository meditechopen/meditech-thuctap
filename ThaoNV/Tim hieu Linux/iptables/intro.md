# Tìm hiểu tổng quan về iptables

## Mục lục

1. iptables là gì và để làm gì?

2. Sự khác biệt với Firewalld

3. Các khái niệm thường gặp trong iptables.

4. Cách hoạt động của iptables

5. Quá trình xử lí gói tin trong iptables

6. Một số tùy chọn phổ biến

-----------

## 1. iptables là gì và để làm gì?

iptables là firewall software cơ bản được dùng nhiều nhất trong Linux, được dùng để tạo tường lửa cho máy linux của bạn, nó có các chức năng lọc gói tin, nat gói tin qua đó để giúp làm nhiệm vụ bảo mật thông tin cá nhân tránh mất mát thông tin và áp dụng nhưng chính sách đổi với người sử dụng. Iptables hoạt động bằng cách giao tiếp với packet filtering hooks trong Linux kernel's networking stack. Các hooks này là netfilter framework.

Netfilter là packet filtering framework bên trong Linux kernel 2.4.x và các phiên bản tiếp theo. Đây là phiên bản nâng cấp của  ipchains cũng như ipfwadm trong những phiên bản linux kernel 2.0.x và 2.2.x. netfilter là một danh sách các hooks nằm bên trong Linux kernel, nó cho phép kernel modules thực hiện các tác vụ đối với network stack.

iptables đơn giản chỉ là một danh sách các rules được tổ chức theo dạng bảng. Mỗi một rule chứa một loạt các classifiers (iptables matches) và một connected action (iptables target).

Các firewall software khác chỉ đơn giản là sử dụng lại cơ chế hoặc cung cấp GUI interface để người dùng thao tác với iptables.

**Các tính năng chính**

- stateless packet filtering (IPv4 and IPv6)
- stateful packet filtering (IPv4 and IPv6)
- all kinds of network address and port translation, e.g. NAT/NAPT (IPv4 and IPv6)
- flexible and extensible infrastructure
- multiple layers of API's for 3rd party extensions

`stateful filter` sẽ giữ 1 danh sách các connections đã được thiết lập, nó được cho là có hiệu quả hơn trong việc phát hiện các gói tin giả mạo và có thể thực hiện một loạt các functions của IPsec như tunnels và encryption.

`stateless filter` không giữ danh sách ấy, mọi packet đều được process một cách độc lập với nhau. Nó được cho là sẽ xử lí gói tin nhanh hơn.

**Người dùng có thể làm gì với iptables?**

- Xây dựng một hệ thống tường lửa cho hệ thống dựa trên stateless và stateful packet filtering
- Triển khai một cụm cluster stateless và stateful firewall
- Dùng NAT và masquerading để chia sẻ kết nối internet
- Dùng NAT để xây dựng transparent proxies
- Thực hiệm một số tác vụ với packet như thay đổi TOS/DSCP/ECN trong IP header


## 2. Sự khác biệt giữa iptables với Firewalld
Firewalld là phiên bản firewall mới mặc định được sử dụng trong các phiên bản RHEL 7 để thay thế cho interface của iptables. Về bản chất, nó vẫn kết nối tới netfilter kernel code. Firewalld tập trung chủ yếu vào việc cải thiện vấn đề quản lí rules bằng cách cho phép thay đổi cấu hình mà không bị mất các kết nối hiện tại.

Hình dưới đây mô tả tổng quan mối quan hệ giữa iptables và firewalld

<img src="http://i.imgur.com/Pu5sOu7.png">

Như vậy cả hai đều sử dụng iptables tool để giao tiếp với kernel packet filter.

Tuy vậy, trong khi iptables service lưu cấu hình tại `/etc/sysconfig/iptables` và `/etc/sysconfig/ip6tables` thì firewalld lại lưu nó dưới dạng một loạt các file XML trong `/usr/lib/firewalld/` và `/usr/lib/firewalld/`. Lưu ý: `/etc/sysconfig/iptables` không tồn tại nếu chưa cài đặt iptables service bởi mặc định firewalld mới là dịch vụ được cài đặt.

Đối với iptables, mỗi một thay đổi đồng nghĩa với việc hủy bỏ toàn bộ các rules cũ và load lại một loạt các rules mới trong file `/etc/sysconfig/iptables`. Trong khi đó với firewalld, chỉ những thay đổi mới được applied. Vì thế firewalld có thể thay đổi cài đặt trong thời gian runtim mà không làm mât bất cứ kết nối nào.

Để em các iptables rules mà firewalld tạo ra, sử dụng câu lệnh sau:

`iptables-save`

**Hướng dẫn sử dụng iptables thay cho firewalld**

Bạn vẫn có thể sử dụng iptables tại các phiên bản CentOS/RHEL7 tuy nhiên chỉ nên dùng 1 cái (hoặc firewalld hoặc iptables).

- Cài đặt packages

`yum install -y iptables-services`

- Disable Firewalld service

`systemctl mask firewalld`

- Cho phép iptables service khởi động cùng hệ thống

`systemctl enable iptables`

- Stop Firewalld service

`systemctl stop firewalld`

- Bật iptables service

`systemctl start iptables`

**Một số lưu ý đối với iptables, firewalld và ufw**

- Đối với CentOS/RHEL 7, khi bạn tắt firewalld (mặc định) hoặc tắt iptables service. Các iptables rules cũng sẽ biến mất -> Một số service hoạt động dựa trên nó như network default của KVM (LB) cũng sẽ bị ảnh hưởng.
- Đối với Ubuntu/Debian, ufw là firewall mặc định. Tuy nhiên khi disable ufw, các iptables rules không bị mất đi. Mặc dù vậy, để có thể lưu lại các iptables rules đã cấu hình, bạn cần cài thêm gói `iptables-persistent`

## 3. Các khái niệm thường gặp trong iptables

iptables định nghĩa ra 5 "hook points" trong quá trình xử lí gói tin của kernel: PREROUTING, INPUT, FORWARD, POSTROUTING và OUTPUT. Các built-int chains được gán vào các hook points này, bạn có thể add một loạt các rules cho mỗi hook points. Lưu ý: Chains không thực sự nằm trong một table và table cũng không chỉ chứa một chain.

Hình dưới đây mô tả quá trình gói tin đi qua hệ thống để NAT

<img src="http://i.imgur.com/GpNoh0x.png">

Hình dưới đây mô tả quá trình gói tin đi qua hệ thống để filter

<img src="http://i.imgur.com/3phtTDm.png">

Hình dưới đây mô tả quá trình gói tin đi qua hệ thống để mangle

<img src="http://i.imgur.com/wpfICOs.png">

| Hook | Cho phép bạn xử lí các packet ...|
|------|------------------------------|
| FORWARD | có đích là một server khác nhưng không được tạo từ server của bạn. Chain này là cách cơ bản để cấu hình server của bạn để route các request tới một thiết bị khác |
| INPUT | có địa chỉ đích đến là server của bạn |
| OUTPUT | được tạo bởi server của bạn |
| PREROUTING | vừa mới tiến vào từ network interface. Nó sẽ được thực thi trước khi quá trình routing diễn ra, thường dùng cho DNAT (destination NAT) |
| POSTROUTING | đi ra ngoài hoặc được forward sau khi  quá trình routing  hoàn tất, chỉ trước khi nó tiến vào đường truyền, thường dùng cho SNAT (source NAT) |

**Tables**

Iptables có 3 bảng chính: filter, mangle, và nat.

| Table | Description |
|-------|-------------|
| nat | dùng để NAT, thường dựa vào địa chỉ nguồn hoặc đích. Nó có 3 chains là:  OUTPUT, POSTROUTING, và PREROUTING |
| filter | Dùng để thiết lập policies cho các traffic vào, qua và ra khỏi hệ thống. iptables lấy đây làm table default, nếu bạn không khai báo bất cứ thông tin gì về table trong câu lệnh, iptables sẽ mặc định áp dụng nó cho filter table. Nó bao gồm các chains: FORWARD, INPUT, và OUTPUT |
| mangle | Dùng để thay đổi một số thông tin cụ thể của packet. Nó có các chains là : ORWARD, INPUT, OUTPUT, POSTROUTING, và PREROUTING |

**Chains**

Mặc định thì mỗi table đều có chains trống. Bạn cũng có thể tự tạo chain cho mình. Mỗi chain sẽ có policy, policy này sẽ quyết định trạng thái của gói tin truong trường hợp nó không match với bất cứ rules nào. Policy chỉ cso 2 target là ACCEPT và DROP, mặc định là ACCEPT. Các chain được tạo bởi user sẽ có policy mặc định và không thay đổi được có target là RETURN.

**Rules**

iptables rule bao gồm một hoặc nhiều tiêu chuẩn để xác định packets nào sẽ phải chịu ảnh hưởng và target để xác định hành động nào sẽ được thực thi với packet ấy.

Cả hai yếu tố của rules đó là match và target đều là tùy chọn.
Như vậy, cấu trúc của iptables như sau: iptables -> Tables -> Chains -> Rules

<img src="http://i.imgur.com/POf5Fvx.png">

**Matches**

Có vô số các match có thể sử dụng với iptables. Ví dụ như Internet Protocol (IP) matches (protocol, source, hoặc destination address).

**Targets**

Targets được dùng để xác định hành động sẽ được thực thi đối với các packets "match" với rules và nó cũng dùng để xác định chain policies. Hiện có 4 targets mặc định đó là:

| Target | Description |
|--------|-------------|
| ACCEPT | Cho phép packet đi đến quá trình xử lí tiếp theo. Dừng việc traverse ở chain hiện tại |
| DROP | Không cho phép tiếp tục quá trình xử lí, không check đối với bất cứ rules, chains, tables nào thêm. Để gửi feedback trả lại sender, bạn nên dùng REJECT thay cho DROP |
| QUEUE | Gửi packet tới userspace |
| RETURN | Đối với rule ở user-defined chain, không tiếp tục xử lí chain này, quay lại chain có chain đang xử lí là target. Đối với built-in
chain, không tiếp tục xử lí gói tin và sử dụng policy |

## 4. Cách hoạt động của iptables

Iptables hoạt động bằng cách so sánh network traffic với một danh sách các rules. Rule định nghĩa các tính chất mà packet cần có để match với rule kèm theo những hành động sẽ được thực thi với những matching packets.

Có rất nhiều các options để thiết lập rule sao cho nó match với packets đi qua như protocol, ip, interface... Khi một packet match, target được thực thi. Target có thể là quyết định cuối cùng áp dụng đối với packet ví dụ như ACCEPT hoặc DROP. Nó cũng có thể chuyển packet tới chain khác để xử lí hoặc đơn giản log lại.

Các rules này được gộp lại thành nhóm gọi là chains. Chains là danh sách các rules và nó sẽ được check lần lượt. Khi một packet match với 1 rules, nó sẽ được thực thi với hành động tương ứng và không cần phải check với các rules còn lại.

Mỗi chain có thể có một hoặc nhiều rule nhưng mặc định nó sẽ có 1 policy. Trong trường hợp packets không match với bất cứ rules nào, policy sẽ được thực thi, bạn có thể accept hoặc drop nó.

## 5. Quá trình xử lí gói tin trong iptables
