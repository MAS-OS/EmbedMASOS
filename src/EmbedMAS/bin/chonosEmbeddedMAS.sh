#! /bin/sh
EmbedMAS_HOME=/opt/EmbedMAS
EmbedMAS_TMP=/tmp/.embedMAS
mkdir -p $EmbedMAS_TMP

while getopts f:m:-: flag
do
    case "${flag}" in
        f) file=${OPTARG};;
        m) memory=${OPTARG};;
        -) opt=${OPTARG};;
    esac
done

if [ "$memory" = "" ]; then
	memory="256m"
fi

if [ "$opt" = "help" ]; then
	cat $EmbedMAS_HOME/docs/scripts/chonosEmbeddedMAS.txt
elif [ "$opt" = "start" ]; then
    pid=`cat $EmbedMAS_TMP/embeddedMAS.pid 2> /dev/null`
    if [ "$pid" = "" ]; then
        if [ "$file" != "" ]; then
            directory="$(dirname "${file}")" 
            cd $directory
            timestamp=`date`
            echo "*************************" >> $EmbedMAS_TMP/embeddedMAS.log
            echo "[$timestamp] Starting SMA" >> $EmbedMAS_TMP/embeddedMAS.log
            /usr/bin/java -Xms$memory -jar $EmbedMAS_HOME/lib/jason/lib/jason.jar $file -console >> $EmbedMAS_TMP/embeddedMAS.log 2>> $EmbedMAS_TMP/embeddedMAS.log &
            pid=$!
            echo $pid > $EmbedMAS_TMP/embeddedMAS.pid
            echo "Executando SMA, processo $pid"
        fi
    else
        /usr/bin/chonosEmbeddedMAS --stop
        /usr/bin/chonosEmbeddedMAS --start -f $file
    fi
elif [ "$opt" = "stop" ]; then
    pid=`cat $EmbedMAS_TMP/embeddedMAS.pid 2> /dev/null`
    if [ "$pid" != "" ]; then
        kill -9 $pid
        timestamp=`date`
        echo "[$timestamp] Stoping SMA" >> $EmbedMAS_TMP/embeddedMAS.log
        rm -rf $EmbedMAS_TMP/embeddedMAS.pid
        echo "Encerrando SMA, processo $pid"
    fi
elif [ "$opt" = "log" ]; then
    tail -f $EmbedMAS_TMP/embeddedMAS.log
elif [ "$opt" = "clearLog" ]; then
    rm -rf $EmbedMAS_TMP/embeddedMAS.log
fi

