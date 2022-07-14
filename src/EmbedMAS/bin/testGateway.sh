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
	echo -n "Aguardando... "
	sleep 30
	if apMode; then
		echo "ApMode Enable!"
		return 0
	else
		if lanComm; then
			echo "LAN Connected!"
			$EmbedMAS_HOME/bin/ddnsUpdate.sh
			return 0
		else
			wlanInterface=`cat $EmbedMAS_HOME/conf/wlanInterface.conf`
			# Limpa tabela ARP
			ip link set arp off dev $wlanInterface
			ip link set arp on dev $wlanInterface
			sleep 60

			# Consulta tabela ARP
			arp -ni $wlanInterface | grep $wlanInterface > /tmp/arp

			if [ -s /tmp/arp ]
			then
				echo "AutoAp ON!"
				return 0
			else
				echo "Restarting Network!"
				$EmbedMAS_HOME/bin/EmbedMAS-NetworkRestart
			fi
		fi
	fi
}


while true
do
	commands
done
