#alta_Usuarios.ps1 : Parámetro 1 el dc (nombre netbios del dominio) parámetro 2 la extensión y parámetro 3 la ruta del fichero csv
#
#Creación de los usuarios
#
param($a,$b,$c)
#DC=smr,DC=local
$dc="dc="+$a+",dc="+$b
$usuariosCsv=$c
#
#Los campos del fichero csv están separados por el carácter ,
#
$fichero = import-csv -Path $usuariosCsv
$Class = "User"
foreach($linea in $fichero)
{
	$ou = "ou="+$linea.Cargo
	$nombre = $linea.Nombre+"."+$linea.PrimerApellido

	$ADSI = [ADSI]"LDAP://$ou,$dc"
	$cnuser = "cn="+$nombre
	$User = $ADSI.create($Class,$cnuser)

	$User.put("UserPrincipalName", $nombre)
	$User.put("SamAccountName", $nombre)
	$User.put("givenName", $($linea.Nombre))
	$User.put("sn", $($linea.PrimerApellido+" "+$linea.SegundoApellido))
	$User.put("displayName", $($linea.Nombre+" "+$linea.PrimerApellido+" "+$linea.SegundoApellido))
	$User.put("mail", $($nombre+"@"+$a+"."+$b))
	$User.setInfo()
	#
	#Lo último que hacemos es: Establecer el Password y si el user está habilitado o no.
	#
	$User.SetPassword($($linea.DNI))
	$User.psbase.invokeset("AccountDisabled", "False")
	$User.setInfo()
        
	#Membresía de grupo: Con esta parte de código, establecemos los grupos de los cuales será
	#miembro el usuario creado
	$cngrupo="cn="+$linea.Nivel   #Nombre del grupo
	$uo_users="cn=users"    #Ruta donde está ubicado el grupo, en este caso, está ubicado en el contenedor Users
	$grupoActual = [ADSI]"LDAP://$cngrupo,$uo_users,$dc" #ADSI: LDAP://Nombre_grupo,ruta_del_grupo,controlador_dominio
	$grupoActual.Add("LDAP://$cnuser,$ou,$dc") # Añadimos al grupo (membresía) el usuario creado haciendo uso del protocolo LDAP
	$grupoActual.SetInfo() #Guardamos en la BD la información

}
