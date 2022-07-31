#! /bin/sh
fqdn=".embed.masos.org"
EmbedMAS_HOME=/opt/EmbedMAS
EmbedMAS_TMP=/tmp/.embedMAS
EmbedMAS_LOGFILE=$EmbedMAS_TMP/embeddedMAS.log

update(){
	ddns_user=`cat $EmbedMAS_HOME/conf/ddns.conf | cut -d ":" -f 2`
	ddns_token=`cat $EmbedMAS_HOME/conf/ddns.conf | cut -d ":" -f 3`
	echo "... $IP - $hostname " > $EmbedMAS_LOGFILE
	curl -v -u $ddns_user:$ddns_token "https://ddns.masos.org/ddns.php?subdomain=$hostname&address=$IP" > /dev/null 2> /dev/null
	echo $hostname > $EmbedMAS_TMP/last_hostname
	echo $IP > $EmbedMAS_TMP/last_IP
}


#echo -n "DDNS Update"
IP=`ip route | grep link | cut -f 9 -d " "`
last_IP=`cat $EmbedMAS_TMP/last_IP 2>/dev/null`
hostname=`cat $EmbedMAS_HOME/conf/ddns.conf | cut -d ":" -f 1`
last_hostname=`cat $EmbedMAS_TMP/last_hostname 2>/dev/null`
last_dnsrecord=`dig +short @8.8.4.4 $hostname$fqdn`

if [ "$hostname" != "$last_hostname" ] ||  [ "$IP" != "$last_IP" ] || [ "$IP" != "$last_dnsrecord" ]
then
    echo -n " Update... DNS" > $EmbedMAS_LOGFILE
    update    
else
#    echo "Nothing"
#    echo "$hostname$fqdn = $last_dnsrecord"
    exit 0 
fi






