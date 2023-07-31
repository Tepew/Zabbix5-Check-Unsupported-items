# Zabbix5-Check-Unsupported-items

Tempplate tested and work in zabbix 5.0.X.  
For use this Template you need import  
Template Check Unsupported items.xml  
in you Zabbix  
and linked for your zabbix-server.  
Macros in template  
{$UNSUPPORTED_WARN} - deafult threshold for all types  
{$UNSUPPORTED_WARN:"Calculated"} - you can use user macros with context for set threshold to individual type (f.e. Calculated)  

You need create file for zabbix-agent (file in folder userparameter)  
/etc/zabbix/zabbix_agentd.d/zabbix-server.conf 
and create script with permission for execute to user whats work zabbix-agent (file in folder sccripts)  
/usr/lib/zabbix/externalscripts/unsupported.sh  

Script for Oracle databse, but you can recreate for other DB  
In script you must change variables  

zabbix_db_user  
zabbix_db  
sqlplus_client  
  
Path in you system can be another - before create check all   