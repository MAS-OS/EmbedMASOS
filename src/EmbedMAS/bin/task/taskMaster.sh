#! /bin/sh

commands(){
	taskExec=`cat /tmp/task.conf`
	if [ $taskExec -eq 1 ]; then
		echo tem-coisa
		echo 0 > /tmp/task.conf
		/tmp/taskExec.sh
	else
		sleep 10
	fi
}

echo "[  OK  ] Ativando o taskMaster"
ls /tmp/taskMaster.alive 2> /dev/null >/dev/null
[ $? -eq 0 ] && echo "EM-Execucao" && exit 0
touch /tmp/taskMaster.alive
echo 0 > /tmp/task.conf

while true
do
	commands
done
