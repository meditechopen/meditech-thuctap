# Tìm hiểu các thao tác sử dụng Glance

## Mục lục

[1. Sử dụng glance command line](#glance)

[2. Sử dụng OpenStack client](#client)

[3. Sử dụng cURL](#curl)

-----------

## 1. Sử dụng glance command line

### 1.1 List image

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

### 1.3 Create image

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

### 3.4
