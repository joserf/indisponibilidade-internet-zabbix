# indisponibilidade-internet-zabbix
Enviando notificações de indisponibilidade de internet com Zabbix e Telegram. 

Edite o arquivo docker-compose.yml e altere conforme desejado.

    $ sudo vim docker-compose.yml
    
Crie as pastas conforme alterado no arquivo YML.

    $ sudo mkdir -p 
    
Subindo os containers Zabbix-Mysql, Zabbix-Server, Zabbix-Agent, Zabbix-Web, Grafana.

    # docker-compose up -d
    
Importe o host hosts_internet.xml, no seu Zabbix.

Copie o arquivo zabbix-telegram.sh para a pasta  

    $ sudo cp zabbix-telegram.sh /home/joserf/docker/containers/zabbix/alertscripts/

Edite o arquivo e preencha os dados de acordo com o seu cenário, nas linhas 18,20,21 e 26. 

    $ sudo vim zabbix-telegram.sh
