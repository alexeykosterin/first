$path = "C:\Users\$env:UserName\Desktop\TEST"
$a=1


If(!(test-path $path))
{
New-Item -ItemType Directory -Force -Path $path
}

cd $path

echo "1" > $path\test.txt

#$number = `type C:\Users\$env:UserName\Desktop\TEST\test.txt`
#echo $number

#$values = Get-Content $path\test.txt
#$values.GetType()

$VAL = (Get-Content -Path  $path\test.txt).foreach({[int]$psitem})  | sort

#$VAL = $VAL+$a
#echo $VAL

do {
  $VAL
  $VAL--
#  echo asd$VAL

} while ( $VAL -gt 0 )


cd C:\Users\$env:UserName\Desktop\CURL\bin
#получить токен из файла txt
start 'token.bat' -Wait
$path_curl = "C:\Users\$env:UserName\Desktop\CURL\bin"
$paths = @((gc $path_curl\token.txt) -replace '\"', "")
$token = $paths.replace('{access_token: ', "")
$token.Split(",")[0] > token.txt


#---MATCH

#$paths= @((gc C:\Users\$env:UserName\Desktop\SFTP\parse.txt))
#$N=0
#foreach ($path in $paths) {
#$N = $N+1
##echo $N
##echo $path
#$path -match 'NAI=(?<content>.*)'
#$matches['content']
#}