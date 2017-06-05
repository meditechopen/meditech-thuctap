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

- Có 2 nhân tố chính trong SNMP: Manager và Agent. Các SNMP agent sẽ giữ một sơ sở dữ liệu, được gọi là Management Information Base (MIB), trong đó chứa các thông tin khác nhau về hoạt động của thiết bị mà agent đang giám sát. Phần mềm quản trị SNMP Manager sẽ thu thập thông tin này qua giao thức SNMP.

## SNMP - sâu hơn về MIBs và OIDs :
- MIB - Management Information Base : thu thập các thông tin được tổ chức theo thứ bậc. Các mẫu thông tin khác nhau được truy cập bởi giao thức SMNP. Có 2 loại MIB : Scaler ones và Tabular ones . Các đối tượng Scalar xác định một thể hiện của đối tượng duy nhất, trong khi Tabular xác định được nhiều thể hiện trên cùng một đối tượng.
- OID - Object Identiflers các đối tượng xác định được quản lý trong MIB. Nó có thể được miêu tả như là một cái cây có nhiều nút,được quản lý bởi các tổ chức khác nhau.Nói chung OID là một dãy số dài, mã hóa các nút,được phân tách với phần khác bằng dấu chấm.
- SNMP hoat động cơ bản theo nguyên tắc là : hệ thống quản lý mạng gửi yêu cầu và các thiết bị được quản lý sẽ trả về các phản hồi. Nó thực hiện bằng cách sử dụng một trong bốn hoạt động : Get, GetNext, Set, Trap.

## Giao thức SNMP

- SNMP sử dụng dịch vụ UDP. Theo mặc định, cổng UDP 161 được dử dụng để  lắng nghe các thông điệp SNMP ở phía Agent và cổng 162 sử dụng để lắng nghe các trả về SNMP tại Server. Các cổng này có thể cấu hình khác đi.

<img src=http://i.imgur.com/eqqDxNz.gif>
