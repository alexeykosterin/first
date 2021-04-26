create or replace trigger bis.biu_subs_packs_sonic

  before insert on subs_packs
  for each row
  
when (user != 'SONIC_MIGRATE' and user != 'BIS_BONUS')
declare
  v_ptyp_id pack_types.ptyp_id%type := 0;
  v_start_date date;
  v_end_date date;
begin
  select nvl(ptyp_ptyp_id, 0)
  into v_ptyp_id
  from packs
  where pack_id = :new.pack_pack_id
  ;
--Пакеты лояльности
  if (v_ptyp_id >= 6) and (v_ptyp_id <= 10) then
    v_start_date := :new.start_date;
    --Если подключаем уже началом будущей даты то отодвинем дату начала назад на 1 сек.
    if (v_ptyp_id <> 6) and (v_start_date >= trunc(sysdate + 1)) and (trunc(v_start_date) = v_start_date)
     then v_start_date := v_start_date - 1/86400;     
    end if;
    count_bonus_interval(v_ptyp_id - 3, v_start_date, v_start_date, v_end_date);  
    :new.start_date := v_start_date;
    :new.end_date := v_end_date;
  end if;
exception
  when others then null;
end;
/
