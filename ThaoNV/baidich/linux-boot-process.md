# Phân tích quá trình boot của Linux

Một trò đùa vui ở thế giới open source đó là bản thân code đã tự giải thích chi tiết cho nó. Mặc dù vậy, kinh nghiệm vẫn cho thấy rằng đọc source code cũng giống như bạn nghe dự báo thời tiết, đôi khi nghe xong vẫn phải chạy ra ngoài trời để kiểm tra. Dưới đây là một số tips về cách để kiểm tra và quan sát các hệ thống Linux khi khởi động bằng cách tận dụng kiến thức về các tool debug quen thuộc. Việc phân tích quá trình khởi động của các hệ thống đang hoạt động tốt sẽ giúp cho người dùng và developers chuẩn bị trước những nguy hại thường gặp phải.

Thực chất quá trình boot rất đơn giản. Kernel bắt đầu một thread đơn và đồng bộ trên 1 core. Nhưng làm cách nào để kernel có thể tự nó khởi động? `initrd` (initial ramdisk) và `bootloaders` có chức năng gì? Và tại sao đèn LED ở ethernet port luôn được bật? Câu trả lời sẽ được hé lộ ở phần dưới đây.

## Khởi đầu quá trình boot: Trạng thái OFF

**Wake-on-LAN**

Trạng thái OFF có nghĩa là hệ thống không còn điện nữa. Tuy nhiên điều này chưa chắc đã chính xác, nếu đèn LED trên port ethernet được bật thì đó là do hệ thống đã được kích hoạt wake-on-LAN (WOL). kiểm tra bằng câu lệnh sau

`$# sudo ethtool <interface name>`

`<interface name>` là tên card mạng. `ethtool` là tên 1 công cụ trên linux mà bạn có thể tải về và cài đặt với tên package là chính nó.

