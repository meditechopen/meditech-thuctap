# Hướng dẫn tạo Template và Snapshot trong KVM

## Mục lục

### [1. Hướng dẫn tạo Template từ VM](#template)

#### [1.1 Giới thiệu về template trong KVM](#gioi-thieu)

#### [1.2 Hướng dẫn tạo và quản lí template](#create-template)

### [2. Hướng dẫn tạo Snapshot](#snapshot)

#### [2.1 Hướng dẫn tạo và quản lí Internal Snapshot](#internal)

#### [2.2 Hướng dẫn tạo và quản lí External Snapshot](#external)

----

### <a name="template"> 1. Hướng dẫn tạo Template từ VM </a>

#### <a name="gioi-thieu">1.1 Giới thiệu về Template trong KVM </a>

- Template là một dạng file image pre-configured của hệ điều hành được dùng để tạo nhanh các máy ảo. Sử dụng template sẽ khiến bạn tránh khỏi những bước cài đặt lặp đi lặp lại và tiết kiệm thời gian rất nhiều so với việc cài bằng tay từng bước một.
- Giả sử bạn có 4 máy Apache web server. Thông thường, bạn sẽ phải cài 4 máy ảo rồi lần lượt cài hệ điều hành cho từng máy, sau đó lại tiếp tục tiến hành cài đặt dịch vụ hoặc phần mềm. Điều này tốn rất nhiều thời gian và template sẽ giúp bạn giải quyến vấn đề này.
- Hình dưới đây mô tả các bước mà bạn phải thực hiện theo ví dụ trên nếu bạn cài bằng tay. Rõ ràng từ bước 2-5 chỉ là những tasks lặp đi lặp lại và nó sẽ tiêu tốn rất nhiều thời gian không cần thiết.

<img src="http://i.imgur.com/yPEbPLj.png">

- Với việc sử dụng template, số bước mà người dùng phải thực hiện sẽ được rút ngắn đi rất nhiều, chỉ cần thực hiện 1 lần các bước từ 1-5 rồi tạo template là bạn đã có thể triển khai 4 web servers còn lại một cách rất dễ dàng. Điều này sẽ giúp người dùng tiết kiệm rất nhiều thời gian:

<img src="http://i.imgur.com/itJRUFQ.png">

#### <a name="create-template"> 1.2 Hướng dẫn tạo và quản lý template </a>

- Hai khái niệm mà người dùng cần phân biệt đó là `clone` và `template`. Nếu `clone` đơn thuần chỉ là một bản sao của máy ảo thì `template` được coi là master copy của VM, nó có thể được dùng để tạo ra rất nhiều clone khác nữa.
- Có hai phương thức để triển khai máy ảo từ template đó là `Thin` và `Clone`
  <ul>
  <li>Thin: Máy ảo được tạo ra theo phương thức này sẽ sử dụng template như một base image, lúc này nó sẽ được chuyển sang trạng thái read only. Cùng với đó, sẽ có một ổ mới hỗ trợ "copy on write" được thêm vào để lưu dữ liệu mới. Phương thức này tốn ít dung lượng hơn tuy nhiên các VM được tạo ra sẽ phụ thuộc vào base image, chúng sẽ không chạy được nếu không có base image</li>
  <li>Clone: Máy ảo được tạo ra làn một bản sao hoàn chỉnh và hoàn toàn không phụ thộc vào template cũng như máy ảo ban đầu. Mặc dù vậy, nó sẽ chiếm dung lượng giống như máy ảo ban đầu.</li>
  </ul>

**Hướng dẫn tạo templates**

- Template thực chất là máy ảo được chuyển đổi sang. Quá trình này gồm 3 bước:
  <ul>
  <li>Bước 1: Cài đặt máy ảo với đầy đủ các phần mềm cần thiết để biến nó thành template</li>
  <li>Bước 2: Loại bỏ tất cả những cài đặt cụ thể ví dụ như password SSH, địa chỉ MAC... để đảm bảo rằng nó sẽ không được áp dụng giống nhau tới tất cả các máy ảo được tạo ra sau này.</li>
  <li>Bước 3: Đánh dấu máy ảo là template bằng việc đổi tên.</li>
  </ul>

**Sau đây là các bước cụ thể để tạo template với máy ảo Ubuntu 14.04 64bit trên KVM:**

