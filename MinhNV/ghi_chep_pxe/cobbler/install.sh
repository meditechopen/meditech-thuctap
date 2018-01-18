# Services IP Address on the server
IP_ADDR=192.168.100.93
NETMASK=255.255.255.0
NETDEVICE=eth0
NETPREFIX=24
NETWORK=192.168.100.0

# DHCP Server IP Range. First and Last
DHCP_MIN_HOST=192.168.100.10
DHCP_MAX_HOST=192.168.100.20

### install
yum install epel-release -y
yum install cobbler cobbler-web dnsmasq syslinux pykickstart xinetd bind bind-utils dhcp debmirror pykickstart fence-agents-all -y


systemctl start cobblerd
systemctl enable cobblerd
systemctl start httpd
systemctl enable httpd


sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/selinux/config
setenforce 0


firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=443/tcp --permanent
firewall-cmd --add-service=dhcp --permanent
firewall-cmd --add-port=69/tcp --permanent
firewall-cmd --add-port=69/udp --permanent
firewall-cmd --add-port=4011/udp --permanent
firewall-cmd --reload


sed -i "s/127\.0\.0\.1/${IP_ADDR}/" /etc/cobbler/settings
sed -i "s/manage_dhcp: .*/manage_dhcp: 1/" /etc/cobbler/settings
sed -i "s/subnet .* netmask .* {/subnet $NETWORK netmask $NETMASK {/" /etc/cobbler/dhcp.template
sed -i "s/option routers .*/option routers             ${IP_ADDR};/" /etc/cobbler/dhcp.template
sed -i "s/option domain-name-servers .*/option domain-name-servers 8.8.8.8;/" /etc/cobbler/dhcp.template
sed -i "s/range dynamic-bootp .*/range dynamic-bootp        ${DHCP_MIN_HOST} ${DHCP_MAX_HOST};/" /etc/cobbler/dhcp.template
sed -i "s/disable.*/disable\t\t\t= no/" /etc/xinetd.d/tftp
sed -i "s/^@dists/#@dists/" /etc/debmirror.conf
sed -i "s/^@arches/#@arches/" /etc/debmirror.conf

systemctl enable rsyncd.service
systemctl restart rsyncd.service
systemctl restart cobblerd
systemctl restart xinetd
systemctl enable xinetd
cobbler get-loaders
cobbler check
cobbler sync

init 6
