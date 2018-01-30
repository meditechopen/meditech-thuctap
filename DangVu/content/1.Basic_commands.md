# Xác định ví trí file
Phụ thuộc vào từng phần cụ thể, chương trình và các gói phần mềm có thể được cài đặt ở nhiều thư
mục khác nhau. Nhìn chung, chương trình thực thi thường được lưu ở các thư mục dưới đây.
```/bin
/usr/bin
/sbin
/usr/sbin
/opt.
```

Một cách để định vị chương trình là sử dụng lệnh `which`. Ví dụ, để tìm chính xác chương trình
tên "diff" nằm ở đâu trong filesystem:

<img src="https://i.imgur.com/LRbjrhM.png">

nếu `which` không tìm thấy chương trình đó, thì lệnh `whereis` là một sự thay thế tốt bởi vì
nó có thể tìm tới tất cả các gói trong phạm vi toàn thư mục filesystem

<img src="https://i.imgur.com/sjUasEH.png">

# Truy cập thư mục
các dòng lệnh dưới đây là rất hữu ích để di chuyển giữa các thư mục
```
cd : vào thư mục home
cd.. : vào thư mục cha
cd- : trở lại thư mục trước
cd/ : chuyển từ thư mục hiện tại vào thư mục root
```
# liệt kê filesystem
lệnh `tree` là một cách tốt để xem tổng thể cấu trúc của filesystem. Dưới đây là các lệnh
có thể giúp liệt kê filesystem:

<img src="https://i.imgur.com/WTinDTp.png">

# Liên kết mềm và liên kết cứng
lệnh `ln` có thể được sử dụng để tạo liên kết cứng hoặc liên kết mềm hay còn gọi là symlinks
tạo liên kết cứng từ filename1 đã tồn tại trước đó với cú pháp:
`ln filename1 filename2`

<img src="https://i.imgur.com/WqOg670.png">

tạo liên kết mềm thì thêm tùy chọn -s, cú pháp:
`# ln -s file1.txt file2.txt`

<img src="https://i.imgur.com/ZkIv2NA.png">

liên kết cứng là tạo 1 file mới độc lập từ 1 file đã tồn tại sẵn.
liên kết mềm cũng tạo 1 file mới từ 1 file đã tồn tại sẵn.
Sự giống nhau giữa 2 liên kết: sự thay đổi ở file gốc thì file liên kết cũng được tự động thay đổi theo
Sự khác nhau. liên kết cứng tạo ra file liên kết độc lập, nghĩa là file gốc bị xóa thì file liên kết
không bị ảnh hưởng, còn liên kết mềm khi file gốc bị xóa thì file liên kết cũng bị vô hiệu hóa

