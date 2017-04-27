# Hướng dẫn cài Hệ điều hành Ubuntu Server
============================================

Đầu tiên, để cài một hệ điều hành Ubuntu Server thì cần phải có một file iso của hệ điều hành đó. Các bạn truy cập địa chỉ

[Download UbuntuServer](#https://www.ubuntu.com/download/server)

Sau khi đã tải xong, chúng ta bắt đầu tiến hành cài đặt nó.
Ở đây mình sử dụng phiên bản UbuntuServer 14.04 và thực hiện cài đặt nó trên phần mềm VMware.

- *Bước 1* : Sau khi đã chọn file iso và tiến hành một số bước cài đặt phần cứng trên VMware, Power On máy ảo UbuntuServer lên sẽ hiển thị như sau :

    Phần này chọn ngôn ngữ cài đặt cho UbuntuServer
    <img src=http://i.imgur.com/9wHro3W.png>

    Các bạn nên chọn ngôn ngữ là : English

- *Bước 2* : Sau khi chọn ngôn ngữ, sẽ hiển thị ra một số tùy chọn. Chúng ta chỉ quan tâm đến vấn đề cài đặt Hệ Điều Hành. Vì thế chọn `Install Ubuntu Server` để bắt đầu tiến hành cài đặt.

    <img src=http://i.imgur.com/EDWbXxe.png>

- *Bước 3* : Tiếp tục chọn ngôn ngữ cài đặt. Chúng ta vẫn chọn là `English`

    <img src=http://i.imgur.com/S7OE9um.png>

- *Bước 4* : Chọn Quốc gia của bạn.Mình ở Việt Nam nên mình sẽ keó xuống dưới cùng, chọn `other` chọn tiếp `Asia` và chọn `Việt Nam`.

    <img src=http://i.imgur.com/yoxVEPv.png>

- *Bước 5* : Tiếp theo là chọn chuẩn mã hóa ký tự.Để phù hợp với chuẩn bàn phím quốc tế bạn chọn `United State - en_US.UTF-8` nhé.

    <img src=http://i.imgur.com/SEFtWT4.png>

- *Bước 6* : Kiểm tra kiểu bàn phím của các bạn. Cái này chọn `No` để bỏ qua nhé.Vì mình chọn theo chuẩn quốc tế rồi.

  <img src=http://i.imgur.com/ptCoyw9.png>

- *Bước 7* : Chọn kiểu bàn phím .

    <img src=http://i.imgur.com/Ifln8im.png>

- *Bước 8* : Tiếp tục chọn kiểu bàn phím .Vẫn để theo `US` nhé.

    <img src=http://i.imgur.com/f0ZNN8E.png>

    Tiếp theo Hệ thống sẽ tiến hành một số cài đặt, các bạn chờ một lát.

- *Bước 9* : Nhập tên cho hệ thống bạn cài đặt. Lưu ý là tên không có khoảng trống và không có ký tự đặt biệt.

    <img src=http://i.imgur.com/RjAIuFu.png>

- *Bước 10* : Đặt tên cho người dùng đăng nhập hệ thống.

    <img src=http://i.imgur.com/7ACGTM5.png>

- *Bước 11* : Cài đặt mật khẩu đăng nhập hệ thống.

    <img src=http://i.imgur.com/meTRjcH.png>

    Sau bước này có bước xác nhận lại mật khẩu. Các bạn gõ lại mật khẩu vừa nhập nhé.

- *Bước 12* : Hệ thống hỏi rằng bạn có muốn mã hóa thư mục `Home` hay không ?

    <img src=http://i.imgur.com/nn4KR9B.png>

    Ở bước này mình không muốn mã hóa nên mình chọn `No`.

- *Bước 13* : Hệ thống sẽ tự động cấu hình thời gian và yêu cầu xác nhận lại múi giờ, nếu sai sẽ phải chỉnh lại múi giờ.

- *Bước 14* : Sau khi tự động cài đặt một số cấu hình, Hệ thống sẽ yêu cầu bạn chọn *Thông số phân vùng ổ cứng* .
    Có 4 tùy chọn:
    <ul>
    <li>`Use entire disk` : HT tự động cấu hình các phân vùng </li>
    <li>`Use entire disk and set up LVM` :  HT tự động cấu hình phân vùng và cài đặt quản lý các phân vùng ổ cứng.</li>
    <li>`Use entire disk and set up encryped LVM` : HT tự động cấu hình phân vùng và cài đặt quản lý ,mã hóa các phân vùng ổ cứng </li>
    <li>`Manual` :  Tự cấu hình các phân vùng bằng tay .</li>
    </ul>

    Ở đây nếu bạn nào thông thạo việc chia các phân vùng trong Ubuntu thì nên chọn `Manual` để tự cấu hình theo ý muốn. Mình chọn tự động cấu hình cho nó nhanh.
    <img src=http://i.imgur.com/4rBGeIg.png>

- *Bước 15* : Hiển thị dung lượng ổ cứng máy ảo.
    Mục này ấn `Enter`
    <img src=http://i.imgur.com/DwDNkaL.png>

- *Bước 16* : Xác nhận phân vùng cấu hình. Chọn `Yes` để xác nhận.

    <img src=http://i.imgur.com/KypnuSd.png>

- *Bước 17* : Chọn dung lượng ổ cứng bạn sử dụng.

    <img src=http://i.imgur.com/uDNni6J.png>

- *Bước 18* : Hệ thống hiện thị thông tin cấu hình, chọn `Yes` để xác nhận.

- *Bước 19* : Cài đặt thông số Proxy.Nếu bạn muốn sử dụng Proxy cho hệ thống của mình thì điền các thông số Proxy . Nếu không dùng Proxy Server thì để trống và `Continue`.

- *Bước 20* : Tự động cập nhật hệ thống hay không. Ở bước này mình không muốn tự động cập nhật nên mình chọn `No automatic updates`

    <img src=http://i.imgur.com/DCgnVlR.png>

- *Bước 21* : Cài đặt một số dịch vụ trên Ubuntu Server.
    Mình muốn truy cập từ xa nên mình chọn SSH và `Continue`
    <img src=http://i.imgur.com/gzUHjYz.png>

- *Bước 22* : Sau khi cấu hình các dịch vụ, hệ thống hỏi có cài đặt Grub boot loader hay không.
  `Grub boot loader` : Cái này mình vẫn chưa hiểu, nên sẽ update sau.

  <img src=http://i.imgur.com/2qLWcEJ.png>

- *Bước 23* : Cài đặt hoàn thành.Chọn `Continue` để bắt đầu Restart.

  <img src=http://i.imgur.com/fnzAT4N.png>

    Hệ thống sau khi khởi động xong. Điền `Username` và `Password` để đăng nhập vào hệ thống.

    <img src=http://i.imgur.com/7lEgek4.png>

Trên đây là quá trình cài đặt Ubuntu Server do mình tìm hiểu. Nếu có gì sai sót các bạn hãy góp ý để mình chỉnh sửa, xin cảm ơn !!!
