load data characterset CL8MSWIN1251
infile      'C:\Users\A.Kosterin\Desktop\SYNC\MTH_CLUSTERS.ALPHA.csv'
badfile     'C:\Users\A.Kosterin\Desktop\SYNC\dump_MTH_CLUSTERS.bad' 
discardfile 'C:\Users\A.Kosterin\Desktop\SYNC\dump_MTH_CLUSTERS.dis'
replace
INTO TABLE test_mth_clusters_imp
FIELDS TERMINATED BY ";" TRAILING NULLCOLS
(
clst_id     ":clst_id", 
def     ":def", 
stnd_stnd_id     ":stnd_stnd_id", 
navi_user     ":navi_user", 
navi_date DATE 'DD.MM.YYYY HH24:MI:SS'
)