- Cài đặt Ubuntu 14.04 trên KVM bằng công cụ mà bạn ưa thích (virt-manager, virt-install...). Cài đặt lên những dịch vụ cần thiết.
- Shutdown máy ảo bằng câu lệnh `virsh shutdown VMname`
- Sử dụng `virt-sysprep` để "niêm phong" máy ảo:
  <ul>
  <li>"virt-sysprep" là một tiện ích nằm trong gói "libguestfs-tools-c" được sử dụng để loại bỏ những thông tin cụ thể của hệ thống đồng thời niêm phong và biến máy ảo trở thành template</li>
  <li>Có 2 options để dùng  "virt-sysprep" đó là "-a" và "-d". Tùy chọn "-d" được sử dụng với tên hoặc UUID của máy ảo, tùy chọn "-a" được sử dụng với đường dẫn tới ổ đĩa máy ảo.</li>
  </ul>

- Người dùng cũng có thể liệt kê các options cụ thể khi sử dụng với `virt-sysprep`. Ví dụ: `virt-sysprep --operations ssh-hostkeys,udev-persistent-net -d`.
- Giờ đây ta đã có thể đánh dấu máy ảo trở thành template. Người dùng cũng có thể backup file XML và tiến hành "undefine" máy ảo trong libvirt.
- Sử dụng "virt-manager" để thay đổi tên máy ảo, đối với việc backup file XML, hãy chạy câu lệnh: `virsh dumpxml Template_VMname > /root/Template_VMname.xml`
- Để undefine máy ảo, chạy câu lệnh `virsh undefine VMname`

**Hướng dẫn triển khai máy ảo từ template sử dụng phương thức "Clone" trên virt-manager**

- Mở virt-manager, chọn máy ảo đã được chuyển đổi thành template, click chuột phải và chọn `Clone`

<img src="http://i.imgur.com/N81Pgvh.png">

- Điền tên và chọn các thông tin liên quan như network, storage... Sau đó click vào `Clone` để tiến hành tạo máy ảo mới.
- Sau khi hoàn tất, máy ảo đã sẵn sàng để sử dụng

<img src="http://i.imgur.com/8yXMAne.png">

- Lưu ý rằng máy ảo khi tạo ra với phương thức "Clone" sẽ hoàn toàn độc lập với template, nó vẫn có thể chạy khi ta bỏ đi template.

**Hướng dẫn triển khai máy ảo từ template sử dụng phương thức "Thin"**

- Tạo ra file images mới với định dạng qcow2 để làm file backup bằng câu lệnh: `qemu-img create -b / -f qcow2 /`

<img src="http://i.imgur.com/qyDGb7K.png">

- Kiểm tra xem file mới tạo ra đã được chỉ tới file backup của nó hay chưa bằng câu lệnh: `qemu-img info /`

<img src="http://i.imgur.com/WwmApHY.png">

- Dùng `virt-clone` để tạo ra máy ảo mới từ file XML và image đã được backup: `virt-clone --original-xml=/root/file.xml -f /var/kvm/images/vm1.qcow2 -n Ubuntu-01 --preserve-data`

<img src="http://i.imgur.com/NhFTaSw.png">

- Sử dụng câu lệnh `virsh list --all` để kiểm tra xem máy ảo đã được define hay chưa.

<img src="http://i.imgur.com/wkK35wN.png">

- Tiến hành download 1 số thứ rồi kiểm ta dung lượng. Máy ảo được tạo ra sẽ có dung lượng file image đúng bằng dung lượng file bạn vừa down. Cơ chế hoạt động giống như Thin Provisioning giúp tiết kiệm bộ nhớ tuy nhiên nếu file template bị remove, các máy ảo tạo từ nó cũng sẽ không thể chạy được nữa.

### <a name="snapshot"> 2. Hướng dẫn tạo Snapshot trên VM </a>

