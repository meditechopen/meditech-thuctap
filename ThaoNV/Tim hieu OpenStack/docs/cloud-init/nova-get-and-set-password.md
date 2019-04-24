# OpenStack nova get-password, set-password and post encrypted password to metadata service

## Mục lục

1. nova get-password

2. nova set-password

-----------

## 1. nova get-password

Đây là câu lệnh của nova client dùng để lấy thông tin password của máy ảo dưới dạng mã hóa. metadata service trong OpenStack cho phép máy ảo post password của mình nên endpoint để người dùng có thể lấy nó thông qua câu lệnh nova get-password hoặc trên dashboard (tính năng ko có trong mặc định). Đây là một dạng mật khẩu đã được mã hóa với public key và đương nhiên không phải là root password.

Thông thường đối với các image Windows đã cài cloud init, khi máy ảo boot lên mà không được truyền password trông qua command inject password của nova thì nó sẽ tự gen ra một đoạn password mà nếu có ssh public key, nó sẽ mã hóa và post nó lên metadata service. Còn đối với các máy ảo linux, ta cần chèn một đoạn script vào image để chạy ở lần boot đầu tiên để post thông tin password lên metadata bởi câu lệnh nova-get password chỉ hoạt động nếu password đã được post lên metadata service.

```
[root@controller ~]# nova help get-password
usage: nova get-password <server> [<private-key>]

Get the admin password for a server.

Positional arguments:
  <server>       Name or ID of server.
  <private-key>  Private key (used locally to decrypt password) (Optional).
                 When specified, the command displays the clear (decrypted) VM
                 password. When not specified, the ciphered VM password is
                 displayed.
```

Sử dụng câu lệnh đối với máy ảo đã post encrypted password:

```
[root@controller ~(keystone_admin)]# nova get-password thaonv
5PqlfiZpzz6v1uMlUL93NsA57b+tYX9EJWhvQWitNTDsyvyxJx6MQn+r7MZVtytRlqWvh06nAy2Fi0Kop7BpMyKIdjbyxsA8Kx6pH53U0DJWfm8+Y33i1C9LqMpKBAxv8w8z3zauPU211+AKE7IFsrw+gZNmhi3rlLnkx9KRDsU84kp2xQT/Rh4KYn5cmDwJUcf6yMZNOj2WKzXRSyN9m3nxvBdnZFZzEZYMxb0ili0F6uLg/mSarlI9h6slx0Oyo+LjYN38MBny6X+VY0uD3LgeKMwwAN56sDBFIXiktOWVXbNbfMCNmE9EHfNF7oVvoy86qoAvXw/ZKcU2vUAVnA==
```

Để decrypt password này, thêm vào file private key

```
[root@controller ~(keystone_admin)]# nova get-password thaonv /root/cloud.key
MsoV8vi8ccIt7vmrwOju
```

Hoặc bạn cũng có thể decrypt nó bằng cách sử dụng openssl command line tools

```
echo " 5PqlfiZpzz6v1uMlUL93NsA57b+tYX9EJWhvQWitNTDsyvyxJx6MQn+r7MZVtytRlqWvh06nAy2Fi0Kop7BpMyKIdjbyxsA8Kx6pH53U0DJWfm8+Y33i1C9LqMpKBAxv8w8z3zauPU211+AKE7IFsrw+gZNmhi3rlLnkx9KRDsU84kp2xQT/Rh4KYn5cmDwJUcf6yMZNOj2WKzXRSyN9m3nxvBdnZFZzEZYMxb0ili0F6uLg/mSarlI9h6slx0Oyo+LjYN38MBny6X+VY0uD3LgeKMwwAN56sDBFIXiktOWVXbNbfMCNmE9EHfNF7oVvoy86qoAvXw/ZKcU2vUAVnA==" \
| openssl base64 -d \
| openssl rsautl -decrypt -inkey /root/cloud.key -keyform PEM
```

- Trên dashboard, bạn cần cấu hình thêm trong file `/etc/openstack-dashboard/local_settings`

`OPENSTACK_ENABLE_PASSWORD_RETRIEVE = True`

và option trong file `/etc/nova/nova.conf`

`enable_instance_password=true`

- Để lấy password, bạn cần boot vm mới public key. Tiến hành lấy password trên dashboard

<img src="https://i.imgur.com/SoQGklr.png">
<img src="https://i.imgur.com/0N0PNGk.png">

Sau đó paste hoặc load private key vào và chọn "Decrypt Password"

<img src="https://i.imgur.com/1dcomZ4.png">

Đây là password của bạn!

<img src="https://i.imgur.com/tCnJet9.png">

**Lưu ý:**

- Đối với các image Windows thì đây chính là password của tài khoản `Admin`. Dùng tài khoản này để đăng nhập.

- metadata service cho phép post password ở cả dạng chưa mã hóa và bất cứ web application nào cũng có thể request API url để lấy dữ liệu thông qua địa chỉ này.

`curl http://169.254.169.254/openstack/latest/password`

**Đối với các image linux, ta có thể chạy script ở lần đầu boot để post password. Tuy nhiên ta có thể dùng cloud-init để chèn script vào hoặc cài sẵn qemu-guest-agent để reset password. Phần này sẽ được trình bày ở dưới đây :)**

Btw, đây là script mà các bạn có thể dùng để post password lên metadata service đối với máy ảo ubuntu. Password được gen là của user `ubuntu`.

```
#!/usr/bin/env bash
SSH_KEYFILE=`tempfile`
SSL_KEYFILE=`tempfile`
if ! curl -s -f http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key > $SSH_KEYFILE; then
  echo  "Failed to get key"
fi
cat $SSH_KEYFILE
PASSWORD=`openssl rand -base64 48 | tr -d '/+' | cut -c1-16`
sudo usermod ubuntu -p `openssl passwd -1 $PASSWORD`

ssh-keygen -e -f $SSH_KEYFILE -m PKCS8 > $SSL_KEYFILE
ENCRYPTED=`echo "$PASSWORD" | openssl rsautl -encrypt -pubin -inkey $SSL_KEYFILE -keyform PEM | openssl base64 -e -A`
echo $'\n'"ENCRYPTED_PASSWORD:$ENCRYPTED" | sudo tee /dev/console
curl -X POST http://169.254.169.254/openstack/2013-04-04/password -d $ENCRYPTED || true
rm $SSH_KEYFILE $SSL_KEYFILE
```


## 2. nova set-password

Câu lệnh này chỉ hoạt động nếu image chứa máy ảo có cài sẵn [qemu-guest-agent](https://wiki.qemu.org/Features/GuestAgent).

Mặc định thì cầu lệnh này sẽ không có output.

```
[root@controller ~(keystone_admin)]# nova set-password minhcave
New password:
Again:
```

Đối với các máy ảo linux, câu lệnh này sẽ reset root password của chúng.

Tham khảo một số hướng dẫn đóng image với qemu-guest-agent tại link sau:

https://github.com/thaonguyenvan/meditech-thuctap/tree/master/ThaoNV/Tim%20hieu%20OpenStack/docs/image-create
