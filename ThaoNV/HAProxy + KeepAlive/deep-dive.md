# Tìm hiểu sâu về HAProxy

## Mục lục

1. Giới thiệu chung về load balancing và load balancer

2. Giới thiệu về HAProxy

3. Chi tiết các tùy chọn cấu hình quan trọng trong HAProxy

4. Hướng dẫn quản lí HAProxy

----------------

## 1. Giới thiệu chung về load balancing và load balancer

Load Balancing bao gồm việc kết hợp lại nhiều thành phần để có được tổng hợp khả năng xử lí trên các thiết bị riêng lẻ mà không cần có sự can thiệp nào từ phía người dùng và có khả năng mở rộng. Như vậy sẽ có nhiều quá trình xử lí diễn ra trong cùng thời gian mà nó xử lí một tiến trình riêng lẻ.

Lợi ích chính của load balancing đó là sử dụng hết tất cả tài nguyên để đem lại hiệu suất tốt nhất. Ví dụ ngoài đời thường, một tuyến đường có nhiều làn sẽ cho phép nhiều xe đi qua hơn trong cùng một thời điểm mà không cần phải tăng tốc độ của các xe chạy qua.

Ví dụ của load balancing:

- Quá trình schedule của hệ thống với nhiều vi xử lí
- EtherChannel, Bonding
- ......

Thành phần thực hiện các load balancing operations được gọi là load balancer. Một trong những use case áp dụng load balancing tốt nhất đó là môi trường web.

Load balancer có thể hoạt động ở:
- Link level: quyết định card mạng để gửi gói tin
- Network level: quyết định đường mạng để gửi gói tin đi
- server level : quyết định server nào sẽ xử lí request

Có hai công nghệ thực hiện điều này và mỗi thứ lại cần những điều kiện nhất định.

Loại thứ nhất hoạt động ở packet level. Mối quan hệ giữa input và output packet là 1-1. Nó có thể hoạt động stateful (layer 4) và phù hợp nhất với network-level load balancing.

Loại thứ 2 hoạt động trên các nội dung của phiên làm việc. Nội dung có thể được thay đổi và output stream được phân lại thành các packets khác nhau. Loại này thường hoạt động bằng proxies và được gọi là layer 7 load balancer. Công nghệ này rất phù hợp với server load balancing.

## 2. Giới thiệu về HAProxy

### 2.1 HAProxy là gì

HAProxy là:

- TCP Proxy: có có thể chấp nhận các kết nối tcp từ listening socket, kết nối nó tới server và gán các sockets này lại với nhau ch phép traffic di chuyển theo cả hai chiều
- HTTP reverse-proxy: Hay còn gọi là gateway, tự bản thân nó có thể là server, nhận các http requests từ kết nối được thông qua bởi listening TCP socket và chuyển các requests này tới các server bằng nhiều kết nối khác nhau.
- SSL terminator / initiator / offloader
- TCP normalizer
- HTTP normalizer
- HTTP fixing tool
- content-based switch: dựa vào thành phần của request để xác định server nhận
- server load balancer
- traffic regulator: thực hiện một số rule để limit traffic
- protection against DDoS: nó có thể lưu giữ danh số liệu về địa chỉ ip, url,... và thực hiện các hành động (làm chậm, block,...)

### 2.2 Cách thức hoạt động

HAProxy là single-threaded, event-driven, non-blocking engine kết hợp các I/O layer với priority-based scheduler. Vì nó được thiết kế với mục tiêu vận chuyển dữ liệu, kiến trúc của nó được tối ưu hóa để chuyển dữ liệu nhanh nhất có thể. Nó có những layer model với những cơ chế riêng để đảm bảo dữ liệu không đi tới những level cao hơn nếu không cần thiết. Phần lớn những quá trình xử lí diễn ra ở kernel và HAProxy làm mọi thứ tốt nhất để giúp kernel làm việc nhanh nhất có thể.

HAProxy (product) chỉ yêu cầu haproxy (programs) được thực thi và file cấu hình để chạy. File cấu hình sẽ được đọc trước khi nó khởi động, sau đó HAProxy sẽ cố gắng gộp tất cả listening sockets và từ chối khởi động nếu có cái gì đó lỗi. Vì thế sẽ không có bất cứ một lỗi run-time nào, một khi đã chạy, nó sẽ chỉ dừng lại nếu có lệnh.

Một khi HAProxy được bật lên, nó thực hiện 3 điều:

- Xử lí các incoming connections
- Định kì check các trạng thái của server (health checks)
- Trao đổi thông tin với các haproxy nodes khác

Quá trình xử lí các incoming connections là phần phức tạp nhất và nó phụ thuộc vào rất nhiều cấu hình. Có thể tóm gọn nó lại trong 9 bước:

- Cho phép các connections từ listening sockets thuộc về các cấu hình trong phần frontend
- Áp dụng các frontend-specific processing rules đối với những connections này
- Chuyển các incoming connections tới "backend", nơi chứa các server và cả những kế hoạch load balancing cho nó
- Áp dụng những backend-specific processing rules cho các connections
- Dựa vào kế hoạch load balancing mà quyết định server sẽ nhận kết nối
- Áp dụng backend-specific processing rules cho dữ liệu được trả về từ server
- Áp dụng frontend-specific processing rules cho dữ liệu được trả về từ server
- Tạo log để ghi lại những gì đã xảy ra
- Đối với http, lặp lại bước 2 để đợi một request mới, nếu không có, tiến hành đóng kết nối.

### 2.3 Các tính năng cơ bản

**Proxying**

**SSL**

**Monitoring**

**HA**

**Load balancing**

**Sampling and converting information**

**Maps**

**ACLs and conditions**

**Content switching**

**HTTP rewriting and redirection**

**Server protection**

**Logging**

**Statistics**

## 3. Chi tiết các tùy chọn cấu hình quan trọng trong HAProxy
