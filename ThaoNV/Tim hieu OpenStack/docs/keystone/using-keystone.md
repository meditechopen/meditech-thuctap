# Sử dụng keystone

## Mục lục

[I. Sử dụng command line để thực hiện những tác vụ quản trị cơ bản trong Keystone](#command)

- [1. Lấy Token](#token)
- [2. Liệt kê danh sách users](#user)
- [3. Liệt kê danh sách projects](#project)
- [4. Liệt kê danh sách groups](#group)
- [5. Liệt kê danh sách roles](#role)
- [6. Liệt kê danh sách domains](#domain-list)
- [7. Tạo domains](#domain-create)
- [8. Tạo project với domain](#create-project)
- [9. Tạo user với domain](#create-user)
- [10. Gán role cho user vào project](#add-user)
- [11. Xác thực user mới](#auth-user)

[II. Sử dụng dashboard để thực hiện những tác vụ quản trị cơ bản trong Keystone](#dashboard)

- [1. Những tác vụ có thể thực hiện được của Keystone thông qua dashboard](#task)
- [2. Truy cập trên dashboard](#access)
- [3. Liệt kê, thiết lập, xóa, tạo, xem project](#project-dashboard)
- [4. Liệt kê, thiết lập, xóa, tạo, xem user](#user-dashboard)

----------

### <a name="command"> I. Sử dụng command line để thực hiện những tác vụ quản trị cơ bản trong Keystone </a>

Tại phần này chúng ta sẽ sử dụng OpenStackClient để thực hiện những tác vụ quản trị cơ bản với Keystone như xác thực, liệt kê danh sách, tạo mới users, domains, projects,...

Để bắt đầu, ta cần phải thiết lập 1 số biến môi trường (environment variables) để không phải lặp lại nhiều lần trong quá trình xác thực.

Chạy những câu lệnh sau:

``` sh
export OS_IDENTITY_API_VERSION=3
export OS_AUTH_URL=http://controller:5000/v3
export OS_USERNAME=admin
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PASSWORD=Welcome123
export OS_PROJECT_DOMAIN_NAME=Default
```

Lưu ý: Hầu hết những thông tin phía trên nên trùng với mô hình của riêng bạn ngoại trừ hostname hoặc địa chỉ ip của máy ảo.

Để kiểm tra xem biết đã được set hay chưa, chạy lệnh sau:

``` sh
$ env | grep OS_
OS_IDENTITY_API_VERSION=3
OS_AUTH_URL=http://controller:5000/v3
OS_USERNAME=admin
OS_PROJECT_NAME=admin
OS_USER_DOMAIN_NAME=Default
OS_PASSWORD=Welcome123
OS_PROJECT_DOMAIN_NAME=Default
```

#### <a name="token"> 1. Lấy Token </a>

**Dùng OpenStackClient**

Vì đã thực thi việc xác thực và trao quyền bằng các biến môi trường, bạn chỉ cần chạy câu lệnh sau để lấy token:

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

**Dùng cURL**

Khi dùng cURL, phần payload phải chứa thông tin về user và project.

``` sh
$ curl -i -H "Content-Type: application/json" -d '
{ "auth": {
    "identity": {
        "methods": ["password"],
        "password": {
            "user": {
              "name": "admin",
              "domain": { "name": "Default" },
              "password": "Welcome123"
            }
          }
        },
        "scope": {
          "project": {
            "name": "admin",
            "domain": { "name": "Default" }
          }
        }
      }
}' http://localhost:5000/v3/auth/tokens
```

- Phần response:

```sh
HTTP/1.1 201 Created
Date: Wed, 07 Jun 2017 08:38:01 GMT
Server: Apache/2.4.6 (CentOS)
X-Subject-Token: a012204ccd6847b69bc97dca5ce5f041
Vary: X-Auth-Token
x-openstack-request-id: req-e301a2f1-9193-40fc-acf7-00a0e58c8a54
Content-Length: 7780
Connection: close
Content-Type: application/json

{"token": {"methods": ["password"], "roles": [{"id": "2c43533ecb594bde953f7ad2d7ee4a31", "name": "admin"}], "expires_at": "2017-06-07T09:38:01.780859Z", "project": {"domain": {"id": "default", "name": "Default"}, "id": "b47e8a9d5d88439dadc4f849c0424e8c", "name": "admin"}, "catalog": [{"endpoints": [{"region_id": "RegionOne", "url": "http://192.168.100.171:35357/v2.0", "region": "RegionOne", "interface": "admin", "id": "6f325fa91ef14b25baf9251bea74e121"}, {"region_id": "RegionOne", "url": "http://192.168.100.171:5000/v2.0", "region": "RegionOne"
```

Phần response phía trên đã được rút ngắn lại cho dễ đọc bởi nó chứa catalog với tất cả các endpoints nên khá dài.

Token nằm ở phía sau `X-Subject-Token`. Hãy set nó vào biến để không phải khai báo ở những thao tác tiếp theo:

`$ OS_TOKEN=a012204ccd6847b69bc97dca5ce5f041`

#### <a name="user"> 2. Liệt kê danh sách users </a>

**Sử dụng OpenStackClient**

Sử dụng câu lệnh sau để xem danh sách users:

``` sh
[root@controller ~]# openstack user list
+----------------------------------+------------+
| ID                               | Name       |
+----------------------------------+------------+
| 35274f35cbaf4aec89563a6f960a19ad | ceilometer |
| 603af7d05553404e8860ea175cf84d85 | swift      |
| 9620231760784d918f235f9580d21661 | cinder     |
| ab33c6e82c78416892838b068742ef84 | glance     |
| c172160011214fbfbb31f260df0729da | aodh       |
| c5329ddf45bd4cb294ebef0f0bd13d4b | gnocchi    |
| cd171df00daf44208ba66c8fab9595b9 | admin      |
| ce6f7040162148eeb070501f3bbb7e1f | nova       |
| f1e9ad0c84d3424da20b42bfb7914b9a | neutron    |
+----------------------------------+------------+
```

**Sử dụng cURL**

Để sử dụng cURL, bạn phải khai báo token và địa chỉ API tương ứng

``` sh
curl -s -H "X-Auth-Token: $OS_TOKEN" \
 http://localhost:5000/v3/users | python -mjson.tool
```

Kết quả:

``` sh
{
    "links": {
        "next": null,
        "previous": null,
        "self": "http://localhost:5000/v3/users"
    },
    "users": [
        {
            "domain_id": "default",
            "email": "ceilometer@localhost",
            "enabled": true,
            "id": "35274f35cbaf4aec89563a6f960a19ad",
            "links": {
                "self": "http://localhost:5000/v3/users/35274f35cbaf4aec89563a6f960a19ad"
            },
            "name": "ceilometer"
        },
    ]
}
```

Lưu ý: Kết quả đã được rút ngắn.

#### <a name="project"> 3. Liệt kê danh sách projects </a>

**Sử dụng OpenStackClient**

Sử dụng câu lệnh sau:

```sh
[root@controller ~]# openstack project list
+----------------------------------+----------+
| ID                               | Name     |
+----------------------------------+----------+
| 83e57578f4fc40489fcafd56d5c58569 | services |
| b47e8a9d5d88439dadc4f849c0424e8c | admin    |
+----------------------------------+----------+
```

**Sử dụng cURL**

Dùng cURL với endpoints của projects

```sh
curl -s -H "X-Auth-Token: $OS_TOKEN" \
 http://localhost:5000/v3/projects | python -mjson.tool
```

Kết quả:

``` sh
{
    "links": {
        "next": null,
        "previous": null,
        "self": "http://localhost:5000/v3/projects"
    },
    "projects": [
        {
            "description": "Tenant for the openstack services",
            "domain_id": "default",
            "enabled": true,
            "id": "83e57578f4fc40489fcafd56d5c58569",
            "is_domain": false,
            "links": {
                "self": "http://localhost:5000/v3/projects/83e57578f4fc40489fcafd56d5c58569"
            },
            "name": "services",
            "parent_id": "default"
        },
        {
            "description": "admin tenant",
            "domain_id": "default",
            "enabled": true,
            "id": "b47e8a9d5d88439dadc4f849c0424e8c",
            "is_domain": false,
            "links": {
                "self": "http://localhost:5000/v3/projects/b47e8a9d5d88439dadc4f849c0424e8c"
            },
            "name": "admin",
            "parent_id": "default"
        }
    ]
}
```

#### <a name="group"> 4. Liệt kê danh sách groups </a>

**Sử dụng OpenStackClient**

Dùng câu lệnh sau:

``` sh
[root@controller ~]# openstack group list
```

Lưu ý: Nếu không có group thì sẽ không có giá trị nào trả về

**Sử dụng cURL**

``` sh
curl -s -H "X-Auth-Token: $OS_TOKEN" \
 http://localhost:5000/v3/groups | python -mjson.tool
```

Kết quả:

``` sh
{
    "groups": [],
    "links": {
        "next": null,
        "previous": null,
        "self": "http://localhost:5000/v3/groups"
    }
}
```

#### <a name="role"> 5. Liệt kê danh sách roles </a>

**Sử dụng OpenStackClient**

Sử dụng câu lệnh sau:

``` sh
[root@controller ~]# openstack role list
+----------------------------------+---------------+
| ID                               | Name          |
+----------------------------------+---------------+
| 1b077579210f4062b4e73fb4debfc98e | ResellerAdmin |
| 2c43533ecb594bde953f7ad2d7ee4a31 | admin         |
| 9fe2ff9ee4384b1894a90878d3e92bab | _member_      |
| ce4fa09b579e4bcaae2129c54f42481a | SwiftOperator |
+----------------------------------+---------------+
```

**Sử dụng cURL**

``` sh
curl -s -H "X-Auth-Token: $OS_TOKEN" \
 http://localhost:5000/v3/roles | python -mjson.tool
```

Kết quả:

``` sh
{
    "links": {
        "next": null,
        "previous": null,
        "self": "http://localhost:5000/v3/roles"
    },
    "roles": [
        {
            "domain_id": null,
            "id": "1b077579210f4062b4e73fb4debfc98e",
            "links": {
                "self": "http://localhost:5000/v3/roles/1b077579210f4062b4e73fb4debfc98e"
            },
            "name": "ResellerAdmin"
        },
        {
            "domain_id": null,
            "id": "2c43533ecb594bde953f7ad2d7ee4a31",
            "links": {
                "self": "http://localhost:5000/v3/roles/2c43533ecb594bde953f7ad2d7ee4a31"
            },
            "name": "admin"
        },
        {
            "domain_id": null,
            "id": "9fe2ff9ee4384b1894a90878d3e92bab",
            "links": {
                "self": "http://localhost:5000/v3/roles/9fe2ff9ee4384b1894a90878d3e92bab"
            },
            "name": "_member_"
        },
        {
            "domain_id": null,
            "id": "ce4fa09b579e4bcaae2129c54f42481a",
            "links": {
                "self": "http://localhost:5000/v3/roles/ce4fa09b579e4bcaae2129c54f42481a"
            },
            "name": "SwiftOperator"
        }
    ]
}
```

#### <a name="domain-list"> 6. Liệt kê danh sách domains </a>

**Sử dụng OpenStackClient**

Sử dụng câu lệnh sau:

``` sh
[root@controller ~]# openstack domain list
+---------+---------+---------+--------------------+
| ID      | Name    | Enabled | Description        |
+---------+---------+---------+--------------------+
| default | Default | True    | The default domain |
+---------+---------+---------+--------------------+
```

**Sử dụng cURL**

``` sh
curl -s -H "X-Auth-Token: $OS_TOKEN" \
 http://localhost:5000/v3/domains | python -mjson.tool
```

Kết quả:

``` sh
{
    "domains": [
        {
            "description": "The default domain",
            "enabled": true,
            "id": "default",
            "links": {
                "self": "http://localhost:5000/v3/domains/default"
            },
            "name": "Default"
        }
    ],
    "links": {
        "next": null,
        "previous": null,
        "self": "http://localhost:5000/v3/domains"
    }
}
```

#### <a name="domain-create"> 7. Tạo domains </a>

**Sử dụng OpenStackClient**

Sử dụng câu lệnh sau để tạo domain `acme`

``` sh
[root@controller ~]#  openstack domain create acme
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description |                                  |
| enabled     | True                             |
| id          | 5af80e340f104b7dace206773913eae7 |
| name        | acme                             |
+-------------+----------------------------------+
```

**Sử dụng cURL**

Chúng ta sử dụng POST request với một chút thông tin ở phần payload (tên domain) và mặc định nó sẽ được bật sau khi tạo xong

``` sh
[root@controller ~]# curl -s -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json" -d '{ "domain": { "name": "acme2"}}' http://localhost:5000/v3/domains | python -mjson.tool
{
    "domain": {
        "description": "",
        "enabled": true,
        "id": "5212ad8e677e4cdc96217661da49d1fa",
        "links": {
            "self": "http://localhost:5000/v3/domains/5212ad8e677e4cdc96217661da49d1fa"
        },
        "name": "acme2"
    }
}
```

#### <a name="create-project"> 8. Tạo project với domain </a>

**Sử dụng OpenStackClient**

Ta cần thêm một vài mô tả để có thể tạo project với domain

``` sh
[root@controller ~]# openstack project create thaonvs_project --domain acme --description "thaonvs project"
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | thaonvs project                  |
| domain_id   | 5af80e340f104b7dace206773913eae7 |
| enabled     | True                             |
| id          | 0399e0c4aaef4c04b405af67301838f8 |
| is_domain   | False                            |
| name        | thaonvs_project                  |
| parent_id   | 5af80e340f104b7dace206773913eae7 |
+-------------+----------------------------------+
```

**Sử dụng cURL**

Cùng với tên của project, phần payload còn cần phải có domain ID mà ta có ở phần tạo domain trước đó:

``` sh
curl -s -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json" -d '{ "project": { "name": "tims_project 2", "domain_id": "5af80e340f104b7dace206773913eae7", "description": "tims dev project 2"}}' http://localhost:5000/v3/projects | python -mjson.tool

{
    "project": {
        "description": "tims dev project 2",
        "domain_id": "5af80e340f104b7dace206773913eae7",
        "enabled": true,
        "id": "d16e3752f21e4386a5d17ede31bd2bb2",
        "is_domain": false,
        "links": {
            "self": "http://localhost:5000/v3/projects/d16e3752f21e4386a5d17ede31bd2bb2"
        },
        "name": "tims_project 2",
        "parent_id": "5af80e340f104b7dace206773913eae7"
    }
}
```

#### <a name="create-user"> 9. Tạo user với domain </a>

**Sử dụng OpenStackClient**

Ta cần cung cấp thông tin của domain. Password và email cho user là optional.

``` sh
[root@controller ~]# openstack user create thaonv --email thaonvhanu@gmail.com \
>  --domain acme --description "thaonv openstack user account" \
>  --password hihihoho
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | thaonv openstack user account    |
| domain_id   | 5af80e340f104b7dace206773913eae7 |
| email       | thaonvhanu@gmail.com             |
| enabled     | True                             |
| id          | 1ef31ae8d91a4c6fb63b623376f4fee2 |
| name        | thaonv                           |
+-------------+----------------------------------+
```

**Sử dụng cURL**

Tương tự như những trường hợp trước, ta cũng cần khai báo đúng cấu trúc trong payload:

``` sh
[root@controller ~]#  curl -s -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json" -d '{ "user": { "name": "thaonv", "password": "hihihoho", "email": "thaonvhanu@gmail.com", "domain_id": "5212ad8e677e4cdc96217661da49d1fa", "description": "thaonvs openstack user account"}}' http://localhost:5000/v3/users | python -mjson.tool
 {
    "user": {
        "description": "thaonvs openstack user account",
        "domain_id": "5212ad8e677e4cdc96217661da49d1fa",
        "email": "thaonvhanu@gmail.com",
        "enabled": true,
        "id": "2bee4fc89dd04c49aaf54d35253d79a6",
        "links": {
            "self": "http://localhost:5000/v3/users/2bee4fc89dd04c49aaf54d35253d79a6"
        },
        "name": "thaonv"
    }
}
```

#### <a name="add-user"> 10. Gán role cho user vào project

**Sử dụng OpenStackClient**

Để gán role cho user mới, ta có thể sử dụng command line. Bạn cần khai báo đúng project, user và domain, nếu không OpenStackClient sẽ dùng domain mặc định.

``` sh
openstack role add admin --project thaonvs_project --project-domain acme --user thaonv --user-domain acme
```

**Sử dụng cURL**

Khác với những command trước, nó sử dụng PUT thay vì POST và chỉ dùng id của user, project và role.

``` sh
curl -s -X PUT -H "X-Auth-Token: $OS_TOKEN" \
http://localhost:5000/v3/projects/0399e0c4aaef4c04b405af67301838f8/users/1ef31ae8d91a4c6fb63b623376f4fee2/roles/2c43533ecb594bde953f7ad2d7ee4a31
```

#### <a name="auth-user"> 11. Xác thực user mới

**Sử dụng OpenStackClient**

Để xác thực user mới, tốt nhất ta nên tạo mới 1 session và thay đổi thiết lập biến môi trường tùy thuộc theo user mới:

``` sh
export OS_PASSWORD=hihihoho
export OS_IDENTITY_API_VERSION=3
export OS_AUTH_URL=http://controller:5000/v3
export OS_USERNAME=thaonv
export OS_PROJECT_NAME=thaonvs_project
export OS_USER_DOMAIN_NAME=acme
export OS_PROJECT_DOMAIN_NAME=acme
```

Sau khi thiết lập ta có thể lấy token và dĩ nhiên user đã được xác thực:

``` sh
[root@controller ~]# openstack token issue
+------------+----------------------------------+
| Field      | Value                            |
+------------+----------------------------------+
| expires    | 2017-06-07T10:47:09.198596Z      |
| id         | 8f0e3c1bd8a44abb96b64a9fd4ca0366 |
| project_id | 0399e0c4aaef4c04b405af67301838f8 |
| user_id    | 1ef31ae8d91a4c6fb63b623376f4fee2 |
+------------+----------------------------------+
```

**Sử dụng cURL**

Giống với phần trước đó khi chúng ta lấy token cho admin tuy nhiên có một vài giá trị cần thay đổi cho phù hợp với user mới.

``` sh
curl -i -H "Content-Type: application/json" -d ' { "auth": {
  "identity": {
    "methods": ["password"],
    "password": {
      "user": {
        "name": "thaonv",
        "domain": { "name": "acme" },
        "password": "hihihoho"
      }
    }
  },
  "scope": {
    "project": {
      "name": "thaonvs_project",
      "domain": { "name": "acme" }
      }
    }
  }
}' http://localhost:5000/v3/auth/tokens
```

Kết quả:

``` sh
HTTP/1.1 201 Created
Date: Wed, 07 Jun 2017 09:50:16 GMT
Server: Apache/2.4.6 (CentOS)
X-Subject-Token: 4c440c3b77574d03a00dbf3734765609
Vary: X-Auth-Token
x-openstack-request-id: req-db37468b-114d-4aaf-84bc-45152cd55bdb
Content-Length: 7835
Connection: close
Content-Type: application/json
```

### <a name="dashboard"> II. Sử dụng dashboard để thực hiện những tác vụ quản trị cơ bản trong Keystone

#### <a name="task"> 1. Những tác vụ có thể thực hiện được của Keystone thông qua dashboard

Tùy thuộc vào phiên bản được sử dụng trong file config của Horizon. Nếu là Identity API v2 thì chỉ có phần quản lí cho User và Project. Nếu là v3 thì sẽ có thêm Group, Domain, và Role.

#### <a name="access"> 2. Truy cập trên dashboard

Phần quản trị Identity nằm ở menu bên trái màn hình:

<img src="http://i.imgur.com/UPUzn3s.png">

#### <a name="project-dashboard"> 3. Liệt kê, thiết lập, xóa, tạo, xem project

<img src="http://i.imgur.com/Uve804Z.png">

#### <a name="user-dashboard"> 4. Liệt kê, thiết lập, xóa, tạo, xem user

<img src="http://i.imgur.com/ec00oJ0.png">
