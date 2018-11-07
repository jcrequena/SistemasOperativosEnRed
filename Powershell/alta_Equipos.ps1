# alta_Equipos.ps1 : Parámetro 1 el dc (nombre netbios del dominio) parámetro 2 el sufijo del dominio 
#Referencia: https://technet.microsoft.com/es-es/library/hh852258(v=wps.630).aspx

param($dominio,$sufijoDominio)

#Componemos el Domain Component para el dominio que se pasa por parámetro
# en este caso, el dominio es smr.local
#Por lo que hay que componer dc=smr,dc=local
$domainComponent="dc="+$dominio+",dc="+$sufijoDominio

#
#Creación de los grupos a partir de un fichero csv
#
#Lee el fichero grupos.csv. El carácter delimitador de columna es :
$equiposCsv=Read-Host "Introduce el fichero csv de Equipos:"
$fichero= import-csv -Path $equiposCsv -delimiter ":"

foreach($line in $fichero)
{
	$pathObject=$line.Path+","+$domainComponent	
	#Comprobamos que no exista el equipo en el sistema
	if ( !(Get-ADComputer -Filter { name -eq $line.Computer }) )
	{
		New-ADComputer -Enabled:$true -Name:$line.Computer -Path:$pathObject -SamAccountName:$line.Computer
	}
	else { Write-Host "El equipo $line.Computer ya existe en el sistema"}
}

write-Host ""
write-Host "Se han creado los equipos" -Fore green
write-Host "" 
