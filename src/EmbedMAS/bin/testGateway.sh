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
		echo "ApMode Enable!"
#		systemctl status isc-dhcp-server > /dev/null
#		[ $? -eq 0 ] && echo dchcp-ok && return 0
#
#		echo INICIA DHCP
#		systemctl restart isc-dhcp-server > /dev/null
		return 0
	else
		if lanComm; then
			echo "LAN Connected!"
			$EmbedMAS_HOME/bin/ddnsUpdate.sh
			return 0
		else
			echo "LAN Sem Acesso!"
			sleep 10
			if lanComm; then
				return 0
			else
				echo LAN-SEMACESSO
				sleep 10
				if lanComm; then
					return 0
				else
					$EmbedMAS_HOME/bin/EmbedMAS-NetworkRestart -m ap
				fi
			fi
#			wlanInterface=`cat $EmbedMAS_HOME/conf/wlanInterface.conf`
#			# Limpa tabela ARP
#			ip link set arp off dev $wlanInterface
#			ip link set arp on dev $wlanInterface
#			sleep 60
#
#			# Consulta tabela ARP
#			arp -ni $wlanInterface | grep $wlanInterface > /tmp/arp
#
#			if [ -s /tmp/arp ]
#			then
#				#echo "AutoAp ON!"
#				return 0
#			else
#				if apMode; then
#					echo "ApMode Enable!"
#					return 0
#				else
#					echo "Restarting Network!"
#					#cat $EmbedMAS_HOME/conf/WLANs/*.conf > $EmbedMAS_HOME/etc/wpa_supplicant/wpa_supplicant.conf
#					$EmbedMAS_HOME/bin/EmbedMAS-NetworkRestart -m default
#				fi
#			fi
		fi
	fi
}


while true
do
	sleep 15
	commands
done
