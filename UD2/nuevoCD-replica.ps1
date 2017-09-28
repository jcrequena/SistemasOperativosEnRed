Import-Module ADDSDeployment `
Install-ADDSDomainController –NoGlobalCatalog:$False `
–CreateDNSDelegation:$False `
–Credential (Get-Credential) `
–CriticalReplicationOnly:$False `
–DatabasePath “C:\Windows\NTDS” `
–DomainName “smr.es” `
–InstallDNS:$True `
–LogPath “C:\Windows\NTDS” `
–NoRebootOnCompletion:$False `
–SiteName “Default-First-Site-Name” `
–SysVolPath “C:\Windows\SysVol” 

#NOTA: smr.es es el nombre del controlador del dominio principal, este nuevo CD haría las veces de réplica o balenceo de cargas.
