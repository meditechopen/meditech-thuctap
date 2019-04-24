# Hướng dẫn sử dụng local check

Local check là kĩ thuật cho phép bạn tự viết các script (thường là bằng shell). Các script này sẽ được đặt ở thư mục mà checkmk agent có thể scan được. Đối với Linux, nó thường được đặt ở `/usr/lib/check_mk_agent/local`. Nếu bạn không chắc, bạn có thể xem bằng câu lệnh sau:

`check_mk -d monitor_host | head`

<img src="https://i.imgur.com/LDKfdpy.png">

## Hướng dẫn sử dụng local check để check file log update

Kịch bản: Nếu file log không update trong một khoảng thời gian nhất định thì sẽ có cảnh báo warning hoặc critical.

Tiến hành đặt script vào thư mục `/usr/lib/check_mk_agent/local`

`vi /usr/lib/check_mk_agent/local/checkupdate`

```
#!/bin/sh

# Input file
FILE=/var/log/auth.log

# Get current and file times
CURTIME=$(date +%s)
FILETIME=$(stat $FILE -c %Y)
TIMEDIFF=$(expr $CURTIME - $FILETIME)

# Check if file older
if [ $TIMEDIFF -lt 30 ]; then
   status=0
   statustxt=OK
elif [ $TIMEDIFF -lt 60 ]; then
   status=1
   statustxt=WARNING
else
   status=2
   statustxt=CRITICAL
fi
echo "$status Check_log_update_$FILE time=$TIMEDIFF; $statustxt - File is not update in $TIMEDIFF seconds"
```

Phân quyền

`chmod +x /usr/lib/check_mk_agent/local/checkupdate`

Chạy thử script

<img src="https://i.imgur.com/ZMxDOjW.png">

Discover trên check mk

<img src="https://i.imgur.com/QHYFgmi.png">
