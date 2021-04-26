load data characterset CL8MSWIN1251
infile      'C:\Users\A.Kosterin\Desktop\SYNC\PACKS.ALPHA.csv'
badfile     'C:\Users\A.Kosterin\Desktop\SYNC\dump_packs.bad' 
discardfile 'C:\Users\A.Kosterin\Desktop\SYNC\dump_packs.dis'
replace
INTO TABLE test_packs_imp
FIELDS TERMINATED BY ";" TRAILING NULLCOLS
(
pack_id     ":pack_id",
rtpl_rtpl_id     ":rtpl_rtpl_id",
name_e     ":name_e",
name_r     ":name_r",
expire_date     DATE 'DD.MM.YYYY HH24:MI:SS',
navi_user     ":navi_user",
navi_date     DATE 'DD.MM.YYYY HH24:MI:SS',
ptyp_ptyp_id     ":ptyp_ptyp_id",
avail_date     DATE 'DD.MM.YYYY HH24:MI:SS',
duration_limit_date     DATE 'DD.MM.YYYY HH24:MI:SS',
duration_months     ":duration_months",
duration_days     ":duration_days",
poty_poty_id     ":poty_poty_id",
pcct_pcct_id     ":pcct_pcct_id",
switch_pack_id     ":switch_pack_id",
pack_code     ":pack_code",
recurring_flag     ":recurring_flag",
check_rtpl_charge     ":check_rtpl_charge",
is_legacy     ":is_legacy"
)




