

#usuario juancarlos.requena 
$cuenta="juancarlos.requena"

#Creamos Permisos Totales para el usuario
New-Item -Path F:\Dir-Personales\$cuenta -ItemType Directory
$Acl= Get-Acl "F:\Dir-Personales\$cuenta"
$nueva_ACL = New-Object System.Security.AccessControl.FileSystemAccessRule("smr\$cuenta","FullControl","Allow")
$Acl.SetAccessRule($nueva_ACL)
Set-Acl "E:\Dir-Personales\$cuenta" $Acl


https://www.jesusninoc.com/03/03/ejemplos-de-powershell-asignacion-de-permisos/
