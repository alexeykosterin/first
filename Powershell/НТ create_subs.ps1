$path = "C:\Users\$env:UserName\Desktop\CURL\bin\SPOOL"
$path_to_token = "C:\Users\$env:UserName\Desktop\CURL\bin"
$path_to_json = "$path\LIST"
cd $path

start 'spool_info.bat' -Wait
$spool_info_tmp = "spool_info.tmp"
$spool_info = "spool_info.txt"
#del $spool_info_tmp

(get-content $spool_info_tmp) -replace " ", "" | set-content $spool_info

echo 'C:\Users\A.Kosterin\Desktop\CURL\bin\curl -d "@C:\Users\A.Kosterin\Desktop\CURL\bin\SPOOL\LIST\create_subs_OTA.json" -v -X POST "http://10.143.117.228:47141/openapi/v2/orders" -H "Authorization: Bearer X" -H "Accept:application/json" -H "Content-Type:application/json" 1 > create_subs.txt' > create_subs.curl.tmp
$curl = (Get-Content -Path  $path\create_subs.curl.tmp).foreach({$psitem})  | sort
$json = "$path_to_json\create_subs_OTA.json.tmp"
$json2 = "$path_to_json\create_subs_OTA.json"

$orderRecipientId = "orderRecipientId_"
$orderEntityId = "orderEntityId_"
$customerId = "customerId_"
$COMOrderId = "COMOrderId_"
$productOfferingId = "productOfferingId_"
$productOfferingInstanceId = "productOfferingInstanceId_"
$productOfferingName = "productOfferingName_"
$CFSId = "CFSId_"
$parentCFSId = "parent_"
$calcDependOnCFSId = "calcDependOn_"
$CFSSId = "CFSSId_"
$CFSSCode = "CFSSCode_"
$clusterId = "clusterId_"
$zoneId = "zoneId_"
$addressId = "addressId_"
$value = "value_"
$startPeriod = "startPeriod_"
$rtplId = "rtplId_"
$packId = "packId_"
$priceId = "priceId_"
$personalPrice = "personalPrice_"

$productOfferingId2 = "2000"
$productOfferingInstanceId2 = "930"
$parentCFSId2 = "NULL"
$calcDependOnCFSId2 = "NULL" 
$CFSSId2 = "1"
$clusterId2 = "И-Нск-1"
$zoneId2 = "356"
$addressId2 = "1379880"
$startPeriod2 = "2018-12-01T10:00:00+03:00"
$rtplId2 = "52"
$packId2 = "965"
$priceId2 = "12401"
$personalPrice2 = "NULL"

gc $spool_info | Foreach {
do {

$token = (Get-Content -Path  $path_to_token\token.txt).foreach({$psitem})  | sort
$curl = $curl.replace('Authorization: Bearer X', "Authorization: Bearer $token")
echo $curl > create_subs.curl.tmp
Get-Content create_subs.curl.tmp | out-file -encoding ASCII create_subs.bat

$COMOrderId2 = $_.Split(";")[0]
$CFSId2 = $_.Split(";")[1]
$clnt_clnt_id = $_.Split(";")[2]
$acccount = $_.Split(";")[3]

$orderRecipientId2 = $clnt_clnt_id
$orderEntityId2 = $clnt_clnt_id
$customerId2 = $clnt_clnt_id
$productOfferingName2 = "AAK"+" "+$acccount
$CFSSCode2 = "AAK"+" "+$acccount
$value2 = $CFSId2

(get-content $json) -replace $orderRecipientId, $orderRecipientId2 | set-content $json2
(get-content $json2) -replace $orderEntityId, $orderEntityId2 | set-content $json2
(get-content $json2) -replace $customerId, $customerId2 | set-content $json2
(get-content $json2) -replace $COMOrderId, $COMOrderId2 | set-content $json2
(get-content $json2) -replace $productOfferingId, $productOfferingId2 | set-content $json2
(get-content $json2) -replace $productOfferingInstanceId, $productOfferingInstanceId2 | set-content $json2
(get-content $json2) -replace $productOfferingName, $productOfferingName2 | set-content $json2
(get-content $json2) -replace $CFSId, $CFSId2 | set-content $json2
(get-content $json2) -replace $parentCFSId, $parentCFSId2 | set-content $json2
(get-content $json2) -replace $calcDependOnCFSId, $calcDependOnCFSId2 | set-content $json2
(get-content $json2) -replace $CFSSId, $CFSSId2 | set-content $json2
(get-content $json2) -replace $CFSSCode, $CFSSCode2 | set-content $json2
(get-content $json2) -replace $clusterId, $clusterId2 | set-content $json2
(get-content $json2) -replace $zoneId, $zoneId2 | set-content $json2
(get-content $json2) -replace $addressId, $addressId2 | set-content $json2
(get-content $json2) -replace $value, $value2 | set-content $json2
(get-content $json2) -replace $startPeriod, $startPeriod2 | set-content $json2
(get-content $json2) -replace $rtplId, $rtplId2 | set-content $json2
(get-content $json2) -replace $packId, $packId2 | set-content $json2
(get-content $json2) -replace $priceId, $priceId2 | set-content $json2
(get-content $json2) -replace $personalPrice, $personalPrice2 | set-content $json2

start 'create_subs.bat' -Wait

$curl = $curl.replace("Authorization: Bearer $token", "Authorization: Bearer X")
echo $curl > create_subs.bat

}
while (1 -gt 2)
} 



