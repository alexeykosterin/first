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
SPOOL TRAFIC_HISTORIES.ALPHA.csv; 
select SRLS_SRLS_ID||';'||ZNTP_ZNTP_ID||';'||NUMBER_HISTORY||';'||TMCL_TMCL_ID||';'||BSS_BSS_ID||';'||ZONE_ZONE_ID||';'||LCAL_LCAL_ID||';'||RTPL_RTPL_ID||';'||PACK_PACK_ID||';'||PSET_PSET_ID||';'||PRICE_$||';'||PSET_COST_$||';'||CONNECTION_$||';'||FUNCTION_NAME||';'||START_DATE||';'||END_DATE||';'||NAVI_USER||';'||NAVI_DATE||';'||FAFT_FAFT_ID||';'||SCPR_SCPR_ID||';'||RTGR_RTGR_ID||';'||PTTP_PTTP_ID||';'||COU_COU_ID||';'||RMOP_RMOP_ID||';'||AOB_AOB_ID||';'||VUNT_VUNT_ID||';'||RTCM_RTCM_ID||';'||FLAG_CS||';'||TFRG_TFRG_ID||';'||HOME_TFRG_ID||';'||HOME_RMOP_ID||';'||RMTP_RMTP_ID||';'||ACTN_ACTN_ID||';'||MUNT_MUNT_ID||';'||MSRU_MSRU_ID||';'||PRICE_ID||';'||DRCT_DRCT_ID||';'||CALL_COU_ID from TRAFIC_HISTORIES where ZONE_ZONE_ID in (0) and navi_date = trunc(sysdate); 
spool off; 
prompt Done 
exit; 
