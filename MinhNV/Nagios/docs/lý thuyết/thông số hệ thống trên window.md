# Thông số hệ thống trong Resource Monitor trên Window
## Mục lục

- 1.[CPU](#cpu)
- 2. [RAM](#ram)
- 3. [Disk](#disk)
- 4. [Network](#network)

<a name="cpu"></a>
## CPU

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/tab%20cpu.PNG?raw=true">

### Processes With Network Activity:

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/processes.PNG?raw=true">

Tương tự như trên, các ứng dụng được liệt kê tại đây nghĩa là đang sử dụng tài nguyên của CPU.

- Name: tên file thực thi của ứng dụng đang sử dụng CPU để hoạt động.
- PID: số ID tương ứng của chương trình.
- Description: nội dung miêu tả ngắn gọn về tiến trình đang hoạt động
- Status: tình trạng hoạt động của ứng dụng.
- Threads: số lượng các luồng dữ liệu xử lý đang ở chế độ kích hoạt.
- CPU: tỉ lệ hoạt động hiện thời của CPU tính theo %.
- Average CPU: mức hoạt động trung bình của các ứng dụng gây ra với CPU trong vòng 60 giây.

### Services:

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/services.PNG?raw=true">

- Tại đây, chương trình sẽ liệt kê từng dịch vụ đang hoạt động và đang chạy trên CPU nào.


### Associated Handles:

- Dùng khi bạn muốn xác định 1 chương trình nào đó đang xử lý file hoặc đang làm việc.
- Trong phần **Search Handles**, điền tên của file hoặc đường dẫn các bạn cần tìm kiếm, và danh sách các tiến trình tương ứng sẽ được trả về đầy đủ.

### Associated modules

Các module ở đây có thể được hiểu là những file hoặc chương trình có chức năng hỗ trợ cho ứng dụng chính, ví dụ như file DLL chẳng hạn. Chúng ta có thể sử dụng tính năng này để tìm hiểu cụ thể về nguyên nhân hoặc vấn đề bất thường đang xảy ra trong hệ thống.

- Module name: tên của module được tải bởi ứng dụng nào đó.
- Version: phiên bản của file có liên quan tới module đó.
- Full Path: đường dẫn đầy đủ của module đang kích hoạt.

### The graphs:

Cửa sổ ở phía bên phải chương trình này sẽ hiển thị một số biểu đồ chi tiết, có liên quan đến hiệu suất đo lường của CPU.

- CPU – Total:

Trong phần biểu đồ này, chúng ta sẽ thấy thành phần nho nhỏ được mô tả bằng những đường màu xanh lá cây và da trời. Cụ thể, phần màu xanh da trời hiển thị tổng công suất hoạt động của CPU của hệ thống, còn phần màu xanh lá cây là mức hoạt động hiện tại có thể được sử dụng. Resource Monitor hoạt động tương thích với nhiều phiên bản Windows, và nhiều mẫu CPU hiện nay còn có thêm chức năng tự thay đổi mức Clock phụ thuộc vào điện năng được cung cấp và nhiệt độ môi trường.

- Service CPU usage:

Biểu đồ này hiển thị mức hoạt động của CPU qua những dịch vụ hoặc chương trình hoạt động ở chế độ Background.

- CPU 0 - CPU 3:

Đối với mỗi bộ nhân riêng biệt của CPU, thì bao nhiêu % hiệu suất đang được sử dụng? Trong một số trường hợp nhất định, các nhân khác nhau của CPU sẽ được đánh dấu là Parked – nghĩa là đang tạm thời ngừng hoạt động.

<a name="ram"></a>
## RAM

Tiếp theo, nhấp hoặc chạm vào tab Memory. Ở trên cùng, bạn sẽ thấy danh sách các chương trình và quy trình đang sử dụng không gian bộ nhớ, và ở dưới cùng, một biểu đồ thanh cho thấy bạn ở đâu và làm thế nào bộ nhớ sẵn có của bạn đang được sử dụng. Các cột được gắn nhãn Hard Faults / sec, Commit, Working Set, Shareable và Private, mỗi cái đều theo sau (KB) - nghĩa là không gian bộ nhớ bằng kilobytes.

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/tab%20memory.PNG?raw=true">

- Cột Commit cho thấy bạn có bao nhiêu không gian bộ nhớ Windows allots cho mỗi chương trình theo mặc định. Chương trình có thể hoặc không thể sử dụng tất cả các không gian đó. (Nếu các cột của bạn chưa được sắp xếp, hãy nhấp vào cột này để hiển thị cho bạn những gì đang sử dụng bộ nhớ nhất). Cột Làm việc hiển thị số lượng bộ nhớ mà mỗi chương trình đang sử dụng tại thời điểm này.

- Cột shareable cho bạn thấy bộ nhớ được phân bổ cho mỗi chương trình có thể được chia sẻ bởi các chương trình khác như thế nào và cột Private hiển thị số lượng bộ nhớ được phân bổ cho mỗi chương trình chỉ có thể được sử dụng bởi chương trình đó. Nếu một chương trình xuất hiện khi sử dụng quá nhiều bộ nhớ, bạn có thể quyết định đóng nó.

<a name="disk"></a>
## Disk

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/tab%20disk.PNG?raw=true">

### Processes With Disk Activity:

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/processes%20with%20disk%20activity.PNG?raw=true">

Phần chức năng này của chương trình sẽ hiển thị danh sách toàn bộ các ứng dụng đang hoạt động và sử dụng phần lưu trữ trên phân vùng ổ cứng, cụ thể là tên của chương trình đang kích hoạt và số liệu thống kê cụ thể.

- Image: tên các chương trình, tiến trình đang thực thi.
- PID: số ID tương ứng với các tiến trình đang hoạt động.
- Read (B/sec): lượng dữ liệu trung bình tính theo đơn vị byte / giây được đọc bởi chương trình.
- Write (B/sec): lượng dữ liệu trung bình tính theo đơn vị byte / giây được ghi bởi chương trình.
- Total (B/sec): lượng dữ liệu trung bình tính theo đơn vị byte / giây được truy cập bởi chương trình.

Nhưng xét về mặt kỹ thuật, những thông tin được cung cấp tại đây không thực sự tỏ ra hữu ích, vì chúng ta chỉ có thể xem được những chi tiết cơ bản về các ứng dụng, chương trình đang truy xuất dữ liệu trên ổ cứng. Cụ thể tại ảnh chụp màn hình trên, chúng ta có thể dễ dàng nhận ra rằng tiến trình có tên DPMRA.exe đang đọc rất nhiều dữ liệu từ phân vùng lưu trữ.

### Disk Activity:

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/dick%20activity.PNG?raw=true">

Tại phần tiếp theo, chương trình sẽ cung cấp cho người dùng nhiều thông tin có ích hơn trong việc xác định và giải quyết vấn đề đang xảy ra trong hệ thống. Cụ thể, tại cửa sổ bên phải, chúng ta sẽ thấy 2 ô hiển thị chi tiết về tình hình đọc và ghi dữ liệu, cùng với khoảng thời gian hoạt động tương ứng của chương trình.
- File: tên của file được sử dụng bởi chương trình đang trong tình trạng kích hoạt, đồng thời tại đây cũng chỉ ra đường dẫn đầy đủ.
- I/O Priority: mức độ ưu tiên và truyền tải dữ liệu qua phương thức I/O.
- Response Time (ms): thời gian phản hồi từ phân vùng ổ cứng tính theo milisecond. Cụ thể tại đây, nếu số này càng nhỏ thì càng tốt, và bất kỳ ứng dụng nào có khoảng thời gian này nhỏ hơn 10 ms thì có nghĩa là đang trong tình trạng hoạt động ổn định, còn nếu lớn hơn 20 ms thì các bạn cần chú ý đến những ứng dụng đó. Khi thông số này từ 50 ms hoặc lớn hơn, chúng ta đang gặp vấn đề thực sự nghiêm trọng.

### Storage:

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/storage.PNG?raw=true">

- Logical Disk: ký tự của phân vùng gắn liền với ổ cứng.
- Physical disk: ổ cứng nào đang được quản lý tại dòng thông tin này.
- Active Time (%): tỉ lệ thời gian phân vùng ổ cứng vận hành trong các trạng thái, chế độ khác nhau. Ví dụ, nếu 1 ổ cứng liên tục hoạt động với hiệu suất rất cao (80% hoặc cao hơn), thì nhiều khả năng bạn đang gặp tình trạng “thắt nút cổ chai” có liên quan đến dữ liệu, còn nếu con số này gần tới mức 100% thì chắc chắn chúng ta sẽ cần bổ sung nhiều ổ cứng lưu trữ hơn nữa.
- Available Space (MB): dung lượng còn trống để lưu trữ dữ liệu còn lại trên phân vùng ổ cứng.
- Total Space (MB): tổng dung lượng lưu trữ của phân vùng.
- Disk Queue Length: các thông số tại đây chỉ ra số lượng các yêu cầu (đọc và ghi dữ liệu) chưa được giải quyết tại bất kỳ thời điểm nào. Nếu thông số này khá cao thì nguyên nhân có thể do không đủ dung lượng lưu trữ trên phân vùng để đáp ứng các nhu cầu của dịch vụ, chương trình trên hệ thống.

### The graphs:

Công cụ này tỏ ra thực sự hữu ích trong việc xác định cụ thể tỉ lệ truyền tải dữ liệu của hệ thống. Phần màu xanh lá cây hiển thị lượng dữ liệu I/O hiện tại, còn phần màu xanh da trời hiển thị khoảng thời gian hoạt động với hiệu suất cao nhất của phân vùng ổ cứng.

<a name="network"></a>
## Network

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/tab%20network.PNG?raw=true">

### Processes With Network Activity:

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/Processes%20With%20Network%20Activity.PNG?raw=true">

Tại đây, Resource Monitor sẽ hiển thị danh sách tất cả các tiến trình đang hoạt động và đang sử dụng nguồn tài nguyên của hệ thống, cụ thể chúng ta sẽ thấy tên chính xác và số lượng các chương trình đó.

- Image: tên file của tiến trình đang thực thi.
- PID: số ID tương ứng với gắn liền với chương trình, tính năng này khá hữu ích khi người dùng muốn quản lý hoặc giám sát 1 tiến trình nào đó.
- Send (B/sec): dữ liệu trung bình tính theo đơn vị byte mà chương trình đó gửi đi từ hệ thống mạng qua mỗi giây.
- Receive (B/sec): dữ liệu trung bình tính theo đơn vị byte mà chương trình đó nhận được từ hệ thống mạng qua mỗi giây.
- Total (B/sec): tổng lượng dữ liệu trung bình tính theo đơn vị byte mà chương trình đó tạo ra trong toàn bộ thời gian hoạt động.

Tuy nhiên, những thông tin được đưa ra tại đây chưa thực sự hữu ích để giải quyết những vấn đề phức tạp trong hệ thống, ngoại trừ những chương trình nào đang sử dụng ít hoặc nhiều tài nguyên. Với ảnh chụp màn hình trên, chúng ta có thể thấy rằng ứng dụng FSEContentScanner64.exe đang yêu cầu rất nhiều dữ liệu tài nguyên từ hệ thống.

### Network Activity:

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/Network%20Activity.PNG?raw=true">

Tại phần này, chương trình sẽ cung cấp thêm một số thông tin hữu ích hơn dành cho người sử dụng:

- Network I/O: tổng dung lượng dữ liệu đang được sử dụng tính bằng Kbps.
- Network Utilization: toàn bộ dữ liệu của hệ thống sẽ được hiển thị qua 1 thành phần duy nhất, qua đó giúp người sử dụng dễ dàng giám sát chính xác những thông số này. Nếu con số này thường xuyên đạt mức 100% thì có nghĩa là bạn đang gặp vấn đề, và giải pháp duy nhất là tăng lưu lượng băng thông.
- Address: đây là tên hoặc địa chỉ IP của chương trình, ứng dụng đang làm việc.

### TCP Connections:

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/tcp%20connections.PNG?raw=true">

- Local Address: nhiều hệ thống server được trang bị nhiều hơn 1 card mạng, và mỗi card mạng đó lại có thể được gán với nhiều địa chỉ IP. Để xác định chính xác địa chỉ IP hoặc card mạng nào đang gây ra nguyên nhân chính trong hệ thống, đây chính là phần các bạn nên để ý kỹ vì rất nhiều thông tin chi tiết và cụ thể được liệt kê tại đây.
- Local Port: tương tự như trên, hệ thống của bạn có thể đang sử dụng nhiều dịch vụ kích hoạt trên nhiều cổng – Port khác nhau. Và đây là nơi xác định vấn đề giữa hệ thống mạng với các cổng.
- Remote Address: mỗi kết nối qua hệ thống local đều yêu cầu tính năng giao tiếp với 1 hệ thống nào đó đang được điều khiển từ xa. Tại phần này, chúng ta sẽ thấy toàn bộ các địa chỉ của máy tính remote chiếm tới hơn nửa luồng truyền tải dữ liệu.
- Remote Port: tại đây chúng ta sẽ tìm thấy những cổng remote hoàn thiện quá trình giao tiếp giữa hệ thống.
- Packet Loss (%): đây là những con số mang ý nghĩa rất quan trọng, số này càng lớn – đồng nghĩa với việc lưu lượng mạng thất thoát càng lớn, nghĩa là chất lượng của hệ thống mạng đang trong tình trạng xấu.
- Latency (ms): hay thường được gọi là độ trễ, hiểu nôm na là khoảng thời gian cần thiết để truyền dữ liệu từ điểm A tới điểm B. Con số này càng lớn, nghĩa là khoảng thời gian càng dài và ngược lại. Một số chương trình, ứng dụng trực tuyến hoặc truyền tải media thường gây ra hiện tượng này.

### Listening Ports:

<img src="https://github.com/nguyenminh12051997/meditech-thuctap/blob/master/MinhNV/Nagios/image/listenning%20ports.PNG?raw=true">

- Address: một số chương trình, dịch vụ nhất định nào đó thường xuyên gắn liền với một địa chỉ IP cho dù đó là IPv4 hoặc IPv6. Nếu dịch vụ đó không gắn cố định với địa chỉ IP tĩnh, thì cột này sẽ hiển thị dưới dạng <IP … > unspecified.
- Protocol: là giao thức sử dụng TCP (Transmission Control Protocol) hoặc UDP (User Datagram Protocol). Trong đó, quá trình thực hiện qua TCP sẽ được đảm bảo về mặt dữ liệu, còn UDP thì không.
- Firewall Status: nếu tính năng Firewall của bạn đang ngăn chặn một số chương trình qua lượng traffic, thì chúng ta biết thêm nhiều thông tin cụ thể hơn qua phần này.

### The graphs:

Biểu đồ Network sẽ đưa ra toàn bộ lưu lượng bandwidth được sử dụng trong vòng 60 giây gần nhất đối với tất cả các chương trình. Cụ thể hơn, các thành phần TCP Connections chỉ ra bao nhiêu kết nối TCP mới vừa được thiết lập, và nếu số lượng này cao quá mức bình thường, thì có nghĩa là hệ thống của bạn đang gặp vấn đề, không thể kiểm soát được, bị spyware xâm nhập... Biểu đồ Local Area Connection chỉ ra toàn bộ lượng dữ liệu đang được sử dụng, hiển thị theo %.

## Tài liệu tham khảo

- http://www.digitalcitizen.life/how-use-resource-monitor-windows-7


















