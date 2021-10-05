#!/bin/sh
LogoPrint() {
    cat <<"EOF"



  ____             _               ___   _____ ____  
 |  _ \           | |             |__ \ / ____|___ \ 
 | |_) | __ _  ___| | ___   _ _ __   ) | (___   __) |
 |  _ < / _` |/ __| |/ / | | | '_ \ / / \___ \ |__ < 
 | |_) | (_| | (__|   <| |_| | |_) / /_ ____) |___) |
 |____/ \__,_|\___|_|\_\\__,_| .__/____|_____/|____/ 
                             | |                     
                             |_|                     

    S3 BACKUP CONTAINER (R) 2021 V1.0
    by SAKLY Ayoub
    saklyayoub@gmail.com



EOF
}
SetupS3Credential() {
    aws configure set aws_access_key_id $AWS_ACCESS
    aws configure set aws_secret_access_key $AWS_SECRET
    aws configure set default.region $AWS_REGION
    echo "[$(date)] Setting up AWS credentials."
}
CronSetup(){
cat <<EOT >> /crontab.conf
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
${CRON_TIME} /usr/bin/backup.sh >> /var/log/s3backup.log 2>&1
EOT
    crontab /crontab.conf
    echo "[$(date)] Setting up cron configuration."
}

LogoPrint
SetupS3Credential
touch /var/log/s3backup.log
tail -F /var/log/s3backup.log &
CronSetup
echo "[$(date)] >>Running backup on cron task manager"
exec cron -f