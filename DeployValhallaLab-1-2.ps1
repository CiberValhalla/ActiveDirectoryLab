#Script 1.2 - Script to change adapter and create domain

Write-Host "   _____ _ _            __      __   _ _           _ _       "
Write-Host "  / ____(_) |           \ \    / /  | | |         | | |      "
Write-Host " | |     _| |__   ___ _ _\ \  / /_ _| | |__   __ _| | | __ _ "
Write-Host " | |    | | '_ \ / _ \ '__\ \/ / _\` | | '_ \ / _\` | | |/ _\` |"
Write-Host " | |____| | |_) |  __/ |   \  / (_| | | | | | (_| | | | (_| |"
Write-Host "  \_____|_|_.__/ \___|_|    \/ \__,_|_|_| |_|\__,_|_|_|\__,_|"
Write-Host "   -------------------------------------------------"
Write-Host " Script 1.2 - Script to change adapter and create domain"
Write-Host "  "

Write-Host " [+] Parsing config file..."
#Parse config file
try{
    Foreach ($i in $(Get-Content config.txt)){
        Set-Variable -Name $i.split("=")[0] -Value $i.split("=",2)[1]
    }
    Write-Host " [+] Config file parsed"
    }
catch {
    Write-Host " [-] Error parsing config file"
}

#Change net adapter
PS > Remove-NetRoute -InterfaceIndex (Get-NetAdapter).InterfaceIndex -Confirm:$false
PS > Remove-NetIPAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -Confirm:$false
PS > New-NetIPAddress –IPAddress $dcaddress -DefaultGateway $dcgateway -PrefixLength $dcmask -InterfaceIndex (Get-NetAdapter).InterfaceIndex

Import-Module ADDSDeployment
#Install AD DS service
Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools

#Create forest and domain
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName $domainname `
-DomainNetbiosName $netbiosname `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true


