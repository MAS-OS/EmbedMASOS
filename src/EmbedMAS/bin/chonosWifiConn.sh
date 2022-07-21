#! /bin/bash
EmbedMAS_HOME=/opt/EmbedMAS
lockfile=/tmp/EmbedMAS-WifiConn.lock
wlanInterface=`cat $EmbedMAS_HOME/conf/wlanInterface.conf`

while getopts h:f:m:c:e:k:-: flag
do
    case "${flag}" in
        -) opt=${OPTARG};;
    esac
done

if [ "$opt" = "help" ]; then
	cat $EmbedMAS_HOME/docs/scripts/chonosWifiConn.txt
elif [ "$opt" = "list" ]; then
	iwlist wlan0 scan | grep ESSID
elif [ "$opt" = "" ]; then
	touch $lockfile
	echo $wlanInterface

	while [ -f $lockfile ]
	do
		clear
		echo "Searching Wireless Networks"
		iwlist $wlanInterface scan | grep ESSID
		read -r -p "Press [S] to Scan again. Press any key to continue. " choice
		case $choice in
			s|S) echo "Searching again ..." ;;
			*) rm $lockfile ;;
		esac
	done

	echo " "
	read -r -p "Insert the ESSID to conect: " wlanSSID
	read -s -p "Insert the Password of  $wlanSSID : " wlanPass
	echo " "
	
	wpa_passphrase $wlanSSID $wlanPass > $EmbedMAS_HOME/conf/WLANs/lan_$wlanSSID.conf
	echo "Agendando WLAN Reconfigure ..."
	$EmbedMAS_HOME/bin/task/taskNew.sh "/usr/bin/chonosWifiConf -m default"
fi




