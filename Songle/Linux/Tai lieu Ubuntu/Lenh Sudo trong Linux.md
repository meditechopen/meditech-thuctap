# Sudo trong Linux

## 1. Định nghĩa :

- Sudo là chữ viết tắt của Superuser Do.

- Sudo được dùng khi ta muốn thực thi một lệnh trên Linux với quyền của một user khác. 
Nếu được cho phép, ta sẽ thực thi một lệnh như là người quản trị hay một user nào khác. 
Các khai báo “ai được làm gì” đặc tả trong file “/etc/sudoers”. 
Những ghi nhận (log) của hệ thống khi sudo được sử dụng theo mặc định nằm trong file /var/log/secure (Red Hat/Fedora / CentOS Linux) 
hoặc /var/log/auth.log (Ubuntu / Debian Linux).

- Nếu người sử dụng sudo là root hoặc là người muốn “mượn” quyền là một thì sẽ không có xác nhận mật khẩu. 
Còn lại ,sudo yêu cầu người dùng phải tự xác nhận bằng mật khẩu. Lưu ý ở đây là trong cấu hình mặc định thì mật khẩu để xác nhận này là mật khẩu của người sử dụng, 
chứ không phải mật khẩu của root. Khi người dùng đã được xác nhận xong, hệ thống sẽ thiết lập một khoảng thời gian cho user đó tiếp tục dùng sudo mà không cần phải xác nhận mật khẩu lại (mặc định là 15 phút).

- Đối với user gõ lệnh `sudo`, thì họ sẽ được hỏi mật khẩu của chính họ để xác nhận gửi yêu cầu thay vì sử dụng lệnh `su` là chuyển sang tài khoản root và nhập mật khẩu của root vì không bảo mật bằng.

## 2. Tạo và quản lí user :

- Tạo user mới : **useradd** tên-user-cần-tạo 

vd : useradd songle

- Thiết lập mật khẩu cho user vừa tạo : **passwd** tên-user-cần-thiết-lập

vd : passwd songle

=> Gõ mật khẩu 2 lần để hoàn thành .

- Kiểm ra xem đã tạo thành công user chưa : **cat /etc/passwd**

Khi tạo xong một user, user đó sẽ có riêng một thư mục nằm trong `/home` . User này có thể thay đổi, xóa
trên thư mục của họ mà không thể thay đổi gì ở các thư mục khác khi chưa được cấp quyền.

- Thêm quyền quản trị cho user và sử dụng **sudo** :

	- Trường hợp nếu bạn muốn thêm user nhưng bạn chưa được cấp quyền quản trị, phải sử dụng **sudo** để
	thực thi lệnh : `sudo useradd songle2`
	
	- Tuy nhiên, khi user bạn mới lập không được quyền sử dụng lệnh `sudo` thì phải thoát ra và đăng nhập bằng 
	tài khoản **root** , gõ lệnh **visudo** ( vi /etc/sudoes )
	
	- Sử dụng lệnh để tìm đến dòng :/Allows people in group .
	
	- Bây giờ bạn hãy viết đoạn này vào bên dưới bằng cách ấn `i` để **Insert**
	
	```
	# %wheel        ALL=(ALL)       ALL
	
	**%quantri      ALL=(ALL)       ALL**
	```
	
		Lưu lại và thoát ra bằng `:wq!`
	
	- Mặc dù đã thêm group `quantri` vào danh sách sudoers nhưng ta chưa tạo group nào tên là quản trị, vậy
	tiến hành tạo group : **groupadd quantri**
	
	- Để kiểm tra toàn bộ danh sách group trong VPS, sử dụng lệnh : **cut -d: -f1 /etc/group**

	- Tiếp theo, đưa user cần được cấp quyền vào group quản trị :
	
	**usermod -G quantri songle2**
	
	- Kiểm tra xem user **songle2** đã có trong group chưa : **# groups quantri**
	
	- Vậy là từ giờ bạn có thể sử dụng tài khoản **songle2** để thực hiện các lệnh quản trị thay
	vì phải đăng nhập vào tài khoản root như cũ.
	
	
	
	

	


