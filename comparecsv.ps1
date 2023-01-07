$a = Import-Csv -Path \path\to\file1.csv
$b = Import-Csv -Path \path\to\file2.csv


Compare-Object $a $b -property Header1, Header2 | Export-Csv \path\to\outfile.csv
