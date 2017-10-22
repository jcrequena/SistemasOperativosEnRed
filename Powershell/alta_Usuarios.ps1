#alta_Usuarios.ps1 : Parámetro 1 el dc (nombre netbios del dominio) parámetro 2 la extensión y parámetro 3 la ruta del fichero csv

#Primero comprobaremos si se tiene cargado el módulo Active Directory
if (!(Get-Module -Name ActiveDirectory)) #Accederá al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el módulo
}
#
#Creación de los usuarios
#

param($a,$b,$c)
#DC=smr,DC=local
$dc="dc="+$a+",dc="+$b
$usuariosCsv=$c
#
#Los campos del fichero csv están separados por el carácter ,
#
$fichero = import-csv -Path $usuariosCsv -Delimiter : 
						     
foreach($linea in $fichero)
{
	$rutaContenedor =$linea.RutaContenedor+","+$dc #Ruta donde se creará el usuario

	#Guardamos de manera segura la contraseña que en este caso corresponde al DNI-
	$passAccount=ConvertTo-SecureString $linea.DNI -AsPlainText -force
	
	$name=$linea.Nombre
	$nameShort=$linea.Nombre+'.'+$linea.PrimerApellido
	$Surnames=$linea.PrimerApellido+' '+$linea.SegundoApellido
	$nameLarge=$linea.Nombre+' '+$linea.PrimerApellido+' '+$linea.SegundoApellido
	$grpAccount=$linea.Grupo
	$computerAccount=$linea.Equipo
	$email=$nameShort+"@"+$a+"."+$b

	#Si el usaurio ya existe (Nombre + 1er Apellido), ampliamos el nombre corto con el 2 Apellido   
	if ( !!(Get-ADUser -filter { name -eq $nameShort }) )
	{
		$nameShort=$nombre+'.'+$linea.PrimerApellido+$linea.SegundoApellido
	}
	New-ADUser -SamAccountName $nameShort -UserPrincipalName $nameShort -Name $nameShort -Surname $Surnames -DisplayName $nameLarge -GivenName $name -Description "Cuenta de $nombreLargo" -EmailAddress "$email" -AccountPassword $passAccount -Enabled $true -CannotChangePassword $false -ChangePasswordAtLogon $true -PasswordNotRequired $false -Path $rutaContenedor
	#Asignar cuenta de Usuario a Grupo
	Add-ADGroupMember -Identity $grpAccount -Members $nameShort
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
