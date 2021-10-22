#Listar los usuarios del dominio smr.local
 Get-ADUser -filter * -SearchBase "dc=smr,dc=local" | Select sAMAccountName
 
 
