#Referencia
# https://docs.microsoft.com/es-es/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-

#
# Script de Windows PowerShell para implementación de AD DS
#
# cmdlet para instalar el rol AD DS y las herramientas de administración de Active Directory.
Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools 

# cmdlet de promoción a CD en un nuevo bosque
Import-Module ADDSDeployment Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "Win2012R2" -DomainName "smr.local" -DomainNetbiosName "smr" -ForestMode "Win2012R2" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true


