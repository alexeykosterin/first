for /F "tokens=1-2 delims=." %%i in (C:\Users\%username%\Desktop\SPOOL\procedures.txt) do (
importProcedure.bat %%i %%j)