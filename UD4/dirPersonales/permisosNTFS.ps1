#usuario juancarlos.requena 
$cuenta="juancarlos.requena"

#Creamos Permisos Totales para el usuario
New-Item -Path F:\Dir-Personales\$cuenta -ItemType Directory
#Recuperamos en la variable Acl la lista acl del directorio que se acaba de crear
$Acl= Get-Acl "F:\Dir-Personales\$cuenta"
#Se crea un objeto con los permisos para el usuario, en este caso, control Total
$nueva_ACL = New-Object System.Security.AccessControl.FileSystemAccessRule("smr\$cuenta","FullControl","Allow")
#Establecemos los permisos ($nueva_ACL) a la lista acl que se obtuvo anteriormente
$Acl.SetAccessRule($nueva_ACL)
#Establecemos la lista acl al directorio del usuario
Set-Acl "F:\Dir-Personales\$cuenta" $Acl
