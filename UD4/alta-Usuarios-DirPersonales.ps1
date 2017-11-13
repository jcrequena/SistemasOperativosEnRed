#alta_Usuarios-DirPersonales.ps1 : Parámetro 1 el dc (nombre netbios del dominio) parámetro 2 la extensión
#Capturamos los 2 parámetros que hemos pasado en la ejecución del script
# Ejemplo: alta_Usuarios-DirPersonales.ps1 smr local 
param($a,$b)
$dc="dc="+$a+",dc="+$b

#Primero comprobaremos si se tiene cargado el módulo Active Directory
if (!(Get-Module -Name ActiveDirectory)) #Accederá al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el módulo
}

#
#Creación de los usuarios
#
$fileUsersCsv=Read-Host "Introduce el fichero csv de los usuarios:"
$fichero = import-csv -Path $fileUsersCsv -Delimiter : 			     
foreach($linea in $fichero)
{
	$rutaContenedor =$linea.RutaContenedor+","+$dc 

	#Guardamos de manera segura la contraseña que en este caso corresponde al DNI-
	$passAccount=ConvertTo-SecureString $linea.DNI -AsPlainText -force
	
	$name=$linea.Nombre
	$nameShort=$linea.Nombre+'.'+$linea.PrimerApellido
	$Surnames=$linea.PrimerApellido+' '+$linea.SegundoApellido
	$nameLarge=$linea.Nombre+' '+$linea.PrimerApellido+' '+$linea.SegundoApellido
	$computerAccount=$linea.Equipo
	$email=$nameShort+"@"+$a+"."+$b
	

	#Si el usaurio ya existe (Nombre + 1er Apellido), ampliamos el nombre corto con el 2 Apellido   
	if (Get-ADUser -filter { name -eq $nameShort })
	{
		$nameShort=$linea.Nombre+'.'+$linea.PrimerApellido+$linea.SegundoApellido
	}
	#El parámetro -Enabled es del tipo booleano por lo que hay que leer la columna del csv
	#que contiene el valor true/false para habilitar/no habilitar el usuario y convertirlo en boolean.
	[boolean]$Habilitado=$true
  If($linea.Habilitado -Match 'false') { $Habilitado=$false}
  
  $ExpirationAccount = $linea.ExpirationAccount
  $timeExp = (get-date).AddDays($ExpirationAccount)
	
	New-ADUser -SamAccountName $nameShort -UserPrincipalName $nameShort -Name $nameShort `
		-Surname $Surnames -DisplayName $nameLarge -GivenName $name -LogonWorkstations:$linea.Equipo `
		-Description "Cuenta de $nameLarge" -EmailAddress $email `
		-AccountPassword $passAccount -Enabled $Habilitado `
		-CannotChangePassword $false -ChangePasswordAtLogon $true `
		-PasswordNotRequired $false -Path $rutaContenedor -AccountExpirationDate $timeExp `
    -HomeDrive "H:" -HomeDirectory $linea.DirPersonales\$nameShort" 
	
	#Asignar cuenta de Usuario a Grupo
	# Distingued Name CN=Nombre-grupo,ou=..,ou=..,dc=..,dc=...
	$cnGrpAccount="Cn="+$linea.grupo+","+$rutaContenedor
	Add-ADGroupMember -Identity $cnGrpAccount -Members $nameShort
	
	## Establecer horario de inicio de sesión de 8am - 6pm Lunes (Monday) to Viernes (Friday)      
	[byte[]]$hoursSession = @(0,0,0,0,255,3,0,255,3,0,255,3,0,255,3,0,255,3,0,0,0)                                       
	Get-ADUser -Identity $nameShort | Set-ADUser -Replace @{logonhours = $hoursSession} 
}



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
HomeDrive "H:" : La carpeta personal aparecerá en la unidad de red H:
HomeDirectory "$linea.DirPersonales\$nameShort": La carpeta personal se hallará en \\NombreServidor\DirPersonales\Cuenta-Usuario
