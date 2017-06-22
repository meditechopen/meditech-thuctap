# Tìm hiểu câu lệnh history

`history` là command thường được dùng để check lại lịch sử các dòng lệnh đã được thực thi bởi người dùng. Mặc định thời gian sẽ không hiển thị cùng lịch sử câu lệnh. Tuy nhiên bash shell cung cấp cho chúng ta CLI tool dành cho việc chỉnh sửa lịch sử câu lệnh. Bài viết này sẽ cung cấp cho người dùng các tips khi sử dụng `history` command

### Xem lịch sử các câu lệnh đã được thực thi trên Linux

Để xem danh sách các câu lệnh đã được thực thi trên Linux, sử dụng câu lệnh `history` đơn giản

<img src="http://i.imgur.com/rewGB58.png">

### Xem lịch sử các câu lệnh đã được thực thi trên Linux với ngày giờ cụ thể

Để hiển thị danh sách lịch sử câu lệnh kèm ngày và giờ, sử dụng câu lệnh `export HISTTIMEFORMAT='%F %T  '` trước khi chạy `history`

<img src="http://i.imgur.com/KXv4bUp.png">

Trong đó %F tương ứng với %Y - %m - %d (năm - tháng - ngày) và %T tương đương với thời gian (%H:%M:%S)

### Lọc lịch sử command

Để không hiển thị một số command nào đó, chúng ta có thể lọc nó bằng câu lệnh `export HISTIGNORE='ls -l:pwd:date:'`

Trong đó `ls -l, pwd, date` là những câu lệnh sẽ không được hiển thị trong danh sách lịch sử.

### Loại bỏ những command trùng lặp

Sử dụng câu lệnh `export HISTCONTROL=ignoredups` để tránh phải xem những câu lệnh trùng lặp với nhau.

### Loại bỏ những câu lệnh lọc

Để xóa những câu lệnh lọc trước đó, sử dụng `unset export HISTCONTROL`

### Tìm kiếm lịch sử

Để tìm kiếm trong danh sách lịch sử các câu lệnh đã thực hiện, bấm `Ctrl + R` rồi nhập vào từ cần tìm

<img src="http://i.imgur.com/oZg8HVB.png">

Bạn cũng có thể dùng `grep` để lọc ra những câu lệnh mong muốn. Ví dụ: `history | grep pwd`

### Gọi lại câu lệnh vừa thực hiện

Có 4 cách để gọi lại những câu lệnh vừa thực hiện:

- Sử dụng nút định hướng lên trên để gọi lại câu lệnh và ấn enter
- Ấn `!!` và ấn enter
- Ấn `!-1` và ấn enter
- Sử dụng tổ hợp phím `Ctrl P` và ấn enter

Để gọi lại chính xác một câu lệnh nào đó từ danh sách lịch sử, sử dụng câu lệnh `!n`, trong đó `n` là số thứ tự theo danh sách lịch sử câu lệnh.

### Thay đổi số dòng hiển thị và số dòng được lưu vào history

Mặc định thì lịch sử sẽ được lưu tại `~/.bash_history`. Để chính sửa số dòng được lưu và số dòng được hiển thị khi chạy lệnh history. Ta cần chỉnh sửa file `.bash_profile`. Thêm 2 dòng sau rồi login lại vào bash shell:

``` sh
# vi ~/.bash_profile
HISTSIZE=1000
HISTFILESIZE=2000
```

Như ở trường hợp trên, mỗi khi chạy lệnh history, sẽ có 1000 dòng được hiển thị vài file sẽ lưu được tối đa 2000 dòng.

Nếu bạn muốn lịch sử không được hiển thị, hãy sử dụng câu lệnh `export HISTSIZE=0`

### Xem lịch sử command của từng user cụ thể

`~/.bash_history` là thư mục chứa lịch sử, mặc định thì thư mục này sẽ bị ẩn đi. Bạn có thể vào thư mục của từng user để xem lịch sử của user đó theo đường dẫn `/home/username/.bash_history`. Lưu ý rằng chỉ user root mới có quyền được xem lịch sử của tất cả các user.

### Xóa tất cả lịch sử

Dùng câu lệnh sau `history -c`

**Link tham khảo:**

https://www.tecmint.com/history-command-examples/

http://www.thegeekstuff.com/2008/08/15-examples-to-master-linux-command-line-history