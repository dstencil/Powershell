
$comp= gc "C:\Users\user\Downloads\servers.txt"
$infoObject=@()
$results=@()
$csvfoldername = "C:\AD_Reports\Groups\Software\CSV\$datestring"
$htmlfoldername = "C:\AD_Reports\Groups\Software\HTML\$datestring"
$foldername = "C:\AD_Reports\Groups\Software"
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
if (Test-Path $csvfoldername) {
    Write-Host "Folder Exists creating csv file...."
}
else
{
    New-Item $csvfoldername -ItemType Directory
    Write-Host "Folder Created Successfully"
}
if (Test-Path $htmlfoldername) {
    Write-Host "Folder Exists creating csv file...."
}
else
{
    New-Item $htmlfoldername -ItemType Directory
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

$csvFile = $csvfoldername + $dateString + "_" + $co + $env:USERDNSDomain + "_" + $filename + $csvext
$htmlFile = $htmlfoldername + $dateString + "_" + $co + $env:USERDNSDomain + "_" + $filename + $htmlext

$infoObject = New-Object PSObject
$p=Test-Connection -ComputerName $co -BufferSize 16  -Count 1 -Quiet
$p
if ($p -eq $true)
{

    $csvproduct=Get-WmiObject -ComputerName $co -ClassName Win32_product 
    $results += $csvproduct | Select-Object -Property Name,Description,Vendor,Version,HelpLink,HelpTelephone
    $results | Export-Csv -Path $csvfile -Encoding Unicode
    Import-CSV $csvfile | ConvertTo-Html -Head $css -Body "<h1>$co</h1><h1>Software Report<h1><h5>$dateString</h5>" | Out-File $htmlFile
    Write-Host "$co files Created Successfully in $foldername"
}

else
{

Write-Host $co + "not found"

}
}

