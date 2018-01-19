# influxDB 

- Một số note ngắn gọn để ghi nhớ syntax query influxDB 
- Database metric được thu thập bởi collectd plugin virt 


### Hiển thị thông tin về một MEASUREMENTS

```sh
> select * from virt_value where host = '032d3fc6-7d95-b731-91b8-3031d32c81f6' and (time > now() - 1m) and type = 'virt_vcpu'
name: virt_value
time                host                                 instance       type      type_instance value
----                ----                                 --------       ----      ------------- -----
1516340662645778219 032d3fc6-7d95-b731-91b8-3031d32c81f6 cobbler-server virt_vcpu 0             103230000000
1516340662645854252 032d3fc6-7d95-b731-91b8-3031d32c81f6 cobbler-server virt_vcpu 1             184140000000
1516340662955606754 032d3fc6-7d95-b731-91b8-3031d32c81f6 cobbler-server virt_vcpu 0             103230000000
1516340662955615586 032d3fc6-7d95-b731-91b8-3031d32c81f6 cobbler-server virt_vcpu 1             184140000000
1516340672643795870 032d3fc6-7d95-b731-91b8-3031d32c81f6 cobbler-server virt_vcpu 0             103230000000
1516340672643951970 032d3fc6-7d95-b731-91b8-3031d32c81f6 cobbler-server virt_vcpu 1             184140000000
1516340672953629956 032d3fc6-7d95-b731-91b8-3031d32c81f6 cobbler-server virt_vcpu 0             103230000000
1516340672953652497 032d3fc6-7d95-b731-91b8-3031d32c81f6 cobbler-server virt_vcpu 1             184140000000
1516340682655920262 032d3fc6-7d95-b731-91b8-3031d32c81f6 cobbler-server virt_vcpu 0             103240000000
1516340682656007193 032d3fc6-7d95-b731-91b8-3031d32c81f6 cobbler-server virt_vcpu 1             184150000000
1516340682945579114 032d3fc6-7d95-b731-91b8-3031d32c81f6 cobbler-server virt_vcpu 0             103240000000
1516340682945589624 032d3fc6-7d95-b731-91b8-3031d32c81f6 cobbler-server virt_vcpu 1             184150000000
```

### Danh sách các MEASUREMENTS đã thu thập 

```sh 
> SHOW MEASUREMENTS
name: measurements
name
----
cpu_value
df_value
disk_io_time
disk_read
disk_value
disk_weighted_io_time
disk_write
entropy_value
interface_rx
interface_tx
irq_value
load_longterm
load_midterm
load_shortterm
memory_value
processes_value
swap_value
users_value
virt_read
virt_rx
virt_tx
virt_value
virt_write
vmem_in
vmem_majflt
vmem_minflt
vmem_out
vmem_value
```
 

### List tag keys của từng MEASUREMENTS

```sh 
> show tag keys from virt_value

name: virt_value
tagKey
------
host
instance
type
type_instance
```

### Hiển thị giá trị trong tag keys 

```sh 
> show tag values from virt_value with key = host 

name: virt_value
key  value
---  -----
host 032d3fc6-7d95-b731-91b8-3031d32c81f6
host 0ead5100-68dc-419e-44a1-836a0189fa98
host 0f58a110-9f1b-f8fc-6e88-7bf0280114f9
host 139bce83-aae5-aa6f-0c51-b19cce3147e4
host 1ccf28d7-fcb5-d7cc-fc5d-92392af23265
host 2c491595-5647-de1c-473e-4efcb7c1f321
host 2d5c50ac-8839-05fb-0aef-7d600b784587
host 378ec024-20ba-98bd-9a45-3ece38f5dfc7
host 45b031e5-01e7-42c2-ee52-cc82beda3126
host 5111ee5b-49ae-1848-737b-0202406e167c
host 5429157e-df44-268c-03ed-9dbb64b49c20
host 5453512c-43c9-b216-30dd-1bda5b358cbf
host 746d8447-af09-99bd-6307-e07edf642d58
host 781c5136-7d79-45c4-37d3-be6c015d8cf0
host d0568a96-7283-beb8-08e0-50149d75a00a
host d54290b4-db1f-a978-2b9d-fbe1296bda18
host e010292f-0751-70e9-2d6e-1472a868a4eb
``` 
### Show kiểu dữ liệu của từng MEASUREMENTS

```sh
> show FIELD KEYS from virt_value
name: virt_value
fieldKey fieldType
-------- ---------
value    float
```

## Function 

### Count 

EXP 1: Returns the number of non-null field values.

```sh
> select count(value) from virt_value where host = '032d3fc6-7d95-b731-91b8-3031d32c81f6' and type = 'virt_vcpu' and type_instance = '1'
name: virt_value
time count
---- -----
0    3707
```

### mean()

Returns the arithmetic mean (average) for the values in a single field. The field type must be int64 or float64.

- Example 1: Calculate the mean field value associated with a field key

```sh 
> select mean(value) from virt_value where host = '032d3fc6-7d95-b731-91b8-3031d32c81f6' and type = 'virt_vcpu' and type_instance = '1'

name: virt_value
time mean
---- ----
0    178770002663.82526
```

```sh 
select mean(value) from virt_value where host = '032d3fc6-7d95-b731-91b8-3031d32c81f6' and type = 'virt_vcpu' and type_instance = '1'group by time(10s)
```

### MEDIAN

Returns the middle value from the sorted values in a single field.

```sh
> select MEDIAN(value) from virt_value where host = '032d3fc6-7d95-b731-91b8-3031d32c81f6' and type = 'virt_vcpu' and type_instance = '1'
name: virt_value
time median
---- ------
0    179090000000
```