- Snapshot là trạng thái của hệ thống ở một thời điểm nhất định, nó sẽ lưu lại cả những cài đặt và dữ liệu. Với snapshot, bạn có thể quay trở lại trạng thái của máy ảo ở một thời điểm nào đó rất dễ dàng.
- libvirt hỗ trợ việc tạo snapshot khi máy ảo đang chạy. Mặc dù vậy, nếu máy ảo của bạn đang chạy ứng dụng thì tốt hơn hết hãy tắt hoặc suspend trước khi tiến hành tạo snapshot.
- Có 2 loại snapshot chính được hỗ trợ bởi libvirt:
- Internal: Trước và sau khi tạo snapshot, dữ liệu chỉ được lưu trên một ổ đĩa duy nhất. Người dùng có thể tạo internal snapshot bằng công cụ virt-manager. Mặc dù vậy, nó vẫn có 1 vài hạn chế:
     <ul>
     <li>Chỉ hỗ trợ duy nhất định dạng qcow2</li>
     <li>VM sẽ bị ngưng lại khi tiến hành snapshot</li>
     <li>Không hoạt động với LVM storage pools</li>
     </ul>

- External: Dựa theo cơ chế copy-on-write. Khi snapshot được tạo, ổ đĩa ban đầu sẽ có trạng thái "read-only" và có một ổ đĩa khác chồng lên để lưu dữ liệu mới: 

<img src="http://i.imgur.com/7LjgixT.png">

- Ổ đĩa được chồng lên được tạo ra có định dạng `qcow2`, hoàn toàn trống và nó có thể chứa lượng dữ diệu giống như ổ đĩa ban đầu. External snapshot có thể được tạo với bất kì định dạng ổ đĩa nào mà libvirt hỗ trợ. Tuy nhiên không có công cụ đồ họa nào hỗ trợ cho việc này. 


#### <a name="internal">  2.1 Hướng dẫn tạo và quản lí Internal Snapshot </a>

- Internal snapshot chỉ hỗ trợ định dạng `qcow2` vì thế hãy xem rằng ổ đĩa của máy ảo thuộc định dạng nào bằng câu lệnh `qemu-img info /` . Nếu định dạng ổ đĩa không phải là `qcow2`, hãy chuyển nó sang định dạng này bằng câu lệnh `qemu-img convert`

- Một vài câu lệnh `virsh` liên quan tới việc tạo và quản lí máy ảo:
  <ul>
  <li>"snapshot-create " : Tạo snapshot từ file XML</li>
  <li>"snapshot-create-as" : Tạo snapshot với những tùy chọn</li>
  <li>"snapshot-current" : Thiết lập hoặc lấy thông tin của snapshot hiện tại</li>
  <li>"snapshot-delete" : Xóa một snapshot</li>
  <li>"snapshot-dumpxml" : Tạo ra thêm 1 file XML cho một snapshot</li>
  <li>"snapshot-edit" : Chỉnh sửa file XML của snapshot</li>
  <li>"snapshot-info" : Lấy thông tin của snapshot</li>
  <li>"snapshot-list" : Lấy danh sách các snapshots</li>
  <li>"snapshot-parent" : Lấy tên của snapshot "cha" của một snapshot nào đó</li>
  <li>"snapshot-revert" : Quay trở về trạng thái khi tạo snapshot</li>
  </ul>

- Để tạo mới một internal snapshot, thông thường ta hay sử dụng câu lệnh: `virsh snapshot-create-as VMname --name "Snapshot 1" --description "First snapshot" --atomic`

<img src="http://i.imgur.com/7iTpURh.png">

Trong đó "Snapshot 1" là tên của snapshot, "First snapshot" là mô tả và `--atomic` bao đảm cho việc toàn vẹn dữ liệu

- Người dùng có thể tạo ra nhiều các snapshot, thêm tùy chọn `--parent` vào `snapshot-list` để hiển thị ra danh sách snapshots theo mối quan hệ "cha-con"
- Để quay trở lại trạng thái của một internal snapshot, dùng câu lệnh: `virsh snapshot-revert <vm-name> --snapshotname "Snapshot 1"`
- Để xóa một internal snapshot sử dụng câu lệnh `virsh snapshot-delete VMname Snapshotname`

<img src="http://i.imgur.com/1ZsTM2h.png">

#### <a name="external">  2.2 Hướng dẫn tạo và quản lí External Snapshot </a>

**Tạo snapshot**

- Tiến hành kiểm tra ổ đĩa mà máy ảo muốn tạo snapshot đang sử dụng bằng câu lệnh `virsh domblklist VMname --details`

<img src="http://i.imgur.com/6imSrzk.png">

