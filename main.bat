call "init_config.bat"

for %%i in ("start.bat", "createSequence.bat", "prepareData.bat", "startAddTable.bat", "startImportToCsv.bat", "startLoadCsvInPg.bat") do call %%i|| exit /b 1


goto end
-----------
call "^start.bat"
call "createSequence.bat"
call "prepareData.bat"
call "startAddTable.bat"
call "startImportToCsv.bat"
call "startLoadCsvInPg.bat"
-----------

:end



