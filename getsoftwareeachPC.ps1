$comp= gc "C:\Users\user\Downloads\servers.txt"
$infoObject=@()
$results=@()
$foldername = "C:\AD_Reports\Groups\Software\$datestring"
$csvext = ".csv"
$htmlext = ".html"
$dateString = (Get-Date).ToString("yyyy-MM-dd")




#Test Folder Path and Create if not exists
if (Test-Path $foldername) {
    Write-Host "Folder Exists creating csv file...."
}
else
{
    New-Item $foldername -ItemType Directory
    Write-Host "Folder Created Successfully"
}



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

$csvFile = $foldername + $dateString + "_" + $co + $env:USERDNSDomain + "_" + $filename + $csvext
$htmlFile = $foldername + $dateString + "_" + $co + $env:USERDNSDomain + "_" + $filename + $htmlext

$infoObject = New-Object PSObject
$p=Test-Connection -ComputerName $co -BufferSize 16  -Count 1 -Quiet
$p
if ($p -eq $true)
{

	$csvproduct=Get-WmiObject -ComputerName $co -ClassName Win32_product -Verbose | -Select-Object -Property Name,Description,Vendor,Version,HelpLink,HelpTelephone | Export-csv $csvfile
	#$results|Export-csv $csvFile  -NoTypeInformation
	Import-CSV $csvFile | ConvertTo-Html -Head $css  | Out-File $htmlFile
    Write-Host "$co files Created Successfully in $foldername"
}

else
{

Write-Host $co + "not found"

}
}
