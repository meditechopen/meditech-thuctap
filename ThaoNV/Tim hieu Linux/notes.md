# Tìm hiểu thêm về Linux

### 1. Tìm hiểu cấu trúc của file /etc/passwd và /etc/group

Trước đây, file này chứa mật khẩu dạng mã hóa (encoded password) của mỗi tài khoản. Mọi user thông thường đều chỉ có duy nhất quyền đọc (read) đối với file này, điều này rất cần thiết cho nhiều chương trình, ví dụ lệnh ls cần đọc file này để biết được ánh xạ giữa Username và User ID. Chỉ riêng root được chỉnh sửa file này (quyền write).

Tuy nhiên theo thời gian nó đã không còn an toàn nên các hệ điều hành Linux sau này phải ứng dụng cơ chế shadow password nhằm khắc phục nguy cơ hacker sử dụng phương thức brute force, dictionary attack để dò tìm mật khẩu nguyên gốc từ encoded password được lưu trong file /etc/passwd. Lúc này:

- Encoded password được đưa vào file /etc/shadow, trường password trong file /etc/passwd được thay bằng dấu x.
- Chỉ có root mới có toàn quyền với file shadow, các user thông thường khác vẫn có quyền đọc file /etc/passwd nhưng không có bất cứ quyền hạn truy cập nào tới file shadow.
- File thực thi usr/bin/passw được gán bit SUID để khi user chạy lệnh passwd nhằm đổi lại mật khẩu thì họ vẫn có thể ghi vào file shadow hoặc khi đọc encoded password từ shadow trong quá trình chứng thực lúc đăng nhập.

**Định dạng của file /etc/passwd**

Mỗi dòng trong file /etc/passwd là thông tin về 1 user. Có tất cả 7 trường trên mỗi dòng, các trường được phân tách bởi dấu 2 chấm ( : ). Dưới đây là 1 ví dụ về thông tin của user oracle.

<img src="">

1. Username: Tên người dùng, được sử dụng khi user đăng nhập, không nên chứa các ký tự in hoa trong username.

2. Password: Nếu sử dụng shadow password thì nên sử dụng dấu x hoặc ký tự * (gõ man pwcnv, và man shadow để hiểu rõ hơn)

3. User ID (UID): Đây là 1 chuỗi số duy nhất được gán cho user, hệ thống sử dụng UID hơn là username để nhận dạng user.

4. Group ID (GID): Là 1 chuỗi số duy nhất được gán cho Group đầu tiên mà user này tham gia (thông tin các Group có trong file /etc/group)

5. User ID Info (còn gọi là GECOS): Trường này không quan trọng lắm, bạn để trống cũng được vì chỉ dùng cho mục đích khai báo các thông tin cá nhân về user như: tên đầy đủ, số điện thoại… Lệnh finger sẽ cung cấp thêm những thông tin phụ này.

6. Home directory: Phải là đường dẫn đầy đủ tới thư mục sẽ làm thư mục chủ cho user, mặc định đây sẽ là thư mục hiện hành (working direcroty) khi user đăng nhập. Nếu bạn chỉ đến 1 thư mục không tồn tại thì hệ thống sẽ tự gán là thư mục gốc (/) làm thư mục chủ.

7. Shell: Đường dẫn đầy đủ tới login shell. Nếu để trống trường này thì login shell mặc định là file /bin/sh, nếu chỉ tới 1 file không tồn tại thì user không thể đăng nhập vào hệ thống từ giao diện console hoặc qua SSH bằng lệnh login. Nhưng user vẫn có thể đăng nhập thông qua giao diện đồ họa bằng cách sử dụng non-login shell.

**Định dạng của file /etc/group**

<img src="">

1. Tên group
2. password, thường được thay bằng dấu x
3. Group ID (GID)
4. Danh sách member (có thể có hoặc không)

### 2. Các thư mục trong linux

1. / - Root
   Đúng với tên gọi của mình: nút gốc (root) đây là nơi bắt đầu của tất cả các file và thư mục. Chỉ có root user mới có quyền ghi trong thư mục này. Chú ý rằng /root là thư mục home của root user chứ không phải là /.

