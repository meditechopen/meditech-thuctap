


# Khái niệm và phân loại VTP mode

## Phụ lục:
### [1.	Chế độ VTP](#chedo) 
  #### [1.1 Server mode](#server)
  #### [1.2 Client mode](#client)
  #### [1.3 Transparent mode](#trans)
### [2.	So sánh phương thức làm việc giữa các mode](#ss)
  #### [2.1 Tạo bản tin VTP](#bantin)
  #### [2.2	Lắng nghe bản tin VTP](#langnghe)
  #### [2.3	Tạo, xóa , sửa Vlan](#tao)

```
VTP là gì?
VTP viết tắt của từ VLAN Trunking Protocol là giao thức độc quyền của Cisco hoạt động ở lớp 2 của mô hình OSI.
VTP giúp cho việc cấu hình VLAN luôn đồng nhất khi thêm, xóa, sửa thông tin về VLAN trong một hệ thống mạng. 
VTP được thiết lập để giải quyết các vấn đề nằm bên trong hoạt động của môi trường mạng VLAN. 
Ví dụ: Một hệ thống có các kết nối Switch hỗ trợ bởi các VLAN. Để thiết lập và duy trì kết nối bên trong VLAN ,
mỗi VLAN phải được cấu hình thông suốt trên tất cả các Switch. Khi phát triển mạng và các Switch được thêm vào
mạng, mỗi Switch mới phải được cấu hình với các thông tin của VLAN trước đó.
Việc cấu hình VLAN có thể sẽ sảy ra 2 vấn đề sau:
– Các kết nối chồng chéo lên nhau do cấu hình VLAN không đúng.
– Các cấu hình không đúng giữa các môi trường truyền khác nhau.
```

