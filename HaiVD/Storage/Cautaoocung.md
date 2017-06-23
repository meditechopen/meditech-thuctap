# Cấu tạo ổ cứng

Ổ cứng HDD (Hard Disk Driver) là loại lưu trữ cơ bản và sẽ không thay đổi trên máy tính. Nghĩa là nó không mất đi như các dữ liệu lưu trên bộ nhớ hệ thống khi bạn tắt máy tính. Ổ cứng HDD có cấu tạo cơ bản là đĩa kim loại được phủ một lớp từ tính. Khi ổ cứng HDD hoạt động, một đầu đọc / ghi trên một thanh kim loại sẽ truy cập vào dữ liệu trong khi phần đĩa cứng được quay trong một khay chứa đĩa.

![oc](/HaiVD/Storage/images/ocung.jpg)


- Đĩa từ : thường được làm bằng nhôm, thủy tinh, sứ,... bề mặt được phủ một vật liệu từ tính,là nơi chứa dữ liệu. Sau khi được hoàn tất và đánh bóng, các đĩa này được xếp chồng lên nhau,ghép nối với mô tơ quay,chúng được gắn song song và quay đồng trục,cùng tốc độ với nhau khi hoạt động. Số lượng đĩa có thể nhiều hơn 1, phụ thuộc vào dung lượng và công nghệ của nhà sản xuất. Trước khi các đĩa từ được lắp vào khung, các dầu từ được ghép vào giữa các đĩa. Dữ liệu được ghi vào các đường tròn đồng tâm.


## Cấu tạo đĩa từ

![oc](/HaiVD/Storage/images/cylinder.png)

- Track : mỗi vòng tròn đồng tâm trên đĩa được gọi là track.Track trên ổ đĩa cứng không cố định từ khi sane xuất, chúng có thể thay đổi vị trí khi định dạng ổ đĩa cấp thấp.Thông thường một đĩa có từ 312 đến 2048 rãnh.
- Sector : mỗi trạc được chia thành những phần nhỏ bắn các đoạn hướng tâm tạo thành các Sector (cung từ). Sector là đơn vị chứa dữ liệu nhỏ nhất.Theo các chuẩn thông thường thì một sector chưa 512 byte,Số sector trên các track từ phần rìa đĩa đến trung tâm đĩa là khác nhau và giảm dần về tâm.Các ổ đĩa được chia thành 10 vùng mà trong mỗi vùng có số Sector/ track là bằng nhau.
- Cluster : Trong lĩnh vực lưu trữ dữ liệu ở mức độ hệ điều hành, cluster (liên cung) là một đơn vị lưu trữ gồm một hoặc nhiều sector . Khi hệ điều hành lưu trữ một tập tin vào đĩa , nó ghi tập tin đó vào hàng chục, hàng trăm cluster liền nhau.Nếu không sẵn cluster liền nhau, hệ điều hành sẽ tìm kiếm cluster còn trống ở kế tiếp đó và ghi tiếp tập tin lên đĩa.
- Cylinder : Bao gồm những Track có chung một tâm và đồng trục nằm trên những mặt đĩa từ.Tập hợp các trách có cùng bán kính ở các mặt đĩa khác nhau tao thành các cylinder.

## Mô tơ trục quay
- Mô tơ trục quay là các bộ phận để gắn các đĩa từ lên đó, chúng được nối trực tiếp với động cơ quay đĩa cứng, Trục quay có nhiệm vụ truyền chuyển động quay từ động cơ đến các đĩa từ. Trục quay thường được chế tạo bằng các hợp kinh và phải được thiết kế một cách chính xác, không bị sai lệch.
- Một trong nhưng yếu tố xác định chất lượng ổ cứng là tốc độ mà đĩa quay lướt qua đầu đọc.Thường là 3600 vòng/phút.Bây giờ được cải tiến lên 5400 vòng/phút hoặc 7200 vòng/phút. Thậm chí với công nghệ hiện đại, tốc độ quay của một số hãng đã đạt tới 10000 rpm (round per minute) và 15000 rpm.

