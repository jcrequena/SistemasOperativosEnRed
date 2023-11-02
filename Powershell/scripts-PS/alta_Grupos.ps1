#alta_Grupos.ps1 : Parámetro 1 el dc (nombre netbios del dominio) parámetro 2 el sufijo del dominio
#Referencia: https://technet.microsoft.com/en-us/library/ee617258.aspx
#El fichero csv que leemos es:
#Name:Path:Description:Category:Scope
#SMR-GG-DepInformatica:OU=Dep-Informatica:Grupo global y de seguridad del Dep.Informatica:Security:Global
#SMR-GG-DepLogistica:OU=Dep-Logistica:Grupo global y de seguridad del Dep.Logistica:Security:Global

#Ponemos el Domain Component para el dominio en cuestión, que para este caso es smr.local
$domain="dc=smr,dc=local"

#
#Creación de los grupos a partir de un fichero csv
#
$gruposCsv=Read-Host "Introduce el fichero csv de Grupos:"
#Lee el fichero grupos.csv
$fichero = import-csv -Path $gruposCsv -delimiter :
foreach($linea in $fichero)
{
	$pathObject=$linea.Path
	#Comprobamos si no existe el grupo antes de crearlo.
	if ( !(Get-ADGroup -Filter { name -eq $linea.Name }) )
	{
		New-ADGroup -Name:$linea.Name -Description:$linea.Description `
		-GroupCategory:$linea.Category `
		-GroupScope:$linea.Scope  `
		-Path:$pathObject
	}
	else { Write-Host "El grupo $line.Name ya existe en el sistema"}
}
write-Host ""
write-Host "Se han creado los grupos en el dominio $domain" -Fore green
write-Host "" 
