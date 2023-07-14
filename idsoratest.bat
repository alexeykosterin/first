call "init_config.bat"

cd C:\Users\%username%\Desktop\SPOOL
echo prompt Start the unloading process... > TMP\idsoratest.sql
echo set colsep ';' >> TMP\idsoratest.sql
echo set echo off >> TMP\idsoratest.sql
echo set feedback off >> TMP\idsoratest.sql
echo set linesize 1000 >> TMP\idsoratest.sql
echo set pagesize 0 >> TMP\idsoratest.sql
echo set sqlprompt '' >> TMP\idsoratest.sql
echo set trimspool on >> TMP\idsoratest.sql
echo set headsep off >> TMP\idsoratest.sql
echo set serveroutput on >> TMP\idsoratest.sql

echo SPOOL C:\Users\%username%\Desktop\SPOOL\REP\%2.txt; >> TMP\idsoratest.sql

echo DECLARE  >> TMP\idsoratest.sql 
echo lv_table_name varchar2(150) := '%2'; >> TMP\idsoratest.sql 
echo lv_schema_name varchar2(150) := '%1'; >> TMP\idsoratest.sql 
echo lv_data_type varchar2(150); >> TMP\idsoratest.sql 
echo lv_comma varchar2(100) := ','; >> TMP\idsoratest.sql 
echo lv_UNIQUENESS varchar2(20) := ''; >> TMP\idsoratest.sql 
echo lv_data_length varchar2(20); >> TMP\idsoratest.sql
echo lv_DATA_DEFAULT varchar2(100); >> TMP\idsoratest.sql
echo BEGIN  >> TMP\idsoratest.sql 
echo dbms_output.put_line('CREATE TABLE IF NOT EXISTS '^|^|lv_schema_name^|^|'.'^|^|lv_table_name^|^|' ('); >> TMP\idsoratest.sql 
echo FOR rec IN (SELECT COLUMN_NAME,DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE, DATA_DEFAULT, COLUMN_ID, max(COLUMN_ID) OVER (PARTITION BY table_name, OWNER) AS max_column_id >> TMP\idsoratest.sql 
echo FROM DBA_TAB_COLUMNS WHERE table_name = lv_table_name AND OWNER = lv_schema_name ORDER BY column_id) >> TMP\idsoratest.sql 
echo LOOP  >> TMP\idsoratest.sql 
echo IF rec.DATA_TYPE = 'VARCHAR2' THEN lv_data_type := 'VARCHAR'; >> TMP\idsoratest.sql 
echo ELSIF rec.DATA_TYPE = 'NVARCHAR2' THEN lv_data_type := 'VARCHAR'; >> TMP\idsoratest.sql
echo ELSIF rec.data_type = 'NUMBER' THEN lv_data_type := 'NUMERIC'; >> TMP\idsoratest.sql 
echo ELSIF rec.data_type = 'CLOB' THEN lv_data_type := 'TEXT'; >> TMP\idsoratest.sql 
echo ELSIF rec.data_type = 'BLOB' THEN lv_data_type := 'BYTEA'; >> TMP\idsoratest.sql 
echo ELSIF rec.data_type LIKE 'TIMESTAMP%%' THEN lv_data_type := 'TIMESTAMP'; >> TMP\idsoratest.sql 
echo ELSE lv_data_type := rec.data_type; >> TMP\idsoratest.sql 
echo END IF; >> TMP\idsoratest.sql 
echo IF rec.data_type = 'DATE' THEN lv_data_length := ''; lv_data_type := 'TIMESTAMP'; >> TMP\idsoratest.sql 
echo ELSIF rec.data_type = 'CLOB' THEN lv_data_length := '';  >> TMP\idsoratest.sql 
echo ELSIF rec.data_type = 'BLOB' THEN lv_data_length := '';  >> TMP\idsoratest.sql 
echo ELSE lv_data_length := ' ('^|^|rec.data_length^|^|')'; >> TMP\idsoratest.sql 
echo END IF; >> TMP\idsoratest.sql 
echo IF rec.DATA_PRECISION IS NOT NULL THEN  >> TMP\idsoratest.sql 
echo lv_data_length := ' ('^|^|rec.DATA_PRECISION^|^|','^|^|rec.DATA_SCALE^|^|')'; >> TMP\idsoratest.sql 
echo END IF; >> TMP\idsoratest.sql 
echo SELECT CASE WHEN rec.DATA_DEFAULT like '%%trunc(sysdate)%%' THEN 'current_date' >> TMP\idsoratest.sql
echo WHEN rec.DATA_DEFAULT = 'sysdate' THEN 'current_timestamp(0)' ELSE rec.DATA_DEFAULT END INTO lv_DATA_DEFAULT FROM dual; >> TMP\idsoratest.sql
echo IF lv_DATA_DEFAULT IS NOT NULL THEN  >> TMP\idsoratest.sql
echo lv_comma := ' DEFAULT '^|^|lv_DATA_DEFAULT^|^|','; >> TMP\idsoratest.sql
echo ELSE lv_comma := ','; >> TMP\idsoratest.sql
echo END IF; >> TMP\idsoratest.sql
echo IF rec.max_column_id = rec.column_id AND lv_DATA_DEFAULT IS NULL THEN  >> TMP\idsoratest.sql
echo lv_comma := NULL; >> TMP\idsoratest.sql
echo ELSIF rec.max_column_id = rec.column_id AND lv_DATA_DEFAULT IS NOT NULL THEN >> TMP\idsoratest.sql
echo lv_comma := ' DEFAULT '^|^|lv_DATA_DEFAULT; >> TMP\idsoratest.sql
echo END IF; >> TMP\idsoratest.sql
echo dbms_output.put_line(rec.COLUMN_NAME^|^|' '^|^|lv_data_type^|^|lv_data_length^|^|lv_comma); >> TMP\idsoratest.sql 
echo END LOOP; >> TMP\idsoratest.sql 
echo dbms_output.put_line(') tablespace SOGECAP; alter table '^|^|lv_schema_name^|^|'.'^|^|lv_table_name^|^|' owner to %1;'); >> TMP\idsoratest.sql 
echo FOR rec IN (SELECT CONSTRAINT_TYPE, CONSTRAINT_NAME, SEARCH_CONDITION FROM DBA_CONSTRAINTS WHERE owner = lv_schema_name AND table_name = lv_table_name) LOOP  >> TMP\idsoratest.sql 
echo IF rec.CONSTRAINT_TYPE = 'C' AND rec.SEARCH_CONDITION LIKE '%%IS%%' THEN  >> TMP\idsoratest.sql 
echo dbms_output.put_line('alter table '^|^|lv_schema_name^|^|'.'^|^|lv_table_name^|^|' alter column '^|^| >> TMP\idsoratest.sql 
echo regexp_substr(rec.SEARCH_CONDITION, '[^^^"]+', 1, 1, 'i')^|^|' set '^|^| >> TMP\idsoratest.sql 
echo regexp_substr(rec.SEARCH_CONDITION, '(.*?)(IS ^|$)+', 1, 2, 'i')^|^|';' >> TMP\idsoratest.sql 
echo ); >> TMP\idsoratest.sql 
echo ELSIF rec.CONSTRAINT_TYPE = 'C' AND rec.SEARCH_CONDITION NOT LIKE '%%IS%%NULL%%' THEN  >> TMP\idsoratest.sql 
echo dbms_output.put_line('alter table '^|^|lv_schema_name^|^|'.'^|^|lv_table_name^|^|' alter column '^|^| >> TMP\idsoratest.sql 
echo regexp_substr(rec.SEARCH_CONDITION, '[^^^"]+', 1, 1, 'i')^|^|' set '^|^| >> TMP\idsoratest.sql 
echo regexp_substr(rec.SEARCH_CONDITION, '[^^^"]+', 1, 2, 'i')^|^|';' >> TMP\idsoratest.sql 
echo ); >> TMP\idsoratest.sql 
echo ELSIF rec.CONSTRAINT_TYPE = 'P' THEN >> TMP\idsoratest.sql 
echo FOR rec2 IN (SELECT OWNER, INDEX_NAME, GENERATED, SECONDARY, FUNCIDX_STATUS, DROPPED, INDEX_TYPE, UNIQUENESS, TABLESPACE_NAME, >> TMP\idsoratest.sql 
echo (SELECT LISTAGG(column_name,', ') WITHIN GROUP (ORDER BY COLUMN_POSITION) AS column_name FROM dba_ind_columns uic WHERE index_name = di.index_name and INDEX_OWNER = lv_schema_name) AS column_name  >> TMP\idsoratest.sql 
echo FROM DBA_INDEXES di WHERE table_name = lv_table_name AND di.owner = lv_schema_name AND rec.CONSTRAINT_NAME = di.index_name) LOOP  >> TMP\idsoratest.sql 
echo IF rec2.DROPPED = 'NO' THEN  >> TMP\idsoratest.sql 
echo if rec2.INDEX_NAME = lv_table_name then rec2.INDEX_NAME := rec2.INDEX_NAME^|^|'_C'; end if; >> TMP\idsoratest.sql 
echo dbms_output.put_line('alter table '^|^|lv_schema_name^|^|'.'^|^|lv_table_name^|^|' add constraint '^|^|rec2.INDEX_NAME^|^|' primary key ('^|^|rec2.column_name^|^|');'); >> TMP\idsoratest.sql 
echo END IF; >> TMP\idsoratest.sql 
echo END LOOP; >> TMP\idsoratest.sql 
echo END IF; >> TMP\idsoratest.sql 
echo END LOOP; >> TMP\idsoratest.sql 
:: echo FOR rec IN (SELECT OWNER, NAME, TYPE, REFERENCED_OWNER, REFERENCED_NAME FROM DBA_DEPENDENCIES WHERE name = lv_table_name) LOOP  >> TMP\idsoratest.sql 
:: echo IF rec.TYPE = 'SYNONYM' THEN  >> TMP\idsoratest.sql 
:: echo dbms_output.put_line('SET SEARCH_PATH TO '^|^|rec.owner^|^|','^|^|rec.REFERENCED_OWNER^|^|';'); >> TMP\idsoratest.sql 
:: echo END IF; >> TMP\idsoratest.sql 
:: echo END LOOP; >> TMP\idsoratest.sql 
echo FOR rec IN (SELECT di.INDEX_NAME, di.UNIQUENESS, di.TABLESPACE_NAME, LISTAGG(dic.COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY di.INDEX_NAME) AS COLUMN_NAME FROM DBA_INDEXES di, DBA_IND_COLUMNS dic >> TMP\idsoratest.sql 
echo WHERE di.INDEX_NAME = dic.index_name AND di.table_name = lv_table_name >> TMP\idsoratest.sql 
echo AND status = 'VALID' AND owner = lv_schema_name AND INDEX_OWNER = lv_schema_name AND table_type = 'TABLE' GROUP BY di.INDEX_NAME, di.UNIQUENESS, di.TABLESPACE_NAME) LOOP  >> TMP\idsoratest.sql 
echo IF rec.uniqueness = 'UNIQUE' THEN  >> TMP\idsoratest.sql 
echo lv_UNIQUENESS := rec.uniqueness; >> TMP\idsoratest.sql 
echo ELSE >> TMP\idsoratest.sql 
echo lv_UNIQUENESS := ''; >> TMP\idsoratest.sql 
echo END IF; >> TMP\idsoratest.sql 
echo if rec.INDEX_NAME = lv_table_name then rec.INDEX_NAME := rec.INDEX_NAME^|^|'_C'; end if;>> TMP\idsoratest.sql
echo dbms_output.put_line('CREATE '^|^|lv_UNIQUENESS^|^|' INDEX IF NOT EXISTS '^|^|rec.INDEX_NAME^|^|' on '^|^|lv_schema_name^|^|'.'^|^|lv_table_name^|^|' ('^|^|rec.column_name^|^|')'^|^|' TABLESPACE '^|^| >> TMP\idsoratest.sql 
echo rec.tablespace_name^|^|';'); >> TMP\idsoratest.sql 
echo dbms_output.put_line('alter index '^|^|lv_schema_name^|^|'.'^|^|rec.index_name^|^|' owner to '^|^|lv_schema_name^|^|';'); >> TMP\idsoratest.sql 
echo END LOOP; >> TMP\idsoratest.sql 

