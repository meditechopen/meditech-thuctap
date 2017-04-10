# Tìm hiểu về PS
=========================================
# Mục lục
## [I. Giới thiệu về PS](#gt)
## [II. Cú pháp câu lệnh PS](#ct)
### [2.1 Tùy chọn cơ bản](#21)
### [2.2 Lựa chọn các tiến trình theo danh sách](#22)
### [2.3 Định dạng đầu ra](#23)
### [2.4 Hiển thị theo chủ đề](#24)
## [III. Một số ví dụ về PS](#vd)

<a name=gt></a>
## I. Giới thiệu về PS
- Ps là một chương trình báo cáo về tình trạng của các tiến trình đang chạy trên hệ điều hành linux.
- Trên mọi hệ điều hành tương tự như UNIX, PS hiển thị thông tin về các quy trình đang hoạt động.Mỗi phiên bản PS của các hệ điều hành hơi khác nhau.ví dụ :
<ul>
<li>UNIX : các tùy chọn có thể được nhóm lại và phải có dấu "-"</li>
<li>BSD : Các tùy chọn có thể được nhóm lại và không sử dụng dấu "-"</li>
<li>GNU : Các tùy chọn phải được đặt trước 2 dấu "-"</li>
</ul>

Các tùy chọn có nhiều loại khác nhau, nếu sử dụng một cách tự do có thể gây ra mâu thuẫn giữa các tùy chọn với nhau.
- Mặc định, ps chon tất cả các quy trình với cùng một ID người dùng(euid = EUID).

<a name=ct></a>
## II. Cú pháp câu lệnh PS

```
ps [options]
```

<a name=21></a>
### 2.1 Các tùy chọn cơ bản
  - a : chọn tất cả kèm với tty,ngoại trừ các phiên chủ đạo.
  - -A, -e : Chọn tất cả các tiến trình
  - -a : chọn tất cả các tiến trình cùng với tty,bao gồm cả các người dùng khác.
  - -d : Chọn tất cả các tiến trình trừ tiến trình chủ đạo.
  - -N, --deselect : Chọn tất cả các tiến trình, trừ những tiến trình thỏa mãn điều kiện.
  - T : Chọn tất cả các tiến trình kết hợp với thiết bị đầu cuối.
  - r : Hạn chế lựa chọn chỉ để chạy các tiến trình.
  - x : Các tiến trình mà đang không điều khiển các tty.

<a name=22></a>
### 2.2 Lựa chọn các tiến trình theo danh sách.
  Các tùy chọn này chấp nhận một đối số duy nhất ở dạng một danh sách trống hoặc tách biệt nhau bằng dấu phẩy, và chúng có thể được sử dụng nhiều lần.Ví dụ :

```
ps -p "1 2" -p 3,4
```

  Các tùy chọn chọn các quy trình theo danh sách như sau :

- -C <command> : chọn bằng tên các câu lệnh.
- -g , --group <group> : Chọn theo phiên hoặc tên nhóm có hiệu quả.
- -G, --Group grplist : Chọn theo tên thật của nhóm ID (RGID) hoặc tên.
- -p , p, ---pid <PID> : Chọn theo ID tiến trình.
- --ppid <PID> : Chọn theo ID của tiến trình cha.
- -s, -sid <session> : Chọn theo ID phiên.
- t,t, --tty <tty> : Chọn bởi tty hay terminal.
- -u, U, --uer <UID> : Chọn theo ID hoặc tên người dùng có hiệu lực.
- -U, --User <UID> : Chọn theo ID hoặc tên người dùng thực.

<a name=23></a>
### 2.3 Định dạng đầu ra
 Có các tùy chọn xuất đầu ra như sau :
 - -f : Hiển thị đầy đủ định dạng,được chèn trong câu lệnh.
 - f, --forest : Hiển thị tiến trình theo cây .
 - -H : Hiển thị tiến trình theo phân cấp.
 - -j : Hiển thị theo định dạng công việc.
 - -l : Hiển thị theo định dạng dài.
 - -M , Z : Thêm bảo vệ dữ liệu
 - -O <formart> : Hiển thị cùng các cột mặc định được nạp sẵn.
 - -o , o, --formart <formart> : người dùng định nghĩa định dạng.
 - -s : định dạng tín hiệu
 - u : định dạng định hướng người dùng.
 - X : tạo định dạng.
 - -y : không hiển thị cờ, hiển thị rss vs. addr (sử dụng cùng với -l).

<a name=24></a>
### 2.4 Hiển thị theo chủ đề
 - H : nếu nó từng là tiến trình.
 - -L : Có thể cùng với cột LWP và NLWP
 - m, -m : Sau tiến trình.
 - -T : có thể cùng với cột SPID.

<a name=vd></a>
## III. Một số ví dụ về PS
- Hiển thị tất cả các tiến trình:

  ```
  ps ax
  ps -ef

  Sử dụng tùy chọn "u" hoặc "-f" để hiển thị thông tin chi tiết về các quy trình :

  ps aux
  ps -ef -f
  ```
- Hiển thị các tiến trình của gười dùng.Để lọc các quá trình bởi người dùng sở hữu sử dụng tùy chọn "-u" theo sau tên người dùng. Nhiều tên người dùng có thể được cung cấp cách nhau bằng dấu phẩy.

  ```
 ps -f -u

  ```
- Hiển thị tiến trình theo tên hoặc ID tiến trình :

 ```
 ps -C apche2

 ps -f -p 3150,7298
 ```

-
