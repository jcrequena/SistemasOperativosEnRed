#alta_Grupos.ps1 : Parámetro 1 el dc (nombre netbios del dominio) parámetro 2 el sufijo del dominio y parámetro 3 la ruta del fichero csv

param($a,$b,$c)
#DC=smr,DC=local
$dc="dc="+$a+",dc="+$b
$gruposCsv=$c
#
#Creación de los grupos a partir de un fichero csv
#
#Lee el fichero grupos.csv
$fichero = import-csv -Path $ficheroCsvUO -delimiter :
foreach($linea in $fichero)
{
	$rutaObject=$linea.Path+","+$dc
	New-ADGroup -Description:$linea.Descripcion -GroupCategory:"Security" -GroupScope:"Global" -Name:$linea.Nombre -Path:$rutaObject -SamAccountName:$linea.Nombre		
}
