#!/usr/bin/env bash

# Run as root, otherwise you will need to sudo the "npm install -g pm2"

#This will override your NODE version
curl --silent --location https://rpm.nodesource.com/setup_7.x | sudo bash -;
yum -y install nodejs

npm install -g pm2; #this will be used to daemonize the service
rm -rf /opt/device-config-server; #where the new version will be installed
mkdir -p /opt; #make the directory if it doesn't exist

#Download and unzip the package
cd /opt;
curl --silent --location https://github.com/active-video/device-config-server/archive/master.zip | unzip


# Add to rc.local so begings at system startup
if ! grep -q "device-config-server" /etc/rc.local ;
then
    echo "pm2 start /opt/device-config-server/index.js" >> /etc/rc.local;
fi;

pm2 start /opt/device-config-server/index.js;