# Phân tích quá trình khởi động trên Linux

Trong bài viết là các mẹo để kiểm tra và quan sát các hệ thống Linux khi khởi động bằng cách 
tận dụng kiến thức về các công cụ gỡ lỗi quen thuộc. 
Phân tích quá trình khởi động của hệ thống đang hoạt động tốt sẽ là bước chuẩn bị cho người dùng và 
các nhà phát triển hiểu rõ được hệ thống của mình để đối phó với những sự cố không thể tránh khỏi trong 
tương lai.


Theo một cách nào đó, quá trình khởi động của hệ thống Linux khá là đơn giản. Nhân kernel sẽ khởi 
động và tiến hành quá trình đồng bộ trên một nhân trên bộ vi xử lý để nạp hệ điều hành, những thứ cần thiết để khởi động hệ thống. 
Nhưng làm cách nào để kernel có thể tự khởi động? Initrd( initial ramdisk) và bootloaders sẽ thực hiện chức năng nào? Và tại 
sao đèn LED trên cổng Ethernet luôn luôn sáng? 
Bạn hãy đọc tiếp những mục dưới đây để trả lời những câu hỏi trên và nắm được một cách cặn kẽ quá trình khởi động của Linux.

## Quá trình ban đầu của việc khởi động : Trạng thái tắt ( Off state )

### Wake-on-LAN

Trạng thái tắt ( Off state ) nghĩa là hệ thống chưa được cấp nguồn điện ? Không hẳn vậy, ví dụ đèn LED của 
card mạng vẫn sáng bởi chế độ Wake-on-LAN ( WOL) đang được bật trên hệ thống của bạn. Kiểm tra điều này 
bằng lệnh :

` $# sudo ethtool <interface name>`

