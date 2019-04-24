# Hướng dẫn cấu hình sử dụng VLAN cho tenant networks

Đối với tenant networks, người ta thường sử dụng các công nghệ như vxlan hoặc gre bởi số lượng lớn dải mạng mà nó có thể tạo ra. Tuy nhiên performance của network sẽ bị giảm do ip header bị gán thêm 1 trường id nữa. Ngoài ra nếu người dùng muốn kết nối máy ảo với máy ảo hoặc máy vật lí bên ngoài cũng sẽ khó khăn hơn trong quá trình cấu hình.

Chính vì thế ta có thể sử dụng vlan cho tenant network, tuy nhiên do số lượng id vlan có hạn nên cần cân nhắc trước khi sử dụng.

Để cấu hình sử dụng vlan cho tenant network, ta cần có 1 dải data vm được gán vào các máy compute.

Cấu hình trên node controller:

File `/etc/neutron/plugins/ml2/ml2_conf.ini`

```
[DEFAULT]
[l2pop]
[ml2]
type_drivers = flat,vlan,vxlan
tenant_network_types = vlan
mechanism_drivers = openvswitch,l2population
extension_drivers = port_security
[ml2_type_flat]
flat_networks = provider
[ml2_type_geneve]
[ml2_type_gre]
[ml2_type_vlan]
network_vlan_ranges = vlan:100:200
[ml2_type_vxlan]
[securitygroup]
enable_ipset = True
```

- Trên node compute

Thêm 1 bridge mới và gán interface của dải data vm vào

```
ovs-vsctl add-br br-vlan
ovs-vsctl add-port br-vlan eth3
```

Xóa file cấu hình của interface

`rm -rf /etc/sysconfig/network-scripts/ifcfg-eth3`

Thêm mới file cấu hình cho interface

```
cat << EOF >> /etc/sysconfig/network-scripts/ifcfg-eth3
DEVICE=eth3
NAME=eth3
DEVICETYPE=ovs
TYPE=OVSPort
OVS_BRIDGE=br-vlan
ONBOOT=yes
BOOTPROTO=none
NM_CONTROLLED=no
EOF
```

Thêm mới file cấu hình cho bridge

```
cat << EOF >> /etc/sysconfig/network-scripts/ifcfg-br-vlan
ONBOOT=yes
DEVICE=br-vlan
NAME=br-vlan
DEVICETYPE=ovs
OVSBOOTPROTO=none
TYPE=OVSBridge
EOF
```

Restart lại network

`systemctl restart network`

Cấu hình trong file `/etc/neutron/plugins/ml2/openvswitch_agent.ini`

```
[DEFAULT]
[agent]
l2_population = True
[network_log]
[ovs]
bridge_mappings = provider:br-provider,vlan:br-vlan
[securitygroup]
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
[xenapi]
```

- Restart lại neutron trên cả node ctl và com

`systemctl restart neutron-*`

- Tiến hành tạo thử tenant network với dải mạng tùy chọn. Sau khi tạo xong, ta sẽ thấy id của VLAN

<img src="https://i.imgur.com/IOdPd3S.png">

- Tiến hành gán dải mạng data vm vào một máy bất kì, config vlan theo id của network vừa tạo trên OpenStack.

<img src="https://i.imgur.com/j88YoSd.png">

- Tạo một vm với dải mạng vừa tạo, tiến hành kiểm tra và ping tới máy ở bên ngoài OPS mà ta vừa cấu hình.

<img src="https://i.imgur.com/4P8bNRB.png">

**Lưu ý:** Port đấu nối với card data vm trên sw phải được cấu hình mode trunk. Ngoài ra ta cũng cần khai báo vlan theo đúng id vlan mà chúng ta thấy trên OPS. Ta chỉ có thể xem id này sau khi network được tạo bởi hiện tại neutron không cho phép ta specify id của vlan khi tạo tenant network.
