# Một số module phổ biến thường được dùng trong cloud-init

## Mục lục

[1. Bootcmd](#1)

[2. Disk Setup](#2)

[3. NTP](#3)

[4. Package Update Upgrade Install](#4)

[5. Resolv Conf](#5)

[6. Runcmd](#6)

[7. Set Hostname](#7)

[8. Set Passwords](#8)

[9. SSH](#9)

[10. Users and Groups](#10)

[11. Write Files](#11)

[12. Yum Add Repo](#12)

[13. Power State Change](#13)

---------------

<a name=""></a>
## 1. Bootcmd

Chạy câu lệnh ở ngay lúc quá trình boot mới diễn ra. Nó nên chỉ được dùng cho những phần sẽ không làm được ở giai đoạn sau của quá trình boot.

Distro hỗ trợ: tất cả

Config keys:

```sh
bootcmd:
    - echo 192.168.1.130 us.archive.ubuntu.com > /etc/hosts
    - [ cloud-init-per, once, mymkfs, mkfs, /dev/vdb ]
```

<a name=""></a>
## 2. Disk Setup

Cấu hình partions và filesystems.

Distro hỗ trợ: tất cả

Config keys:

``` sh
device_aliases:
    <alias name>: <device path>
disk_setup:
    <alias name/path>:
        table_type: <'mbr'/'gpt'>
        layout:
            - [33,82]
            - 66
        overwrite: <true/false>
fs_setup:
    - label: <label>
      filesystem: <filesystem type>
      device: <device>
      partition: <"auto"/"any"/"none"/<partition number>>
      overwrite: <true/false>
      replace_fs: <filesystem type>
```

<a name="3"></a>
## 3. NTP

Kích hoạt và cấu hình NTP

Nếu ntp chưa được cài đặt nhưng đã được cấu hình, nó sẽ được cài đặt sau. Nếu mặc định đã có file cấu hình ntp trên image hoặc trong distro, nó sẽ được copy tới `/etc/ntp.conf.dist` trước khi được thay đổi. Nếu không có pool hoặc server nào, 4 pools sẽ được sử dụng đó là `{0-3}.{distro}.pool.ntp.org`

Distro hỗ trợ: centos, debian, fedora, opensuse, ubuntu

Config examples:

``` sh
ntp:
  pools:
  - 0.company.pool.ntp.org
  - 1.company.pool.ntp.org
  - ntp.myorg.org
  servers:
  - my.ntp.server.local
  - ntp.ubuntu.com
  - 192.168.23.2
```

<a name="4"></a>
## 4. Package Update Upgrade Install

Update, upgrade và cài đặt packages trong quá trình boot. Nếu có package nào được cài đặt hoặc upgrade thì package cache sẽ được update trước. Nếu yêu cầu reboot thì máy sẽ reboot khi phát hiện tùy chọn `package_reboot_if_required`.

Distro hỗ trợ: Tất cả

Config keys:

``` sh
packages:
    - pwgen
    - pastebinit
    - [libpython2.7, 2.7.3-0ubuntu3.1]
package_update: <true/false>
package_upgrade: <true/false>
package_reboot_if_required: <true/false>

apt_update: (alias for package_update)
apt_upgrade: (alias for package_upgrade)
apt_reboot_if_required: (alias for package_reboot_if_required)
```

<a name="5"></a>
## 5. Resolv Conf

Cấu hình file resolv.conf nếu nó là cần thiết cho những tiến trình tiếp theo trong quá trình boot. Lưu ý trên các distro Ubuntu/debian, người ta khuyến khích sử dụng file /etc/network/interfaces.

Distro hỗ trợ: fedora, rhel, sles

Config keys:

``` sh
manage_resolv_conf: <true/false>
resolv_conf:
    nameservers: ['8.8.4.4', '8.8.8.8']
    searchdomains:
        - foo.example.com
        - bar.example.com
    domain: example.com
    options:
        rotate: <true/false>
        timeout: 1
```

<a name="6"></a>
## 6. Runcmd

Chạy câu lệnh. Lưu ý tất cả các câu lệnh cần đúng theo cú pháp yaml.

Distro hỗ trợ: tất cả

Config keys:

``` sh
runcmd:
    - [ ls, -l, / ]
    - [ sh, -xc, "echo $(date) ': hello world!'" ]
    - [ sh, -c, echo "=========hello world'=========" ]
    - ls -l /root
    - [ wget, "http://example.org", -O, /tmp/index.html ]
```

<a name="7"></a>
## 7. Set Hostname

Đặt hostname và fqdn. Nếu tùy chọn `preserve_hostname` được thiết lập thì hostname sẽ không thể bị thay đổi sau này.

Distro hỗ trợ: tất cả

Config keys:

``` sh
preserve_hostname: <true/false>
fqdn: <fqdn>
hostname: <fqdn/hostname>
```

<a name="8"></a>
## 8. Set Passwords

Cấu hình passwords và kích hoạt hoặc hủy ssh bằng password.

Distro hỗ trợ: tất cả

Config keys:

``` sh
ssh_pwauth: <yes/no/unchanged>

password: password1
chpasswd:
    expire: <true/false>

chpasswd:
    list: |
        user1:password1
        user2:RANDOM
        user3:password3
        user4:R

##
# or as yaml list
##
chpasswd:
    list:
        - user1:password1
        - user2:RANDOM
        - user3:password3
        - user4:R
        - user4:$6$rL..$ej...
```

<a name="9"></a>
## 9. SSH

Cấu hình ssh và ssh keys. Có rất nhiều image đã có sẵn keys, bạn có thể xóa nó bằng tùy chọn `ssh_deletekeys`.

Lưu ý: Khi cấu hình ssh private keys, nhớ rằng kết nối giữa datasource và instance phải được bảo mật.

Các loại keys hỗ trợ:

- rsa
- dsa
- ecdsa
- ed25519

Root login có thể được kích hoạt hoặc hủy bỏ thông qua tùy chọn `disable_root`.

Distro hỗ trợ: tất cả

Config keys:

``` sh
ssh_deletekeys: <true/false>
ssh_keys:
    rsa_private: |
        -----BEGIN RSA PRIVATE KEY-----
        MIIBxwIBAAJhAKD0YSHy73nUgysO13XsJmd4fHiFyQ+00R7VVu2iV9Qco
        ...
        -----END RSA PRIVATE KEY-----
    rsa_public: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAGEAoPRhIfLvedSDKw7Xd ...
    dsa_private: |
        -----BEGIN DSA PRIVATE KEY-----
        MIIBxwIBAAJhAKD0YSHy73nUgysO13XsJmd4fHiFyQ+00R7VVu2iV9Qco
        ...
        -----END DSA PRIVATE KEY-----
    dsa_public: ssh-dsa AAAAB3NzaC1yc2EAAAABIwAAAGEAoPRhIfLvedSDKw7Xd ...
ssh_genkeytypes: <key type>
disable_root: <true/false>
disable_root_opts: <disable root options string>
ssh_authorized_keys:
    - ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAGEA3FSyQwBI6Z+nCSjUU ...
    - ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA3I7VUf2l5gSn5uavROsc5HRDpZ ...
```

<a name="10"></a>
## 10. Users and Groups

Cấu hình users và groups. Các entry hỗ trợ đối với `users`

- `name` : Tên user login. (bắt buộc)
- `expiredate` : Ngày user không thể đăng nhập
- `gecos` : Comment về user, thường để lưu thông tin liên lạc
- `groups` : Groups để add users vào
- `homedir` : thư mục cho user, mặc định là `/home/<username>`
- `inactive` : Đánh dấu user chưa active
- `lock_passwd` : không cho phép login bằng password
- `no-create-home` : không tạo thư mục home
- `no-log-init` : không tạo lastlog và faillog cho user
- `no-user-group` : không tạo group cho user
- `passwd` : password cho user (bắt buộc)
- `ssh-authorized-keys` : danh sách các key để add vào  user’s authkeys file
- `sudo` : Các rule để sử dụng sudo
- `system` : tạo system user không có thư mục home

Distro hỗ trợ: tất cả

Config keys:

``` sh
groups:
    - <group>: [<user>, <user>]
    - <group>

users:
    - default
    - name: <username>
      expiredate: <date>
      gecos: <comment>
      groups: <additional groups>
      homedir: <home directory>
      inactive: <true/false>
      lock_passwd: <true/false>
      no-create-home: <true/false>
      no-log-init: <true/false>
      no-user-group: <true/false>
      passwd: <password>
      primary-group: <primary group>
      selinux-user: <selinux username>
      shell: <shell path>
      snapuser: <email>
      ssh-authorized-keys:
          - <key>
          - <key>
      ssh-import-id: <id>
      sudo: <sudo config>
      system: <true/false>
      uid: <user id>
```

<a name="11"></a>
## 11. Write Files

Thêm nội dung vào file và có thể set thêm quyền.

Distro hỗ trợ: tất cả

Config keys:

``` sh
write_files:
    - encoding: b64
      content: CiMgVGhpcyBmaWxlIGNvbnRyb2xzIHRoZSBzdGF0ZSBvZiBTRUxpbnV4...
      owner: root:root
      path: /etc/sysconfig/selinux
      permissions: '0644'
    - content: |
        # My new /etc/sysconfig/samba file

        SMDBOPTIONS="-D"
      path: /etc/sysconfig/samba
    - content: !!binary |
        f0VMRgIBAQAAAAAAAAAAAAIAPgABAAAAwARAAAAAAABAAAAAAAAAAJAVAAAAAA
        AEAAHgAdAAYAAAAFAAAAQAAAAAAAAABAAEAAAAAAAEAAQAAAAAAAwAEAAAAAAA
        AAAAAAAAAwAAAAQAAAAAAgAAAAAAAAACQAAAAAAAAAJAAAAAAAAcAAAAAAAAAB
        ...
      path: /bin/arch
      permissions: '0555'
```

<a name="12"></a>
## 12. Yum Add Repo

Thêm cấu hình yum repository vào `/etc/yum.repos.d`

Distro hỗ trợ: fedora, rhel

Config keys:

``` sh
yum_repos:
    <repo-name>:
        baseurl: <repo url>
        name: <repo name>
        enabled: <true/false>
        # any repository configuration options (see man yum.conf)
```

<a name="13"></a>
## 13. Power State Change

Module này cho phép bạn shutdown/reboot máy ảo sau khi các module khác đã hoàn tất.

Distro hỗ trợ: tất cả

Config keys:

``` sh
power_state:
    delay: <now/'+minutes'>
    mode: <poweroff/halt/reboot>
    message: <shutdown message>
    timeout: <seconds>
    condition: <true/false/command>
```

**Link tham khảo:**

https://cloudinit.readthedocs.io/en/latest/topics/modules.html
