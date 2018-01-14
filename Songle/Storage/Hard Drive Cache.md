# Hard Drive Cache


### 1. Định nghĩa

![Imgur](https://i.imgur.com/rcLMNQB.gif)

- Hard Drive Cache thường được coi như disk buffer ( bộ nhớ đệm của ổ cứng ).
- Ổ cứng có bộ vi xử lí tích hợp sẵn để điều khiển và xử lý việc đọc / ghi dữ liệu. Bộ nhớ
cache hoạt động kết hợp với bộ điều khiển đó để lưu trữ dữ liệu khi đang được xử lý.

- *Bạn cũng có thể nghĩ nó giống như một bộ đệm video. Mọi người đều đã xử lý một luồng video trên một kết nối chậm. 
Trình phát video đợi trước hoặc trong quá trình phát lại để thu thập nhiều dữ liệu hơn để có thể tiếp tục phát video một cách trơn tru hơn. 
Bộ nhớ cache của ổ cứng cho phép ổ cứng thực hiện cùng một điều trong khi đọc hoặc ghi dữ liệu.*

- Dung lượng cache phổ biến hiện nay :

	- HDD: 8 - 256 Mb
	- SSD: 1 GB
### 2. Cách thức hoạt động

- Khi ổ cứng đọc/ghi dữ liệu, nó phải đẩy dữ liệu từ các tấm đĩa. Trong trường hợp nêu nó làm việc với một dữ liệu nhiều lần, 
vì người dùng có thể làm việc trên một hoặc nhiều tác vụ một lúc.  

=> Ổ cứng giữ những dữ liệu mà các chương trình người dùng sử dụng thường xuyên vào cache của nó.
=> Mỗi khi cần có thể lấy trực tiếp từ cache luôn mà không phải truy xuất từ các platter trên hdd.

**Các bước đọc/ghi dữ liệu của ổ cứng sử dụng cache:**

	- Bước 1: Khi có chương trình yêu cầu dữ liệu từ ổ cứng, ổ cứng trích xuất dữ liệu từ platter.
	
	- Bước 2: Ổ cứng không chỉ lấy mình dữ liệu mà chương trình cần, nó cũng trích xuất các dữ liệu xung quanh platter mà nó vừa 
	lấy dữ liệu ra.
	
	- Bước 3: Ổ cứng lưu dữ liệu chính và các dữ liệu xung quanh lên cache. Việc này được thực hiện bằng cơ chế đoán biết được lập trình sẵn 
	trên ổ cứng, nó tính toán để bù đắp lại các mặt hạn chế về tốc độ của các bộ phận vật lý bằng việc lưu cả những dữ liệu gần khu vực ổ cứng 
	vừa trích xuất dữ liệu lên cache, vì rất có khả năng người dùng sẽ lại sử dụng những dữ liệu đó.
	
### Cache trong SSD:

- Mặc dù tốc độ đọc/ghi của SSD rất cao nhờ việc sử dụng chíp nhớ, tuy nhiên nó vẫn sử dụng cache để có thể nâng cao hơn
 tốc độ xử lí dữ liệu.
 
- Cache trong SSD không giống cache trên HDD. Trong khi cache trên HDD giống RAM tĩnh, thì trên SSD là DRAM (ram động) cho tốc độ nhanh hơn và lưu
 được nhiều dữ liệu hơn.
