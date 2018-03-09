# Quá trình khởi tạo máy ảo trong Nova

<img src="http://i.imgur.com/drbTrDG.png">

<img src="http://i.imgur.com/HrBos46.png">

Ở ví dụ này có 2 hosts được sử dụng: compute host (hoạt động như Hypervisor khi nova-compute chạy) và controller host (chứa tất cả các dịch vụ quản lí).

Workflow khi khởi tạo máy ảo:

1. Client (có thể là Horizon hoặc CLI) hỏi tới keystone-api để xác thực và generate ra token.

2. Nếu quá trình xác thực thành công, client sẽ gửi request khởi chạy máy ảo tới nova-api. Giống câu lệnh `nova boot`.

3. Nova service sẽ kiểm tra token và nhận lại header với roles và permissions từ keystone-api.

4. Nova kiểm tra trong database để xem có conflicts nào với tên những objects đã có sẵn không và tạo mới một entry cho máy ảo mới trong database.

5. Nova-api gửi RPC tới nova-scheduler service để lên lịch cho máy ảo.

6. Nova-scheduler lấy request từ message queue

7. Nova-scheduler service sẽ tìm compute host thích hợp trong database thông qua filters và weights. Lúc này database sẽ cập nhật lại entry của máy ảo với host ID phù hợp nhận được từ nova-scheduler. Sau đó scheduler sẽ gửi RPC call tới nova-compute để khởi tạo máy ảo.

8. nova-compute lấy request từ message queue.

9. nova-compute hỏi nova-conductor để lấy thông tin về máy ảo như host ID, flavor. (nova-compute lấy các thông tin này từ database thông qua nova-conductor vì lý do bảo mật, tránh trường hợp nova-compute mang theo yêu cầu bất hợp lệ tới instance entry trong database)

10. nova-conductor lấy request từ message queue.

11. nova-conductor lấy thông tin máy ảo từ database.

12. nova-compute lấy thông tin máy ảo từ queue. Tại thời điểm này, compute host đã biết được image nào sẽ được sử dụng để chạy máy ảo. nova-compute sẽ hỏi tới glance-api để lấy url của image.

13. Glance-api sẽ xác thực token và gửi lại metadata của image trong đó bao gồm cả url của nó.

14. Nova-compute sẽ đưa token tới neutron-api và hỏi nó về network cho máy ảo.

15. Sau khi xác thực token, neutron sẽ tiến hành cấu hình network.

16. Nova-compute tương tác với cinder-api để gán volume vào máy ảo.

17. Nova-compute sẽ generate dữ liệu cho Hypervisor và gửi thông tin thông qua libvirt.


## Spawning VMs workflow

1. Dùng câu lệnh `nova-boot` hoặc tạo máy ảo trên dashboard

2. Quy trình tạo máy ảo: API -> Scheduler -> Compute (manager) -> Libvirt Driver

3. Tạo file disk: Lấy image từ glance vào thư mục  instance_dir/_ base và converrt nó sang dạng RAW (nếu đã ở dạng raw thì không cần convert)
-> Tạo instance_dir/uuid/{disk, disk.local, disk.swap}:
    -> Tạo `QCOW2` "disk" file, với backing file từ `_base image`
    -> Tạo QCOW2 “disk.local” và “disk.swap”
4. Tạo file libvirt XML và sao chép nó vào instance_dir (dù file này không được sử dụng bởi Nova)

5. Thiết lập kết nối với volume (nếu bạn chọn option boot từ volume). Các câu lệnh thực thi tiếp theo còn tùy thuộc vào volume driver:
  - Đối với iSCSI: Kết nối thông qua tgt hoặc iscsiadm
  - Đối với RBD: Tạo XML cho Libvirt, phần còn lại được thực hiện bởi QEMU.

6. Tạo network cho máy ảo

- Tùy thuộc vào các driver mà người dùng khai báo, các câu lệnh sẽ được thực hiện theo.
- Bật tất cả các bridges/VLANs cần thiết.
- Tạo security groups (iptables)

7. Difine domain với Libvirt, sử dụng file XML đã được tạo từ trước. Tương đương với câu lệnh `virsh define instance_dir/<uuid>/libvirt.xml’`

8. Giờ đây máy ảo đã được start. Tương đương với câu lệnh `virsh start`


## Hard reboot workflow

1. Destroy domain (chỉ hủy đi tiến trình, không hủy dữ liệu).

2. Thiết lập lại các kết nối volume.

3. Tạo lại file Libvirt XML.

4. Kiểm tra và tải lại các backing files nếu thiếu.

5. Gán lại các network stack.

6. Tạo lại các iptables rules.
