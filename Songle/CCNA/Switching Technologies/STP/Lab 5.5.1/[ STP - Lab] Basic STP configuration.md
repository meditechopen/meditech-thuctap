# Lab 5.5.1 Basic Spanning Tree Protocol

![Imgur](https://i.imgur.com/hy1dYbp.jpg)

![Imgur](https://i.imgur.com/e6Nzqjv.jpg)

## Mục đích bài Lab :

- Nối các đường dây mạng trong mô hình
- Xóa cấu hình hiện tại của Switch và nạp lại cấu hình mặc định, cài đặt Switch trở về trạng thái ban đầu
- Cấu hình cơ bản cho Switch
- Quan sát và giải thích những sự thay đổi và hoạt động của STP
- Quan sát phản hồi sau những thay đổi trong mô hình STP

## Phần 1 : Thiết lập các cấu hình cơ bản 

### Bước 1 : Thực hiện kết nối các thiết bị như mô hình ở trên
- Thiết bị : Cisco 2960 Switches

- Thiết lập các kết nối console giữa 3 swithches.

*Mỗi thiết bị khác nhau có thể cho ra những đầu ra khác nhau*

### Bước 2: Xóa bỏ mọi cấu hình hiện tại của Switch và cấu hình cơ bản cho Switch:

- Switch hostname
- Tắt chế độ DNS lookup
- Cấu hình chế độ mật khẩu EXEC của class
- Cấu hình mật khẩu cho kết nối console
- Cấu hình mật khẩu cho kết nối vty

https://github.com/Skyaknt/CCNA/blob/master/%5BCCNA-Lab%5D%20%20Cau%20hinh%20co%20ban%20Router%20va%20Switch.md

```
Switch>enable
Switch#configure terminal
Enter configuration commands, one per line. End with CNTL/Z.
Switch(config)#hostname S1
S1(config)#enable secret class
S1(config)#no ip domain-lookup
S1(config)#line console 0
S1(config-line)#password cisco
S1(config-line)#login
S1(config-line)#line vty 0 15
S1(config-line)#password cisco
S1(config-line)#login
S1(config-line)#end
%SYS-5-CONFIG_I: Configured from console by console
S1#copy running-config startup-config
Destination filename [startup-config]?
Building configuration...
[OK]
```

## Phần 2 : Chuẩn bị hệ thống mạng 

### Bước 1 : Tắt kết nối tất cả các cổng bằng lệnh **shutdown** :

```
S1(config)#interface range fa0/1-24
S1(config-if-range)#shutdown
S1(config-if-range)#interface range gi0/1-2
S1(config-if-range)#shutdown
S2(config)#interface range fa0/1-24
S2(config-if-range)#shutdown
S2(config-if-range)#interface range gi0/1-2
S2(config-if-range)#shutdown
S3(config)#interface range fa0/1-24
S3(config-if-range)#shutdown
S3(config-if-range)#interface range gi0/1-2
S3(config-if-range)#shutdown
```

#### Bước 2 : Khởi động lại các cổng sẽ sử dụng trong mô hình trên S1 và S2 vào chế độ truy cập

```
S1(config)#interface fa0/3
S1(config-if)#switchport mode access
S1(config-if)#no shutdown
S2(config)#**interface range fa0/6, fa0/11, fa0/18
S2(config-if-range)#switchport mode access
S2(config-if-range)#no shutdown
```

#### Bước 3 : Bật chế độ trunk port trên các Switches :

```
S1(config-if-range)#interface range fa0/1, fa0/2
S1(config-if-range)#switchport mode trunk
S1(config-if-range)#no shutdown
S2(config-if-range)#interface range fa0/1, fa0/2
S2(config-if-range)#switchport mode trunk
S2(config-if-range)#no shutdown
S3(config-if-range)#interface range fa0/1, fa0/2
S3(config-if-range)#switchport mode trunk
S3(config-if-range)#no shutdown
```

#### Bước 4 : Cấu hình ip cho vlan quản lí trên các swithches :

```
S1(config)#interface vlan1
S1(config-if)#ip address 172.17.10.1 255.255.255.0
S1(config-if)#no shutdown
S2(config)#interface vlan1
S2(config-if)#ip address 172.17.10.2 255.255.255.0
S2(config-if)#no shutdown
S3(config)#interface vlan1
S3(config-if)#ip address 172.17.10.3 255.255.255.0
S3(config-if)#no shutdown
```


### Phần 3 : Cấu hình các PCs như trên mô hình:

- IP address
- Subnet mask
- Gateway

### Phần 4 : Cấu hình Spanning tree 

#### Bước 1 : Kiểm tra chế độ cấu hình mặc định của chuẩn 802.1D STP :

S1#show spanning-tree

```
VLAN0001
Spanning tree enabled protocol ieee
Root ID Priority 32769
Address 0019.068d.6980 This is the MAC address of the root switch
This bridge is the root
Hello Time 2 sec Max Age 20 sec Forward Delay 15 sec
Bridge ID Priority 32769 (priority 32768 sys-id-ext 1)
Address 0019.068d.6980
Hello Time 2 sec Max Age 20 sec Forward Delay 15 sec
Aging Time 300
Interface Role Sts Cost Prio.Nbr Type
---------------- ---- --- --------- -------- --------------------------------
Fa0/1 	  Desg FWD  19  128.3     P2p
Fa0/2     Desg FWD  19  128.4     P2p
Fa0/3     Desg FWD  19  128.5     P2p
```

**Switch S2** : 
![Imgur](https://i.imgur.com/70ZBVvG.jpg)

**Switch 3 làm tương tự**

#### Bước 2 : 

- Bridge ID, MAC address, system ID extension được lưu trong bản tin BPDU của mỗi Switch.
- Lệnh **Show spanning-tree** sẽ biểu thị giá trị của **Bridge ID Priority**


### Phần 5 : Quan sát sự phản hồi khi có sự thay đổi trong mô hình 802.1D STP 

#### Bước 1 :  Đặt các switches về chế độ **spanning-tree debug** sử dụng lệnh **debug spanning-tree events**

```
S1#debug spanning-tree events
Spanning Tree event debugging is on
S2#debug spanning-tree events
Spanning Tree event debugging is on
S3#debug spanning-tree events
Spanning Tree event debugging is on
```

#### Bước 2 : Cố tình tắt port Fa0/1 của S1

```
S1(config)#interface fa0/1
S1(config-if)#shutdown
```

#### Bước 3 :  Kiểm tra debug output từ S2 và S3 :

![Imgur](https://i.imgur.com/dzefX25.jpg)

When the link from S2 that is connected to the root switch goes down, what is its initial conclusion about
the spanning tree root?______________________
Once S2 receives new information on Fa0/2, what new conclusion does it draw?____________________
Port Fa0/2 on S3 was previously in a blocking state before the link between S2 and S1 went down. What
states does it go through as a result of the topology change? __________________________________


#### Bước 4 : Kiểm tra những thay đổi trong mô hình STP sử dụng lệnh **show spanning-tree**

S2#show spanning-tree

```
VLAN0001
Spanning tree enabled protocol ieee
Root ID Priority 32769
Address 0019.068d.6980
Cost 38
Port 2 (FastEthernet0/2)
Hello Time 2 sec Max Age 20 sec Forward Delay 15 sec
Bridge ID Priority 32769 (priority 32768 sys-id-ext 1)
Address 001b.0c68.2080
Hello Time 2 sec Max Age 20 sec Forward Delay 15 sec
Aging Time 300
Interface Role Sts Cost Prio.Nbr Type
---------------- ---- --- --------- -------- --------------------------------
Fa0/2     Root FWD 19    128.2    P2p
Fa0/6     Desg FWD 19    128.6    P2p
Fa0/11    Desg FWD 19    128.11   P2p
Fa0/18    Desg FWD 19    128.18   P2p
```

S3#show spanning-tree

```
VLAN0001
Spanning tree enabled protocol ieee
Root ID Priority 32769
Address 0019.068d.6980
Cost 19
Port 1 (FastEthernet0/1)
Hello Time 2 sec Max Age 20 sec Forward Delay 15 sec
Bridge ID Priority 32769 (priority 32768 sys-id-ext 1)
Address 001b.5303.1700
Hello Time 2 sec Max Age 20 sec Forward Delay 15 sec
Aging Time 300
Interface Role Sts Cost Prio.Nbr Type
---------------- ---- --- --------- -------- --------------------------------
Fa0/1 Root FWD 19 128.1 P2p
Fa0/2 Desg FWD 19 128.2 P2p
```

Answer the following questions based on the output.
1. What has changed about the way that S2 forwards traffic? __________________________________
2. What has changed about the way that S3 forwards traffic?___________________________________



### Phần 6 : Sử dụng lệnh **show run**, ghi lại cấu hình của mỗi switch :

S1#show run

```
!<output omitted>
!
hostname S1
!
!
interface FastEthernet0/1
switchport mode trunk
!
interface FastEthernet0/2
switchport mode trunk
!
interface FastEthernet0/3
switchport mode access
!
! <output omitted>
!
interface Vlan1
ip address 172.17.10.1 255.255.255.0
!
end
```


S2#show run

```
!<output omitted>
!
hostname S2
!
!
interface FastEthernet0/1
switchport mode trunk
!
interface FastEthernet0/2
switchport mode trunk
!
! <output omitted>
!
interface FastEthernet0/6
switchport mode access
!
interface FastEthernet0/11
switchport mode access
!
interface FastEthernet0/18
switchport mode access
!
!
interface Vlan1
ip address 172.17.10.2 255.255.255.0
!
end
```

S3#show run

```
!<output omitted>
!
hostname S3
!
!
interface FastEthernet0/1
switchport mode trunk
!
interface FastEthernet0/2
switchport mode trunk
!
!
! <output omitted>
!
interface Vlan1
ip address 172.17.10.3 255.255.255.0
!
end
```

Phần 7: Clean Up

- Xóa các cấu hình và tải lại cấu hình mặc định cho các thiết bị chuyển mạch. Ngắt kết nối và lưu trữ
cáp. 
- Đối với máy tính cá nhân thường kết nối với các mạng khác (như mạng LAN của trường học hoặc đến
Internet), kết nối lại cáp thích hợp và khôi phục cài đặt TCP / IP