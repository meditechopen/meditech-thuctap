# Set static ip for Untu server

1- Thay đổi cấu hình mạng của Ubuntu Server ảo hoá, chuyển từ DHCP sang Static IP. Chuyển xong, Ubuntu được gán IP tĩnh, nhưng không truy cập được Internet nữa.
2- Cách sửa là bổ xung thủ công các DNS Server cần thiết để Ubuntu Server ảo hoá có thể truy cập Internet.
Lưu ý phải cấu hình Network Adapter cho Ubuntu Server ảo hoá là Bridged (Auto Detect)
Các bước chi tiết như sau: 
1- Mở Terminal, gõ lệnh, để thay network interface từ DHCP sang Static

```
sudo nano /etc/network/interfaces
# The primary network interface
auto eth0
#iface eth0 inet dhcp  //bo lenh nay di, thay bang lenh duoi de fix IP address
iface eth0 inet static
address 192.168.1.8
netmask 255.255.255.0
gateway 192.168.1.1
```

2- Việc sửa trực tiếp vào file resolv.conf chỉ có tác dụng nhất thời, khi Ubuntu boot lại, nội dung file này sẽ bị ghi đè lên. Do đó ta phải chèn DNS Server vào tập tin cấu hình /etc/resolvconf/resolv.conf.d/head. Danh sách DNS server trong tập tin này sẽ ghi vào file resolv.conf

```
sudo nano /etc/resolvconf/resolv.conf.d/head
nameserver 127.0.0.1  //Dùng sẵn các resolved host được caching
nameserver 192.168.1.1 //Trỏ vào default gateway ở đây là địa chỉ của modem ADSL
nameserver 210.245.0.58 //Trỏ vào DNS của FPT
nameserver 203.162.4.190 //Trỏ vào DNS của VNPT
nameserver 203.113.131.1
nameserver 210.245.0.11
nameserver 8.8.8.8
nameserver 8.8.4.4
```
Kết quả thu được, Ubuntu Server ảo hoá được gán địa chỉ IP tĩnh, và cấu hình được các DNS server cần thiết để nối Internet.