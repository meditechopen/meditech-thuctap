# Tìm hiểu cơ chế làm việc của yum và apt-get install

## Mục lục

1. Các cách cài package thông dụng trong Linux

2. Yum và Rpm

3. Apt-get và dpkg

------------

## 1. Các cách cài package thông dụng trong Linux

Thông thường người dùng Linux thường sử dụng 2 cách để cài packages. Cách đầu tiên và cũng là đơn giản nhất đó là sử dụng yum và apt-get. Đây là 2 công cụ được dùng để quản lí các gói phần mềm trên server của bạn. Nó sẽ tự động cài đặt các gói phụ trợ mà không cần phải khai báo thêm. Ưu điểm của nó là thuận tiện và dễ dàng trong việc cài đặt cũng như update packages.

Cách thứ 2 thường được sử dụng đó là rpm và dpkg. Đây là những công cụ cấp thấp để cài các packages, muốn sử dụng nó thì các bạn phải tải các packages này. Bạn sẽ phải khai báo các gói phụ thuộc. Ưu điểm của nó là bạn có thể kiểm soát được phiên bản mà mình mong muốn.

Các packages được đặt trên những repos, mặc định thì yum và apt cũng đã có khá nhiều repos thông dụng nhưng sẽ có những packages không có sẵn, bạn sẽ phải khai báo repos cho nó mới có thể cài đặt.

## 2. Yum và Rpm

Như đã giới thiệu, yum là một công cụ quản lý và cài đặt phần mềm rất tiện dụng cho các hệ thống Red Hat Linux. Nó có thể cài đặt các gói mới hoặc cập nhật các gói đã tồn tại trên hệ thống một cách tự động và tiện lợi thông qua vài dòng lệnh đơn giản. YUM được viết tắt từ “Yellowdog Update Modified” được phát triển bởi Duke University. Lệnh này được hỗ trợ trên Red Hat Enterprise Linux (RHEL) và các bản phân phối của nó bao gồm : Red Hat Enterprise Linux, Fedora, CentOS

**Một số lệnh cơ bản với Yum**

- `yum check-update` hoặc `yum list updates` : dùng để cập nhật thông tin và danh sách các gói phần mềm được hỗ trợ cài đặt bằng lệnh YUM
- `yum list all` hoặc `yum list` : dùng để liệt kê tất cả các gói phần mềm có thể được cài đặt bằng lệnh YUM và những phần mềm đã được cài đặt
- `yum list installed` : lệnh liệt kê tất cả các phần mềm đã được cài đặt
- `yum list available` : liệt kê tất cả các phần mềm có thể cài đặt bằng lệnh YUM
- `yum info` : xem thông tin của gói phần mềm
- `yum search <tên packages>` : tìm kiếm gói phần mềm được hỗ trợ cài đặt bằng yum
- `yum install` :  cài đặt gói phần mềm
- `yum update` : kiểm tra và cập nhật phiên bản mới nhất của gói phần mềm.
- `yum remove` : gỡ bỏ và xoá gói phần mềm do bạn chỉ định
- `yum clean all` : xóa cache

RPM (Red Hat Package Management): Đây là một trong những dạng gói phần mềm dễ dùng nhất. Các tập tin RPM thường có kết thúc bằng ‘.rpm’.

**Một số lệnh cơ bản với rpm**

- `rpm -Uvh <tập tin rpm>` : cài đặt gói rpm (thực hiện với root)
- `rpm -e <tên gói>`  : gỡ cài đặt
- `rpm -qa​` : Liệt kê danh sách tất cả các gói đã cài đặt
- `rpm -q <tên gói>​` : Kiểm tra gói <tên gói>có cài đặt chưa

**Những lưu ý về yum và yum cache**

repo = viêt tắt của repositories = kho chứa. Yum repo là kho chứa các gói phần mềm theo kiểu của yum đặt trên một server ngoài Internet, cho phép dùng lệnh yum để cập nhật, cài đặt hay tìm kiếm. Nó giống như Apple Store (trên iPhone iPad) hay Google Play Store (Android), nơi tác giả của distro đưa lên rất nhiều các gói phần mềm đã được dịch sẵn và làm sẵn, thử trước rồi. khi cần chỉ tìm kiếm cài đặt hay update không phải build compile từ nguồn hay xử lý các vấn đề tương thích gì phức tạp.

Thực chất khi cài đặt, server sẽ tải các gói có định dạng `*.rpm` về. Các gói này sau khi được download và cài đặt lên sẽ bị xóa hết, không lưu như bên Ubuntu! Muốn giữ lại các gói yum tải về, sửa file config:

`/etc/yum.conf`

`keepcache=1​`

Lúc này, khi tải các gói về thì nó sẽ được lưu lại, để xóa, sử dụng lệnh `yum clean`. Lưu ý rằng các packages này sẽ không bị xóa tự động.
Bạn có thể tìm kiếm các gói đã tải về bằng lệnh:

`find /var/cache/yum -iname '*.rpm'`

Mặc định thì nó được cấu hình để lưu tại `/var/cache/yum/$basearch/$releasever`. Bạn có thể chỉnh sửa nó.

**Hướng dẫn chỉ download file .rpm với yum**

- Trước tiên cần cài đặt gói `yum-plugin-downloadonly`

`yum install yum-plugin-downloadonly`

- Sau đó bạn có thể tiến hành download các gói về (bao gồm cả các gói bổ trợ) mà không cài đặt nó với lệnh yum

`yum install --downloadonly -y <tên gói>`

- Bạn có thể tìm kiếm các gói này tại thư mục `/var/tmp/yum/cache/$basearch/$releasever`

## 3. Apt-get và dpkg

Giống với yum, đối với các distro debian thì apt-get là công cụ rất hữu ích dùng để cài đặt và quản lí packages.
