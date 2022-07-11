#! /bin/sh


EmbedMAS_HOME=/opt/EmbedMAS

echo "DDNS Update"
IP=`ip route | grep link | cut -f 9 -d " "`
hostname=`cat $EmbedMAS_HOME/conf/ddns.conf | cut -d ":" -f 1`
ddns_user=`cat $EmbedMAS_HOME/conf/ddns.conf | cut -d ":" -f 2`
ddns_token=`cat $EmbedMAS_HOME/conf/ddns.conf | cut -d ":" -f 3`

echo "... $IP - $hostname "
curl -v -u $ddns_user:$ddns_token "https://ddns.masos.org/ddns.php?subdomain=$hostname&address=$IP" > /dev/null 2> /dev/null

