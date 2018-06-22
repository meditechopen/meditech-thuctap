# Script install ELK Server

<img src="https://media1.giphy.com/media/Cmr1OMJ2FN0B2/giphy.gif">

This is script to install ELK server. Please note that this script only works for CentOS 7.

Firstly, please download script and two config files for logstash

If you do not have `wget`. Please run the following command to install it:

`yum install wget -y`

After that, download three files by following commands:

`wget https://raw.githubusercontent.com/thaonguyenvan/meditech-thuctap/master/ThaoNV/ghi-chep-elk/script/ELK-server.sh`

`wget https://raw.githubusercontent.com/thaonguyenvan/meditech-thuctap/master/ThaoNV/ghi-chep-elk/script/02-openstack.conf`

`wget https://raw.githubusercontent.com/thaonguyenvan/meditech-thuctap/master/ThaoNV/ghi-chep-elk/script/03-syslog.conf`

Run the following command to run the script.

`bash ELK-server.sh`

There are some options for you in this script. Firstly, script will ask you to know whether you want to keep using `firewalld` or not.

<img src="https://i.imgur.com/MP6nrJL.png">

If you want to use firewalld, press `1` and `Enter`

If you do not want to use firewalld, press any button and `Enter`

This script is use to build ELK server to get log of OpenStack system or linux syslog. The script will ask you to get your selection.

<img src="https://i.imgur.com/TkeOz4d.png">

If you want to config this ELK server to get log from OpenStack system, press `1` and `Enter`.

If you want to config this ELK server to get log from linux syslog, press any button and `Enter`.

The script will start automatically.

<img src="https://i.imgur.com/AonudeD.png">

After installed, you can access your dashboard of Kibana by address `http://your-elk-server:5601`

# Script to install filebeat in client to push log to ELK server

Firstly, download `ELK-client` script by the following command:

`curl https://raw.githubusercontent.com/thaonguyenvan/meditech-thuctap/master/ThaoNV/ghi-chep-elk/script/ELK-client.sh > ELK-client.sh`

After that, run this script:

`bash ELK-client.sh`

The script will ask you to enter your ELK server IP.

Moreover, you have to choose to install filebeat to push your OpenStack log or your syslog.

<img src="https://i.imgur.com/9N4RMey.png">

Press `1` to push your OpenStack log and any button to push your syslog.

Thanks for using this script,

Good luck,

ThaoNV

<img src="https://media2.giphy.com/media/xTk9ZTOGgL1W84vX7q/200w.webp">
