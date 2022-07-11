#! /bin/sh
clear

EmbedMAS_HOME=/opt/EmbedMAS

ln -s $EmbedMAS_HOME/etc/apt/sources.list.d/embedmasos.list /etc/apt/sources.list.d/embedmasos.list

# Instalando o JAVA
apt install $EmbedMAS_HOME/var/cache/apt/archives/openjdk-8-jre_8u312-b07-1+rpi1_armhf.deb -y

# Instalando o Python pyserial
apt install $EmbedMAS_HOME/var/cache/apt/archives/python3-pip_20.3.4-4+rpt1_all.deb -y
pip install --no-index --find-links $EmbedMAS_HOME/var/cache/pip/ pyserial

# Instalando o Git
#apt install $EmbedMAS/var/cache/apt/archives/git_1%3a2.30.2-1_armhf.deb -y

# Arduino
#ln -s $EmbedMAS_HOME/lib/arduino/.arduino15 /root/.arduino15
#ln -s $EmbedMAS_HOME/lib/maven/.m2 /root/.m2