*<interface name>* là tên card mạng của bạn, ví dụ eth0, ens33.. ( ethtool có sẵn trong kho Linux với cùng tên như vậy )
 Nếu "Wake-on" trên hiển thị trên output là `g`, thì các hosts từ xa có thể khởi động hệ thống bằng cách gửi các 
 MagicPacket ( https://en.wikipedia.org/wiki/Wake-on-LAN ) . Nếu bạn không có ý định đánh thức hệ thống từ xa và không cho 
 những người khác làm điều đó, thì tắt chế độ WOL trong BIOS menu, hoặc bằng lệnh :
 
 `$# sudo ethtool -s <interface name> wol d`
 
 Bộ xử lý phản hồi lại với MagicPacket có thể là một phần của card mạng hoặc nó có thể là Baseboard Management Controller ( BMC - bộ quản lý bảng điều khiển ).
 ( https://lwn.net/Articles/630778/)
 
### Công cụ quản lý Intel (IME), Cơ sở bộ điều khiển Hub, và Minix 
 
BMC không phải là vi điều khiển duy nhất ( MCU - Mircocontroller ) có thể lắng nghe hệ thống khi nó trong trạng thái tắt. 
Hệ thống x86_64 cũng bao gồm cả Intel Management Engine ( IME ) phù hợp cho việc quản lý từ xa. 
Một loạt các thiết bị, từ máy chủ đến máy tính xách tay, bao gồm công nghệ này, cho phép các chức năng như KVM Remote Control 
và Dịch vụ Cấp phép của Intel (Intel Capability Licensing Service ). IME có lỗ hổng chưa được vá - theo công cụ phát hiện của
 Intel. Tin xấu là rất khó để vô hiệu hóa IME. Trammell Hudson đã tạo ra me_cleaner project có khả năng dọn dẹp một số thành 
 phần của IME nhưng cũng có thể gây hại cho hệ thống mà nó đang chạy.
 
IME firmware và the System Management Mode (SMM) theo kèm trong quá trình khởi động dựa trên hệ điều hành Minix và 
chạy trên bộ xử lý Platform Controller Hub riêng biệt, không chạy trên main CPU. SMM sau đó sẽ khởi động phần mềm 
Universal Extensible Firmware Interface (UEFI) chạy trên main CPU. Nhóm Coreboot của Google đã bắt đầu dự án 
Non-Extensible Reduced Firmware (NERF) với mục tiêu chính là thay thể không chỉ UEFI mà còn một số thành phần 
userspace (không gian người dùng) của linux như systemd. Trong khi chờ đợi những sản phẩm mới thì giờ đây người dùng linux có thể mua 
laptop từ Purism, System76, or Dell với IME đã được tắt, hơn nữa ta có thể hi vọng vào những laptop với vi xử lý ARM 64-bit.


### Bootloaders ( chương trình khởi động hệ thống và nạp hệ điều hành )

Bên cạnh việc khởi động phần mềm buggy spyware, thì chức năng nào boot firmware sẽ khởi động sớm nhất?
Việc của bootloader là nạp hệ điều hành và tài nguyên để cpu chạy nó một cách ổn định.
Khi bật nguồn, bộ nhớ ảo hay DRAM đều chưa được bật cho đến khi bộ điều khiển được bật.  Bootloader sau đó 
sẽ bật nguồn cấp và quét các bus, các cổng giao tiếp để định vị kernel image và file hệ thống của root.

Những bootloader phổ biến hiện nay là U-Boot hay GRUB đều hỗ trợ các cổng kết nối như USB, PCI và NFS cũng như 
một số thiết bị nhúng như NOR- và NAND-flash.

Bootloader cũng tương tác với các thiết bị bảo mật phần cứng như Trusted Platform Modules (TPM ) để thiết lập một chu trình 
an toàn cho việc khởi động sớm.

![Imgur](https://i.imgur.com/aGtwztd.png)
*Chạy bootloader U-boot trong sandbox trên máy chủ lưu trữ*

Đối với các hệ điều hành mã nguồn mở, chúng thường sử dụng U-Boot bootloader trên các hệ thống cỉa các thiết bị từ 
Raspberry Pi đến Nintedo rồi bảng mạch ô tô đến Chromebook. Không có **syslog**, không có đầu ra console. Để gỡ lỗi,nhóm phát triển U-Boot 
 khuyến nghị sử dụng **sandbox** - ứng dụng chứa các bản vá (patches) có thể kiểm tra trên máy chủ lưu trữ hoặc ngay cả trong một hệ thống 
 tích hợp liên tục hàng đêm. Việc sử dụng sandbox của U-Boot khá là đơn giản trên một hệ thống 
 mà các công cụ phát triển phổ biến như GIT và GNU Compiler Collection(GCC) được cài đặt : 

```
$# git clone git://git.denx.de/u-boot; cd u-boot
$# make ARCH=sandbox defconfig
$# make; ./u-boot
=> printenv
=> help
```

Những điều trên có nghĩa rằng : bạn đang chạy U-Boot trên nền tảng x86_64 và bạn có thể thử nghiệm các tính năng thông minh 
như phân vùng lại thiết bị lưu trữ mô phỏng, thao tác khóa bí mật dựa trên TPM và các kết nối thêm của thiết bị USB.
Các sandbox U-Boot thậm chí có thể chạy chỉ với 1 bước bwangf GDB debugger. 
Việc phát triển bằng cách sử dụng sandbox nhanh gấp 10 lần so với kiểm tra bằng cách nạp lại bộ reflashing bootloader vào 
bảng mạch, và một "bricked" sandbox có thể được phục hồi với cú pháp "Ctrl + C".

### Khởi động kernel

#### Quan sát việc khởi động kernel

Sau khi hoàn thành những công việc ở trên, bootloader sẽ khởi chạy một loạt các mã đã được nạp vào trong 
bộ nhớ chính (ram) và tiến hành từng lệnh một. 
Vậy kenel là chương trình gì?  `file /boot/vmlinuz` chỉ ra rằng nó là một file nén lớn dạng bzlmage. 
Cây mã nguồn của Linux chứa một công cụ có tên là `extrax-vmlinux` có thể sử dụng để giải nén file:

```
$# scripts/extract-vmlinux /boot/vmlinuz-$(uname -r) > vmlinux
$# file vmlinux
vmlinux: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically
linked, stripped
```

Kernel là một dãy nhị phân có thể thực thi và có định dạng liên kết với nhau ( executable and linking format)
giống như chương trình không gian người dùng của Linux ( Linux userspace programs).
Điều này có nghĩa là chúng ta có thể sử dụng lệnh từ gói `binutils` như `readelf` để kiểm tra nội dung của nó.
So sánh đầu ra của ví dụ:

```
$# readelf -S /bin/date
$# readelf -S vmlinux
```

Danh sách của section ở dạng nhị phân vầ gần như giống nhau.

Vì vậy mà kernel phải khởi động những thứ như Linux ELF binaries.. nhưng làm thế nào chương trình userspace 
khởi động một cách thật sự? Trong hàm `main()` ư? Không hẳn vậy.

Trước khi hàm `main()` có thể chạy, các chương trình cần phải có một môi trường 
để chạy bao gồm heap và stack memory kèm theo các file mô tả (descriptors) cho `stdio`, `stdout`, và `stderr`. 
Các chương trình userspace chứa resource của chúng trong thư viện (thường ở glibc trên hầu hết các hệ thống Linux)

```
$# file /bin/date
/bin/date: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically
linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32,
BuildID[sha1]=14e8563676febeb06d701dbee35d225c5a8e565a,
stripped
```

ELF binaries có một trình phiên dịch, giống như bash hoặc python. 
Tuy nhiên trình phiên dịch này không cần phải khai báo với `#!` như trong các scripts ELF với định dạng của linux. 
Trình phiên dịch ELK cung cấp một số nhị phân với các tài nguyên cần thiết bằng cách gọi tới hàm `_start()`, 
chức năng có sẵn được chứa tại thư viện glibc. Kernel thì rõ ràng không có cho mình một trình phiên dịch và 
phải tự lo lấy, vậy nó đã làm cách nào?

Việc kiểm tra khởi động của kernel với GDB sẽ đưa ra câu trả lời. 
Đầu tiên cài đặt gói debug cho kernel chứa phiên bản vmlinux, 
ví dụ `apt-get install linux-image-amd64-dbg` hoặc biên soạn và cài đặt nhân kernel riêng từ nguồn 
. gdb vmlinux được theo sau bởi các file info hiển thị lên phần init.text của ELF. Liệt kê các chương 
trình khởi động trong file `init.text` với `l*(address)`, address ở đây chính là 
mã khởi động dạng thập phân của init.text. GDB sẽ chỉ ra rằng x86_64 kernel 
khởi động trong kernel's file `arch/x86/kernel/head_64.S`, nơi mà ta tìm thấy 
hàm `assembly start_cpu0()` và code tạo ra stack và giải nén `zImage` trước 
khi nó gọi tới hàm `x86_64 start_kernel()`. ARM 32 bit kernel cũng 
có `arch/arm/kernel/head.S. start_kernel()` nhưng nó không chỉ rõ ra cấu trúc. 
Vì thế cho nên hàm `init/main.c. start_kernel()` là `Linux's true main() function`.


#### Từ start_kernel() đến PID 1

Kê khai phần cứng của kernel: Cây thiết bị và bảng ACPI

Khi khởi động, kernel cần thông tin về phần cứng ngoại trừ loại processor mà nó đã được biên dịch. 
Các hướng dẫn trong mã được gia tăng bởi dữ liệu cấu hình được lưu trữ riêng. 
Có hai phương pháp chính để lưu trữ dữ liệu này: cây thiết bị và bảng ACPI. 
kernel học được phần cứng nào nó phải chạy ở mỗi lần khởi động bằng cách đọc các tập tin này.

Đối với thiết bị nhúng, cây thiết bị là biểu hiện của phần cứng được cài đặt. 
Cây thiết bị chỉ đơn giản là một tập tin được biên dịch cùng lúc với nguồn 
kernel và thường nằm trong /boot cùng với vmlinux. Để xem những gì trong cây 
thiết bị nhị phân trên một thiết bị ARM, chỉ cần sử dụng lệnh strings từ gói 
binutils trên một tệp có tên tương ứng /boot/* .dtb, vì dtb đề cập đến một cây 
nhị phân cây thiết bị. Rõ ràng cây thiết bị có thể được sửa đổi đơn giản 
bằng cách chỉnh sửa các tệp JSON giống như tạo tệp và rerunning trình biên 
dịch dtc đặc biệt được cung cấp cùng với mã nguồn kernel. Mặc dù cây thiết bị 
là một tệp tin tĩnh mà đường dẫn tệp thường được kernel truyền đến bởi trình 
nạp khởi động trên dòng lệnh, một cơ chế che phủ cây thiết bị đã được thêm vào 
trong những năm gần đây, nơi kernel có thể tự động nạp các mảnh bổ sung để 
đáp ứng các hotplug events sau khi khởi động.

x86-family và nhiều thiết bị ARM64 cấp doanh nghiệp sử dụng cơ chế cấu hình và giao diện cấp cao (ACPI) thay thế. 
Trái ngược với cây thiết bị, thông tin ACPI được lưu trữ trong hệ thống tập tin ảo của 
hệ thống /sys/firmware/acpi/tables được tạo bởi kernel khi khởi động bằng cách truy cập vào ROM trên máy. 
Cách dễ dàng để đọc bảng ACPI là với lệnh acpidump từ gói công cụ acpica.
Đây là một ví dụ về bảng ACPI trên Lenovo laptop:

![Imgur](https://i.imgur.com/ZJGadRM.png)

ACPI có cả phương pháp và dữ liệu không giống như cây thiết bị, 
vốn là ngôn ngữ mô tả phần cứng. Các phương pháp của ACPI tiếp tục là hoạt động sau khi khởi động. 
Ví dụ, bắt đầu lệnh acpi_listen (từ gói apcid) và mở và đóng nắp máy tính xách tay sẽ cho thấy rằng 
chức năng ACPI đang chạy tất cả thời gian. Trong khi tạm thời và tự động ghi đè lên các bảng ACPI là có thể, 
thay đổi vĩnh viễn chúng liên quan đến tương tác với trình đơn BIOS lúc khởi động hoặc reflashing ROM. Nếu bạn đang gặp rắc rối đó, 
có lẽ bạn nên cài đặt coreboot, phần mềm nguồn mở thay thế.


##### Từ start_kernel() tới userspace

Code của init/main.c rất dễ đọc và nó vẫn mang dáng dấp của phiên bản đầu tiên mà Linus Torvald tạo ra vào năm 1991-1992. 
Các dòng tìm thấy trong dmesg|head trên một hệ thống mới khởi động bắt nguồn chủ yếu từ tập tin nguồn này. CPU đầu tiên được 
đăng ký với hệ thống, các cấu trúc dữ liệu toàn cầu được khởi tạo, và trình tự lập trình, bộ xử lý gián đoạn (IRQs), 
bộ đếm thời gian và giao diện điều khiển được đặt trực tuyến theo thứ tự nghiêm ngặt. Cho đến khi chức năng timekeeping_init () chạy, 
tất cả các dấu thời gian là số không. Phần khởi tạo kernel này đang đồng bộ, có nghĩa là sự thực hiện xảy ra trong một 
luồng và không có chức năng nào được thực hiện cho đến khi kết thúc và trả về kết quả cuối cùng. Kết quả là, đầu ra dmesg sẽ 
được tái tạo hoàn toàn, ngay cả giữa hai hệ thống, miễn là họ có cùng một thiết bị cây hoặc bảng ACPI. 
Linux đang hoạt động giống như một trong những hệ điều hành RTOS (hệ điều hành thời gian thực) 
chạy trên các MCU, ví dụ như QNX hoặc VxWorks. Tình huống vẫn tồn tại trong hàm rest_init (), 
được gọi bởi start_kernel () tại thời điểm chấm dứt.

![Imgur](https://i.imgur.com/9ZLORro.png)

Rest_init () tạo ra một thread mới chạy kernel_init(), nó sẽ gọi do_initcalls (). 
Người dùng có thể theo dõi initcalls trong hành động bằng cách thêm initcall_debug vào dòng lệnh hạt nhân, 
dẫn đến các mục dmesg mỗi khi một chức năng initcall chạy. initcalls đi qua bảy cấp độ tuần tự: early, core, 
postcore, arch, subsys, fs, device, và late. Phần người dùng có thể nhìn thấy nhất là các thiết bị 
ngoại vi: bus, mạng, lưu trữ, màn hình hiển thị ... cùng với việc tải các mô-đun hạt nhân của họ. `rest_init ()` cũng tạo
 ra một thread thứ hai trên bộ vi xử lý khởi động bắt đầu bằng cách chạy cpu_idle () trong khi nó chờ cho trình lên lịch gán nó làm việc.

kernel_init () cũng thiết lập symmetric multiprocessing (SMP). Với các kernel gần đây hơn, 
hãy tìm điểm đầu ra dmesg bằng cách tìm kiếm "Bringing up secondary CPUs..." SMP proceed bằng các "hotplugging" CPU, 
có nghĩa là nó quản lý vòng đời của chúng bằng một máy trạng thái tương tự như các thiết bị như ổ cắm USB. 
Hệ thống quản lý năng lượng của nhân này thường lấy các lõi riêng lẻ, sau đó đánh thức chúng khi cần thiết, 
do đó cùng một mã nguồn của CPU được gọi lặp đi lặp lại trên một máy không bận. Quan sát việc gọi trình cắm của 
CPU của hệ thống quản lý điện bằng công cụ BCC được gọi là offcputime.py.

Lưu ý rằng mã trong init/main.c gần như đã hoàn thành khi chạy smp_init (): Bộ xử lý khởi động đã hoàn thành 
hầu hết việc khởi tạo một lần mà các lõi khác không cần phải lặp lại. Tuy nhiên, các chuỗi cho mỗi CPU phải được 
sinh ra cho mỗi lõi để quản lý interupts (IRQs), workqueues, timer, và các power events. Ví dụ, xem các chuỗi cho 
mỗi CPU phục vụ softirqs và workqueues đang hoạt động thông qua lệnh `ps -o psr`.

```
$\# ps -o pid,psr,comm $(pgrep ksoftirqd)  
 PID PSR COMMAND
   7   0 ksoftirqd/0
  16   1 ksoftirqd/1
  22   2 ksoftirqd/2
  28   3 ksoftirqd/3

$\# ps -o pid,psr,comm $(pgrep kworker)
PID  PSR COMMAND
   4   0 kworker/0:0H
  18   1 kworker/1:0H
  24   2 kworker/2:0H
  30   3 kworker/3:0H
[ . .  . ]
```
PSR ở đây chính là processor. Mỗi core cũng phải tự tổ chức timers và cpuhp hotplug handlers.

Vậy cuối cùng thì đâu là không gian người dùng bắt đầu? Gần cuối tiến trình, kernel_init () tìm 
kiếm một initrd có thể thực hiện quá trình init thay cho nó. Nếu nó không tìm thấy, hạt nhân trực tiếp thực hiện init. 
Tại sao người ta có thể muốn một initrd?

#### Early userspace: cái gì gọi initrd?

Bên cạnh cây thiết bị, một đường dẫn tệp khác được cung cấp cho hạt nhân khi khởi động là tệp initrd. 
Initrd thường sống trong /boot cùng với tệp bmlIcon của bzImage trên x86 hoặc cùng với uImage và cây thiết bị tương tự cho ARM. 
Liệt kê nội dung của initrd bằng công cụ lsinitramfs là một phần của gói initramfs-tools-core. 
Các sơ đồ initrd distro chứa các thư mục /bin, /sbin, và /etc tối thiểu cùng với các mô-đun kernel, 
cộng với một số tệp trong /scripts. Tất cả những thứ này trông khá quen thuộc, 
vì initrd phần lớn chỉ đơn giản là một hệ thống tập tin gốc Linux tối thiểu. 
Sự giống nhau rõ ràng là một chút lừa dối, vì gần như tất cả các file thực thi trong /bin và /sbin 
bên trong ramdisk là các liên kết đến binary BusyBox, kết quả là /bin và /sbin nhỏ hơn 10x so với glibc's.

Tại sao lại phải tạo ra một initrd nếu tất cả những gì nó làm là nạp một số mô-đun và sau đó bắt đầu init 
trên hệ thống tập tin gốc thông thường? Xem xét một hệ thống tập tin gốc mã hóa. Giải mã có thể dựa vào 
việc tải một mô-đun hạt nhân được lưu trữ trong /lib/modules trên hệ thống tập tin gốc ... và, không có gì 
đáng ngạc nhiên, initrd cũng làm tương tự như vậy. Môđun crypto có thể được biên dịch vào trong kernel 
thay vì được tải từ một tệp tin, nhưng có nhiều lý do khiến bạn không muốn làm như vậy. Ví dụ, việc biên dịch 
hạt nhân bằng các mô đun có thể làm cho nó quá lớn để phù hợp với dung lượng có sẵn, hoặc việc biên dịch tĩnh 
có thể vi phạm các điều khoản của một giấy phép phần mềm. Các thiết bị lưu trữ, mạng và thiết bị đầu vào 
con người (HID) cũng có thể có trong initrd- về cơ bản bất kỳ mã nào không phải là một phần của kernel đều 
cần được gán vào hệ thống tập tin gốc. Initrd cũng là nơi người dùng có thể lưu trữ mã bảng ACPI tùy chỉnh của riêng họ.

![Imgur](https://i.imgur.com/kIedxhX.png)


initrd cũng rất tuyệt cho testing và các thiết bị lưu trữ. Cuối cùng, khi init chạy, hệ thống đang up. 
Kể từ khi các bộ vi xử lý thứ cấp đang chạy, máy đã trở thành sasynchronous, preemptible, unpredictable, high-performance creature 
mà chúng ta biết và yêu thích. Thật vậy, ps -o pid, psr, comm -p 1 có thể chứng minh rằng tiến trình init của không gian người 
dùng không còn chạy trên bộ xử lý khởi động nữa.

### Kết luận

Quá trình khởi động Linux nghe có vẻ bí ẩn khi xem xét số lượng phần mềm khác nhau tham gia ngay cả trên các thiết bị nhúng đơn giản. 
Nhìn ở góc độ khác, quá trình khởi động khá đơn giản, vì sự phức tạp gây bối rối do các tính năng như preemption, RCU, ... 
Chỉ tập trung vào hạt nhân và PID 1 nhìn thấy số lượng lớn công việc mà bootloader và bộ vi xử lý phụ trợ có thể làm trong việc 
chuẩn bị nền tảng cho hạt nhân để chạy. Trong khi kernel chắc chắn là duy nhất trong số các chương trình Linux, một số hiểu biết 
về cấu trúc của nó có thể được lượm lặt bằng cách áp dụng cho nó một số công cụ tương tự dùng để kiểm tra các chương trình ELF khác. 
Nghiên cứu quá trình khởi động trong khi nó đang làm việc để bảo vệ hệ thống cho những sự cố khi nó ập đến.

 
### Tham khảo:

(1). https://opensource.com/article/18/1/analyzing-linux-boot-process
 