# Tổng quan về các công nghệ lưu trữ

Các lọai công nghệ lưu trữ :
- DAS (Direct Attached Storage) : Lưu trữ dữ liệu qua các thiết bị gắn trực tiếp
- NAS (Network Attached Storage) : Lưu trữ dữ liệu vào thiết bị lưu thông qua mạng IP.
- SAN (Storage Area Network) : Lưu trữ dữ liệu qua mạng lưu trữ chuyên dụng riêng.

Mỗi loại hình lưu trữ đều có những ưu , nhược điểm riêng và được dùng cho những mục đích nhất định.

Dưới đây là một số hình ảnh tổng quát :

<img src=http://i.imgur.com/qtwF8WU.png>

**Giải pháp lưu trữ truyền thống DAS**

DAS là cơ chế lưu trữ với thiết bị gắn trực tiếp vào máy chủ. Đây được coi là công nghệ lưu trữ truyền thống được nhiều doanh nghiệp sử dụng.Với cơ chế  DAS
, mỗi máy chủ sẽ có một hệ thống lưu trữ và phần mềm quản lý lưu trữ riêng biệt.Ưu điểm của DAS là dễ lắp đặt và chi phí thấp, hiệu năng cao.
Tuy nhiên. nhược điểm của DAS là khả năng mở rộng hạn chế. Thực tế DAS làm việc rất tốt với 1 Server nhưng khi dữ liệu tăng, số lượng máy chủ cũng tăng sẽ tạo nên những vùng dữ liệu bị phân tán và gián đoạn. Khi đó, nhà quản trị sẽ phải bổ sung hay thiết lập lại dung lượng, công việc bảo trì sẽ thực hiện ở từng Server. Điều này làm tăng chi phí lưu trữ tổng thể của doanh nghiệp và càng khó khăn hơn khi muốn sao lưu hay bảo về một hệ thống kho lưu trữ dữ liệu đang nằm rải rác và phân tán.

**Giải pháp lưu trữ theo công nghệ NAS**

NAS là phương pháp lưu trữ dữ liệu sử dụng các thiết bị lưu trữ đặc biệt gắn trực tiếp vào mạng LAN như một thiết bị mạng bình thường( tương tự như máy tính, switch hay router). Các thiết bị NAS cũng được gán địa chỉ IP cố định và được người dùng truy nhập thông tin qua sự điều khiển của máy chủ. Trong một số trường hợp , NAS có thể truy cập trực tiếp không cần sự truy nhập của máy chủ.Trong môi trường nhiều hệ điều hành với nhiều máy chủ khác nhau, việc lưu trữ dữ liệu, sao lưu và phục hồi dữ liệu, quản lý hay áp các chính sách bảo mật đều được thực hiện một cách tập trung.
- Ưu điểm của NAS :
Khả năng mở rộng : khi người dùng cần thêm dung lượng lưu trữ, các thiết bị lưu trữ NAS mới có thể được bổ sung và lắp đặt vào mạng, NAS cũng tăng cường khả năng chống lại sự cố cho mạng. Trong môi trường DAS , khi một máy chủ chưa dữ liệu không hoạt động thì toàn bộ dữ liệu đó không thể sử dụng được. Trong môi trường NAS, dữ liệu vẫn hoàn toàn có thể truy nhập được bởi người dùng.Các biện pháp chống lỗi và dự phòng tiên tiến được áp dụng để đảm bỏa NAS luôn trong trạng thái sẵn sàng cung cấp dữ liệu cho người dùng.

- Nhược điểm NAS : Với việc sử dụng chung hạ tầng mạng với các ứng dụng khác, việc lưu trữ dữ liệu có thể ảnh hưởng tới hiệu năng của toàn hệ thống (làm chậm tốc độ của LAN), điều này là đáng lo ngại khi thường xuyên lưu trữ một lượng dữ liệu lớn. Trong môi trường có các hệ cơ sở dữ liệu thì NAS không phải là giải pháp tốt vì các hệ quản trị cơ sở dữ liệu thường lưu trữ dữ liệu dưới dạng block chữ không phải dạng file nên sử dụng NAS sẽ không cho hiệu năng tốt.

**Giải pháp lưu trữ qua mạng chuyên dụng SAN**

