# Referencia:
#  https://technet.microsoft.com/es-es/library/ee617238.aspx
# Establcemos un a política de contraseñas para los usuarios de una UO (Dep-Informatica)
# MaxPasswordAge: Cambio de contraseña a los 15 días
# MinPasswordLength: Longitud mínima de la contraseña 7 días
# PasswordHistoryCount: Especifica la cantidad de contraseñas anteriores para guardar. 


New-ADFineGrainedPasswordPolicy -ComplexityEnabled:$true `
  -LockoutDuration:"00:30:00" -LockoutObservationWindow:"00:30:00" `
  -LockoutThreshold:"0" -MaxPasswordAge:"15.00:00:00" -MinPasswordAge:"1.00:00:00" `
  -MinPasswordLength:"7" -Name:"Users-DepInformatica" `
  -PasswordHistoryCount:"24" `
  -Precedence:"10" -ReversibleEncryptionEnabled:$false `
  -Server:"srv-2012R2D-FSMO.smr.local"
  
  Set-ADObject -Identity:"CN=Users-DepInformatica,CN=Password Settings Container,CN=System,DC=smr,DC=local" `
    -ProtectedFromAccidentalDeletion:$true -Server:"srv-2012R2D-FSMO.smr.local"
