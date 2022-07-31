#! /bin/sh
clear
echo "Installing EmbedMAS				[OK]"

EmbedMAS_HOME=/opt/EmbedMAS

# Desabilitando o usuário Pi e habilitando o root
chpasswd < $EmbedMAS_HOME/conf/rootPassDefault.conf
passwd -l pi
echo "Lock Pi User and Allow root			[OK]"

# Copiando pacotes mínimos
mv /var/cache/apt/archives /var/cache/apt/archives.OLD
ln -s $EmbedMAS_HOME/var/cache/apt/archives /var/cache/apt/archives
#echo "Coping Debian packages				[OK]"

# Copiando arquivos de conf
mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.bkp
cat $EmbedMAS_HOME/conf/WLANs/base.conf > $EmbedMAS_HOME/etc/wpa_supplicant/wpa_supplicant.conf
cat $EmbedMAS_HOME/conf/WLANs/modeAp.conf >> $EmbedMAS_HOME/etc/wpa_supplicant/wpa_supplicant.conf
ln -s $EmbedMAS_HOME/etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf

mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bkp
ln -s $EmbedMAS_HOME/etc/ssh/sshd_config /etc/ssh/sshd_config
systemctl enable ssh

mv /etc/dhcpcd.conf /etc/dhcpcd.conf.bkp
ln -s $EmbedMAS_HOME/etc/dhcpcd.conf /etc/dhcpcd.conf


# Configurando relogio do sistema
apt install /var/cache/apt/archives/chrony_4.0-8+deb11u2_armhf.deb  -y
mv /etc/chrony/chrony.conf /etc/chrony/chrony.conf.bkp
ln -s $EmbedMAS_HOME/etc/chrony/chrony.conf /etc/chrony/chrony.conf

# Configurando DHCP Server
apt install $EmbedMAS_HOME/var/cache/apt/archives/isc-dhcp-server_4.4.1-2.3_armhf.deb -y
mv /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bkp
ln -s $EmbedMAS_HOME/etc/default/isc-dhcp-server /etc/default/isc-dhcp-server
mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bkp
ln -s $EmbedMAS_HOME/etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf

# Configurando o hostname
mv /etc/hostname /etc/hostname.bkp
ln -s $EmbedMAS_HOME/etc/hostname /etc/hostname
mv /etc/hosts /etc/hosts.bkp
ln -s $EmbedMAS_HOME/etc/hosts /etc/hosts


# Scripts
ln -s $EmbedMAS_HOME/bin/chonosWifiConn.sh /usr/bin/chonosWifiConn
ln -s $EmbedMAS_HOME/bin/chonosWifiConf.sh /usr/bin/chonosWifiConf
ln -s $EmbedMAS_HOME/bin/chonosFirmwareManager.sh /usr/bin/chonosFirmwareManager
ln -s $EmbedMAS_HOME/bin/chonosEmbeddedMAS.sh /usr/bin/chonosEmbeddedMAS
ln -s $EmbedMAS_HOME/bin/task/taskNew.sh /usr/bin/EmbedMAS-NewTask


# Instalando o JAVA
apt install $EmbedMAS_HOME/var/cache/apt/archives/libcups2_2.3.3op2-3+deb11u2_armhf.deb -y
apt install $EmbedMAS_HOME/var/cache/apt/archives/openjdk-8-jre_8u312-b07-1+rpi1_armhf.deb -y


# Instalando o Python pyserial
apt install $EmbedMAS_HOME/var/cache/apt/archives/libexpat1_2.2.10-2+deb11u3_armhf.deb -y
apt install $EmbedMAS_HOME/var/cache/apt/archives/libexpat1-dev_2.2.10-2+deb11u3_armhf.deb -y
apt install $EmbedMAS_HOME/var/cache/apt/archives/python3-pip_20.3.4-4+rpt1_all.deb -y
pip install --no-index --find-links $EmbedMAS_HOME/var/cache/pip/ pyserial
pip install --no-index --find-links $EmbedMAS_HOME/var/cache/pip/ wtee

# Instalando DNSUtils
apt install $EmbedMAS_HOME/var/cache/apt/archives/bind9-libs_1%3a9.16.27-1~deb11u1_armhf.deb -y
apt install $EmbedMAS_HOME/var/cache/apt/archives/bind9-dnsutils_1%3a9.16.27-1~deb11u1_armhf.deb -y
apt install $EmbedMAS_HOME/var/cache/apt/archives/dnsutils_1%3a9.16.27-1~deb11u1_all.deb -y

# Instalando JQ
apt install $EmbedMAS_HOME/var/cache/apt/archives/jq_1.6-2.1_armhf.deb -y

apt clean; apt autoclean; apt autoremove -y

#Conf user
ln -s $EmbedMAS_HOME/root/.java /root/.java
ln -s $EmbedMAS_HOME/root/.jason /root/.jason
ln -s $EmbedMAS_HOME/root/.arduino15 /root/.arduino15
ln -s $EmbedMAS_HOME/root/Arduino /root/Arduino
ln -s $EmbedMAS_HOME/root/EmbeddedMAS /root/EmbeddedMAS

/usr/bin/chonosWifiConf -m ap

echo 0 > $EmbedMAS_HOME/conf/firstBoot.conf
reboot
