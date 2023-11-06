$targetComputerNamesOrIPs = Get-Content -Path .\computerNamesOrIPs.txt

#Get commands mapping
$mappings = Get-Content -Path .\test-mapping.json | ConvertFrom-Json

$commands = $mappings.commands

#Log In
$Credential = Get-Credential

# SSH into the Linux machine and execute the commands
foreach ($targetComputerNamesOrIP in $targetComputerNamesOrIPs) {
    try {
        $session = New-SSHSession -ComputerName $targetComputerNamesOrIP -Credential $Credential
    }
    catch {
        Write-Host "Could not open the session: $_"
    }

    if ($session) {
        foreach ($command in $commands) {
            try {
                $result = Invoke-SSHCommand -SessionId $session.SessionId -Command $command -ErrorAction Stop
                if ($result.ExitStatus -ne 0) {
                    Write-Host "Command failed with exit code $($result): $command"
                    # Optionally, you can choose to break out of the loop or continue with the next command.
                }
                else
                {
                    Write-Host "Completed $command"
                }
            }
            catch {
                Write-Host "Error executing command: $_"
                # Optionally, you can choose to break out of the loop or continue with the next command.
            }
        }
        Remove-SSHSession -SessionId $session.SessionId
    } 
    else 
    {
        Write-Host "Failed to establish an SSH session."
    }
}