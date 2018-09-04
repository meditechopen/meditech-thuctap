# Hướng dẫn monitor weblogic

- Cài weblogic theo link sau:

http://www.oracle.com/webfolder/technetwork/tutorials/obe/fmw/wls/12c/12_2_1/01-02-002-InstallWLSGeneric/installwlsgeneric.html#section2

Lưu ý:

Cần cài GNOME

jdk1.8.0_181/bin/java -Djava.awt.headless=true -jar fmw_12.2.1.0.0_wls.jar

yum install xorg-x11-* -y và reboot lại máy

https://access.redhat.com/solutions/24464

- Sau khi cài xong, copy 2 file jolokia.cfg và mk_jolokia để vào lần lượt /etc/check_mk/ và /usr/lib/check_mk_agent/plugins/.

Chỉnh sửa file jolokia.cfg để phù hợp, ví dụ:

```
server = "127.0.0.1"
user = "None"
password = "None"
mode = "digest"
suburi = "jolokia"
instance = None
port = 7001
```

- Tải jolokia.war tại link Sau

https://jolokia.org/download.html

- Deploy thông qua giao diện web tại địa chỉ:

http://xxx:7001/console

- Tiến hành chạy thử script đặt tại /usr/lib/check_mk_agent/plugins/. Nếu chưa được, kiểm tra lại phần cấu hình.
