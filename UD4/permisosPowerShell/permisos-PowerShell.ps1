#Permisos de red. 
#Crear un recurso compartido y asignar permisos al miso. Ejemplo: Asignar a la carpeta Publico los permisos de red siguientes:
#Acceso total (FullAccess) al usuario administrador
#Manual: https://docs.microsoft.com/en-us/powershell/module/smbshare/new-smbshare?view=windowsserver2019-ps
#Usamos 2 grupos locales para los permisos de lectura y cambio
#Acceso total para el grupo Administradores
#Con ConcurrentUserLimit establecemos a 28 el número de usaurios que acceden de manera simultánea al recurso compartido
#En Description ponemos una breve descripción de la utilidad del directorio compartido

#----------------------------------
#Ejemplo Práctico permisos de red
#----------------------------------

$ruta = 'F:\Publico'
#Creamos la carpeta que hemos añadido en la variable $ruta 
New-Item -Path $ruta -ItemType Directory

New-SmbShare -Name Publico-RC -Path $ruta -FullAccess Administradores -ReadAccess SMR_GL_R_DirPublico `
-ChangeAccess SMR_GL_RW_DirPublico -ConcurrentUserLimit 28 `
-Description "Carpeta publico para el acceso de usuarios"

#-------------------------------------------
#Ejemplo Práctico permisos NTFS - Seguridad al directorio F:\Publico
#------------------------------------------
#Los puntos que hay que seguir para establecer los permisos NTFS son
#1. Recuperar las reglas de ACL existente
#1.1 Eliminar la herencia
#2. Crea un nuevo FileSystemAccessRule 
#3. Agregar la nueva regla ACL en el conjunto de permisos existente
#4. Aplicar la nueva ACL al archivo o carpeta existente usando Set-ACL


#0.Deshabilitar / habilitar la herencia de permisos
$ ACL.SetAccessRuleProtection ($true, $false) $ACL | Set-Acl -Path $ruta


#----------------------------
#Al grupo local SMR_GL_R_DirPublico le damos permisos de lectura en el directorio
#----------------------------
#1. Obtenemos la lista acl (permisos NTFS) de la carpeta
$acl = Get-Acl -Path $ruta
"1.1 Quitamos la herencia copiando los permisos
$acl.SetAccessRuleProtection($true,$false)
$acl | Set-Acl -Path $ruta
#2. Creamos un nuevo FileSystemAccessRule 
$regla = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule("SMR_GL_R_DirPublico", "Read", "Allow") 
#3.Agregar la nueva regla
$getPermisosNTFS.SetAccessRule($regla)
#4. Aplicar la nueva ACL al archivo o carpeta (Añadir permisos a la carpeta)
$getPermisosNTFS | Set-Acl -Path $ruta


#----------------------------
#Comprobar permisos
#----------------------------
$getPermisosNTFS.Access


#----------------------------
#Elimnar Permisos
#----------------------------

$Path = 'F:\Publico'
$acl = Get-Acl -Path $path
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ("SMR_GL_R_DirPublico", "Read", "Allow")
$acl.RemoveAccessRule ($AccessRule)
 
$acl | Set-Acl -Path $path
