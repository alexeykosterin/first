$path = "C:\Users\$env:UserName\Desktop\CURL\bin\SPOOL"
cd $path

#$var = "Привет"
#gc test.txt | Foreach {"{0} : {1}" -f $_,$var} | out-file result.txt
#gc test.txt | Foreach {"{0}" -f $_}

#gc test.txt | Foreach {
#do {
#echo $_
#}
#while (1 -gt 2)
#} 


gc test.txt | Foreach {
do {
$COMOrderId = $_.Split(";")[0]
$CFSId = $_.Split(";")[1]
$clnt_clnt_id = $_.Split(";")[2]
$acccount = $_.Split(";")[3]

echo $COMOrderId
echo $CFSId
echo $clnt_clnt_id
echo $acccount

}
while (1 -gt 2)
} 

#100001830;990001354;66716;654000012624