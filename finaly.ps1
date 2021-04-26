cd "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Notepad++"
.\notepad++.lnk

cd "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
.\"Google Chrome.lnk"

cd "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
.\"Outlook 2016.lnk"

cd "C:\Users\A.Kosterin\Desktop\Applications\KeePass-2.39.1"
.\KeePass.exe

cd "C:\Program Files (x86)\PLSQL Developer"
.\plsqldev.exe

cd "C:\Users\A.Kosterin\Desktop\Applications\MobaXterm_Portable_v10.6"
.\"MobaXterm_Personal_10.6.exe"


$path = "X:\Akosterin\Backup\txt"
$pathsql = "X:\Akosterin\Backup\SQL"
$pathwhat = "C:\Users\A.Kosterin\Desktop\*txt"
$pathwhatsql = "C:\Users\A.Kosterin\Desktop\SQL\*"
If(!(test-path $path))
{
New-Item -ItemType Directory -Force -Path $path
}

If(!(test-path $pathsql))
{
New-Item -ItemType Directory -Force -Path $pathsql
}

Copy-Item -Path "$pathwhat" -Destination "$path" -Recurse
Copy-Item -Path "$pathwhatsql" -Destination "$pathsql" -Recurse

