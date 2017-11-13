#alta_Usuarios-DirPersonales.ps1 : Parámetro 1 el dc (nombre netbios del dominio) parámetro 2 la extensión
#Capturamos los 2 parámetros que hemos pasado en la ejecución del script
# Ejemplo: alta_Usuarios-DirPersonales.ps1 smr local 
param($a,$b)
$dominio=$a
$sufijo=$b
$dc="dc="+$dominio+",dc="+$sufijo

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
	$rutaContenedor =$linea.ContainerPath+","+$dc 
	#Guardamos de manera segura la contraseña que en este caso corresponde al DNI-
	$passAccount=ConvertTo-SecureString $linea.NIF -AsPlainText -force
	
	$name=$linea.Name
	$nameShort=$linea.Name+'.'+$linea.Surname
	$Surnames=$linea.Surname+' '+$linea.Surname2
	$nameLarge=$linea.Name+' '+$linea.Surname+' '+$linea.Surname2
	$computerAccount=$linea.Computer
	$email=$nameShort+"@"+$a+"."+$b
	$perfilmovil=$linea.PerfilMovil+"\"+$nameShort
  
  
	#Si el usaurio ya existe (Nombre + 1er Apellido), ampliamos el nombre corto con el 2 Apellido   
	if (Get-ADUser -filter { name -eq $nameShort })
	{
		$nameShort=$linea.Name+'.'+$linea.Surname+$linea.Surname2
	}
	#El parámetro -Enabled es del tipo booleano por lo que hay que leer la columna del csv
	#que contiene el valor true/false para habilitar/no habilitar el usuario y convertirlo en boolean.
	[boolean]$Habilitado=$true
  	If($linea.Hability -Match 'false') { $Habilitado=$false}
  
  	$ExpirationAccount = $linea.DaysAccountExpire
 	$timeExp = (get-date).AddDays($ExpirationAccount)
	
	New-ADUser -SamAccountName $nameShort -UserPrincipalName $nameShort -Name $nameShort `
		-Surname $Surnames -DisplayName $nameLarge -GivenName $name -LogonWorkstations:$linea.Computer `
		-Description "Cuenta de $nameLarge" -EmailAddress $email `
		-AccountPassword $passAccount -Enabled $Habilitado `
		-CannotChangePassword $false -ChangePasswordAtLogon $true `
		-PasswordNotRequired $false -Path $rutaContenedor -AccountExpirationDate $timeExp
		-HomeDrive "$linea.HomeDrive:" -HomeDirectory "$linea.DirPersonales\$nameShort" `
    		-ProfilePath $perfilmovil `
    		-ScriptPath $linea.ScriptPath
    
	#Asignar cuenta de Usuario a Grupo
	# Distingued Name CN=Nombre-grupo,ou=..,ou=..,dc=..,dc=...
	$cnGrpAccount="Cn="+$linea.Group+","+$rutaContenedor
	Add-ADGroupMember -Identity $cnGrpAccount -Members $nameShort
	
	## Establecer horario de inicio de sesión de 8am - 6pm Lunes (Monday) to Viernes (Friday)      
	[byte[]]$hoursSession = @(0,0,0,0,255,3,0,255,3,0,255,3,0,255,3,0,255,3,0,0,0)                                       
	Get-ADUser -Identity $nameShort | Set-ADUser -Replace @{logonhours = $hoursSession} 
	#
	#Creamos el directorio personal de cada usuario con los permisos adecuados. Control Total para el usuario
	#
	$pathDirPersonales="$linea.HomeDrive:"+"$linea.DirPersonales\$nameShort"
	New-Item -Path $pathDirPersonales -ItemType Directory
	$nueva_ACL = new-object System.Security.AccessControl.FileSystemAccessRule("$dominio\$nombreCorto","FullControl","Allow")
	$acl.AddAccessRule($nueva_ACL)
	set-acl $pathDirPersonales $acl_actual
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
HomeDirectory "$linea.DirPersonales\$nameShort": La carpeta personal se hallará en \\NombreServidor\Dir-Personales\Cuenta-Usuario
ProfilePath $perfilmovil: El perfil del usuario se almacenará en \\NombreServidor\Dir-Perfiles\$nombreCorto
ScriptPath $linea.ScriptPath: El script de inicio de sesión se halla en \\NombreServidor\Scripts\logon
