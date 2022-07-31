#! /bin/sh
EmbedMAS_HOME=/opt/EmbedMAS
EmbedMAS_TMP=/tmp/.embedMAS
mkdir -p $EmbedMAS_TMP

while getopts f:l:m:-: flag
do
    case "${flag}" in
        f) file=${OPTARG};;
        l) log=${OPTARG};;
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
        if [ "$file" = "" ]; then
            file=$EmbedMAS_HOME/root/EmbeddedMAS/*.mas2j
        fi
        directory="$(dirname "${file}")" 
        cd $directory
        timestamp=`date`
        echo "*************************" >> $EmbedMAS_TMP/embeddedMAS.log
        echo "[$timestamp] Starting SMA" >> $EmbedMAS_TMP/embeddedMAS.log
        /usr/bin/java -Xms$memory -jar $EmbedMAS_HOME/lib/jason/lib/jason.jar $file -console >> $EmbedMAS_TMP/embeddedMAS.log 2>> $EmbedMAS_TMP/embeddedMAS.log &
        pid=$!
        echo $pid > $EmbedMAS_TMP/embeddedMAS.pid
        echo "Executando SMA, processo $pid"
        
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
elif [ "$opt" = "import" ]; then
    if [ "$file" != "" ]; then
        rm -rf $EmbedMAS_TMP/embeddedmasIN
        mkdir -p $EmbedMAS_TMP/embeddedmasIN
        unzip $file -d $EmbedMAS_TMP/embeddedmasIN/
        mas2jFile=`find $EmbedMAS_TMP/embeddedmasIN/ | grep .mas2j | tail -1 | xargs`
        directory="$(dirname "${mas2jFile}")"
        rm -rf $EmbedMAS_HOME/root/EmbeddedMAS/*
        mv -v $directory/* $EmbedMAS_HOME/root/EmbeddedMAS/
    fi
fi

if [ "$log" = "term" ]; then
    tail -f $EmbedMAS_TMP/embeddedMAS.log
elif [ "$log" = "clear" ]; then
    echo "EmbeddedMAS Log" > $EmbedMAS_TMP/embeddedMAS.log
    echo "Cleaning EmbeddedMAS Log"
#elif [ "$log" = "web" ]; then
#    pid=`cat $EmbedMAS_TMP/logWeb.pid 2> /dev/null`
#   if [ "$pid" = "" ]; then
#        cd $EmbedMAS_HOME/lib/logstation/
#        /usr/bin/java -jar $EmbedMAS_HOME/lib/logstation/logstation.jar &
#        pid=$!
#        echo $pid > $EmbedMAS_TMP/logWeb.pid
#        echo "Iniciado <a href=\"http://rosie.embed.masos.org:2064\" target=\"_blank\"> Log Web </a>, processo $pid"
#    else
#        echo "Em execução <a href=\"http://rosie.embed.masos.org:2064\" target=\"_blank\"> Log Web </a>, processo $pid"
#    fi
#elif [ "$log" = "stopWeb" ]; then
#    pid=`cat $EmbedMAS_TMP/logWeb.pid 2> /dev/null`
#    if [ "$pid" != "" ]; then
#        kill -9 $pid
#        rm -rf $EmbedMAS_TMP/logWeb.pid
#        echo "Encerrando Log Web, processo $pid"
#    fi
fi