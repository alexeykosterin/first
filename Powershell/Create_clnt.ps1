$path = "C:\Users\$env:UserName\Desktop\CURL\bin"
cd $path
echo 'curl -d "@C:\Users\A.Kosterin\Desktop\CURL\bin\JSON\create_clnt.json" -v -X POST "http://10.143.117.228:47141/openapi/v2/orders" -H "Authorization: Bearer X" -H "Accept:application/json" -H "Content-Type:application/json" 1 > create_clnt.txt' > create_clnt.tmp
#Get-Content create_clnt2.bat | out-file -encoding ASCII create_clnt.bat
#del create_clnt2.bat
$curl = (Get-Content -Path  $path\create_clnt.tmp).foreach({$psitem})  | sort


$token = (Get-Content -Path  $path\token.txt).foreach({$psitem})  | sort
$curl = $curl.replace('Authorization: Bearer X', "Authorization: Bearer $token")
echo $curl > create_clnt.tmp
Get-Content create_clnt.tmp | out-file -encoding ASCII create_clnt.bat



start 'create_clnt.bat' -Wait
del create_clnt.tmp

$curl = $curl.replace("Authorization: Bearer $token", "Authorization: Bearer X")
echo $curl > create_clnt.bat
