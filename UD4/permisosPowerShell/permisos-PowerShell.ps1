#Permisos de red. 
#Crear un recurso compartido y asignar permisos al miso. Ejemplo: Asignar a la carpeta Publico los permisos de red siguientes:
#Acceso total (FullAccess) al usuario administrador
#Acceso en modo lectura (ReadAccess) para todos.

New-SmbShare -Name Publico-RC -Path F:\Publico -FullAccess administrador -ReadAccess Everyone

#Añadir permiso NTFS a una carpeta. Ejemplo: Carpeta C:\Publico
$ruta = 'C:\Publico'
#Creamos la carpeta que hemos añadido en la variable $ruta 
New-Item -Path $ruta -ItemType Directory

#Obtenemos la lista acl (permisos NTFS) de la carpeta
$getPermisosNTFS = Get-Acl -Path $ruta
 
$permisoadd = 'Todos', 'FullControl', 'ContainerInherit, ObjectInherit', 'None', 'Allow'
$regla = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permisoadd
$getPermisosNTFS.SetAccessRule($regla)
 
#Añadir permisos a la carpeta
$getPermisosNTFS | Set-Acl -Path $ruta
 
#Comprobar permisos
$getPermisosNTFS.Access

 



#----------------------------
#Elimnar Permisos explícitos
#----------------------------
#Los permisos explícitos son aquellos que se establecen de forma predeterminada en objetos que no son secundarios cuando se crea el objeto, o los que crea el usuario en objetos secundarios, primarios o que no son secundarios.
 
$Path = 'C:\Publico'
$acl = Get-Acl -Path $path
$acl.Access | Select-Object IdentityReference,IsInherited
 
#Eliminar permisos explícitos
$acl.Access | Where-Object{!($_.isInherited)} | ForEach-Object {$acl.RemoveAccessRule($_)}
$acl.Access | Select-Object IdentityReference,IsInherited
 
#Asignar nuevos permisos
$acl | Set-Acl -Path $path
