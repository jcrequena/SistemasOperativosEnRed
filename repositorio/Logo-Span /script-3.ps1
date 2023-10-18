$nameServer="serv-resp"
$IPAddress = ”192.168.1.1”
$Prefix = 24
$Gateway=192.168.1.254
New-NetIPAddress –IPAddress $IPAddress -DefaultGateway $Gateway -PrefixLength $Prefix -InterfaceIndex (Get-NetAdapter).InterfaceIndex

Rename-Computer -NewName $nameServer


Import-Module ServerManager
Add-WindowsFeature AD-Domain-Services
Import-Module ADDSDeployment 

Install-ADDSDomainController ` 
-DomainName "logo-span.com" `
–Credential (Get-Credential) `
–SiteName “Default-First-Site-Name” `
–InstallDNS:$True `
–NoGlobalCatalog:$false `
-CreateDNSDelegation:$false `
-ReplicationSourceDC "serv-raiz.logo-span.com" `
–CriticalReplicationOnly:$False –DatabasePath “C:\Windows\NTDS” `
–LogPath “C:\Windows\NTDS” `
–SysVolPath “C:\Windows\SysVol” `
–NoRebootOnCompletion:$False `
-Force:$true
