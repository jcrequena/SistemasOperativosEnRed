#alta_UnidadesOrg.ps1 : Parámetro 1 el dc (nombre netbios del dominio) parámetro 2 el sufijo
#
#Creación de las unidades organizativas
#
param($a,$b)
#DC=smr,DC=local
$dc="dc="+$a+",dc="+$b

$ficheroCsvUO=Read-Host "Introduce el fichero csv de UO's:"
$fichero = import-csv -Path $ficheroCsvUO -delimiter :
foreach($linea in $fichero)
{
	$rutaObjeto=$dc
	If !($linea.Ruta -noMatch '') { $rutaObjetoUO=$linea.Ruta+","+$dc}

	New-ADOrganizationalUnit -Description:$linea.Descripcion -Name:$linea.Nombre `
	-Path:$dc -ProtectedFromAccidentalDeletion:$true	
}
