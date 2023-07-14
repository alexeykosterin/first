@echo off
set logname=%date:~0,2%%date:~3,2%%date:~6,8%_%time:~0,2%%time:~3,2%%time:~6,2%
set logname=%logname: =%

call "init_config.bat"

if exist C:\Users\%username%\Desktop\SPOOL goto endif
:: for tmp csv
md C:\Users\%username%\Desktop\SPOOL\CSV
:: DDL Oracle to Postgres
md C:\Users\%username%\Desktop\SPOOL\REP
:: tmp catalog
md C:\Users\%username%\Desktop\SPOOL\TMP
md C:\Users\%username%\Desktop\SPOOL\LOG
md C:\Users\%username%\Desktop\SPOOL\APPEND
:endif

:: main catalog for export csv
if not exist C:\CSV md C:\CSV
if not exist C:\CSV\SPLIT_FILE md C:\CSV\SPLIT_FILE
if not exist C:\Users\%username%\Desktop\SPOOL\tables.txt (type nul > C:\Users\%username%\Desktop\SPOOL\tables.txt)



rem "%pg_sql_path%" -h %pg_host% -d %pg_db_name% -U %pg_user_name% -p %pg_port% -f "C:\Users\%username%\Desktop\SPOOL\prepareData.sql" > C:\Users\%username%\Desktop\SPOOL\LOG\prepareData_%logname%.txt 2>>&1
"%pg_sql_path%" -h %pg_host% -d %pg_db_name% -U %pg_user_name% -p %pg_port% -f "C:\Users\%username%\Desktop\SPOOL\TMP\createSequence.txt" >> C:\Users\%username%\Desktop\SPOOL\LOG\prepareData_%logname%.txt 2>>&1