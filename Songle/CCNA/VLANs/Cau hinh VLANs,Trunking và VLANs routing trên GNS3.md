# Hướng dẫn cấu hình VLANs, Trunking và VLANs routing trên GNS3 

## 1.	Mô hình bài lab: 
4 Switch trong đó switch L3-SW-1 và L3-SW-2 được kết nối với nhau và sử dụng etherchannel port. L3-SW1 đóng vai trò là VTP server, các switch còn lại đóng vai trò VTP client. VLANs sẽ được tạo trên Switch L3-SW1 (vtp server) sau đó sẽ update xuống các switch còn lại (vtp client).,
![Mô hình](http://i.imgur.com/BUEDlca.png)

## 2.	Triển khai cấu hình :
-	Download và cài đặt GNS3
http://itlabvn.net/phan-cung-mang/huong-dan-su-dung-phan-men-gia-lap-routers-switch-gns3
-	Tạo 1 project mới : File => New blank project => đặt tên là Trunking project
Kéo thả các thiết bị cần thiết vào :  4 VPCS, 2 L2-SW, 2 L3-SW, 1 Router
-	L3-SW1 đóng vai trò là VTP Client , Vlans sẽ được tạo trên nó rồi update xuống các switch còn lại
-	Tiến hành nối dây các thiết bị với nhau theo sơ đồ 
-	Cấu hình VTP cho Switch:

### Bước 1. Cấu hình VTP cho các switch
* Cấu hình VTP mode server và domain cisco trên Switch L3-SW1
```
L3-SW1(config)#hostname L3-SW1
L3-SW1(config)#vtp mode server
L3-SW1(config)#vtp domain cisco
L3-SW1(config)#vtp password cisco
L3-SW1(config)#vtp pruning
```
* Cấu hình VTP mode client trên switch L2-SW1 và L2-SW2 và L3-SW2

```
L2-SW1(config)#hostname L2-SW1
L2-SW1(config)#vtp mode client
L2-SW1(config)#vtp domain cisco
L2-SW1(config)#vtp password cisco
```

* Switch L2-SW2

``` 
L2-SW2(config)#hostname L2-SW2
L2-SW2(config)#vtp mode client
L2-SW2(config)#vtp domain cisco
L2-SW2(config)#vtp password cisco
```

* Switch L3-SW2

```
L3-SW2(config)#hostname L3-SW2
L3-SW2(config)#vtp mode client
L3-SW2(config)#vtp domain cisco
L3-SW2(config)#vtp password cisco
```

### Bước 2: Cấu hình VLAN trên VTP server ( L3-SW1 )

```
L3-SW1#config t
L3-SW1(config)#vlan 10
L3-SW1(config-vlan)#name HR
L3-SW1(config)#vlan 20
L3-SW1(config-vlan)#name ADMIN
L3-SW1(config)#vlan 30
L3-SW1(config-vlan)#name IT
```

* Kiểm tra cấu hình vlan trên VTP mode Server ( L3-SW1 ) và VTP mode client ( L2-SW1 )

* L3-SW1#show vlan brief

```
VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Gi0/2, Gi0/3, Gi1/0, Gi1/1
                                                Gi1/2, Gi1/3, Gi2/0, Gi2/1
                                                Gi2/2, Gi2/3, Gi3/0, Gi3/1
                                                Gi3/2, Gi3/3
10   HR                               active
20   IT                               active
30   ADMIN                            active
1002 fddi-default                     act/unsup
1003 trcrf-default                    act/unsup
1004 fddinet-default                  act/unsup
1005 trbrf-default                    act/unsup
L2-SW1#show vlan brief

VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Gi0/1, Gi0/2, Gi0/3, Gi1/0
                                                Gi1/1, Gi1/2, Gi1/3, Gi2/0
                                                Gi2/1, Gi2/2, Gi2/3, Gi3/0
                                                Gi3/1, Gi3/2, Gi3/3
10   HR                               active
20   IT                               active
30   ADMIN                            active
100  VLAN100                          active
200  VLAN0200                         active
300  VLAN0300                         active
1002 fddi-default                     act/unsup
1003 trcrf-default                    act/unsup
1004 fddinet-default                  act/unsup
1005 trbrf-default                    act/unsup
```

### Bước 3: Cấu hình trunk port trên các switch 


* Switch L2-SW1

```
L2-SW1(config)#interface range G0/0,G0/3
L2-SW1(config-if-range)#switchport trunk encapsulation dot1q
L2-SW1(config-if-range)#switchport mode trunk
L2-SW1(config-if-range)#switchport trunk allowed vlan 10,20,30
```

* Switch L2-SW2

```
L2-SW2(config)#interface range G0/0,G0/3
L2-SW2(config-if-range)#switchport trunk encapsulation dot1q
L2-SW2(config-if-range)#switchport mode trunk
L2-SW2(config-if-range)#switchport trunk allowed vlan 10,20,30
```

* Switch L3-SW1

- Cấu hình etherchannel

```
L3-SW1(config)#interface range G0/1 - 2
L3-SW1(config-if-range)#channel-protocol lacp
L3-SW1(config-if-range)#channel-group 1 mode active
Creating a port-channel interface Port-channel 1
```

- Kiểm tra cấu hình etherchannel

```
L3-SW1(config)#interface range G0/1 - 2
L3-SW1(config-if-range)#channel-protocol lacp
L3-SW1(config-if-range)#channel-group 1 mode active
Creating a port-channel interface Port-channel 1
```

- Kiểm tra cấu hình etherchannel

`L3-SW1#show etherchannel summary`

```  
Port-channel  Protocol    Ports
------+-------------+-----------+-----------------------------------------------
      Po1(SU)         LACP      Gi0/1(P)    Gi0/2(P)
L3-SW1#show ip interface brief
Interface              IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0     unassigned      YES unset  up                    up
GigabitEthernet0/1     unassigned      YES unset  up                    up
GigabitEthernet0/2     unassigned      YES unset  up                    up
Port-channel1             unassigned      YES unset  up                    up
L3-SW1#show interface Po 1
Port-channel1 is up, line protocol is up (connected)
  Hardware is GigabitEthernet, address is 00d3.84dc.da05 (bia 00d3.84dc.da05)
  MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 10 usec,
  ```
 


* Cấu hình trunking 

```
L3-SW1(config)#interface range G0/0, G0/3, G0/1-2, Po1
L3-SW1(config-if-range)#switchport trunk encapsulation dot1q
L3-SW1(config-if-range)#switchport mode trunk
L3-SW1(config-if-range)#switchport trunk allowed vlan 10,20,30
L3-SW1(config-if-range)#no shut
```

* Switch L3-SW2
```
L3-SW2(config)#interface range G0/0, G0/3, G0/1-2, Po1
L3-SW2(config-if-range)#switchport trunk encapsulation dot1q
L3-SW2(config-if-range)#switchport mode trunk
L3-SW2(config-if-range)#switchport trunk allowed vlan 10,20,30
L3-SW2(config-if-range)#no shut
```

- Cấu hình etherchannel 

```
L3-SW2(config)#interface range G0/1 - 2
L3-SW2(config-if-range)#channel-protocol lacp
L3-SW2(config-if-range)#channel-group 1 mode passive
Creating a port-channel interface Port-channel 1
```

- Kiểm tra etherchannel

`L2-SW2#show etherchannel summary`

```
Group  Port-channel  Protocol    Ports
------+-------------+-----------+-----------------------------------------------
      Po1(SU)         LACP      Gi0/1(P)    Gi0/2(P)
L2-SW2#show ip interface brief
Interface              IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0     unassigned      YES unset  up                    up
GigabitEthernet0/1     unassigned      YES unset  up                    up
GigabitEthernet0/2     unassigned      YES unset  up                    up
Port-channel1             unassigned      YES unset  up                    up
```

* L2-SW2#show interface Po 1

```
Port-channel1 is up, line protocol is up (connected)
  Hardware is GigabitEthernet, address is 00d3.84a7.0405 (bia 00d3.84a7.0405)
  MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 10 usec,
  ```
 
* Cấu hình trunk port

```
L3-SW2(config-if-range)#int range G0/0,G0/3, G0/1-2, Po1
L3-SW2(config-if-range)#switchport trunk encapsulation dot1q
L3-SW2(config-if-range)#switchport mode trunk
L3-SW2(config-if-range)#switchport trunk allowed vlan 10,20,30
L3-SW2(config-if-range)#no shut
```

### Bước 4:  Cấu hình VLANs routing và switch access vlan trên switch L3-SW1, L2-SW1 và L2-SW2 
```
L3-SW1(config)#int vlan 10
L3-SW1(config-if)#ip add 192.168.10.1 255.255.255.0
L3-SW1(config)#int vlan 20
L3-SW1(config-if)#ip add 192.168.20.1 255.255.255.0
L3-SW1(config)#int vlan 30
ip add 192.168.30.1 255.255.255.0
```

* L3-SW1(config)#ip routing

* Cấu hình Switch access vlan interfaces trên L2-SW1 & L2-SW2

```
L2-SW1(config)#int G0/1
L2-SW1(config-if)#switchport mode access
L2-SW1(config-if)#switchport access vlan 10
L2-SW1(config)#int G0/2
L2-SW1(config-if)#switchport mode access
L2-SW1(config-if)#switchport access vlan 20
```
 
```
L2-SW2(config)#int G0/1
L2-SW2(config-if)#switchport mode access
L2-SW2(config-if)#switchport access vlan 10
L2-SW2(config)#int G0/2
L2-SW2(config-if)#switchport mode access
L2-SW2(config-if)#switchport access vlan 20
```

### Bước 5: Cấu hình địa chỉ ip address cho các PC

```
PC1> ip 192.168.10.10/24 192.168.10.1
Checking for duplicate address...
PC1 : 192.168.10.10 255.255.255.0 gateway 192.168.10.1
```
```
PC2> ip 192.168.20.10/24 192.168.20.1
Checking for duplicate address...
PC2 : 192.168.20.10 255.255.255.0 gateway 192.168.20.1
```
```
PC3> ip 192.168.10.20/24 192.168.10.1
Checking for duplicate address...
PC3 : 192.168.10.20 255.255.255.0 gateway 192.168.10.1
```
```
PC4> ip 192.168.20.20/24 192.168.20.1
Checking for duplicate address...`
PC4 : 192.168.20.20 255.255.255.0 gateway 192.168.20.1
```

### Bước 6: Kiểm tra kết quả từ PC1 ta thấy ping giữa VLAN 10 và VLAN 20 thành công -> VLAN routing successful

```
PC1> ping 192.168.10.1
84 bytes from 192.168.10.1 icmp_seq=1 ttl=255 time=34.002 ms
84 bytes from 192.168.10.1 icmp_seq=2 ttl=255 time=53.003 ms
84 bytes from 192.168.10.1 icmp_seq=3 ttl=255 time=18.001 ms
84 bytes from 192.168.10.1 icmp_seq=4 ttl=255 time=9.001 ms
```
```
PC1> ping 192.168.10.20
84 bytes from 192.168.10.20 icmp_seq=1 ttl=64 time=90.005 ms
84 bytes from 192.168.10.20 icmp_seq=2 ttl=64 time=59.003 ms
84 bytes from 192.168.10.20 icmp_seq=3 ttl=64 time=91.005 ms
84 bytes from 192.168.10.20 icmp_seq=4 ttl=64 time=84.005 ms
```
```
PC1> ping 192.168.20.1
84 bytes from 192.168.20.1 icmp_seq=1 ttl=255 time=23.001 ms
84 bytes from 192.168.20.1 icmp_seq=2 ttl=255 time=23.001 ms
84 bytes from 192.168.20.1 icmp_seq=3 ttl=255 time=96.006 ms
84 bytes from 192.168.20.1 icmp_seq=4 ttl=255 time=40.002 ms
```
```
PC1> ping 192.168.20.20
84 bytes from 192.168.20.20 icmp_seq=2 ttl=63 time=101.005 ms
84 bytes from 192.168.20.20 icmp_seq=3 ttl=63 time=107.006 ms
84 bytes from 192.168.20.20 icmp_seq=4 ttl=63 time=146.008 ms
84 bytes from 192.168.20.20 icmp_seq=5 ttl=63 time=112.006 ms
```


