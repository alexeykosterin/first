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
begin
    execute immediate 'MERGE INTO mth_clusters p1
USING (select * from test_mth_clusters_imp) p2 ON (p1.clst_id = p2.clst_id) 
WHEN MATCHED 
THEN UPDATE SET
  
p1.def=p2.def, 
p1.stnd_stnd_id=p2.stnd_stnd_id, 
p1.navi_user=''BASIS-20320;''||(select osuser from v$session where sid=(select sid from v$mystat where rownum=1)), 
p1.navi_date=trunc(sysdate)
 
WHEN NOT MATCHED 
THEN INSERT (clst_id, def, stnd_stnd_id, navi_user, navi_date) 
VALUES (
p2.clst_id, p2.def, p2.stnd_stnd_id, ''BASIS-20320;''||(select osuser from v$session where sid=(select sid from v$mystat where rownum=1)), trunc(sysdate)
)';
commit;
end;
/ 
prompt Done 
exit; 