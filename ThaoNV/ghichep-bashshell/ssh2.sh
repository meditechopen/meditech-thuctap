#!/bin/bash
###############
# Script cai dat ssh key
###############

source ip.txt

PUB_KEY=/root/.ssh/id_rsa.pub
PRI_KEY=/root/.ssh/id_rsa

function check_key {
  if [ ! -f $PUB_KEY ] && [ ! -f $PRI_KEY ]
  then
    ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -P ""
  else
    echo "You already had key pairs"
  fi
}

function centos_install_sshpass {
  yum install sshpass -y
}

function ubuntu_install_sshpass {
  apt-get install sshpass -y
}

function install_sshpass {
  ID=`cat /etc/*release | grep ^ID= | cut -d= -f2 | sed -e 's/^"//' -e 's/"$//'`
  if [ $ID = 'centos' ]
  then
  centos_install_sshpass
  elif [ $ID = 'ubuntu' ]
  then
  ubuntu_install_sshpass
  else
    echo "Your OS is currently not supported by this script"
  fi
}

check_key
install_sshpass

for IP in $IP01 $IP02
do
  for PASS in $PASS01 $PASS02
  do
    sshpass -p "$PASS"  ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub root@$IP
  done
done
