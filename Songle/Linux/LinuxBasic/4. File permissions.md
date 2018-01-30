# File Permissions


- Trong Linux và các hệ điều hành UNIX, mỗi file đều liên quan tới một người dùng cụ thể mà sở hữu nó
- Mỗi file cũng được liên kết với một nhóm có nhu cầu đến tệp với các quyền nhất định,
 hoặc cho phép: đọc, viết và thực thi.
 
|Lệnh|Kết quả|
|-------|-----------|
|chown|Đổi quyền sở hữu của người dùng với một file hoặc thư mục|
|chgrp|Thay đổi quyền sở hữu của nhóm|
|chmod|Thay đổi quyền truy cập tới tệp| 

- File có 3 hình thức cấp quyền : **read(r)** , **write(w)**, **execute(x)**
+ Thứ tự thông thường : **rwx**
+ Quyền sở hữu được chia thành 3 nhóm : **user(u)** , **group(g)** , và **other (o)**

|rwx:|rwx:|rwx|
|----|----|---|
|u:|g:|o|

**Có nhiều cách để sử dụng lệnh `cmod` . Ví dụ, cấp quyền truy cập cho người dùng :**

```
$ ls -l test1
-rw-rw-r-- 1 joy caldera 1601 Mar 9 15:04 test1
$ chmod u+x test1
$ ls -l test1
-rwxrw-r-- 1 joy caldera 1601 Mar 9 15:04 test1
```

Tuy nhiên cách cấp quyền bằng chữ cái như vậy sẽ khó nhớ, chúng có thể được thay thế bởi các số :

- 4 : **read**
- 2 : **write**
- 1 : **execute**

=> 7 = **read + write + execute**, 6 = **read + write** , 5 = **read + execute**

+ Ví dụ :

```
$ chmod 755 test1
$ ls -l test1
-rwxr-xr-x 1 joy caldera 1601 Mar 9 15:04 test1
```

**Quyền sở hữu nhóm được thay đổi bằng lệnh `chgrp`**

```
# ll /home/mina/myfile.txt
-rw-rw-r--. 1 mina caldera 679 Feb 19 16:51 /home/mina/myfile.txt
# chgrp root /home/mina/myfile.txt
# ll /home/mina/myfile.txt
-rw-rw-r--. 1 mina root 679 Feb 19 16:51 /home/mina/myfile.txt
```
