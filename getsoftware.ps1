
$comp= gc "C:\downloads\servers.txt"
$infoObject=@()
$results=@()
foreach($co in $comp)
{
$co
$css = @"
<style>
h1, h5, th { text-align: center; font-family: Segoe UI; }
table { margin: auto; font-family: Segoe UI; box-shadow: 10px 10px 5px #888; border: thin ridge grey; }
th { background: #0046c3; color: #fff; max-width: 400px; padding: 5px 10px; }
td { font-size: 11px; padding: 5px 20px; color: #000; }
tr { background: #b8d1f3; }
tr:nth-child(even) { background: #dae5f4; }
tr:nth-child(odd) { background: #b8d1f3; }
</style>
"@

$infoObject = New-Object PSObject
$p=Test-Connection -ComputerName $co -BufferSize 16  -Count 1 -Quiet
$p
if ($p -eq $true)
{

    $os = (Get-WMIObject win32_operatingsystem -ComputerName $co ).caption
    $os
    $product=Get-WmiObject -ClassName Win32_product -Property *|select Name
    $h=($product|select @{Name="name" ;expression={$product.name -join ","}} -Last 1).name
    $h
    $infoObject|Add-Member -MemberType NoteProperty -Name "Hostname"  -value $co
    $infoObject|Add-Member -MemberType NoteProperty -Name "Reachable"  -value $p
    $infoObject|Add-Member -MemberType NoteProperty -Name "Operating System"  -value $os
    $infoObject|Add-Member -MemberType NoteProperty -Name "Product" -Value $h
    $results+=$infoObject
}

else
{

$infoObject|Add-Member -MemberType NoteProperty -Name "Hostname"  -value $co
$infoObject|Add-Member -MemberType NoteProperty -Name "Reachable"  -value $p
#$infoObject|Add-Member -MemberType NoteProperty -Name "Operating System"  -value $os
#$infoObject|Add-Member -MemberType NoteProperty -Name "Auto Stopped services" -Value $h
$results+=$infoObject

}
}
$results|Export-csv "C:\AD_Reports\Software\result.csv"  -NoTypeInformation
Import-CSV "C:\AD_Reports\Software\result.csv" | ConvertTo-Html -Head $css  | Out-File "C:\AD_Reports\Software\result.html"

