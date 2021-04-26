CREATE OR REPLACE PROCEDURE BIS.event_210286 (
P_SUBS_ID IN SUBSCRIBERS.SUBS_ID%TYPE,
P_OLD_CLNT_ID IN CLIENTS.CLNT_ID%TYPE,
P_NEW_CLNT_ID IN CLIENTS.CLNT_ID%TYPE,
P_NEW_RTPL_ID IN RATE_PLANS.RTPL_ID%TYPE,
P_OPERATION_DATE IN DATE DEFAULT SYSDATE)IS
/*
��� ���������������� ���������, ���������� ����� �������� �������� ������� �������.
�������� ������ ��� ������� ����� ���������������� ���������, ���������� ����� �������� �������� ������� �������. �������� ����������� ��������� ��������: ������������� ��������, �������������� ������� � ������ �������, ������������� ������ ��������� �����.
������������ ���� VALUE_STRING.
�������� �� ��������� � NULL.
������ ���������:
PROCEDURE TEST (
P_SUBS_ID IN SUBSCRIBERS.SUBS_ID%TYPE,
P_OLD_CLNT_ID IN CLIENTS.CLNT_ID%TYPE,
P_NEW_CLNT_ID IN CLIENTS.CLNT_ID%TYPE,
P_NEW_RTPL_ID IN RATE_PLANS.RTPL_ID%TYPE);


*/
v_NEW_CLCL_ID number;
v_OLD_CLCL_ID number;
v_NEW_CCAT_ID number;
v_OLD_CCAT_ID number;
v_atwr_id number;
v_atbr_id number;
v_tmp number;

