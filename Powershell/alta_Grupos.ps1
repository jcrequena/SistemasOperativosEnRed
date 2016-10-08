#
#Creación de los grupos a partir de un fichero csv
#
$fichero= import-csv -Path grupos.csv
$Class = "Group"
$ADSI = [ADSI]"LDAP://cn=users,$dc"
foreach($linea in $fichero)
{
    $Name = "CN="+$linea.Grupo
    $Group = $ADSI.create($Class, $Name)
    $Group.setInfo()
}
