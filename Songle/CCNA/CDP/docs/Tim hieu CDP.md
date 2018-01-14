# Cisco Discovery Protocol


## 1.  CDP là gì?

- CPD ( Cisco Discovery Protocol) là một giao thức lớp 2 ( Data Link Layer) hoạt động trên các thiết bị 
Cisco cho phép thu thập thông tin về các thiết bị lân cận (router, switch, bridge, access server) như : *hostname*, *address list*, *port id*, *platform*.

	- Các thông tin này rất hữu ích khi xử lý sự cố hoặc kiểm soát thiết bị trong hệ thống mạng. 
	
-  Mỗi một thiết bị đã cấu hình CDP sẽ gửi các thông điệp theo chu kỳ dưới dạng địa chỉ multicast, để quảng bá ít nhất một địa chỉ mà nó có thể nhận các SNMP message.
 Quá trình quảng bá cũng chứa time-to-live (TTL), hoặc thông tin holdtime, holdtime là thời gian mà một thiết bị nhận được một thông tin CDP 
 về một thiết bị khác và lưu trữ chúng trước khi quyết định hủy thông tin đó đi. Mỗi thiết bị cũng luôn lắng nghe những message được gửi bởi 
 những thiết bị khác để học thông tin về hàng xóm của những thiết bị đó.

- Trên một switch, CDP đã enable Network Assistant để hiển thị một bản đồ về một mạng nào đó. 
Switch sử dụng CDP để tìm kiếm những cluster candidate và duy trì những thông tin về các thành viên của cluster đó.
- Các switch có khả năng hỗ trợ CDP version 2.

## 2. Cấu hình CDP

### 2.1. Cấu hình CDP mặc định

![Imgur](https://i.imgur.com/U0EHWWg.png)

### 2.2. Cấu hình các đặc tính CDP

- Bạn có thể cấu hình lại thời gian để update các CDP message, và thời gian để lưu trữ những thông tin đó trước khi quyết định hủy thông tin đó đi.
- Bắt đầu cấu hình ở chế độ Privileged EXEC trên switch, bạn sẽ thực hiện các bước sau để cấu hình lại CDP timer, holdtime và advertisement type.

![Imgur](https://i.imgur.com/dBdQ4Oe.png)

example:
```
Switch_3560_VNE# configure terminal
Switch_3560_VNE(config)# cdp timer 50
Switch_3560_VNE(config)# cdp holdtime 120
Switch_3560_VNE(config)# cdp advertise-v2
Switch_3560_VNE(config)# end
Switch_3560_VNE# show cdp
Switch_3560_VNE# copy run start
```

- Sử dụng từ khóa **no** trước các câu lệnh của CDP để trở về những tham số mặc định.


### 2.3. Bật và tắt CDP

![Imgur](https://i.imgur.com/7Dab7sN.png)

- CDP được enable theo mặc định.

- Các bạn có thể thực hiện những bước sau để disable CDP.
example:

```
Switch_3560_VNE# configure terminal
Switch_3560_VNE(config)# no cdp run
Switch_3560_VNE(config)# end
```

- Để enable CDP trở lại hoạt động, bạn sử dụng những câu lệnh dưới đây:
example:

```
Switch_3560_VNE# configure terminal
Switch_3560_VNE(config)# cdp run
Switch_3560_VNE(config)# end
```

### 2.4. Disable và Enable CDP.

- CDP được enable theo mặc định.

- Các bạn có thể thực hiện những bước sau để disable CDP.
example:
Switch_3560_VNE# configure terminal
Switch_3560_VNE(config)# no cdp run
Switch_3560_VNE(config)# end

- Để enable CDP trở lại hoạt động, bạn sử dụng những câu lệnh dưới đây:
example:
Switch_3560_VNE# configure terminal
Switch_3560_VNE(config)# cdp run
Switch_3560_VNE(config)# end

### 2.5. Disable và Enable CDP trên một interface.


- CDP được enable mặc định trên tất cả các interface để gửi và nhận các thông tin CDP.

- Để disable CDP trên một interface nào đó, sử dụng những câu lệnh sau:

![Imgur](https://i.imgur.com/o4hXwAP.png)

example:
Switch_3560_VNE# configure terminal
Switch_3560_VNE(config)# interface fastethernet 0/22
Switch_3560_VNE(config-if)# no cdp enable
Switch_3560_VNE(config-if)# end
Switch_3560_VNE# copy run start

- Để enable CDP hoạt động trở lại trên một interface nào đó, thì bạn có thể dùng những lệnh sau:

example:

```
Switch_3560_VNE# configure terminal
Switch_3560_VNE(config)# interface fastethernet 0/24
Switch_3560_VNE(config-if)# cdp enable
Switch_3560_VNE(config-if)# end
Switch_3560_VNE# copy run start
```

### 2.6. Giám sát và duy trì CDP.

- Để có thể giám sát và duy trì sự hoạt động của CDP trên thiết bị của bạn, thì bạn có thể thi hành một trong những câu lệnh sau:

![Imgur](https://i.imgur.com/rtFtJUe.png)

example:

```
Switch_3560_VNE# clear cdp counters
Switch_3560_VNE# clear cdp table
Switch_3560_VNE# show cdp
Switch_3560_VNE# show cdp entry
Switch_3560_VNE# show cdp interface fa/23
Switch_3560_VNE# show cdp neighbors detail
Switch_3560_VNE# show cdp traffic
```

#### Tham khảo: 

https://www.cisco.com/c/en/us/td/docs/routers/access/3200/software/wireless/3200WirelessConfigGuide/CiscoDiscovProto.pdf
