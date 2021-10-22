

#Capturamos los 2 parámetros que hemos pasado en la ejecución del script
# Ejemplo: user-a-grupo.ps1 smr local 
param($a,$b)
$dominio=$a
$sufijo=$b
$dc="dc="+$dominio+",dc="+$sufijo


#Primero comprobaremos si se tiene cargado el módulo Active Directory
if (!(Get-Module -Name ActiveDirectory)) #Accederá al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el mÃ³dulo
}
#
#Añadir usuarios a grupos
#
$fileUsersCsv=Read-Host "Introduce el fichero csv de los usuarios:"
$fichero = import-csv -Path $fileUsersCsv -Delimiter :
		     
foreach($linea in $fichero)
{
	Add-ADGroupMember -Identity $linea.Name -Members $linea.User
}

#El fichero csv será de esta forma
#Name:User
#grupo1:user1
#grupo2:user2
