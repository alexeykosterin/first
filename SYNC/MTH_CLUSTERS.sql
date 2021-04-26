prompt Start the unloading process... 
set colsep ';' 
set echo off 
set feedback off 
set linesize 1000 
set pagesize 0 
set sqlprompt '' 
set trimspool on 
set headsep off 
alter session set nls_date_format="dd.mm.yyyy hh24:mi:ss"; 
SPOOL MTH_CLUSTERS.ALPHA.csv; 
spool off; 
prompt Done 
exit; 
