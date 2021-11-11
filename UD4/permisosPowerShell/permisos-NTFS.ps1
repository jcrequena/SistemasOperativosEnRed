#-------------------------------------------
#Ejemplo Práctico permisos NTFS (Seguridad) al directorio F:\Publico
#Al grupo local SMR_GL_R_DirPublico le damos permisos de lectura en el directorio
#------------------------------------------
#Los puntos que hay que seguir para establecer los permisos NTFS son
#1. Recuperar las reglas de ACL existente
#1.1 Eliminar la herencia
#2. Crea un nuevo FileSystemAccessRule 
#3. Agregar la nueva regla ACL en el conjunto de permisos existente
#4. Aplicar la nueva ACL al archivo o carpeta existente usando Set-ACL

#----------------------------
#INICIO DEL PROCESO
#----------------------------
#1. Obtenemos la lista acl (permisos NTFS) de la carpeta
$acl = Get-Acl -Path $ruta
"1.1 Quitamos la herencia copiando los permisos
$acl.SetAccessRuleProtection($true,$true)
$acl | Set-Acl -Path $ruta
1.2 Eliminamos el grupo Usuarios del dominio (Usuarios)
$grupoUsers='BUILTIN\Usuarios'
--> BUILTIN\Usuarios
Fuente: https://www.enmimaquinafunciona.com/pregunta/105013/eliminar-completamente-un-usuario-de-la-acl-mediante-powershell


#2. Creamos un nuevo FileSystemAccessRule 
$regla = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule("SMR_GL_R_DirPublico", "Read", "Allow") 
#Posibles valores: Read-Write-Modify-
#3.Agregar la nueva regla
$acl.SetAccessRule($regla)
#4. Aplicar la nueva ACL al archivo o carpeta (Añadir permisos a la carpeta)
$acl | Set-Acl -Path $ruta


#----------------------------
#Comprobar permisos
#----------------------------
$acl.Access


#----------------------------
#Elimnar Permisos
#----------------------------

$Path = 'F:\Publico'
$acl = Get-Acl -Path $path
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ("SMR_GL_R_DirPublico", "Read", "Allow")
$acl.RemoveAccessRule ($AccessRule)
 
$acl | Set-Acl -Path $path
