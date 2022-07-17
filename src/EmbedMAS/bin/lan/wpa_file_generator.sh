#! /bin/sh
# WPA Supplicant ModeAP Gerenerator
EmbedMAS_HOME=/opt/EmbedMAS
tmpFile=/tmp/wpa-conf-random-freq.conf

while getopts c:e:k: flag
do
    case "${flag}" in
        c) ch=${OPTARG};;
        e) name=${OPTARG};;
        k) key=${OPTARG};;
    esac
done

####################### Random Channel ####################################
if [ "$ch" = "" ] || [ "$ch" = "random" ]; then
	div=$((11))
	RANDOX=$$
	ch=$((($RANDOX%$div)+1))
fi
channel=ch$ch:
freq=`cat $EmbedMAS_HOME/conf/apMHz.conf | grep $channel | cut -d ":" -f 2`

####################### Default ESSID ####################################
if [ "$name" = "" ]; then
	name='EmbedMAS'
fi

####################### Create Default File ##############################
echo ""				> 	$tmpFile
echo "network={"		>> 	$tmpFile
echo -n '         ssid="'	>> 	$tmpFile
echo -n $name			>> 	$tmpFile
echo '"'			>> 	$tmpFile
echo "         mode=2"		>> 	$tmpFile
echo "         frequency=$freq"	>> 	$tmpFile

if [ "$key" = "" ] || [ "$key" = "NONE" ]; then
echo "         key_mgmt=NONE"	>> 	$tmpFile
else
echo "         key_mgmt=WPA-PSK">> 	$tmpFile
echo "         proto=RSN" 	>> 	$tmpFile
echo "         pairwise=CCMP"	>> 	$tmpFile
echo -n '         psk="' 	>> 	$tmpFile
echo -n $key			>> 	$tmpFile
echo '"' 			>> 	$tmpFile
fi

echo "}"			>> 	$tmpFile
         
mv $tmpFile $EmbedMAS_HOME/conf/WLANs/modeApZeroConf.conf
