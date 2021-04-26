CREATE OR REPLACE PROCEDURE bis.EVENT_ON_AFTER_CLOSE_SUBS(P_SUBS_ID IN SUBSCRIBERS.SUBS_ID%TYPE, P_CLNT_ID IN CLIENTS.CLNT_ID%TYPE) IS
  v_count        NUMBER;
  v_virtual      NUMBER;
  v_virtual_date DATE;
  v_bills        NUMBER;
  v_balance      NUMBER;
  V_TAX          NUMBER;
  V_TAX$         NUMBER;
  V_COMMENT      VARCHAR2(150);
  v_log_id       NUMBER;
  v_rtpl_id      rate_plans.rtpl_id%type;
BEGIN
  IF USER NOT IN ('BIS') THEN
    SELECT COUNT(*)
      INTO v_COUNT
      FROM subs_clnt_histories
     WHERE clnt_clnt_id = P_CLNT_ID
       AND sbst_sbst_id <> 4
       AND end_date > SYSTIMESTAMP + 1 / 1440
       AND start_date <= SYSTIMESTAMP + 1 / 1440;
    IF lower(USER) NOT LIKE 'carem_%' AND lower(USER) NOT IN ('rm_dealer', 'ibr', 'ibr_voron', 'bis_uni', 'selfcare', 'sbms') THEN
      --вызов процедуры создания обращения "Закрытие абонента"
      bis.mk_cms_bis_event_pkg.CMS_SUBS_CLOSE(P_CLNT_ID, P_SUBS_ID);
    END IF;
  END IF;

  SELECT COUNT(*), MAX(a.adj_date)
    INTO v_virtual, v_virtual_date -- Если FMCG, то заберем неизрасходованные средства
    FROM adjustments a
   WHERE a.clnt_clnt_id = P_CLNT_ID
     AND a.ajtp_ajtp_id = 3
     AND a.ajrs_ajrs_id = 21
     AND a.ajmt_comment = 'Виртуальный FMCG';

  IF v_virtual > 0 THEN
    SELECT nvl(SUM(b.charge_$), -90)
      INTO v_bills
      FROM bills b
     WHERE b.clnt_clnt_id = P_CLNT_ID
       AND b.bill_date >= v_virtual_date;
    SELECT balance_$ INTO v_balance FROM balances b WHERE b.clnt_clnt_id = P_CLNT_ID;
    IF v_bills < 0 AND v_balance < 0 THEN
      V_COMMENT := 'Остаток скидки на Виртуальном FMCG';
      V_TAX     := Lite_Upd_Clients.GET_CLIENT_TAX(P_CLNT_ID, TAX_DATE => SYSDATE);
      V_TAX$    := ROUND(v_balance - v_balance / V_TAX, 4);
      Lite_Upd_Clients.ADD_ADJUSTMENT(P_CLNT_ID, PAJTP_AJTP_ID => 3, PAMOUNT_$ => (-1) * v_balance, PVAT_$ => (-1) * V_TAX$, PLINE_NUM => NULL,
                                      PAMOUNT_R => NULL, PVAT_R => NULL, PADJ_DATE => SYSDATE, PAJMT_COMMENT => V_COMMENT, PAJRS_AJRS_ID => 21,
                                      PPAY_PAY_ID => NULL);
    END IF;
  END IF;
  BEGIN
    FOR rec IN (SELECT sh.subs_subs_id, ns.msisdn, sh.srls_srls_id
                  FROM serv_histories sh, phone_histories ph, number_sets ns
                 WHERE sh.srls_srls_id IN (2012, --Замени гудок
                                           1062, --Teligent_IN
                                           1064, --WEB-управление сообществом
                                           1063, --Глава сообщества (абонплата)
                                           5023, --Запрет отправки развлекательных SMS
                                           5054, --Азан
                                           5044, --Банк памяти
                                           5046, --Мобильная почта
                                           15023, --Основной ресурс
                                           15031, --Менеджер сообщений
                                           15040, --МультиФон
										   15037, --Личный секретарь - останов вызова (больше не используется)
											15038, --Личный секретарь - переадресация вызова (больше не используется)
											15039, --Личный секретарь - персональные сообщения (больше не используется)
											15049, --Личный секретарь - Ваш новый номер
											15089, --Личный секретарь
											15090, --Личный секретарь: входящий CAMEL
											15091	--Запрет по услуге Настроение
                                           )
                   AND sh.subs_subs_id = p_subs_id
                   AND SYSDATE - 1 / 24 / 12 > sh.start_date
                   AND SYSDATE - 1 / 24 / 12 <= sh.end_date
                   AND SYSDATE - 1 / 24 / 12 > ph.start_date
                   AND SYSDATE - 1 / 24 / 12 <= ph.end_date
                   AND sh.subs_subs_id = ph.subs_subs_id
                   AND ns.ncat_ncat_id = 1
                   AND ph.nset_nset_id = ns.nset_id
                   AND sh.srst_srst_id IN (2, 4)) LOOP
      EXECUTE IMMEDIATE 'insert into mk$req_for_subs (subs_subs_id,old_msisdn,srls_srls_id) values (:p1,:p2,:p3)'
        USING rec.subs_subs_id, rec.msisdn, rec.srls_srls_id;
    END LOOP;

    FOR rec IN (SELECT sh.subs_subs_id, ns.msisdn, sh.srls_srls_id
                  FROM serv_histories sh, phone_histories ph, number_sets ns
                 WHERE sh.srls_srls_id IN (1 -- Телефония всегда подключена
                                           )
                   AND sh.subs_subs_id = p_subs_id
                   AND SYSDATE - 1 / 24 / 12 > sh.start_date
                   AND SYSDATE - 1 / 24 / 12 <= sh.end_date
                   AND SYSDATE - 1 / 24 / 12 > ph.start_date
                   AND SYSDATE - 1 / 24 / 12 <= ph.end_date
                   AND sh.subs_subs_id = ph.subs_subs_id
                   AND ns.ncat_ncat_id = 1
                   AND ph.nset_nset_id = ns.nset_id
                   AND sh.srst_srst_id IN (2, 4, 6)) LOOP
      EXECUTE IMMEDIATE 'insert into mk$req_for_subs (subs_subs_id,old_msisdn,srls_srls_id) values (:p1,:p2,:p3)'
        USING rec.subs_subs_id, rec.msisdn, -1; -- фиктивный услуга для сторонних платформ(всегда отображается)
    END LOOP;

    FOR rec IN (SELECT sp.subs_subs_id, ns.msisdn, sp.pack_pack_id, sp.number_history
                  FROM subs_packs sp, phone_histories ph, number_sets ns
                 WHERE sp.subs_subs_id = p_subs_id
                   AND SYSDATE - 1 / 24 / 12 > sp.start_date
                   AND SYSDATE - 1 / 24 / 12 <= sp.end_date
                   AND SYSDATE - 1 / 24 / 12 > ph.start_date
                   AND SYSDATE - 1 / 24 / 12 <= ph.end_date
                   AND sp.subs_subs_id = ph.subs_subs_id
                   AND ns.ncat_ncat_id = 1
                   AND ph.nset_nset_id = ns.nset_id) LOOP
      EXECUTE IMMEDIATE 'insert into mk$req_for_subs (subs_subs_id,old_msisdn,pack_pack_id) values (:p1,:p2,:p3)'
        USING rec.subs_subs_id, rec.msisdn, rec.pack_pack_id;

      SELECT COUNT(*) INTO v_COUNT FROM bis.bis_qos_settings qs WHERE rec.pack_pack_id = qs.pack_pack_id;

      IF v_COUNT > 0 THEN
        BEGIN
          bis.bis_qos_pack.QOS_OFF(PSUBS_ID => rec.subs_subs_id);
        EXCEPTION
          WHEN OTHERS THEN
            v_log_id := mk$insert_log(p_mess => substr('EVENT_ON_AFTER_CLOSE_SUBS subs_id=' || p_subs_id || '. ' || chr(10) || chr(13) || dbms_utility.format_error_stack || dbms_utility.format_error_backtrace, 1, 2000),
						                          p_appl => 21,
                                      p_apmt => 1,
																			p_msg_id => NULL);
        END;
      END IF;

      EXECUTE IMMEDIATE 'update subs_packs sp set sp.end_date=:end_date, sp.add_comment=substr(sp.add_comment||chr(10)||chr(13)||''EVENT_ON_AFTER_CLOSE_SUBS'',1,255)
                            where sp.subs_subs_id = :subs_id and sp.pack_pack_id=:pack_id and sp.number_history=:num_hist'
        USING SYSDATE, rec.subs_subs_id, rec.pack_pack_id, rec.number_history;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      v_log_id := mk$insert_log(p_mess => substr('EVENT_ON_AFTER_CLOSE_SUBS subs_id=' || p_subs_id || '. ' || chr(10) || chr(13) || dbms_utility.format_error_stack || dbms_utility.format_error_backtrace, 1, 2000),
			                          p_appl => 21,
                                p_apmt => 1,
																p_msg_id => NULL);
  END;


 -------- для служебных номеров (ОАО Мегафон, Остелеком) аннулируем условный платеж-----------
 BEGIN
	select sh.rtpl_rtpl_id
    into v_rtpl_id
    from subs_histories sh
   where sh.subs_subs_id=P_SUBS_ID
     and sh.number_history = (select max(sh2.number_history)
                                from subs_histories sh2
                               where sh2.subs_subs_id=sh.subs_subs_id);
  if  v_rtpl_id=10274 then
     mk$annul_Virt_paym_emploee(p_subs_id => P_SUBS_ID, p_clnt_id => P_CLNT_ID);
  end if;

  if v_rtpl_id=10315 then
     mk$annul_emploee_ost(p_subs_id => P_SUBS_ID, p_clnt_id => P_CLNT_ID);
  end if;
 EXCEPTION
    WHEN OTHERS THEN
          v_log_id := mk$insert_log(p_mess => substr('EVENT_ON_AFTER_CLOSE_SUBS: annul_virt: subs_id=' || p_subs_id || '. ' || chr(10) || chr(13) || dbms_utility.format_error_stack || dbms_utility.format_error_backtrace, 1, 2000),
                                p_appl => 21,
                                p_apmt => 1,
                                p_msg_id => NULL);
 end;

  -- закрыть группы FAF этого владельца CLM#94190
  begin
    for rec in (
      select * from faf_groups
       where subs_subs_id=p_subs_id
         and end_date>sysdate and del_date is null
    ) loop
      bis_engine.delete_fafg_c(pfafg_id => rec.fafg_id,
                               pfafr_id => 0); -- Причина - ???
    end loop;
  exception when others then
    v_log_id := mk$insert_log(p_mess => substr('EVENT_ON_AFTER_CLOSE_SUBS: close faf_groups: subs_id=' || p_subs_id || '. ' || chr(10) || chr(13) || dbms_utility.format_error_stack || dbms_utility.format_error_backtrace, 1, 2000),
                          p_appl => 21,
                          p_apmt => 1,
                          p_msg_id => NULL);
  end;

  -- исключить этого абонента из FAF групп CLM#94190
  begin
    for rec in (
      select * from fafs
       where faf_subs_id=p_subs_id
         and end_date>sysdate and del_date is null
    ) loop
      bis_engine.delete_from_faf(pfafg_id => rec.fafg_fafg_id,
                                 pstart_date => sysdate,
                                 pphone => null,
                                 pfaf_subs_id => p_subs_id);
    end loop;
  exception when others then
    v_log_id := mk$insert_log(p_mess => substr('EVENT_ON_AFTER_CLOSE_SUBS: close fafs: subs_id=' || p_subs_id || '. ' || chr(10) || chr(13) || dbms_utility.format_error_stack || dbms_utility.format_error_backtrace, 1, 2000),
                              p_appl => 21,
                              p_apmt => 1,
                              p_msg_id => NULL);
  end;

EXCEPTION
  WHEN OTHERS THEN
      v_log_id := mk$insert_log(p_mess => substr('EVENT_ON_AFTER_CLOSE_SUBS subs_id=' || p_subs_id || '. ' || chr(10) || chr(13) || dbms_utility.format_error_stack || dbms_utility.format_error_backtrace, 1, 2000),
			                          p_appl => 21,
                                p_apmt => 1,
																p_msg_id => NULL);
END;
/
