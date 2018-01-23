# LVM Stripe
## Giới thiệu
`LVM Stripe` là một đặc tính của LVM quy định cách ghi dữ liệu vào các partition(physical volume) hình thành nên logical volume. Nó dùng để thay thế cho các ghi mặc định đó là ghi dữ liệu lần lượt lên các pv. Khi dữ liệu ghi đầy pv này nó mới thực hiện ghi dữ liệu sang pv khác. Ví dụ
- Ta có một lv tên là `xxx` được hình thành từ 2 pv là `/dev/sdb` và `/dev/sdc`. Khi thực hiện ghi dữ liệu thông thường lên `xxx` thì dữ liệu sẽ được ghi vào `/dev/sdb` trước, nếu `/dev/sdb` đầy nó mới thực hiện ghi lên `/dev/sdc`.
- Khi sử dụng LVM Stripe, dữ liệu ghi vào `xxx` sẽ được chia đều lên 2 pv là `/dev/sdb` và `/dev/sdc`. Có nghĩa là 50% dữ liệu sẽ được ghi cho `/dev/sdb`,  50% dữ liệu được ghi cho  `/dev/sdc`.
Ưu điểm của LVM Stripe:
- Tăng hiệu năng tốc độ ghi dữ liệu lên các pv
- Tiết kiệm không gian đĩa. Do đó ta có thể sử dụng phần không gian đĩa còn trống để tạo 1 PV khác.
Nếu không thiết lập `LVM Stripe`, sẽ mặc định là `LVM Linear`.
## Các bước thiết lập LVM Stripe
B1: Kiểm tra dung lượng Volume Group
<img src="https://i.imgur.com/DVMuQo9.png">

Tạo thử một logical volume thông thường
<img src="https://i.imgur.com/RZHHMWm.png">

B2: Tạo một logical volume kiểu LVM Stripe
sử dụng cú pháp lệnh
`lvcreate -L [lv size] -n [lv name] -i [number] [name vg]`
<img src="https://i.imgur.com/c8b1OwR.png">

Trong đó:
-i 2: là số physical volume sử dụng kiểu Stripe
B3: kiểm chứng kiểu lưu dữ liệu của logical
Để kiểm chứng xem lv sử dụng kiểu lưu dữ liệu nào thì sử dụng câu lệnh `lvdisplay [lv] -m`
- lv1 được tạo thông thường nên mặc định kiểu `Linear`
<img src="https://i.imgur.com/7MG2ZrY.png">

- lv2 được tạo kiểu LVM Stripe
<img src="https://i.imgur.com/iYNIFfM.png">

Trong đó:
- Dòng Stripe: số PV được sử dụng kiểu Stripe

Để kiểm tra các PV đã được sử dụng như thế nào, dùng lệnh `pvs`
<img src="https://i.imgur.com/XaoYuHn.png">

Như hình bên trên ta thấy, `/dev/sdb` sử dụng hết 1,5G trong đó 1G cho Logical Volume `lv1`, 0,5G cho logical Volume `lv2`. `/dev/sdc` dùng 0,5G cho logical Volume `lv2`.

Như vậy, ta có thể hình dung các thức hoạt động của 2 kiểu `Stripe` và `Linear` theo hình dưới đây.
-Đối với `Linear` (kiểu mặc định)
<img src="../pictures/linear-read-write-pattern.gi">

- Đối với `Stripe`
<img src="../pictures/striped-read-write-pattern.gif">

- So sánh cả 2 kiểu:
<img src="../pictures/linear-vs-striped-logical-volume-overview.png">

Để kiểm chứng rõ hơn, mount lv `lv2` vào một thư mục và tạo 1 file dung lượng 500Mb với câu lệnh `truncate -s 500M filename`, sau đó kiểm tra dung lượng của sử dụng của 2 pv tạo nên lv2