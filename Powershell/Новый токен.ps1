$ts = New-TimeSpan -Minutes 1
$then = (get-date) + $ts

$then = $then.ToString('HHmm')
$now = (Get-Date).ToString('HHmm')

$ts_to_token = New-TimeSpan -Minutes 1
$then_to_token = (get-date) + $ts_to_token
$then_to_token = $then_to_token.ToString('HHmm')


do {

$now = (Get-Date).ToString('HHmm')
#echo $then
#echo $now

if ( $then_to_token -gt $now )
{$isnull++}
else {

cd C:\Users\$env:UserName\Desktop\CURL\bin
#получить токен из файла txt
start 'token.bat' -Wait
$path_curl = "C:\Users\$env:UserName\Desktop\CURL\bin"
$paths = @((gc $path_curl\token.txt) -replace '\"', "")
$token = $paths.replace('{access_token: ', "")
$token.Split(",")[0] > token.txt
$ts_to_token = New-TimeSpan -Minutes 1
$then_to_token = (get-date) + $ts_to_token
$then_to_token = $then_to_token.ToString('HHmm')
Get-Date
echo "Новый токен получен"
}

} while ( $then -gt $now )