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
declare
t_name1 number;
t_name2 number;
t_name3 number;
t_name4 number;
begin
  select count(1) into t_name1 from USER_CONS_COLUMNS where lower(table_name) like 'test_packs_imp';
  select count(1) into t_name2 from USER_CONS_COLUMNS where lower(table_name) like 'test_rate_plans_imp';
  select count(1) into t_name3 from USER_CONS_COLUMNS where lower(table_name) like 'test_mth_clusters_imp';
  select count(1) into t_name4 from USER_CONS_COLUMNS where lower(table_name) like 'test_mth_tarif_histories_imp';
  if t_name1 = 0 then
    execute immediate 'create table test_packs_imp as select * from packs where 1=2';
  end if;
  if t_name2 = 0 then
    execute immediate 'create table test_rate_plans_imp as select * from rate_plans where 1=2';
  end if;
  if t_name3 = 0 then
    execute immediate 'create table test_mth_clusters_imp as select * from mth_clusters where 1=2';
  end if;
  if t_name4 = 0 then
    execute immediate 'create table test_mth_tarif_histories_imp as select * from mth_tarif_histories where 1=2';
  end if;
end;
/ 
prompt Done 
exit; 