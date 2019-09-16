#!/bin/bash

LOG=/var/lib/postgresql/bkp.log
BKPDATE=`date +%Y-%m-%d-%H%M%S`

echo " " >> $LOG
echo " " >> $LOG
echo "|-----------------------------------------------" >> $LOG
echo "$(date +'%d/%m/%Y - %H:%M:%S') - Iniciando dump" >> $LOG
nice -n 20 pg_dump company_production > /var/lib/postgresql/company_production-$BKPDATE.sql
echo "$(date +'%d/%m/%Y - %H:%M:%S') - Iniciando compactacao e envio para storage" >> $LOG
nice -n 20 gzip -9 /var/lib/postgresql/company_production-$BKPDATE.sql
nice -n 20 mv /var/lib/postgresql/company_production-$BKPDATE.sql.gz /bkp/
echo "$(date +'%d/%m/%Y - %H:%M:%S') - Executando retenção para últimos 30 dias" >> $LOG
find /bkp -name "*sql.gz" -ctime +30 -exec rm -f {} \;

echo "$(date +'%d/%m/%Y - %H:%M:%S') - BKP finalizado" >> $LOG
echo "|-----------------------------------------------" >> $LOG
echo " " >> $LOG
echo " " >> $LOG

exit 0
