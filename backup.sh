#!/bin/sh
#
#
#Global Vars
BACKUP_NAME="$(date +%Y%m%d_%H%M).zip"
#
#
#DB_DUMPING
if [ -d "/input/.mysql_init" ]; then
    rm -Rf /input/.mysql_init
    mkdir -p /input/.mysql_init
    echo "[$(date)] Renitilize database init directory"
else
    mkdir -p /input/.mysql_init
    echo "[$(date)] Create new database init directory"
fi
/usr/bin/mysqldump -u root --password=$DB_ROOT_PASSWORD --host=$DB_HOST $DB_NAME >/input/.mysql_init/dump.sql
if [ "$?" -eq "0" ]; then
    echo "[$(date)] Database successfully dumped."
else
    echo "[$(date)] Error : Fail to dump database"
fi
#
#
#COMPRESSING
echo "[$(date)] Compressing...Please wait!"
zip -qq -r /output/$BACKUP_NAME /input 2>&1
if [ "$?" -eq "0" ]; then
    echo "[$(date)] Backup files successfully compressed."
else
    echo "[$(date)] Error : Fail to compress files!"
    exit
fi
#
#
#S3_UPLOAGIN
#echo "[$(date)] Uploading to S3 bucket... Please wait"
#aws s3api put-object --bucket $S3_BUCKET --key $BACKUP_NAME --body /$TMP/$BACKUP_NAME 2>&1
#if [ "$?" -eq "0" ]; then
#    echo "[$(date)] Uploading to S3 Bucket=$S3_BUCKET successfully done."
#else
#    echo "[$(date)] Error: Fail uploading to S3 Bucket."
#    exit
#fi
#
#
#CleaningUP
#echo "[$(date)] Cleaning tmp..."
#rm /output/$BACKUP_NAME
#if [ "$?" -eq "0" ]; then
#    echo "[$(date)] Clean up local old backup from /output."
#else
#    echo "[$(date)] Error: Fail to clean up local old backup from /output."
#    exit
#fi
#
#
#Done!
echo " "
echo "[$(date)] >>Buckup successfully done, Ref=$BACKUP_NAME"
exit