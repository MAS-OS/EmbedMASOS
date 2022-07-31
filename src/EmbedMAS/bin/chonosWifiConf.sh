#! /bin/sh
EmbedMAS_HOME=/opt/EmbedMAS
EmbedMAS_TMP=/tmp/.embedMAS
EmbedMAS_LOGFILE=$EmbedMAS_TMP/embeddedMAS.log

while getopts h:f:m:c:e:k:-: flag
do
    case "${flag}" in
        f) confFile=${OPTARG};;
        m) modeOperation=${OPTARG};;
        c) ch=${OPTARG};;
        e) name=${OPTARG};;
        k) key=${OPTARG};;
        -) opt=${OPTARG};;
    esac
done


if [ "$opt" = "help" ]; then
	cat $EmbedMAS_HOME/docs/scripts/chonosWifiConf.txt
elif [ "$opt" = "forget" ]; then
	rm $EmbedMAS_HOME/conf/WLANs/lan_*.conf
elif [ "$opt" = "list" ]; then
	qtd=`cat $EmbedMAS_HOME/conf/WLANs/lan_*.conf 2> /dev/null | grep "network=" | nl | tail -1 | xargs | cut -d " " -f 1`
	echo "{" > $EmbedMAS_TMP/json.out
		i=2
		while [ $i -le $((qtd+1)) ]; do
			essid=`cat $EmbedMAS_HOME/conf/WLANs/lan_*.conf | xargs | cut -d "{" -f $i | xargs | cut -d " " -f 1 | cut -d "=" -f 2`
			echo "\"$((i-2))\": {" >> $EmbedMAS_TMP/json.out
			echo "\"ESSID\": \"$essid\"," >> $EmbedMAS_TMP/json.out    
			key=`cat $EmbedMAS_HOME/conf/WLANs/lan_*.conf | xargs | cut -d "{" -f $i | xargs | cut -d " " -f 2 | cut -d "=" -f 2`
			echo "\"Pass\": \"$key\"" >> $EmbedMAS_TMP/json.out
			
			if [ $i -le $((qtd)) ]; then
				echo "}," >> $EmbedMAS_TMP/json.out
			else
				echo "}" >> $EmbedMAS_TMP/json.out
			fi
			i=$((i+1))  
		done
	echo "}" >> $EmbedMAS_TMP/json.out
	cat $EmbedMAS_TMP/json.out
fi

######################## Mode Operation #####################################
if [ "$modeOperation" = "ap" ]; then
	op1='-c random'
	op2='-e EmbedMAS'
	op3='-k NONE'

	if [ "$ch" != "" ]; then
		op1="-c $ch"
	fi

	if [ "$name" != "" ]; then
		op2="-e $name"
	fi

	if [ "$key" != "" ]; then
		op3="-k $key"
	fi
	echo 1 > $EmbedMAS_HOME/conf/apMode.conf
	$EmbedMAS_HOME/bin/lan/wpa_file_generator.sh $op1 $op2 $op3

	echo "Agendando AP WLAN Reconfigure ..." > $EmbedMAS_LOGFILE
	$EmbedMAS_HOME/bin/task/taskNew.sh "/usr/bin/chonosWifiConf -f apmode"
	exit 0
elif [ "$modeOperation" = "default" ]; then
	echo 0 > $EmbedMAS_HOME/conf/apMode.conf
	$EmbedMAS_HOME/bin/lan/wpa_file_generator.sh

	echo "Agendando Default WLAN Reconfigure ..." > $EmbedMAS_LOGFILE
	$EmbedMAS_HOME/bin/task/taskNew.sh "/usr/bin/chonosWifiConf -f default"
	exit 0
elif [ "$modeOperation" = "client" ]; then
	echo 0 > $EmbedMAS_HOME/conf/apMode.conf
	wpa_passphrase $name $key > $EmbedMAS_HOME/conf/WLANs/lan_$name.conf
	echo "Agendando WLAN Reconfigure ..." > $EmbedMAS_LOGFILE
	$EmbedMAS_HOME/bin/task/taskNew.sh "/usr/bin/chonosWifiConf -m default"
	exit 0
fi

######################### WPA Conf ##########################################
if [ "$confFile" != "" ]; then
		systemctl stop isc-dhcp-server
		systemctl stop dhcpcd
		systemctl stop wpa_supplicant
		systemctl stop networking
	if [ "$confFile" = "default" ]; then
  		confFile="$EmbedMAS_HOME/conf/WLANs/base.conf $EmbedMAS_HOME/conf/WLANs/lan_*.conf"
 		cat $confFile > $EmbedMAS_HOME/etc/wpa_supplicant/wpa_supplicant.conf
		systemctl start networking
		systemctl start wpa_supplicant
		systemctl start dhcpcd
  	elif [ "$confFile" = "apmode" ]; then
  		confFile="$EmbedMAS_HOME/conf/WLANs/base.conf $EmbedMAS_HOME/conf/WLANs/modeApZeroConf.conf"
 		cat $confFile > $EmbedMAS_HOME/etc/wpa_supplicant/wpa_supplicant.conf
		systemctl start networking
		systemctl start wpa_supplicant
		systemctl start dhcpcd
		systemctl start isc-dhcp-server
 	fi
fi
