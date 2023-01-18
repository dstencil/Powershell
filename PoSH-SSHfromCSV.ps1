#Requires Posh-SSH


#Specify $filepath for list of computers
$filepath = "C:\users\file\to\path
$file = "filename.csv"
#Import list from file above
$objects = Import-CSV "$filepath\$file"
#Results of output.log
$result = "C:\path\to\output.log"
if (Test-Path $result) {
    Write-Host "file Exists skipping creating csv file...."
}
else
{
    New-Item $result -ItemType File
    Write-Host "file Created Successfully"
}
#Iterate through and run commands on each one using variables available
ForEach ($object in $objects) {
$IPAddress = $object.IP_Address
#credentials to login
$user = $object.User
$password = ConvertTo-SecureString $object.Password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($user,$password)
#Create session to grab info on home folder and file output
$session = New-SSHSession -ComputerName $IPAddress -Credential $creds 
$pwdoutput = Invoke-SSHCommand -Index 0 -Command "pwd"
$lsoutput = Invoke-SSHCommand -Index 0 -Command "ls -l"
$fileoutput = Invoke-SSHCommand -Index 0 -Command "cat ~/folder/file.txt"
"


$IPAddress

List Home Folders

"| Out-File -FilePath $result -Append
$lsoutput.Output | Out-File -FilePath $result -Append
"

File Logs


"| Out-File -FilePath $result -Append
$fileoutput.Output | Out-File -FilePath $result -Append
Remove-SSHSession $session -Verbose
}
Write-Host "Output wrote to $result"
