# Hướng dẫn sử dụng apt-mirror làm local repository

## Mục lục

1. Tổng quan về apt-mirror

2. Cấu hình apt-mirror server

3. Cấu hình trên client

-----------------------------

## 1. Tổng quan về apt-mirror

Apt-mirror là một packages được sử dụng cho Ubuntu và Debian để sync repository official của Ubuntu về local và chia sẻ với các client trong mạng local.

## 2. Cấu hình apt-mirror server

- Cài đặt apt-mirror

`apt-get install apt-mirror`

- Sau khi cài đặt, source list của mirror nằm trong thư mục /etc, vào đây để chỉnh

`vi /etc/apt/mirror.list`

Nội dung của file

``` sh
############# config ##################
    #
    # set base_path /var/spool/apt-mirror
    #
    # if you change the base path you must create the directories below with write privileges
    #
    # set mirror_path $base_path/mirror
    # set skel_path $base_path/skel
    # set var_path $base_path/var
    # set cleanscript $var_path/clean.sh
    # set defaultarch <running host architecture>
    set nthreads 20
    set _tilde 0
    #
    ############# end config ##############

    deb http://archive.ubuntu.com/ubuntu jaunty main restricted universe multiverse
    deb http://archive.ubuntu.com/ubuntu jaunty-updates main restricted universe multiverse
    deb http://archive.ubuntu.com/ubuntu jaunty-backports main restricted universe multiverse
    deb http://archive.ubuntu.com/ubuntu jaunty-security main restricted universe multiverse
    deb http://archive.ubuntu.com/ubuntu jaunty-proposed main restricted universe multiverse

    deb-src http://archive.ubuntu.com/ubuntu jaunty main restricted universe multiverse
    deb-src http://archive.ubuntu.com/ubuntu jaunty-updates main restricted universe multiverse
    deb-src http://archive.ubuntu.com/ubuntu jaunty-backports main restricted universe multiverse
    deb-src http://archive.ubuntu.com/ubuntu jaunty-security main restricted universe multiverse
    deb-src http://archive.ubuntu.com/ubuntu jaunty-proposed main restricted universe multiverse

    clean http://archive.ubuntu.com/ubuntu
```

- Bạn có thể khai báo repo muốn tải về để làm local repo vào đây, mặc định package được tải về sẽ nằm trong `/var/spool/apt-mirror/`

- Chạy câu lệnh để tải về

`apt-mirror /etc/apt/mirror.list`

- Tùy từng repo mà dung lượng sẽ được tải về khác nhau

- Tiếp theo ta cài apache2

`apt-get install apache2`

- Sau đó tạo đường liên kết để public repo này

```
cd /var/www
ln -s /var/spool/apt-mirror/mirror/archive.ubuntu.com/ubuntu/ ubuntu
```

Lưu ý là tùy từng repo mà bạn tải về bạn sẽ thay đổi đường dẫn trên tới thư mục mà apt-mirror tải repo về

## 3. Cấu hình trên client

Tiến hành khai báo để client trỏ tới repo của bạn bằng cách sửa file source list

`vi /etc/apt/sources.list`

Ở đây ta cần thay thế đường dẫn các máy chủ trên thế giới bằng máy chủ chạy apt-mirror. Ví dụ ở đây địa chỉ của mình là `192.168.1.5` ta sẽ thay như Sau

```
deb http://192.168.1.5/ubuntu jaunty universe
deb-src http://192.168.1.5/ubuntu/ jaunty universe
deb http://192.168.1.5/ubuntu/ jaunty-updates universe
deb-src http://192.168.1.5/ubuntu/ jaunty-updates universe
```

Sau khi thay, tiến hành chạy lệnh `apt-get update` và tải gói

**Link tham khảo:**

https://www.diendanmaychu.vn/showthread.php/388-Setup-local-Repository-Mirror-cho-Ubuntu-9.04

https://saylinux.wordpress.com/2007/09/01/server-update-va-qu%E1%BA%A3n-ly-software-v%E1%BB%9Bi-apt-mirror/

http://www.familug.org/2015/10/mirror-apt-repository-voi-apt-mirror.html
