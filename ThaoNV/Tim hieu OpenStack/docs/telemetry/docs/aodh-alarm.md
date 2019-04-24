# Hướng dẫn bắn cảnh báo của aodh ra slack

## Mục lục

1. Tạo cảnh báo

2. Tạo webserver

------------------

## 1. Tạo cảnh báo

Ta sẽ tạo một cảnh báo với alarm action là http.

Ví dụ aodh sẽ cảnh báo nếu CPU vượt mức 70% và bắn cảnh báo tới địa chỉ webhook chỉ định.

```
aodh alarm create \
  --name cpu_hi \
  --type gnocchi_resources_threshold \
  --description 'instance running hot' \
  --metric cpu_util \
  --threshold 70.0 \
  --comparison-operator gt \
  --aggregation-method mean \
  --granularity 60 \
  --evaluation-periods 1 \
  --alarm-action http://192.168.100.49:5123/cpu \
  --ok-action http://192.168.100.49:5123/cpu \
  --resource-id b9cfbf49-ec5f-4c2b-9599-fcb463d5c5d2 \
  --resource-type instance
```

Cảnh báo sau sẽ xuất hiện nếu ram máy ảo dùng trên 500MB và alrm ở trạng thái ok

```
aodh alarm create \
  --name memory_hi \
  --type gnocchi_resources_threshold \
  --description 'memory alarm' \
  --metric memory.usage \
  --threshold 500.0 \
  --comparison-operator gt \
  --aggregation-method mean \
  --granularity 60 \
  --evaluation-periods 1 \
  --alarm-action 'http://192.168.100.49:5123/memory' \
  --ok-action 'http://192.168.100.49:5123/memory' \
  --resource-id b9cfbf49-ec5f-4c2b-9599-fcb463d5c5d2 \
  --resource-type instance
```

Cảnh báo được bắn tới là một đoạn mã json. Trên webhook ta sẽ chạy một đoạn code để "hứng" các cảnh báo này đồng thời đẩy nó ra slack để cảnh báo.

## 2. Tạo webserver

Trên phía server dùng để cảnh báo (192.168.100.49) mình chạy 1 đoạn code để gửi cảnh báo qua slack.

```
pip install flask
mkdir flask
cd flask
wget https://raw.githubusercontent.com/thaonguyenvan/meditech-thuctap/master/ThaoNV/Tim%20hieu%20OpenStack/docs/telemetry/scripts/aodh-alarm.py
chmod +x alarm_proxy.py
cd
export FLASK_APP=flask/alarm_proxy.py
flask run --host=0.0.0.0 --port=5123
```

Kiểm tra

<img src="https://i.imgur.com/MTrhzXm.png">
