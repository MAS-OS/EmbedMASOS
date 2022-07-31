#! /bin/sh
EmbedMAS_HOME=/opt/EmbedMAS
EmbedMAS_TMP=/tmp/.embedMAS
EmbedMAS_LOGFILE=$EmbedMAS_TMP/embeddedMAS.log

commands(){
	taskExec=`cat /tmp/task.conf`
	if [ $taskExec -eq 1 ]; then
		echo "Nova Tarefa para executar" > $EmbedMAS_LOGFILE
		echo 0 > /tmp/task.conf
		/tmp/taskExec.sh
	else
		sleep 10
	fi
}

echo "[  OK  ] Ativando o taskMaster" > $EmbedMAS_LOGFILE
ls /tmp/taskMaster.alive 2> /dev/null >/dev/null
[ $? -eq 0 ] && echo "EM-Execucao" && exit 0
touch /tmp/taskMaster.alive
echo 0 > /tmp/task.conf

while true
do
	commands
done
