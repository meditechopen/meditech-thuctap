# Linux - Basic Commands

#### [Xác định vị trí các ứng dụng, dịch vụ](#xd)
#### [Truy cập thư mục](#tc)
#### [Xem danh sách các file hệ thống](#x)
#### [Gán liên kết mềm và liên kết cứng ](#g)

<hr>

### <a name="xd"> Xác định vị trí các ứng dụng, dịch vụ : </a>
- Phụ thuộc vào từng thành phần và mức ảnh hưởng tới hệ thống mà các chương trình và các gói phần mềm dược lưu
trên nhiều thư mục khác nhau. Nhìn chung các chương trình thực thi sẽ được lưu trên các đường dẫn sau : 
```
/bin
/usr/bin
/sbin
/usr/sbin
/opt.
```

- Một cách để định vị vị trí của các chương trình là sử dụng lệnh `which` . Ví dụ, để tìm chính xác vị trí của 
chương trình tên "diff" trong hệ thống, ta sử dụng lệnh :
```
$ which diff
/usr/bin/diff
```
-  Nếu lệnh `which` không tìm thấy chương trình đó, `whereis` là một lựa chọn dự phòng khá tốt vì nó sẽ tìm đến 
tất cả các gói trên một khu vực bao quát tất cả các thư mục hệ thống :

```
$ whereis diff
diff: /usr/bin/diff /usr/share/man/man1/diff.1.gz

```

### <a name="tc"> Truy cập thư mục : </a>

**Các lệnh sau dùng để di chuyển giữa các thư mục:**

![Imgur](https://i.imgur.com/wG8NdAN.png)

 ### <a name="x">Xem danh sách các file hệ thống </a>

- Lệnh `tree` rất hữu dụng để nhìn một cách tổng thể cấu trúc của các thư mục trong hệ thống :

![Imgur](https://i.imgur.com/kxhV03P.png)

**ls**

![Imgur](https://i.imgur.com/jo4N4rt.png)

**tree**

![Imgur](https://i.imgur.com/vJPhtfo.png)


 ### <a name="g"> Gán liên kết mềm và liên kết cứng </a>

- Lệnh `ln` có thể sử dụng để tạo các liên kết cứng hoặc mềm :

Giả sử một file tên ` songle.ssh ` đã tồn tại. Với liên kết cứng ` song ` sẽ được tạo bằng lệnh :

` ln songle.ssh song `

-  Note : liên kết cứng sẽ tạo ra 1 file vật lí cùng trỏ tới mục nhập inode của file vật lí gốc. 
2 file sẽ cùng tồn tại đồng đẳng như nhau, **nếu xóa file gốc thì dữ liệu hoàn toàn không bị mất** nó chỉ mất
khi không còn liên kết nào đến inode nữa .
	
![Imgur](https://i.imgur.com/Tdhcez8.png)

```
root@ubuntu:/home/songle# ls -l song*
-rw-r--r-- 2 root root 7 Sep 26 22:29 song
-rw-r--r-- 2 root root 7 Sep 26 22:29 songle.ssh

root@ubuntu:/home/songle# ls -li song*
1703952 -rw-r--r-- 2 root root 7 Sep 26 22:29 song
1703952 -rw-r--r-- 2 root root 7 Sep 26 22:29 songle.ssh
```

- Lựa chọn `-i` sẽ cho in ra cột đầu tiên của số i-node( điểm truy cập riêng biệt của mỗi file ).
Với 2 file songle.ssh và song ở trên, chúng có cùng một i-node để gọi tới, là 1 file gốc nhưng nó sẽ có 
nhiều hơn 1 tên gắn liền với nó.

```
root@ubuntu:/home/songle# ls -li song*
1703952 -rw-r--r-- 3 root root 7 Sep 26 22:29 song
1703952 -rw-r--r-- 3 root root 7 Sep 26 22:29 song1
1703952 -rw-r--r-- 3 root root 7 Sep 26 22:29 songle.ssh

```
- Nếu thay đổi file song1 , thì các songle.ssh và song cũng sẽ bị thay đổi theo.

**Link mềm ( symbolic or soft link) được tạo bằng option `-s` :**

```
root@ubuntu:/home/songle# ln -s songle.ssh songle2
root@ubuntu:/home/songle# ls -li song*
1703952 -rw-r--r-- 3 root root  7 Sep 26 22:29 song
1703952 -rw-r--r-- 3 root root  7 Sep 26 22:29 song1
1703951 lrwxrwxrwx 1 root root 10 Sep 26 23:55 songle2 -> songle.ssh
1703952 -rw-r--r-- 3 root root  7 Sep 26 22:29 songle.ssh

```

- Chú ý rằng songle2 không phải là một file bình thường, nó chỉ là một liên kết tới songle.ssh và nó có một số inode riêng. 
Link mềm không tạo ra một bản sao khác như link cứng, mà chỉ tạo một liên kết giống như 1 lối tắt tới songle.ssh ở trong thư mục.
Khi xóa song.ssh gốc thì songle2 cũng sẽ không truy cập được nữa.
```
root@ubuntu:/home/songle# rm songle.ssh
root@ubuntu:/home/songle# cat songle2
cat: songle2: No such file or directory
```

- Không giống link cứng, link mềm có thể trỏ tới các file con ở những file hệ thống khác nhau. Nó có thể trỏ đến
liên kết đã tạo nếu file gốc còn tồn tại, trường hợp file gốc không còn thì link đó sẽ trở thành link treo ( dangling link)
 và không trỏ tới file nào hết.
- Link cứng ( hard link) rất hữu dụng vì nó tiết kiệm bộ nhớ. Tuy nhiên ở một số trường hợp thì cần phải cẩn trọng khi sử dụng nó.
Ví dụ, khi bạn xóa file1 hoặc file2, số inode vẫn được giữ nguyên.  Khi bạn tạo một file mới có tên trùng với file bạn đã xóa ở trên,
thì mặc định liên kết inode sẽ được trỏ tới vị trí file đã xóa. Do đó liên kết cũ với file chưa bị xóa có thể sẽ bị mất.

