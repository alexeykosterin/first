$Path = "C:\Users\$env:UserName\Desktop\SFTP"
$file = "C:\Users\$env:UserName\Desktop\SFTP\AAA.txt"
$result = "$Path\result.txt"

cd $Path

get-content "$path\AAA.txt" | Out-File $Path\new_file.txt -NoNewline -Enc default


$text = [string]::Join("`n", (Get-Content $Path\new_file.txt))
[regex]::Replace($text, "Cisco", "Cisco`n ", "Singleline") > 1.txt


#удалить, если существует
Remove-Item $result -ErrorAction Ignore


#$paths= @((gc $Path\1.txt))
$paths= @((Get-Content $Path\1.txt | Select-Object -Skip 1))

foreach ($al in $paths) {

if ($al -like "aaaQoS*")
{
$al -match ',nai=(?<content>.*),'
$LOGIN_RAC = $matches['content']
echo $LOGIN_RAC >> C:\Users\$env:UserName\Desktop\SFTP\result.txt
}
else
{
[regex]$regex = ',spo=.*?,'
$regex.Matches("$al") | foreach-object {$_.Value} >> C:\Users\$env:UserName\Desktop\SFTP\result.txt
[regex]$regex3 = '"so=limit,'
$regex3.Matches("$al") | foreach-object {$_.Value} >> C:\Users\$env:UserName\Desktop\SFTP\result.txt
[regex]$regex2 = ',"X(.*?)",'
$regex2.Matches("$al") | foreach-object {$_.Value} >> C:\Users\$env:UserName\Desktop\SFTP\result.txt
[regex]$regex4 = ',nai=.*?,'
$regex4.Matches("$al") | foreach-object {$_.Value} >> C:\Users\$env:UserName\Desktop\SFTP\result.txt
[regex]$regex6 = ',"{0,3}[0-9].{0,3}[0-9].{0,3}[0-9].{0,3}[0-9]"'
$regex6.Matches("$al") | foreach-object {$_.Value} >> C:\Users\$env:UserName\Desktop\SFTP\result.txt


[regex]$regex5 = ',vo=Cisco'
$regex5.Matches("$al") | foreach-object {$_.Value} >> C:\Users\$env:UserName\Desktop\SFTP\result.txt
#вставить перенос строки в файл
[System.Environment]::NewLine >> C:\Users\$env:UserName\Desktop\SFTP\result.txt
}

}

(Get-Content C:\Users\$env:UserName\Desktop\SFTP\result.txt) | Get-Unique > C:\Users\$env:UserName\Desktop\SFTP\result2.txt

#"so=limit

(get-content C:\Users\$env:UserName\Desktop\SFTP\result2.txt) -replace '(,spo=)', "" -replace '(,nai=)', "" -replace '("so=)', "" -replace '(,")', "" | set-content C:\Users\$env:UserName\Desktop\SFTP\result2.txt

get-content "C:\Users\$env:UserName\Desktop\SFTP\result2.txt" | Out-File $Path\new_file.txt -NoNewline -Enc default

$text = [string]::Join("`n", (Get-Content $Path\new_file.txt))
[regex]::Replace($text, ",vo=Cisco", "`n", "Singleline") > C:\Users\$env:UserName\Desktop\SFTP\result2.txt


(get-content C:\Users\$env:UserName\Desktop\SFTP\result2.txt) -replace ',', ";" -replace '\)"', ")" -replace '"', ";" | set-content C:\Users\$env:UserName\Desktop\SFTP\result.csv

#удалить, если существует
Remove-Item C:\Users\$env:UserName\Desktop\SFTP\result.txt -ErrorAction Ignore
Remove-Item C:\Users\$env:UserName\Desktop\SFTP\result2.txt -ErrorAction Ignore
Remove-Item C:\Users\$env:UserName\Desktop\SFTP\1.txt -ErrorAction Ignore
Remove-Item C:\Users\$env:UserName\Desktop\SFTP\parse.txt -ErrorAction Ignore
Remove-Item C:\Users\$env:UserName\Desktop\SFTP\new_file.txt -ErrorAction Ignore
