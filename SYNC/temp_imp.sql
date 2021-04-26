prompt Start the unloading process... 
set colsep ';' 
set echo off 
set feedback off 
set linesize 1000 
set pagesize 0 
set sqlprompt '' 
set trimspool on 
set headsep off 
set serveroutput on 
SPOOL temp.txt; 
declare 
p_column_name varchar2(20) := 'ZONE_ZONE_ID'; 
p_id clob := '0'; 
sql_qry varchar2(600); 
emp_count number(10); 
begin 
for rec in (select distinct t.table_name as forSelect1, COLUMN_NAME as forSelect2 From USER_CONSTRAINTS t 
inner join USER_CONS_COLUMNS tt on tt.table_name = t.table_name 
where t.constraint_type in ('P','R') 
and tt.column_name like '%'||p_column_name||'%' and t.table_name in ('TRAFIC_HISTORIES')) loop 
sql_qry:= 'select count(1) from '||rec.forselect1||' where '||rec.forselect2||' in ('||p_id||')'; 
EXECUTE IMMEDIATE sql_qry INTO emp_count; 
if emp_count > 0 then 
execute immediate  
      'declare 
      p_table_col clob; 
      v_c clob; 
      begin  
      select LISTAGG(column_name, ''||'''';''''||'') WITHIN GROUP (order by column_id) as list into p_table_col from user_tab_columns t where table_name = :1 group by table_name; 
      dbms_output.put_line(''select ''||p_table_col||'' from ''||:1||'' where ''||:2||'' in (''||:3||'') and navi_date = trunc(sysdate);''); 
      end;'  
using rec.forselect1,rec.forselect2,p_id; 
end if; 
end loop; 
end; 
/ 
spool off; 
prompt Done 
exit; 
