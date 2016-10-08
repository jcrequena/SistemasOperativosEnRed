#alta_Equipos.ps1 : Parámetro 1 el dc (nombre netbios del dominio) parámetro 2 la extensión y parámetro 3 la ruta del fichero csv

param($a,$b,$c)
#DC=smr,DC=local
$dc="dc="+$a+",dc="+$b
$equiposCsv=$c
#
#Creación de los grupos a partir de un fichero csv
#
#Lee el fichero grupos.csv
$fichero= import-csv -Path $equiposCsv
$Class = "Computer"
$ADSI = [ADSI]"LDAP://cn=computers,$dc"
foreach($linea in $fichero)
{
    $Name = "CN="+$linea.Equipo
    $Computer = $ADSI.create($Class, $Name)
    $Computer.setInfo()
}
