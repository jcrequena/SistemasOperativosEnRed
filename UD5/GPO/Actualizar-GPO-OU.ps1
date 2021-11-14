#Actualizar GPOs en todos los equipos de una OU
Get-ADComputer –filter * -Searchbase "OU=Equipos,DC=smr,DC=local" | foreach{ Invoke-GPUpdate –computer $_.name -force -RandomDelayInMinutes 0}
