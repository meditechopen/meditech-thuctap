# Tìm hiểu các thao tác sử dụng Glance

## Mục lục

[1. Sử dụng glance command line](#glance)

- [1.1 Hiển thị danh sách image](#list)

- [1.2 Show image](#show)

- [1.3 Tạo image](#create)

- [1.4 Upload image](#upload)

- [1.5 Xóa image](#delete)

- [1.6 Thay đổi trạng thái máy ảo](#update)

[2. Sử dụng OpenStack client](#client)

[3. Sử dụng cURL](#curl)

-----------

<a name ="glance"></a>
## 1. Sử dụng glance command line

<a name="list"></a>
### 1.1 Hiển thị danh sách image

Sử dụng câu lệnh sau để lấy danh sách các image được phép truy cập

`glance image-list`

``` sh
[root@controller ~(keystone_admin)]# glance image-list
+--------------------------------------+--------+
| ID                                   | Name   |
+--------------------------------------+--------+
| 8867a307-8e2a-4c17-ac07-3bb126681ff5 | cent6  |
| d5b42a15-54ca-41fa-8e84-29ff537a3567 | cirros |
+--------------------------------------+--------+
```

<a name="show"></a>
### 1.2 Show image

Để hiển thị thông tin chi tiết 1 image, sử dụng câu lệnh

`glance image-show image_id`

``` sh
[root@controller ~(keystone_admin)]# glance image-show 8867a307-8e2a-4c17-ac07-3bb126681ff5
+------------------+--------------------------------------+
| Property         | Value                                |
+------------------+--------------------------------------+
| checksum         | af3cdec809e0c9376023dec7716e6102     |
| container_format | bare                                 |
| created_at       | 2017-06-05T01:36:42Z                 |
| description      |                                      |
| disk_format      | qcow2                                |
| id               | 8867a307-8e2a-4c17-ac07-3bb126681ff5 |
| min_disk         | 0                                    |
| min_ram          | 0                                    |
| name             | cent6                                |
| owner            | b47e8a9d5d88439dadc4f849c0424e8c     |
| protected        | False                                |
| size             | 305001984                            |
| status           | active                               |
| tags             | []                                   |
| updated_at       | 2017-06-05T01:36:44Z                 |
| virtual_size     | None                                 |
| visibility       | public                               |
+------------------+--------------------------------------+
```

<a name="create"></a>
### 1.3 Tạo image

Để upload image lên thư mục của glance từ file image có sẵn, sử dụng lệnh `glance image-create`

``` sh
[root@controller ~(keystone_admin)]# glance image-create --file /tmp/cirros-0.3.4-x86_64-disk.img --disk-format qcow2 --container-format bare --public cirros-0.3.4-x86_64
+------------------+------------------------------------------------------+
| Field            | Value                                                |
+------------------+------------------------------------------------------+
| checksum         | ee1eca47dc88f4879d8a229cc70a07c6                     |
| container_format | bare                                                 |
| created_at       | 2017-06-20T09:38:54Z                                 |
| disk_format      | qcow2                                                |
| file             | /v2/images/9a096044-36b8-426b-929e-8ebed525348d/file |
| id               | 9a096044-36b8-426b-929e-8ebed525348d                 |
| min_disk         | 0                                                    |
| min_ram          | 0                                                    |
| name             | cirros-0.3.4-x86_64                                  |
| owner            | b47e8a9d5d88439dadc4f849c0424e8c                     |
| protected        | False                                                |
| schema           | /v2/schemas/image                                    |
| size             | 13287936                                             |
| status           | active                                               |
| tags             |                                                      |
| updated_at       | 2017-06-20T09:38:54Z                                 |
| virtual_size     | None                                                 |
| visibility       | public                                               |
+------------------+------------------------------------------------------+
```

<a name="upload"></a>
### 1.4 Upload image

Trong trường hợp ta tạo ra một image mới và rỗng, ta cần upload dữ liệu cho nó, sử dụng câu lệnh `glance image-upload --file file_name image_id`

``` sh
[root@controller ~(keystone_admin)]# glance image-create --name cirros --container bare --disk-format qcow2
+------------------+--------------------------------------+
| Property         | Value                                |
+------------------+--------------------------------------+
| checksum         | None                                 |
| container_format | bare                                 |
| created_at       | 2017-06-20T09:46:06Z                 |
| disk_format      | qcow2                                |
| id               | 47f7bcb2-55e0-490e-920d-48f09d29e4e7 |
| min_disk         | 0                                    |
| min_ram          | 0                                    |
| name             | cirros                               |
| owner            | b47e8a9d5d88439dadc4f849c0424e8c     |
| protected        | False                                |
| size             | None                                 |
| status           | queued                               |
| tags             | []                                   |
| updated_at       | 2017-06-20T09:46:06Z                 |
| virtual_size     | None                                 |
| visibility       | private                              |
+------------------+--------------------------------------+
[root@controller ~(keystone_admin)]# glance image-upload --file /tmp/cirros-0.3.4-x86_64-disk.img 47f7bcb2-55e0-490e-920d-48f09d29e4e7
```

<a name="delete"></a>
### 1.5 Xóa image

Để xóa image, ta sử dụng câu lệnh `glance image-delete image_id`

``` sh
[root@controller ~(keystone_admin)]# glance image-list
+--------------------------------------+--------+
| ID                                   | Name   |
+--------------------------------------+--------+
| 8867a307-8e2a-4c17-ac07-3bb126681ff5 | cent6  |
| 47f7bcb2-55e0-490e-920d-48f09d29e4e7 | cirros |
+--------------------------------------+--------+
[root@controller ~(keystone_admin)]# glance image-delete 47f7bcb2-55e0-490e-920d-48f09d29e4e7
[root@controller ~(keystone_admin)]# glance image-list
+--------------------------------------+-------+
| ID                                   | Name  |
+--------------------------------------+-------+
| 8867a307-8e2a-4c17-ac07-3bb126681ff5 | cent6 |
+--------------------------------------+-------+
```

<a name="update"></a>
### 1.6 Thay đổi trạng thái máy ảo

Như ta đã biết một image upload thành công sẽ ở trạng thái active, người dùng có thể đưa nó về trạng thái deactivate cũng như thay đổi qua lại giữa hai trạng thái bằng câu lệnh `glance image-deactivate <IMAGE_ID>>` và `glance image-reactivate <IMAGE_ID>`

``` sh
[root@controller ~(keystone_admin)]# glance image-show 8867a307-8e2a-4c17-ac07-3bb126681ff5
+------------------+--------------------------------------+
| Property         | Value                                |
+------------------+--------------------------------------+
| checksum         | af3cdec809e0c9376023dec7716e6102     |
| container_format | bare                                 |
| created_at       | 2017-06-05T01:36:42Z                 |
| description      |                                      |
| disk_format      | qcow2                                |
| id               | 8867a307-8e2a-4c17-ac07-3bb126681ff5 |
| min_disk         | 0                                    |
| min_ram          | 0                                    |
| name             | cent6                                |
| owner            | b47e8a9d5d88439dadc4f849c0424e8c     |
| protected        | False                                |
| size             | 305001984                            |
| status           | deactivated                          |
| tags             | []                                   |
| updated_at       | 2017-06-20T10:16:09Z                 |
| virtual_size     | None                                 |
| visibility       | public                               |
+------------------+--------------------------------------+
```

**Lưu ý:**

Đây là câu lệnh để tương tác với glance từ ban đầu, nó còn nhiều hạn chế so với OpenStack client, tham khảo thêm tại link sau:

https://docs.openstack.org/cli-reference/glance.html

<a name="client"></a>
## 2. Sử dụng OpenStack client

Giống với glance command line, OpenStack client sử dụng câu lệnh để quản lí glance. Bảng sau đây thể hiện mối quan hệ tương tác giữa hai câu lệnh trên:

| Glance CLI | OpenStack client | Mục đích |
|------------|------------------|----------|
| glance image-create | openstack image create | Tạo mới image |
| glance image-delete | openstack image delete | Xóa image |
| glance member-create | openstack image add project | Gán project với image |
| glance member-delete | openstack image remove project | Xóa bỏ image khỏi project |
| glance image-list | openstack image list | Xem danh sách image |
| glance image-download | openstack image save | Lưu image vào ổ đĩa |
| glance image-show | openstack image show | Hiển thị thông tin chi tiết của image |
| glance image-deactivate | openstack image set -deactivate | deactivate image |
| glance image-update | openstack set | Thay đổi thông tin image |


**Xem thêm về OpenStack client cho glance tại link sau:**

https://docs.openstack.org/developer/python-openstackclient/command-objects/image.html

**Cách kiểm tra thông tin trong database**

Một image bị xóa sẽ vẫn được lưu thông tin trong database, đây là cấu trúc của glance database :

<img src="http://i.imgur.com/eHLu2Ss.png">

Bạn có thể connect rồi query ra để xem hoặc dùng GUI tool để hiển thị nội dung database:

<img src = "http://i.imgur.com/ial7BD8.png">

<img src="http://i.imgur.com/vQNQQMx.png">

- Lưu ý: Nếu bạn sử dụng Navicat, bạn cần tạo thêm một tài khoản trong database và cấp quyền truy cập cho nó thì mới có thể connect được:

``` sh
CREATE USER 'newuser'@'%' IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES ON * . * TO 'newuser'@'%';

FLUSH PRIVILEGES;
```

<a name="curl"></a>
## 3. Sử dụng cURL

- Tham khảo về API cũng như nhiệm vụ của các API trong Glance tại link sau:

https://docs.openstack.org/admin-guide/image-policies.html

https://developer.openstack.org/api-ref/image/index.html

### 3.1 Lấy token

``` sh
curl -i -X POST -H "Content-Type: application/json" -d '
{
"auth": {
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
}' http://localhost:35357/v3/auth/tokens
```

Ta thu được kết quả:

``` sh
HTTP/1.1 201 Created
Date: Tue, 20 Jun 2017 11:00:34 GMT
Server: Apache/2.4.6 (CentOS)
X-Subject-Token: 74dc157244e24eee85b94dd3f3962bc7
Vary: X-Auth-Token
x-openstack-request-id: req-32693eb4-9226-43fa-9bdb-4d24b4ac9be5
Content-Length: 7780
Connection: close
Content-Type: application/json
```

Gán token vừa lấy được vào biến để sử dụng:

`OS_AUTH_TOKEN=74dc157244e24eee85b94dd3f3962bc7`

### 3.2 Lấy danh sách image

`curl -s -X GET -H "X-Auth-Token: $OS_AUTH_TOKEN" http://controller:9292/v2/images`

Kết quả:

``` sh
[root@controller ~(keystone_admin)]# curl -s -X GET -H "X-Auth-Token: $OS_AUTH_TOKEN" http://controller:9292/v2/images
{"images": [{"status": "deactivated", "virtual_size": null, "description": "", "tags": [], "container_format": "bare", "created_at": "2017-06-05T01:36:42Z", "size": 305001984, "disk_format": "qcow2", "updated_at": "2017-06-20T10:16:09Z", "visibility": "public", "self": "/v2/images/8867a307-8e2a-4c17-ac07-3bb126681ff5", "min_disk": 0, "protected": false, "id": "8867a307-8e2a-4c17-ac07-3bb126681ff5", "file": "/v2/images/8867a307-8e2a-4c17-ac07-3bb126681ff5/file", "checksum": "af3cdec809e0c9376023dec7716e6102", "owner": "b47e8a9d5d88439dadc4f849c0424e8c", "schema": "/v2/schemas/image", "min_ram": 0, "name": "cent6"}], "schema": "/v2/schemas/images", "first": "/v2/images"}
```

### 3.3 Xem thông tin chi tiết image

Dùng API endpoint chứa image id

`curl -s \
   -X GET \
   -H "X-Auth-Token: $OS_AUTH_TOKEN" \
   http://controller:9292/v2/images/8867a307-8e2a-4c17-ac07-3bb126681ff5`

Kết quả:

``` sh
{"status": "active", "virtual_size": null, "description": "", "tags": [], "container_format": "bare", "created_at": "2017-06-05T01:36:42Z", "size": 305001984, "disk_format": "qcow2", "updated_at": "2017-06-20T11:06:05Z", "visibility": "public", "self": "/v2/images/8867a307-8e2a-4c17-ac07-3bb126681ff5", "min_disk": 0, "protected": false, "id": "8867a307-8e2a-4c17-ac07-3bb126681ff5", "file": "/v2/images/8867a307-8e2a-4c17-ac07-3bb126681ff5/file", "checksum": "af3cdec809e0c9376023dec7716e6102", "owner": "b47e8a9d5d88439dadc4f849c0424e8c", "schema": "/v2/schemas/image", "min_ram": 0, "name": "cent6"}
```

### 3.4 Tạo mới image (chưa upload dữ liệu)

`curl -i -X POST -H "X-Auth-Token: $OS_AUTH_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{"name": "curl-test", "tags": ["cirros"]}' \
    http://controller:9292/v2/images`


Kết quả trả về:

``` sh
HTTP/1.1 201 Created
Content-Length: 557
Content-Type: application/json; charset=UTF-8
Location: http://controller:9292/v2/images/2049b252-dc7b-48d6-8b54-12ebd9779a15
X-Openstack-Request-Id: req-ec4ac436-48be-4704-9d84-30532b169c6e
Date: Wed, 21 Jun 2017 01:57:03 GMT

{"status": "queued", "name": "curl-test", "tags": ["cirros"], "container_format": null, "created_at": "2017-06-21T01:57:03Z", "size": null, "disk_format": null, "updated_at": "2017-06-21T01:57:03Z", "visibility": "private", "self": "/v2/images/2049b252-dc7b-48d6-8b54-12ebd9779a15", "min_disk": 0, "protected": false, "id": "2049b252-dc7b-48d6-8b54-12ebd9779a15", "file": "/v2/images/2049b252-dc7b-48d6-8b54-12ebd9779a15/file", "checksum": null, "owner": "b47e8a9d5d88439dadc4f849c0424e8c", "virtual_size": null, "min_ram": 0, "schema": "/v2/schemas/image"}
```

### 3.5 Cập nhật các thuộc tính của image

- Để cập nhật các thuộc tính của image, ta sử dụng phương thức PATCH gửi tới API dành riêng cho từng image (Mỗi image được tự động tạo ra một API riêng theo form sau: http://controller:9292/v2/images/<IMAGE_ID> )
- Ví dụ: cập nhật thuộc tính container_format và disk_format của image vừa tạo ta làm như sau:

``` sh
curl -i -X PATCH -H "X-Auth-Token: $OS_AUTH_TOKEN" \
-H "Content-Type: application/openstack-images-v2.1-json-patch" \
-d '
[
    {
        "op": "add",
        "path": "/disk_format",
        "value": "qcow2"
    },
    {
        "op": "add",
        "path": "/container_format",
        "value": "bare"
    }
]' http://controller:9292/v2/images/2049b252-dc7b-48d6-8b54-12ebd9779a15
```

- Kết quả trả về:

``` sh
HTTP/1.1 200 OK
Content-Length: 562
Content-Type: application/json; charset=UTF-8
X-Openstack-Request-Id: req-0418a8a8-50f7-4cd8-ba6e-857fb7590abd
Date: Wed, 21 Jun 2017 02:15:51 GMT

{"status": "queued", "name": "curl-test", "tags": ["cirros"], "container_format": "bare", "created_at": "2017-06-21T01:57:03Z", "size": null, "disk_format": "qcow2", "updated_at": "2017-06-21T02:15:50Z", "visibility": "private", "self": "/v2/images/2049b252-dc7b-48d6-8b54-12ebd9779a15", "min_disk": 0, "protected": false, "id": "2049b252-dc7b-48d6-8b54-12ebd9779a15", "file": "/v2/images/2049b252-dc7b-48d6-8b54-12ebd9779a15/file", "checksum": null, "owner": "b47e8a9d5d88439dadc4f849c0424e8c", "virtual_size": null, "min_ram": 0, "schema": "/v2/schemas/image"}
```

### 3.6 Upload dữ liệu lên image

- Để upload dữ liệu cho image, sử dụng phương thức PUT tới API của từng image.

- Ví dụ: upload file .img lên image vừa tạo:

`curl -i -X PUT -H "X-Auth-Token: $OS_AUTH_TOKEN" \
	-H "Content-Type: application/octet-stream" \
	-d @/tmp/cirros-0.3.4-x86_64-disk.img \
	http://controller:9292/v2/images/2049b252-dc7b-48d6-8b54-12ebd9779a15/file`

- Kết quả:

``` sh
HTTP/1.1 204 No Content
Content-Type: text/html; charset=UTF-8
Content-Length: 0
X-Openstack-Request-Id: req-e193a06c-cd7c-4009-89d8-741b0d1a3ade
Date: Wed, 21 Jun 2017 02:22:49 GMT
```

Lúc này trạng thái image sẽ từ `queued` sang `active`.

### 3.7 Xóa image

- Để xóa image vừa tạo, sử dụng phương thức DELETE gửi request tới API của image đó.
- VÍ dụ: xóa image curl-test vừa tạo:

`curl -i -X DELETE -H "X-Auth-Token: $OS_AUTH_TOKEN" \
	-H "Content-Type: application/octet-stream" \
	http://controller:9292/v2/images/2049b252-dc7b-48d6-8b54-12ebd9779a15`

- Kết quả trả về:

``` sh
[root@controller ~(keystone_admin)]# openstack image list
+--------------------------------------+-----------+--------+
| ID                                   | Name      | Status |
+--------------------------------------+-----------+--------+
| 2049b252-dc7b-48d6-8b54-12ebd9779a15 | curl-test | active |
| 8867a307-8e2a-4c17-ac07-3bb126681ff5 | cent6     | active |
+--------------------------------------+-----------+--------+
[root@controller ~(keystone_admin)]# curl -i -X DELETE -H "X-Auth-Token: $OS_AUTH_TOKEN" \
> -H "Content-Type: application/octet-stream" \
> http://controller:9292/v2/images/2049b252-dc7b-48d6-8b54-12ebd9779a15
HTTP/1.1 204 No Content
Content-Type: text/html; charset=UTF-8
Content-Length: 0
X-Openstack-Request-Id: req-3444f8fd-a4d4-4d31-82a8-693ecba70fd6
Date: Wed, 21 Jun 2017 02:26:43 GMT

[root@controller ~(keystone_admin)]# openstack image list
+--------------------------------------+-------+--------+
| ID                                   | Name  | Status |
+--------------------------------------+-------+--------+
| 8867a307-8e2a-4c17-ac07-3bb126681ff5 | cent6 | active |
+--------------------------------------+-------+--------+
```

### 3.8 Sử dụng REST client

Ta có thể sử dụng tiện ích trên Google chrome và Firefox là Advanced REST client:

**Lấy token**

<img src="http://i.imgur.com/NbuLr1I.png">

Kết quả trả về:

<img src="http://i.imgur.com/zdOf2bg.png">

**Liệt kê danh sách các image**

<img src="http://i.imgur.com/xH6HeRU.png">

Kết quả trả về:

<img src="http://i.imgur.com/vL1jvFr.png">

**Các thao tác khác thực hiện tương tự. (Chú ý các tham số của URI, method, header và payload của request)**

**Tham khảo thêm về glance API tại link sau:**

https://developer.openstack.org/api-ref/image/v2/index.html

**Tham khảo:**

https://github.com/hocchudong/thuctap012017/blob/master/TamNT/Openstack/Glance/docs/3.Cac_thao_tac_su_dung_Glance.md

https://github.com/vietstacker/texbook-openstack-VN/blob/master/02.Glance/02.GlanceAPI.md

https://docs.openstack.org/developer/glance/glanceapi.html
