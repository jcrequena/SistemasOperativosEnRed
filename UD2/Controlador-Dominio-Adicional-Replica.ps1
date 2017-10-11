#Referencia
# https://docs.microsoft.com/es-es/windows-server/identity/ad-ds/deploy/install-a-replica-windows-server-2012-domain-controller-in-an-existing-domain--level-200-#BKMK_PS
# Este comando promociona un equipo Windows Server R2 Datacenter a controlador de dominio adicional (réplica) en el Controlador
# del dominio existente smr.local.
# Este nuevo CD haría las veces de réplica o balenceo de cargas.
# Antes de ejecutar el script debes realizar:
# 1. Configurar el tcp/ip del equipo con una ip dentro del rango del maestro de operaciones y con el dns principal la ip del
# servidor maestro de operaciones.
# 2. Integrar el equipo en el dominio smr.local

# Enlace al vídeo explicativo del proceso: https://youtu.be/oMtheS4Xa-c

#  
# Windows PowerShell Script for AD DS Deployment  
#  
Import-Module ADDSDeployment `
Install-ADDSDomainController 
–NoGlobalCatalog:$false `
–CreateDNSDelegation:$false `
–Credential (Get-Credential) `
–CriticalReplicationOnly:$false `
–DatabasePath “C:\Windows\NTDS” `
–DomainName “smr.local” `
–InstallDNS:$True `
–LogPath “C:\Windows\NTDS” `
–NoRebootOnCompletion:$False `
-ReplicationSourceDC "srv-2012R2D-FSMO.smr.local" `
–SiteName “Default-First-Site-Name” `
–SysVolPath “C:\Windows\SYSVOL” `
-Force:$true

# Para ver el significado de cada parámetro del cmdlet ir a: 
#https://technet.microsoft.com/es-es/library/hh974723(v=wps.630).aspx


# NOTA: srv-2012R2D-FSMO es el nombre del equipo servidor maestro de operaciones

