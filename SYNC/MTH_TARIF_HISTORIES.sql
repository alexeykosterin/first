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
SPOOL MTH_TARIF_HISTORIES.ALPHA.csv; 
select RTPL_RTPL_ID||';'||PACK_PACK_ID||';'||SRLS_SRLS_ID||';'||BNDL_BNDL_ID||';'||MACR_MACR_ID||';'||BRNC_BRNC_ID||';'||CLST_CLST_ID||';'||MTCG_MTCG_ID||';'||AMOUNT||';'||RATE_FOR_ONE_DAY||';'||FEE_TAX_INCLUDED||';'||TARIF_MODIFY||';'||COMMENTS||';'||START_DATE||';'||END_DATE||';'||NAVI_USER||';'||NAVI_DATE||';'||EVAL_DISC_RATE||';'||EVAL_DISC_DAYS from MTH_TARIF_HISTORIES where BNDL_BNDL_ID in (0) and navi_date = trunc(sysdate); 
spool off; 
prompt Done 
exit; 
