#Permisos de red. 
#Crear un recurso compartido y asignar permisos al miso. Ejemplo: Asignar a la carpeta Publico los permisos de red siguientes:
#Acceso total (FullAccess) al usuario administrador
#Acceso en modo lectura (ReadAccess) para todos.
#Manual: https://docs.microsoft.com/en-us/powershell/module/smbshare/new-smbshare?view=windowsserver2019-ps
#Usamos 2 grupos locales para los permisos de lectura y cambio
#Acceso total para el grupo Administradores
#Con ConcurrentUserLimit establecemos a 28 el número de usaurios que acceden de manera simultánea al recurso compartido
#En Description ponemos una breve descripción de la utilidad del directorio compartido

New-SmbShare -Name Publico-RC -Path F:\Publico -FullAccess Administradores -ReadAccess SMR_GL_R_DirPublico `
-ChangeAccess SMR_GL_RW_DirPublico -ConcurrentUserLimit 28 `
-Description "Carpeta publico para el acceso de usuarios"


#Añadir permisos NTFS a una carpeta. Ejemplo: Carpeta C:\Publico
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
