#!/bin/bash <br>
#Variaveis <br>
SERVICE="httpd" <br>
STATUS=$(systemctl is-active $SERVICE) <br>
TIMESTAMP=$(date +"%d-%m-%Y %H:%M:%S") <br>
NFS_DIR="/mnt/nfs_share/thiago" <br>
ONLINE_MSG="Positivo, o Apache está ONLINE" <br>
OFFLINE_MSG="Desculpe, mas o Apache está OFFLINE" <br>

#Verificando se o Apacha está Online ou Offline <br>
if [ "$STATUS" = "active" ]; then <br>
    echo "$TIMESTAMP - $SERVICE - $STATUS - $ONLINE_MSG" >> "$NFS_DIR/apache_online.log" <br>
else <br>
    echo "$TIMESTAMP - $SERVICE - $STATUS - $OFFLINE_MSG" >> "$NFS_DIR/apache_offline.log" <br>
fi 
