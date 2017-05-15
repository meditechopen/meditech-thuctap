# Tìm hiểu về lệnh GREP trong linux
----------------------------------------------------------------------
GREP (Global regular expression print) là lệnh tìm kiếm các dòng có chứa một chuỗi hoặc từ khóa trong file. Bài viết này sẽ hướng dẫn cách dùng lệnh grep cơ bản.

## 1. Tìm một chuỗi trong một file
- Đây là cách sử dụng cơ bản và hay gặp nhất, nếu đơn gỉan bạn muốn tìm một chuỗi nào đó trong chỉ một file duy nhất thì có thể dùng theo cú pháp sau :
```
$ grep "chuoi" ten_file
```
- Kết qủa sẽ hiển thị ngay trên màn hình command line theo dòng nào có chứa chuỗi sẽ hiển thị cả dòng trong file đó ra và chuỗi đó sẽ được highlight.


## 2. Tìm chuỗi trong nhiều file cùng lúc
- Để làm được việc này thì bạn cần chỉ định pattern chung của các file muốn thực hiện tìm kiếm :
```
$ grep "chuoi" file_pattern
```
- Ví dụ, Muốn tìm chuỗi Error trong tất cả các file log mà chúng được ghi theo từng ngày với for mat report_ddmmyyyy.log :
```
$ grep "chuoi" report_*.log
```
- Khi này kết qủa tìm kiếm sẽ hiển thị ra thêm cả tên file mà có chứa chuỗi Error dạng :
```
report_01082016.log: <nội dung match ở đây>
report_01082016.log: <nội dung match ở đây>
...
report_28082016.log: <nội dung match ở đây>
report_28082016.log: <nội dung match ở đây>
report_29082016.log: <nội dung match ở đây>
```
## 3. Tìm kiếm không phân biệt hoa thường
- Bình thường nếu bạn đã chắc chắn chuỗi mình định tìm kiếm như nào và chỉ muốn có kết qủa match 100% chuỗi đó thì ko cần sử dụng thêm lựa chọn -i, khi khai báo thêm nó grep sẽ thực hiện tìm kiếm gần đúng theo kiểu không phân biệt ký tự hoa thường :
```
$ grep -i "chuoi" ten_file
```
- Như ví dụ trên thì dù là Error, error hay ERROR ... đi chăng nữa thì bạn cũng sẽ nhận được kết qủa.

## 4. Tìm kiếm theo regular expression
- Như bao ngôn ngữ lập trình, việc tìm kiếm theo regular expression luôn được hỗ trợ thì lệnh grep cũng vậy, bạn hoàn toàn có thể chỉ định biểu thức chính quy để tìm kiếm chuỗi match với nó
```
$ grep "regex_here" ten_file
```
- Trong grep thì nó cũng giống các ngôn ngữ khác, ví dụ [A-z] tức là match với chỉ kí tự alpha từ A lớn đến z nhỏ, hay dùng [^text] là ko chứa chuỗi text...

## 5. Tìm chính xác với grep -w
- Nếu tìm kiếm theo những lệnh trên thì kết qủa trả về sẽ chưa hẳn theo đúng mong muốn của bạn. Kết qủa thường sẽ thừa so với yêu cầu bởi vì grep sẽ tìm theo cả chuỗi con, ví dụ tìm no thì not, nothing cũng có chứa chuỗi no nên cũng sẽ trả về kết qủa. Do đó, nếu bạn muốn tìm chính xác từ mong muốn thì có thể dùng lựa chọn -w.
```
$ grep -i "is" demo_file
```

## 6. Hiển thị thêm dòng trước, sau, xung quanh dòng chứa kết qủa
- Có những trường hợp bạn phải thao tác với file rất lớn, nên có thể lựa chọn tìm kiếm mà có hiển thị ra các dòng trước, sau hoặc xung quanh dòng kết qủa sẽ có thể hữu ích.
```
$ grep -<A, B hoặc C> <n> "chuoi" demo_file
-- A : là after
-- B : là before
-- C : là xung quanh
-- n : là số tự nhiên chỉ định xem hiển thị trước, sau hay xung quang bao nhiêu dòng
```

## 7. Tìm tất cả các file ở tất cả các thư mục con
- Đôi khi bạn không biết file ở đâu trong thư mục rất nhiều file, không nhớ tên file là gì hoặc đơn gỉan là muốn tìm kiếm với từ khóa xem nó có trong nhưng file nào trong thư mục hiện hành. Lúc đó, lựa chọn -r sẽ hữu ích. Nếu khai báo lựa chọn này thì nó sẽ tìm đến tận cùng các thư mục con, tất cả các file có trog chúng.
```
$ grep -r "chuoi" *
```

## 8. Tìm kiếm ngược
- Với những lựa chọn trên bạn có thể tìm kiếm từ khóa theo những hoàn cảnh của riêng mình, nhưng nếu bạn muốn ngược lại tức là chỉ tìm những dòng không chứa từ khóa đó thì hãy dùng -v.
```
$ grep -v "chuoi" file_*
```

## 9. Đếm số kết qủa
- grep hoàn toàn có thể hỗ trợ bạn đếm xem trong file chỉ định có bao nhiêu kết qủa trả về bằng cách dùng -c. Ví dụ như đếm xem có bao nhiêu bản ghi được insert trong file log.
```
grep -c -w "INSERT" log_*
```

## 10. Chỉ hiển thị tên file
- Bạn chỉ quan tâm xem từ khóa bạn đang tìm xuất hiện trong những file nào thôi. Lúc đó hãy dùng lựa chọn -l
```
$ grep -l -r -w "Error" *
```

## 11. Hiển thị số thứ tự của dòng kết qủa
- Trong một file rất lớn thì nhu cầu biết được xem kết qủa ở dòng nào thì tôi nghĩ luôn là cần thiết. grep hoàn toàn làm được điều này với lựa chọn -n.
```
$ grep -n -w "Error" file_name
```

## 12. Ứng dụng
- Trong thực tế hay gặp nhất có lẽ là lệnh kép kiểm tra xem một chương trình nào đó có đang chạy hay không, bằng cách kết hợp ps và grep.
- Ví dụ
```
$ ps ux | grep ssh
```
