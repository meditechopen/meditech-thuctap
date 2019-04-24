#!/bin/bash -ex
##############################################################################
### Script cai dat ELK server tren CentOS 7 ###

OPS_FILTER=./02-openstack.conf
SYSLOG_FILTER=./03-syslog.conf

function echocolor {
    echo "#######################################################################"
    echo "$(tput setaf 3)##### $1 #####$(tput sgr0)"
    echo "#######################################################################"

}

function check_file_logstash {
  if [ ! -f $OPS_FILTER ] && [ ! -f $SYSLOG_FILTER ]
  then
    echocolor ""
    echocolor "Could not see file $OPS_FILTER & $SYSLOG_FILTER. Did you download it?"
    echocolor "See the instruction."
    echocolor ""
    exit 1
  fi;
}

function install_java {
  yum install java-1.8.0-openjdk -y
  java -version
}

function install_elaticsearch {
  rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch
  cat <<EOF > /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

  yum install elasticsearch -y
}

function start_elastic {
  systemctl daemon-reload
  systemctl enable elasticsearch
  systemctl start elasticsearch
}

function install_logstash {
  cat << EOF > /etc/yum.repos.d/logstash.repo
[logstash-6.x]
name=Elastic repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

  yum install logstash -y
}

function start_logstash {
  systemctl daemon-reload
  systemctl start logstash
  systemctl enable logstash
}

function  install_kibana {
  cat <<EOF > /etc/yum.repos.d/kibana.repo
[kibana-6.x]
name=Kibana repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

yum install kibana -y
sed -i 's/#server.host: "localhost"/server.host: "0.0.0.0"/'g /etc/kibana/kibana.yml
}

function start_kibana {
  systemctl daemon-reload
  systemctl start kibana
  systemctl enable kibana
}

function stop_firewalld {
  FWSTATUS=`systemctl status firewalld | awk 'FNR == 3 {print}' | awk '{print $2}'`
  if [ "$FWSTATUS" == "active" ]
  then
    systemctl stop firewalld
    systemctl disable firewalld
  fi
}

function start_firewalld {
  FWSTATUS=`systemctl status firewalld | awk 'FNR == 3 {print}' | awk '{print $2}'`
  if [ "$FWSTATUS" == "inactive" ]
  then
    systemctl start firewalld
    systemctl enable firewalld
  fi
}

function add_firewall_rules {
  firewall-cmd --add-port=9200/tcp
  firewall-cmd --add-port=9200/tcp --permanent
  firewall-cmd --add-port=5044/tcp
  firewall-cmd --add-port=5044/tcp --permanent
  firewall-cmd --add-port=5601/tcp
  firewall-cmd --add-port=5601/tcp --permanent
}

##############################################################################
# Implement functions
##############################################################################

echocolor "Do you want to keep firewalld?"
echocolor "Press 1 for YES and any button for NO"
read select

if [ $select = 1 ]
then
  start_firewalld
  add_firewall_rules
else
  stop_firewalld
fi

sleep 2

echocolor "There are two options"
echocolor "If you want to get log of OPENSTACK. PRESS 1"
echocolor "If you want to get log of SYSLOG. PRESS ANY BUTTON"

read option

if [ $option = 1 ]
then
  echocolor "Checking if there is config file for logstash"

  sleep 3

  check_file_logstash

  echocolor "Starting to install Java"

  sleep 3

  install_java

  sleep 3

  echocolor "Start to install elasticsearch"

  install_elaticsearch

  sleep 2

  echocolor "Starting elasticsearch"

  start_elastic

  sleep 2

  echocolor "Start to install logstash"

  install_logstash

  sleep 2

  cp $OPS_FILTER /etc/logstash/conf.d/$OPS_FILTER

  echocolor "Starting logstash"

  start_logstash

  sleep 2

  echocolor "Start to install kibana"

  sleep 2

  install_kibana

  echocolor "Starting kibana"

  start_kibana

  sleep 2
else
  echocolor "Checking if there is config file for logstash"

  sleep 3

  check_file_logstash

  echocolor "Starting to install Java"

  sleep 3

  install_java

  sleep 3

  echocolor "Start to install elasticsearch"

  install_elaticsearch

  sleep 2

  echocolor "Starting elasticsearch"

  start_elastic

  sleep 2

  echocolor "Start to install logstash"

  install_logstash

  sleep 2

  cp $SYSLOG_FILTER /etc/logstash/conf.d/$SYSLOG_FILTER

  echocolor "Starting logstash"

  start_logstash

  sleep 2

  echocolor "Start to install kibana"

  sleep 2

  install_kibana

  echocolor "Starting kibana"

  start_kibana

  sleep 2
fi

echo "Setup complete"
echo "Please access to http://your_ip:5601"
##########################################
## End script
####
