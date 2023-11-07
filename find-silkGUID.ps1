$targetComputerNamesOrIPs = Get-Content -Path .\computerNamesOrIPs.txt

$fileName = "file-" + (Get-Random) + ".txt"
$fileLocation = ".\"

New-Item -Path $fileLocation -Name $fileName

$devicePath = '/dev/sdc'

# Get Computer Information
$Credential = Get-Credential

foreach ($computerNameOrIP in $targetComputerNamesOrIPs)
{
   $computerNameOrIP = $computerNameOrIP.Trim()
   
   try 
   {
        # Check if the computer is reachable before establishing an SSH session
        $isReachable = Test-Connection -ComputerName $computerNameOrIP -Count 1 -ErrorAction Stop

        if ($isReachable)
        {
            $ssh = New-SSHSession -ComputerName $computerNameOrIP -Credential $Credential
        }
        else
        {
            Write-Host "Computer $computerNameOrIP is not reachable."
            continue  # Skip to the next computer
        }
   }
   catch
   {
        Write-Host "Could not establish a connection to ${computerNameOrIP}: $_"
        continue  # Skip to the next computer
   }

   try
   {
       # Change command to sdparm and grep the vendor specific property
       $output = $(Invoke-SSHCommand -SSHSession $ssh -Command "sudo hdparm -I ${devicePath} | grep 'Logical/Physical Sector size'").Output

       $output = $output -split '\s+' | Select-Object -Last 2
       $output = $output.Trim()

       $structureData = "$computerNameOrIP,$output"
       Add-Content -Path ".\$fileName" -Value $structureData
   }
   catch
   {
       Write-Host "Error executing SSH command on ${computerNameOrIP}: $_"
   }
   finally
   {
       Remove-SSHSession -SessionId $ssh.SessionId
   }
}
