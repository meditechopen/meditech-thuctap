# Tìm hiểu các main options trong file config của Nova

- Đặt tại /etc/nova/nova.conf

- Các file log của nova:
  - service nova-* trên node controller: /var/log/nova
  - service libvirt và console (boot up message) cho VM trên node compute: /var/log/libvirt/libvirtd.log và /var/lib/nova/instances/instance-<instance-id>/console.log

- Địa chỉ management IP của node controller

`[DEFAULT]
my_ip = 10.0.2.15`

- Kích hoạt support cho dịch vụ netwoking.

`[DEFAULT]
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver`

- Khai báo dịch vụ Identity

`auth_uri` : public Identity API endpoint

`auth-url` : admin Identity API endpoint

`[DEFAULT]
auth_strategy = keystone
[keystone_authtoken]
auth_uri = http:// 10.0.2.15:5000
auth_url = http:// 10.0.2.15:35357
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = openstack`

- Kết nối tới Nova database

`[api_database]
connection=mysql+pymysql://nova_
api:password@10.0.2.15/nova_api
[database]
connection=mysql+pymysql://
nova:password@10.0.2.15/nova`

- Khai báo địa chỉ, port, username, password cho RabbitMQ

`[DEFAULT]
rpc_backend = rabbit
[oslo_messaging_rabbit]
rabbit_host = localhost
rabbit_port = 5672
rabbit_userid = guest
rabbit_password = guest`


Lưu ý: tại những phiên bản mới, chỉ cần khai báo kết nối:

`[DEFAULT]
...
transport_url = rabbit://openstack:RABBIT_PASS@controller`

- Khai báo địa chỉ management IP của VNC proxy

`[vnc]
 vncserver_listen = $my_ip
 vncserver_proxyclient_address = $my_ip`

- Khai báo địa chỉ Image service API

`[glance]
 api_servers=10.0.2.15:9292`
