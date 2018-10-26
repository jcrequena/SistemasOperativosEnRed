#Referencia
# https://docs.microsoft.com/es-es/windows-server/identity/ad-ds/deploy/install-a-replica-windows-server-2012-domain-controller-in-an-existing-domain--level-200-#BKMK_PS
# https://msdn.microsoft.com/es-es/library/jj574134(v=ws.11).aspx
# Este comando promociona un equipo Windows Server R2 Datacenter a controlador de dominio adicional (réplica) en el Controlador
# del dominio existente smr.local.
# Este nuevo CD haría las veces de réplica o balenceo de cargas.
# Antes de ejecutar el script debes realizar:
# 1. Configurar el tcp/ip del equipo con una ip dentro del rango del maestro de operaciones y con el dns principal la ip del
# servidor maestro de operaciones.
# 2. Integrar el equipo en el dominio smr.local

# Enlace al vídeo explicativo del proceso: https://youtu.be/oMtheS4Xa-c
#Instalar el Rol ADDS y DNS Install-WindowsFeature AD-Domain-Services,DNS
#
# Pasos a seguir para promocionar el servidor a controlador de dominio adicional (réplica)
#

#
#1. Importar el módulo de PowerShell que nos permite administrar el servidor
#
Import-Module ServerManager

#
#2. Instalar las características de los servicios de directorio
#
Add-WindowsFeature AD-Domain-Services

#
#3. Importar el módulo que nos permitirá instalar el directorio activo 
#Referencia: AD DS Deployment Cmdlets in Windows PowerShell: https://technet.microsoft.com/es-es/library/hh974719(v=wps.630).aspx
#
if (!(Get-Module -Name ADDSDeployment)) #Se comprueba si se tiene cargado el módulo
{
  Import-Module ADDSDeployment #Se carga el módulo
}
#
#4. Ahora, podemos pasar a promocionar el servidor a controlador de dominio adicional (réplica)
#
Install-ADDSDomainController -DomainName "smr.local" –Credential (Get-Credential) –SiteName “Default-First-Site-Name” –InstallDNS:$True –NoGlobalCatalog:$false -CreateDNSDelegation:$false -ReplicationSourceDC "srv-2012R2D-FSMO.smr.local" –CriticalReplicationOnly:$False –DatabasePath “C:\Windows\NTDS” –LogPath “C:\Windows\NTDS” –SysVolPath “C:\Windows\SysVol” –NoRebootOnCompletion:$False -Force:$true

#Descripción de los parámetros
#
#1. En primer lugar Install- ADDSDomainController es el cmdlet que nos va a permitir instalar y configurar un controlador de dominio (principal o adicional, según indiquemos).
#2. En DomainName indicaremos el nombre del dominio en el que introduciremos el equipo. Como en este caso se trata de una réplica escribiremos el nombre del dominio existente.
#3. Con Credential indicamos las credenciales de usuario con las queremos realizar este proceso. (Get -Credential) abre una ventana en la que podemos introducir el nombre de usuario y la contraseña de una manera más segura que guardándola como texto plano en el script.
#4. SiteName indica el sitio en el que se ubicará el controlador de dominio adicional. Introduciremos el valor por defecto "Default -First- Site- Name".
#5. InstallDNS: $true nos permitirá instalar el servidor DNS, y aprovecharlo para permitir a los equipos de la red que resuelvan nombres en caso de que no esté disponible el DNS principal.
#6. La opción NoGlobalCatalog , nos permitirá especificar si queremos que el controlador que creemos sea de Catálogo Global. Esta opción tiene dos valores: $true o $false . Como queremos que este controlador de respaldo sí almacene el catálogo global, aún a coste de un posible mayor tráfico de red, indicaremos $false (observad que el nombre de la opción es NoGlobalCatalog).
#7. CreateDNSDelegation: $false nos permitirá no tratar de crear una delegación del DNS antes de instalar el servicio.
#8. ReplicationSourceDC nos permite indicar el controlador de dominio del cual se replicarán los datos, en este caso "srv-2012R2D-FSMO.smr.local"
#9. CriticalReplicationOnly especifica si durante la creación del controlador de dominio se realizará una réplica de todo el directorio activo (la cual puede tener un volumen muy grande), o solo de las partes críticas. En el ejemplo que estamos poniendo en marcha indicaremos $false . En caso contrario habríamos indicado $true .
#10. DatabasePath nos va a permitir indicar la ruta dentro del controlador de dominio actual en la que queremos que se almacene la base de datos con la información del directorio activo.
#11. Con LogPath indicaremos la ruta en la que queremos que se almacenen los archivos de registro.
#12. En SysvolPath se halla la ruta en la que se almacenarán ficheros que deben estar accesibles a los equipos clientes como por ejemplo los scripts de inicio de sesión, las políticas de grupo, etc.
#13. NoRebootOnCompletion nos permitirá realizar esta tarea de manera más desatendida, ya que si indicamos $false cuando haya finalizado el sistema se reiniciará automáticamente para que los cambios surtan efecto, sin tener que esperar la intervención del usuario.
#14. Y finalmente indicaremos Force: $true para evitar preguntas de confirmación.


# Para ver el significado oficial de cada parámetro del cmdlet acceder a: https://technet.microsoft.com/es-es/library/hh974723(v=wps.630).aspx

# NOTA: srv-2012R2D-FSMO es el nombre del equipo servidor maestro de operaciones

