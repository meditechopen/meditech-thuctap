	

# Cache ( bộ nhớ đệm )

## 1. Tổng quát

### Cache là gì?
- Cache là bộ nhớ nằm bên cạnh CPU, bộ nhớ này có tốc độ truy cập rất nhanh. Do làm bằng chất liệu cao cấp nên CPU nào có cùng tốc độ mà cache lớn hơn thì giá thành cao hơn. Nhiệm vụ của cache này là lưu các lệnh mà HDH đưa xuống chờ CPU xử lý. Bộ nhớ Ram chứa chương trình, Cache chứa các lệnh.

- Bộ nhớ Cache là bộ nhớ nằm bên trong của CPU, nó có tốc độ truy cập dữ liệu theo kịp tốc độ xủa lý của CPU, điều này khiến cho CPU trong lúc xử lý không phải chờ dữ liệu từ RAM vì dữ iệu từ RAM phải đi qua Bus của hệ thống nên mất nhiều thời gian.

- Một dữ liệu trước khi được xử lý, thông qua các lệnh gợi ý của ngôn ngữ lập trình, dữ liệu được nạp sẵn lên bộ nhớ Cache, vì vậy khi xử lý đến, CPU không mất thời gian chờ đợi . Khi xử lý xong trong lúc đường truyền còn bận thì CPU lại đưa tạm kết quả vào bộ nhớ Cache, như vậy CPU không mất thời gian chờ đường truyền được giải phóng .

- Bộ nhớ Cache là giải pháp làm cho CPU có điều kiện hoạt động thường xuyên mà không phải ngắt quãng chờ dữ liệu, vì vậy nhờ có bộ nhớ Cache mà hiệu quả xử lý tăng lên rất nhiều, tuy nhiên bộ nhớ Cache được làm bằng Ram tĩnh do vậy giá thànhcủa chúng rất cao



### Các cấp độ của bộ nhớ

![Imgur](https://i.imgur.com/sBxgklh.png)

- **Level 1 hay Register**: Một loại bộ  nhớ cache mà dữ liệu được lưu trực tiếp trên CPU. Hầu hết các trường hợp sử dụng **register** là thanh chứa thông tin, chương trình truy cập, đăng kí địa chỉ.
- **Level 2 or Cache memory**: Đây là bộ nhớ có thời gian truy cập nhanh nhất, nơi dữ liệu được lưu trữ tạm thời để truy cập nhanh hơn.
- **Level 3 or Main Memory**: bộ nhớ ram mà hệ điều hành sử dụng, khi mất điện toàn bộ dữ liệu trong ram sẽ mất.
- **Level 4 or Secondary Memory**: bộ nhớ ngoài(HDD, SSD), không nhanh bằng ram nhưng dữ liệu tồn tại cố định trong nó và không bị mất đi khi bị cắt nguồn điện. 

### Các loại cache

Hiện nay CPU (đa nhân) có 3 loại cache là L1, L2 và L3:
- **Cache L1**: Được tích hợp vào lõi của CPU. Tốc độ truy xuất của cache L1 tương đương với tốc độ của CPU nhưng dung lượng khá nhỏ với hai thành phần chính là Data cache và Code cache (trong một số CPU được gọi là Instruction cache hay Trace cache) để lưu trữ dữ liệu và mã lệnh.

- **Cache L2**: được gọi là external cache hay cache phụ. Chức năng chính của cache L2 là dựa vào các lệnh mà CPU sắp thi hành để lấy dữ liệu cần thiết từ RAM, CPU sẽ dùng dữ liệu ở cache L2 để tăng tốc độ xử lý.

- **Cache L3**: dùng chung cho tất cả các nhân, giúp việc trao đổi dữ liệu giữa các nhân hiệu quả hơn mà không cần thông qua các cache bên trong của mỗi nhân.


### Hiệu suất của Cache

Khi cpu cần đọc/ghi dữ liệu từ ổ cứng,nó sẽ kiểm tra các mục liên quan đến tiến trình sắp thực hiện trong cache đầu tiên.
	- Nếu cpu tìm thấy dữ liệu nó đang cần trong cache, sẽ xảy ra một trường hợp gọi là **cahe hit** , cpu sẽ trích xuất dữ liệu trực tiếp từ cache luôn.
	- Nếu cpu không thấy dữ liệu nó cần trong cache, sẽ xảy ra trường hợp **cache miss**, sau đó  cache sẽ truy xuất các tập lệnh và dữ liệu mới mà cpu cần từ ram, cpu sẽ tiến hành lấy dữ liệu từ cache.

Hiệu suất của cache được tính toán dựa trên một quy chuẩn gọi là **Hit ratio**

```
Hit ratio =  hit / (hit+miss) =  no. of hits/total accesses
```

- Chúng ta có thể cải thiện hiệu suất của Cache bằng cách sử dụng cache block lớn hơn, thành phần bổ trợ mạnh hơn, giảm tỉ lệ miss, giảm thời gian miss penalty ( thời gian xử lí cache miss), giảm thời gian truy xuất dữ liệu (hit time) trên cache.

## 2. Cơ chế làm việc của Cache

### Cache Mapping (ánh xạ giữa ram và cache)

Có 3 kiểu mapping được dùng khi sử dụng cache:
- Direct mapping ( ánh xạ trực tiếp )
- Associate mapping ( ánh xạ liên kết hoàn toàn)
- Set-Asociate mapping ( ánh xạ liên kết theo tập hợp )

#### Direct mapping

- Ánh xạ trực tiếp : block 0 đưa vào cache sẽ đưa vào line 0, block 1 đưa vào line 1,... theo thứ tự.
- Khi lượng **Line** trong Cache chỉ là m Line trong khi số lượng Block từ ram lớn hơn nhiều,Block thứ m sẽ được đưa vào line 0 ( xoay vòng), và block đang nằm trong line 0 sẽ bị xóa khỏi cache.
- Để biết được Block từ Ram nào được đưa vào Line đang xét, ta sử dụng trường Tag của Line đó để xác định.
- Khi CPU cần truy xuất ô nhớ có địa chỉ là X gồm N bit, nếu bộ nhớ đang sử dụng phương pháp direct mapping
#### Associate mapping

- Cho phép 1 Block khi chuyển vào cache sẽ có thể nằm ở bất kì Line nào miễn sao nó còn trống.
- Khi CPU muốn tìm ô nhớ nào thì phải duyệt từng Line một trong Cache cho đến khi thấy thì thôi.

#### Set associative mapping

Kết hợp của 2 phương pháp direct mapping & associate mapping.
- Thay vì 1 



