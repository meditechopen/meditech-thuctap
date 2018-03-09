# Ghi chép file cấu hình Neutron

## Section [DEFAULT]

- auth_strategy = keystone

Loại hình xác thực

- core_plugin = None

plugin mà Neutron sẽ sử dụng

- dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq

Driver được sử dụng để quản lí DHCP server

- enable_isolated_metadata = False

DHCP server có thể hỗ trợ để cung cấp metadata trên các mạng riêng biệt

## Section [ml2]

- type_drivers = local, flat, vlan, gre, vxlan, geneve

Loại driver được sử dụng

- mechanism_drivers =

Cơ chế network sử dụng (OVS, LB)

## Section [ml2_type_flat]

- flat_networks = *

Tên mạng vật lý được dùng làm flat network

## Section [LINUX_BRIDGE]

- bridge_mappings =

<physical_network>:<physical_bridge>

- physical_interface_mappings =

<physical_network>:<physical_interface>

## Section [VXLAN]

- enable_vxlan = True

Kích hoạt VXLAN

- l2_population = False

Extension để sử dụng ml2 plugin’s l2population mechanism driver. Nó sẽ kích hoạt plugin để populate VXLAN forwarding table

- local_ip = None

Địa chỉ ip của overlay (tunnel) network endpoint.

## Section [OVS]

- bridge_mappings =

<physical_network>:<bridge>

## Section [SECURITYGROUP]

- enable_security_group = True

kích hoạt security group API

- firewall_driver = None

driver cho security groups firewall trong l2 agent


Xem thêm về các tùy chọn cấu hình tại:

https://docs.openstack.org/newton/config-reference/networking/networking_options_reference.html
