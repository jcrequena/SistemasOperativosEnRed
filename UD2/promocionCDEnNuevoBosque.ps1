#Referencia
# https://docs.microsoft.com/es-es/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-

#
# Script de Windows PowerShell para implementación de AD DS
#
# cmdlet para instalar el rol AD DS y las herramientas de administración de Active Directory.
Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools 

# cmdlet de promoción a CD en un nuevo bosque
if (!(Get-Module -Name ADDSDeployment)) #Se comprueba si se tiene cargado el módulo
{
  Import-Module ADDSDeployment #Se carga el módulo
}
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "Default" -DomainName "smr.local" -DomainNetbiosName "SMR" -ForestMode "Default" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true
