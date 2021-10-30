# Domino raiz : smr.local
# Subdominio: sor.smr.local

#
# Script de Windows PowerShell para implementación de AD DS
#

if (!(Get-Module -Name ServerManager)) #Se comprueba si se tiene cargado el módulo
{
  Import-Module ServerManager #Se carga el módulo
}

#
#Se instala el rol AD DS
#
Add-WindowsFeature AD-Domain-Services

if (!(Get-Module -Name ADDSDeployment)) #Se comprueba si se tiene cargado el módulo
{
  Import-Module ADDSDeployment #Se carga el módulo
}

Install-ADDSDomain `
-NoGlobalCatalog:$false `
-CreateDnsDelegation:$true `
-Credential (Get-Credential) `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainType "ChildDomain" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NewDomainName "sor" `
-NewDomainNetbiosName "SOR" `
-ParentDomainName "smr.local" `
-NoRebootOnCompletion:$false `
-SiteName "Default-First-Site-Name" `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true

#-Force:$true fuerza la instalación sin preguntar al usuario.

#Nota:
#https://docs.microsoft.com/en-us/powershell/module/addsdeployment/install-addsforest?view=windowsserver2019-ps
#Domain Mode
#Windows Server 2003: 2 or Win2003
#Windows Server 2008: 3 or Win2008
#Windows Server 2008 R2: 4 or Win2008R2
#Windows Server 2012: 5 or Win2012
#Windows Server 2012 R2: 6 or Win2012R2
#Windows Server 2016: 7 or WinThreshold
