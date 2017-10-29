# alta_Equipos.ps1 : Parámetro 1 el dc (nombre netbios del dominio) parámetro 2 el sufijo del dominio 

param($a,$b)
#DC=smr,DC=local
$dc="dc="+$a+",dc="+$b

#
#Creación de los grupos a partir de un fichero csv
#
#Lee el fichero grupos.csv. El carácter delimitador de columna es :
$equiposCsv=Read-Host "Introduce el fichero csv de Equipos:"
$fichero= import-csv -Path $equiposCsv -delimiter ":"

foreach($linea in $fichero)
{
	$pathObject=$linea.Ruta+","+$dc	 
	New-ADComputer -Enabled:$true -Name:$linea.Equipo -Path:$pathObject -SamAccountName:$linea.Equipo
}

write-Host ""
write-Host "Se han creado los equipos" -Fore green
write-Host "" 
