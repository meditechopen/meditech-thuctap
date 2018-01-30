# Cài đặt phần mềm trên Ubuntu

Nội dung: các gói phần mềm và việc quản lý chúng trên Ubuntu.

### Package là gì?

-  Package là phần mềm bạn có thể chạy trên máy tính. Khi cài đặt phần mềm, sẽ có rất nhiều file 
cần dùng đến để phần mềm có thể chạy được và mọi thứ trở nên phức tạp và khó để quản lí.
- Với Ubuntu thì khác, nó sử dụng các gói để lưu trữ tất cả mọi thứ mà một chương trình cụ thể 
cần để chạy. Một package đơn giản là tập hợp các tập tin được đóng gói vào 1 tập tin duy nhất khiến cho 
việc cài đặt và quản lí dễ dàng hơn  rất nhiều.


### Source hay Binary?


- Các gói nguồn (**source package**) chỉ đơn giản là các gói chỉ bao gồm mã nguồn và thường có thể được 
sử dụng trên bất kỳ loại máy nào nếu mã được biên dịch đúng cách. 
(Để biết thông tin về cách biên dịch và cài đặt gói nguồn, xem CompilingEasyHowTo).

- Các gói nhị phân (**binary package**) là những gói đã được thực hiện cụ thể cho một loại máy tính hoặc kiến ​​trúc. 
Ubuntu hỗ trợ kiến ​​trúc x86 (i386 hoặc i686), AMD64 và PPC. Các gói nhị phân chính xác sẽ được sử 
dụng tự động, do đó bạn không phải lo lắng về việc chọn đúng. Để biết bạn đang sử dụng ứng dụng nào, 
hãy mở Applications → Accessories → Terminal, gõ uname -m sau đó nhấn phím enter.

### Package Dependencies

- Có một số gói phần mềm con chứa các tệp mà nhiều chương trình khác nhau có thể dùng nó để cài đặt , goi là các gói 
dependencies package.
- Khi cài đặt một chương trình, dependencies phải được cài đặt cùng lúc. 