2. /bin - Chương trình của người dùng
   Thư mục này chứa các chương trình thực thi. Các chương trình chung của Linux được sử dụng bởi tất cả người dùng được lưu ở đây. Ví dụ như: ps, ls, ping...

3. /sbin - Chương trình hệ thống
   Cũng giống như /bin, /sbinn cũng chứa các chương trình thực thi, nhưng chúng là những chương trình của admin, dành cho việc bảo trì hệ thống. Ví dụ như: reboot, fdisk, iptables...

4. /etc - Các file cấu hình
   Thư mục này chứa các file cấu hình của các chương trình, đồng thời nó còn chứa các shell script dùng để khởi động hoặc tắt các chương trình khác. Ví dụ: /etc/resolv.conf, /etc/logrolate.conf

5. /dev - Các file thiết bị
   Các phân vùng ổ cứng, thiết bị ngoại vi như USB, ổ đĩa cắm ngoài, hay bất cứ thiết bị nào gắn kèm vào hệ thống đều được lưu ở đây. Ví dụ: /dev/sdb1 là tên của USB bạn vừa cắm vào máy, để mở được USB này bạn cần sử dụng lệnh mount với quyền root: # mount /dev/sdb1 /tmp

6. /tmp - Các file tạm
   Thư mục này chứa các file tạm thời được tạo bởi hệ thống và các người dùng. Các file lưu trong thư mục này sẽ bị xóa khi hệ thống khởi động lại.

7. /proc - Thông tin về các tiến trình
   Thông tin về các tiến trình đang chạy sẽ được lưu trong /proc dưới dạng một hệ thống file thư mục mô phỏng. Ví dụ thư mục con /proc/{pid} chứa các thông tin về tiến trình có ID là pid (pid ~ process ID). Ngoài ra đây cũng là nơi lưu thông tin về về các tài nguyên đang sử dụng của hệ thống như: /proc/version, /proc/uptime...

8. /var - File về biến của chương trình
   Thông tin về các biến của hệ thống được lưu trong thư mục này. Như thông tin về log file: /var/log, các gói và cơ sở dữ liệu /var/lib...

9. /usr - Chương trình của người dùng
   Chứa các thư viện, file thực thi, tài liệu hướng dẫn và mã nguồn cho chương trình chạy ở level 2 của hệ thống. Trong đó

/usr/bin chứa các file thực thi của người dùng như: at, awk, cc, less... Nếu bạn không tìm thấy chúng trong /bin hãy tìm trong /usr/bin
/usr/sbin chứa các file thực thi của hệ thống dưới quyền của admin như: atd, cron, sshd... Nếu bạn không tìm thấy chúng trong /sbin thì hãy tìm trong thư mục này.
/usr/lib chứa các thư viện cho các chương trình trong /usr/bin và /usr/sbin
/usr/local chứa các chương tình của người dùng được cài từ mã nguồn. Ví dụ như bạn cài apache từ mã nguồn, nó sẽ được lưu dưới /usr/local/apache2
10. /home - Thư mục người của dùng
Thư mục này chứa tất cả các file cá nhân của từng người dùng. Ví dụ: /home/john, /home/marie

11. /boot - Các file khởi động
Tất cả các file yêu cầu khi khởi động như initrd, vmlinux. grub được lưu tại đây. Ví dụ vmlixuz-2.6.32-24-generic

12. /lib - Thư viện hệ thống
Chứa cá thư viện hỗ trợ cho các file thực thi trong /bin và /sbin. Các thư viện này thường có tên bắt đầu bằng ld* hoặc lib*.so.* . Ví dụ như ld-2.11.1.so hay libncurses.so.5.7

13. /opt - Các ứng dụng phụ tùy chọn
Tên thư mục này nghĩa là optional (tùy chọn), nó chứa các ứng dụng thêm vào từ các nhà cung cấp độc lập khác. Các ứng dụng này có thể được cài ở /opt hoặc một thư mục con của /opt

14. /mnt - Thư mục để mount
Đây là thư mục tạm để mount các file hệ thống. Ví dụ như # mount /dev/sda2 /mnt

