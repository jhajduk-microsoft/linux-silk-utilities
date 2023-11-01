    
$targetComputerNamesOrIPs = Get-Content -Path .\computerNamesOrIPs.txt
Write-Host "${targetComputerNamesOrIPs}"

$fileName = "file-" + (Get-Random) + ".csv"
$fileLocation = "C:\path\to\Silk-Utilities\"

New-Item -Path $fileLocation -Name $fileName
$Credential = Get-Credential

$devicePath = '/dev/sdc'

#Get Computer Information
foreach ($computerNameOrIP in $targetComputerNamesOrIPs)
{

    $ssh = New-SSHSession -ComputerName $computerNameOrIP -Credential $Credential

    #Change command to sdparm
    $output = $(Invoke-SSHCommand -SSHSession $ssh -Command "sudo hdparm -I ${devicePath} | grep 'Logical/Physical Sector size'").Output
    $data = @{
        Computer = $computerNameOrIP
        Info = $output
    }

    $data | Export-Csv -Path $fileLocation -Name $fileName
}

