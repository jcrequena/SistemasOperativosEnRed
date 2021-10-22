# Referencia:
#  https://technet.microsoft.com/es-es/library/ee617238.aspx
# Establcemos un a política de contraseñas para los usuarios de una UO (Dep-Informatica)
# MaxPasswordAge: Cambio de contraseña a los 15 días
# MinPasswordLength: Longitud mínima de la contraseña 7 días
# PasswordHistoryCount: Especifica la cantidad de contraseñas anteriores para guardar. 
# Precedence: Este valor determina qué política de contraseña usar cuando se aplica más de una política 
#             de contraseña a un usuario o grupo. Cuando hay un conflicto, la política de contraseñas que 
#             tiene el valor de propiedad Precedencia inferior tiene una prioridad más alta. 
#             Por ejemplo, si PasswordPolicy1 tiene un valor de propiedad de Precedence de 200 y 
#             PasswordPolicy2 tiene un valor de propiedad de Precedence de 100, se usa PasswordPolicy2.

# Creamos las política de contraseñas (el nombre del servidor es orion)
#
New-ADFineGrainedPasswordPolicy `
      -ComplexityEnabled:$true `
      -LockoutDuration:"00:30:00" `
      -LockoutObservationWindow:"00:30:00" `
      -LockoutThreshold:"0" `
      -MaxPasswordAge:"15.00:00:00" `
      -MinPasswordAge:"1.00:00:00" `
      -MinPasswordLength:"7" `
      -Name:"UsersDepInf-15" `
      -PasswordHistoryCount:"24" `
      -Precedence:"1" `
      -ReversibleEncryptionEnabled:$false `
      -Server:"orion.smr.local"

# Creamos el objeto (el nombre del servidor es orion)
Set-ADObject -Identity:"CN=UsersDepInf-15,CN=Password Settings Container,CN=System,DC=smr,DC=local"  `
              -ProtectedFromAccidentalDeletion:$true -Server:"orion.smr.local"

# Asociamos la política al grupo (el nombre del servidor es orion)
Add-ADFineGrainedPasswordPolicySubject -Identity:"CN=UsersDepInf-15,CN=Password Settings Container,CN=System,DC=smr,DC=local" `
        -Server:"orion.smr.local" `
        -Subjects:"CN=SMR-GG-DepInf-15,OU=Dep-Informatica,DC=smr,DC=local"
