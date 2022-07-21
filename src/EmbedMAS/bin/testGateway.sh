#! /bin/sh
EmbedMAS_HOME=/opt/EmbedMAS

echo "Ativando o teste de Conexão"
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
	#echo -n "Aguardando... "
	if apMode; then
		return 0
	else
		if lanComm; then
#			echo "LAN Connected!"
			$EmbedMAS_HOME/bin/ddnsUpdate.sh
			return 0
		else
			sleep 30
			if lanComm; then
				return 0
			else
				sleep 30
				if lanComm; then
					return 0
				else
					echo LAN not Connected - restart conf
					#$EmbedMAS_HOME/bin/EmbedMAS-NetworkRestart -f default
					sleep 30
					$EmbedMAS_HOME/bin/chonosWifiConf -m ap
					echo 1 > $EmbedMAS_HOME/conf/apMode.conf
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
