#Referencia
# https://docs.microsoft.com/es-es/windows-server/identity/ad-ds/deploy/install-a-replica-windows-server-2012-domain-controller-in-an-existing-domain--level-200-#BKMK_PS
# Este comando promociona un equipo Windows Server R2 Datacenter a controlador de dominio adicional (réplica) en el Controlador
# del dominio existente smr.es.

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