echo FOR rec IN (SELECT BASE_OBJECT_TYPE, TRIGGER_BODY, TRIGGER_NAME, TRIGGER_TYPE, TRIGGERING_EVENT, TABLE_OWNER, TABLE_NAME  >> TMP\idsoratest.sql
echo FROM dba_triggers >> TMP\idsoratest.sql
echo WHERE STATUS = 'ENABLED' AND TABLE_NAME = lv_table_name AND TABLE_OWNER = lv_schema_name) LOOP  >> TMP\idsoratest.sql



echo dbms_output.put_line('create or replace function '^|^|lv_schema_name^|^|'.'^|^|rec.trigger_name^|^|'_'^|^|lv_table_name^|^|'()'); >> TMP\idsoratest.sql
echo dbms_output.put_line('RETURNS trigger AS');  >> TMP\idsoratest.sql
echo dbms_output.put_line('^$^$');  >> TMP\idsoratest.sql
echo dbms_output.put_line(regexp_replace(regexp_replace(regexp_replace(rec.TRIGGER_BODY, 'from dual', '', 1, 0, 'i'), ':', '', 1, 0, 'i'), 'end;', 'RETURN NEW; END;', 1, 0, 'i'));  >> TMP\idsoratest.sql

echo dbms_output.put_line('^$^$');  >> TMP\idsoratest.sql
echo dbms_output.put_line('LANGUAGE ^'^'plpgsql^'^';'); >> TMP\idsoratest.sql

