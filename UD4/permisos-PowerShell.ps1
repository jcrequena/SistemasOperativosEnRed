#Permisos de red. 
#Crear un recurso compartido y asignar permisos al miso. Ejemplo: Asignar a la carpeta Publico los permisos de red siguientes:
#Acceso total (FullAccess) al usuario administrador
#Acceso en modo lectura (ReadAccess) para todos.

New-SmbShare -Name Publico-RC -Path F:\Publico -FullAccess administrador -ReadAccess Everyone


