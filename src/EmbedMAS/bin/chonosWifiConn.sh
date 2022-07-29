#! /bin/bash
EmbedMAS_HOME=/opt/EmbedMAS
EmbedMAS_TMP=/tmp/.embedMAS
lockfile=/tmp/EmbedMAS-WifiConn.lock


while getopts i:-: flag
do
    case "${flag}" in
		i) wlanInterface=${OPTARG};;
        -) opt=${OPTARG};;
    esac
done

if [ "$wlanInterface" = "" ]; then
	wlanInterface=`cat $EmbedMAS_HOME/conf/wlanInterface.conf`
fi

if [ "$opt" = "help" ]; then
	cat $EmbedMAS_HOME/docs/scripts/chonosWifiConn.txt
elif [ "$opt" = "list" ]; then
	COMMAND=$(iwlist ${wlanInterface} scan | grep -v "IE: Unknown:" | grep -v "Bit Rates" | grep -v "Extra:")
	IFS=$'\n'

	declare -A regexes
	regexes=(\
			["Address"]="(?<=Address:\ ).*(?=$)" \
			["ESSID"]="(?<=ESSID:\").*(?=\")" \
			["Frequency"]="(?<=Frequency:).*(?=\ \(Channel)" \
			["Quality"]="(?<=Quality=).*(?=\ Signal)" \
			["Encryption"]="(?<=Encryption key:).*(?=$)" \
			)
	data="{}"

	for line in $COMMAND; do
	for key in "${!regexes[@]}"; do
		match=$(echo $line | grep -Po "${regexes[$key]}")
		if [ $match ]; then
		if [ $key == "Address" ]; then
			address=$match
		else
			value=$match
			data=$(echo $data | jq --arg address "$address" --arg key "$key" --arg value "$value" '.[$address][$key] |= .+ $value')
		fi
		fi
	done
	done

	echo "$data"
elif [ "$opt" = "status" ]; then
	mkdir -p $EmbedMAS_TMP
	iwconfig $wlanInterface > $EmbedMAS_TMP/status

	mode=`cat $EmbedMAS_TMP/status | grep Mode | xargs | cut -d ":" -f 2 | cut -d " " -f 1`

	if [ "$mode" = "Master" ]; then
		# Caso Modo AP
		essid=`cat /etc/wpa_supplicant/wpa_supplicant.conf | grep "ssid=" | xargs | cut -d "=" -f 2`
		bitRate="unknown"
		quality="unknown"
		frequency=`cat /etc/wpa_supplicant/wpa_supplicant.conf | grep "frequency" | xargs | cut -d "=" -f 2`
		echo "{" > $EmbedMAS_TMP/json.out
			echo "\"Interface\": \"$wlanInterface\"," >> $EmbedMAS_TMP/json.out
			echo "\"ESSID\": \"$essid\"," >> $EmbedMAS_TMP/json.out
			echo "\"Mode\": \"$mode\"," >> $EmbedMAS_TMP/json.out
			echo "\"Mb/s\": \"$bitRate\"," >> $EmbedMAS_TMP/json.out
			echo "\"Quality\": \"$quality\"," >> $EmbedMAS_TMP/json.out
			echo "\"Frequency\": \"$frequency\"" >> $EmbedMAS_TMP/json.out
		echo "}" >> $EmbedMAS_TMP/json.out
		cat $EmbedMAS_TMP/json.out
	elif [ "$mode" = "Managed" ]; then
		# Caso Modo Cliente
		essid=`cat $EmbedMAS_TMP/status | grep "ESSID:" | xargs | cut -d ":" -f 2`
		bitRate=`cat $EmbedMAS_TMP/status  | grep "Bit Rate" | xargs | cut -d "=" -f 2 | cut -d " " -f 1`
		quality=`cat $EmbedMAS_TMP/status  | grep "Quality" | xargs | cut -d "=" -f 2 | cut -d " " -f 1`
		frequency=`cat $EmbedMAS_TMP/status | grep Frequency | xargs | cut -d " " -f 2 | cut -d ":" -f 2`
		echo "{" > $EmbedMAS_TMP/json.out
			echo "\"Interface\": \"$wlanInterface\"," >> $EmbedMAS_TMP/json.out
			echo "\"ESSID\": \"$essid\"," >> $EmbedMAS_TMP/json.out
			echo "\"Mode\": \"$mode\"," >> $EmbedMAS_TMP/json.out
			echo "\"Mb/s\": \"$bitRate\"," >> $EmbedMAS_TMP/json.out
			echo "\"Quality\": \"$quality\"," >> $EmbedMAS_TMP/json.out
			echo "\"Frequency\": \"$frequency\"" >> $EmbedMAS_TMP/json.out
		echo "}" >> $EmbedMAS_TMP/json.out
		cat $EmbedMAS_TMP/json.out
	fi
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