### <a name="chedo" > 1.	Chế độ VTP: </a>
Khi triển khai VTP trên hệ thống, bạn sẽ có ba sự lựa chọn chế độ làm việc cho Switch của mình: Server, Client và Transparent. Tùy thuộc vào mục đích quản trị và hạ tầng mạng mà ta lựa chọn sao cho hợp lý. Bảng sau đây tóm tắt sự khác nhau giữa ba chế độ làm việc:
</br>
![Sự khác nhau giữa các mode](http://i.imgur.com/e0zqi9g.png)
* <a name="server"> Chế độ Server </a> </br>
  Các sever VTP sẽ điều khiển việc tạo VLAN và thay đổi miền của nó. Tất cả thông tin VTP đều được quảng bá đến các Switch trong miền, các Switch khác sẽ nhận đồng thời. Mặc định một Switch hoạt động ở chế độ sever.
  Có thể tạo, chỉnh sửa và xóa VLAN
  * Gửi hoặc chuyển tiếp thông tin quảng bá
  * Đồng bộ hóa thông tin VLAN
  * Lưu cấu hình vào NVRAM

* <a name="client">Chế độ Client </a> </br>

  Các VTP chế độ này không cho phép tạo, chỉnh sửa và xóa bất cứ VLAN mà nó lắng nghe các quảng bá VTP từ các Switch khác và thay đổi cấu hình VLAN một cách thích hợp. Đây là chế độ lắng nghe thụ động. Các thông tin VTP được chuyển tiếp ra liên kết trunk đến các Switch lân cận trong miền.
  * Chuyển tiếp thông tin quảng bá
  * Đồng bộ hóa thông tin VLAN
  * Không lưu cấu hình vào NVRAM

* <a name="trans">Chế độ Transparent </a> </br>

  Ở chế độ này, một Switch không quảng bá cấu hình VLAN của chính nó và không đồng bộ cơ sở dữ liệu VLAN của nó với thông tin VLAN nhận được. Trong phiên bản 1, Switch hoạt động ở chế độ này không chuyển tiếp thông tin quảng bá VTP nhận được đến các Switch khác, trừ khi tên miền và số phiên bản VTP của nó khớp với các Switch khác. Trong phiên bản 2, Switch hoạt động ở chế độ này chuyển tiếp thông tin quảng bá VTP nhận được ra cổng trunk của nó
  Chú ý: Switch hoạt động ở chế độ Transparent có thể tạo và xóa VLAN cục bộ. Tuy nhiên các thay đổi của VLAN không được truyền đến bất cứ Switch nào.
  *	Có thể tạo, chính sửa và xóa VLAN
  *	Chuyển tiếp thông tin quảng bá
  *	Không đồng bộ hóa thông tin VLAN
  *	Lưu cấu hình vào NVRAM

### <a name="ss">2.So sánh các chế độ làm việc của Switch khi chạy VTP </a>

<a name="bantin"> **Tạo bản tin VTP:** </a> Bất cứ khi nào người quản trị tạo, xóa hay sửa một VLAN và muốn thông tin này quảng bá đến các Switch khác trong cùng một vùng, người quản trị phải cấu hình nó trên Switch đang làm việc ở chế độ Server. Do đó chế độ Server là một nguồn tạo bản tin VTP. Ngoài ra ở chế độ Client cũng có khả năng là nguồn của một bản tin VTP mặc dù nó không thể tạo, xóa hay sửa một VLAN. Đó là khi một Switch mới gia nhập vào hệ thống nhưng nó đã mang sẵn cấu hình VTP của vùng khác, với cùng VTP domain và chỉ số revision lớn hơn tất cả trong hệ thống của chúng ta. Đó là lý do đôi lúc ta thấy làm việc ở chế độ Client cũng có khả năng là nguồn tạo bản tin VTP.
    - Một Switch hoạt động ở chế độ Transparent hoàn toàn có thể tạo VLAN nhưng nó sẽ không gửi đi bản tin quảng bá VLAN mới đó. Hay nói cách khác nó chỉ hoạt động độc lập, do đó nó không phải là nguồn tạo một bản tin VTP.
    
<a name="langnghe"> **Lắng nghe bản tin VTP:** </a> Chỉ có những Switch hoạt động ở chế độ Client hay Server mới lắng nghe bản tin VTP từ những nguồn khác trong hệ thống. Khi một Switch nhận một thông tin quảng bá đến nó từ địa chỉ multicast 01-00-0C-CC-CC-CC nó sẽ tiến hành xử lý gói tin đó. Nếu thông số revision lớn hơn của nó, khi đó quá trình đồng bộ sảy ra, Switch sẽ cập nhật thông tin nó đang có với thông tin trong bản tin vừa nhận. Nếu thông số revision của bản tin vừa nhận nhỏ hơn của Swith thì nó sẽ hủy bản tin và gửi lại bản tin khác có thông số revision lớn hơn để cập nhật cho các thiết bị khác trong mạng.
    - Một Switch hoạt động ở chế độ Transparent không lắng nghe bản tin VTP quảng bá trong hệ thống. Nó vẫn nhận bản tin quảng bá nhưng không xử lý, nó chỉ có nhiệm vụ chuyển tiếp bản tin đó ra liên kết trunk.
  
<a name="tao"> **Tạo, xóa, sửa VLAN:** </a> Thuộc tính này có trên Switch hoạt động ở chế độ Server và Transparent. Tuy nhiên bản chất của nó là khác nhau. Khi người quản trị tạo, xóa hay sửa VLAN trên một Server, ngay lập tức thông tin quảng bá sẽ được gửi đến địa chỉ multicast 01-00-0C-CC-CC-CC với thông số revision tăng lên một. Quá trình cập nhật trong hệ thống với việc tăng thêm một VLAN mới sảy ra ngay sau đó. Việc này cũng có thể thực hiện trên Switch hoạt động ở chế độ Transparent, người quản trị dễ dàng tạo, xóa hay sửa thông tin một VLAN, nhưng bản tin VTP quảng bá không được tạo ra, không được gửi đi trong hệ thống do đó những Switch khác không cập nhật những thông tin mới chỉnh sửa. Switch hoạt động ở chế độ Transparent làm việc một cách cục bộ không ảnh hưởng đến toàn bộ hệ thống, nó chỉ có nhiệm vụ chuyển tiếp bản tin VTP quảng bá để hệ thống thông suốt liên tục.
  * Thuộc tính này không có ở một Switch hoạt động ở chế độ Client, nó không thể tạo, xóa hay sửa thông tin một VLAN.

