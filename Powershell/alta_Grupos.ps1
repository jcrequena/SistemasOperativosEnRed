#alta_Grupos.ps1 : Parámetro 1 el dc (nombre netbios del dominio) parámetro 2 el sufijo del dominio
#Referencia: https://technet.microsoft.com/en-us/library/ee617258.aspx
param($a,$b)
#DC=smr,DC=local
$dc="dc="+$a+",dc="+$b

#
#Creación de los grupos a partir de un fichero csv
#
$gruposCsv=Read-Host "Introduce el fichero csv de Grupos:"
#Lee el fichero grupos.csv
$fichero = import-csv -Path $gruposCsv -delimiter :
foreach($linea in $fichero)
{
	$rutaObject=$linea.Ruta+","+$dc
	New-ADGroup -Name:$linea.Nombre -Description:$linea.Descripcion `
	-GroupCategory:$linea.Categoria `
	-GroupScope:$linea.Ambito  `
	-Path:$rutaObject	
}
