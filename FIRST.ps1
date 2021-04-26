cls
Get-ChildItem C:\Users\A.Kosterin\Desktop\ -Directory -exclude "Distrib","SQL","И" | Select-Object -Property name |  convertto-csv -NoTypeInformation  | Out-File C:\Users\A.Kosterin\Desktop\start_backup.txt
$paths= @((gc start_backup.txt) -replace '\"', "")
$date = Get-Date -Format dd_MM_yyyy
$ExcludeFileTypes=@('*.mp4*','*.exe','*.bat','*.ps', "*.js",'*.ps1')
$XD = @("Distrib", "SQL", "И", "Powershell", "eclipse", "Workspace")
foreach ($path in $paths) {
$path_count = Get-ChildItem -Path $path | Measure-Object  
    if ($path_count.Count -eq 0) 
       {write-host "нет элементов в папке"}
    else 
       {write-host "копирую файлы из $path"
        $path_copy = ("X:\Akosterin\Backup\Directory\"+$path)
          robocopy $path $path_copy /S /MAXAGE:50 /MT:5 /R:3 /Z /XD $XD /xf $ExcludeFileTypes $path_copy
       }
}

del C:\Users\A.Kosterin\Desktop\start_backup.txt