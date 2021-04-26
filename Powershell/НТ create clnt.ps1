$path = "C:\Users\$env:UserName\Desktop\CURL\bin"
cd $path
echo 'curl -d "@C:\Users\A.Kosterin\Desktop\CURL\bin\create_clnt.json" -v -X POST "http://10.143.117.228:47141/openapi/v2/orders" -H "Authorization: Bearer X" -H "Accept:application/json" -H "Content-Type:application/json" 1 > create_clnt.txt' > create_clnt.tmp
#Get-Content create_clnt2.bat | out-file -encoding ASCII create_clnt.bat
#del create_clnt2.bat
$curl = (Get-Content -Path  $path\create_clnt.tmp).foreach({$psitem})  | sort

$json = "create_clnt.json.tmp"
$json2 = "create_clnt.json"

$orderEntityIdold = "orderEntityId_"
$operationDateold = "operationDate_"
$accountNumberold = "accountNumber_"
$categoryId1old = "categoryId1_"
$departmentIdold = "departmentId_"
$name1old = "name1_"
$juralTypeIdold = "juralTypeId_"
$languageIdold = "languageId_"
$customerTypeIdold = "customerTypeId_"
$branchIdold = "branchId_"
$customerClassIdold = "customerClassId_"
$residentTypeIdold = "residentTypeId_"
$name2old = "name2_"
$phone1old = "phone1_"
$addressold = "address_"
$phone2old = "phone2_"
$emailold = "email_"
$accountold = "account_"
$bankFromDictionaryIdold = "bankFromDictionaryId_"
$contractNumberold = "contractNumber_"
$contractClassIdold = "contractClassId_"
$signingDateold = "signingDate_"
$categoryId2old = "categoryId2_"


$orderEntityId = 654000012718
$orderEntityIdmax = $orderEntityId + 1
$accountNumber = 654000012718
$accountNumbermax = $accountNumber + 1

$operationDate = "2018-01-01"
$categoryId1 = "1"
$departmentId = "16090"
$name1 = "AAK"
$juralTypeId = "2"
$languageId = "2"
$customerTypeId = "13"
$branchId = "1609"
$customerClassId = "3"
$residentTypeId = "1"
$name2 = "Лид Лид Лид"
$phone1 = "+79131112233"
$address = "spam@billing.ru"
$phone2 = "+79139503258"
$email = "spam@billing.ru"
$account = "40817810999999"
$bankFromDictionaryId = "1"
$contractNumber = "6000001"
$contractClassId = "112"
$signingDate = "2018-01-01T00:00:00"
$categoryId2 = "1"

Do {

$token = (Get-Content -Path  $path\token.txt).foreach({$psitem})  | sort
$curl = $curl.replace('Authorization: Bearer X', "Authorization: Bearer $token")
echo $curl > create_clnt.tmp
Get-Content create_clnt.tmp | out-file -encoding ASCII create_clnt.bat

$orderEntityId++
$accountNumber++

(get-content $json) -replace $orderEntityIdold, $orderEntityId | set-content $json2
(get-content $json2) -replace $operationDateold, $operationDate | set-content $json2
(get-content $json2) -replace $accountNumberold, $accountNumber | set-content $json2
(get-content $json2) -replace $categoryId1old, $categoryId1 | set-content $json2
(get-content $json2) -replace $departmentIdold, $departmentId | set-content $json2
(get-content $json2) -replace $name1old, ($name1+" "+$accountNumber) | set-content $json2
(get-content $json2) -replace $juralTypeIdold, $juralTypeId | set-content $json2
(get-content $json2) -replace $languageIdold, $languageId | set-content $json2
(get-content $json2) -replace $customerTypeIdold, $customerTypeId | set-content $json2
(get-content $json2) -replace $branchIdold, $branchId | set-content $json2
(get-content $json2) -replace $customerClassIdold, $customerClassId | set-content $json2
(get-content $json2) -replace $residentTypeIdold, $residentTypeId | set-content $json2
(get-content $json2) -replace $name2old, ($name2+" "+$accountNumber) | set-content $json2
(get-content $json2) -replace $phone1old, $phone1 | set-content $json2
(get-content $json2) -replace $addressold, $address | set-content $json2
(get-content $json2) -replace $phone2old, $phone2 | set-content $json2
(get-content $json2) -replace $emailold, $email | set-content $json2
(get-content $json2) -replace $accountold, $account | set-content $json2
(get-content $json2) -replace $bankFromDictionaryIdold, $bankFromDictionaryId | set-content $json2
(get-content $json2) -replace $contractNumberold, $contractNumber | set-content $json2
(get-content $json2) -replace $contractClassIdold, $contractClassId | set-content $json2
(get-content $json2) -replace $signingDateold, $signingDate | set-content $json2
(get-content $json2) -replace $categoryId2old, $categoryId2 | set-content $json2

start 'create_clnt.bat' -Wait
#del create_clnt.tmp

$curl = $curl.replace("Authorization: Bearer $token", "Authorization: Bearer X")
echo $curl > create_clnt.bat


    }
While ($orderEntityIdmax -gt $orderEntityId)


