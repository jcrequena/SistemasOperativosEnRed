# Domino raiz : smr.local
# Subdominio: sor.smr.local

#
# Script de Windows PowerShell para implementación de AD DS
#

if (!(Get-Module -Name ADDSDeployment)) #Se comprueba si se tiene cargado el módulo
{
  Import-Module ADDSDeployment #Se carga el módulo
}
Install-ADDSDomain -NoGlobalCatalog:$false -CreateDnsDelegation:$true -Credential (Get-Credential) -DatabasePath "C:\Windows\NTDS" -DomainMode "Win2012R2" -DomainType "ChildDomain" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NewDomainName "sor" -NewDomainNetbiosName "SOR" -ParentDomainName "smr.local" -NoRebootOnCompletion:$false -SiteName "Default-First-Site-Name" -SysvolPath "C:\Windows\SYSVOL" -Force:$true
