
#!/bin/bash
#####################################################################################################################
#                                                                                                                   #
#                              This script is written by Pierre Goude                                               #
#  This program is open source; you can redistribute it and/or modify it under the terms of the GNU General Public  #
#                                                                                                                   #
#                                                                                                                   #
#####################################################################################################################

#This skript is not finished!


##############3 deploy server installation##################
cd /etc/apache2/mods-enabled
$ sudo ln -s ../mods-available/cgi.load

 sudo apt-get install curl
 
 sudo apt-get install apache2
 sudo a2enmod cgi
 sudo service apache2 reload
 
 
 sudo echo '#Defaults for tftpd-hpa
RUN_DAEMON="yes"
OPTIONS="-l -s /var/lib/tftpboot"' >> /etc/default/tftpd-hpa
/etc/init.d/tftpd-hpa restart
sudo mkdir /var/www/html/ubuntu
sudo rm -rf /var/www/html/index.html
sudo mkdir /var/lib/tftpboot/ubuntu

sudo echo '
allow booting;
allow bootp;

subnet 192.168.2.0 netmask 255.255.255.0 {
  range 192.168.2.xxx 192.168.2.xxx;
  option broadcast-address 192.168.2.255;
  option routers 192.168.2.xxx;
  option domain-name-servers 192.168.2.xxx;

  filename "pxelinux.0";
}' >> /etc/dhcp/dhcpd.conf
sudo cp /usr/lib/syslinux/pxelinux.0 /var/lib/tftpboot/
sudo echo 'tftp dgram udp wait root /usr/sbin/in.tftpd /usr/sbin/in.tftpd -s /var/lib/tftpboot' >> /etc/inetd.conf

