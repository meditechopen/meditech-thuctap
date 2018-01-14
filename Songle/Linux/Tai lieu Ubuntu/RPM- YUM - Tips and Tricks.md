RPM and YUM : Tips and Tricks

# File RPM (Red Hat Package Manager) : Red Hat based Linux distribution.

- **Yêu cầu** : HĐH CentOS 7

- Tại sao lại cần RPM package?
	- Theo hình thức ban đầu, tất cả các file sử dụng trong Linux đều ở dạng **tar** . Những file tar sẽ chứa 
	tất cả files liên quan tới phần mềm đó. Người dùng muốn sử dụng phải trích xuất file và cài đặt nó. Điều này 
	sẽ dẫn tới 2 bất lợi :
	
	-  Một phần mềm khi được cài đặt sẽ khó để theo dõi tất cả các file đã được cài đặt trên những đường dẫn 
	khác nhau trong hệ thống, do đó khó để xóa hay cập nhật phần mềm. 
	- Nếu phần mềm đó có những phần bổ trợ thì người dùng phải cài bằng tay chúng trước khi cài phần mềm.
		
=> File RPM chứa tất cả các thông tin về phiên bản, danh sách các files, các phần bổ trợ, mô tả về package... do vậy 
	sẽ luôn theo dõi được các thành phần nó.	

	- Một trong những ưu điểm của loại file này mà openSUSE hiện đang dùng là nó có thể tạo các file nâng cấp PatchRPM 
	hoặc DeltaRPM chỉ chứa phần thay đổi để cài vá vào bản đã cài trước đó. Các file nâng cấp đó có dung lượng nhỏ nên 
	quá trình tải về từ Internet và cài nhanh hơn kiểu tải cả file deb mới về cài thay thế file cũ như ở Ubuntu hiện nay.

	- Ubuntu sử dụng package system cài đặt bằng apt từ Debian, file có đuôi .deb, muốn cài đặt file rpm trên
	ubuntu cần convert từ rmp sang deb.

- File RPM khác file DEB là nội dung file đều đã dịch sang mã máy. Trong một file RPM có các thành phần chính sau:

	- Mã định danh file là một file RPM.
	- Chữ ký số để kiểm tra tính toàn vẹn và xác thực nguồn gốc file.
	- Phần đầu file chứa các meta-information như tên gói phần mềm, version, kiến trúc vi xử lý, danh sách các file trong gói, v.v..
	- Phần thân file lưu theo định dạng cpio và nén bằng gzip.
	
## RPM Command : 



1. Liệt kê danh sách các gói RPM đã cài đặt trên hệ thống :

`rpm -qa`

