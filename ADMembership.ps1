Import-Module ActiveDirectory
$allusers = Get-ADUser -Filter *
$results = @()
$foldername = "C:\AD_Reports\Groups\"


#Test Folder Path and Create if not exists
if (Test-Path $foldername) {
    Write-Host "Folder Exists"
}
else
{
    New-Item $foldername -ItemType Directory
    Write-Host "Folder Created Successfully"
}
#save users into results variable and export to csv
foreach($user in $allUsers)
{

    $userGroups = Get-ADPrincipalGroupMembership -Identity $user
    foreach($group in $userGroups)
    {
        $adGroup = Get-ADGroup -Identity $group -Properties *
        $results += $adGroup | Select-Object -Property @{name='User';expression={$user.SamAccountName}},@{name='Enabled';expression={$user.Enabled}}, Name, Description
    }
}
$results | Export-Csv -Path 'C:\AD_Reports\Groups\Membership.csv' -Encoding Unicode

#set up css and convert csv to html for web page table of results
$css = @"


<style>
h1, h5, th { text-align: center; font-family: Segoe UI; }
table { margin: auto; font-family: Segoe UI; box-shadow: 10px 10px 5px #888; border: thin ridge lime ; }
th { background: #0046c3; color: #fff; max-width: 400px; padding: 5px 10px; }
td { font-size: 11px; padding: 5px 20px; color: #000; }
tr { background: #b8d1f3; }
tr:nth-child(even) { background: #dae5f4; }
tr:nth-child(odd) { background: #b8d1f3; }
</style>

"@

$csvs = get-childitem "C:\AD_Reports\Groups" -filter *.csv -Recurse
$outputfile = "C:\AD_Reports\Groups\adalluser_groups.html"
foreach($csv in $csvs){
Import-CSV $csv.FullName | ConvertTo-Html -Head $css -Body "<h1>Filename: $csv</h1>" | Out-File $outputfile -Append

}
