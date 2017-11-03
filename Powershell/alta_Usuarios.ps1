#alta_Usuarios.ps1 : Parámetro 1 el dc (nombre netbios del dominio) parámetro 2 la extensión y parámetro 3 la ruta del fichero csv
#Capturamos los 2 parámetros que hemos pasado en la ejecución del script
# Ejemplo: alta_Usuarios.ps1 smr local 
param($a,$b)

#Primero comprobaremos si se tiene cargado el módulo Active Directory
if (!(Get-Module -Name ActiveDirectory)) #Accederá al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el módulo
}
#
#Creación de los usuarios
#
#DC=smr,DC=local
$dc="dc="+$a+",dc="+$b
$fileUsersCsv=Read-Host "Introduce el fichero csv de los usuarios:"
#
#Los campos del fichero csv están separados por el carácter ,
#
$fichero = import-csv -Path $fileUsersCsv -Delimiter : 
						     
foreach($linea in $fichero)
{
	$rutaContenedor =$linea.RutaContenedor+","+$dc #Ruta donde se creará el usuario

	#Guardamos de manera segura la contraseña que en este caso corresponde al DNI-
	$passAccount=ConvertTo-SecureString $linea.DNI -AsPlainText -force
	
	$name=$linea.Nombre
	$nameShort=$linea.Nombre+'.'+$linea.PrimerApellido
	$Surnames=$linea.PrimerApellido+' '+$linea.SegundoApellido
	$nameLarge=$linea.Nombre+' '+$linea.PrimerApellido+' '+$linea.SegundoApellido
	$email=$nameShort+"@"+$a+"."+$b

	#Si el usaurio ya existe (Nombre + 1er Apellido), ampliamos el nombre corto con el 2 Apellido   
	if ( !!(Get-ADUser -filter { name -eq $nameShort }) )
	{
		$nameShort=$nombre+'.'+$linea.PrimerApellido+$linea.SegundoApellido
	}
	#El parámetro -Enabled es del tipo booleano por lo que hay que leer la columna del csv
	#que contiene el valor tru/false para habilitar/no habilitar el usuario y convertirlo en boolean.
	[boolean]$Habilitado=$true
    	If($linea.Habilitado -Match 'false') { $Habilitado=$false}
	
	New-ADUser -SamAccountName $nameShort -UserPrincipalName $nameShort `
		-Name $nameShort -Surname $Surnames -DisplayName $nameLarge ` 
		-GivenName $name -LogonWorkstations:$linea.Equipo `
		-Description "Cuenta de $nameLarge" -EmailAddress "$email" `
		-AccountPassword $passAccount -Enabled $linea.Habilitado `
		-CannotChangePassword $false -ChangePasswordAtLogon $true `
		-PasswordNotRequired $false -Path $rutaContenedor
	
	#Asignar cuenta de Usuario a Grupo
	# Distingued Name CN=Nombre-grupo,ou=..,ou=..,dc=..,dc=...
	$cnGrpAccount="Cn="+$linea.Grupo+","+$rutaContenedor
	Add-ADGroupMember -Identity $cnGrpAccount -Members $nameShort
	
	## Establecer horario de inicio de sesión de 8am - 6pm Lunes (Monday) to Viernes (Friday)      
	[byte[]]$hoursSession = @(0,0,0,0,255,3,0,255,3,0,255,3,0,255,3,0,255,3,0,0,0)                                       
	Get-ADUser -Identity $nameShort | Set-ADUser -Replace @{logonhours = $hoursSession} 
}

#Ejemplos de establecer vector de inicios de sesión
# Deny all logon
# [byte[]]$hours = @(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

# Allow logon at all hours
# [byte[]]$hours = @(255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255)

# A continuación, las propiedades de New-ADUser que se han utilizado son:
SamAccountName: nombre de la cuenta SAM para compatibilidad con equipos anteriores a Windows 2000.
UserPrincipalName: Nombre opcional que puede ser más corto y fácil de recordar que el DN (Distinguished Name) y que puede ser utilizado por el sistema.
Name: Nombre de la cuenta de usuario.
Surname: Apellidos del usuario.
DisplayName: Nombre del usuario que se mostrará cuando inicie sesión en un equipo.
GivenName: Nombre de pila.
Description: Descripción de la cuenta de usuario.
EmailAddress: Dirección de correo electrónico.
AccountPassword: Contraseña encriptada.
Enabled: Cuenta habilitada ($true) o deshabilitada ($false).
CannotChangePassword: El usuario no puede cambiar la contraseña (como antes, tiene dos valores: $true y $false).
ChangePasswordAtLogon: Si su valor es $true obliga al usuario a cambiar la contraseña cuando vuelva a iniciar sesión.
PasswordNotRequired: Permite que el usuario no tenga contraseña.
