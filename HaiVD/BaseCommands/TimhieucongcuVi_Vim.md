# Một số thao tác soạn thảo với trình soạn thảo Vi_Vim
-------------------------------------------------------------
# Mục lục
## [1. Sử dụng và chuyển đổi chế độ soạn thảo](#1)
## [2. Các lệnh trong chế độ soạn thảo](#2)
### [2.1 Các nhóm lệnh di chuyển con trỏ](#21)
### [2.2 Nhóm các lệnh xóa](#22)
### [2.3 Nhóm lệnh thay thế](#23)
### [2.4 Nhóm lệnh tìm kiếm](#24)
### [2.5 Nhóm lệnh tìm kiếm và thay thế](#25)
### [2.6 Các thao tác trên tệp tin](#26)

<a name=1></a>
## 1. Sử dụng và chuyển đổi chế độ soạn thảo.
- Sử dụng vi kèm theo tên file(s) muốn edit: vi one.txt two.txt etc.txt
- Có 2 mode: command mode và insert mode. Khi bắt đầu sử dụng lệnh vi, vi mặc định ở command mode. Hoặc ấn Esc để chuyển sang command mode khi người dùng đang ở insert mode.

<a name=2></a>
## 2. Các lệnh trong chế độ soạn thảo

<a name=21></a>
### 2.1 Các nhóm lệnh di chuyển con trỏ
- h : Sang trái 1 space
- e : Sang phải 1 space
- w : Sang phải 1 từ
- b : Sang trái 1 từ
- k : Lên một dòng
- j : Xuống một dòng
- ) : Đến cuối câu
- ( : Lên đầu câu
- } : Đến cuối đoạn
- { : Lên đầu đoạn

<a name=22></a>
### 2.2 Nhóm các lệnh xóa
- dw : Xóa 1 từ
- d^ : Xóa các ký tự từ vị trí con trỏ đến đầu dòng
- d$ : Xóa các ký tự từ vị trí con trỏ đến cuối dòng
- 3dw : Xóa 3 từ
- dd : Xóa dòng lệnh hiện hành
- 5dd : Xóa 5 dòng lệnh
- x : Xóa một ký tự

<a name=23></a>
### 2.3 Nhóm lệnh thay thế
- cw : Thay thế một từ
- 3cw : Thay thế 3 từ
- cc : Thay thế dòng lệnh hiện hành
- 5cc : Thay thế 5 dòng lệnh

<a name=24></a>
### 2.4 Nhóm lệnh tìm kiếm
- ? : Tìm kiến từ vị trí con trỏ trở lên
- / : Tìm kiếm từ vị trí con trỏ trở xuống
- */and : Tìm kiếm từ kế tiếp của and
- *?and : Tìm kiếm từ kết thúc là and
- */nThe : Tìm kiến dòng kế tiếp bắt đầu bằng The
- n : Tìm hướng xuống
- N : Tìm hướng lên

<a name=25></a>
### 2.5 Nhóm lệnh tìm kiếm và thay thế
- :s/text1/text2/g : Thay thế text 1 bằng text2
- :1.$s/tập tin/thư mục - Thay tập tin bằng thư mục
- :g/one/s/1/g : Thay thế one bằng 1

<a name=26></a>
### 2.6 Các thao tác trên tệp tin
- :w : Ghi vào tệp tin
- :x : Lưu và thoát
- :wq : Lưu và thoát
- :w : Lưu vào tệp tin mới
- :q : Thoát nếu không có thay đổi
- :q! : Thoát không lưu
- :r : Mở tệp tin đọc
- :set nu : Đánh số các dòng
- shift+g : Xuống cuối đoạn
- g+g : Lên đầu đoạn
- Số dòng + Shift+g : Chuyển đến một dòng bất kì
