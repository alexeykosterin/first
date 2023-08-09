call "init_config.bat"

set logname=%date:~0,2%%date:~3,2%%date:~6,8%_%time:~0,2%%time:~3,2%%time:~6,2%
set logname=%logname: =%

:: type nul > C:\Users\%username%\Desktop\SPOOL\TMP\log.txt
for /f "delims=" %%i in ('dir C:\Users\%username%\Desktop\SPOOL\REP /b/a-d') do (
echo TABLE: %%i >> C:\Users\%username%\Desktop\SPOOL\LOG\add_tables_%logname%.txt
"%pg_sql_path%" -h %pg_host% -d %pg_db_name% -U %pg_user_name% -p %pg_port% -f "C:\Users\%username%\Desktop\SPOOL\REP\%%i" >> C:\Users\%username%\Desktop\SPOOL\LOG\add_tables_%logname%.txt 2>>&1
)

for /f "delims=" %%j in ('dir C:\Users\%username%\Desktop\SPOOL\STORED\%login_ora% /b/a-d') do (
echo STORED: %%j >> C:\Users\%username%\Desktop\SPOOL\LOG\add_tables_%logname%.txt
"%pg_sql_path%" -h %pg_host% -d %pg_db_name% -U %pg_user_name% -p %pg_port% -f "C:\Users\%username%\Desktop\SPOOL\STORED\%login_ora%\%%j" >> C:\Users\%username%\Desktop\SPOOL\LOG\add_tables_%logname%.txt 2>>&1
)