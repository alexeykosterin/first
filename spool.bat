@mode con cp select=1251
cd C:\Users\A.Kosterin\Desktop\SPOOL
:: формируем первый spool
echo prompt Start the unloading process... > IMPORT.sql
echo set colsep ';' >> IMPORT.sql
echo set echo off >> IMPORT.sql
echo set feedback off >> IMPORT.sql
echo set linesize 1000 >> IMPORT.sql
echo set pagesize 0 >> IMPORT.sql
echo set sqlprompt '' >> IMPORT.sql
echo set trimspool on >> IMPORT.sql
echo set headsep off >> IMPORT.sql

echo SPOOL C:\Users\A.Kosterin\Desktop\SPOOL\temp.txt; >> IMPORT.sql
echo select LISTAGG(column_name, '^^^|^^^|'';''^^^|^^^|') WITHIN GROUP (order by column_id) as list from user_tab_columns t where lower(table_name) = '%1' group by table_name; >> IMPORT.sql
echo spool off; >> IMPORT.sql
echo prompt Done >> IMPORT.sql
echo exit; >> IMPORT.sql

SQLPLUS "bis/employer@ALPHA" @IMPORT.sql


Set file=C:\Users\A.Kosterin\Desktop\SPOOL\temp.txt
For /F "usebackq tokens=* delims=" %%q In ("%file%") Do Set var=%%q
echo %var% > C:\Users\A.Kosterin\Desktop\SPOOL\BD\BIS_TEST_EACP\%1.txt

echo prompt Start the unloading process... > %1.sql
echo set colsep ';' >> %1.sql
echo set echo off >> %1.sql
echo set feedback off >> %1.sql
echo set linesize 1000 >> %1.sql
echo set pagesize 0 >> %1.sql
echo set sqlprompt '' >> %1.sql
echo set trimspool on >> %1.sql
echo set headsep off >> %1.sql

echo alter session set nls_date_format="dd.mm.yyyy hh24:mi:ss"; >> %1.sql
echo SPOOL C:\Users\A.Kosterin\Desktop\SPOOL\%1.ALPHA.csv; >> %1.sql
echo select %var% from %1; >> %1.sql

echo spool off; >> %1.sql
echo prompt Done >> %1.sql
echo exit; >> %1.sql

SQLPLUS "bis/employer@ALPHA" @%1.sql