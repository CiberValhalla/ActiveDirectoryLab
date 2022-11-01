#Configuration
$servername = "DC02"
$address = "192.168.2.101"
$gateway = "192.168.2.1"
$mask = "24"
$dns = "127.0.0.1"

#Workflow to rename and continue executing after reboot
#https://stackoverflow.com/questions/15166839/powershell-reboot-and-continue-script
workflow Rename-And-Reboot {
  param ([string]$Name)
  Rename-Computer -NewName $Name -Force -Passthru
  Restart-Computer -Wait
}

#---STEP1: Computer rename with workflow
Rename-And-Reboot $servername
#TODO: Eliminar
Write-Host "He continuado tras reboot"

#---STEP2: Assign static IP address
#Remove existing interface
Remove-NetRoute -InterfaceIndex (Get-NetAdapter).InterfaceIndex -Confirm:$false
Remove-NetIPAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -Confirm:$false
#Assign new IP and DNS
New-NetIPAddress –IPAddress $address -DefaultGateway $gateway -PrefixLength $mask -InterfaceIndex (Get-NetAdapter).InterfaceIndex
Set-DNSClientServerAddress –InterfaceIndex (Get-NetAdapter).InterfaceIndex –ServerAddresses $dns

