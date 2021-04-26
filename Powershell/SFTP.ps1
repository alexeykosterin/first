$HOST_IP=read-host "Введите IP/DNS сервера"
$LOGIN = read-host "Введите имя пользователя"
$Password = Read-Host 'Введите пароль от SFTP сервера' -AsSecureString | ConvertFrom-SecureString #| Out-File 'C:\Users\$env:UserName\Desktop\SFTP\password.txt' 
$localPath = "C:\Users\$env:UserName\Desktop\SFTP\oapi_raaac_backend.log"
$remotePath = "/home/brt/DISTRIB/AAK"
$result = "$Path\result.txt"

$Path = "C:\Users\$env:UserName\Desktop\SFTP"
If(!(test-path $Path))
{
New-Item -ItemType Directory -Force -Path $Path
}


Add-Type -Path "C:\Users\$env:UserName\AppData\Local\WinSCP\WinSCPnet.dll"

# Setup session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = $HOST_IP
    UserName = $LOGIN
    SecurePassword = ConvertTo-SecureString "$Password"
    SshHostKeyFingerprint = "ssh-ed25519 256 RijeO/MrHOaNAsHVac9AaLi8oJj6eOyeUQ7+B7ziGlw="
}

$session = New-Object WinSCP.Session

try
{
    # Connect
    $session.Open($sessionOptions)


    # Получить спиоск файлов в директории
    $directoryInfo = $session.ListDirectory($remotePath)
    # Получить последний созданный файл, который заканчивается на "log"
    $latest =
    $directoryInfo.Files |
    Where-Object { -Not $_.IsDirectory } | Where-Object {$_ -like "*2.log"} |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1
    # Any file at all?
    if ($latest -eq $Null)
    {
    Write-Host "No file found"
    exit 1
    }
     

    # Upload
    #$session.PutFiles("C:\Users\$env:UserName\Desktop\SFTP\oapi_raaac_backend.log", "/home/brt/DISTRIB/AAK/test.txt").Check()
    # Download
    #$session.GetFiles("$remotePath" , "$localPath").Check(); #все файлы
    $session.GetFiles([WinSCP.RemotePath]::EscapeFileMask($latest.FullName) , "$localPath").Check(); #последний файл
}
finally
{
    # Disconnect, clean up
    $session.Dispose()
}


(Select-String -Path "$localPath" -Pattern '(CamelHttpUri)|({"res":)').line > $Path\parse.txt


#удалить, если существует
Remove-Item $result -ErrorAction Ignore

$paths= @((gc $Path\parse.txt))

foreach ($path in $paths) {

if ($path -like "CamelHttpUri*")
{
$path -match 'NAI=(?<content>.*)'
$LOGIN_RAC = $matches['content']
echo $LOGIN_RAC >> C:\Users\$env:UserName\Desktop\SFTP\result.txt
}
else
{
[regex]$regex = '\\"spo=.*?\"'
$regex.Matches("$path") | foreach-object {$_.Value} >> C:\Users\$env:UserName\Desktop\SFTP\result.txt
[regex]$regex2 = '\\"X(.*?)\"'
$regex2.Matches("$path") | foreach-object {$_.Value} >> C:\Users\$env:UserName\Desktop\SFTP\result.txt
#вставить перенос строки в файл
[System.Environment]::NewLine >> C:\Users\$env:UserName\Desktop\SFTP\result.txt
}

}

(get-content C:\Users\$env:UserName\Desktop\SFTP\result.txt) -replace '(\\|\"|spo=)', "" | set-content C:\Users\$env:UserName\Desktop\SFTP\result.txt
