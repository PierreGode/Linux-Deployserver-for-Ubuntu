
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
cd /etc/apache2/mods-enabled
$ sudo ln -s ../mods-available/cgi.load

 sudo apt-get install curl -y
 sudo apt-get install apache2 -y
 sudo a2enmod cgi -y
 sudo service apache2 reload
sudo echo '
RUN_DAEMON="yes"
OPTIONS="-l -s /var/lib/tftpboot"' >> /etc/default/tftpd-hpa
/etc/init.d/tftpd-hpa restart

