$dateString = (Get-Date).ToString("yyyy-MM-dd")

$From = "Gmailuser@gmail.com"
$To = "outlookuser@outlook.com"
$CC = ""
$Attachment = "Path\to\file.html"
$Subject = "Subject"
$Body = "<h1>$dateString</h1>"

#used to import and add html report into email body css styling applies $Body above also
$Body += Get-Content "Path\to\file.html"
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$SMTPUser = "Gmailuser@gmail.com"
$SMTPPassword = "AppPassword"
$Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $SMTPUser, $($SMTPPassword | ConvertTo-SecureString -AsPlainText -Force)


Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -BodyAsHTML -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential $Credentials -Attachments $Attachment

