#!/bin/bash -ex
##############################################################################
### Script cai dat filebeat de gui log ve ELK server ###

function echocolor {
    echo "#######################################################################"
    echo "$(tput setaf 3)##### $1 #####$(tput sgr0)"
    echo "#######################################################################"

}

function lsb {
	if [[ -x $(command -v lsb_release 2>/dev/null) ]]; then
			return
		fi
	if [[ -x $(command -v apt-get 2>/dev/null) ]]; then
			sudo apt-get install -y lsb-release
	elif [[ -x $(command -v zypper 2>/dev/null) ]]; then
			sudo zypper -n install lsb
	elif [[ -x $(command -v dnf 2>/dev/null) ]]; then
			sudo dnf install -y redhat-lsb-core
	elif [[ -x $(command -v yum 2>/dev/null) ]]; then
			sudo yum install -y redhat-lsb-core
	else
			echo "Unable to find or auto-install lsb_release"
		fi
}

function hienthi {
		a=$(lsb_release -r -s)
		b=$(lsb_release -c -s)
		c=$(lsb_release -i -s)
		echo "You are using $a $b $c"
			sleep 5
}

function centos_install {
cat << EOF >> /etc/yum.repos.d/filebeat.repo
[filebeat]
name=Filebeat for ELK clients
baseurl=https://packages.elastic.co/beats/yum/el/$basearch
enabled=1
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch
gpgcheck=1
EOF

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.2.4-x86_64.rpm

rpm -vi filebeat-6.2.4-x86_64.rpm
}

function openstack {
mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.orig
touch /etc/filebeat/filebeat.yml
cat << EOF > /etc/filebeat/filebeat.yml
filebeat.prospectors:
- type: log
  paths:
    - /var/log/cinder/*.log
  fields:       {log_type: cinder}
- type: log
  paths:
    - /var/log/glance/*.log
  fields:       {log_type: glance}
- type: log
  paths:
    - /var/log/keystone/*.log
  fields:       {log_type: keystone}
- type: log
  paths:
    - /var/log/neutron/*.log
  fields:       {log_type: neutron}
- type: log
  paths:
    - /var/log/nova/*.log
  fields:       {log_type: nova}
- type: log
  paths:
    - /var/log/rabbitmq/*.log
  fields:       {log_type: rabbitmq}
- type: log
  paths:
    - /var/log/apache2/*.log
  fields:       {log_type: apache2}
- type: log
  paths:
    - /var/log/mysql/*.log
  fields:       {log_type: mysql}
- type: log
  paths:
    - /var/log/syslog
  fields:       {log_type: syslog}
- type: log
  paths:
    - /var/log/auth.log
  fields:       {log_type: ssh}
tags:
- openstack

output.logstash:
  hosts: ["localhost:5044"]
logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat
  keepfiles: 7
  permissions: 0644
EOF
}

function ubuntu_install {
  curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.2.3-amd64.deb
  dpkg -i filebeat-6.2.3-amd64.deb
}

function syslog {
mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.orig
touch /etc/filebeat/filebeat.yml
cat << EOF > /etc/filebeat/filebeat.yml
filebeat.prospectors:
- type: log
  enabled: true
  paths:
    - /var/log/*.log
    - /var/log/auth.log
    - /var/log/syslog
    - /var/log/secure
    - /var/log/messages
output.logstash:
  hosts: ["localhost:5044"]
EOF
}

function start_filebeat_centos {
  systemctl start filebeat
  systemctl enable filebeat
}

function start_filebeat_ubuntu {
  service filebeat restart
  update-rc.d filebeat defaults
}

echo "Please enter your ELK server's IP:"
read elkip

echo "Do you want to install filebeat to push your OPENSTACK log or your SYSLOG?"
echo "Press 1 if you want to push your OPENSTACK log and ANY BUTTON if you want to push your SYSLOG"
read selection

lsb
hienthi

if [ $selection = 1 ]
then
  if [ "$c" == "CentOS" ]
  then
    systemctl stop firewalld
    systemctl disable firewalld
    centos_install
    openstack
    sed -i "s/localhost/$elkip/g" /etc/filebeat/filebeat.yml
    start_filebeat_centos
  elif [ "$c" == "Ubuntu" ]
  then
    ubuntu_install
    openstack
    sed -i "s/localhost/$elkip/g" /etc/filebeat/filebeat.yml
    start_filebeat_ubuntu
  else
    echo "Your OS is currently not supported by this script"
    exit 1
  fi
else
  if [ "$c" == "CentOS" ]
  then
    systemctl stop firewalld
    systemctl disable firewalld
    centos_install
    syslog
    sed -i "s/localhost/$elkip/g" /etc/filebeat/filebeat.yml
    start_filebeat_centos
  elif [ "$c" == "Ubuntu" ]
  then
    ubuntu_install
    syslog
    sed -i "s/localhost/$elkip/g" /etc/filebeat/filebeat.yml
    start_filebeat_ubuntu
  else
    echo "Your OS is currently not supported by this script"
    exit 1
  fi
fi
