create or replace procedure bis.EVENT_210189(
PSUBS_ID IN SUBSCRIBERS.SUBS_ID%TYPE,
POLD_CLNT_ID IN CLIENTS.CLNT_ID%TYPE,
PNEW_CLNT_ID IN CLIENTS.CLNT_ID%TYPE,
PNEW_RTPL_ID IN RATE_PLANS.RTPL_ID%TYPE,
P_OPERATION_DATE IN DATE DEFAULT SYSDATE) IS
/*
Имя пользовательской процедуры, вызываемой перед передачей абонента другому клиенту.
Параметр служит для задания имени пользовательской процедуры, вызываемой перед передачей абонента другому клиенту. Входными параметрами процедуры являются: идентификатор абонента, идентификаторы старого и нового клиента, идентификатор нового тарифного плана.
Используется поле VALUE_STRING.
Значение по умолчанию - NULL.
Формат процедуры:
PROCEDURE TEST (
P_SUBS_ID IN SUBSCRIBERS.SUBS_ID%TYPE,
P_OLD_CLNT_ID IN CLIENTS.CLNT_ID%TYPE,
P_NEW_CLNT_ID IN CLIENTS.CLNT_ID%TYPE,
P_NEW_RTPL_ID IN RATE_PLANS.RTPL_ID%TYPE);

*/

	V_COMMIT_STATE BOOLEAN default BIS_ENGINE.GET_COMMIT_STATE;
	v_exists_serv boolean := false;
	v_spgr_id spg.spgr_id%type;
	v_temp_num number;

begin

	BIS_ENGINE.SET_COMMIT_STATE(FALSE); -- отключаем COMMIT-ы

     --Акция Мы вместе!
     --SUBS_GROUPS_PG.ON_CHANGE_AB_OWNER(P_SUBS_ID => PSUBS_ID,P_NEW_CLNT_ID =>  PNEW_CLNT_ID, P_NEW_RTPL_ID => PNEW_RTPL_ID);
	 
	--Иванов М.Д. добавляем абонента в СПГ
	--№3-0-GD-П08-30/08 от 18.08.2008
	--есть ли абоненты у нового клиента на служебых ТП и "Сотруднике"
	for rec in (select * from subs_clnt_histories sch join subs_histories sh
		on(sch.subs_subs_id=sh.subs_subs_id and sch.clnt_clnt_id=pnew_clnt_id and
			sch.sbst_sbst_id in (2,3) and sysdate between sch.start_date and sch.end_date-1/24/60/60 and
			sysdate between sh.start_date and sh.end_date-1/24/60/60 and sh.rtpl_rtpl_id in (41,42,43,44,45,98))) loop
		v_exists_serv := true;
		exit;
	end loop;

	if(
		(sysdate between to_date('20.08.2008','dd.mm.yyyy') and to_date('15.09.2008 08','dd.mm.yyyy hh24') 
			and (v_exists_serv or pnew_rtpl_id in (41,42,43,44,45,98) or pnew_clnt_id in (10,44398,3484067)
				or pold_clnt_id in (10,44398,3484067))
		) or
		sysdate>to_date('15.09.2008 08','dd.mm.yyyy hh24')
		
	)then
		--добавим в СПГ нового клиента, если есть
		v_spgr_id := bis.sib_insert_into_spg (pnew_clnt_id,psubs_id);
		bis.sys_logs_autonom(10000
			,'EVENT_210189_add_spg: spgr_id=' || to_char(nvl(v_spgr_id,-1)) ||
				', subs_id=' || to_char(psubs_id) || ', old_clnt_id=' || to_char(pold_clnt_id) ||
				', new_clnt_id=' || to_char(pnew_clnt_id) || ', pnew_rtpl_id=' || to_char(pnew_rtpl_id) ||
				', user=' || user || '.'
			,3,null,null); 
		--удалим их всех СПГ, кроме только что добавленной
		v_temp_num := bis.sib_delete_from_all_spg(psubs_id,nvl(v_spgr_id,-1));
		bis.sys_logs_autonom(10000
			,'EVENT_210189_del_spg: spg_count=' || to_char(v_temp_num) ||
				', subs_id=' || to_char(psubs_id) || ', old_clnt_id=' || to_char(pold_clnt_id) ||
				', new_clnt_id=' || to_char(pnew_clnt_id) || ', pnew_rtpl_id=' || to_char(pnew_rtpl_id) ||
				', user=' || user || '.'
			,3,null,null); 
	end if;
    
    --Тихомиров Д.В. 26.11.2010 
    for rec in (select * from subs_packs where subs_subs_id = psubs_id and sysdate between start_date and end_date and pack_pack_id in
        (select pack_pack_id from tarif_histories where sysdate between start_date and end_date and srls_srls_id in (2133,2120))) loop
      BIS_ENGINE.SET_COMMIT_STATE(V_COMMIT_STATE);
	  raise_application_error(-20000,
																'Невозможно передача абонента другому клиенту с подключенным пакетом');
      
      exit;
    end loop;
	 
	BIS_ENGINE.SET_COMMIT_STATE(V_COMMIT_STATE);

exception when others then 
	BIS_ENGINE.SET_COMMIT_STATE(V_COMMIT_STATE);
	bis.sys_logs_autonom(10000
		,'EVENT_210189_ERR: sqlcode=' || sqlcode || ', sqlerrm=' || sqlerrm || 
			', subs_id=' || to_char(psubs_id) || ', old_clnt_id=' || to_char(pold_clnt_id) ||
			', new_clnt_id=' || to_char(pnew_clnt_id) || ', pnew_rtpl_id=' || to_char(pnew_rtpl_id) ||
			', user=' || user || '.'
		,1,null,null); 
end ;
/
