# Các câu lệnh thường dùng trong Keystone

## 1. Lấy Token

Để làm việc với keystone hay bất cứ một service nào khác thì bạn cần phải khai báo thông tin credential

``` sh
export OS_IDENTITY_API_VERSION=3
export OS_AUTH_URL=http://controller:5000/v3
export OS_USERNAME=admin
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PASSWORD=Welcome123
export OS_PROJECT_DOMAIN_NAME=Default
```

- Để lấy token
``` sh
[root@controller ~]# openstack token issue
+------------+----------------------------------+
| Field      | Value                            |
+------------+----------------------------------+
| expires    | 2017-06-07T09:34:30.284479Z      |
| id         | 5548f103dc474b88903fcd67ddc4d4c0 |
| project_id | b47e8a9d5d88439dadc4f849c0424e8c |
| user_id    | cd171df00daf44208ba66c8fab9595b9 |
+------------+----------------------------------+
```

## 2. Các câu lệnh làm việc với users, projects, groups, roles, domains

- Liệt kê danh sách các users, projects, groups, roles, domains

``` sh
openstack user list
openstack project list
openstack group list
openstack role list
openstack domain list
```

- Tạo mới domain

`openstack domain create <tên domain>`

- Tạo mới project trong domain

`openstack project create <tên-project> --domain <tên-domain> --description "<miêu tả về doamin>"`

- Tạo mới user với domain

``` sh
openstack user create <tên-user> [--email <email(optional)>] \
>  --domain <tên domain> --description "<mô tả về domain>" \
>  --password <password>
```

- Xem user đang có những role gì

`openstack role list --user <tên user> --project <tên project>`

- Gán role cho user

`openstack role add --project <tên project> --project-domain <tên domain> --user <tên user> --user-domain <tên domain> <tên role>`

Xem thêm về các câu lệnh [tại đây](https://docs.openstack.org/python-openstackclient/latest/cli/command-list.html) 
