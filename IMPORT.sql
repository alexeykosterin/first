prompt Start the unloading process... 
set colsep ';' 
set echo off 
set feedback off 
set linesize 1000 
set pagesize 0 
set sqlprompt '' 
set trimspool on 
set headsep off 
SPOOL C:\Users\A.Kosterin\Desktop\SPOOL\temp.txt; 
select LISTAGG(column_name, '^|^|'';''^|^|') WITHIN GROUP (order by column_id) as list from user_tab_columns t where lower(table_name) = '' group by table_name; 
spool off; 
prompt Done 
exit; 
