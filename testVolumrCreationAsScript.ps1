# Get Credential
$Credential = Get-Credential
# Establish an SSH session
$session = New-SSHSession -ComputerName 10.1.0.6 -Credential $Credential

# Upload the Bash script
Copy-SSHFile -SessionId $session.SessionId -LocalFile ".\testVolumeCreation.sh" -RemotePath "/testVolumeCreation.sh"

# Execute the Bash script remotely
Invoke-SSHCommand -SessionId $session.SessionId -Command "bash /testVolumeCreation.sh"

# Close the SSH session
Remove-SSHSession -SessionId $session.SessionId
