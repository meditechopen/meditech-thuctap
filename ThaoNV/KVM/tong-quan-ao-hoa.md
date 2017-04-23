# Tổng quan về ảo hóa

## Mục Lục

- [1.Giới thiệu về ảo hóa](#gioi-thieu)

- [2. Chức năng và lợi ích của ảo hóa](#chuc-nang)

- [3. Lựa chọn công nghệ ảo hóa phù hợp](#cong-nghe)

------

### <a name ="gioi-thieu"> </a> 1. Giới thiệu về ảo hóa

- Ngày nay, việc quản lí và sử dụng hạ tầng CNTT là điều rất cần thiết đối với bất kì một doanh nghiệp nào.
Tuy nhiên vẫn còn đó một vài những hạn chế trong việc quản lí và sử dụng tài nguyên theo phương pháp truyền thống:
  <ul>
  <li>Mỗi máy chủ vật lý chỉ cài đặt tương ứng 01 hệ điều hành, từ đó chỉ thiết lập được 01 môi trường hoạt động, 
  dẫn đến thiếu linh hoạt về các loại ứng dụng có thể cài đặt phục vụ cho mục đích của doanh nghiệp.</li>
  <li>Việc đầu tư máy chủ nhưng không sử dụng hết năng lực của máy chủ dẫn đến phí phạm tài nguyên và quản lý tài nguyên trở nên khó khăn.</li>
  <li>Các máy chủ vật lý được cài đặt trực tiếp hệ điều hành và ứng dụng gặp khó khăn trong việc sao lưu và phục hồi (backup và restore), 
  một số máy chủ vật lý đang hoạt động có những cơ chế đặc thù riêng và gần như rất khó hoặc “không thể” thực hiện sao lưu và phục hồi.</li>
  <li>Thời gian downtime của máy chủ vật lý thường rất lâu và dễ gặp trục trặc trong quá trình khởi động lại.</li>
  <li>Khó khăn trong quản trị và giám sát tập trung khi số lượng máy chủ vật lý tăng lên</li>
  </ul>
- Chính vì vậy, ảo hóa được coi là giải pháp nhằm tối ưu hóa việc sử dụng và khai thác tài nguyên vật lý.
- Vậy ảo hóa là gì?
- Ảo hóa được hiểu một cách đơn giản là chạy nhiều máy chủ ảo trên hạ tầng 01 máy chủ vật lý. 
Trên mỗi máy ảo có hệ điều hành riêng giống như 01 máy chủ thật và được triển khai các môi trường, 
ứng dụng khác nhau để phù hợp với hoạt động và mục đích của doanh nghiệp.

<img src="http://i.imgur.com/vGNtn6N.jpg">

### <a name="chuc-nang"> </a> 2. Chức năng và lợi ích của ảo hóa

** Các chức năng chính của ảo hóa **
- Phân chia: Với công nghệ ảo hóa, chúng ta có thể chạy nhiều máy ảo trên một máy thật với nhiều hệ điều hành khác nhau, nhờ thế mà 
ta cũng có thể tách từng dịch vụ ra để cài trên từng máy ảo.

<img src="http://i.imgur.com/FX3XCiV.png">

- Cô lập: Khi mỗi dịch vụ quan trọng được cài trên một máy ảo khác nhau thì nếu có sự cố, các dịch vụ khác cũng không bị ảnh hưởng gì.
Thêm vào đó, nó cũng giúp người dùng quản lí tốt hơn tài nguyên trên các máy ảo.

<img src ="http://i.imgur.com/Hkk3ZiO.png">

- Đóng gói: Với công nghệ ảo hóa, các máy ảo được đóng gói thành các file riêng biệt, nhờ vậy mà nó có thể dễ dàng được sao chép
 để backup và di chuyển sang các hệ thống khác để chạy.

 <img src ="http://i.imgur.com/KTnBnfO.png">

 ** Những lợi ích chính mà ảo hóa mang lại **

 - Giảm chi phí về hạ tầng IT và quản trị hệ thống: ảo hóa giúp tạo nhiều máy chủ ảo, khai thác triệt để tài nguyên vật lý của máy chủ, 
 từ đó giúp giảm chi phí đầu tư của doanh nghiệp, đồng thời giúp thiết lập hệ thống nhanh hơn, thuận tiện cho quản trị và giám sát, 
 giảm chi phí nhân công vận hành.
 - Tăng hiệu suất và tính linh hoạt của hệ thống: việc quản trị và khai thác triệt để tài nguyên vật lý giúp nâng cao 
 hiệu suất của từng máy chủ vật lý và của toàn hệ thống, đồng thời linh hoạt trong vấn đề mở rộng máy ảo, sao lưu, 
 dự phòng, di chuyển máy ảo.

 ### <a name = "cong-nghe"></a> 3. Lựa chọn công nghệ ảo hóa phù hợp

- Ảo hóa có 2 loại chính đó là:
  <ul>
  <li>Dedicated virtualization (Bare-Metal Hypervisor): Hypervisor tương tác trực tiếp với phần cứng của máy chủ để quản lý, phân phối và cấp phát tài nguyên.
   Loại ảo hóa này bao gồm các giải pháp như Vmware ESXi, Microsoft Hyper-V, Xen Server, KVM.</li>
  <li>Hosted Architecture: Đây là loại ảo hóa Hypervisor giao tiếp với phần cứng thông qua hệ điều hành. 
  Hypervisor lúc này được xem như một ứng dụng của hệ điều hành và các phương thức quản lý, 
  cấp phát tài nguyên đều phải thông qua hệ điều hành. 
  Loại ảo hóa này bao gồm các giải pháp như Vmware WorkStation, Oracle VirtualBox, Microsoft Virtual PC, …</li>
  </ul>
  - Vì ở loại thứ 1, Hypervisor tương tác trực tiếp với phần cứng nên việc quản lý và phân phối tài nguyên được tối ưu và 
  hiệu quả hơn so với loại 02, vì vậy khi triển khai trong thực tế, ảo hóa Loại 01 (Bare-Metal Hypervisor) được sử dụng, 
  loại 02 chỉ sử dụng trong các trường hợp thử nghiệm, hoặc mục đích học tập.

  <img src ="http://i.imgur.com/x57HzRc.png">
