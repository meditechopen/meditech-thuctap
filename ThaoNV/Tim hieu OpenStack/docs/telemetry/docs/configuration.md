# Một số cấu hình cho Ceilometer

## Mục lục

1. Data collection

2. Data processing and pipelines

--------------

Như đã nói, dữ liệu được thu thập chính từ 2 cách đó là Notifications và Polling.

**Notifications**

Tất cả các service của OPS gửi thông báo về các chương trình đang hoạt động hoặc trạng thái của hệ thống.

Mặc định, notification agent được cấu hình để xây dựng cả sample lẫn events. Thêm vào đó, notification agent cũng chịu trách nhiệm cho việc xử lí data như transformation và publishing. Sau khi được xử lí, dữ liệu sẽ được gửi đi các publisher target như gnocchi và panko. Những service này sẽ giữ dữ liêu trong db.

**Meter definitions**

Telemetry service thu thập một danh sách các meter bằng cách filter notification được đưa ra bởi các service của OpenStack. Bạn có thể xem meter definitions trong file `ceilometer/data/meters.d/meters.yaml`.

Bạn cũng có thể load file definition và cho phép user thêm meter def riêng cuả họ vào bằng cách thêm file vào `/etc/ceilometer/meters.d`

Một meter definition tiêu chuẩn:

```
---
metric:
  - name: 'meter name'
    event_type: 'event name'
    type: 'type of meter eg: gauge, cumulative or delta'
    unit: 'name of unit eg: MB'
    volume: 'path to a measurable value eg: $.payload.size'
    resource_id: 'path to resource id eg: $.payload.id'
    project_id: 'path to project id eg: $.payload.owner'
    metadata: 'addiitonal key-value data describing resource'
```

**Polling**

Một số thông tin không thể lấy được một cách trực tiếp ví dụ như các thông số sử dụng của VM.

Vì thể Telemetry dùng một phương án khác đó là sử dụng agent để cài lên các máy compute.

Các polling rules được define trong file `polling.yaml`. Một polling def:

```
---
sources:
  - name: 'source name'
    interval: 'how often the samples should be generated'
    meters:
      - 'meter filter'
    resources:
      - 'list of resource URLs'
    discovery:
      - 'list of discoverers'
```

## 2. Data processing and pipelines

**Pipeline configuration**

Như ta đã biết, pipeline chính là cách mà dữ liệu được xử lí. Quá trình này được phụ trách bởi notification agent.

notification agent hỗ trợ 2 pipeline, một cho sample và một cho events. Pipeline có thể được enabled hoặc disable trong section [notifications]

Mỗi một pipeline có 1 file cấu hình riêng, đó là pipeline.yaml and event_pipeline.yaml.

Một meter pipeline def :

```
---
sources:
  - name: 'source name'
    meters:
      - 'meter filter'
    sinks:
      - 'sink name'
sinks:
  - name: 'sink name'
    transformers: 'definition of transformers'
    publishers:
      - 'list of publishers'
```

Các transformers mà ceilometer đang cung cấp:

| Name of transformer | Reference name for configuration |
|---------------------|----------------------------------|
| Accumulator | accumulator |
| Aggregator | aggregator |
| Arithmetic | arithmetic |
| Rate of change | rate_of_change |
| Unit conversion | unit_conversion |
| Delta | delta |

**publisher**

Các publisher được dùng để lưu lại dữ liệu hoặc gửi nó tới các hệ thống bên ngoài khác. Các loại publisher đang được ceilometer hỗ trợ:

- gnocchi: Mặc định, lữu trữ measurement và resource information
- panko: Cung cấp HTTP REST interface để query system event
- notifier: Gửi dữ liệu ra AMQP sử dụng oslo.messaging.
- udp: gửi dữ liệu qua udp
- file: ghi data vào file.
- http: gửi sample tớiexternal HTTP target.