begin
  
    v_tmp := 0;
    
    --��������� ������������ ������
    for rec in (select 1 from subs_packs where subs_subs_id = p_subs_id and end_date > sysdate and pack_pack_id in (select pack_id from packs 
      where ptyp_ptyp_id in (808,811,821,822,823,824,825,826,1103,1104,1105,1106,1107,1108))) loop
      
      v_tmp := 1;
      exit;
    end loop;
    
    if v_tmp = 1 then
      raise_application_error(-20000,
                              '������ ���������� �������� � ������������� ������� ������������');      
    end if;
    
  --��������� �.�. ��������� ������ "����������� ������ � PTT" ���� � ������ ������� ������ �����
  --���������� ����� ������� �������
    for rec in (select clcl_clcl_id, ccat_ccat_id from bis.client_histories where clnt_clnt_id = P_OLD_CLNT_ID and sysdate between start_date and end_date) loop
      v_OLD_CLCL_ID := rec.clcl_clcl_id;
      v_OLD_CCAT_ID := rec.ccat_ccat_id;
      exit;
    end loop;
  --���������� ����� ������ �������
    for rec in (select clcl_clcl_id, ccat_ccat_id from bis.client_histories  where clnt_clnt_id = P_NEW_CLNT_ID and sysdate between start_date and end_date) loop
      v_NEW_CLCL_ID := rec.clcl_clcl_id;
      v_NEW_CCAT_ID := rec.ccat_ccat_id;
      exit;
    end loop;

    --���������� �.�. 28.01.2008, ������� �� �������� �� ������� ����� � ������� 0(25, 50, 150, 300)�, 
    --����. ����. ��������� 15(25, 35, 100, 150, 300)� 
    If v_NEW_CLCL_ID <> v_OLD_CLCL_ID Then
      BIS.SIB_CHANG_CLNT_PACKS_REVOKE(P_NEW_CLNT_ID, v_NEW_CLCL_ID);  
    End If;
   
  --���������� �����������-���������� ����� ���� ����������
    IF v_NEW_CLCL_ID in (1,12,13) and v_OLD_CLCL_ID in (3,5,6,7) and bis.srls_present(p_subs_id => P_SUBS_ID,p_srls_id => 2071,p_call_date => sysdate) THEN        
      for rec1 in (select * from bis.serv_histories where sysdate between start_date and end_date and P_SUBS_ID = subs_subs_id and srls_srls_id = 2071) loop
        v_atwr_id := rec1.atwr_atwr_id;
        v_atbr_id := rec1.atbr_atbr_id;                              
      end loop;   
      bis.sib_new_srls_state(P_SUBS_ID,2071,6,3,3);
      bis.sib_new_srls_state(P_SUBS_ID,2069,4,v_atwr_id,v_atbr_id);
    elsif v_NEW_CLCL_ID in (3,5,6,7) and v_OLD_CLCL_ID in (1,12,13) and bis.srls_present(p_subs_id => P_SUBS_ID,p_srls_id => 2069,p_call_date => sysdate)  then
      for rec1 in (select * from bis.serv_histories where sysdate between start_date and end_date and P_SUBS_ID = subs_subs_id and srls_srls_id = 2069) loop
        v_atwr_id := rec1.atwr_atwr_id;
        v_atbr_id := rec1.atbr_atbr_id;                              
      end loop;   
      bis.sib_new_srls_state(P_SUBS_ID,2069,6,3,3);
      bis.sib_new_srls_state(P_SUBS_ID,2071,4,v_atwr_id,v_atbr_id);
    end if;    
    
      --��������� 02.11.2008 �������������� ������ �� �����
    /*2073  ������ �� �����
    2093	������ �� �����-0    */
    IF v_NEW_CLCL_ID in (1,12,13) and v_OLD_CLCL_ID in (3,5,6,7) and bis.srls_present(p_subs_id => P_SUBS_ID,p_srls_id => 2093,p_call_date => sysdate) THEN

       bis.bis_engine.CLOSE_SERVICE(P_SUBS_ID,2093,sysdate);
       bis.bis_engine.MAKE_SERVICE_ORDER(P_SUBS_ID,2073,sysdate+5/24/60,true);       
    
	--������ �.�.	05.07.2009 - ����������� ������
    --elsif v_NEW_CLCL_ID in (3,5,6,7) and v_OLD_CLCL_ID in (1,12,13) and bis.srls_present(p_subs_id => P_SUBS_ID,p_srls_id => 2069,p_call_date => sysdate)  then
    elsif v_NEW_CLCL_ID in (3,5,6,7) and v_OLD_CLCL_ID in (1,12,13) and bis.srls_present(p_subs_id => P_SUBS_ID,p_srls_id => 2073,p_call_date => sysdate)  then

       bis.bis_engine.CLOSE_SERVICE(P_SUBS_ID,2073,sysdate);
       bis.bis_engine.MAKE_SERVICE_ORDER(P_SUBS_ID,2093,sysdate+5/24/60,true);       

    end if;    
    
    --21.04.2009 ��������� �.�. ������ �� ����������� ��� ��������� ��������
    if v_NEW_CCAT_ID in (2) and v_OLD_CCAT_ID not in (2) then
      if bis.srls_present(p_subs_id,2064,sysdate) then
        bis.bis_engine.CLOSE_SERVICE(p_subs_id,2064);
      end if;
    end if;
    
    --��������� �.�. 01.04.2010 #1053939
    if v_NEW_CLCL_ID in (1) and v_OLD_CLCL_ID in (3,5,6) then
/*
2004	������ ����������� ��������
16	������������� ����������� �����
10014	�������� ����� �� �-mail
10010	�������� ����� - ��������
*/      
      if bis.srls_present(p_subs_id => p_subs_id,p_srls_id => 2004,p_call_date => sysdate)  then
        bis.bis_engine.close_service(psubs_id => p_subs_id,psrls_id => 2004);
      end if;
      if bis.srls_present(p_subs_id => p_subs_id,p_srls_id => 16,p_call_date => sysdate)  then
        bis.bis_engine.close_service(psubs_id => p_subs_id,psrls_id => 16);
      end if;
      if bis.srls_present(p_subs_id => p_subs_id,p_srls_id => 10014,p_call_date => sysdate)  then
        bis.bis_engine.close_service(psubs_id => p_subs_id,psrls_id => 10014);
      end if;
      if bis.srls_present(p_subs_id => p_subs_id,p_srls_id => 10010,p_call_date => sysdate)  then
        bis.bis_engine.close_service(psubs_id => p_subs_id,psrls_id => 10010);
      end if;
    end if;



    

end ;
/
