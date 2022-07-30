#! /bin/sh
EmbedMAS_HOME=/opt/EmbedMAS
EmbedMAS_TMP=/tmp/.embedMAS
mkdir -p $EmbedMAS_TMP

while getopts b:d:i:f:p:s:-: flag
do
    case "${flag}" in
        i) importLib=${OPTARG};;
		d) deploy=${OPTARG};;
		s) sketch=${OPTARG};;
		f) file=${OPTARG};;
		b) board=${OPTARG};;
		p) port=${OPTARG};;
        -) opt=${OPTARG};;
    esac
done

if [ "$opt" = "help" ]; then
	cat $EmbedMAS_HOME/docs/scripts/chonosFirmwareManager.txt
elif [ "$opt" = "list" ]; then
	$EmbedMAS_HOME/lib/arduino/arduino-cli board list | grep arduino > $EmbedMAS_TMP/arduinoboard
	qtd=`cat $EmbedMAS_TMP/arduinoboard | nl | tail -1 | xargs | cut -d " " -f 1`
	echo "{" > $EmbedMAS_TMP/json.out
	i=0
	while read -r LINE; do
		port=`echo $LINE | xargs | cut -d " " -f 1`
		fqbn=`echo $LINE | xargs | cut -d " " -f 8`
		core=`echo $LINE | xargs | cut -d " " -f 9`

		echo "\"Board $i\": {" >> $EmbedMAS_TMP/json.out
			echo "\"Port\": \"$port\"," >> $EmbedMAS_TMP/json.out
			echo "\"FQBN\": \"$fqbn\"," >> $EmbedMAS_TMP/json.out
			echo "\"Core\": \"$core\"" >> $EmbedMAS_TMP/json.out

		i=$((i+1))
		if [ $i -le $((qtd-1)) ]; then
			echo "}," >> $EmbedMAS_TMP/json.out
		else
			echo "}" >> $EmbedMAS_TMP/json.out
		fi
	done < $EmbedMAS_TMP/arduinoboard
	echo "}" >> $EmbedMAS_TMP/json.out
	cat $EmbedMAS_TMP/json.out
elif [ "$opt" = "listLibraries" ]; then
	ls -l $EmbedMAS_HOME/root/Arduino/libraries/ | grep root > $EmbedMAS_TMP/listLibraries
	qtd=`cat $EmbedMAS_TMP/listLibraries | nl | tail -1 | xargs | cut -d " " -f 1`
	echo "{" > $EmbedMAS_TMP/json.out
	i=0
	while read -r LINE; do
		librarie=`echo $LINE | xargs | cut -d " " -f 9`

		echo "\"Lib $i\": {" >> $EmbedMAS_TMP/json.out
			echo "\"Name\": \"$librarie\"" >> $EmbedMAS_TMP/json.out

		i=$((i+1))
		if [ $i -le $((qtd-1)) ]; then
			echo "}," >> $EmbedMAS_TMP/json.out
		else
			echo "}" >> $EmbedMAS_TMP/json.out
		fi
	done < $EmbedMAS_TMP/listLibraries
	echo "}" >> $EmbedMAS_TMP/json.out
	cat $EmbedMAS_TMP/json.out
elif [ "$importLib" != "" ]; then
	unzip -o $importLib -d $EmbedMAS_HOME/root/Arduino/libraries/ > $EmbedMAS_TMP/importLibLog
	cat $EmbedMAS_TMP/importLibLog
elif [ "$sketch" != "" ]; then
	if [ "$file" != "" ]; then
		if [ "$board" != "" ]; then
			rm -rf /tmp/$sketch
			rm -rf $EmbedMAS_TMP/fimrware-log.out
			$EmbedMAS_HOME/lib/arduino/arduino-cli sketch new /tmp/$sketch > $EmbedMAS_TMP/fimrware-log.out
			mv $file /tmp/$sketch/$sketch.ino
			md5sum /tmp/$sketch/* >> $EmbedMAS_TMP/fimrware-log.out
			$EmbedMAS_HOME/lib/arduino/arduino-cli compile --libraries $EmbedMAS_HOME/root/Arduino/libraries/ --fqbn $board /tmp/$sketch >> $EmbedMAS_TMP/fimrware-log.out 2>> $EmbedMAS_TMP/fimrware-log.out
			cat $EmbedMAS_TMP/fimrware-log.out
		fi
	fi
elif [ "$deploy" != "" ]; then
	if [ "$board" != "" ]; then
		if [ "$port" != "" ]; then
			rm -rf $EmbedMAS_TMP/fimrware-log.out
			$EmbedMAS_HOME/lib/arduino/arduino-cli upload --verbose --fqbn $board -p $port /tmp/$deploy >> $EmbedMAS_TMP/fimrware-log.out 2>> $EmbedMAS_TMP/fimrware-log.out
			cat $EmbedMAS_TMP/fimrware-log.out
		fi
	fi
fi