15. /media - Các thiết bị gắn có thể gỡ bỏ
Thư mục tạm này chứa các thiết bị như CdRom /media/cdrom. floppy /media/floopy hay các phân vùng đĩa cứng /media/Data (hiểu như là ổ D:/Data trong Windows)

16. /srv - Dữ liệu của các dịch vụ khác
Chứa dữ liệu liên quan đến các dịch vụ máy chủ như /srv/svs, chứa các dữ liệu liên quan đến CVS.

### Tìm hiểu về chown, chgrp và chmod trong Linux

Quyền (permission) trên linux:

- Quyền đọc r được quy định bằng số 4
- Quyền ghi w được quy định bằng số 2
- Quyền thực thi x được quy định bằng số 1

<img src="">

Ký tự đầu thể hiện loại file:

- : Tệp tin thông thường
  d : Thư mục
  l : Liên kết
  c : Special file
  s : Socket
  p : Named pipe
  b : Thiết bị

9 dấu gạch ngang còn lại chỉ định quyền, từ trái qua phải mỗi đối tượng u,g,o chịu tác động của ba quyền r,w,x tương ứng. Các quyền này còn được thể hiện dưới dạng tổng các số rwx = 7, rw- = 6, r-x = 5 …  Cách viết quyền dưới dạng số còn được gọi là Octal Mode

Như vậy:

- Quyền 755 trên folder tương ứng với drwxr-xr-x có nghĩa là user sở hữu folder có full quyền, group sở hữu folder có quyền đọc và thực thi, other cũng có quyền đọc và thực thi.
- Quyền 644 trên file tương ứng với -rw-r--r-- có nghĩa là user sở hữu file này có quyền đọc và ghi, group sở hữu có quyền đọc, other cũng có quyền đọc mà thôi

**LỆNH CHOWN**

Cú pháp:

`chown option user:group file/folder`

**LỆNH CHMOD**

`chmod option permission file/folder`

Cũng như chown muốn phân quyền cho các file/folder con bạn thêm option -R.

**LỆNH CHGRP**

Để thay đổi group cho đối tượng sử dụng lệnh chgrp nhưng phải thỏa một trong hai điều kiện sau:
1. Bạn sử dụng quyền root
2. Bạn là chủ sở hữu và thuộc Group (có tên là Group_Name trong lệnh) mà bạn muốn thay đổi Group cho file:

`chgrp Group_Name File_Name​`

Để biết mình thuộc các nhóm nào, bạn sử dụng lệnh 'id'. Lệnh này cho biết id cùng với tên của bạn và các nhóm mà bạn tham gia.

### Tìm hiểu về các cách cài đặt package trong Linux

1. Sử dụng yum và apt-get

Đối với Debian based distributions (Ubuntu, Linux Mint,...), ta có thể dử dụng câu lệnh apt-get để có thể cài đặt package, câu lệnh này sẽ cài đặt phiên bản mới nhất của package đó.

Tương tự với những RPM based Linux distributions (Fedora, Red Hat...), t có thể sử dụng câu lệnh yum.

Hai câu lệnh này sẽ xử lí luôn những gói phụ thuộc trong quá trình cài đặt (gói phụ thuộc là những gói phải cài trước khi có thể cài gói bạn mong muốn).

Đây là 2 câu lệnh cài package từ repository, có 2 loại repo chính đó là repo của distro và repo của ứng dụng. Nếu bạn chạy câu lệnh `apt-get update` hoặc `yum update` thì nó sẽ tự động update trên repo của distro. Nếu ứng dụng đó đã ra một phiên bản mới hơn mà distro chưa cập nhật thì bạn phải tự add một repo riêng rồi mới có thể tải nó về.

2. Sử dụng rpm và dpkg

Đây được coi là công cụ "cấp thấp" để cài đặt package. Để có thể dùng rpm và dpkg để cài, nười dùng cần tải các file cài đặt (đuôi .deb đối với Debian based distributions và đuôi rpm đối với RPM based Linux distributions). Ưu điểm của phương pháp này đó là có thể tùy chỉnh được các phiên bản của gói cần cài đặt. Tuy nhiên nó sẽ không tự động điều chỉnh cài đặt cho người dùng những gói phụ thuộc.

3. Sử dụng git clone

