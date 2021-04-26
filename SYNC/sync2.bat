for /f "usebackq tokens=* eol= delims=" %%i in (temp.txt) do (echo %%i)
