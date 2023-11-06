#Log In
$Credential = Get-Credential

#Get commands mapping
$mappings = Get-Content -Path .\volumeMapping.json | ConvertFrom-Json

$commands = $mappings.commands

# SSH into the Linux machine and execute the commands
try {
    $session = New-SSHSession -ComputerName $linuxMachineIP -Credential (New-Object PSCredential -ArgumentList ($sshUsername, $sshPassword))
}
catch {
    Write-Host "Could not open the session: $_"
}

if ($session) {
    foreach ($command in $commands) {
        try {
            $result = Invoke-SSHCommand -SessionId $session.SessionId -Command $command -ErrorAction Stop
            if ($result.ExitCode -ne 0) {
                Write-Host "Command failed with exit code $($result.ExitCode): $command"
                # Optionally, you can choose to break out of the loop or continue with the next command.
            }
        }
        catch {
            Write-Host "Error executing command: $_"
            # Optionally, you can choose to break out of the loop or continue with the next command.
        }
    }
    Remove-SSHSession -SessionId $session.SessionId
} else {
    Write-Host "Failed to establish an SSH session."
}