CREATE OR REPLACE PROCEDURE BIS.SIB_CHANG_CLNT_PACKS_REVOKE(p_Clnt_Id number, p_New_Clcl number)
IS
/* Колесников С.С. 25.01.2008 отключение пакетов «Офис в кармане 0(25, 50, 150, 300)»,
   «Упр. удал. объектами 15(25, 35, 100, 150, 300)» при смене класса клиента */
v_Ptype   number(10);
Begin

  For Rec in (select subs_subs_id from bis.subs_clnt_histories where (sysdate between start_date and end_date-1/24/60/60) and clnt_clnt_id=p_Clnt_Id and sbst_sbst_id!=4) Loop
    If p_New_Clcl not in (3,5,6,7) Then    
      For Rec1 in (select pack_pack_id from subs_packs where sysdate between start_date and end_date-1/24/60/60 and subs_subs_id=Rec.subs_subs_id) loop
        select ptyp_ptyp_id into v_Ptype from packs where pack_id = Rec1.pack_pack_id;
        if v_Ptype in (31, 32, 33, 34, 35, 36, 37, 64, 65, 66, 104, 105, 172,173,174,175,176
          --Тихомиров 23.06.2011 забираем УУО и Информ
          ,32,33,34,64,65,66,225,458,579,888,889,890,891,892,893,894,895,896,897,898,899,900,901,902,903,904,905,906,907,908,909,
          910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,938,939,
          940,941,942,943,944,945,946,947,948,949,950,951,952,953,954,955,
          --SMS-Информ 10000_Vip
          885
          ) then
          bis.bis_engine.REVOKE_PACK_SERVICE(Rec.subs_subs_id,Rec1.pack_pack_id);
        end if;
      end loop;
    End If;
    --Тихомиров Д.В. 24.03.2010 отключение УУО при смене класса клиента "Приказ Об обновлении тарифов на услугу для копоративных клиентов "Управление удаленными объектами"" №5/3-0-DD-П03-53/10
    if p_NEW_CLCL not in (3,5,6)  then
      for rec_p in (select * from subs_packs where subs_subs_id = rec.subs_subs_id and sysdate < end_date and pack_pack_id in (select pack_id from packs where ptyp_ptyp_id in (454,453,452,451,450,449,448,447,446,445,444,443,442,441,440,
          439,438,437,436,435,434,433,432,431,430,429,428,427,426,425,424,423,
          --5/3-0-DD-П08-38/11 Соколов Д.Е. 25.08.2011 "СМС-Информ"
          --Приказ  5/3-0-DD-П12-01/11 Светлов А.Н. 06.12.2011 "СМС-Информ 0.07" добавлен ptyp_id=1044
					988, 989, 990, 991, 992, 993,1044))) loop
        bis.bis_engine.revoke_pack_service(psubs_id => rec.subs_subs_id,ppack_id => rec_p.pack_pack_id);
        exit;
      end loop;
    end if;  
  
	

--Светлов 10.02.2012 Приказ #1151586,О вводе опций для ФКК 
---отключение УУО при смене класса клиента
   if p_NEW_CLCL not in (3,5,6,14)  then
      for rec_p in (select * from subs_packs where subs_subs_id = rec.subs_subs_id and sysdate < end_date and pack_pack_id in 
				(select pack_id from packs where ptyp_ptyp_id in (1081))) loop
        bis.bis_engine.revoke_pack_service(psubs_id => rec.subs_subs_id,ppack_id => rec_p.pack_pack_id);
        exit;
      end loop;
    end if;  

	End Loop;
End ;
/
