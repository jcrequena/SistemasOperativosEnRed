#alta_Usuarios-DirPersonales.ps1 : 
#A la ejeción del script le pasamos 2 parámetros para capturar el nombre del dominio y sufijo (donde queremos crear los usuarios)
#Parámetro 1: el nombre netbios del dominio.
#Parámetro 2: el sufijo del dominio
#Ejemplo: smr.local --> Parámetro 1 sería smr y Parámetro 2 local
# Ejemplo de ejecución del script: alta_Usuarios-DirPersonales.ps1 smr local 

#
#Capturamos los 2 parámetros que hemos pasado en la ejecución del script ($a será el nombre del dominio y $b el sufijo)
#
param($a,$b)
$dominio=$a
$sufijo=$b
#En la variable dc componemos el nombre dominio y sufijo. Ejemplo: dc=smr,dc=local.
$dc="dc="+$dominio+",dc="+$sufijo

#
#Primero hay que comprobar si se tiene cargado el módulo Active Directory
#
if (!(Get-Module -Name ActiveDirectory)) #Accederá al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el módulo
}

#
#Creación de los usuarios
#
#
#Preguntamos al usuario que nos indique el fichero csv
#
$fichero_csv=Read-Host "Introduce el fichero csv de los usuarios:"

#El fichero csv tiene esta estructura (13 campos)
#Name:Surname:Surname2:NIF:Group:ContainerPath:Computer:Hability:DaysAccountExpire:HomeDrive:HomeDirectory:PerfilPath:ScriptPath

#
#Importamos el fichero csv (comando import-csv) y lo cargamos en la variable fichero_csv. 
#El delimitador usado en el csv es el : (separador de campos)
#
$fichero_csv_importado = import-csv -Path $fichero_csv -Delimiter : 			     
foreach($linea_leida in $fichero_csv_importado)
{
	#Componemos la ruta donde queda ubicado el objeto a crear (usuario). Ejemplo: OU=DepInformatica,dc=smr,dc=local
  $rutaContenedor =$linea_leida.ContainerPath+","+$dc 
	#
  #Guardamos de manera segura la contraseña con el comando ConvertTo-SecureString. En este caso, la contraseña corresponde al NIF (9 números + letra)
	#
  $passAccount=ConvertTo-SecureString $linea_leida.NIF -AsPlainText -force
	
	$name=$linea.Name
	$nameShort=$linea.Name+'.'+$linea_leida.Surname
	$Surnames=$linea.Surname+' '+$linea_leida.Surname2
	$nameLarge=$linea.Name+' '+$linea_leida.Surname+' '+$linea_leida.Surname2
	$computerAccount=$linea_leida.Computer
	$email=$nameShort+"@"+$a+"."+$b
	$perfilmovil=$linea_leida.PerfilMovil+"\"+$nameShort
  
  
	#Si el usaurio ya existe (Nombre + 1er Apellido), ampliamos el nombre corto con el 2 Apellido   
	if (Get-ADUser -filter { name -eq $nameShort })
	{
		$nameShort=$linea_leida.Name+'.'+$linea_leida.Surname+$linea_leida.Surname2
	}
	#
  #El parámetro -Enabled es del tipo booleano por lo que hay que leer la columna del csv
	#que contiene el valor true/false para habilitar o no habilitar el usuario y convertirlo en boolean.
  #
	[boolean]$Habilitado=$true
  	If($linea_leida.Hability -Match 'false') { $Habilitado=$false}
  
  $ExpirationAccount = $linea_leida.DaysAccountExpire
 	$timeExp = (get-date).AddDays($ExpirationAccount)
	
	New-ADUser `
    -SamAccountName $nameShort `
    -UserPrincipalName $nameShort `
    -Name $nameShort `
		-Surname $Surnames `
    -DisplayName $nameLarge `
    -GivenName $name `
    -LogonWorkstations:$linea.Computer `
		-Description "Cuenta de $nameLarge" `
    -EmailAddress $email `
		-AccountPassword $passAccount `
    -Enabled $Habilitado `
		-CannotChangePassword $false `
    -ChangePasswordAtLogon $true `
		-PasswordNotRequired $false `
    -Path $rutaContenedor `
    -AccountExpirationDate $timeExp `
		-HomeDrive "$linea.HomeDrive:" `
    -HomeDirectory "$linea_leida.DirPersonales\$nameShort" `
    -ProfilePath $perfilmovil `
    -ScriptPath $linea.ScriptPath
	
  #Asignar la cuenta de Usuario creada a un Grupo
	# Distingued Name CN=Nombre-grupo,ou=..,ou=..,dc=..,dc=...
	$cnGrpAccount="Cn="+$linea_leida.Group+","+$rutaContenedor
	Add-ADGroupMember -Identity $cnGrpAccount -Members $nameShort
	
	#
	## Establecer horario de inicio de sesión de 8am - 6pm Lunes (Monday) to Viernes (Friday)   
	# Para ello, importamos una utilidad (Set-OSCLogonHours) que nos permite establecer el horario
  # El SetADUserLogonTime.psm1 está situado en este ejemplo en C:\Scripts\LogonHours
	#
	Import-Module C:\Scripts\LogonHours\SetADUserLogonTime.psm1
	Set-OSCLogonHours -SamAccountName $nameShort -DayofWeek Monday,Tuesday,Wednesday,Thursday,Friday -From 8AM -To 6PM
	
	#
	#Creamos el directorio personal de cada usuario con los permisos adecuados. Control Total para el usuario
	#
	$pathDirPersonales="$linea_leida.HomeDrive:"+"$linea_leida.DirPersonales\$nameShort"
	New-Item -Path $pathDirPersonales -ItemType Directory
	$nueva_ACL = new-object System.Security.AccessControl.FileSystemAccessRule("$dominio\$nombreCorto","FullControl","Allow")
	$acl.AddAccessRule($nueva_ACL)
	set-acl $pathDirPersonales $acl_actual
}



# A continuación, las propiedades de New-ADUser que se han utilizado son:
#SamAccountName: nombre de la cuenta SAM para compatibilidad con equipos anteriores a Windows 2000.
#UserPrincipalName: Nombre opcional que puede ser más corto y fácil de recordar que el DN (Distinguished Name) y que puede ser utilizado por el sistema.
#Name: Nombre de la cuenta de usuario.
#Surname: Apellidos del usuario.
#DisplayName: Nombre del usuario que se mostrará cuando inicie sesión en un equipo.
#GivenName: Nombre de pila.
#Description: Descripción de la cuenta de usuario.
#EmailAddress: Dirección de correo electrónico.
#AccountPassword: Contraseña encriptada.
#Enabled: Cuenta habilitada ($true) o deshabilitada ($false).
#CannotChangePassword: El usuario no puede cambiar la contraseña (como antes, tiene dos valores: $true y $false).
#ChangePasswordAtLogon: Si su valor es $true obliga al usuario a cambiar la contraseña cuando vuelva a iniciar sesión.
#PasswordNotRequired: Permite que el usuario no tenga contraseña.
#HomeDrive "H:" : La carpeta personal aparecerá en la unidad de red H:
#HomeDirectory "$linea.DirPersonales\$nameShort": La carpeta personal se hallará en \\NombreServidor\Dir-Personales\Cuenta-Usuario
#ProfilePath $perfilmovil: El perfil del usuario se almacenará en \\NombreServidor\Dir-Perfiles\$nombreCorto
#ScriptPath $linea.ScriptPath: El script de inicio de sesión se halla en \\NombreServidor\Scripts\logon
