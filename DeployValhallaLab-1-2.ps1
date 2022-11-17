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
Write-Host " [+] Removing adapter conf..."
try {
    Remove-NetRoute -InterfaceIndex (Get-NetAdapter).InterfaceIndex -Confirm:$false
    Remove-NetIPAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -Confirm:$false
    Write-Host " [+] Adapter conf removed "
} 
catch {
    Write-Host " [-] Error removing adapter conf"
}

Write-Host " [+] Changing adapter conf..."
try {
    New-NetIPAddress –IPAddress $dcaddress -DefaultGateway $dcgateway -PrefixLength $dcmask -InterfaceIndex (Get-NetAdapter).InterfaceIndex
    Set-DNSClientServerAddress –InterfaceIndex (Get-NetAdapter).InterfaceIndex –ServerAddresses 127.0.0.1
    Set-DNSClientServerAddress –InterfaceIndex (Get-NetAdapter).InterfaceIndex –ServerAddresses $natdns
    Write-Host " [+] Adapter conf changed "
} 
catch {
    Write-Host " [-] Error changing adapter conf"
}


#Install AD DS service

Write-Host " [+] Installing ADDS..."
try {
    Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools
    Write-Host " [+] AD DS installed "
} 
catch {
    Write-Host " [-] Error installing AD DS"
}



Write-Host " [+] Creating FOREST..."
try {
#Create SecureString for password
    $securePass = (ConvertTo-SecureString -String $adminpass -AsPlainText -Force)
    #Create forest and domain
    Install-ADDSForest `
    -SafeModeAdministratorPassword $securePass `
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
    Write-Host " [+] FOREST created "
} 
catch {
    Write-Host " [-] Error with FOREST creation"
}
