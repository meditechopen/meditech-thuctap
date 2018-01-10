# Tìm hiểu về cloud-init

## Mục lục

[1. Giới thiệu tổng quan về cloud-init](#1)

[2. Chức năng của cloud-init](#2)

[3. Giới thiệu về cloud-config](#3)

---------

<a name="1"></a>
## 1. Giới thiệu về cloud-init

Cloud-init là một công cụ được sử dụng để thực hiện các thiếp lập ban đầu đối với các máy ảo hóa và cloud. Dịch vụ này sẽ chạy trước quá trình boot, nó lấy dữ liệu từ bên ngoài và thực hiện một số tác động tới máy chủ.

Các tác động mà cloud-init thực hiện phụ thuộc vào loại format thông tin mà nó tìm kiếm được. Các format hỗ trợ:

- Shell scripts (bắt đầu với #!)
- Cloud config files (bắt đầu với #cloud-config)
- MIME multipart archive.
- Gzip Compressed Content
- Cloud Boothook

Một trong những định dạng thông dụng nhất dành cho các scripts đó là `cloud-config`.

`cloud-config` là các file script được thiết kế để chạy trong các tiến trình cloud-init. Nó được sử dụng cho các cài đặt cấu hình ban đầu trên server như networking, SSH keys, timezone, user data injection...

**File config của cloud-init**

File cấu hình của cloud-init `/etc/cloud/cloud.cfg` mặc định chứa 3 module là Cloud_init_modules, Cloud_config_modules, Cloud_final_module

``` sh
users:
 - default

disable_root: 1
ssh_pwauth:   0

locale_configfile: /etc/sysconfig/i18n
mount_default_fields: [~, ~, 'auto', 'defaults,nofail', '0', '2']
resize_rootfs_tmp: /dev
ssh_deletekeys:   0
ssh_genkeytypes:  ~
syslog_fix_perms: ~

cloud_init_modules:
 - migrator
 - bootcmd
 - write-files
 - growpart
 - resizefs
 - set_hostname
 - update_hostname
 - update_etc_hosts
 - rsyslog
 - users-groups
 - ssh

cloud_config_modules:
 - mounts
 - locale
 - set-passwords
 - yum-add-repo
 - package-update-upgrade-install
 - timezone
 - puppet
 - chef
 - salt-minion
 - mcollective
 - disable-ec2-metadata
 - runcmd

cloud_final_modules:
 - rightscale_userdata
 - scripts-per-once
 - scripts-per-boot
 - scripts-per-instance
 - scripts-user
 - ssh-authkey-fingerprints
 - keys-to-console
 - phone-home
 - final-message

system_info:
  default_user:
    name: centos
    lock_passwd: true
    gecos: Cloud User
    groups: [wheel, adm, systemd-journal]
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    shell: /bin/bash
  distro: rhel
  paths:
    cloud_dir: /var/lib/cloud
    templates_dir: /etc/cloud/templates
  ssh_svcname: sshd

# vim:syntax=yaml
```

Ở trong 3 modules này chứa Jobs mặc định của Cloud- init, ta có thể thay đổi các Jobs này, định nghĩa ra các Jobs mới. Bạn cần phải viết thêm một file code python thực hiện các thông số đầu vào mà người dùng đặt và đặt nó trong thư mục chứa datasource. Các đầu mục trong /etc/cloud/cloud.cfg sẽ được map với code python.


**Cấu trúc thư mục của cloud-init**

Thông thường thư mục chính của cloud-init được đặt tại `/var/lib/cloud`. Cloud-init sẽ lấy thông tin từ datasource và lưu tại đây.

Datasource là các nguồn dữ liệu cấu hình cho cloud-init thường được lấy từ user (userdata) hoặc tới từ stack tạo ra configuration drive (metadata). userdata thường chứa files, yaml, và shell scripts. Trong khi đó, metadata lại chứa server name, instance id, display name và một số thông tin khác.

Notes: Đối với OpenStack, url để lấy metadata của nó thường là `http://169.254.169.254`


``` sh
/var/lib/cloud/
  - data/
    - instance-id
    - previous-instance-id
    - datasource
    - previous-datasource
    - previous-hostname
  - handlers/
  - instance
  - instances/
    i-00000XYZ/
      - boot-finished
      - cloud-config.txt
      - datasource
      - handlers/
      - obj.pkl
      - scripts/
      - sem/
      - user-data.txt
      - user-data.txt.i
  - scripts/
    - per-boot/
    - per-instance/
    - per-once/
  - seed/
  - sem/
```

- `data/` : Chứa các thông tin liên quan tới instance ids, datasources và hostnames của instance. Chúng có thể được phân tích khi cần thiết để xác định các thông tin của lần boot trước đó.

- `handlers/` : Các part-handlers code được chứa tại đây.
- `instance` : Một symlink tới folder `instances` chỉ tới các instance đang active.
- `instances` : Tất cả các instances được tạo bởi image với instance identifier subdirectories (và corresponding data)
- `scripts/` : scripts được tải hoặc tạo bởi  part-handler
- `sem` : Cloud-init có một khái niệm về một semaphore module, về cơ bản bao gồm tên module và tần suất của nó. Các tệp này được sử dụng để đảm bảo module chỉ chạy mỗi lần 1 lần, một trường hợp, chạy liên tục.


<a name="2"></a>
## 2. Chức năng của cloud-init

- Đặt nơi chứa máy ảo
- Thiết lập hostname
- Generate SSH private keys
- Chèn SSH key vào file `.ssh/authorized_keys` để user đó có thể đăng nhập
- Cấu hình các mount points
- Cấu hình các network devices

Hiện tại cloud-init đang được sử dụng rất rộng rãi trên hầu hết các distro của linux và các công nghệ cloud như OpenStack, Amazon EC2, RHEV, và VMware.

<a name="3"></a>
## 3. Giới thiệu về cloud-config

Định dạng cloud-config thực thi các câu lệnh đã được declare cho rất nhiều các configuration items phổ biến, nó khiến việc thực hiện các task này trở nên dễ dàng hơn.

cloud-config sử dụng YAML data serialization format. Định dạng này được thiết kế để người sử dụng dễ hiểu và đơn giản hóa cho việc áp dụng vào các programs.

Một số rules khi viết file định dạng YAML:

- Các khoảng trống (space) cho biết cấu trúc và mối quan hệ giữa các items. Ví dụ các items là sub-items của item đầu tiên khi nó được viết thụt vào trong lề.
- Danh sách được xác định bằng các dấu gạch đầu dòng
- Các entries của mảng liên kết với nhau thể hiện qua dấu hai chấm (:), theo sau là khoảng trống (space) và các giá trị.
- Các khối văn bản với nhau được thụt vào lề dòng.

Hãy xem xét 1 ví dụ về cloud-config:

``` sh
#cloud-config
users:
  - name: demo
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDf0q4PyG0doiBQYV7OlOxbRjle026hJPBWD+eKHWuVXIpAiQlSElEBqQn0pOqNJZ3IBCvSLnrdZTUph4czNC4885AArS9NkyM7lK27Oo8RV888jWc8hsx4CD2uNfkuHL+NI5xPB/QT3Um2Zi7GRkIwIgNPN5uqUtXvjgA+i1CS0Ku4ld8vndXvr504jV9BMQoZrXEST3YlriOb8Wf7hYqphVMpF3b+8df96Pxsj0+iZqayS9wFcL8ITPApHi0yVwS8TjxEtI3FDpCbf7Y/DmTGOv49+AWBkFhS2ZwwGTX65L61PDlTSAzL+rPFmHaQBHnsli8U9N6E4XHDEOjbSMRX user@example.com
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcthLR0qW6y1eWtlmgUE/DveL4XCaqK6PQlWzi445v6vgh7emU4R5DmAsz+plWooJL40dDLCwBt9kEcO/vYzKY9DdHnX8dveMTJNU/OJAaoB1fV6ePvTOdQ6F3SlF2uq77xYTOqBiWjqF+KMDeB+dQ+eGyhuI/z/aROFP6pdkRyEikO9YkVMPyomHKFob+ZKPI4t7TwUi7x1rZB1GsKgRoFkkYu7gvGak3jEWazsZEeRxCgHgAV7TDm05VAWCrnX/+RzsQ/1DecwSzsP06DGFWZYjxzthhGTvH/W5+KFyMvyA+tZV4i1XM+CIv/Ma/xahwqzQkIaKUwsldPPu00jRN user@desktop
runcmd:
  - touch /test.txt
```

**Một số lưu ý quan trọng:**

- Mỗi một file cloud-config được bắt đầu bằng `#cloud-config` đứng một mình ở dòng đầu tiên. Đây là dấu hiệu để cloud init biết được đó là file cloud-config.
- Ví dụ trên có 2 câu lệnh "top-level" đó là `users` và `runcmd` . Đây đều được coi là keys và nó được theo sau bởi một loạt các dòng lệnh thụt lề dòng.
- Đối với phần `user`, giá trị là 1 list item. Với chỉ 1 dấu gạch ngang (-), ta có thể biết được ở đây chỉ thực hiện các thiết lập cho 1 user.


**Tham khảo**

https://cloudinit.readthedocs.io/en/latest/

https://www.digitalocean.com/community/tutorials/an-introduction-to-cloud-config-scripting

https://people.redhat.com/mskinner/rhug/q3.2014/cloud-init.pdf

https://github.com/vdcit/Cloud-Init
