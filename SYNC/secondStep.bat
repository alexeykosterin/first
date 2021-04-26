@mode con cp select=1251
:: cd C:\Users\A.Kosterin\Desktop\SPOOL
:: формируем первый spool
for /f "tokens=3 eol=, delims=;" %%i in (column_name.txt) do (set var=%%i)
for /f "tokens=2 eol=, delims=;" %%k in (column_name.txt) do (Set var_id=%%k)
echo prompt Start the unloading process... > temp_imp.sql
echo set colsep ';' >> temp_imp.sql
echo set echo off >> temp_imp.sql
echo set feedback off >> temp_imp.sql
echo set linesize 1000 >> temp_imp.sql
echo set pagesize 0 >> temp_imp.sql
echo set sqlprompt '' >> temp_imp.sql
echo set trimspool on >> temp_imp.sql
echo set headsep off >> temp_imp.sql
echo set serveroutput on >> temp_imp.sql
echo SPOOL temp.txt; >> temp_imp.sql
echo declare >> temp_imp.sql
echo p_column_name varchar2(20) := '%1'; >> temp_imp.sql
echo p_id clob := '%var_id%'; >> temp_imp.sql
echo sql_qry varchar2(600); >> temp_imp.sql
echo emp_count number(10); >> temp_imp.sql
echo begin >> temp_imp.sql
echo for rec in (select distinct t.table_name as forSelect1, COLUMN_NAME as forSelect2 From USER_CONSTRAINTS t >> temp_imp.sql
echo inner join USER_CONS_COLUMNS tt on tt.table_name = t.table_name >> temp_imp.sql
echo where t.constraint_type in ('P','R') >> temp_imp.sql
echo and tt.column_name like '%%'^|^|p_column_name^|^|'%%' and t.table_name in (%var%)) loop >> temp_imp.sql
echo sql_qry:= 'select count(1) from '^|^|rec.forselect1^|^|' where '^|^|rec.forselect2^|^|' in ('^|^|p_id^|^|')'; >> temp_imp.sql
echo EXECUTE IMMEDIATE sql_qry INTO emp_count; >> temp_imp.sql
echo if emp_count ^> 0 then >> temp_imp.sql
echo execute immediate  >> temp_imp.sql
echo       'declare >> temp_imp.sql
echo       p_table_col clob; >> temp_imp.sql
echo       v_c clob; >> temp_imp.sql
echo       begin  >> temp_imp.sql
echo       select LISTAGG(column_name, ''^|^|'''';''''^|^|'') WITHIN GROUP (order by column_id) as list into p_table_col from user_tab_columns t where table_name = :1 group by table_name; >> temp_imp.sql
echo       dbms_output.put_line(''select ''^|^|p_table_col^|^|'' from ''^|^|:1^|^|'' where ''^|^|:2^|^|'' in (''^|^|:3^|^|'') and navi_date = trunc(sysdate);''); >> temp_imp.sql
echo       end;'  >> temp_imp.sql
echo using rec.forselect1,rec.forselect2,p_id; >> temp_imp.sql
echo end if; >> temp_imp.sql
echo end loop; >> temp_imp.sql
echo end; >> temp_imp.sql
echo ^/ >> temp_imp.sql
echo spool off; >> temp_imp.sql
echo prompt Done >> temp_imp.sql
echo exit; >> temp_imp.sql

SQLPLUS "bis/employer@BETA" @temp_imp.sql


for /f "tokens=2 eol= delims=mw" %%i in (temp.txt) do (Set var_table=%%i)
set var_table=%var_table: =%
:: echo %var_table% > %var_table%.txt


echo prompt Start the unloading process... > %var_table%.sql
echo set colsep ';' >> %var_table%.sql
echo set echo off >> %var_table%.sql
echo set feedback off >> %var_table%.sql
echo set linesize 1000 >> %var_table%.sql
echo set pagesize 0 >> %var_table%.sql
echo set sqlprompt '' >> %var_table%.sql
echo set trimspool on >> %var_table%.sql
echo set headsep off >> %var_table%.sql

echo alter session set nls_date_format="dd.mm.yyyy hh24:mi:ss"; >> %var_table%.sql
echo SPOOL %var_table%.ALPHA.csv; >> %var_table%.sql

::for /f "tokens=* eol=, delims=" %%i in (temp.txt) do (Set var_select=%%i)
::echo %var_select% >> %var_table%.sql
for /f "usebackq tokens=* eol= delims=" %%i in (temp.txt) do (echo %%i >> %var_table%.sql)

echo spool off; >> %var_table%.sql
echo prompt Done >> %var_table%.sql
echo exit; >> %var_table%.sql

SQLPLUS "bis/employer@BETA" @%var_table%.sql
