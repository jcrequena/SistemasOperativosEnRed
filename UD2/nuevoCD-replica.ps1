#Referencia
# https://docs.microsoft.com/es-es/windows-server/identity/ad-ds/deploy/install-a-replica-windows-server-2012-domain-controller-in-an-existing-domain--level-200-#BKMK_PS
# Este comando promociona un equipo Windows Server R2 Datacenter a controlador de dominio adicional (réplica) en el Controlador
# del dominio existente smr.local.
# Este nuevo CD haría las veces de réplica o balenceo de cargas.

#  
# Windows PowerShell Script for AD DS Deployment  
#  
Import-Module ADDSDeployment `
Install-ADDSDomainController –NoGlobalCatalog:$false `
–CreateDNSDelegation:$false `
–Credential (Get-Credential) `
–CriticalReplicationOnly:$false `
–DatabasePath “C:\Windows\NTDS” `
–DomainName “smr.local” `
–InstallDNS:$True `
–LogPath “C:\Windows\NTDS” `
–NoRebootOnCompletion:$False `
–SiteName “Default-First-Site-Name” `
–SysVolPath “C:\Windows\SYSVOL” `
-Force:$true