![Imgur](https://i.imgur.com/jxG6fYg.jpg)

2. Kiểm tra một phần mềm cụ thể nào đó đã được cài đặt trên hệ thống chưa:

`rpm -qa <package-name>`

vd : `rpm -qa httpd`

![Imgur](https://i.imgur.com/LeHom45.jpg)

3. Kiểm tra xem package nào liên quan tới một file cụ thể :

`rpm -qa <file-path>`

vd :

`rpm -qf /etc/yum.conf`

![Imgur](https://i.imgur.com/jgN9Eac.jpg)

4. Liệt kê tất cả file trong package :

`rpm -ql <package-name>`

vd :

`rpm -ql yum`

![Imgur](https://i.imgur.com/8UUYywp.jpg)

5. Kiểm các các gói bổ trợ của RPM package : 

`rpm -qR <package-name>`

vd : 

`rpm -qR yum`

6. Liệt kê sự thay đổi trong log của package :

`rpm -q --changelog <package-name>`

vd :

`rpm -q --changelog yum | less`

![Imgur](https://i.imgur.com/8UUYywp.jpg)

## Lệnh YUM 


- Yellowdog Updater Modified (yum) là một công cụ dòng lệnh để quản lí các gói RPM packages và 
các kho chứa chúng. Khi công cụ RPM không thể cài đặt các gói bổ trợ của package theo mặc định,
thì `yum` sẽ đảm nhận việc này.

- Để cài đặt, gỡ bỏ, cập nhật các RPM packages từ hệ thống và kiểm tra lịch sử `yum`, bạn cần 
chạy các lệnh với quyền `root user`.

1. Để cài đặt RPM package :

`# yum install <package-name>`

vd :

`yum install httpd`

Lệnh trên sẽ cài đặt gói `httpd` với các phần mềm bổ trợ đi kèm của nó. Nếu có một phần bổ trợ nào
không còn trong  repository, qá trình sẽ bị lỗi.

- Trong quá trình cài đặt, sẽ có lựa chọn **[y/d/N]**
	- `d` : download only
	- `y` : yes
	- `N` : No
	
- Bạn có thể cài đặt nhiều gói RPM cùng lúc :

`yum install <pkg1> <pkg2>....<pkgn>`

![Imgur](https://i.imgur.com/fwhr02L.jpg)

2. Gỡ bỏ RPM package :

`# yum erase <package name>`

vd :

`# yum erase httpd`
![Imgur](https://i.imgur.com/39bwWJp.jpg)

3. Cập nhật RPM package :

`# yum update <package name>`

vd :

`# yum update httpd`

4. Cập nhật tất cả các file RPM trong hệ thống :

`# yum update`

5. Tìm kiếm thông tin về package :

`# yum info <package name>`

vd :

`# yum info httpd`

![Imgur](https://i.imgur.com/NLRG40i.jpg)

6. Tìm ra package nào cung cấp một lệnh/thư viện cụ thể :

`# yum provides <binary/command name>`

vd :

`# yum provides sar`

![Imgur](https://i.imgur.com/aVi1jyB.jpg)

7. Kiểm tra lịch sử của các yum transaction trong hệ thống, sử dụng lệnh dưới để hiển thị transaction-id, thời gian , hoạt động :

`# yum history`

![Imgur](https://i.imgur.com/q0urqCx.jpg)

- Sử dụng lệnh `history` để xem lịch sử hoạt động của yum và hoàn tác nó :

`# yum history undo <transaction id>`

`# yum history undo 2 -y`

8. Hiển thị repository đã được cấu hình trong hệ thống :

`# yum repolist`
<<<<<<< HEAD

9. Xóa dữ liệu cache trong thư mục đường dẫn `/var/cache/yum/` directory :

`# yum clean all`

## Tạo một yum repository :
=======

![Imgur](https://i.imgur.com/tqK3p2T.jpg)

9. It is often useful to remove cached data accumulated in the /var/cache/yum/ directory.

`# yum clean all`

![Imgur](https://i.imgur.com/TS1NgUc.jpg)

## Làm thế nào để tạo một yum repository?

- Ta sẽ tạo một **repository** để test vừa quản trị nó qua **httpd**.

- Hệ điều hành : **CentOS 7**

`Server IP - 192.168.10.2`

### Cấu hình server :

- Cài đặt gói **httpd** : `yum install httpd -y`

- Tạo một twh mục `custom_repo` trong `/var/www/html` và copyrpms trong thư mục đó :

`mkdir -p /var/www/html/custom_repo`

- Khi tạo xong, bạn tải cấc gói RPMs sử dụng **yumdownloader** - một công cụ tải RPMs tử **yum reposistories**

`yumdownloader <pkg1> <pkg2> ....<pkgn>`

![Imgur](https://i.imgur.com/dbilMHs.jpg)

- **Createrepo  rpm** yêu cầu phải tạo một **yum repository** 

`yum install createrepo -y`

- Lệnh **createrepo** sẽ xuất ra repodata trong thư mục **custom_repo** . Sau khi xác nhận repodata đã được xuất,
khởi động dịch vụ **httpd**:

```
# createrepo /var/www/html/custom_repo
# ls -l /var/www/html/custom_repo/repodata
# systemctl start httpd
```
![Imgur](https://i.imgur.com/6fNxugh.jpg)

- Bạn có thể phê duyệt repository bằng cách truy cập `http://192.168.10.2/custom_repo` .

![Imgur](https://i.imgur.com/XArUg75.jpg)

### Cấu hình Client 

Có 2 cách để thêm **reposistory** vào **client system** :

-  Tạo một reposistory file `custom.repo` trong `/etc/yum.repos.d` và thêm nội dung vào một cách thủ công .

```
[custom_repo]
name=custom_repo  
baseurl=http://192.168.10.2/custom_repo  
enabled=1  
gpgcheck=1  
```

```
Name - Name of the repository  
baseurl - Repository location  
enabled - To enabled repository set value as 1. To disable, 0.  
gpgcheck - To enable gpgcheck set value as 1. To disable, 0.  
```
- Chạy lệnh `yum-config-manager` để thêm repository, nó sẽ tự động tạo một repo file trong thư mục `/ect/yum.repos.d`:

`# yum-config-manager --add-repo http://192.168.10.2/custom_repo`

![Imgur](https://i.imgur.com/oD9APQC.jpg)
cd /
- Bây giờ bắt đầu cài đặt các gói rpm trong hệ thống client :

`yum install <package name>`

- Các đường dẫn file cho việc cấu hình và gỡ lỗi :

`/etc/yum.conf` - File cấu hình chính

`/etc/yum.repos.d/` - file cấu hình reposistory

`/etc/yum/` - Một số file cấu hình yum khác

`/var/cache/yum/` - vị trí yum cache

`/var/log/yum.log` - Yum log file

`/var/lib/rpm/` - Tất cả thông tin về các gói RPMs đã được cài đặt và lưu trong RPM database. Files trong thư mục đó
là các Berkeley DB files.

**Để tra cứu tất cả lệnh/đặc điểm cung cấp bởi `yum` và `rpm` có thể sử dụng lệnh `--help` hoặc `man`**
>>>>>>> origin/master

## Tham khảo :

(1) http://neharawat.in/RPM-YUM-Tips-and-Tricks/


