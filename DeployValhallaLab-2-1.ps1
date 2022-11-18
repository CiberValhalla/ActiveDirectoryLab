﻿#Script 1.1 - Script to rename PC
Write-Host "   _____ _ _            __      __   _ _           _ _       "
Write-Host "  / ____(_) |           \ \    / /  | | |         | | |      "
Write-Host " | |     _| |__   ___ _ _\ \  / /_ _| | |__   __ _| | | __ _ "
Write-Host " | |    | | '_ \ / _ \ '__\ \/ / _\` | | '_ \ / _\` | | |/ _\` |"
Write-Host " | |____| | |_) |  __/ |   \  / (_| | | | | | (_| | | | (_| |"
Write-Host "  \_____|_|_.__/ \___|_|    \/ \__,_|_|_| |_|\__,_|_|_|\__,_|"
Write-Host "   -------------------------------------------------"
Write-Host " Script 2.1 - Script to rename PC"
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

#Change hostname
Write-Host " [+] Changing hostname..."
Start-Sleep -Seconds 3
Rename-Computer -NewName $HOST1NAME -Restart