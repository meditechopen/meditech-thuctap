# Tìm hiểu shell linux

## Mục lục

1. Shell script là gì?

2. Hướng dẫn tạo và thực thi chương trình shell

3. Biến trong shell

4. Các phép toán số học

5. Cấu trúc điều khiển


--------------

## 1. Shell script là gì?

Shell là chương trình giao tiếp với người dùng. Có nghĩa là shell chấp nhận các lệnh từ bạn (keyboard) và thực thi nó. Nhưng nếu bạn muốn sử dụng nhiều lệnh chỉ bằng một lệnh, thì bạn có thể lưu chuỗi lệnh vào text file và bảo shell thực thi text file này thay vì nhập vào các lệnh. Điều này gọi là shell script.

Định nghĩa: Shell script là một chuỗi các lệnh được viết trong plain text file. Shell script thì giống như batch file trong MS-DOS nhưng mạnh hơn.

Tại sao phải viết shell script:

- Shell script có thể nhận input từ user, file hoặc output từ màn hình.

- Tiện lợi để tạo nhóm lệnh riêng.

- Tiết kiệm thời gian.

- Tự động làm một vài công việc thường xuyên.

## 2. Hướng dẫn tạo và thực thi chương trình shell

- Tạo file hello.sh với nội dung như sau

``` sh
#!/bin/bash
echo "hello world"
```

**Lưu ý:** Dòng đầu tiên chúng ta luôn đặt #!/bin/bash, đây là cú pháp bắt buộc. Sau # được hiểu là comment, chú thích của các đoạn mã.

- Sau đó, để script có thể thực thi ta phải cấp quyền cho nó

`chmod 0777 hello.sh`

- Có thể chạy file bằng 1 số cách sau

``` sh
–  bash hello.sh
–  sh hello.sh
–  ./hello.sh
```

## 3. Biến trong shell

Trong Linux shell có 2 loại biến:

- Biến hệ thống :

  - Tạo ra và quản lý bởi Linux.
  - Tên biến là CHỮ HOA

- Biến do người dùng định nghĩa

  - Tạo ra và quản lý bởi người dùng
  - Tên biến là chữ thường

**Một số biến hệ thống**

``` sh
$BASH_VERSION
$BASH
$HOME
$PATH
```

**Biến người dùng, cú pháp, quy tắc đặt tên**

Cú pháp:

`tên_biến=value`

- tên_biến phải bắt đầu bằng ký tự
- Không có dấu cách 2 bên toán tử = khi gán giá trị cho biến

``` sh
#Đúng
a=1
#sai
a = 1
#sai
a= 1
```

- Tên biến có phân biệt chữ hoa, thường

``` sh
#các biến sau đây là khác nhau
a=1
A=2
```

- Một biến không có giá trị khởi tạo thì bằng NULL
- Không được dùng dấu ?, * để đặt tên các biến

**ECHO Để in giá trị của biến**

Cú pháp:

``` sh
echo [option][string,variables…]
#example
echo $tên_biến
```

- In một số ký tự đặc biệt trong tham số với tùy chọn -e:

``` sh
\a  alert   (bell)
\b  backspace
\c  suppress trailing new   line
\n  new line
\r  carriage return
\t  horizontal tab
\\  backslash

//example
$ echo -e "Hello\tThao"
#output:  Hello   Thao
$ echo -e "Hello\nThao"
#output
Hello
Thao
```

## 4. Các phép toán số học

Cú pháp:

`expr toán_hạng_1 toán_tử toán_hạng_2`

``` sh
# phép cộng
$expr 1 + 2
# phép trừ
$expr 5 - 1
# phép chia
$expr 8 / 3   # output =2 phép chia chỉ lấy phần nguyên
$expr 8 % 5  # output =3 phép chia lấy phần dư
$expr 10 \* 2 # output = 20 phép nhân
```

Chú ý: Phải có dấu cách trước và sau toán tử.

``` sh
# example sai cú pháp
$expr 1+2
$expr 5- 1
```

**Các dấu ngoặc**

- Tất cả các ký tự trong dấu ngoặc kép đều không có
ý nghĩa ñnh toán, trừ những ký tự sau \ hoặc $
- Dấu nháy ngược: nghĩa là yêu cầu thực thi lệnh

``` sh
#example
$ echo "ngay hom nay la: `date`"
#ouput: ngay hom nay la: Wed Apr 27 10:43:59 ICT 2016
$ echo `expr 1 + 2`
#output = 3
$echo "expr 1 + 2"
#ouput: expr 1 + 2
```

**Kiểm tra trạng thái trả về của 1 câu lệnh**

`$echo $?`

- Trạng thái 0 nếu câu lệnh kết thúc thành công.
- Khác 0 nếu kết thúc có lỗi

``` sh
# xóa file không tồn tại
rm abc.txt #output messge:( rm: cannot remove `abc.txt': No such file or directory )
# kiểm tra trạng thái câu lệnh rm abc.txt
$echo $? #output 1 nghĩa là có lỗi

$ echo "ngay hom nay la: `date`"
#ouput: ngay hom nay la: Wed Apr 27 10:43:59 ICT 2016
$echo $? #output 0, nghĩa là thành công
```

## 5. Cấu trúc điều khiển

**If**

``` sh
if điều_kiện
then
câu lệnh 1
…
fi
```

**if...else...fi**

``` sh
if điều_kiện then
    câu_lệnh_1
….
else
    câu_lệnh_2
fi
```

**For**


for { tên biến } in { danh sách }
do
# Khối lệnh
# Thực hiện từng mục trong danh sách cho đến cho đến hết
# (Và lặp lại tất cả các lệnh nằm trong "do" và "done")
done

#hoặc sử dụng for
for (( expr1; expr2; expr3 ))
do
# Lặp cho đến khi biểu thức expr2 trả về giá trị TRUE
done


Ví dụ

``` sh
#  for 1
for i in 1 2 3 4 5
do
 echo $i
done

#output: 1 2 3 4 5

#for 2
for (( i = 0 ; i <= 5; i++ )) # bao quanh bằng (())
do
echo $i
done
#ouput 1 2 3 4 5
```

**While**

``` sh
while   [Điều kiện]
do
command1
command2
command3    ..  ....
done
```

Ví dụ:

``` sh
#!/bin/sh
echo "Nhap vao cac so can tinh tong, nhap so am de exit"
sum=0
read i
while [ $i -ge 0 ] # nếu i >= 0
do
sum=`expr $sum + $i`
read i # nhận giá trị từ người dùng
done
echo "Total: $sum."
```
