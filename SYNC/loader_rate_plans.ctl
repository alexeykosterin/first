load data characterset CL8MSWIN1251
infile      'C:\Users\A.Kosterin\Desktop\SYNC\RATE_PLANS.ALPHA.csv'
badfile     'C:\Users\A.Kosterin\Desktop\SYNC\dump_RATE_PLANS.bad' 
discardfile 'C:\Users\A.Kosterin\Desktop\SYNC\dump_RATE_PLANS.dis'
replace
INTO TABLE test_rate_plans_imp
FIELDS TERMINATED BY ";" TRAILING NULLCOLS
(
rtpl_id     ":rtpl_id", 
number_history     ":number_history", 
scls_scls_id     ":scls_scls_id", 
name_e     ":name_e", 
name_r     ":name_r", 
name_1     ":name_1", 
name_2     ":name_2", 
start_date     DATE 'DD.MM.YYYY HH24:MI:SS', 
end_date     DATE 'DD.MM.YYYY HH24:MI:SS', 
navi_user     ":navi_user", 
navi_date     DATE 'DD.MM.YYYY HH24:MI:SS', 
traf_by_dir_#     ":traf_by_dir_#", 
ctyp_ctyp_id     ":ctyp_ctyp_id", 
ccat_ccat_id     ":ccat_ccat_id", 
cur_cur_id     ":cur_cur_id", 
stnd_stnd_id     ":stnd_stnd_id", 
xtyp_xtyp_id     ":xtyp_xtyp_id", 
rptp_rptp_id     ":rptp_rptp_id", 
active_start     DATE 'DD.MM.YYYY HH24:MI:SS', 
active_end     DATE 'DD.MM.YYYY HH24:MI:SS', 
is_complect     ":is_complect", 
brnc_brnc_id     ":brnc_brnc_id", 
is_equipment     ":is_equipment", 
flag_mix     ":flag_mix", 
flag_all_stnd     ":flag_all_stnd", 
flag_add_eqpm     ":flag_add_eqpm", 
all_quantity_eqpm     ":all_quantity_eqpm", 
recurring_flag     ":recurring_flag", 
is_legacy     ":is_legacy"
)




