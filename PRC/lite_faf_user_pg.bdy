create or replace package body bis.lite_faf_user_pg2 is
  --
  ---@ BIS
  ----- Server part of the "Customer Service" application (USER package)
  -----  is to be modified manually (not re-written at the 'Customer Service" application installation)
  ------ 033.02
  --
  -- Customer Service
  --
  -- Copyright (c) 2004 Peter-Service
  --
  -- Eugenia Samorodova
  --
  --
  -- 033.02, 13.05.2004
  --   E.Samorodova Created.
  --
  current_version_pb constant varchar2(20) := '033.02';
  --
  -- The phone number validity control (raise returned in case of error)
  procedure validate_phone
  (
    p_fafg_id faf_groups.fafg_id%type, p_phone fafs.phone%type,
    -- external phone
    p_faf_subs_id subscribers.subs_id%type,
    -- internal phone
    p_start_date fafs.start_date%type
  ) is
  begin
    null;
  end;
  --
  -- procedure which processes the FAF group creation
  procedure on_create_fafg
  (
    p_subs_id subscribers.subs_id%type,
    p_fafg_id faf_groups.fafg_id%type,
    p_start_date faf_groups.start_date%type
  ) is
  begin
    for rec in (

    select decode(rtpf.faft_faft_id, 3, 2152, 4, 2153, 5, 2154, 6, 2155,7,2156, 8,2157, 0) slrs_id from faf_groups ffg,rtpl_faft rtpf
    where ffg.fafg_id=p_fafg_id and ffg.rtpf_rtpf_id=rtpf.rtpf_id

/*    select decode(fd.faft_faft_id, 3, 2152, 4, 2153, 5, 2154, 6, 2155) slrs_id
                  from fafs f, favored_directions fd
                 where f.fafg_fafg_id = p_fafg_id and
                       fd.favd_id = f.favd_favd_id
*/                       
                       
                )
    loop
       if rec.slrs_id <> 0 then

      bis_engine.SRV_CHANGE_STATUS(SERVICE_ID => rec.slrs_id,
                                   SUBSCRIBER_ID => p_subs_id, STATUS => 4,
                                   OPERATION_DATE => p_start_date
                                   );
        end if;                    
    end loop;
  end;
  --
  -- procedure which processes the FAF group deletion
  procedure on_delete_fafg
  (
    p_fafg_id faf_groups.fafg_id%type, p_operation_date faf_groups.end_date%type
  ) is
  begin
    for rec in (
/*    select decode(fd.faft_faft_id, 3, 2152, 4, 2153, 5, 2154, 6, 2155) slrs_id,
                       f.subs_subs_id
                  from fafs f, favored_directions fd
                 where f.fafg_fafg_id = p_fafg_id and
                       fd.favd_id = f.favd_favd_id
*/                       

    select decode(rtpf.faft_faft_id, 3, 2152, 4, 2153, 5, 2154, 6, 2155,7,2156, 8,2157, 0) slrs_id, ffg.subs_subs_id from faf_groups ffg,rtpl_faft rtpf
    where ffg.fafg_id=p_fafg_id and ffg.rtpf_rtpf_id=rtpf.rtpf_id                       
                     
                       )
    loop
    
        if rec.slrs_id <> 0 then
    
          bis_engine.SRV_CHANGE_STATUS(SERVICE_ID => rec.slrs_id,
                                       SUBSCRIBER_ID => rec.subs_subs_id,
                                       STATUS => 6,
                                       OPERATION_DATE => p_operation_date
                                       );
        end if;                                   
    
    end loop;
  end;
  --
  -- procedure which processes the FAF group modification
  procedure on_recalc_fafg
  (
    p_fafg_id faf_groups.fafg_id%type, p_start_date date
  ) is
  begin
    null;
  end;
  --
  -- procedure which enters charges for operations with FAF; the operation id is transmitted as parameter
  procedure on_make_charge
  (
    p_subs_id fafs.subs_subs_id%type, p_fafg_id faf_groups.fafg_id%type,
    p_prcl_id price_list.prcl_id%type, p_amount in out charges.amount_$%type
  ) is
    p_count   number; -- ���������� ��������� � �������� �������
    p_zone    zones.zone_id%type; -- ���� ��������
    p_rtpl_id rate_plans.rtpl_id%type; -- ������������� ���
  begin
  
    select sh.rtpl_rtpl_id, sh.zone_zone_id
      into p_rtpl_id, p_zone
      from subs_histories sh
     where sh.subs_subs_id = p_subs_id and
           sysdate between sh.start_date and sh.end_date - 1 / 86400;
    -- ��� �������� � ��������  
    if sysdate between to_date('15.05.2007', 'DD.MM.YYYY') and
       to_date('01.08.2007', 'DD.MM.YYYY') - 1 / 86400 and P_ZONE in (12) and
       P_RTPL_ID in (218) then
      select count(1)
        into p_count
        from fafs f
       where f.navi_date between to_date('15.05.2007', 'DD.MM.YYYY') and
             to_date('01.08.2007', 'DD.MM.YYYY') - 1 / 86400 and
             f.rtpl_rtpl_id in (218) and
             f.factor<>0 and
             f.subs_subs_id = p_subs_id;
      --��������� ����������� ���� ��������� ������ 3-� ������� ������� - ���������
      if P_COUNT < 4 then
        for rec in (select 1
                      from mss_saratov_subscribers
                     where subs_subs_id = p_subs_id)
        loop
          p_amount := 0;
        end loop;
      end if;
    end if;
  
  end;
  --
  -- procedure which determines whether the number is internal or external (redefines the standard procedure)
  -- (in case it must be determined automatically and the operator cannot specify it)
  -- p_phone - phone number
  -- p_faf_subs_id - the result of the standard check procedure is transmitted to the procedure
  -- p_faf_subs_id  is subs_id (for internal phone number) or null (for external phone number)
  -- If the control way is not the standard one, then the correct overridden value
  -- is to be retuned to p_faf_subs_id
  procedure on_is_internal_phone
  (
    p_phone in fafs.phone%type, p_faf_subs_id in out subscribers.subs_id%type
  ) is
  begin
    null;
  end;
  --
  -- procedure which determines factor for the phone if using "By selection" method
  -- (in case it must be determined automatically and the operator cannot specify it)
  function on_get_select_factor
  (
    p_fafg_id faf_groups.fafg_id%type, p_phone fafs.phone%type,
    -- external phone
    p_faf_subs_id subscribers.subs_id%type,
    -- internal phone
    p_start_date fafs.start_date%type
  ) return fafs.factor%type is
  begin
    return null;
  end;
  --
end lite_faf_user_pg;
/
