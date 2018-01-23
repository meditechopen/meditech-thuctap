# The file streams
khi những câu lệnh được thực thi,mặc định có 3 chuẩn file stream
Standard input (stdin): nhập dữ liệu đầu vào
Standard output (stdout): hiện thị dữ liệu được tạo ra bởi các chương trình
Standard erro (stderr): báo lỗi trong quá trình thực thi

# chuyển hướng các luồng file
> filename: mở một tập tin, ghi đè nếu đã có dữ liệu
<img src="https://i.imgur.com/6Nybg7e.png">

>> filename: dữ liệu được thêm vào, không ghi đè

<img src="https://i.imgur.com/XzQby2Z.png">

# pipe
 Sử dụng để lấy kết quả của câu lệnh trước làm input cho câu lệnh sau, ngăn cách bởi dấu `|`
 ví dụ:
<img src="https://i.imgur.com/IKxAk68.png">

# Tìm kiếm file
`locate` là một tiện ích giúp tìm kiếm một dữ liệu có trước trong file và thư mục trong filesystem
của bạn, phù hợp cả với các thư mục chứ kí tự đặc biệt.
`local` sử dụng cơ sở dữ liệu được tạo bởi chương trình `updatedb`. Hầu hết các kệ thống Linux
chạy một cách tự động hàng ngày. Tuy nhiên, bạn cần phải cập nhật nó bất cứ lúc nào bằng cách chạy
lệnh `updatedb` dưới quền người dùng `root`

```
# sudo apt-get install -y mlocate
# updatedb
# locate zip
```
kết quả trả về của lệnh `locate` thỉnh thoảng có thể là 1 list rất dài. Để chọn lấy những thông tin
cần thiết, ta sử dụng lệnh `grep`. Nó sẽ lọc ra những dòng có chứa nội dung theo kí tự được
chỉ định

<img src="https://i.imgur.com/tJSw5e3.png">

lệnh `find` là lệnh hữu ích và thường xuyên được sử dụng hàng ngày của sysadmin. 
nó tìm kiếm tới bất kì thư mục nào và định vị tập tin phù hợp với điều kiện đã chỉ định.
mặc định nó luôn luôn làm việc ở thư mục hiện tại
## tìm kiếm văn bản
`find xxx.txt`
## tìm kiếm file ẩn
`find / -type f -name ".*"`

## chỉ tìm kiếm thư mục có tên "gcc"
`find /usr -type d -name gcc`

## chỉ tìm kiếm file có "test1"
`find /usr -type f -name test1`

Một cách sử dụng khác của `find` là chạy lệnh trên file phù hợp với tiêu chuẩn tìm kiếm của bạn
ví dụ:
## tìm và xóa tất cả file với đuôi kết thúc là .swp
`find -name "*.swp" -exec rm {} ';'`
`find -name  "*.swp" -ok rm {} \;`

## tìm kiếm file có group
`find /home -group xx`

## tìm kiếm file có quyền 777
`find .-type f -perm 777`

## tìm kiếm file file CHỈ có quyền read
`find / -perm /u=r`

## tìm kiếm file rỗng
`find /tmp - type f -empty`

## tìm kiếm file có dung lượng 50MB
`find / -size +50M`

## tìm kiếm file được chỉnh sửa trong vòng 50 - 100 ngày
`find / -mtime +50 -mtime -100`

## tìm kiếm file vừa được tạo ra trong vòng 1 giờ
`find / -cmin -60`

## tìm kiếm file có dung lượng từ 50mb - 100mb
`find / -size +50M -size -100M`

# Quản lí file
các lệnh dưới đây để xem file

cat:  sẽ trả lại nội dung tập tin ra console. nếu tập tin quá lớn cần kết hợp
cùng less
tac: sử dụng để xem file ngược từ cuối, bắt đầu từ dòng cuối cùng
less: sử dụng để phân trang trong file lớn
tail: sử dụng để check log, xem các tập tin từ cuối lên, mặc định là 10 dòng cuối file
head: sử dụng để xem file từ trên xuống dưới, bắt đầu từ dòng đầu tiên

lệnh `touch` thường được sử dụng để thiết lập hoặc cập nhật quyền truy cập, thay đổi và chỉnh
sửa thời gian của file. Mặc định nó reset mốc thời gian của file để phù hợp với file hiện tại
Tuy nhiên, bạn cũng có thể khởi tạo 1 file rỗng với `touch`
`touch filename`

thêm tùy chọn -t cho phép bạn thiết lập ngày và thời gian cho file. ví dụ để thiết lập mốc
thời gian cho 1 thời gian cụ thể:
`touch -t 03201600 filename`

câu lệnh trên thiết lập 1 file với mốc thời gian là 4 giờ chiều, ngày 20/3/1600
lệnh `mkdir` được dùng để khởi tạo thư mục. các đơn giản để xóa thư mục là dùng lệnh `rmkdir`. nhưng
lệnh `rmkdir` sẽ fail nếu thư mục cần xóa không rỗng

# So sánh file

lệnh `diff` dùng để so sánh file và thư mục

<img src="https://i.imgur.com/syOFEHB.png">
# File tiện ích
