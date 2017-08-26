#!/usr/bin/env bash

# Run as root, otherwise you will need to sudo the "npm install -g pm2"

#This will override your NODE version
curl --silent --location https://rpm.nodesource.com/setup_7.x | sudo bash -;
yum -y install nodejs curl

# Dameonizer
npm install -g pm2; #this will be used to daemonize the service
pm2 install pm2-logrotate;
pm2 startup;


rm -rf /opt/device-config-server; #where the new version will be installed
mkdir -p /opt/device-config-server; #make the directory if it doesn't exist

#Download and unzip the package
curl --silent --location https://github.com/active-video/device-config-server/tarball/master > /opt/device-config-server.gz;
tar -xzvf /opt/device-config-server.gz -C /opt/device-config-server;
mv /opt/device-config-server/*/* /opt/device-config-server;
cd /opt/device-config-server/;
npm install;


# Add to rc.local so begings at system startup
if ! grep -q "device-config-server" /etc/rc.local ;
then
    echo "pm2 start /opt/device-config-server/index.js -l /var/log/device-config-server.log" >> /etc/rc.local;
fi;

pm2 start /opt/device-config-server/index.js --merge-logs -l /var/log/device-config-server.log;


#Verify that it works

curl --request PUT -d "{\"This is\": \"JSON\"}" http://127.0.0.1:8299/device/installtest; #Should print out:   save: ok("installtest")
curl http://127.0.0.1:8299/device/installtest; #Shuld print out the JSON:    {"This is": "JSON"}
curl --request DELETE http://127.0.0.1:8299/device/installtest; #Shuld print out:   delete: ok("installtest")