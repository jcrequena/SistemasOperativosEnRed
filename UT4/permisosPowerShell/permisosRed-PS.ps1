#Permisos de red. 
#Manual: https://docs.microsoft.com/en-us/powershell/module/smbshare/new-smbshare?view=windowsserver2019-ps
#---------------------------------------------------------------------------------------
#Ejemplo práctico: Asignar a la carpeta Publico los permisos de red siguientes en el dominio smr.local:
#------------------------------------------------------------------------------
#Directorio Publico en F:
#Aceso sólo lectura a los usuarios del departamento de Marketing
#Acceso lectura y cambio para los usuarios del departamento de Informática

#Acceso Total (FullAccess) para el grupo Administradores
#Nos solicitan que de manera simultánea sólo puedan haber 28 usuarios a la vez
#-------------------------------------------------------------------------------
#Análisis y diseño para solucionar el ejemplo
#---------------------------------------------------
#Grupos Locales: Usaremos 3 grupos locales para dar los permisos de lectura, cambio y total
#Grupos Locales:SMR-GL-Read-DirPublico , SMR-GL-Change-DirPublico y SMR-GL-Total-DirPublico
#Grupos Globales: Se tiene 1 grupo global para los usuarios del departamento de Marketing - SMR-GG-DepMarketing
#Grupos Globales: Se tiene 1 grupo global para los usuarios del departamento de Informática - SMR-GG-DepInformatica
#El grupo SMR-GL-Read-DirPublico tendrá como miembro al grupo global SMR-GG-DepMarketing
#El grupo SMR-GL-Change-DirPublico tendrá como miembro al grupo global SMR-GG-DepInformatica
#El grupo SMR-GL-Total-DirPublico tendrá como miembro al grupo Administradores

#Con -ConcurrentUserLimit establecemos a 28 el número de usuarios que podrán acceder de manera simultánea al recurso compartido
#En -Description ponemos una breve descripción de la utilidad del directorio compartido


#----------------------------------
#Solución
#----------------------------------
$ruta = 'F:\Publico'
#Creamos la carpeta que hemos añadido en la variable $ruta 
New-Item -Path $ruta -ItemType Directory

New-SmbShare -Name Publico-RC -Path $ruta -FullAccess SMR-GL-Total-DirPublico -ReadAccess SMR-GL-Read-DirPublic `
-ChangeAccess SMR-GL-Change-DirPublico -ConcurrentUserLimit 28 `
-Description "Carpeta publico para el acceso de usuarios"
