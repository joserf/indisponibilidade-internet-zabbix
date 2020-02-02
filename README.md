# indisponibilidade-internet-zabbix
Enviando notificações de indisponibilidade de internet com Zabbix e Telegram. 

1- Baixando o repositório do projeto.

    cd /opt; git clone https://github.com/joserf/indisponibilidade-internet-zabbix.git; cd indisponibilidade-internet-zabbix/ 

2- Edite o arquivo docker-compose.yml e altere conforme desejado.

    $ sudo vim docker-compose.yml
    
3- Crie as pastas conforme alterado no arquivo YML.

    $ sudo mkdir -p /home/joserf/docker/containers/{grafana/data,zabbix/{alertscripts,mysql/data,scripts}}
    $ sudo chown -R 472:472 /home/joserf/docker/containers/grafana/ 
    $ sudo chmod -R 775 /home/joserf/docker/containers/grafana/
    
4- Subindo os containers Zabbix-Mysql, Zabbix-Server, Zabbix-Agent, Zabbix-Web, Grafana.

    # docker-compose up -d
    
5- Importe o host hosts_internet.xml, no seu Zabbix.

    http://192.168.0.171:8282

6- Edite o arquivo e preencha os dados de acordo com o seu cenário, nas linhas 18,20,21 e 26. 

    $ sudo vim zabbix-telegram.sh

7- Copie o arquivo zabbix-telegram.sh para a pasta alertscripts. 

    $ sudo cp zabbix-telegram.sh /home/joserf/docker/containers/zabbix/alertscripts/

8- Configurando o Zabbix

    Zabbix:

    Administração
    Tipos de mídias

    Nome: Telegram Gráficos
    Tipo: Script
    Nome script: zabbix-telegram.sh

    Parâmetros do script: {ALERT.SENDTO}
    {ALERT.SUBJECT}
    {ALERT.MESSAGE}

<img src=images/01.png/>

    Administração
    Usuários
    Admin

    Mídia:
    Adicionar:

    Tipo: Telegram Gráficos
    Enviar para: ID do seu grupo
    Ativo quando: 1-7,00:00-24:00

<img src=images/02.png/>

    Configuração
    Ações

    Origem do evento: Triggers

    Ação:

    Nome: Reportar Problema no Telegram (Queda de link de internet)

    Nova condição 

    Incidente suprimido | não
    Trigger | igual SELECIONE:

    Grupo: Internet | Host: Internet
    [x] Unavailable by ICMP ping 

<img src=images/03.png/>

    Operações:

    Duração padrão do passo da operação: 1h

    Operações de recuperação:

    Assunto padrão: Internet restabelecida após: {EVENT.AGE}
    Mensagem padrão: Item Graphic: [{ITEM.ID1}]
    IP/DNS: {HOST.CONN}

    Operações

    Tipo da operação: Enviar mensagem
    Enviar para usuários: Admin (Zabbix Administrator)
    Enviar apenas para: Telegram Gráficos

<img src=images/04.png/>

<img src=images/05.png/>
