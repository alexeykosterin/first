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
SPOOL PACKS.ALPHA.csv; 
select PACK_ID||';'||RTPL_RTPL_ID||';'||NAME_E||';'||NAME_R||';'||EXPIRE_DATE||';'||NAVI_USER||';'||NAVI_DATE||';'||PTYP_PTYP_ID||';'||AVAIL_DATE||';'||DURATION_LIMIT_DATE||';'||DURATION_MONTHS||';'||DURATION_DAYS||';'||POTY_POTY_ID||';'||PCCT_PCCT_ID||';'||SWITCH_PACK_ID||';'||PACK_CODE||';'||RECURRING_FLAG||';'||CHECK_RTPL_CHARGE||';'||IS_LEGACY from PACKS where PACK_ID in (4165); 
spool off; 
prompt Done 
exit; 
