#! /bin/sh
EmbedMAS_HOME=/opt/EmbedMAS
EmbedMAS_TMP=/tmp/.embedMAS
EmbedMAS_LOGFILE=$EmbedMAS_TMP/embeddedMAS.log
mkdir -p $EmbedMAS_TMP
data=`date`
echo "[ChonOS] Iniciando o sistema $data" > $EmbedMAS_LOGFILE

firstBoot=`cat $EmbedMAS_HOME/conf/firstBoot.conf`

if [ $firstBoot -eq 1 ];then
	echo INICIANDO_O_SISTEMA_PELA_PRIMEIRA_VEZ
	$EmbedMAS_HOME/bin/firstBoot.sh
fi

$EmbedMAS_HOME/bin/task/taskMaster.sh &
$EmbedMAS_HOME/bin/testGateway.sh &
$EmbedMAS_HOME/bin/EmbedMAS-SysConf start &

#WebLog
tail -f $EmbedMAS_LOGFILE | wtee -b *:2064 > /dev/null &
