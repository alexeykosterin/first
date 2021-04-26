$path = "C:\Users\$env:UserName\Desktop\CURL\bin"
cd $path

$json = "create_clnt.json"


#$t = "30000", "56798", "12432"

#$t | ForEach-Object -Process {$_/1024}

$V = "orderEntityId_","accountNumber_"
$V2 = "SSSS"
$V3 = "LLLL"

$V | ForEach-Object -Process {(get-content $json) -replace $V2, $_ | set-content $json}
$V | ForEach-Object -Process {(get-content $json) -replace $V3, $_ | set-content $json}

#(get-content $json) -replace $V, $V2 | set-content $json
