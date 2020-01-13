#!/bin/bash
#
# Modificado do github de diegosmaia https://github.com/diegosmaia/zabbix-telegram 
#

MAIN_DIRECTORY="/usr/lib/zabbix/alertscripts"

USER=$1
SUBJECT=$2
SUBJECT="${SUBJECT//,/ }"
MESSAGE="chat_id=${USER}&text=$3"
GRAPHID=$3
GRAPHID=$(echo $GRAPHID | grep -o -E "(Item Graphic: \[[0-9]{7}\])|(Item Graphic: \[[0-9]{6}\])|(Item Graphic: \[[0-9]{5}\])|(Item Graphic: \[[0-9]{4}\])|(Item Graphic: \[[0-9]{3}\])")
GRAPHID=$(echo $GRAPHID | grep -o -E "([0-9]{7})|([0-9]{6})|([0-9]{5})|([0-9]{4})|([0-9]{3})")

ZABBIXMSG="/tmp/zabbix-message-$(date "+%Y.%m.%d-%H.%M.%S").tmp"
# Endereço do Zabbix
ZBX_URL="http://192.168.X.X:8282"
# Conta de usuário do Zabbix
USERNAME=""
PASSWORD=""
# Zabbix Versao >= 3.4.1
# 0 para nao e 1 para sim
ZABBIXVERSION34="1"
# Token Telegram
BOT_TOKEN=''

case $GRAPHID in
	''|*[!0-9]*) ENVIA_GRAFICO=0 ;;
	*) ENVIA_GRAFICO=1 ;;
esac

ENVIA_GRAFICO=1
ENVIA_MESSAGE=0

case $GRAPHID in
    ''|*[!0-9]*) ENVIA_GRAFICO=0 ;;
esac

WIDTH=800
CURL="/usr/bin/curl"
COOKIE="/tmp/telegram_cookie-$(date "+%Y.%m.%d-%H.%M.%S")"
PNG_PATH="/tmp/telegram_graph-$(date "+%Y.%m.%d-%H.%M.%S").png"

PERIOD=10800

if [ "$#" -lt 3 ]
then
	exit 1
fi

echo "$MESSAGE" > $ZABBIXMSG
${CURL} -k -s -c ${COOKIE} -b ${COOKIE} -s -X GET "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage?chat_id=${USER}&text=\"${SUBJECT}\""  > /dev/null

if [ "$ENVIA_MESSAGE" -eq 1 ]
then
	${CURL} -k -s -c ${COOKIE} -b ${COOKIE} --data-binary @${ZABBIXMSG} -X GET "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage"  > /dev/null
fi

if [ $(($ENVIA_GRAFICO)) -eq '1' ]; then

		${CURL} -k -s -c ${COOKIE} -b ${COOKIE} -d "name=${USERNAME}&password=${PASSWORD}&autologin=1&enter=Sign%20in" ${ZBX_URL}"/index.php" > /dev/null
		# ${CURL} -k -s -c ${COOKIE} -b ${COOKIE} -d "name=${USERNAME}&password=${PASSWORD}&autologin=1&enter=Conectar-se" ${ZBX_URL}"/index.php" > /dev/null

	if [ "${GRAPHID}" == "000001" ]; then
		GRAPHID="00002";
		${CURL} -k -s -c ${COOKIE} -b ${COOKIE} -d "graphid=${GRAPHID}&period=${PERIOD}&width=${WIDTH}" ${ZBX_URL}"/chart2.php" -o "${PNG_PATH}";
	elif [ "${GRAPHID}" == "000002" ]; then
		GRAPHID="00003";
		${CURL} -k -s -c ${COOKIE}  -b ${COOKIE} -d "graphid=${GRAPHID}&period=${PERIOD}&width=${WIDTH}" ${ZBX_URL}"/chart2.php" -o "${PNG_PATH}";
	elif [ "${GRAPHID}" == "000003" ]; then
		GRAPHID="00004";
		${CURL} -k -s -c ${COOKIE}  -b ${COOKIE} -d "graphid=${GRAPHID}&period=${PERIOD}&width=${WIDTH}" ${ZBX_URL}"/chart2.php" -o "${PNG_PATH}";
	else
		
		if [ "${ZABBIXVERSION34}" == "1" ]; then
			${CURL} -k -s -c ${COOKIE}  -b ${COOKIE} -d "itemids=${GRAPHID}&period=${PERIOD}&width=${WIDTH}&profileIdx=web.item.graph" ${ZBX_URL}"/chart.php" -o "${PNG_PATH}";
		else
			${CURL} -k -s -c ${COOKIE}  -b ${COOKIE} -d "itemids=${GRAPHID}&period=${PERIOD}&width=${WIDTH}" ${ZBX_URL}"/chart.php" -o "${PNG_PATH}";
		fi
	fi

	${CURL} -k -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendPhoto" -F chat_id="${USER}" -F photo="@${PNG_PATH}" > /dev/null

fi
rm -f ${COOKIE}
rm -f ${PNG_PATH}
rm -f ${ZABBIXMSG}
exit 0
