# Get the CSV file
$csvFile = Get-ChildItem -Path "C:\Users\User\Documents\fileHashes.csv"

# Get the file paths and hash values from the CSV file
$csvData = Import-Csv -Path $csvFile

# Create an array to store the changes
$changes = @()

# Loop through each file path in the CSV
foreach ($row in $csvData) {
    $filePath = $row.Path
    $hashValue = $row.HashValue

    # Get the current hash value of the file
    $currentHashValue = Get-FileHash -Path $filePath | Select-Object -ExpandProperty Hash

    # Compare the current hash value to the stored hash value
    if ($currentHashValue -ne $hashValue) {
        # If the hash values are different, add an object to the changes array with the file path and new hash value
        $changes += [pscustomobject]@{
            Path = $filePath
            HashValue = $currentHashValue
        }
    }
}

# Export the changes to a CSV
$changes | Export-Csv -Path "C:\Users\User\Documents\fileChanges.csv" -NoTypeInformation
