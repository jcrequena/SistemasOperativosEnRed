
$IPAddress = ”192.168.1.2”
$Prefix = 24
$Gateway=192.168.1.254
New-NetIPAddress –IPAddress $IPAddress -DefaultGateway $Gateway -PrefixLength $Prefix -InterfaceIndex (Get-NetAdapter).InterfaceIndex
$nameServer="serv-raiz"
Rename-Computer -NewName $nameServer

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "5" `
-DomainName "logo-span.com" `
-DomainNetbiosName "smr" `
-ForestMode "5" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true


$IPAddress = ”192.168.1.3”
$Prefix = 24
$Gateway=192.168.1.254
New-NetIPAddress –IPAddress $IPAddress -DefaultGateway $Gateway -PrefixLength $Prefix -InterfaceIndex (Get-NetAdapter).InterfaceIndex
$nameServer="serv-deleg-1"
Rename-Computer -NewName $nameServer
Install-ADDSDomain `
-NoGlobalCatalog:$false `
-CreateDnsDelegation:$true `
-Credential (Get-Credential) `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "5" `
-DomainType "ChildDomain" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NewDomainName "delegacion1" `
-NewDomainNetbiosName "DELEGACION1" `
-ParentDomainName "logo-span.com" `
-NoRebootOnCompletion:$false `
-SiteName "Default-First-Site-Name" `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true

$IPAddress = ”192.168.1.4”
$Prefix = 24
$Gateway=192.168.1.254
New-NetIPAddress –IPAddress $IPAddress -DefaultGateway $Gateway -PrefixLength $Prefix -InterfaceIndex (Get-NetAdapter).InterfaceIndex
$nameServer="serv-deleg-2"
Rename-Computer -NewName $nameServer
Install-ADDSDomain `
-NoGlobalCatalog:$false `
-CreateDnsDelegation:$true `
-Credential (Get-Credential) `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "5" `
-DomainType "ChildDomain" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NewDomainName "delegacion2" `
-NewDomainNetbiosName "DELEGACION2" `
-ParentDomainName "logo-span.com" `
-NoRebootOnCompletion:$false `
-SiteName "Default-First-Site-Name" `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
