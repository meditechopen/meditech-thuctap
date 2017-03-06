# Tìm hiểu về KMV

# Mục lục
##  [I.Giới thiệu](#gioithieu)
###   [1.1 Định nghĩa](#dinhnghia)
###   [1.2 Lịch sử ](#lichsu)
##  [II.Cấu trúc KVM](#cautruc)
### [1.Mô hình KVM Stack](#stack)
### [2.Mô hình KVM QEMU](#qemu)

-----------------------------------------

<a name="gioithieu"></a>
## I.Giới thiệu

<a name="dinhnghia"></a>
### 1.1 Định nghĩa

  - `KVM(Kernel-based Virtual Machine)` : là giải pháp ảo hóa toàn diện trên phần cứng x86 và hỗ trợ hầu hết các hệ điều hành của Linux và Windowws. KVM chuyển đổi một nhân Linux (Linux kernel) thành một bare metal hypervisor và thêm vào đó những đặc trưng riêng của các bộ xử lý Intel như Intel VT-X hay AMD như AMD-V.Nó có thể cài đặt các hệ điều hành khác nhau mà không cần phụ thuộc vào hệ điều hành của máy chủ vật lý.Hơn thế nữa, KVM còn tích hợp các đặc điểm bảo mật của Linux như SELinux hay các cơ chế bảo mật nhiều lớp, điều đó làm cho các máy ảo được bảo vệ tối đa và cách ly hoàn toàn.

  - KVM được phát triển trên nền tảng mã nguồn mở, chính vì thế nó ngày càng lớn mạnh và trở thành một lựa chọn hàng đầu cho doanh nghiệp và hơn thế nữa, nó còn được hỗ trợ từ những nhà sản xuất thiết bị phần cứng, đó là những công nghệ ảo hóa được tích hợp vào bộ vi xử lý như Intel VT-X hay AMD-V để gia tăng đáng kể hiệu suất, tính linh hoạt và khả năng bảo mật.
  - Ngoài ra, do hoạt động trên nền tảng hệ điều hành Linux hay nói đúng hơn là KVM được tải thẳng vào bên trong Linux kernel nên KVM đạt hiệu suất rất cao, cùng một cấu hình, KVM có thể tạo được số lượng máy ảo tương đương nhiều hơn so với VMware.

<a name="lichsu"></a>
### 1.2 Lịch sử
  - KVM ra đời phiên bản đầu tiên vào năm 2007 bởi công ty Qumranet tại Isarel, KVM được tích hợp sẵn vào nhân của hệ điều hành Linux bắt đầu từ phiên bản 2.6.20
  - Năm 2008, RedHat đã mua lại Qumranet và bắt đầu phát triển, phổ biến KVM Hypervisor.

<a name="cautruc"></a>
## II. Cấu trúc KVM



  <img src="http://i.imgur.com/uYUebsU.png">

   - Bản chất mỗi máy ảo có một hoặc nhiều VCPU(Virtual CPU ), mỗi VCPU sẽ sử dụng cơ chế maping trực tiếp đến từng CPU của máy chủ vật lý

<a name="stack"></a>
### 2.1 Mô hình KVM Stack

<img src="http://i.imgur.com/DHuQKkm.png">

Trong đó :
- `User-facing tools` : là các công cụ hỗ  trợ quản lý máy ảo.Có thể là Virt-manager (hỗ trợ giao diện) hoặc Virsh(dòng lệnh) hoặc Virt-tools(công cụ quản lý trung tâm dữ liệu).
- `Mgmt layer` : Lớp này là thư viện libvirt cung cấp API để các công cụ quản lý máy ảo hoặc các hypervisor tương tác với KVM thực hiện các thao tác quản lý tài nguyên ảo hóa.
- `Virtual machine` :  Chính là các máy ảo người dùng tạo ra. Thông thường, nếu không sử dụng các công cụ như virsh hay virt-manager thì sử dụng QEMU.
- `Kernel support` : Chính là KVM, cung cấp một module làm hạt nhân cho hạ tầng ảo hóa (kvm.ko) và một module kernel đặc biệt hỗ trợ các vi xử lý VT-x hoặc AMD-V (kvm-intel.ko hoặc kvm-amd.ko).

<a name="qemu"></a>
### 2.2 Mô hình KVM & QEMU
Mô hình :
<img src=http://i.imgur.com/XVHHuxq.jpg>