Nếu `Wake-on` được show ra thì một host khác có thể khởi động hệ thống bằng cách gửi [MagicPacket](https://en.wikipedia.org/wiki/Wake-on-LAN). Nếu bạn không có ý định cho phép hệ thống của mình có thể khởi động từ xa, hãy tắt WOL trong bios hoặc sử dụng câu lệnh dưới

`$# sudo ethtool -s <interface name> wol d`

Processor tiếp nhận MagicPacket có thể là một phần của network interface hoặc nó có thể là [Baseboard Management Controller](https://lwn.net/Articles/630778/) (BMC).

**Intel Management Engine, Platform Controller Hub, and Minix**

BMC không phải là microcontroller (MCU) duy nhất có thể nghe khi hệ thống đang tắt. Các hệ thống x86_64 cũng kèm theo phần mềm Intel Management Engine (IME) phù hợp để quản lí hệ thống từ xa. Một loạt các danh sách thiết bị, từ servers cho đến laptop đều được đính kèm công nghệ này để sử dụng một số chức năng như KVM Remote Control và Intel Capability Licensing Service. IME có một lỗ hổng bảo mật chưa được vá, tin xấu là rất khó để vô hiệu hóa IME.  Trammell Hudson đã tạo ra me_cleaner project có khả năng dọn dẹp một số thành phần của IME nhưng cũng có thể gây hại cho hệ thống mà nó đang chạy.

IME firmware và the System Management Mode (SMM) theo kèm trong quá trình khởi động được dựa trên hệ điều hành Minix và chạy trên bộ xử lý Platform Controller Hub riêng biệt, không chạy trên main CPU. SMM sau đó sẽ khởi động phần mềm Universal Extensible Firmware Interface (UEFI)  chạy trên main CPU. Nhóm Coreboot của Google đã bắt đầu dự án Non-Extensible Reduced Firmware (NERF) với mục tiêu chính đó là thay thể không chỉ UEFI mà còn một số thành phần userspace của linux như systemd. Trong khi chờ đợi những sản phẩm mới thì giờ đây người dùng linux có thể mua laptop từ Purism, System76, or Dell với IME đã được disable.

**Bootloaders**

Bên cạnh việc start buggy spyware, đâu là chức năng mà boot firmware sớm khởi động? Công việc của bootloader đó là tạo sẵn cho một bộ xử lý mới được hỗ trợ tài nguyên cần thiết để chạy một hệ điều hành mục đích chung như Linux. Khi nguồn điện được bật, không chỉ không có virtual memory mà cả DRAM cũng không được xuất hiện cho tới khi bộ điều khiển của nó được bật lên. Bootloaders sau đó sẽ bật nguồn điện lên và scan một loạt các bus cùng interface để chuẩn bị đặt kernel image kèm với root filesystem. Một số bootloaders nổi tiếng như U-Boot và GRUB có hỗ trợ các interface quen thuộc như USB, PCI, and NFS, cũng như một số thiết bị embedded-specific như NOR- và NAND-flash. Bootloaders cũng tương tác với phần cứng bảo mật như Trusted Platform Modules (TPMs) để thiết lập sớm một `chain of trust `

<img src="https://opensource.com/sites/default/files/u128651/linuxboot_1.png">

U-boot bootloader được hỗ trợ trên một loạt các hệ thống từ Raspberry Pi cho tới các thiết bị của Nitendo. Không có bất cứ syslog nào, thậm chí khi mà mọi thứ xảy ra, không có output nào trên console. Để tạo điều kiện cho việc debug, U-boot team cung cấp một công cụ để kiểm tra (U-Boot sandbox) các bản vá chạy trên các hệ thống máy chủ lưu trữ hoặc ngay cả trên Continuous Integration system. Việc sử dụng công cụ này tương đối đơn giản trên một hệ thống mà các công cụ phát triển phổ biến như Git và GNU Compiler Collection (GCC) được cài đặt

``` sh
$# git clone git://git.denx.de/u-boot; cd u-boot
$# make ARCH=sandbox defconfig
$# make; ./u-boot
=> printenv
=> help
```

Nếu bạn chạy U-Boot trên x86_64, bạn có thể test một vài chức năng như TPM-based secret-key hay hotplug của USB devices. U-Boot sandbox thậm chí có thể được chạy single-step bằng GDB debugger.

## Khởi động kernel

**Cung cấp booting kernel**

Sau khi hoàn thành nhiệm vụ, bootloader sẽ thực hiện lệnh nhảy tới kernel code mà nó đã nạp vào bộ nhớ chính và bắt đầu thực thi, pass bất kỳ tùy chọn dòng lệnh nào mà người dùng đã chỉ định. file `/boot/vmlinuz` chỉ định rằng nó là 1 file nén lớn dạng bzImage. Linux source tree có chứa một công cụ để giải nén tệp này.

``` sh
$# scripts/extract-vmlinux /boot/vmlinuz-$(uname -r) > vmlinux
$# file vmlinux
vmlinux: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically
linked, stripped
```

Kernel là một chương trình nhị phân có thể execute và liên kết (Executable and Linking Format (ELF)), giống với các chương trình dành cho người dùng của linux. Điều đó có nghĩa là chúng ta có thể sử dụng lệnh từ gói `binutils` như `readelf` để kiểm tra nó. So sánh đầu ra của ví dụ:

``` sh
$# readelf -S /bin/date
$# readelf -S vmlinux
```

Danh sách của section ở dạng nhị phân vầ gần như giống nhau

Vì thế kernel buộc phải khởi động một số thứ giống như Linux ELF binaries, nhưng làm cách nào mà các chương trình userspace có thể start?

Trước khi hàm `main()` có thể run, chương trình cần phải có một ngữ cảnh để chạy bao gồm heap và stack memory kèm theo các file descriptors cho `stdio, stdout, và stderr`. Các chương trình userspace chứa resource của chúng trong thư viện (thường ở glibc)

``` sh
$# file /bin/date
/bin/date: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically
linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32,
BuildID[sha1]=14e8563676febeb06d701dbee35d225c5a8e565a,
stripped
```

ELF binaries có một trình phiên dịch, giống như bash hoặc python. Tuy nhiên thì trình phiên dịch này không cần phải được khai báo với `#!` như trong các scripts bởi ELK đã native với linux. Trình phiên dịch ELK cung cấp một số nhị phân với các tài nguyên cần thiết bằng cách gọi tới hàm `_start()`, chức năng có sẵn được chứa tại thư viện glibc. Kernel thì rõ ràng không có cho mình một trình phiên dịch và phải tự cung cấp cho chính nó, nhưng câu hỏi là nó đã làm cách nào?

Việc kiểm tra khởi động của kernel với GDB sẽ đưa ra câu trả lời. Đầu tiên cài đặt gói debug cho kernel chứa phiên bản vmlinux, ví dụ `apt-get install linux-image-amd64-dbg`. gdb vmlinux được theo sau bởi các file info hiển thị lên phần init.text của ELF. Liệt kê các chương trình khởi động trong file init.text với l*(address), address ở đây chính là mã khởi động dạng thập phân của init.text. GDB sẽ chỉ ra rằng x86_64 kernel khởi động trong kernel's file arch/x86/kernel/head_64.S, nơi mà ta tìm thấy hàm assembly start_cpu0() và code tạo ra stack và giải nén zImage trước khi nó gọi tới hàm x86_64 start_kernel(). ARM 32 bit kernel cũng có arch/arm/kernel/head.S. start_kernel() nhưng nó không chỉ rõ ra cấu trúc. Vì thế cho nên hàm init/main.c. start_kernel() là Linux's true main() function.

## Từ start_kernel() cho tới PID 1

**Kê khai phần cứng của kernel: Cây thiết bị và bảng ACPI**

Khi khởi động, kernel cần thông tin về phần cứng ngoại trừ loại processor mà nó đã được biên dịch. Các hướng dẫn trong mã được gia tăng bởi dữ liệu cấu hình được lưu trữ riêng. Có hai phương pháp chính để lưu trữ dữ liệu này: cây thiết bị và bảng ACPI. kernel học được phần cứng nào nó phải chạy ở mỗi lần khởi động bằng cách đọc các tập tin này.

Đối với thiết bị nhúng, cây thiết bị là biểu hiện của phần cứng được cài đặt. Cây thiết bị chỉ đơn giản là một tập tin được biên dịch cùng lúc với nguồn kernel và thường nằm trong /boot cùng với vmlinux. Để xem những gì trong cây thiết bị nhị phân trên một thiết bị ARM, chỉ cần sử dụng lệnh strings từ gói binutils trên một tệp có tên tương ứng /boot/* .dtb, vì dtb đề cập đến một cây nhị phân cây thiết bị. Rõ ràng cây thiết bị có thể được sửa đổi đơn giản bằng cách chỉnh sửa các tệp JSON giống như tạo tệp và rerunning trình biên dịch dtc đặc biệt được cung cấp cùng với mã nguồn kernel. Mặc dù cây thiết bị là một tệp tin tĩnh mà đường dẫn tệp thường được kernel truyền đến bởi trình nạp khởi động trên dòng lệnh, một cơ chế che phủ cây thiết bị đã được thêm vào trong những năm gần đây, nơi kernel có thể tự động nạp các mảnh bổ sung để đáp ứng các hotplug events sau khi khởi động.

x86-family và nhiều thiết bị ARM64 cấp doanh nghiệp sử dụng cơ chế cấu hình và giao diện cấp cao (ACPI) thay thế. Trái ngược với cây thiết bị, thông tin ACPI được lưu trữ trong hệ thống tập tin ảo của hệ thống /sys/firmware/acpi/tables được tạo bởi kernel khi khởi động bằng cách truy cập vào ROM trên máy. Cách dễ dàng để đọc bảng ACPI là với lệnh acpidump từ gói công cụ acpica. Đây là một ví dụ về bảng ACPI trên Lenovo laptop:

<img src="https://opensource.com/sites/default/files/u128651/linuxboot_2.png">

ACPI có cả phương pháp và dữ liệu không giống như cây thiết bị, vốn là ngôn ngữ mô tả phần cứng. Các phương pháp của ACPI tiếp tục là hoạt động sau khi khởi động. Ví dụ, bắt đầu lệnh acpi_listen (từ gói apcid) và mở và đóng nắp máy tính xách tay sẽ cho thấy rằng chức năng ACPI đang chạy tất cả thời gian. Trong khi tạm thời và tự động ghi đè lên các bảng ACPI là có thể, thay đổi vĩnh viễn chúng liên quan đến tương tác với trình đơn BIOS lúc khởi động hoặc reflashing ROM. Nếu bạn đang gặp rắc rối đó, có lẽ bạn nên cài đặt coreboot, phần mềm nguồn mở thay thế.

**Từ start_kernel() tới userspace**

Code của `init/main.c` rất dễ đọc và nó vẫn mang dáng dấp của phiên bản đầu tiên mà Linus Torvald tạo ra vào năm 1991-1992. Các dòng tìm thấy trong dmesg|head trên một hệ thống mới khởi động bắt nguồn chủ yếu từ tập tin nguồn này. CPU đầu tiên được đăng ký với hệ thống, các cấu trúc dữ liệu toàn cầu được khởi tạo, và trình tự lập trình, bộ xử lý gián đoạn (IRQs), bộ đếm thời gian và giao diện điều khiển được đặt trực tuyến theo thứ tự nghiêm ngặt. Cho đến khi chức năng timekeeping_init () chạy, tất cả các dấu thời gian là số không. Phần khởi tạo kernel này đang đồng bộ, có nghĩa là sự thực hiện xảy ra trong một luồng và không có chức năng nào được thực hiện cho đến khi kết thúc và trả về kết quả cuối cùng. Kết quả là, đầu ra dmesg sẽ được tái tạo hoàn toàn, ngay cả giữa hai hệ thống, miễn là họ có cùng một thiết bị cây hoặc bảng ACPI. Linux đang hoạt động giống như một trong những hệ điều hành RTOS (hệ điều hành thời gian thực) chạy trên các MCU, ví dụ như QNX hoặc VxWorks. Tình huống vẫn tồn tại trong hàm rest_init (), được gọi bởi start_kernel () tại thời điểm chấm dứt.

<img src="https://opensource.com/sites/default/files/u128651/linuxboot_3.png">

Rest_init () tạo ra một thread mới chạy kernel_init(), nó sẽ gọi do_initcalls (). Người dùng có thể theo dõi initcalls trong hành động bằng cách thêm initcall_debug vào dòng lệnh hạt nhân, dẫn đến các mục dmesg mỗi khi một chức năng initcall chạy. initcalls đi qua bảy cấp độ tuần tự: early, core, postcore, arch, subsys, fs, device, và late. Phần người dùng có thể nhìn thấy nhất là các thiết bị ngoại vi: bus, mạng, lưu trữ, màn hình hiển thị ... cùng với việc tải các mô-đun hạt nhân của họ. rest_init () cũng tạo ra một thread thứ hai trên bộ vi xử lý khởi động bắt đầu bằng cách chạy cpu_idle () trong khi nó chờ cho trình lên lịch gán nó làm việc.

kernel_init () cũng thiết lập symmetric multiprocessing (SMP). Với các kernel gần đây hơn, hãy tìm điểm đầu ra dmesg bằng cách tìm kiếm "Bringing up secondary CPUs..." SMP proceed bằng các "hotplugging" CPU, có nghĩa là nó quản lý vòng đời của chúng bằng một máy trạng thái tương tự như các thiết bị như ổ cắm USB. Hệ thống quản lý năng lượng của nhân này thường lấy các lõi riêng lẻ, sau đó đánh thức chúng khi cần thiết, do đó cùng một mã nguồn của CPU được gọi lặp đi lặp lại trên một máy không bận. Quan sát việc gọi trình cắm của CPU của hệ thống quản lý điện bằng công cụ BCC được gọi là offcputime.py.

Lưu ý rằng mã trong init/main.c gần như đã hoàn thành khi chạy smp_init (): Bộ xử lý khởi động đã hoàn thành hầu hết việc khởi tạo một lần mà các lõi khác không cần phải lặp lại. Tuy nhiên, các chuỗi cho mỗi CPU phải được sinh ra cho mỗi lõi để quản lý interupts (IRQs), workqueues, timer, và các  power events. Ví dụ, xem các chuỗi cho mỗi CPU phục vụ softirqs và workqueues đang hoạt động thông qua lệnh `ps -o psr`.

``` sh
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

Vậy cuối cùng thì đâu là không gian người dùng bắt đầu? Gần cuối tiến trình, kernel_init () tìm kiếm một initrd có thể thực hiện quá trình init thay cho nó. Nếu nó không tìm thấy, hạt nhân trực tiếp thực hiện init. Tại sao người ta có thể muốn một initrd?


**Early userspace: Đâu là thứ order initrd**

Bên cạnh cây thiết bị, một đường dẫn tệp khác được cung cấp cho hạt nhân khi khởi động là tệp initrd. Initrd thường sống trong /boot cùng với tệp bmlIcon của bzImage trên x86 hoặc cùng với uImage và cây thiết bị tương tự cho ARM. Liệt kê nội dung của initrd bằng công cụ lsinitramfs là một phần của gói initramfs-tools-core. Các sơ đồ initrd distro chứa các thư mục /bin, /sbin, và /etc tối thiểu cùng với các mô-đun kernel, cộng với một số tệp trong /scripts. Tất cả những thứ này trông khá quen thuộc, vì initrd phần lớn chỉ đơn giản là một hệ thống tập tin gốc Linux tối thiểu. Sự giống nhau rõ ràng là một chút lừa dối, vì gần như tất cả các file thực thi trong /bin và /sbin bên trong ramdisk là các liên kết đến binary BusyBox, kết quả là /bin và /sbin nhỏ hơn 10x so với glibc's.

Tại sao lại phải tạo ra một initrd nếu tất cả những gì nó làm là nạp một số mô-đun và sau đó bắt đầu init trên hệ thống tập tin gốc thông thường? Xem xét một hệ thống tập tin gốc mã hóa. Giải mã có thể dựa vào việc tải một mô-đun hạt nhân được lưu trữ trong /lib/modules trên hệ thống tập tin gốc ... và, không có gì đáng ngạc nhiên, initrd cũng làm tương tự như vậy. Môđun crypto có thể được biên dịch vào trong kernel thay vì được tải từ một tệp tin, nhưng có nhiều lý do khiến bạn không muốn làm như vậy. Ví dụ, việc biên dịch hạt nhân bằng các mô đun có thể làm cho nó quá lớn để phù hợp với dung lượng có sẵn, hoặc việc biên dịch tĩnh có thể vi phạm các điều khoản của một giấy phép phần mềm. Các thiết bị lưu trữ, mạng và thiết bị đầu vào con người (HID) cũng có thể có trong `initrd`- về cơ bản bất kỳ mã nào không phải là một phần của kernel đều cần được gán vào hệ thống tập tin gốc. Initrd cũng là nơi người dùng có thể lưu trữ mã bảng ACPI tùy chỉnh của riêng họ.

<img src="https://opensource.com/sites/default/files/u128651/linuxboot_4.png">

`initrd` cũng rất tuyệt cho testing và các thiết bị lưu trữ. Cuối cùng, khi init chạy, hệ thống đang up. Kể từ khi các bộ vi xử lý thứ cấp đang chạy, máy đã trở thành sasynchronous, preemptible, unpredictable, high-performance creature mà chúng ta biết và yêu thích. Thật vậy, ps -o pid, psr, comm -p 1 có thể chứng minh rằng tiến trình init của không gian người dùng không còn chạy trên bộ xử lý khởi động nữa.

## Kết luận

Quá trình khởi động Linux nghe có vẻ bí ẩn khi xem xét số lượng phần mềm khác nhau tham gia ngay cả trên các thiết bị nhúng đơn giản. Nhìn ở góc độ khác, quá trình khởi động khá đơn giản, vì sự phức tạp gây bối rối do các tính năng như preemption, RCU, ... Chỉ tập trung vào hạt nhân và PID 1 nhìn thấy số lượng lớn công việc mà bootloader và bộ vi xử lý phụ trợ có thể làm trong việc chuẩn bị nền tảng cho hạt nhân để chạy. Trong khi kernel chắc chắn là duy nhất trong số các chương trình Linux, một số hiểu biết về cấu trúc của nó có thể được lượm lặt bằng cách áp dụng cho nó một số công cụ tương tự dùng để kiểm tra các chương trình ELF khác. Nghiên cứu quá trình khởi động trong khi nó đang làm việc để bảo vệ hệ thống cho những sự cố khi nó ập đến.
