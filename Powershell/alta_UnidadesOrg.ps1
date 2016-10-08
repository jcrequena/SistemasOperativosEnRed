#alta_UnidadesOrg.ps1 : Parámetro 1 el dc (nombre netbios del dominio) parámetro 2 la extensión y parámetro 3 la ruta del fichero csv
#
#Creación de las unidades organizativas
#
param($a,$b,$c)
#DC=smr,DC=local
$dc="dc="+$a+",dc="+$b
$uoCsv=$c

$fichero = import-csv -Path $uoCsv
$ADSI = [ADSI]"LDAP://$dc"
$Class = "OrganizationalUnit"
foreach($linea in $fichero)
{
	$ou = "ou="+$linea.Unidad
	$OrganizationalUnit = $ADSI.create($Class, $ou)
	$OrganizationalUnit.setInfo()
	$OrganizationalUnit.put("Description", $($linea.Descripcion))
	$OrganizationalUnit.setInfo()
}
