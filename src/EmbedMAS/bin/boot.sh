#! /bin/sh
EmbedMAS_HOME=/opt/EmbedMAS
EmbedMAS_TMP=/tmp/.embedMAS
EmbedMAS_LOGFILE=$EmbedMAS_TMP/embeddedMAS.log
mkdir -p $EmbedMAS_TMP

firstBoot=`cat $EmbedMAS_HOME/conf/firstBoot.conf`
if [ $firstBoot -eq 1 ];then
	echo "Primeira inicialização do sistema. Executando Instalador"
	$EmbedMAS_HOME/bin/firstBoot.sh
	$EmbedMAS_HOME/bin/task/taskMaster.sh &
	/usr/bin/chonosWifiConf -m ap
	echo "Processo de Instalação terminado. Reiniciando o Sistema"
	sleep 10
	reboot
else
	data=`date`
	echo "[ChonOS] Iniciando o sistema $data" > $EmbedMAS_LOGFILE
	$EmbedMAS_HOME/bin/task/taskMaster.sh &
	$EmbedMAS_HOME/bin/testGateway.sh &
	$EmbedMAS_HOME/bin/EmbedMAS-SysConf start &
	#WebLog
	tail -f $EmbedMAS_LOGFILE | wtee -b *:2064 2> /dev/null > /dev/null &
fi
exit 0