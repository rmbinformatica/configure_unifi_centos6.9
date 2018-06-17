# configure_unifi_centos6.9 #
Script de auto instalação e configuração do gerenciador ubiquiti unifi em uma instalação limpa do CentOS 6.9 i386

### Requisitos ###

CentOS 6.9 i386 com instalação limpa.
[ Download da imagem ISO](http://isoredirect.centos.org/centos/6/isos/i386/)

### Como executar esse script ###

Considerando uma instalação limpa do CentOS minimal, não haverá configuração de rede (será configurada via dhcp pelo script). Obtenha um endereço IP do dhcp com o comando:
```
dhclient
```

Realize a instalação do GIT, através do comando:
```
yum -y install git
```

Baixe o arquivo do repositório github:
```
git clone https://github.com/rmbinformatica/configure_unifi_centos6.9.git
```

Execute o instalador
```
configure_unifi_centos6.9/setup.sh 
```

### O que este instalador irá realizar ###

* Instala das chaves SSH da RMB Informática (opcional)
* Desabilita o acesso mediante senha no servidor SSH (se as chaves forem instaladas)
* Configura a interface de rede eth0 no modo DHCP
* Realiza a atualização de pacotes do sistema
* Instala os softwares:
    1. nano
    2. epel-release
    3. java-1.8.0-openjdk
    4. unzip
    5. wget
    6. mongodb server (banco de dados usado pelo unifi)
    7. postfix (e-mail interno, usado para redefinicao de senha)
    8. mailx (cliente de e-mail modo texto)
* Cria do usuário ubnt
* Realiza download do arquivo UniFi.unix.zip (URL deve ser informada pelo usuario)
* Instala do UniFi Unix
* Cria o banco de dados
* Configura os serviços de inicialização
* Configura o firewall para permitir acesso interno
 
### Limitação de responsabilidade ###

Este software é fornecido como apresentado. Qualquer dúvida ou dificuldade a cerca da instalação é de responsabilidade do usuário. 
Caso deseje obter suporte pago entre em contato com nossa empresa através do site [ RMB Informática ](http://www.rmbinformatica.com)

### Contribuição ###

Elaborado por [ Renato Monteiro Batista ](http://871982.xyz) em 2018.



