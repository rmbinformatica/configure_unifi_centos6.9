#!/bin/bash
SCRIPTPATH=`dirname $0`
$SCRIPTPATH/simnao.sh "Deseja instalar as chaves SSH da RMB Informatica" $SCRIPTPATH/rmbkey.sh
echo "Conifgurando a interface de rede eth0 no modo DHCP..."
cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO=dhcp
IPV4_FAILURE_FATAL=yes
NAME="System eth0"
EOF
echo "Atualizando dos pacotes do sistema..."
yum -y update
echo "Instalando os softwares nano, epel, java, unzip e wget..."
yum -y install nano epel-release java-1.8.0-openjdk unzip wget
echo "Instalando o banco de dados mongodb..."
yum -y install mongodb-server
echo "Instalando servidor e cliente de e-mail local..."
yum -y install postfix mailx
echo "Criando usuário ubnt..."
useradd -r ubnt
echo "Informe a URL da versao do UniFi.unix.zip para baixar... (ex.: https://dl.ubnt.com/unifi/5.2.9/UniFi.unix.zip)"
read urlunifi
wget $urlunifi
if [ ! -f UniFi.unix.zip ]; then
    echo "ERRO PACOTE NÃO ENCONTRADO!!!"
    exit 1
else 
	echo "Descompactando o pacote Unifi Unix..."
	unzip -q UniFi.unix.zip -d /opt
	echo "Configurando permissoes para o usuario ubnt..."
	chown -R ubnt:ubnt /opt/UniFi
	echo "Criando diretorio do banco de dados..."
	mkdir -p /data/db
	echo "Definindo permissoes para o mongodb..."
	chown -R mongodb /data/db
	echo "Realizando a primeira inicializacao do banco de dados..."
	service mongod start
	echo "Desativando auto-inicializacao do mongodb..."
	service mongod stop
	chkconfig --del mongod
	echo "Criando servico unifi..."
	mv $SCRIPTPATH/unifi_service /etc/init.d/unifi
	chmod +x /etc/init.d/unifi
	chkconfig --add unifi
	service unifi start
	echo "Informe a rede interna onde as conexões deverão ser liberadas no firewall (ex.: 192.168.0.0/24): " 
	read faixarede
	now=$(date)
	echo "Atualizando script de firewall iptables..."
	cat <<EOF > /etc/sysconfig/iptables
# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
# Modificado pelo script de configuracao do unifi no centos
# em $now
# (C) 2018 RMB Informatica - www.rmbinformatica.com
# Script disponivel em: https://github.com/rmbinformatica/configure_unifi_centos6.9
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -s $faixarede -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT

EOF
	echo "Recarregando firewall..."
	service iptables restart
fi

