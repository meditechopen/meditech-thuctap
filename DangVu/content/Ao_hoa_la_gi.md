# Giới thiệu về ảo hóa
- Ngày nay việc quản lí và sử dụng hạ tầng CNTT là điều rất cần thiết đối với bất kì doanh nghiệp nào. Tuy nhiên vẫn còn đó một vài những hạn chế trong việc quản lí và sử dụng tài nguyên theo phương pháp truyền thống:
	- Mỗi máy chủ vật lí chỉ cài đặt tương ứng 1 hệ điều hành, từ đó thiết lập được 1 môi trường hoạt đông, dẫn đến thiếu linh hoạt về các loại ứng dụng có thể cài đặt phục vụ cho mục đích doanh nghiệp.
	- Việc đầu tư máy chủ nhưng không sử dụng hết năng lực của máy chủ đẫn đến phí phạm tài nguyên và quản lý tài nguyên trở nên khó khăn hơn.
	- Các máy chủ vật lí đc cài đặt trực tiếp hệ điều hành và ứng dụng gặp khó khăn trong việc sao lưu và phục hồi. Một số máy chủ vật lý đang hoạt động có những cơ chế và đặc thù riêng và gần như rất khó không thể sao lưu phục hồi.
	- Thời gian downtime của máy chủ vật lý thường rất lâu và dễ trục trặc trong quá trình khởi động lại.
	- Khó khăn trong quản trị và giám sát tập trung khi số lượng vật lý tăng lên.
- Chính vì vậy, ảo hóa được coi là giải pháp nhằm tối ưu hóa việc sử dụng và khai thác vật lý.
- Vậy ảo hóa là gì?
- Ảo hóa được hiểu một cách đơn giản là chạy nhiều máy chủ ảo trên hạ tầng 1 máy chủ vật lý. Trên mỗi máy ảo có hệ điều hành giống như 1 máy chủ thật và được triển khai các môi trường, ứng dụng khác nhau để phù hợp với hoạt động của mục đích doanh nghiệp.

<img src="">

## Các chức năng và lợi ích của ảo hóa
**Các chức năng chính**
- Phân chia: với công nghệ ảo hóa, chúng ta có thể chạy nhiều máy ảo trên cùng một máy thật với nhiều hệ điều hành khác nhau, nhờ thế mà ta cũng có thể tách từng dịch vụ ra để cài trên từng máy ảo.
<img src="">

- Cô lập: Khi mỗi dịch vụ quan trọng được cài trên một máy ảo khác nhau thì nếu có sự cố, các dịch vụ khác cũng không bị ảnh hưởng gì. Thêm vào đó, nó cũng giúp người dùng quản lý tốt hơn tài nguyên trên các máy ảo.
<img src="">

- Đóng gói: Với công nghệ ảo hóa, các máy ảo được đóng gói thành các file riêng biệt, nhờ vậy mà nó có thể dể dàng được sao chép để backup và di chuyển sang các hệ thống khác để chạy.
<img src="">

**Lợi ích**
- Giảm chi phí về hạ tầng IT và quản trị hệ thống: ảo hóa giúp tạo nhiều máy chủ ảo, khai thác triệt để tài nguyên vật lý của máy chủ, từ đó giúp giảm chi phí đầu tư của doanh nghiệp, đồng thời giúp thiết lập hệ thống nhanh hơn, thuận tiện cho quản trị và giám sát, giảm chi phí nhân công vận hành.
- Tăng hiệu suất và tính linh hoạt của hệ thống: Việc quản trị và khai thác triệt để tài nguyên vật lý giúp nâng cao hiệu suất của từng máy chủ vật lý và của toàn hệ thống, đồng thời linh hoạt hơn trong vấn đề mở rộng máy ảo, sao lưu, dự phòng, di chuyển máy ảo.
## Lựa chọn công nghệ ảo hóa phù hợp
- Ảo hóa có 2 loại chính đó là:
	- Dedicated virtualization (bare-metal Hypervisor): Hypervisor tương tác trực tiếp với phần cứng máy chủ để quản lý, phân phối và cấp tài nguyên. Loại ảo hóa này bao gồm các giải pháp như VMware ESXi, Microsoft Hyper-V, Xen Server, KVM...
	- Hosted Architecture: Đây là loại ảo hóa Hypervisor giao tiếp với phần cứng thông qua hệ điều hành. hypervisor lúc này được xem như một ứng dụng của hệ điều hành và các phương thức quản lý, cấp phát tài nguyên đều phải thông qua hệ điều hành. Loại ảo hóa này bao gồm các giải pháp như Vmware WorkStation, Oracle Virtuabox, Microsoft Virtual PC...
- Vì ở loại thứ 1, Hypervisor tương tác trực tiếp với phần cứng nên việc quản lý và phân phối tài nguyên được tối ưu và hiệu quả hơn so với loại 2, vì vậy triển khai trong thực tế, ảo hóa loại 1 được sử dụng, còn loại 2 sử dụng với mục đích thử nghiệm và học tập
<img src="">
