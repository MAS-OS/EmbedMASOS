#! /bin/sh
EmbedMAS_HOME=/opt/EmbedMAS

echo "[  OK  ] Ativando o teste de Conexão"
echo 0 > $EmbedMAS_HOME/conf/apMode.conf

apMode(){
	apConf=`cat $EmbedMAS_HOME/conf/apMode.conf`
	# Verifica configuração modoAP
	if [ $apConf -eq 1 ];then
		return 0
	fi
	return 1
}

lanComm(){
	# Testa conexão com o gateway
	ping -c 5 `sudo ip route list | grep "default" | cut -d " " -f 3` > /dev/null 2> /dev/null
	[ $? -eq 0 ] && return 0

	return 1
}

commands(){
	if apMode; then
		#echo -n "AP Mode ON "
		return 0
	else
		if lanComm; then
			#echo "LAN Connected!"
			$EmbedMAS_HOME/bin/ddnsUpdate.sh
			sleep 120
			return 0
		else
			chonosWifiConf -m default
			sleep 30
			if lanComm; then
				return 0
			else
				chonosWifiConf -m default
				sleep 30
				if lanComm; then
					return 0
				else
					echo "LAN não conectada - ativando modo AP"
					/usr/bin/chonosWifiConf -m ap
				fi
			fi
		fi
	fi
}


while true
do
	sleep 15
	commands
done
