# Tìm hiểu LVM

## Mục lục

[I. Tìm hiểu chung về ổ cứng](#o-cung)

- [1. Cấu trúc ổ đĩa cứng HDD](#hdd)
- [2. Các định dạng file system trong Linux](#file)
- [3. Cách quản lí phân vùng ổ cứng trên Linux](#phan-vung)

[II. Tìm hiểu LVM](#lvm)

- [1. Định nghĩa](#def)
- [2. Ưu , nhược điểm](#uu-nhuoc)
- [3. Các thành phần trong LVM](#coms)

------------

### <a name="o-cung"> I. Tìm hiểu chung về ổ đĩa </a>

#### <a name ="hdd"> 1. Cấu trúc ổ cứng HDD</a>

- Ổ đĩa cứng, hay còn gọi là ổ cứng (Hard Disk Drive, viết tắt: HDD) là thiết bị dùng để lưu trữ dữ liệu trên bề mặt các tấm đĩa hình tròn phủ vật liệu từ tính.
- Ổ đĩa cứng là loại bộ nhớ "không thay đổi" (non-volatile), có nghĩa là chúng không bị mất dữ liệu khi ngừng cung cấp nguồn điện cho chúng.

**Cấu tạo ổ đĩa:**

Một cụm đĩa bao gồm đĩa từ, trục quay và động cơ

- Đĩa từ: Đĩa từ (platter): Đĩa thường cấu tạo bằng nhôm hoặc thuỷ tinh, trên bề mặt được phủ một lớp vật liệu từ tính là nơi chứa dữ liệu. Tuỳ theo hãng sản xuất mà các đĩa này được sử dụng một hoặc cả hai mặt trên và dưới. Số lượng đĩa có thể nhiều hơn một, phụ thuộc vào dung lượng và công nghệ của mỗi hãng sản xuất khác nhau.
  Mỗi đĩa từ có thể sử dụng hai mặt, đĩa cứng có thể có nhiều đĩa từ, chúng gắn song song, quay đồng trục, cùng tốc độ với nhau khi hoạt động.

- Đĩa từ bao gồm Track, Sector và Cylinder:
  <ul>
  <li>Track: là các đường tròn đồng tâm trên mặt làm việc của đĩa</li>
  <li>Cylinder: Là tập hợp các track cùng bán kính ở các mặt đĩa khác nhau. Nói một cách chính xác hơn thì: khi đầu đọc/ghi đầu tiên làm việc tại một track nào thì tập hợp toàn bộ các track trên các bề mặt đĩa còn lại mà các đầu đọc còn lại đang làm việc tại đó gọi là cylinder</li>
  <li>Sector: Trên track chia thành những phần nhỏ bằng các đoạn hướng tâm thành các sector. Các sector là phần nhỏ cuối cùng được chia ra để chứa dữ liệu. Theo chuẩn thông thường thì một sector chứa dung lượng 512 byte.</li>
  </ul>

- Trục quay: Trục quay là trục để gắn các đĩa từ lên nó, chúng được nối trực tiếp với động cơ quay đĩa cứng. Trục quay có nhiệm vụ truyền chuyển động quay từ động cơ đến các đĩa từ.

**Nguyên tắc lưu trữ dữ liệu**

 Trên bề mặt đĩa người ta phủ một lớp mỏng chất có từ tính, ban đầu các hạt từ tính không có hướng , khi chúng bị ảnh hưởng bởi từ trường của đầu từ lướt qua , các hạt có từ tính được sắp xếp thành các hạt có hướng.

Đầu từ ghi – đọc được cấu tạo bởi một lõi thép nhỏ hình chữ U, một cuộn dây quấn trên lõi thép để đưa dòng điện vào (khi ghi) hay lấy ra (khi đọc), khe hở gọi là khe từ lướt trên bề mặt đĩa với khoảng cách rất gần, bằng 1/10 sợi tóc .

Trong quá trình ghi, tín hiệu điện ở dạng tín hiệu số 0, 1 được đưa vào đầu từ ghi lên bề mặt đĩa thành các nam châm rất nhỏ và đảo chiều tuỳ theo tín hiệu đưa vào là 0 hay 1 .

Trong quá trình phát, đầu từ đọc lướt qua bề mặt đĩa dọc theo các đường Track đã được ghi tín hiệu, tại điểm giao nhau của các nam châm có từ trường biến đổi và cảm ứng lên cuộn dây tạo thành một xung điện, xung điện này rất yếu được đưa vào khuếch đại để lấy ra tín hiệu 0,1 ban đầu .

**Các chuẩn giao tiếp trên ổ cứng**

- Chuẩn giao tiếp dữ liệu là tập hợp các tập lệnh giúp trao đổi dữ liệu giữa máy tính và thiết bị lưu trữ.
- So sánh các giao diện kết nối ổ cứng ra bên ngoài. Các loại giao diện chính bao gồm IDE, SATA, SCSI, SAS và FC.
- Mỗi loại giao diện có khả năng truyền dữ liệu với tốc độ nhất định (throughput – tốc độ truyền dữ liệu data transfer speed, đơn vị Gbps, Mbps…).

**IDE**

- Chuẩn IDE sử dụng phương thức truyền tải dữ liệu song song.
  <ul>
  <li>Ưu điểm: của truyền tải song song là tốc độ cao. Trong cùng một thời điểm có thể truyền tải nhiều bit dữ liệu hơn so với truyền tải nối tiếp.</li>
  <li>Nhược điểm: Sử dụng nhiều dây dẫn để truyền các bit dữ liệu đi nên gây ra hiện tượng tạp âm nhiễu. Đó là lý do vì sao ATA-66 sử dụng lên đến 80 dây dẫn. Bởi vì giữa các dây truyền tín hiệu là các dây đất nằm xen kẽ dây tín hiệu để chống nhiễu</li>
  </ul>

- Chuẩn EIDE: Do chuẩn IDE bị giới hạn dụng lượng đĩa cứng tối đa, Nên người ta sử dụng chuẩn EIDE để thay thế
  <ul>
  <li>Chia làm 2 kênh (primary và secondary) và 2 kênh này sử dụng 2 đường BUS riêng.</li>
  <li>Trên mỗi kênh lại chia làm 2 cấp (master và slaver) trên cùng 1 kênh. Vì cả 2 thiết chỉ được phép sử dụng 1 đường BUS trong cùng 1 thời điểm.</li>
  <li>EIDE không có khả năng cho phép nhiều thiết bị sử dụng nhiều thiết bị trên cùng 1 BUS trong cùng 1 thời điểm. Nên các thiết bị sẽ được cấp phép để sử dụng tuần tự đường BUS.</li>
  </ul>

**ATA**

- ATA (còn được gọi là PATA –Parallel ATA) sử dụng một giao tiếp gồm 40 chân cắm và cáp 80 dây.
- Chuẩn ATA có dung lượng thấp và tốc độ truyền thấp. Được phát triển và mở rộng dần dần từ ATA1 đến ATA 7. Để nâng cao hiệu suất của EIDE mà không làm tăng chi phí, không còn cách nào khác người ta phải thay thế kiểu giao diện song song bằng kiểu nối tiếp. Kết quả là chuẩn SATA ra đời.

**SATA**

- 27/5/2009 tổ chức ATA đã chính thức công bố chuẩn SATA 3.0 với băng thông dữ liệu lên đến 6Gb/s và nó cho phép tương thích ngược với các chuẩn cũ (SATA 1.0, SATA 2.0).
- SATA sử dụng công nghệ khác cho phép truyền tải theo chế độ nối tiếp.
- Trước kia chúng ta thường cho rằng truyền dẫn nối tíêp bao giờ cũng cho tốc độ thấp hơn truyền dẫn song song. Tuy nhiên vấn đề này chỉ đúng nếu chúng ta sử dụng cùng một tốc độ clock.
- Một giao diện SATA chỉ cho phép gắn 1 ổ cứng duy nhất.
- Các chip điều khiển SATA đều hỗ trợ chuẩn giao tiếp AHCI (Advanced Host Controller Interface) làm giao tiếp chuẩn, hỗ trợ các tính năng nâng cao. Tháo lắp nóng. Tính năng này chỉ hỗ trợ khi thiết bị chạy chế độ AHCI. Những hệ điều hành từ windows Vista or mới hơn thì mới hỗ trợ AHCI. Bạn có thể enable tính năng này trong BIOS.
- Thường sử dụng cho các thiết bị máy tính cá nhân. Sử dụng cable 7 chân và chỉ có 7 sợi nên gọn hơn nhiều so với ATA. Điều này giúp ích rất nhiều đến khía cạnh tỏa nhiệt của máy tính, vì sử dụng nhiều cáp mỏng hơn sẽ làm cho không khí lưu thông bên trong case của máy tính được dễ dàng hơn.

**SCSI**

- Trước tiên SCSI còn được gọi là parallel SCSI. Là chuẩn sử dụng phương thức truyền tải dữ liệu song song.
- Thường sử dụng trong các server lưu trữ và truyền dữ liệu với tốc độ cao
- Là chuẩn giao tiếp thường dùng để kết nối với ổ cứng, máy in, CD-ROM,…
- SCSI không quan tâm đến thiết bị nó kết nối đến là gì. Nó chỉ quan tâm thiết bị đó có làm việc được với chuẩn SCSI không.
- Không như EIDE, SCSI sử dụng Bus PCI hoặc ISAA để truyền tín hiệu dữ liệu
- Chúng ta có thể kết nối 7 thiết bị SCSI chung với nhau rồi kết nối chúng với 1 SCSI Adapter.
- Ổ cứng SCSI có bộ điều khiển SCSI có vi xử lý riêng để xử lý việc truyền nhận dữ liệu và công việc của các thiết bị liên quan mà không cần sử dụng CPU chính để xử lý. Điều này giúp CPU không phải tốn tài nguyên để xử lý các công việc truyền tải mà sử dụng tài nguyên cho việc khác.
- Điểm khác biệt giữa SCSI và EIDE:
  <ul>
  <li>SCSI cho phép một loạt thiết bị sử dụng chung một đường BUS cùng một thời điểm.</li>
  <li>SCSI không sử dụng BUS nếu không sử dụng.</li>
  </ul>

- Bởi vì những hạn chế của phương thức truyền tải dữ liệu song song. Nên kể từ năm 2005 Parallel SCSI đã được thay thế bằng một chuẩn sử dụng phương thức truyền tải dữ liệu nối tiếp là Serial Attached SCSI.

**SAS - Serial Attached SCSI**

- Serial Attached SCSI (SAS) là gao thức nối tiếp point-to-point dùng để truyền dữ liệu từ máy tính đến các thiết bị lưu trữ như đĩa cứng và băng từ (Tape drivers). Các bộ điều khiển SAS được liên kết trực tiếp vào ổ đĩa.
- SAS là chuẩn giao tiếp mới, ra đời sau nhưng lại có nhiều cải tiến về hiệu suất và tốc độ. Nó cho phép nhiều thiết bị (hơn 128 thiết bị) với các kích thước khác nhau được kết nối đồng thời vào cáp mỏng.
  <ul>
  <li>SAS rất mạnh trong việc quản lý dữ liệu, cho phép người dùng thao tác dễ dàng với dữ liệu</li>
  <li>SAS cho phép làm việc với nhiều file dữ liệu cùng lúc.</li>
  <li>Hỗ trợ các đĩa SAS tháo gắn nóng.</li>
  </ul>

- Mỗi thiết bị SAS có một kết nói dành riêng (kết nối point-to-point). Do đó tránh được xung đột trên đường truyền. Mỗi kết nối chạy riêng không chua sẻ, và chạy với tốc độ cao nhất.
- SAS vẫn còn ít sử dụng hơn SATA bởi vì:
  <ul>
  <li>Giá thành cao</li>
  <li>Để tận dụng sức mạnh của SAS người dùng phải mất thời gian học để hiêu các quản lý dữ liệu của SAS.</li>
  </ul>

**FC – Fibre channel**

- FC là công nghệ mạng tốc độ cao (2,4,8 và 16 Gbps). Hỗ trợ cả cáp quang và cáp đồng để phục vụ cho hệ thống lưu trữ.
- FC Protocol là giao thức vận chuyển (transport protocol) dùng để chuyển các tập lệnh SCSI trên hạ tầng mạng FC.
  <ul>
  <li>Chuẩn FC chia thành 5 lớp từ FC0 đến FC4, không theo mô hình OSI.</li>
  <li>Không tương thích ngược với các thiết bị thấp tốc.</li>
  <li>Cáp quang tùy loại, có thể dài tới 50km.</li>
  <li>Tốc độ truyền dữ liệu có thể thay đổi phụ thuộc vào loại cáp, chiều dài</li>
  <li>cáp, cấu hình lắp ráp, cần được tính đến khi thiết kế</li>
  </ul>

#### <a name="file"> 2. Các định dạng file system trong Linux </a>

**Journaling**

Journaling chỉ được sử dụng khi ghi dữ liệu lên ổ cứng và đóng vai trò như những chiếc đục lỗ để ghi thông tin vào phân vùng. Đồng thời, nó cũng khắc phục vấn đề xảy ra khi ổ cứng gặp lỗi trong quá trình này, nếu không có journal thì hệ điều hành sẽ không thể biết được file dữ liệu có được ghi đầy đủ tới ổ cứng hay chưa.

Chúng ta có thể hiểu nôm na như sau: trước tiên file sẽ được ghi vào journal, đẩy vào bên trong lớp quản lý dữ liệu, sau đó journal sẽ ghi file đó vào phân vùng ổ cứng khi đã sẵn sàng. Và khi thành công, file sẽ được xóa bỏ khỏi journal, đẩy ngược ra bên ngoài và quá trình hoàn tất. Nếu xảy ra lỗi trong khi thực hiện thì file hệ thống có thể kiểm tra lại journal và tất cả các thao tác chưa được hoàn tất, đồng thời ghi nhớ lại đúng vị trí xảy ra lỗi đó.

Tuy nhiên, nhược điểm của việc sử dụng journaling là phải “đánh đổi” hiệu suất trong việc ghi dữ liệu với tính ổn định. Bên cạnh đó, còn có nhiều công đoạn khác để ghi dữ liệu vào ổ cứng nhưng với journal thì quá trình không thực sự là như vậy. Thay vào đó thì chỉ có file metadata, inode hoặc vị trí của file được ghi lại trước khi thực sự ghi vào ổ cứng.

**Các định dạng file system**

Có khá nhiều dạng file hệ thống trong Linux, và mỗi loại sẽ được áp dụng với từng mục đích riêng biệt. Điều này không có nghĩa rằng những file hệ thống này không thể được áp dụng trong trường hợp khác, mà tùy theo nhu cầu và mục đích của người sử dụng, chúng ta sẽ đưa ra phương án phù hợp.

- **Ext** – Extended file system: là định dạng file hệ thống đầu tiên được thiết kế dành riêng cho Linux. Có tổng cộng 4 phiên bản và mỗi phiên bản lại có 1 tính năng nổi bật. Phiên bản đầu tiên của Ext là phần nâng cấp từ file hệ thống Minix được sử dụng tại thời điểm đó, nhưng lại không đáp ứng được nhiều tính năng phổ biến ngày nay. Và tại thời điểm này, chúng ta không nên sử dụng Ext vì có nhiều hạn chế, không còn được hỗ trợ trên nhiều distribution.

- **Ext2** : thực chất không phải là file hệ thống journaling, được phát triển để kế thừa các thuộc tính của file hệ thống cũ, đồng thời hỗ trợ dung lượng ổ cứng lên tới 2 TB. Ext2 không sử dụng journal cho nên sẽ có ít dữ liệu được ghi vào ổ đĩa hơn. Do lượng yêu cầu viết và xóa dữ liệu khá thấp, cho nên rất phù hợp với những thiết bị lưu trữ bên ngoài như thẻ nhớ, ổ USB... Còn đối với những ổ SSD ngày nay đã được tăng tuổi thọ vòng đời cũng như khả năng hỗ trợ đa dạng hơn, và chúng hoàn toàn có thể không sử dụng file hệ thống không theo chuẩn journaling.

- **Ext3**: về căn bản chỉ là Ext2 đi kèm với journaling. Mục đích chính của Ext3 là tương thích ngược với Ext2, và do vậy những ổ đĩa, phân vùng có thể dễ dàng được chuyển đổi giữa 2 chế độ mà không cần phải format như trước kia. Tuy nhiên, vấn đề vẫn còn tồn tại ở đây là những giới hạn của Ext2 vẫn còn nguyên trong Ext3, và ưu điểm của Ext3 là hoạt động nhanh, ổn định hơn rất nhiều. Không thực sự phù hợp để làm file hệ thống dành cho máy chủ bởi vì không hỗ trợ tính năng tạo disk snapshot và file được khôi phục sẽ rất khó để xóa bỏ sau này

- **Ext4**: cũng giống như Ext3, lưu giữ được những ưu điểm và tính tương thích ngược với phiên bản trước đó. Như vậy, chúng ta có thể dễ dàng kết hợp các phân vùng định dạng Ext2, Ext3 và Ext4 trong cùng 1 ổ đĩa trong Ubuntu để tăng hiệu suất hoạt động. Trên thực tế, Ext4 có thể giảm bớt hiện tượng phân mảnh dữ liệu trong ổ cứng, hỗ trợ các file và phân vùng có dung lượng lớn... Thích hợp với ổ SSD so với Ext3, tốc độ hoạt động nhanh hơn so với 2 phiên bản Ext trước đó, cũng khá phù hợp để hoạt động trên server, nhưng lại không bằng Ext3.
- **Btrfs** :  là thế hệ tiếp theo của hệ thống tập tin trên Linux, được xây dựng dựa trên hệ thống tập tin COW B-tree, hiện vẫn đang trong giai đoạn phát triển bởi Oracle.. Nó cải thiện không gian cũng như thời gian so với các hệ thống tập tin khác ( ext2, ext3, ext4 ... ) và tăng khả năng quản lý. 

Btrfs giải quyết các vấn đề còn thiếu trên các hệ thống tập tin cũ như: snapshot, checksum dữ liệu, phân vùng và mở rộng trực tiếp ...
Mặc dù theo nhiều nguồn thì BtrFS không hoạt động ổn định trên 1 số nền tảng distro nhất định, nhưng với những tính năng ưu việt như trên thì nó vẫn sẽ là sự thay thế cho Ext4 trong tương lai. Do vậy, BtrFS rất phù hợp để hoạt động với server dựa vào hiệu suất làm việc cao, khả năng tạo snapshot nhanh chóng cũng như hỗ trợ nhiều tính năng đa dạng khác.
Hiện tại có 1 vài distro đã sử dụng Btrfs mặc định như Fedora 18, openSUSE 13.2 ...

- **ReiserFS**: có thể coi là 1 trong những bước tiến lớn nhất của file hệ thống Linux, lần đầu được công bố vào năm 2001 với nhiều tính năng mới mà file hệ thống Ext khó có thể đạt được. Nhưng đến năm 2004, ReiserFS đã được thay thế bởi Reiser4 với nhiều cải tiến hơn nữa. Tuy nhiên, quá trình nghiên cứu, phát triển của Reiser4 khá “chậm chạp” và vẫn không hỗ trợ đầy đủ hệ thống kernel của Linux. Đạt hiệu suất hoạt động rất cao đối với những file nhỏ như file log, phù hợp với database và server email.

- **XFS**: được phát triển bởi Silicon Graphics từ năm 1994 để hoạt động với hệ điều hành riêng biệt của họ, và sau đó chuyển sang Linux trong năm 2001. Khá tương đồng với Ext4 về một số mặt nào đó, chẳng hạn như hạn chế được tình trạng phân mảnh dữ liệu, không cho phép các snapshot tự động kết hợp với nhau, hỗ trợ nhiều file dung lượng lớn, có thể thay đổi kích thước file dữ liệu... nhưng không thể shrink – chia nhỏ phân vùng XFS. Với những đặc điểm như vậy thì XFS khá phù hợp với việc áp dụng vào mô hình server media vì khả năng truyền tải file video rất tốt. Tuy nhiên, nhiều phiên bản distributor yêu cầu phân vùng /boot riêng biệt, hiệu suất hoạt động với các file dung lượng nhỏ không bằng được khi so với các định dạng file hệ thống khác, do vậy sẽ không thể áp dụng với mô hình database, email và một vài loại server có nhiều file log. Nếu dùng với máy tính cá nhân, thì đây cũng không phải là sự lựa chọn tốt nên so sánh với Ext, vì hiệu suất hoạt động không khả thi, ngoài ra cũng không có gì nổi trội về hiệu năng, quản lý so với Ext3/4.

- **JFS**: được IBM phát triển lần đầu tiên năm 1990, sau đó chuyển sang Linux. Điểm mạnh rất dễ nhận thấy của JFS là tiêu tốn ít tài nguyên hệ thống, đạt hiệu suất hoạt động tốt với nhiều file dung lượng lớn và nhỏ khác nhau. Các phân vùng JFS có thể thay đổi kích thước được nhưng lại không thể shrink như ReiserFS và XFS, tuy nhiên nó lại có tốc độ kiểm tra ổ đĩa nhanh nhất so với các phiên bản Ext.

- **Swap**: có thể coi thực sự không phải là 1 dạng file hệ thống, bởi vì cơ chế hoạt động khá khác biệt, được sử dụng dưới 1 dạng bộ nhớ ảo và không có cấu trúc file hệ thống cụ thể. Không thể kết hợp và đọc dữ liệu được, nhưng lại chỉ có thể được dùng bởi kernel để ghi thay đổi vào ổ cứng. Thông thường, nó chỉ được sử dụng khi hệ thống thiếu hụt bộ nhớ RAM hoặc chuyển trạng thái của máy tính về chế độ Hibernate.

### <a name="phan-vung"> 3. Cách quản lí phân vùng ổ cứng trên Linux </a>

#### Qui tắc đặt tên đĩa

**IDE hard disks:**

- dev/hda

Primary master IDE (often the hard disk)

- /dev/hdb

Primary slave IDE

- /dev/hdc

Secondary master IDE (often a CD-ROM)

- /dev/hdd

Secondary slave IDE

**SCSI device files**

- /dev/sda

First SCSI drive

- /dev/sdb

Second SCSI drive

- /dev/sdc

Third SCSI drive (and so on)

#### Qui tắc đặt tên partition

**Primary partitions**

/dev/hda1

/dev/hda2

/dev/hda3

/dev/hda4

**Extended partitions**

/dev/hda1 (primary)

/dev/hda2 (extended)

**Logical partitions**

/dev/hda1 (primary)

/dev/hda2 (extended)

/dev/hda5 (logical)

/dev/hda6 (logical)

/dev/hda7 (logical)

/dev/hda8 (logical)

#### Hướng dẫn quản lí phân vùng trên Linux

- Để liệt kê các ổ đĩa đang được gắn trong máy và phân vùng trên các ổ đĩa dùng lệnh sau:

`#fdisk –l`

/dev/hda là hdh: IDE
/dev/sda  là sdp: SCSI

– Liệt kê các phân khu đang mount và dung lượng đang sử dụng/còn trống của phân vùng

``` sh
#df –l
#df –lh
```

**Phân cùng ổ đĩa**

Giả sử bạn muốn gắn thêm 1 ổ HDD SCSI 20GB.

- Dùng `#fdisk –l` để liệt kê những ổ đang có. Dùng `#ls /dev.sd*` để liệt kê những ổ đĩa sd*

<img src="http://i.imgur.com/rMNa8nl.png">

- Dùng lệnh fdisk với ổ sdb vừa gắn thêm và ấn `m` để hiển thị trợ giúp

<img src="http://i.imgur.com/WKZW4BS.png">

- Để add thêm phần vùng, chọn `n`, `e` để thêm phân vùng extended, lưu ý mỗi máy chỉ được có 4 phân vùng primary. 

Cuối cùng, xác định sector cuối của phân vùng. Ấn Enter để chấp nhật sử dụng hết phần ổ đĩa còn trống. Thay vì chỉ định sector, bạn có thể chỉ định kích thước, chữ viết tắt tương ứng: K – Kilobyte, M – Megabyte và G – Gigabyte. Ví dụ, gõ “+5G” cho phân vùng với kích thước 5 Gigabyte. Nếu bạn không gõ đơn vị sau dấu “+”, fdisk sẽ lựa chọn sector làm đơn vị. Ví dụ, nếu bạn gõ “+10000”, fdisk sẽ cộng thêm 10000 sector để làm điểm kết thúc của phân vùng.

<img src="http://i.imgur.com/26G8Igp.png">

- Lưu ý `Id` ở đây là mã loại phân vùng, bạn có thể xem bằng các gõ `L`:

<img src="http://i.imgur.com/TM86H59.png">

Bạn có thể thay đổi `id` cho phân vùng bằng cách ấn `t` rồi nhập vào mã.

- Sau khi tạo phân vùng, tiến hành ấn `p` để liệt kê những phân vùng vừa chọn, sau đó ấn `w` để lưu lại nếu đã chắc chắn.

**Định dạng một phân vùng**

- Bạn phải định dạng (format) phân vùng trước khi sử dụng. Bạn có thể làm điểu này với lệnh mkfs thích hợp. Ví dụ, câu lệnh sau sẽ định dạng phân vùng thứ 2 của ổ đĩa mới thêm vào với hệ thống tệp tin Ext4:

`mkfs.ext4 /dev/sdb2`

Sử dụng lệnh mkswap để định dạng phân vùng như là phân vùng swap.

`mkswap /dev/sdb2`

Ngoài ra thì bạn cũng có thể dùng mkfs với nhiều loại định dạng khác nữa.

**Mount phân vùng mới tạo**

- Bạn sẽ phải mount các phân vùng ra thư mục thì mới có thể sử dụng nó:

`#mount /dev/sdb2 /ketoan`

Lưu ý đây là kiểu mount mềm, tức là nó sẽ bị mất sau khi khởi động lại. Để mount cứng, tiến hành chỉnh sửa file `#vi /etc/fstab`. Thêm vào cuối file rồi save lại và reboot lại máy.

<img src="http://i.imgur.com/opDN1OD.png">

### <a name ="lvm"> II. Tìm hiểu LVM </a>

#### <a name="def"> 1. Định nghĩa LVM </a>

- Logical Volume Manager (LVM): là phương pháp cho phép ấn định không gian đĩa cứng thành những logical Volume khiến cho việc thay đổi kích thước trở nên dễ dàng hơn (so với partition). Với kỹ thuật Logical Volume Manager (LVM) bạn có thể thay đổi kích thước mà không cần phải sửa lại table của OS. Điều này thật hữu ich với những trường hợp bạn đã sử dụng hết phần bộ nhớ còn trống của partition và muốn mở rộng dung lượng của nó

#### <a name ="uu-nhuoc"> 2. Ưu nhược điểm và vai trò của LVM </a>

**Ưu điểm:**

- Có thể gom nhiều đĩa cứng vật lý lại thành một đĩa ảo dung lượng lớn.
- Có thể tạo ra các vùng dung lượng lớn nhỏ tuỳ ý.
- Có thể thay đổi các vùng dung lượng một cách dễ dàng, linh hoạt

**Nhược điểm:**

- Các bước thiết lập phức tạp và khó khăn hơn
- Càng gắn nhiều đĩa cứng và thiết lập càng nhiều LVM thì hệ thống khởi động càng lâu.
- Khả năng mất dữ liệu cao khi một trong số các đĩa cứng bị hỏng.
- Windows không thể nhận ra vùng dữ liệu của LVM. Nếu Dual-boot ,Windows sẽ không thể truy cập dữ liệu trong LVM.

**Vai trò của LVM**

- LVM là kỹ thuật quan lý việc thay đổi kích thước lưu trữ của ổ cứng.
- Không để hệ thống bị gián đoạn khi họat động.
- Không làm học dịch vụ.
- Có thể kết hợp với Hot Swapping

#### <a name ="coms"> 3. Các thành phần trong LVM </a>

Mô hình các thành phần trong LVM :

<img src=http://i.imgur.com/7od5v6b.png>

- Hard drives - Drives : Thiết bị lưu trữ dữ liệu, ví dụ như ổ cứng HDD,SSD,...
- Partion : Là các phân vùng của Hard drives. Mỗi Hard drives có thể chia được thành 4 phân vùng, trong đó có 2 loại phân vùng đó là Primary Partition và Extended Partition.
  <ul>
  <li>Primary Partition : Là phân vùng chính ,có thể khởi động . Mỗi đĩa cứng có thể chia được tối đa 4 phân vùng này.</li>
  <li>Extended Partition : Phân vùng mở rộng, có thể tạo vùng luân lý.</li>
  </ul>

- Physical Volumes : là một cách gọi khác của Partion trong kỹ thuật LVM, nó là những thành phần cơ bản được sử dụng bởi LVM. Một Physical Volume không thể mở rộng ra ngoài phạm vi một ổ đĩa. Chúng ta có thể kết hợp nhiều Physical Volume thành mọt Volume Groups.

- Volume Group : Nhiều Physical Volume trên những ổ đĩa khác nhau được kết hợp lại thành một Volume Group

<img src=http://i.imgur.com/IEw8o09.png>

Volume được sử dụng để tạo ra các Logical Volume, trong đó người dùng có thể tạo, thay đổi kích thước, lưu trữ, gỡ bỏ và sử dụng.

Một điểm cần lưu ý là boot loader không thể đọc được /boot khi nó nằm trên Logical Volume Group. Do đó không thể sử dụng kỹ thuật LVM với /boot mout point.

- Logical Volume : Volume Group được chia nhỏ thành nhiều Logical Volume, mỗi Logical Volume có ý nghĩa tương tự như các Partition . Nó được dùng các mout point và được format với những định dạng khác nhau như ext2, ext3, ext4,....

<img src=http://i.imgur.com/iuIaEbl.png>

Khi dung lượng của Logical Volume được sử dụng hết , ta có thể đưa thêm ổ đĩa mới bổ sung cho Volume Group và do đó tăng được dung lượng của Logical Volume .

- File Systems :
  <ul>
  <li>Tổ chức và kiểm soát các tệp tin</li>
  <li>Được lưu trữ trên ổ đĩa cho phép truy cập nhanh chóng và an toàn</li>
  <li>Sắp xếp dữ liệu trên đĩa cứng máy tính</li>
  <li>Quản trị vât lý của mọi thành phần dữ liệu.</li>
  </ul>