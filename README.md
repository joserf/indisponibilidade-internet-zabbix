# indisponibilidade-internet-zabbix
Enviando notificações de indisponibilidade de internet com Zabbix e Telegram. 

Baixando o repositório do projeto.

    cd /opt; git clone https://github.com/joserf/indisponibilidade-internet-zabbix.git; cd indisponibilidade-internet-zabbix/ 

Edite o arquivo docker-compose.yml e altere conforme desejado.

    $ sudo vim docker-compose.yml
    
Crie as pastas conforme alterado no arquivo YML.

    $ sudo mkdir -p /home/joserf/docker/containers/{grafana/data,zabbix/{alertscripts,mysql/data,scripts}}
    $ sudo chown -R 472:472 /home/joserf/docker/containers/grafana; 
    $ sudo chmod -R 775 /home/joserf/docker/containers/grafana/
    
Subindo os containers Zabbix-Mysql, Zabbix-Server, Zabbix-Agent, Zabbix-Web, Grafana.

    # docker-compose up -d
    
Importe o host hosts_internet.xml, no seu Zabbix.

Copie o arquivo zabbix-telegram.sh para a pasta alertscripts. 

    $ sudo cp zabbix-telegram.sh /home/joserf/docker/containers/zabbix/alertscripts/

Edite o arquivo e preencha os dados de acordo com o seu cenário, nas linhas 18,20,21 e 26. 

    $ sudo vim zabbix-telegram.sh
