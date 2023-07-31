#/bin/bash

zabbix_db="<db>"
zabbix_db_user="<user>"
sqlplus_client="/usr/lib/oracle/<version>/client<bit for os>/bin/sqlplus"
check="$1"

mass_type[0]="Zabbix agent"
mass_type[2]="Zabbix trapper"
mass_type[3]="Simple check"
mass_type[5]="Zabbix internal"
mass_type[7]="Zabbix agent active"
mass_type[8]="Zabbix aggregate"
mass_type[9]="Web item"
mass_type[10]="External check"
mass_type[11]="Database monitor"
mass_type[12]="IPMI agent"
mass_type[13]="SSH agent"
mass_type[14]="Telnet agent"
mass_type[15]="Calculated"
mass_type[16]="JMX agent"
mass_type[17]="SNMP trap"
mass_type[18]="Dependent item"
mass_type[19]="HTTP agent"
mass_type[20]="SNMP agent"

if [ "$check" = "by type" ]
then
unsupported_by_type=$(${sqlplus_client} -s ${zabbix_db_user}/$(grep -i "^dbpassword" /etc/zabbix/zabbix_server.conf | cut -d "=" -f2)@${zabbix_db} << EOF
  set termout off
  set serveroutput off
  set feedback off
  set lines 32760
  set pagesize 0
  set colsep ';'
  set echo off
  set feedback off
  set linesize 32760
  SET newpage none
  SET verify off
  set trimspool on
  select type,count(*) from items i,item_rtdata i_rt where status=0 and state=1 and i.itemid=i_rt.itemid group by type;
  quit;
EOF
)

for i in $(echo  "$unsupported_by_type" | sed "s/[[:space:]]//g")
do
  echo "${mass_type[$(echo $i | cut -d ";" -f1)]};$(echo $i | cut -d ";" -f2)"
done

elif [ "$check" = "count without will be deleted" ]
then
unsupported_without_deleted=$(${sqlplus_client} -s ${zabbix_db_user}/$(grep -i "^dbpassword" /etc/zabbix/zabbix_server.conf | cut -d "=" -f2)@${zabbix_db} << EOF
  set termout off
  set serveroutput off
  set feedback off
  set lines 32760
  set pagesize 0
  set colsep ';'
  set echo off
  set feedback off
  set linesize 32760
  SET newpage none
  SET verify off
  set trimspool on
  select count(*) from items i,item_rtdata i_rt where status=0 and state=1 and i.itemid=i_rt.itemid and i.itemid NOT IN (select itemid from item_discovery where ts_delete!=0);
  quit;
EOF
)

echo $unsupported_without_deleted

elif [ "$check" = "by type without will be deleted" ]
then
unsupported_by_type=$(${sqlplus_client} -s ${zabbix_db_user}/$(grep -i "^dbpassword" /etc/zabbix/zabbix_server.conf | cut -d "=" -f2)@${zabbix_db} << EOF
  set termout off
  set serveroutput off
  set feedback off
  set lines 32760
  set pagesize 0
  set colsep ';'
  set echo off
  set feedback off
  set linesize 32760
  SET newpage none
  SET verify off
  set trimspool on
  select type,count(*) from items i,item_rtdata i_rt where status=0 and state=1 and i.itemid=i_rt.itemid and i.itemid NOT IN (select itemid from item_discovery where ts_delete!=0) group by type;
  quit;
EOF
)

for i in $(echo  "$unsupported_by_type" | sed "s/[[:space:]]//g")
do
  echo "${mass_type[$(echo $i | cut -d ";" -f1)]};$(echo $i | cut -d ";" -f2)"
done

fi
