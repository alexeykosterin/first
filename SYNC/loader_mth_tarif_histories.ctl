load data characterset CL8MSWIN1251
infile      'C:\Users\A.Kosterin\Desktop\SYNC\MTH_TARIF_HISTORIES.ALPHA.csv'
badfile     'C:\Users\A.Kosterin\Desktop\SYNC\dump_MTH_TARIF_HISTORIES.bad' 
discardfile 'C:\Users\A.Kosterin\Desktop\SYNC\dump_MTH_TARIF_HISTORIES.dis'
replace
INTO TABLE test_MTH_TARIF_HISTORIES_imp
FIELDS TERMINATED BY ";" TRAILING NULLCOLS
(
rtpl_rtpl_id     ":rtpl_rtpl_id",
pack_pack_id     ":pack_pack_id",
srls_srls_id     ":srls_srls_id",
bndl_bndl_id     ":bndl_bndl_id",
macr_macr_id     ":macr_macr_id",
brnc_brnc_id     ":brnc_brnc_id",
clst_clst_id     ":clst_clst_id",
mtcg_mtcg_id     ":mtcg_mtcg_id",
amount     ":amount",
rate_for_one_day     ":rate_for_one_day",
fee_tax_included     ":fee_tax_included",
tarif_modify     ":tarif_modify",
comments     ":comments",
start_date     DATE 'DD.MM.YYYY HH24:MI:SS',
end_date     DATE 'DD.MM.YYYY HH24:MI:SS',
navi_user     ":navi_user",
navi_date     DATE 'DD.MM.YYYY HH24:MI:SS',
eval_disc_rate     ":eval_disc_rate",
eval_disc_days     ":eval_disc_days"
)