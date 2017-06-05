# Tìm hiểu về SNMP

## Tổng quan SNMP
-SNMP là “giao thức quản lý mạng đơn giản”, dịch từ cụm từ “Simple Network Management Protocol”. Là giao thức được sử dụng rất phổ biến để giám sát và điều khiển thiết bị mạng như switch, router, server ...

- Giao thức SNMP được thiết kế để cung cấp một phương thức đơn giản để quản lý tập trung mạng TCP/IP. Nếu bạn muốn quản lý các thiết bị từ 1 vị trí tập trung, giao thức SNMP sẽ vận chuyển dữ liệu từ client (thiết bị mà bạn đang giám sát) đến server nơi mà dữ liệu được lưu trong log file nhằm phân tích dễ dàng hơn
SNMP dùng để quản lý tức là có thể theo dõi, có thể lấy thông tin, có thể được thông báo, và có thể tác động để hệ thống hoạt động như ý muốn.

Một số  chức năng của SNMP :
- Theo dõi tốc độ đường truyền của một router, biết được tổng số byte đã truyền/nhận.
- Lấy thông tin máy chủ đang có bao nhiêu ổ cứng, mỗi ổ cứng còn trống bao nhiêu.
- Tự động nhận cảnh báo khi switch có một port bị down.
- Điều khiển tắt (shutdown) các port trên switch.

SNMP có 4 phiên bản : SNMPv1, SNMPv2c, SNMPv2u và SNMPv3. Các phiên bản này khác nhau một chút ở định dạng bản tin và phương thức hoạt động.

Theo RFC1157, kiến trúc của SNMP bao gồm 2 thành phần : các trạm quản lý mạng (network management station) và các thành tố mạng (network element). Trong đó :
- Network management station thường là một máy tính chạy phần mềm quản lý SNMP (SNMP management application), dùng để giám sát và điều khiển tập trung các network element.
- Network element là các thiết bị, máy tính, hoặc phần mềm tương thích SNMP và được quản lý bởi
network management station. Như vậy element bao gồm device, host và application.

<img src=http://i.imgur.com/xyxZsLF.png>

- SNMP agent là một tiến trình (process) chạy trên network element, có nhiệm vụ cung cấp thông tin của element cho station, nhờ đó station có thể quản lý đượcelement. Chính xác hơn là application chạy trên station và agent chạy trên element mới là 2 tiến trình SNMP trực tiếp liên hệ với nhau

<img src=http://i.imgur.com/ov57Xhb.png>


## SNMP - sâu hơn về MIBs và OIDs :

**OID - Objec ID :**

- Một thiết bị hỗ trợ SNMP có thể cung cấp nhiều thông tin khác nhau, mỗi thông tin đó gọi là một object.
- Mỗi object có một tên gọi và một mã số để nhận dạng object đó, mã số gọi là Object ID (OID).
- Một object chỉ có một OID, chẳng hạn tên của thiết bị là một object. Tuy nhiên nếu một thiết bị lại có
nhiều tên, vậy để phân biệt các thiết bị đó với nhau, chúng ta cần tính thêm Sub ID đặt ngay sau OID nữa.
- OID của các object phổ biến có thể được chuẩn hóa, OID của các object do bạn tạo ra thì bạn phải tự mô tả chúng. Để lấy một thông tin có OID đã chuẩn hóa thì SNMP application phải gửi một bản tin SNMP có chứa OID của object đó cho SNMP agent, SNMP agent khi nhận được thì nó phải trả lời bằng thông tin ứng với OID đó.

**MIB-Management Information Base :**

- MIB (cơ sở thông tin quản lý) là một cấu trúc dữ liệu gồm các đối tượng được quản lý (managed object), được dùng cho việc quản lý các thiết bị chạy trên nền TCP/IP. MIB là kiến trúc chung mà các giao thức quản lý trên TCP/IP nên tuân theo, trong đó có SNMP. MIB được thể hiện thành 1 file (MIB file), và có thể biểu diễn thành 1 cây (MIB tree). MIB có thể được chuẩn hóa hoặc tự tạo.
- Các objectID trong MIB được sắp xếp thứ tự nhưng không phải là liên tục, khi biết một OID thì không chắc chắn có thể xác định được OID tiếp theo trong MIB.
- MIB  : thu thập các thông tin được tổ chức theo thứ bậc. Các mẫu thông tin khác nhau được truy cập bởi giao thức SMNP. Có 2 loại MIB : Scaler ones và Tabular ones . Các đối tượng Scalar xác định một thể hiện của đối tượng duy nhất, trong khi Tabular xác định được nhiều thể hiện trên cùng một đối tượng.

## Giao thức SNMP

- SNMP sử dụng dịch vụ UDP. Theo mặc định, cổng UDP 161 được dử dụng để  lắng nghe các thông điệp SNMP ở phía Agent và cổng 162 sử dụng để lắng nghe các trả về SNMP tại Server. Các cổng này có thể cấu hình khác đi.

<img src=http://i.imgur.com/eqqDxNz.gif>
