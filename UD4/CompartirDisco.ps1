# Para obtener información acerca de los recursos compartidos utilizaremos la clase WMI Win32_Share, junto con el cmdlet 
# Get-WmiObject. Para obtener un listado de todos los recursos compartidos por el sistema escribiremos lo siguiente:
# Get-WMIObject -class win32_shar

# Supongamos que queremos compartir un directorio que se halla en la ruta 
# C:\Publico\Proyecto1. Declararemos las variables que nos definen las propiedades del recurso compartido:

$ruta="C:\Publico\Proyecto1"
$clase_WIM="Win32_Share"
$usuarios=5 #Número máximo de usuarios (5) que se conectarán al recurso de manera simultánea.
$nombre_compartido="Proyecto1_Compartido"
$descripcion="Esta es una compartición hecha con PowerShell para el Proyecto 1"
$tipo=0 #Tipo 0 es para directorios
# El siguiente paso consiste en utilizar el método create de la clase Win32_Share con las variables que acabamos de crear.

$objetoWMI=[wmiClass]$clase_WIM
$error_devuelto=$objetoWMI.create($ruta, $nombre_compartido, $tipo, $usuarios, $descripcion)
Write-Host $error_devuelto.returnValue

# Como el método create devuelve un código de error, lo capturaremos con la variable $error_devuelto para poder 
# averiguar la causa del fallo en caso de que este se produzca. En el siguiente enlace encontraréis una relación 
# de los errores que devuelve el método anterior con su significado.
# http://www.computerperformance.co.uk/powershell/powershell_wmi_shares_error.htm

#Para eliminar carpetas compartidas
$clase_WIM="Win32_Share"
$objetoWMI=Get-WmiObject -Class $clase_WIM -filter "Name='Nombre_de_red_del_recurso_compartido'"
$objetoWMI.delete()
