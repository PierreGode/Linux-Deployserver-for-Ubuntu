
#!/bin/bash
#####################################################################################################################
#                                                                                                                   #
#                              This script is written by Pierre Goude                                               #
#  This program is open source; you can redistribute it and/or modify it under the terms of the GNU General Public  #
#                                                                                                                   #
#                                                                                                                   #
#####################################################################################################################

#This skript is not finished!

############## deploy server installation##################
clear
echo "Making necessary installs"
sleep 2
sudo apt-get update
sudo apt-get install -y isc-dhcp-Server inetutils-inetd tftpd-hpa syslinux nfs-kernel-Server
sudo apt-get install wget -y
sudo apt-get install curl -y
sudo apt-get install apache2 -y
sudo a2enmod cgi -y
sudo apt-get install isc-dhcp-server -y
sudo service apache2 reload
clear
echo "Configurating..."
sleep 1
sudo echo '
RUN_DAEMON="yes"
OPTIONS="-l -s /var/lib/tftpboot"' >> /etc/default/tftpd-hpa
/etc/init.d/tftpd-hpa restart
sudo mkdir /var/www/html/ubuntu
sudo rm -rf /var/www/html/index.html
cd /etc/apache2/mods-enabled
$ sudo ln -s ../mods-available/cgi.load
clear
if [ -d /etc/dhcp/ ] 
then
while true; do
   read -p 'dhcp is already installed, do you really whant to overrite configuration? (y/n)?' yn
   case $yn in
    [Yy]* ) echo "Writing to dhcp.conf"
            break;;
    [Nn]* ) echo "Quiting"
            sleep 1        
            exit ;;
    * ) echo 'Please answer yes or no.';;
   esac
done
else
clear
echo "Setting up dhcp.conf"
fi
echo "Type IP"
read depip
echo "Type range formatEX ( 1-200 )"
read RanGE
Myrange=$( echo $RanGE | cut -d '-' -f1 )
Endrange=$( echo $RanGE | cut -d '-' -f2 )
suBnet=$( echo $depip | cut -c 1-9 )
sudo echo "'
allow booting;
allow bootp;
subnet $depip netmask 255.255.255 {
range "$suBnet""$Myrange" "$suBnet""$Endrange";
option broadcast-address "$suBnet"255
#option netbios-name-servers 192.168.1.1; 
filename "pxelinux.0";
}'" > /etc/dhcp/dhcpd.conf
sudo cp /usr/lib/syslinux/pxelinux.0 /var/lib/tftpboot/
sudo echo 'tftp dgram udp wait root /usr/sbin/in.tftpd /usr/sbin/in.tftpd -s /var/lib/tftpboot' >> /etc/inetd.conf
sudo service isc-dhcp-server restart
cd /var/lib/tftpd/
sudo echo'
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/var/lib/tftpboot"
TFTP_ADDRESS="[::]:69" 
#TFTP_OPTIONS="--secure"' >>/etc/default/tftpd-hpa
sudo update-inetd --enable BOOT
sudo service tftpd-hpa restart
sudo cp /usr/lib/syslinux/vesamenu.c32 /var/lib/tftpboot/
sudo cp /usr/lib/syslinux/pxelinux.0 /var/lib/tftpboot/
sudo echo "Downloading Ubuntu16 image from archive"
sudo wget http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-amd64/current/images/netboot/netboot.tar.gz´
sudo gunzip *.gz
sudo tar -xvf *.tar
clear
echo "Primary settings has been setup.. please check your dhcp conf for errors"
echo "Remember to set bootfile name to /var/lib/tftpboot/pxelinux.0 in your dhcp"
echo "upload kickstart file to /var/www/ubuntu/ and cofigure (example below) in /var/lib/tftpboot/ubuntu-installer/amd64/boot-screens/txt.cfg"
echo "'label install
        menu label ^Ubuntu 16 Gen
        kernel ubuntu-installer/amd64/linux
        append ks=http://192.168.1.5/ubuntugeneric.cfg vga=788 initrd=ubuntu-installer/amd64/initrd.gz --- quiet'"
echo "END"