![Imgur](https://i.imgur.com/sMM04MP.jpg)
*ví dụ về dependencies*

### Package Managers

Trình quản lý gói là một ứng dụng xử lý việc tải xuống và cài đặt gói. 
Ubuntu mặc định đã có một vài package managers, và cái nào bạn sử dụng tùy thuộc vào mức độ của 
các nhiệm vụ quản lý gói mà bạn muốn đạt được. Hầu hết mọi người chỉ cần sử dụng trình quản lý gói 
cơ bản nhất, công cụ Thêm / Xóa, rất dễ sử dụng.

### Software Channels/Repositories

Ban có thể lấy các gói từ đâu??

- Ubuntu lưu trữ các gói phần mềm của nó trong một nơi gọi là software channels hay repositories. 
Nó giống như một cái kho được lưu trên một hay nhiều server trên đám mây, khi người dùng muốn cài đặt 
gói nào thì dùng lệnh để trỏ đến kho đó và lấy nó về để cài đặt.

- Software Managers sẽ lưu trữ một chỉ mục của tất cả các gói có sẵn từ một kênh phần mềm. 
Thi thoảng nó sẽ 'cập nhật lại' chỉ mục này để đảm bảo rằng nó được cập nhật và biết gói nào đã 
được nâng cấp hoặc bổ sung vào kênh kể từ lần kiểm tra cuối cùng.

- Có bốn kênh phần mềm cho mỗi cấu trúc - Main, Restricted, Universe và Multiverse. 
	- Theo mặc định, chỉ các package trên channel Main và Restricted có thể được cài đặt Nếu muốn cài đặt
	các gói từ Universe hoặc Multiverse.
	
- Ngoài các kho chính thức của Ubuntu, bạn có thể sử dụng kho bên thứ ba. 
Hãy cẩn thận, mặc dù - một số không tương thích với Ubuntu và sử dụng chúng có thể khiến các 
chương trình ngừng hoạt động hoặc thậm chí gây ra thiệt hại nghiêm trọng cho quá trình cài đặt 
của bạn. Trang http://www.ubuntulinux.nl/source-o-matic (trang đã bị xóa - tại sao) có thể giúp 
bạn tìm thêm các kho lưu trữ và trang Kho lưu trữ cung cấp hướng dẫn về cách bật chúng

## Cài đặt một gói trên Ubuntu

### Qua trình duyệt web

Trong tài liệu Ubuntu, đôi khi bạn tìm thấy các câu như ví dụ:
"Để cài đặt phần mềm này trong Ubuntu, hãy cài đặt gói sau: supertux".
Nhấp vào tên của gói ("supertux" trong ví dụ):

1. Nếu giao thức apturl được kích hoạt trên máy tính của bạn, bạn sẽ được đề xuất để cài đặt package "supertux" đó

2. Nếu không, hãy làm theo hướng dẫn của trang Apturl để kích hoạt giao thức apturl trên máy tính của bạn.

### Qua giao diện cơ bản

Lưu ý rằng một số package không thể cài đặt với phương thức này, trong trường hợp đó vui lòng sử dụng phương thức khác.

- Với ubuntu: "Software Center"

Trong phiên bản gần đây của Ubuntu, tùy chọn "Add/Remove" trong menu Applications được thay thế bằng Ubuntu Software center

- Với Kubuntu: "Add/Remove program"

Cài package mới dễ dàng với Kubuntu là sử dụng công cụ "Add/Remove Programs'". Click K-Menu -> Add/Remove Program to start it.

!<img src="https://i.imgur.com/T0qRGF2.png">

**Add/Remove Program** 

Một cách đơn giản để cài đặt và gỡ bỏ các ứng dụng trong Kubuntu. Để khởi chạy Add/Remove Program, chọn K-Menu -> Add/Remove Programs từ desktop menu system.

- Để cài đặt một ứng dụng mới, hãy chọn danh mục ở bên trái, sau đó chọn hộp ứng dụng bạn muốn cài đặt. Khi hoàn tất, hãy nhấp vào Áp dung, sau đó các chương trình bạn chọn sẽ được tải xuống và cài đặt tự động, cũng như cài đặt bất kì ứng dụng bổ sung nào được yêu cầu. Lựa chọn mặc định giới hạn trong bộ phần mền KDE, nhưng các ứng dụng GNOME có thể được cài đặt đơn giản bằng cách chọn từ trình đơn thả xuống ở trên cùng. Ngoài ra, nếu bạn biết tên của chương trình bạn muốn, hãy sử dụng công cụ tìm kiếm ở trên cùng.

- Phần mềm từ các kho bổ sung có thể được cài đặt bừng cách cho phép **Hiển thị** hộp kiểm **Không được hỗ trợ** và **Hiển thị: phần mềm sở hữu độc quyền** nếu chúng được kích hoạt trong danh sách kho của bạn.

- Khi việc này hoàn thành, hãy nhấp vào Đóng. Ứng dụng của bạn đã sẵn sàng để sử dụng.

### Thông qua giao diện nâng cao

Cho Ubuntu/Kubuntu/Edubuntu: Synaptic

- Các **Synaptic Package Management** cung cấp một cách tiên tiến hơn của việc cài đặt các gói. Nếu bạn gặp sự cố khi tìm package phù hợp với công cụ Add/Remove, hãy sử dụng công cụ tìm kiếm trong Synaptic. Việc này tìm kiếm tất cả các package trong các kho có sẵn, ngay cả những gói không chứa chương trình.

### Thông qua câu lệnh

- Các phương pháp dựa trên văn bản có thể được sử dụng trên Ubuntu, Kubuntu và Xubuntu nhưng yêu cầu quen với thiết bị đầu cuối. Khi giúp người dùng cài đặt package, bạn nên xem xét sử dụng aptURL thay vì apt-get hoặc aptitude.

### Aptitude - Phương pháp dựa trên văn bản

!<img src="https://i.imgur.com/fvCTXFF.png">

- Aptitude là một package management  dựa trên văn bản, nó phải được chạy từ Terminal.

### apt-get : Phương pháp kỹ thuật

- Chương trình apt-get là một trình quản lý gói dòng lệnh, cần được sử dụng nếu công cụ Add/remove và synaptic không xử lý được vấn đề. Nó cung cấp một giao diện tiện ích cho APT, hệ thống quả lý package mà Ubuntu sử dụng nhưng hợp lý và dễ vận hành. Người dùng có thể thấy rằng apt-get nhanh hơn và mạnh hơn các tùy chọn ở trên.

### Installing downloaded packages

- Bạn có thể cài đặt package mà bạn đã tải xuống từ web, thay vì từ một kho phần mềm. Các package này được gọi là các tệp .deb. Bởi vì chúng có thể đã được tạo ra cho các phiên bản Linux khác nhau, nghĩa là chúng có thể không gỡ cài đặt được.
- Để tìm một package mà bạn đã tải về trước bằng synaptic, aptitude hoặc apt-get, hãy tìm trong các thư mục:  `/var/cache/apt/archives`

### Using GDebi to install packages.

- GDebi là một công cụ đơn giản để cài đặt các file .deb. Nó có một giao diện đồ họa người dùng nhưng cũng có thể được sử dụng trong thiết bị đầu cuối của bạn. Nó cho phép bạn cài đặt các package local để giải quyết và cài đặt các phần phụ thuộc của nó. Nó tự động kiểm tra gói cho các mối quan hệ phụ thuộc của chúng và sẽ cố gắng tải chúng từ các kho phần mềm của Ubuntu nếu có thể. Đầu tiên banh cần cài đặt GDebi - chỉ cần cìa đặt package GDebi bằng một trong những trình package management ở trên hoặc mở Terminal lên và nhập lệnh: `sudo apt-get install gdebi`
- Khi bạn đã cài đặt GDebi, sử dụng file Browser để tìm package bạn muốn cài đặt. package đó trông giống như:

!<img src="https://i.imgur.com/RgOnpPc.png">

- Nhấn đúp vào nó để mở bằng GDebi. Nếu tất cả các phụ thuộc đã được đáp ứng cho gói đã chọn, chỉ cần nhấp vào nút "Cài đặt gói" để cài đặt nó. GDebi sẽ cảnh báo bạn nếu có các phụ thuộc không đáp ứng được, nghĩa là có những sự phụ thuộc không được đáp ứng trong các kho mà bạn đang sử dụng.
### Using dpkg to install package
- `dpkg` là một công cụ dòng lệnh được sử dụng để cài đặt các package. Để cài đặt `dpkg`, hãy mở terminal và nhập lệnh:
```
cd directory
sudo dpkg -i package_name.deb
```
**Lưu ý:** Bạn nên đọc hướng dẫn sử dụng dpkg trước khi sử dụng vì việc sử dụng nó không đúng sẽ có thể dẫn đến việc mất dữ liệu trong package management.
### Get a list of recently installed packages

- Bạn có thể sử dụng dpkg logs để phát hiện các package đã được cài đặt gần đây.
`zcat -f /var/log/dpkg.log* | grep "\ install\" | sort`

## Tự động cập nhật: Update Manager

- Ubuntu sẽ tự động thông báo cho bạn khi cập nhật bảo mật và nâng cấp phần mềm. Trình quản lý cập nhật Ubuntu là một ứng dụng đơn giản và dễ sử dụng giúp người dùng giữa lại phần mềm hệ thống cho họ. Đơng giản chỉ cần nhấp vào biểu tượng cập nhật (sẽ xuất hiện trong khu vực thông báo), nhập pass và làm theo các hướng dẫn trên màn hình để tải xuống và cài đặt bản cập nhật.
- Cập nhật rât quan trọng vì các bản sửa lỗi bảo mật để bảo vệ máy tính của bạn khỏi bị tổn hại được phân phối theo cách này.
<img src="https://i.imgur.com/zcKWie1.png">

### Cài đặt offline 
- Đôi khi không có internet để cài đặt một chương trình.

- Có thể cài đặt các chương trình mà không có đĩa CD hoặc DVD trên máy tính offline, đơn giản là sử dụng một USB để copy các package bạn cần.
Có một số phương pháp để thực hiện là:

#### Sử dụng Keryx

- Keryx là một package managerment di động, nền tảng cho các hệ thống dựa trên APT(Ubuntu, Debian). Nó cung cấp một giao diện đồ họa để thu thập cập nhật, package và gói phụ thuộc cho các máy tính offline. Keryx là mã nguồn mở miễn phí. ban có thể tải Keryx tại đây: https://launchpad.net/keryx

#### Sử dụng Synaptic download_script

Hướng dẫn:

1. Chạy Synaptic trên máy tính offline
2. Đánh dấu các package bạn muốn cài
3. Chọn File -> Generate package download script(tạo script để tải package)
4. Lưu script vào USB của bạn
5. Cắm USB vào máy tính online và chạy script vừa tạo. Nó sẽ chỉ tải về các gói được yêu cầu trong script.
6. Cắm USB vào máy tính offline
7. Chạy Synaptic và nhấp vào File -> Add downloaded packages (thêm gói đã tải xuống)
8. Chọn thư mục trong USB chứ các tệp .deb đã tải xuống và nhấn Open. Các package sẽ được cài đặt.

**Lưu ý:** Nếu bạn không có quyền truy cập vào các máy tính với GNU/ Linux hoặc các bản mô phỏng ảo hóa GNU/Linux (Cygwin, VMware, Virtuabox, Qemu ...) bạn chỉ cần mở script với trình sọạn thảo văn bản và nhập tất cả url mà bạn thấy dán trong trình duyệt của bạn để tải xuống các Package tương tứng.
Tất cả các pakage Ubuntu có trên http://packages.ubuntu.com/ và http://www.debian.org/distrib/packages

### Sử dụng Offline apt-get update

- Nếu bạn không thể chọn các package trên máy tính offline vì bạn không thể cập nhập thông tin package, hãy sử dụng: AptGet/Offline/Repository
- Về cơ bản, Nó bao gồm việc tạo kho lưu trữ local của riêng bạn, ngoại trừ nó sẽ không chứa các package, chỉ có thông tin các package phụ thuộc.
- Vấn đề là khi bạn tạo danh sách download package bằng cách sử dụng phương pháp này, nó sẽ cố gắng lấy các gói từ repository local của bạn => điều này là không thể.
- Giải pháp là để post-xử lý các kịch bản bằng cách thay thế các URL với một trong những chính xác.
- Giả sử bạn tạo kho lưu trữ cục bộ tại `/home/username/repository` và có các tệp khác nhau từ http://archive.ubuntu.com/ubuntu/ , điều này có thể dễ dàng thực hiện bằng lệnh sau:

```
sed của # file: /// home / username / repository # http: //archive.ubuntu.com/ubuntu# 'download_script.sh> download_script2.sh
chmod + x download_script2.sh
```
hoặc trực tiếp mà không cần tạo một script thứ hai:

`sed -i 's # file: /// home / username / repository # http: //archive.ubuntu.com/ubuntu#' download_script.sh`

### Sử dụng apt-offline

- Apt-offline cho phép bạn dễ dàng nâng cấp hoặc cài đặt các package mới trên máy tính offline bằng cách sử dụng một máy tính online khác.
`sudo apt-get install apt-offline`

- Update:

1. Trên PC offline:
`sudo apt-offline set /tmp/apt-offline.sig`

2. Trên PC online:
`sudo apt-offline nhận được C: \ apt-offline.sig --bug-reports --threads 5`

3. Trên PC offline:
`sudo apt-offline cài đặt /media/USB/apt-offline.zip`

- Cài đặt

1. Trên PC offline
`sudo apt-offline set abuse-offline.sig --install-packages abuse --src-build-dep -install-src-packages abuse`

2. Trên PC online
`sudo apt-offline nhận được lạm dụng-offline.sig --no-checksum --bundle abuse-offline.zip`

3. Trên PC offline
`sudo apt-offline cài đặt /media/USB/abuse-offline.zip`

#### Từ khóa:
- **apt:**'Advanced Package Tool', chương trình Quản lý Gói của Ubuntu dựa trên. apt xử lý các phần phức tạp hơn trong quản lý gói, chẳng hạn như duy trì cơ sở dữ liệu gói.
- **Architecture:** Loại bộ xử lý mà máy tính sử dụng
- **Binary Package:** Một gói chứa một chương trình phù hợp với Architecture
- **deb:** Một tệp tin .deb là một gói Ubuntu (hoặc Debian), chứa tất cả các tệp mà gói sẽ cài đặt.
- **Dependency:** Sự phụ thuộc là một gói phải được cài đặt cho một gói khác để hoạt động bình thường.
- **Package Manager:** Một chương trình xử lý gói, cho phép bạn tìm kiếm, cài đặt và gỡ bỏ chúng. Ví dụ: Thêm / Xoá ...
- **Repository/Software Channel**: Một vị trí từ đó gói các loại tương tự có sẵn để tải xuống và cài đặt.
- **Source** Package: Gói chứa mã ban đầu cho một chương trình, phải được biên dịch để sử dụng được trên một kiến ​​trúc cụ thể.


