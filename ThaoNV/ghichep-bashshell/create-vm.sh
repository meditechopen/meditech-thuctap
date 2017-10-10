#!/bin/bash

echo "Thuc thi bien moi truong"

source ~/keystonerc_admin

sleep 3

echo "Create network"
sleep 3

neutron net-create external_network --provider:network_type flat \
--provider:physical_network extnet  \
--router:external \
--shared

sleep 3

echo "Tao subnet"

neutron subnet-create --name public_subnet --enable_dhcp=True --dns-nameserver 8.8.8.8 --allocation-pool start=192.168.100.43,end=192.168.100.49 --gateway=192.168.100.1 external_network 192.168.100.0/24

sleep 3

echo "Tao private network"

neutron net-create private_network
neutron subnet-create --name private_subnet private_network 10.10.10.0/24 \
--dns-nameserver 8.8.8.8

sleep 3

echo "Tao router va gan interface"

openstack router create Vrouter

sleep 3

neutron router-gateway-set Vrouter external_network

sleep 3

neutron router-interface-add Vrouter private_subnet

sleep 3

echo "Tao security group rules"

project=`openstack project list | grep admin | awk '{print $2}'`

group=`openstack security group list |grep $project | awk '{print $2}'`

openstack security group rule create --proto icmp $group

sleep 3

openstack security group rule create --proto tcp --dst-port 1:65535 $group

sleep 3

openstack security group rule create --proto udp --dst-port 1:65535 $group

sleep 3

echo "Tao keypair key1"

openstack keypair create key1 > private_key1

sleep 3

echo "He thong da san sang de tao may ao"
echo "Bat dau tao may ao voi provider network"

sleep 3

provider=`openstack network list | grep external_network | awk '{print $2}'`

openstack server create --flavor m1.tiny --image cirros \
    --nic net-id=$provider --security-group $group vm01