SAN là một mạng riêng tốc độ cao dùng cho việc truyền dữ liệu giữa các máy chủ tham gia vào hệ thống lưu trữ cũng như giữa các thiết bị lưu trữ với nhau.SAN cho phép thực hiện quản lý tập trung và cung cấp khả năng chia sẻ dữ liệu và tài nguyên lưu trữ. Hầu hết mạng SAN hiện nay dựa trên công nghệ kênh cáp quang, cũng cấp cho người sử dụng khả năng mở rộng, hiệu năng và tính sẵn sàng cao.Hệ thống SAN được chia làm 2 mức : mức vật lý, mức logic
- Mức vật lý : mô tả sự liên kết các thành phần của mạng tạo ra một hệ thống lưu trữ đồng nhất và có thể sử dụng đồng thời cho nhiều ứng dụng và người dùng.
- Mức logic : bao gồm các ứng dụng, các công cụ quản lý và dịch vụ được xây dựng trên nền tảng của thiết bị lớp vật lý, cung cấp khả năng quản lý cho hệ thống SAN.

- Ưu điểm của hệ thống SAN
Có khả năng sao lưu dữ liệu với dung lượng lớn và thường xuyên mà không làm ảnh hưởng đến lưu lượng thông tin trên mạng.

SAN đặc biệt thích hợp với các ứng dụng cần tốc độ và độ trễ nhỏ ví dụ như các ứng dụng xử lý giao dịch trong ngành ngân hàng, tài chính.

Dữ liệu luôn ở mức độ sẵn sàng cao.

Dữ liệu được lưu trữ thống nhất, tập trung và có khả năng quản lý cao. Có khả năng khôi phục dữ liệu nếu có xảy ra sự cố.

Hỗ trợ nhiều giao thức, chuẩn lưu trữ khác nhau như: iSCSI, FCIP, DWDM…

Có khả năng mở rộng tốt trên cả phương diện số lượng thiết bị, dung lượng hệ thống cũng như khoảng cách vật lý.

Mức độ an toàn cao do thực hiện quản lý tập trung cũng như sử dụng các công cụ hỗ trợ quản lý SAN.

Chính vì những điều trên, SAN thường được sử dụng ở những trung tâm dữ liệu lớn vì mang một số đặc điểm nổi bất như : giảm thiểu rủi ro cho dữ liệu, khả năng chia sẻ tài nguyên cao, khả năng phát triển dễ dàng, thông lượng lớn , hỗ trợ nhiều loại thiết bị , hỗ trợ và quản lý việc truyền dữ liệu lớn và tính an ninh dữ liệu cao.

Hơn nữa SAN tăng cường tính hiểu quả hoạt động của hệ thống bằng việc hỗ trợ đồng thời nhiều hệ điều hành,máy chủ và các ứng dụng, có khả năng đpá ứng nhanh chóng với những thay đổi về yêu cầu hoạt động của một tổ chức cũng như yêu cầu kỹ thuật của hệ thống mạng.


**Tóm lại**

- Ưu điểm của giải pháp DAS là khả năng dễ lắp đặt, chi phí thấp, hiệu năng cao. Nhược điểm của DAS là khả năng mở rộng hạn chế: khi dữ liệu tăng đòi hỏi số lượng máy chủ cũng tăng theo.  Điều này sẽ tạo nên những vùng dữ liệu phân tán, gián đoạn và khó khăn khi sao lưu cũng như bảo vệ hệ thống lưu trữ.

- Giải pháp NAS và SAN giải quyết được các hạn chế của DAS. Với kiểu lưu trữ NAS và SAN, việc lưu trữ được tách ra khỏi server, hợp nhất trong mạng, tạo ra một khu vực truy cập rộng cho các server, cho người sử dụng và cho các ứng dụng truy xuất hay trao đổi. Nó tạo nên sự mềm dẻo và năng động. Việc quản trị và bảo vệ dữ liệu sẽ trở nên đơn giản, độ tiện lợi sẽ cao hơn, chi phí tổng thể sẽ nhỏ hơn. NAS thích hợp cho môi trường chia sẻ file nhưng hạn chế trong môi trường có các hệ cơ sở dữ liệu. Hơn nữa, với việc sử dụng hạ tầng mạng chung với các ứng dụng khác, NAS làm chậm tốc độ truy cập mạng và ảnh hưởng đến hiệu năng của toàn hệ thống.
- Giải pháp mạng lưu trữ SAN giải quyết được hạn chế của NAS và đặc biệt thích hợp với các ứng dụng cần tốc độ cao với độ trễ nhỏ. Hơn nữa, SAN có khả năng đáp ứng nhanh chóng với những thay đổi về yêu cầu hoạt động của một tổ chức cũng như yêu cầu kỹ thuật của hệ thống mạng. Tuy nhiên nhược điểm của SAN là chi phí đầu tư ban đầu cao hơn so với hai giải pháp DAS và NAS.
