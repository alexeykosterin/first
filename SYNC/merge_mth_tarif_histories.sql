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
    execute immediate 'MERGE INTO mth_tarif_histories p1
USING (select * from test_mth_tarif_histories_imp) p2 ON (p1.rtpl_rtpl_id = p2.rtpl_rtpl_id and p1.pack_pack_id=p2.pack_pack_id and p1.clst_clst_id=p2.clst_clst_id and p1.srls_srls_id=p2.srls_srls_id)
WHEN MATCHED 
THEN UPDATE SET
  
p1.bndl_bndl_id=p2.bndl_bndl_id,
p1.macr_macr_id=p2.macr_macr_id,
p1.brnc_brnc_id=p2.brnc_brnc_id,
p1.mtcg_mtcg_id=p2.mtcg_mtcg_id,
p1.amount=p2.amount,
p1.rate_for_one_day=p2.rate_for_one_day,
p1.fee_tax_included=p2.fee_tax_included,
p1.tarif_modify=p2.tarif_modify,
p1.comments=p2.comments,
p1.start_date=p2.start_date,
p1.end_date=p2.end_date,
p1.navi_user=''BASIS-21827;''||(select osuser from v$session where sid=(select sid from v$mystat where rownum=1)),
p1.navi_date=trunc(sysdate),
p1.eval_disc_rate=p2.eval_disc_rate,
p1.eval_disc_days=p2.eval_disc_days
 
WHEN NOT MATCHED 
THEN INSERT (rtpl_rtpl_id, pack_pack_id, srls_srls_id, bndl_bndl_id, macr_macr_id, brnc_brnc_id, clst_clst_id, mtcg_mtcg_id, amount, rate_for_one_day, fee_tax_included, tarif_modify, comments, start_date, end_date, navi_user, navi_date, eval_disc_rate, eval_disc_days) 
VALUES (
p2.rtpl_rtpl_id, p2.pack_pack_id, p2.srls_srls_id, p2.bndl_bndl_id, p2.macr_macr_id, p2.brnc_brnc_id, p2.clst_clst_id, p2.mtcg_mtcg_id, p2.amount, p2.rate_for_one_day, p2.fee_tax_included, p2.tarif_modify, p2.comments, p2.start_date, p2.end_date, p2.navi_user, p2.navi_date, p2.eval_disc_rate, p2.eval_disc_days
)


';
commit;
end;
/ 
prompt Done 
exit; 