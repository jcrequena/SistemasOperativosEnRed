#alta_UnidadesOrg.ps1 : Parámetro 1 el dc (nombre netbios del dominio) parámetro 2 el sufijo y parámetro 3 la ruta del fichero csv
#
#Creación de las unidades organizativas
#
param($a,$b,$c)
#DC=smr,DC=local
$dc="dc="+$a+",dc="+$b
$ficheroCsvUO=$c

$fichero = import-csv -Path $ficheroCsvUO -delimiter :
foreach($linea in $fichero)
{
	New-ADOrganizationalUnit -Description:$linea.Descripcion -Name:$linea.Nombre -Path:$dc -ProtectedFromAccidentalDeletion:$true	
}
