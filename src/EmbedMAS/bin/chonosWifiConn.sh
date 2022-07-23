#! /bin/bash
EmbedMAS_HOME=/opt/EmbedMAS
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
# source: https://github.com/smega/iwlist-data-processing/blob/master/grep/sc_grep.sh
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