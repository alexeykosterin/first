CREATE OR REPLACE PACKAGE INSIS_SGI_DEV.PI_DATA_MANIPULATOR_PKG
IS
UDE EXCEPTION;
GCN_UDEN CONSTANT PLS_INTEGER := -20999;
PRAGMA EXCEPTION_INIT(UDE, -20999);

BIND_VAR_DOES_NOT_EXIST EXCEPTION;
PRAGMA EXCEPTION_INIT(BIND_VAR_DOES_NOT_EXIST, -01006);
TYPE ERV IS VARRAY(2) OF VARCHAR2(4000);
TYPE ERVT IS TABLE OF ERV;
TYPE TTVCIBVC IS TABLE OF VARCHAR2(4000) INDEX BY VARCHAR2(4000);
TYPE TTVC IS TABLE OF VARCHAR2(4000);
GC_OP_STATUS_ACTIVE      CONSTANT VARCHAR2(1) := 'A';
GC_OP_STATUS_PENDING     CONSTANT VARCHAR2(1) := 'P';
GC_OP_STATUS_FAILED      CONSTANT VARCHAR2(1) := 'F';
GC_OP_STATUS_COMPLETED   CONSTANT VARCHAR2(1) := 'C';
GC_OP_STATUS_CANCELLED   CONSTANT VARCHAR2(1) := 'X';

FUNCTION get_param_value_by_name(pi_param_name VARCHAR2)
RETURN VARCHAR2;

FUNCTION send_mail(po_err_msg			OUT VARCHAR2)
RETURN BOOLEAN;
	
END;
/

CREATE OR REPLACE PACKAGE BODY INSIS_SGI_DEV.PI_DATA_MANIPULATOR_PKG
IS
FUNCTION get_param_value_by_name(pi_param_name VARCHAR2)
   RETURN VARCHAR2
IS 
l_result VARCHAR2(4000);
BEGIN
    SELECT param_value INTO l_result
	FROM insis_sgi_dev.sgi_dict_parameters
	WHERE param_id = upper(pi_param_name); 
	RETURN l_result;
EXCEPTION 
	WHEN NO_DATA_FOUND 
	THEN
		RAISE_APPLICATION_ERROR(-20999, 'Get parameter value: row with id = "' || pi_param_name || '" not found in param table!');
	WHEN OTHERS
	THEN
		RAISE;
END get_param_value_by_name;

FUNCTION REPLACEPARAMS(PI_ERRMSG IN VARCHAR2
                      ,PI_TVC    IN TTVC) RETURN VARCHAR2 IS
    I        PLS_INTEGER;
    L_ERRMSG VARCHAR2(4000);
BEGIN
    L_ERRMSG := PI_ERRMSG;
    IF PI_TVC IS NOT NULL
    THEN
        FOR I IN PI_TVC.FIRST .. PI_TVC.LAST
        LOOP
            L_ERRMSG := REPLACE(L_ERRMSG, '#' || I || '#', PI_TVC(I));
        END LOOP;
    END IF;
    RETURN L_ERRMSG;
END REPLACEPARAMS;

FUNCTION REPLACEPARAMS(PI_ERRMSG IN VARCHAR2
                      ,PI_ERVT   IN ERVT) RETURN VARCHAR2 IS
    I        PLS_INTEGER;
    L_ERRMSG VARCHAR2(4000);
BEGIN
    L_ERRMSG := PI_ERRMSG;
    IF PI_ERVT IS NOT NULL
    THEN
        FOR I IN PI_ERVT.FIRST .. PI_ERVT.LAST
        LOOP
            L_ERRMSG := REPLACE(L_ERRMSG, '#' || PI_ERVT(I) (1) || '#', PI_ERVT(I) (2));
        END LOOP;
    END IF;
    RETURN L_ERRMSG;
END REPLACEPARAMS;

FUNCTION GETMESSAGEBYCODE(PI_MSG_CODE IN VARCHAR2) RETURN VARCHAR2 IS
    L_MESSAGE VARCHAR2(4000);
BEGIN
    $IF $$INSISVERSION < 10 $THEN
    RETURN 'No message for code: ' || PI_MSG_CODE;
    $ELSE
    L_MESSAGE := INSIS_SYS_V10.SRV_ERROR.GETSRVMESSAGE(PI_MSG_ID => PI_MSG_CODE);
    RETURN L_MESSAGE; 
    $END
END GETMESSAGEBYCODE;

