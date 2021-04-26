$ts = New-TimeSpan -Minutes 1
$then = (get-date) + $ts

$then = $then.ToString('HHmm')
$now = (Get-Date).ToString('HHmm')


do {
$now = (Get-Date).ToString('HHmm')
echo $then
echo $now
} while ( $then -gt $now )