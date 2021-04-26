$path = "C:\Users\$env:UserName\Desktop\SPOOL\BD"


#cd "C:\Users\A.Kosterin\Desktop\SPOOL"
#start 'IMPORT.bat' -Wait
#start 'IMPORT.ALPHA.bat' -Wait

cd $path

(get-content $path\ALPHA\aak_alpha.txt) -replace "\|\|\';\'\|\|", ';' | set-content $path\ALPHA\temp.txt
(get-content $path\BIS_TEST_EACP\aak_alpha.txt) -replace "\|\|\';\'\|\|", ';' | set-content $path\BIS_TEST_EACP\temp.txt


#param( $symbols = ';' )

$symbols = ';' 
$DATA = Get-Content $path\ALPHA\temp.txt

[int]$count = [Regex]::Matches( $DATA, "[$symbols]" ).Count
#Write-Host "В $DATA  содержится $count таких ( $symbols ) символов"
#сумма +/1
#$count/1 + 1/1
$max = $count

$a = 1


$DATA2 = Get-Content $path\BIS_TEST_EACP\temp.txt

[int]$count2 = [Regex]::Matches( $DATA2, "[$symbols]" ).Count
#Write-Host "В $DATA2  содержится $count2 таких ( $symbols ) символов"
#$count2/1 + 1/1

#если файл есть, то удалить
$tmp = "$path\temp*.txt"
If((test-path $tmp))
{
del temp*.txt
del settings.txt
}


#NEW
gc $path\ALPHA\temp.txt | Foreach {
do {
$NAME = $_.Split(";")[$count]
$NAME = $NAME.Replace(" ","")
echo $NAME"="$count >> settings.txt
echo $NAME >> temp1.txt
$count = $count - $a
}
while (-1 -lt $count)
} 

#OLD
gc $path\BIS_TEST_EACP\temp.txt | Foreach {
do {
$NAME2 = $_.Split(";")[$count2]
$NAME2 = $NAME2.Replace(" ","")
#Write-Host $NAME2
$count2 = $count2 - $a
echo $NAME2 >> temp2.txt
}
while (-1 -lt $count2)
}

echo "load data characterset AL32UTF8" > loader.ctl
echo "infile      'C:\Users\A.Kosterin\Desktop\SPOOL\aak_alpha.BIS_TEST_EACP.csv'" >> loader.ctl
echo "badfile     'C:\Users\A.Kosterin\Desktop\SPOOL\BD\ALPHA\aak_alpha.BIS_TEST_EACP.csv.bad'"  >> loader.ctl
echo "discardfile 'C:\Users\A.Kosterin\Desktop\SPOOL\BD\ALPHA\aak_alpha.BIS_TEST_EACP.csv.dis'" >>loader.ctl
echo "replace" >> loader.ctl
echo "INTO TABLE aak_alpha" >> loader.ctl
echo 'FIELDS TERMINATED BY \";\" TRAILING NULLCOLS' >> loader.ctl
echo "(" >> loader.ctl

#Здесь оставляем список только тех колонок, которые есть в NEW

$f1=get-content -Path $path\temp2.txt
$f2=get-content -Path $path\temp1.txt
foreach ($objf1 in $f1)
{
                $objf1 = $objf1.tostring().Trim()
                $objf1 = $objf1.Replace(" ","")
                $objf1 = $objf1.ToUpper()
                $found = $false

                foreach ($objf2 in $f2)
                {
                               $objf2=$objf2.Replace(" ", "")
                               $objf2=$objf2.Trim()
                               $objf2=$objf2.ToUpper()        
                               if ($objf1 -eq $objf2)
                               {                                            
                                               $found = $true                               
                               }                             
                }
                if (($found) -and ($objf1 -ne ""))
                {
echo $objf1 >> temp3.txt

Get-Content "$path\settings.txt" | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }
#$h.Get_Item("$objf1")
#$objf1

$num = -1

do {

$max = $max - 1
$num = $num + 1

if ($h.Get_Item("$objf1") -like "$num")
{echo "$objf1," >> loader.ctl
echo $max
echo $num
}

} while ( $num -lt 10 )



#if ($h.Get_Item("$objf1") -like "0")
#{echo "$objf1," >> loader.ctl}


if ($objf1 -like "*DATE*")
{Write-Host "$objf1 Найден тип DATE"

}

          
                }
}

#echo "NUMBER_1," >> loader.ctl
#echo "DATE_1     DATE 'DD.MM.YYYY HH24:MI:SS'," >> loader.ctl
#echo "RANDOM_3" >> loader.ctl
echo ")" >> loader.ctl



