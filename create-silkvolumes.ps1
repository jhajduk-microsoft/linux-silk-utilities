    
$targetComputerNamesOrIPs = Get-Content -Path .\computerNamesOrIPs.txt

$fileName = "file-" + (Get-Random) + ".txt"
$fileLocation = ".\"

New-Item -Path $fileLocation -Name $fileName
$Credential = Get-Credential

$devicePath = '/dev/sdc'

#Get Computer Information
foreach ($computerNameOrIP in $targetComputerNamesOrIPs)
{

   $ssh = New-SSHSession -ComputerName $computerNameOrIP -Credential $Credential

   #Change command to sdparm
   $output = $(Invoke-SSHCommand -SSHSession $ssh -Command "sudo hdparm -I ${devicePath} | grep 'Logical/Physical Sector size'").Output

   $computerNameOrIP = $computerNameOrIP.Trim()

   $output = $output -split '\s+' | Select-Object -Last 2
   $output = $output.Trim()

   $structureData = "$computerNameOrIP,$output"
   Add-Content -Path .\file*.txt -Value $structureData

}