## Bảng mạch điều khiển
- Bảng mạch điều khiển hồm có Mạch điều khiển và Mạch xử lý dữ liệu.
- Mạch xử lý dữ liệu thường được dùng để xử lý những dữ liệu được đọc ghi của ổ cứng.
- Mạch điều khiên có nhiệm vụ điều khiển mô tơ trục quay, điều khiển sự di chuyển của thanh mang đầu từ để đảm bảo đúng vị trí trên bề mặt đĩa.
- Bảng mạch điều khiên vào gồm nhiều chip điều khiển toàn mạch, chip điều khiển vào/ra , bộ nhớ đệm cho ổ cứng (HDD cache), một ổ cắm nguồn và chân cắm chuẩn IDE hoặc SATA.
- Bộ nhớ đệm là nơi tạm lưu dữ liệu trong quá trình đọc/ghi dữ liệu .Dữ liệu trên bộ nhớ đệm sẽ mất khi ổ cứng ngừng được cấp điện. Đối với các ổ cứng trước đây, cache chỉ tầm khoảng 512kb nhưng hiện tại, cache đã lên đến 3MB, 6MB. Độ lớn của cache ảnh hưởng rất lớn đến hiệu suất họat động của ổ đĩa cứng.

## Truy cập dữ liệu

![oc](/HaiVD/Storage/images/access.png)

Trong ổ cứng có 2 cách truy nhập dữ liệu :
- Sequential access :  là thuật ngữ dùng để miêu tả việc đọc hoặc ghi các bit dữ liệu liên tiếp nhau. Đối với ổ cứng thông tường, các bit dữ liệu được lưu trữ trên các sector, nếu dữ liệu được lưu trữ trên các sector liên tiếp, việc đọc dữ liệu sẽ nhanh hơn vì thời gian tìm kiếm (seek time) sẽ giảm đi. Tương tự, nếu dữ liệu được ghi liên tiếp thì sẽ nhanh hơn vì chỉ tốn một vòng quay để ghi các sector liên tiếp.
- Random access:là thuật ngữ dùng để miêu tả việc đọc hoặc ghi các bit dữ liệu ngẫu nhiên lộn xộn trên các sector phân bố ngẫu nhiên trên ổ cứng. Vì dữ liệu nằm rời rạc nên phải tốn thời gian tìm kiếm, nên vấn đề đọc/ghi dữ liệu random thường khá tốn thời gian.

## IOPS,Latency và Throughput
- IOPS, Latency và Throughput là ba khái niệm mà bất cứ Sys Admin nào cũng cần quan tâm, khi bắt đầu xây dựng hệ thống Storage.

![oc](/HaiVD/Storage/images/io.png)

Hiểu nôm na
- IOPS là số lượng chuyến đi thực hiện được trong 1 khoảng thời gian.
- Throughput : Số hàng được chuyển đi trong một khoảng thời gian.
- Latency : Đỗ trễ trung bình trong tất cả các chuyến đi trong một khoảng thời gian đã thực hiện.


Ba tham số này, đặc biệt là 2 tham số IOPS và latency phản ánh chất lượng phục vụ của bộ nhớ nhưng không phải lúc nào 2 tham số này cũng theo chiều cùng tốt hoặc cùng xấu. Có thể IOPS cao nưng Latency lại thấp, cũng có thể IOPS thấp nhưng Latency lại cao,hoặc cũng có thể cả 2 đều cao và cả 2 đều thấp.

**IOPS**
- Là đơn vị đo lường thowngf được sử dụng cho các thiết bị lưu trữ như HDD,SSD hoặc SAN - cho biết lượng tác vụ đọc và viết được hoàn thành trong một giây.Số IOPS được các nhà sản xuất công khai và không liên quan gì đến ứng dụng đo lường hiệu năng.


Cách tính IOPS và số lượng ổ cứng :
- Tổng IOPS = IOPS per Disk * Số ổ cứng
- IOPS thực = (Tổng IOPS * %Write)/(Raid Penalty) + (Tổng IOPS * %Read)
- Số lượng ổ cứng = ((Read IOPS) + (Write IOPS * Raid Penalty))/ IOPS per Disk

**Latency - Thông số quan trọng nhất trong hệ thống lưu trữ**

![oc](/HaiVD/Storage/images/latency.png)

- Latency là khái niệm về tốc độ xử lý một request I/O của hệ thống. Khái niệm này rất quan trọng bởi vì một hệ thống lưu trữ mặc dù chỉ có 1000 IOPS với Latency 10ms , vẫn có thể tốt hơn 1 hệ thống 5000 IOPS nhưng Latency 50ms.Đặc biệt là đối với các ứng dụng nhạy cảm như Database.
- Khi một ổ cứng tăng IOPS thì tốn nhiều Latency hơn .


##
