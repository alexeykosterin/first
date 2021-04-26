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
    execute immediate 'MERGE INTO packs p1
USING (select * from test_packs_imp) p2 ON (p1.pack_id = p2.pack_id) 
WHEN MATCHED 
THEN UPDATE SET
  
p1.RTPL_RTPL_ID=p2.RTPL_RTPL_ID,
p1.NAME_E=p2.NAME_E,
p1.NAME_R=p2.NAME_R,
p1.EXPIRE_DATE=p2.EXPIRE_DATE,
p1.NAVI_USER=''BASIS-20320;''||(select osuser from v$session where sid=(select sid from v$mystat where rownum=1)),
p1.NAVI_DATE=trunc(sysdate),
p1.PTYP_PTYP_ID=p2.PTYP_PTYP_ID,
p1.AVAIL_DATE=p2.AVAIL_DATE,
p1.DURATION_LIMIT_DATE=p2.DURATION_LIMIT_DATE,
p1.DURATION_MONTHS=p2.DURATION_MONTHS,
p1.DURATION_DAYS=p2.DURATION_DAYS,
p1.POTY_POTY_ID=p2.POTY_POTY_ID,
p1.PCCT_PCCT_ID=p2.PCCT_PCCT_ID,
p1.SWITCH_PACK_ID=p2.SWITCH_PACK_ID,
p1.PACK_CODE=p2.PACK_CODE,
p1.RECURRING_FLAG=p2.RECURRING_FLAG,
p1.CHECK_RTPL_CHARGE=p2.CHECK_RTPL_CHARGE,
p1.IS_LEGACY=p2.IS_LEGACY
 
WHEN NOT MATCHED 
THEN INSERT (PACK_ID,RTPL_RTPL_ID,NAME_E,NAME_R,EXPIRE_DATE,NAVI_USER,NAVI_DATE,PTYP_PTYP_ID,AVAIL_DATE,DURATION_LIMIT_DATE,DURATION_MONTHS,
DURATION_DAYS,POTY_POTY_ID,PCCT_PCCT_ID,SWITCH_PACK_ID,PACK_CODE,RECURRING_FLAG,CHECK_RTPL_CHARGE,IS_LEGACY) 
VALUES (
p2.PACK_ID,p2.RTPL_RTPL_ID,p2.NAME_E,p2.NAME_R,p2.EXPIRE_DATE,''BASIS-20320;''||(select osuser from v$session where sid=(select sid from v$mystat where rownum=1)),trunc(sysdate),
p2.PTYP_PTYP_ID,p2.AVAIL_DATE,p2.DURATION_LIMIT_DATE,p2.DURATION_MONTHS,p2.DURATION_DAYS,p2.POTY_POTY_ID,p2.PCCT_PCCT_ID,p2.SWITCH_PACK_ID,p2.PACK_CODE,p2.RECURRING_FLAG,p2.CHECK_RTPL_CHARGE,p2.IS_LEGACY
)';
commit;
end;
/ 
prompt Done 
exit; 