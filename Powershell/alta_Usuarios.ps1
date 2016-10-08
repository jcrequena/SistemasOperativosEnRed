#
#Creación de los usuarios
#

param($a,$b)

$dc="dc="+$a+",dc="+$b

$fichero = import-csv -Path usuarios.csv
$Class = "User"

foreach($linea in $fichero)
{
	$ou = "ou="+$linea.Cargo
	$nombre = $linea.Nombre+"."+$linea.PrimerApellido

	$ADSI = [ADSI]"LDAP://$ou,$dc"
	$cnuser = "cn="+$nombre
	$User = $ADSI.create($Class,$cnuser)

	$User.put("UserPrincipalName", $nombre)
	$User.setInfo()

	$User.put("SamAccountName", $nombre)
	$User.setInfo()

	$User.put("givenName", $($linea.Nombre))
	$User.setInfo()

	$User.put("sn", $($linea.PrimerApellido+" "+$linea.SegundoApellido))
	$User.setInfo()
  
	$User.put("displayName", $($linea.Nombre+" "+$linea.PrimerApellido+" "+$linea.SegundoApellido))
	$User.setInfo()
  
	$User.put("mail", $($nombre+"@"+$a+"."+$b))
	$User.setInfo()

	$User.SetPassword($($linea.DNI))
	$User.psbase.invokeset("AccountDisabled", "False")
	$User.setInfo()

	$cngrupo="cn="+$linea.Nivel
	$uo_users="cn=users"
	$grupoActual = [ADSI]"LDAP://$cngrupo,$uo_users,$dc"
	$grupoActual.Add("LDAP://$cnuser,$ou,$dc")
	$grupoActual.SetInfo()

}
