prompt Start the unloading process... 
set colsep ';' 
set echo off 
set feedback off 
set linesize 1000
set pagesize 0 
set sqlprompt '' 
set trimspool on 
set headsep off 
SPOOL "C:\Users\A.Kosterin\Desktop\Applications\PortableGit-2.19.1-64-bit\psm_config\components\prices\202104091330\ubs_inst_pl_detail_charges.csv"; 
alter session set nls_date_format = 'dd.mm.yyyy';
select CGTP_CGTP_ID||';'||SRLS_SRLS_ID||';'||RTPL_RTPL_ID||';'||PACK_PACK_ID||';'||PRCL_PRCL_ID||';'||DETG_DETG_ID||';'||START_DATE||';'||END_DATE||';'||'INSERT' from bis.DETAIL_CHARGES where prcl_prcl_id in (select var_id from aak_t_rating);
spool off; 
SPOOL "C:\Users\A.Kosterin\Desktop\Applications\PortableGit-2.19.1-64-bit\psm_config\components\prices\202104091330\ubs_inst_pl_detail_local_calls.csv"; 
select LCAL_LCAL_ID||';'||SRLS_SRLS_ID||';'||ZNTP_ZNTP_ID||';'||ZONE_ZONE_ID||';'||MSC_ID||';'||DRCT_DRCT_ID||';'||FAFT_FAFT_ID||';'||RTPL_RTPL_ID||';'||PACK_PACK_ID||';'||RPDR_RPDR_ID||';'||DETG_DETG_ID||';'||START_DATE||';'||END_DATE||';'||RMTP_RMTP_ID||';'||RTGR_RTGR_ID||';'||'INSERT' from bis.detail_local_calls where rtgr_rtgr_id in (select var_id*100 from aak_t_rating);

spool off;
SPOOL "C:\Users\A.Kosterin\Desktop\Applications\PortableGit-2.19.1-64-bit\psm_config\components\prices\202104091330\ubs_inst_pl_rating_groups.csv"; 
select RTGR_ID||';'||DEF||';'||NAVI_USER||';'||NAVI_DATE||';'||'INSERT' From bis.rating_groups where rtgr_id in (select var_id * 100 from aak_t_rating) and navi_date = to_date('02.04.2021','dd.mm.yyyy');

spool off;
prompt Done 
exit; 