- Tiến hành tạo snapshot bằng câu lệnh `virsh snapshot-create-as VMname snapshot1 "My First Snapshot" --disk-only --atomic`

Trong đó `--disk-only` dùng để tạo snapshot cho riêng ổ đĩa.

- Check lại danh sách bằng câu lệnh `virsh snapshot-list VMname`

<img src="http://i.imgur.com/S6klysK.png">

- Snapshot đã được tạo tuy nhiên nó chỉ lưu trữ duy nhất trạng thái ổ đĩa:

<img src="http://i.imgur.com/A9Wyiwr.png">

- Kiểm tra lại ổ đĩa mà máy ảo đang sử dụng:

<img src="http://i.imgur.com/WBeHKg4.png">

Lúc này ổ đĩa cũ đã biến thành trạng thái `read-only`, VM dùng ổ đĩa mới để lưu dữ liệu và `backingfile` sẽ là ổ đĩa ban đầu. Hãy xem thông tin của ổ đĩa này:

<img src="http://i.imgur.com/BuqBwSR.png">

**Revert lại trạng thái snapshot**

- Để revert lại trạng thái của external snapshot, bạn phải cấu hình file XML bằng tay bởi libvirt vẫn chưa hỗ trợ cho việc này. Giả sử VM đang ở snapshot2 và bạn muốn quay trở lại snapshot1:
  - Lấy đường dẫn tới ổ đĩa được tạo ra khi snapshot:

     <img src="http://i.imgur.com/8QkfP0Q.png">

  - Kiểm tra để đảm bảo nó còn nguyên vẹn và được kết nối với backing file

     <img src="http://i.imgur.com/3GTE5yy.png">

  - Chỉnh sửa bằng tay file XML, bỏ ổ đĩa hiện tại và thay thế bằng ổ đĩa ở trạng thái snapshot1:

     <img src="http://i.imgur.com/wF6FA7k.png">

  - Kiểm tra lại xem máy ảo đã sử dụng đúng ổ chưa:

     <img src="http://i.imgur.com/TDdUY5q.png'">

  - Khởi động máy ảo và kiểm tra

**Xóa external snapshot**

- Quy trình xóa một external snapshot khá phức tạp. Để có thể xóa, trước tiên bạn phải tiến hành hợp nhất nó với ổ đĩa cũ. Có hai kiểu hợp nhất đó là:

  <ul>
  <li>blockcommit: Hợp nhất dữ liệu với ổ đĩa cũ.</li>
  <li>blockpull : Hợp nhất dữ liệu với ổ đĩa được tạo ra khi snapshot. Ổ đĩa sau khi hợp nhất sẽ luôn có định dạng qcow2.</li>
  </ul>

- Hợp nhất sử dụng `blockcommit` : 
  <ul>
  <li>Kiểm tra ổ đĩa hiện tại mà máy ảo sử dụng bằng câu lệnh "virsh domblklist VM1"</li>
  <li>Xem thông tin backing file của ổ đĩa đang được sử dụng bằng câu lệnh "qemu-img info --backing-chain /vmstore1/vm1.snap4 | grep backing"</li>
  <li>Hợp nhất snapshot bằng câu lệnh "virsh blockcommit VM1 hda --verbose --pivot --active" . Lưu ý đối với ubuntu, chỉ bản 16.04 mới hỗ trợ câu lệnh này</li>
  <li>Check lại ổ đĩa đang sử dụng bằng câu lệnh "virsh domblklist VM1"</li>
  <li>Kiểm tra lại danh sách các snapshot bằng câu lệnh "virsh snapshot-list VM1"</li>
  <li>Xóa snapshot bằng câu lệnh "virsh snapshot-delete VM1 snap1 --children --metadata"</li>
  </ul>

- Hợp nhất sử dụng `blockpull`: 

 - Xem ổ đĩa hiện tại máy ảo đang sử dụng:

 <img src="http://i.imgur.com/Zk7Yh8t.png">

 - Xem backing file của VM:

 <img src="http://i.imgur.com/jvqgfRF.png">

 - Hợp nhất ổ đĩa cũ với ổ đĩa snapshot:

 <img src="http://i.imgur.com/9HtNPZs.png">

 - Xóa bỏ base image và snapshot metadata bằng câu lệnh `virsh snapshot-delete VMname snapshotname --metadata`




