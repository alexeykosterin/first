$path = "C:\Users\$env:UserName\Desktop\SPOOL\BD"
cd $path

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
                if ((!$found) -and ($objf1 -ne ""))
                {
                              
Write-Host "Не найден $objf1"
                              
                }
                if (($found) -and ($objf1 -ne ""))
                {
Write-Host "Найден $objf1"
                              
                }
}


Get-Content "C:\Users\A.Kosterin\Desktop\SPOOL\BD\settings.txt" | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }
$h.Get_Item("InputFile")

