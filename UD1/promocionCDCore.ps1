#
# Script de Windows PowerShell para implementación de AD DS
#

$dominioFQDN = "DC2012R2.ES"
$dominioNETBIOS = "DC2012R2"
$adminPass = "sor-smr2018."
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$False `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Win2012R2" `
-DomainName $dominioFQDN `
-DomainNetbiosName $dominioNETBIOS `
-SafeModeAdministratorPassword (ConvertTo-SecureString -string $adminPass -AsPlainText -Force)
-ForestMode "Win2012R2" `
-InstallDns:$True `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$False `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$True off
