prompt Start the unloading process...
SET heading OFF; ---заголовок колонки
SET echo OFF;
SET feedback OFF;
SET verify OFF;
SET define OFF;
--SET termout OFF; --- вывод на экран процесса
SET timing OFF;
set colsep ';' hea off;
set trimspool on;

SPOOL C:\Users\A.Kosterin\Desktop\SPOOL\log.log;
select ' ' || 'a' || ' ', ' ' || 'b' || ' ' from dual;

spool off;
prompt Done
exit;
