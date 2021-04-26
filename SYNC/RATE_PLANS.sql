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
SPOOL RATE_PLANS.ALPHA.csv; 
select RTPL_ID||';'||NUMBER_HISTORY||';'||SCLS_SCLS_ID||';'||NAME_E||';'||NAME_R||';'||NAME_1||';'||NAME_2||';'||START_DATE||';'||END_DATE||';'||NAVI_USER||';'||NAVI_DATE||';'||TRAF_BY_DIR_#||';'||CTYP_CTYP_ID||';'||CCAT_CCAT_ID||';'||CUR_CUR_ID||';'||STND_STND_ID||';'||XTYP_XTYP_ID||';'||RPTP_RPTP_ID||';'||ACTIVE_START||';'||ACTIVE_END||';'||IS_COMPLECT||';'||BRNC_BRNC_ID||';'||IS_EQUIPMENT||';'||FLAG_MIX||';'||FLAG_ALL_STND||';'||FLAG_ADD_EQPM||';'||ALL_QUANTITY_EQPM||';'||RECURRING_FLAG||';'||IS_LEGACY from RATE_PLANS where RTPL_ID in (3999); 
spool off; 
prompt Done 
exit; 