FUNCTION GETMESSAGETEXT(PI_ERRMSG IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
    RETURN GETMESSAGEBYCODE(PI_ERRMSG);
END GETMESSAGETEXT;

FUNCTION GETMESSAGETEXT(PI_ERRMSG IN VARCHAR2
                       ,PI_TVC    IN TTVC) RETURN VARCHAR2 IS
BEGIN
    RETURN REPLACEPARAMS(GETMESSAGEBYCODE(PI_ERRMSG), PI_TVC);
END GETMESSAGETEXT;

FUNCTION GETMESSAGETEXT(PI_ERRMSG IN VARCHAR2
                       ,PI_ERVT   IN ERVT) RETURN VARCHAR2 IS
BEGIN
    RETURN REPLACEPARAMS(GETMESSAGEBYCODE(PI_ERRMSG), PI_ERVT);
END GETMESSAGETEXT;

PROCEDURE RAISE_UDE(PI_ERRMSG IN VARCHAR2) IS
BEGIN
    RAISE_APPLICATION_ERROR(GCN_UDEN, GETMESSAGEBYCODE(PI_ERRMSG));
END;

PROCEDURE RAISE_UDE(PI_ERRMSG IN VARCHAR2
                   ,PI_TVC    IN TTVC) IS
BEGIN
    RAISE_APPLICATION_ERROR(GCN_UDEN, GETMESSAGETEXT(PI_ERRMSG, PI_TVC));
END;

PROCEDURE RAISE_UDE(PI_ERRMSG IN VARCHAR2
                   ,PI_ERVT   IN ERVT) IS
BEGIN
    RAISE_APPLICATION_ERROR(GCN_UDEN, GETMESSAGETEXT(PI_ERRMSG, PI_ERVT));
END;

FUNCTION GETBATCHDRIVINGQUERY RETURN CLOB IS
    L_CLOB CLOB;
BEGIN
    SELECT P.LONG_TEXT INTO L_CLOB FROM INSIS_GDPR.CFG_PARAMETERS P WHERE P.ID = INSIS_GDPR.pi_data_manipulator.GC_BATCH_DRIVING_QUERY;
    RETURN L_CLOB;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE;
END;

PROCEDURE update_status 
(
	pi_status 		IN VARCHAR2
)
IS
PRAGMA AUTONOMOUS_TRANSACTION;
l_record_id		NUMBER;
BEGIN
    	UPDATE INSIS_SGI_DEV.DATA_MANIPULATOR sui
    	SET sui.status = pi_status
    	WHERE sui.status IN (GC_OP_STATUS_PENDING)
    	AND TRUNC(REGISTRATION_DATE) = TRUNC(CURRENT_DATE);
END update_status;

FUNCTION send_mail(po_err_msg	OUT VARCHAR2)
RETURN BOOLEAN
IS
l_report_path     	 	VARCHAR2(255) := '/sgi/printouts/data_manipulator_report.xdo';
l_message_text			VARCHAR2(4000);
l_recipient_address		VARCHAR2(255);
l_attachment			VARCHAR2(255);
l_printout_parameters	insis_sgi_dev.sgi_printout_parameter_table;
l_filename			 	VARCHAR2(200);
l_file_path				VARCHAR2(200);
l_file_path_send		VARCHAR2(200);
l_poller_file_name		VARCHAR2(200);
l_subject				VARCHAR2(200);

l_wait_timeout		  	NUMBER := 1800;
l_wait_interval		  	NUMBER := 100;	
BEGIN
	l_recipient_address := get_param_value_by_name('DATA_MAN_MAIL_LIST');
	l_message_text :=  get_param_value_by_name('DATA_MAN_TEXT');
	l_file_path := get_param_value_by_name('DATA_MAN_REP_PATH');
	l_file_path_send := get_param_value_by_name('DATA_MAN_URL_PATH');
	l_filename := 'data_manipulator_report' || '_' || to_char(CURRENT_TIMESTAMP,'ddMMyyyyHH24MISSFF3') || '.xls';
	l_attachment := l_file_path || l_filename;

	IF NOT insis_sgi_dev.sgi_printout_core.print_report
			(
				pi_job_name				=> 'NOTIF_UL_INCREAS_PREM',
				pi_report_path 			=> l_report_path,
				pi_report_format		=> insis_sgi_dev.sgi_printout_core.FORMAT_EXCEL,
				pi_absolute_filename	=> l_attachment,
				pi_printout_parameters	=> l_printout_parameters,
				pi_timeout				=> NULL,
				po_err_msg      		=> po_err_msg
			)                								
	THEN
		update_status(pi_status 		=> GC_OP_STATUS_FAILED);
	ELSE
		update_status(pi_status 		=> GC_OP_STATUS_COMPLETED);
	END IF;
	l_attachment := l_file_path_send || l_filename;
	WHILE NOT sgi_email_core.is_file_exists(l_filepath => l_attachment) AND l_wait_timeout > 0
	LOOP
		dbms_lock.sleep(l_wait_interval);
		l_wait_timeout := l_wait_timeout - l_wait_interval;
	END LOOP;

	IF NOT INSIS_SGI_DEV.sgi_email_core.send_mail(
                    pi_job_name			 	=> 'PROCESS_EXPIRED_PERS_DATA',
                    pi_email_event		 	=> 'SEND_MAIL_SGI',
                    pi_recipient_address 	=> l_recipient_address,
                    pi_subject			 	=> 'ИНСИС - маскирование данных',
                    pi_message_text		 	=> l_message_text,
                    pi_message_format 	 	=> 'HTML',
                    pi_attachment		 	=> l_attachment,
                    po_err_msg 			 	=> po_err_msg
                )
	THEN					
		update_status(pi_status 		=> GC_OP_STATUS_FAILED);
	ELSE
		update_status(pi_status 		=> GC_OP_STATUS_COMPLETED);
	END IF;
RETURN TRUE;
END send_mail;

PROCEDURE BATCHSUBMITREQUESTS(PI_AS_EXEC_DATE IN DATE DEFAULT NULL) IS

    L_BEHAVIOUR          VARCHAR2(1);
    L_CLOB_DRIVING_QUERY CLOB;

    CURSOR_ID  NUMBER;
    CUR_RESULT NUMBER;
    TYPE CURTYPE IS REF CURSOR;
    SRC_CUR CURTYPE;
    

    LT_MANIDS  SYS.DBMS_SQL.VARCHAR2_TABLE;
    LT_REASONS SYS.DBMS_SQL.VARCHAR2_TABLE;

    I INTEGER;
	GC_UPDATE CONSTANT VARCHAR2(1) := 'U';
	GC_DELETE CONSTANT VARCHAR2(1) := 'D';
	GC_INIT_TYPE_BATCH CONSTANT VARCHAR2(1) := 'B';
	GC_INIT_TYPE_MANUAL CONSTANT VARCHAR2(1) := 'M';
	GC_QUOT_STATUS_CANCELLED CONSTANT VARCHAR2(18) := 'CANCELLED';
	po_err_msg	VARCHAR2(2000);
	l_result	BOOLEAN;
BEGIN
    
    SELECT VALUE INTO L_BEHAVIOUR FROM INSIS_GDPR.CFG_PARAMETERS P WHERE P.ID = INSIS_GDPR.pi_data_manipulator.GC_BATCH_BEHAVIOUR;
    IF L_BEHAVIOUR NOT IN (GC_UPDATE, GC_DELETE)
    THEN
        RAISE_UDE('gdpr_wrong_batch_beh', TTVC(GC_UPDATE, GC_DELETE));
    END IF;

    IF PI_AS_EXEC_DATE IS NOT NULL AND PI_AS_EXEC_DATE > SYSDATE
    THEN
        RAISE_UDE('gdpr_future_date');
    END IF;
    
    L_CLOB_DRIVING_QUERY := GETBATCHDRIVINGQUERY;
    IF L_CLOB_DRIVING_QUERY IS NULL
    THEN
        RAISE_UDE('gdpr_no_batch_query');
    END IF;
    L_CLOB_DRIVING_QUERY := 'select * from (' || L_CLOB_DRIVING_QUERY ||
                            ') s where not exists (select 1 from INSIS_GDPR.pi_operations op where op.man_id = s.man_id and op.operation_type not in (''R'',''E''))';

    CURSOR_ID := SYS.DBMS_SQL.OPEN_CURSOR;

    DBMS_OUTPUT.PUT_LINE(L_CLOB_DRIVING_QUERY);
    DBMS_SQL.PARSE(CURSOR_ID, L_CLOB_DRIVING_QUERY, SYS.DBMS_SQL.NATIVE);
    BEGIN
        SYS.DBMS_SQL.BIND_VARIABLE(CURSOR_ID, 'AS_EXEC_DATE', NVL(PI_AS_EXEC_DATE, SYSDATE));
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -1006
            THEN
                
                NULL;
            ELSE
                RAISE;
            END IF;
    END;
    CUR_RESULT := SYS.DBMS_SQL.EXECUTE(CURSOR_ID);
    SRC_CUR    := DBMS_SQL.TO_REFCURSOR(CURSOR_ID);

    
    FETCH SRC_CUR BULK COLLECT
        INTO LT_MANIDS, LT_REASONS;
    CLOSE SRC_CUR;

    
    FORALL I IN 1 .. LT_MANIDS.COUNT
        INSERT INTO INSIS_SGI_DEV.DATA_MANIPULATOR
            (MAN_ID, REQUEST_REASON, OPERATION_TYPE, STATUS, REGISTRATION_DATE, INITIATOR_TYPE, REQUESTED_BY)
        VALUES
            (LT_MANIDS(I), LT_REASONS(I), L_BEHAVIOUR, GC_OP_STATUS_PENDING, TRUNC(CURRENT_DATE), GC_INIT_TYPE_BATCH, 'BATCH');
	l_result := send_mail(po_err_msg => po_err_msg);

END BATCHSUBMITREQUESTS;

END;
/