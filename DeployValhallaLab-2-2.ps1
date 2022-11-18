#Script 2.2 - Script to add PC to domain
Write-Host "   _____ _ _            __      __   _ _           _ _       "
Write-Host "  / ____(_) |           \ \    / /  | | |         | | |      "
Write-Host " | |     _| |__   ___ _ _\ \  / /_ _| | |__   __ _| | | __ _ "
Write-Host " | |    | | '_ \ / _ \ '__\ \/ / _\` | | '_ \ / _\` | | |/ _\` |"
Write-Host " | |____| | |_) |  __/ |   \  / (_| | | | | | (_| | | | (_| |"
Write-Host "  \_____|_|_.__/ \___|_|    \/ \__,_|_|_| |_|\__,_|_|_|\__,_|"
Write-Host "   -------------------------------------------------"
Write-Host " Script 2.2 - Script to add PC to domain"
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

#Add DNS to network adapter
Write-Host " [+] Adding DNS..."
try{
    Set-DNSClientServerAddress –InterfaceIndex (Get-NetAdapter).InterfaceIndex –ServerAddresses ($DCADDRESS,$natdns)
    Write-Host " [+] DNS added"
}
catch {
    Write-Host " [-] Error adding DNS"
}

#Create credential
#Add computer to domain
Write-Host " [+] Creating credentials..."
try{
    [string]$domainAdminUser = "$($NETBIOSNAME)\$($DOMAINADMINUSER)"
    [securestring]$domainAdminPassSec = ConvertTo-SecureString "$($DOMAINADMINPASS)" -AsPlainText -Force
    [pscredential]$credObject = New-Object System.Management.Automation.PSCredential($domainAdminUser, $domainAdminPassSec)
    Write-Host " [+] Credential created"
}
catch {
    Write-Host " [-] Error creating credentials"
}

#Add computer to domain
Write-Host " [+] Adding computer to domain"
try{
    Start-Sleep -Seconds 3
    Add-Computer -DomainName $DOMAINNAME -Credential $credObject -Restart
}
catch {
    Write-Host " [-] Error adding computer to domain"
}