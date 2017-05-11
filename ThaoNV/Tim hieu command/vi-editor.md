# Tìm hiểu trình soạn thảo vi

### 1. Bắt đầu trình soạn thảo vi

- Có 3 cách để start trình soạn thảo vi
  <ul>
  <li>"vi filename" : Mở filename, trong trường hợp file chưa tồn tại, nó sẽ tạo ra 1 file mới </li>
  <li>"vi -R filename và "view filename" : mở file trong trạng thái read-only</li>
  </ul>

- vi có 2 chế độ đó là `command mode` dùng để thực hiện các tasks như lưu file, thực hiện câu lệnh... và `insert mode` dùng để chèn text vào file.

Mặc định `vi` sẽ bắt đầu với `command mode`, ấn `i` để có thể vào `insert mode`, ấn `ESC` để thoát khỏi insert mode

<img src="http://i.imgur.com/VdIcd4O.gif">


### Một số phím tắt dùng để di chuyển con trỏ trong vi

- `k` : lên một dòng
- `h` : sang trái 1 kí tự
- `j` : xuống dưới 1 dòng
- `l` : sang phải 1 kí tự
- `0` hoặc `|` : về đầu dòng
- `$` : về cuối dòng
- `w` : sang từ tiếp theo
- `b` : trở về từ phía trước
- `(` : trở về đầu đoạn hiện tại
- `)` : sang đầu đoạn tiếp theo
- `e` : sang phải 1 từ
- `E` : chuyển tới khoảng trống giữa các từ tiếp theo
- `G` : chuyển tới dòng cuối
- `H` : chuyển tới dòng đầu
- `M` : chuyển tới dòng giữa

### Nhóm lệnh insert

- `i` : chèn text vào trước con trỏ
- `I` : chèn text vào đầu dòng
- `a` : chèn text vào sau con trỏ
- `A` : chèn text vào cuối dòng
- `o` : tạo 1 line mới xuống phía dưới con trỏ
- `O` : tạo 1 line mới phía trên con trỏ

### Nhóm lệnh delete

- `x` : xóa kí tự con trỏ đang trỏ tới
- `X` : xóa kí tự phía trước con trỏ
- `dw` : xóa 1 từ
- `d^` : xóa từ vị trí con trỏ tới đầu dòng
- `d$` hoặc `D` : xóa từ vị trí con trỏ tới cuối dòng
- `dd` : xóa dòng hiện tại của con trỏ
- `cc` : Remove nội dung của dòng hiện tại và chuyển sang chế độ insert

### Nhóm lệnh copy-paster và undo

- `yy` : Copy dòng hiện tại
- `yw` : copy từ hiện tại
- `p` : paste dòng vừa copy vào
- `u` : undo thao tác trước đó
- `U` : undo thao tác với dòng

### Nhóm lệnh tìm kiếm và thay thế

- `:%s/text1/text2/g` : thay thế text1 bằng text2
- `/` : tìm từ trên xuống
- `?` : tìm từ dưới lên
- `/^iface` : tìm từ iface tiếp theo
- `n` : tìm hướng xuống dưới
- `N` : tìm hướng lên trên

### Thao tác trên tập tin

- `:w` : ghi vào tập tin
- `:x` : lưu và thoát khỏi chế độ soạn thảo
- `:wq` : giống với `:x`
- `:w filename` : lưu vào một file mới
- `:q` : thoát nếu không có thay đổi
- `:q!` : thoát mà không lưu
- `:r` : mở file và insert nó vào sau dòng mà con trỏ đang chỉ tới
- `:f filename` : đổi tên file hiện tại
- `:set nu` : đánh số thứ tự