Người dùng cần clone repo về trước khi tiến hành cài đặt. Ví dụ để có thể cài Python từ github. Đầu tiên dùng câu lệnh sau để clone repository:

`git clone https://github.com/jkbr/httpie.git`

Chạy file `setup.py`

`sudo python setup.py install`

4. Sử dụng compile

Đây là cách khó nhất để cài một package. Cách này thường được sử dụng bởi những người lập trình viên. Người dùng sẽ phải dùng câu lệnh để compile chương trình, khai báo database... Nó thường được sử dụng đối với những phần mềm chưa được phép cài đặt hoặc không có sẵn trên repository.

Xem thêm về cách compile và install packages tại [đây](https://www.digitalocean.com/community/tutorials/how-to-compile-and-install-packages-from-source-using-make-on-a-vps)

### Tìm hiểu cách nén và giải nén file trong Linux

#### Tar

Tar giúp đóng gói các files/thư mục vào trong 1 file, giúp ích rất nhiều cho việc sao lưu dữ liệu. Thông thường, Tar file có đuôi .tar. Để giảm tối đa kích thước tập tin, chúng ta cần thêm các tùy chọn nén gzip hoặc bunzip2. Tổng hợp các tùy chọn bao gồm:

- c: Tạo file lưu trữ.
- x: Giải nén file lưu trữ.
- z: Nén với gzip – Luôn có khi làm việc với tập tin gzip (.gz).
- j: Nén với bunzip2 – Luôn có khi làm việc với tập tin bunzip2 (.bz2).
- lzma: Nén với lzma – Luôn có khi làm việc với tập tin LZMA (.lzma).
- f: Chỉ đến file lưu trữ sẽ tạo – Luôn có khi làm việc với file lưu trữ.
- v: Hiển thị những tập tin đang làm việc lên màn hình.
- r: Thêm tập tin vào file đã lưu trữ.
- u: Cập nhật file đã có trong file lưu trữ.
- t: Liệt kê những file đang có trong file lưu trữ.
- delete: Xóa file đã có trong file lưu trữ.
- totals: Hiện thỉ thông số file tar
- exclude: loại bỏ file theo yêu cầu trong quá trình nén

**Tạo fie nén .tar**

`tar -cvf filename.tar file1 file2 folder1 folder2`

Filename.tar là tên file tar bạn sẽ tạo ra. File1, folder1… là các file, thư mục bạn muốn đóng gói trong file tar (đóng gói theo đúng thứ tự liệt kê).

**Đóng gói và nén dữ liệu**

Tar thông thường chỉ giúp đóng gói dữ liệu. Để nén dữ liệu giảm thiểu dung lượng, bạn dùng cần các tùy chọn nén z cho gzip (định dạng .gz) hoặc j cho bunzip (định dạng .bz2)

``` sh
# tar -czvf filename.tar.gz file1 file2 folder1 folder2
hoặc
# tar -cjvf filename.tar.bz2 file1 file2 folder1 folder2
```

**Hiển thị tổng dung lượng đã được lưu trữ**

Sử dụng tùy chọn `--totals` giúp hiển thị tổng dung lượng đã được lưu trữ

**Làm việc với file .tar**

Để xem nội dung bên trong 1 file tar, sử dụng tùy chọn v để cho ra các thông tin chi tiết trên màn hình bao gồm permission, owner, date/time…

`# tar -tvf filename.tar`

**Thêm mới, cập nhập nội dung vào file lưu trữ**

Sử dụng tùy chọn r để thêm nội dung vào file lưu trữ

`# tar -rvf filename.tar add_file1 add_file2`

Để cập nhập dữ liệu vào file lưu trữ đã có, sử dụng tùy chọn u (đặc biệt cần trong việc update các file backup)

`# tar -uf filename.tar`

Câu lệnh trên sẽ so sánh thời gian sửa đổi của nội dung bên ngoài và bên trong của file lưu trữ. File bên trong sẽ được cập nhật nếu tập tin bên ngoài mới hơn.

**Xóa dữ liệu trong file lưu trữ**

Sử dụng tùy chọn delete để xóa nội dung theo yêu cầu trong file lưu trữ

`# tar -f filename.tar --delete file1 file2`

**Giải nén file .tar**

`# tar -xvf filename.tar`

Câu lệnh trên sẽ không xóa file .tar mà sẽ chỉ giải nén dữ liệu bên trong file tar vào thư mục hiện tại. Trong trường hợp file được lưu có kèm đường dẫn, nếu đường dẫn đó không tồn tại, hệ thống sẽ tự tạo thư mục tương ứng để đặt file. Tùy theo cách bạn đóng gói dữ liệu mà khi bung ra vị trí file có thể thay đổi

**Bung file nén**

Đối với các file nén gzip .tar.gz bạn cần sử dụng thêm tùy chọn z (với file nén gzip) hay tùy chọn j (với file nén bunzip)

```
# tar -xzvf filename.tar.gz
# tar -xjvf filename.tar.bz2
```

**Bung một vài file/thư mục cụ thể**

`# tar -xvf filename.tar file1 file2`

**Bung vào 1 thư mục khác**

Để bung dữ liệu vào nơi khác thư mục hiện tại, bạn cần chỉ rõ đường dẫn của thư mục đích với tùy chọn -C

`# tar -xvf filename.tar -C /directory`

#### Gzip

Để tạo file nén gzip:

`# gzip filename`

**Thiết lập mức độ nén**

Mức độ nén được tùy chỉnh trong khoảng từ 1 đến 9. Trong đó, 1 ~ fast nén nhanh nhất nhưng mức độ nén thấp nhất còn 9 ~ best mức độ nén cao nhất nhưng nén chậm nhất

`# gzip --fast filename hoặc # gzip -1 filename`

**Kiểm tra thuộc tính file nén**

`# gzip -l filename.gz`

**Giải nén file Gzip**

`# gzip -d filename`

#### Zip

Đầu tiên, bạn cần kiểm tra cài đặt zip trong systems.

``` sh
# rpm -q zip
package zip is not installed
hoặc
Package zip-3.0-1.el6_7.1.x86_64 already installed and latest version
```

Tiến hành cài đặt Zip nếu chưa có

``` sh
# yum install zip -y
Installed:
zip.x86_64 0:3.0-1.el6_7.1
```

**Tạo file nén .zip**

`# zip filename.zip filename1 filename2`

Trong đó, filename.zip là file zip sẽ được tạo từ việc nén filename1 và filename2

**Nén folder thành 1 file zip**

Sử dụng tùy chọn -r để zip nén toàn bộ folder và các file bên trong.

`# zip -r test.zip folder1`

**Tạo file nén ở chế độ yên lặng**

Sử dụng tùy chọn -q để tạo file nén ở chế độ yên lặng – quiet, không hiển thị thông tin gì trong quá trình nén.

`# zip -rq test.zip folder`

**Giải nén file .zip**

`unzip filename.zip`

Khi đó, file trong filename.zip sẽ được giải nén vào thư mục hiện tại, file nén vẫn giữ nguyên
Nếu file đó còn tồn tại ở thư mục giải nén, chương trình sẽ hỏi bạn về các tùy chọn thay thế bao gồm:

`[y]es, [n]o, [A]ll, [N]one, [r]ename`

Sử dụng tùy chọn `-q` để giải nén ở chế độ yên lặng – quiet, không hiển thị thông tin gì trong quá trình giải nén.

### Lệnh sed trong Linux

Sed, như cái tên của nó Stream Editor, dùng để thao tác trực tiếp với văn bản như thay thế, xóa dòng, in ra một số dòng v.v.. Để bắt đầu ta sẽ xem qua một ví dụ:

```
$ echo day | sed s/day/night/ # Thay thế day bằng night
night
$ echo "day Thursday" | sed 's/day/night/g' # thêm "g" để thay thế tất cả day bằng night
night Thursnight​
```

Cú pháp của lệnh:

`sed [tùy chọn]... {script-only-if-no-other-script} [input-file]...`

Các toán tử cơ bản của sed:
[địa_chỉ_vùng]/p : In ra [vùng đã chỉ ra]. "p" là viết tắt của print.

[địa_chỉ_vùng]/d : Xóa [vùng đã chỉ ra]. "d" là viết tắt của delete.

s/mẫu1/mẫu2/ : Thay thế mẫu2 bằng mẫu1 đầu tiên của một dòng. "s" là viết tắt của substitute.

[địa_chỉ_vùng]/s/mẫu1/mẫu2/ : Giống như trên nhưng chỉ áp dụng cho vùng đã chọn

[địa_chỉ_vùng]/y/mẫu1/mẫu2/ : thay thế các ký tự trong mẫu1 với từng ký tự tương ứng tron mẫu2, áp dụng cho vùng đã chọn (tương đương với lệnh tr).

g : Thao tác trên toàn bộ dòng. "g" ở đây là viết tắt của global.​

Một số ví dụ về thao tác với sed

10d Xóa dòng thứ mười.

/^$/d Xóa các dòng trống.

1,/^$/d Xóa từ dòng đầu tiên cho đến khi gặp dòng trống đầu tiên.

/NAM/p Chỉ in ra dòng chứa "NAM" (phải dùng cùng với tùy chọn -n).

s/ * $// Xóa tất cả các khoảng trắng ở cuối mỗi dòng.

/NAM/d Xóa tất cả cáchd òng chưa "NAM".

s/NAM//g Chỉ thay thế chữ "NAM", các phần còn lại giữ nguyên.​

Thông thường lệnh sed sử dụng / để ngăn cách nhưng bạn có thể sử dụng các ký hiệu khác để thay thế như các ví dụ dưới đây:

sed 's/\/usr\/local\/bin/\/common\/bin/' # theo mặc định
sed -i 's_/usr/local/bin_/common/bin_' # dấu _ (cần tùy chọn -i )
sed -i 's:/usr/local/bin:/common/bin:' # dấu :
sed -i 's|/usr/local/bin|/common/bin|' # dấu |

Và đây là một số lệnh nâng cao của sed:

$ echo "123 abc" | sed 's/[0-9]* /& &/'​

Việc thay thế dấu xuống dòng trực tiếp bằng toán tử s/ là không khả thi. Để thay thế dấu xuống dòng bạn hãy làm theo cách dưới đây:
$ tr -d '\n' < file # use tr to delete newlines
$ sed ':a;N;$!ba;s/\n//g' file # GNU sed to delete newlines
$ sed 's/$/ foo/' file # add "foo" to end of each line​

Xem thêm về 1 số câu lệnh thao tác văn bản khác tại [đây](https://github.com/thaonguyenvan/meditech-ghichep-linux/blob/master/content/text_commands.md)

### Lệnh egrep

Egrep được dùng để tìm kiếm với regular expressions. Nó  giống với grep đi kèm tùy chọn -E

Xem thêm về các tùy chọn [tại đây](https://www.computerhope.com/unix/uegrep.htm).

Để thuận tiện cho việc xem cấu hình, tiến hành chạy câu lệnh sau

`cat /tên_file | egrep -v '^#|^$'`

nó sẽ loại bỏ những dòng bắt đầu bằng `#` và `$`

### Lệnh grep

GREP (Global regular expression print) là lệnh tìm kiếm các dòng có chứa một chuỗi hoặc từ khóa trong file.

Cú pháp lệnh :

``` sh
# grep ‘word’ filename
# grep ‘string1 string2’ filename
# cat otherfile | grep ‘something’
# command | grep ‘something’
```

Tìm kiếm từ trong file:

``` sh
# grep Port /etc/ssh/sshd_config
# grep -i port  /etc/ssh/sshd_config  ( sử dụng -i nếu bạn không nhớ chính xác là từ viết hoa hay không viết hoa )
```

Đếm số lần xuất hiện của từ tìm kiếm trong file:

`#  grep -c Port /etc/ssh/sshd_config`

Hiển thị số dòng của từ tìm kiếm trong file:

`#grep -n Port /etc/ssh/sshd_config`

Hiện thị tất cả các dòng không chứa từ tìm kiếm trong file:

`# grep -v 22 /etc/ssh/sshd_config`

`-v` là tùy chọn tìm kiếm ngược, loại bỏ tất cả dòng không chưa từ hoặc kí hiệu đó.

Kết hợp sử dụng với các lệnh khác :

`# cat /proc/cpuinfo |grep cpu`