echo dbms_output.put_line('DROP TRIGGER IF EXISTS '^|^|rec.trigger_name^|^|' ON '^|^|rec.TABLE_OWNER^|^|'.'^|^|lv_table_name^|^|';'); >> TMP\idsoratest.sql

echo dbms_output.put_line('CREATE TRIGGER '^|^|rec.trigger_name^|^|' '^|^|regexp_substr(rec.TRIGGER_TYPE, '[^^ ]+', 1, 1, 'i')^|^|' '^|^|rec.TRIGGERING_EVENT^|^|' ON '^|^|rec.TABLE_OWNER^|^|'.'^|^|lv_table_name^|^|' FOR '^|^|regexp_substr(rec.TRIGGER_TYPE, ' (.*)$', 1, 1, 'i')^|^|' ');  >> TMP\idsoratest.sql
echo dbms_output.put_line('execute procedure '^|^|lv_schema_name^|^|'.'^|^|rec.trigger_name^|^|'_'^|^|lv_table_name^|^|'(); END;'); >> TMP\idsoratest.sql


echo END LOOP; >> TMP\idsoratest.sql
echo END; >> TMP\idsoratest.sql 
echo / >> TMP\idsoratest.sql
echo spool off; >> TMP\idsoratest.sql
echo prompt Done >> TMP\idsoratest.sql
echo exit; >> TMP\idsoratest.sql


SQLPLUS "%login_ora%/%pass_ora%@%tns_connect_to_ora%" @TMP\idsoratest.sql