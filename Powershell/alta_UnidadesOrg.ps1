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
	#Si el campo Ruta no está vacío, componemos la ruta con el valor del campo más el dn del dominio.
	if !($linea.Ruta -noMatch '') { $rutaObjetoUO=$linea.Ruta+","+$dc}
	#Comprobamos que la OU no exista ya en el sistema
	if ( !(Get-ADOrganizationalUnit -Filter { name -eq $UO }) )
	{
        	New-ADOrganizationalUnit -Description:$linea.Descripcion -Name:$linea.Nombre `
		-Path:$dc -ProtectedFromAccidentalDeletion:$true
        }	
}
