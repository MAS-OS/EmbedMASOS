#! /bin/sh
EmbedMAS_HOME=/opt/EmbedMAS

firstBoot=`cat $EmbedMAS_HOME/conf/firstBoot.conf`

if [ $firstBoot -eq 1 ];then
	echo INICIANDO_O_SISTEMA_PELA_PRIMEIRA_VEZ
	$EmbedMAS_HOME/bin/firstBoot.sh
fi

$EmbedMAS_HOME/bin/task/taskMaster.sh &
$EmbedMAS_HOME/bin/testGateway.sh &
$EmbedMAS_HOME/lib/tomcat/bin/catalina.sh start &
