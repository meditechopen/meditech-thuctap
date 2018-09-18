# Hướng dẫn install balloon driver cho các máy chủ windows

## Với các máy chưa được launch

Tải driver virtio [tại đây](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso)

Trong quá trình tạo máy ảo để đóng image, thêm iso vừa tải về dưới dạng cd rom vào.

Truy cập vào iso được mount ở trên, tìm tới thư mục "Balloon" -> Thư mục phù hợp với version máy ảo đang chạy. Ví dụ ở đây mình đang dùng win2k12 r2

<img src="https://i.imgur.com/B7rS98l.png">

Copy thư mục amd64 vào ổ C.

<img src="https://i.imgur.com/2B3H7AZ.png">

Truy cập vào "Device Manager" -> "Other Devices" -> "PCI Device" -> "Update Driver Software"

<img src="https://i.imgur.com/X9fsFrn.png">

Browse tới thư mục vừa được copy vào ổ C.

<img src="https://i.imgur.com/2hTs15h.png">

Driver đã đc cài đặt

<img src="https://i.imgur.com/PLziREM.png">

Truy cập vào powershell chạy dòng lệnh sau:

<img src="https://i.imgur.com/oaXSeHl.png">

```
cd c:/
cd .\amd64
.\blnsvr.exe -i
```

Kiểm tra xem service đã hoạt động chưa

<img src="https://i.imgur.com/i0kMdTn.png">

## Với các máy đã được launch

Copy thư mục "amd64" trong folder Balloon với version os tương ứng vào ổ C rồi thực hiện theo các bước trên.
