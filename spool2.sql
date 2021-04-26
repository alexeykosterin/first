set colsep ';'
set echo off
set feedback off
set linesize 1000
set pagesize 0
set sqlprompt ''
set trimspool on
set headsep off

SPOOL C:\Users\A.Kosterin\Desktop\SPOOL\dump.txt;
select /*+parallel (c,10)*/distinct                 
                codg.codetown,
                codg.name,
                c.codetown,
                c.name,
                v.name,
                z.name,
        z.is_mobile,
        z.vnzone,
        v.cod
from  t_mts_cod_ref codg  ,  
         (select distinct crr.mts_c_id,
                       crr.code_region,
                       crr.codetown,
                       crr.mts_cod_id_out,
                       codgg.name,
                       crr.mts_type_vnd_id,
                       crr.mts_zone_id
          from t_mts_c_ref  crr, t_mts_cod_ref codgg  
          where crr.mts_cod_id=codgg.mts_cod_id) c,
      t_mts_type_cross_vnd v,
      t_mts_zone z
      where  c.mts_cod_id_out=codg.mts_cod_id
      and v.mts_type_vnd_id=c.mts_type_vnd_id
      and z.mts_zone_id=c.mts_zone_id
      and codg.date_end is null
      and v.cod in (4)    
      and rownum <5  
      order by 
                codg.name,                
                c.codetown,
                z.name
                ;

spool off;
prompt Done
exit;
