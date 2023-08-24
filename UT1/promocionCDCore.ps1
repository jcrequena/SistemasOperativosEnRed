#
# Script de Windows PowerShell para implementación de AD DS
#

$dominioFQDN = "smr.local"
$dominioNETBIOS = "SMR"
$adminPass = "sor-smr2021."
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$False `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName $dominioFQDN `
-DomainNetbiosName $dominioNETBIOS `
-SafeModeAdministratorPassword (ConvertTo-SecureString -string $adminPass -AsPlainText -Force)
-ForestMode "WinThreshold" `
-InstallDns:$True `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$False `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true

#Notas:
-DomainMode -ForestMode
#Specifies the domain functional level of the first domain in the creation of a new forest. S
#upported values for this parameter can be either a valid integer or a corresponding enumerated string value. 
#For instance, to set the domain mode level to Windows Server 2008 R2, you can specify either a value of 4 or Win2008R2.
#The acceptable values for this parameter are:
    Windows Server 2003: 2 or Win2003
    Windows Server 2008: 3 or Win2008
    Windows Server 2008 R2: 4 or Win2008R2
    Windows Server 2012: 5 or Win2012
    Windows Server 2012 R2: 6 or Win2012R2
    Windows Server 2016: 7 or WinThreshold



Referencia:
https://docs.microsoft.com/es-es/powershell/module/addsdeployment/?view=windowsserver2022-ps&viewFallbackFrom=win10-ps
