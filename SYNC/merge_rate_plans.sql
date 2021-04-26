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
    execute immediate 'MERGE INTO rate_plans p1
USING (select * from test_rate_plans_imp) p2 ON (p1.rtpl_id = p2.rtpl_id) 
WHEN MATCHED 
THEN UPDATE SET
  
p1.number_history=p2.number_history, 
p1.scls_scls_id=p2.scls_scls_id, 
p1.name_e=p2.name_e, 
p1.name_r=p2.name_r, 
p1.name_1=p2.name_1, 
p1.name_2=p2.name_2, 
p1.start_date=p2.start_date, 
p1.end_date=p2.end_date, 
p1.navi_user=''BASIS-20320;''||(select osuser from v$session where sid=(select sid from v$mystat where rownum=1)),
p1.navi_date=trunc(sysdate), 
p1.traf_by_dir_#=p2.traf_by_dir_#, 
p1.ctyp_ctyp_id=p2.ctyp_ctyp_id, 
p1.ccat_ccat_id=p2.ccat_ccat_id, 
p1.cur_cur_id=p2.cur_cur_id, 
p1.stnd_stnd_id=p2.stnd_stnd_id, 
p1.xtyp_xtyp_id=p2.xtyp_xtyp_id, 
p1.rptp_rptp_id=p2.rptp_rptp_id, 
p1.active_start=p2.active_start, 
p1.active_end=p2.active_end, 
p1.is_complect=p2.is_complect, 
p1.brnc_brnc_id=p2.brnc_brnc_id, 
p1.is_equipment=p2.is_equipment, 
p1.flag_mix=p2.flag_mix, 
p1.flag_all_stnd=p2.flag_all_stnd, 
p1.flag_add_eqpm=p2.flag_add_eqpm, 
p1.all_quantity_eqpm=p2.all_quantity_eqpm, 
p1.recurring_flag=p2.recurring_flag, 
p1.is_legacy=p2.is_legacy
 
WHEN NOT MATCHED 
THEN INSERT (rtpl_id, number_history, scls_scls_id, name_e, name_r, name_1, name_2, start_date, end_date, navi_user, navi_date, traf_by_dir_#, ctyp_ctyp_id, ccat_ccat_id, cur_cur_id, stnd_stnd_id, xtyp_xtyp_id, rptp_rptp_id, active_start, active_end, is_complect, brnc_brnc_id, is_equipment, flag_mix, flag_all_stnd, flag_add_eqpm, all_quantity_eqpm, recurring_flag, is_legacy) 
VALUES (
p2.rtpl_id, p2.number_history, p2.scls_scls_id, p2.name_e, p2.name_r, p2.name_1, p2.name_2, p2.start_date, p2.end_date, ''BASIS-20320;''||(select osuser from v$session where sid=(select sid from v$mystat where rownum=1)),trunc(sysdate), p2.traf_by_dir_#, p2.ctyp_ctyp_id, p2.ccat_ccat_id, p2.cur_cur_id, p2.stnd_stnd_id, p2.xtyp_xtyp_id, p2.rptp_rptp_id, p2.active_start, p2.active_end, p2.is_complect, p2.brnc_brnc_id, p2.is_equipment, p2.flag_mix, p2.flag_all_stnd, p2.flag_add_eqpm, p2.all_quantity_eqpm, p2.recurring_flag, p2.is_legacy
)';
commit;
end;
/ 
prompt Done 
exit; 