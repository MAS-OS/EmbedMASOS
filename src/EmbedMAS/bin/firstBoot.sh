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

# Scripts
ln -s $EmbedMAS_HOME/bin/EmbedMAS-WifiConn /usr/bin/EmbedMAS-WifiConn
ln -s $EmbedMAS_HOME/bin/EmbedMAS-NetworkRestart /usr/bin/EmbedMAS-NetworkRestart

echo 0 > $EmbedMAS_HOME/conf/firstBoot.conf
reboot
