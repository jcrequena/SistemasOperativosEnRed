#Domino smr.local
$dc="dc=smr,dc=local"
$domain="smr.local"

#Solicitamos al usuario que ejecuta el script que indique el nombre del fichero csv
$fileUsersCsv=Read-Host "Introduce el fichero csv de los usuarios:"
$fichero = import-csv -Path $fileUsersCsv -Delimiter :
#Creación de varibles a partir de los datos leídos del fichero csv
foreach($linea in $fichero)
{
  $rutaContenedor =$linea.ContainerPath+","+$dc 
  $passAccount=ConvertTo-SecureString $linea.NIF -AsPlainText -force

  [boolean]$Habilitado=$true
  If($linea.Hability -Match 'false') { $Habilitado=$false}
  
  $name=$linea.Name
  $nameShort=$linea.Name+'.'+$linea.SurName
  $Surnames=$linea.Surname+' '+$linea.Surname2
  #Se construye el nombre y apellidos del usuario
  $nameLarge=$linea.Name+' '+$Surnames
  
  #cmdlet para crear el directori personal
 New-ADUser -SamAccountName $nameShort -UserPrincipalName $nameShort ­-Name $nameShort ­`
  -Surname $Surnames -DisplayName $nameLarge -GivenName $name `
  -Description "Cuenta de $nameLarge" -EmailAddress "$nameShort@$domain" `
  -AccountPassword $passAccount -Enabled $Habilitado -CannotChangePassword $false `
  -ChangePasswordAtLogon $true -PasswordNotRequired $false `
  -ScriptPath $linea.ScriptPath `
  -Path $rutaContenedor
}
