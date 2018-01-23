## LVM Snapshot là gì?
LVM Snapshot là một tính năng trong LVM
## LVM snapshot để làm gì?
`LVM snapshots` là một tính năng cho phép tạo ra các bản sao lưu dữ liệu cho Logical Volume, thêm nữa, nó còn cung cấp một tính năng phục hồi dữ liệu cho Logical Volume.
## Cơ chế hoạt động của LVM snapshot
Từ Volume group, tạo ra một Logical Volume để snapshot cho Logical volume cần backup.
Trường hợp tối ưu nhất là khi Logical volume snapshot bằng dung lượng với logical volume gốc đế tránh bị tràn bộ nhớ.
Trong trường hợp logical volume gốc bị mất dữ liệu, có thể dùng logical volume snapshot có thể khôi phục lại cho bản gốc từ thời điểm tạo snapshot.
Khi logical volume gốc phát sinh thêm dữ liệu thì bản snapshot cũng tốn thêm 1 dung lượng để lưu đúng bằng dữ liệu bản gốc thay đổi. (em vẫn chưa thật sự rõ ràng ý nghĩa vấn đề này lắm, mai em xin hỏi anh trực tiếp ạ)
## Hoàn cảnh áp dụng
logical volume Snapshot sẽ được dùng để khôi phục dữ liệu cho bản gốc tại thời điểm tạo Snapshot trong trường hợp cần thiết
## Bài thực hành.
https://github.com/vuvandang1995/linux/blob/master/tai_lieu_linux/LVM.Snapshot.md