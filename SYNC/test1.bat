set /P var_pas="add pass: "
set /P var_tns="add TNS name: "
If defined var_pas (echo:go) else (echo:var_pas is not defined & exit /b 1)
If defined var_tns (echo:go) else (echo:var_tns is not defined & exit /b 1)

echo %var_pas%&echo %var_tns%
