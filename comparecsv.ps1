$a = Import-Csv -Path \path\to\file1.csv
$b = Import-Csv -Path \path\to\file2.csv
$csvfile = \path\to\outfile.csv
$htmlfile = \path\to\outfile.html

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




Compare-Object $a $b -property Header1, Header2, etc. | Export-Csv $csvfile

Import-Csv $csvfile | ConvertTo-Html - Head -$css -Body "<h1> Difference Report: </h1> <h5> <= removed </h5> <h5> >= added </h5>"| Out-File $htmlfile

