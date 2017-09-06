# Tìm hiểu tổng quan về iptables

## Mục lục

1. iptables là gì và để làm gì?

2. Sự khác biệt với Firewalld

3. Các khái niệm thường gặp trong iptables. Cấu trúc của iptables

4. Quá trình xử lí gói tin trong iptables

5. Một số tùy chọn phổ biến

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

<img src="">

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

## Các khái niệm thường gặp trong iptables. Cấu trúc của iptables
