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
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "WinThreshold" -DomainName "smr.local" -DomainNetbiosName "SMR" -ForestMode "WinThreshold" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true


#Nota:
#https://docs.microsoft.com/en-us/powershell/module/addsdeployment/install-addsforest?view=windowsserver2019-ps
#Domain Mode y -ForestMode
#Windows Server 2003: 2 or Win2003
#Windows Server 2008: 3 or Win2008
#Windows Server 2008 R2: 4 or Win2008R2
#Windows Server 2012: 5 or Win2012
#Windows Server 2012 R2: 6 or Win2012R2
#Windows Server 2016: 7 or WinThreshold
