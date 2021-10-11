#!/bin/sh
#
#
#Global Vars
. /.env
LogoPrint() {
    cat <<"EOF"



  ____             _                 _____      _          
 |  _ \           | |               / ____|    | |         
 | |_) | __ _  ___| | ___   _ _ __ | |    _   _| |__   ___ 
 |  _ < / _` |/ __| |/ / | | | '_ \| |   | | | | '_ \ / _ \
 | |_) | (_| | (__|   <| |_| | |_) | |___| |_| | |_) |  __/
 |____/ \__,_|\___|_|\_\\__,_| .__/ \_____\__,_|_.__/ \___|
                             | |                           
                             |_|                           


    BACKUP CONTAINER (R) 2021 V1.0
    by SAKLY Ayoub
    saklyayoub@gmail.com



EOF
}
BackupConfig() {
    if [ "$BACKUP_CONF" = "s3" ]; then
        echo "[$(date)] Backup configured on S3"
        aws configure set aws_access_key_id $AWS_ACCESS
        aws configure set aws_secret_access_key $AWS_SECRET
        aws configure set default.region $AWS_REGION
        echo "[$(date)] Setting up AWS credentials."
    elif [ "$BACKUP_CONF" = "local" ]; then
        echo "[$(date)] Backup configured locally"
    else
        echo "[$(date)] Error: BACKUP_CONF=\"$BACKUP_CONF\" from .env must be \"local\" or \"s3\" only!"
        exit
    fi
}
CronSetup(){
cat <<EOT >> /crontab.conf
${CRON_TIME} /backup.sh >> /var/log/s3backup.log 2>&1 
EOT
    crontab /crontab.conf
    echo "[$(date)] Setting up cron configuration."
}
LogoPrint
BackupConfig
touch /var/log/s3backup.log
tail -F /var/log/s3backup.log &
CronSetup
echo ""
echo "[$(date)] >>Running backup on cron task manager"
exec cron -f
