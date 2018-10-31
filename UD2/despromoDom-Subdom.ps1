# Importamos el módulo ADDS
if (!(Get-Module -Name ADDSDeployment)) #Se comprueba si se tiene cargado el módulo
{
  Import-Module ADDSDeployment #Se carga el módulo
}

# Despromocionamos el dominio/subdominio
# DemoteOperationMasterRole indica que la degradación debe continuar incluso si se trata del maestro de operaciones del directorio activo.
# ForceRemoval desinstalará AD DS aunque no haya conexión con ningún otro controlador de dominio en la red.
# para evitar que el cmdlet pueda interrumpir su ejecución, el argumento Force hace que no se tenga en cuenta ningún aviso que pueda aparecer durante el proceso.

Uninstall-ADDSDomainController -DemoteOperationMasterRole:$true -ForceRemoval:$true -Force:$true
#Descripción de los parámetros
#Uninstall-ADDSDomainController: desistala un controlador de dominio en el Active Directory.
#DemoteOperationMasterRole:$true: fuerza la despromoción incluso si el maestro de operaciones se halla en el AD DS del que se está degradando.
#ForceRemoval:$true: elimina cualquier conectividad con otro controlador de dominio.
 
#Desinstalar los roles Servicios de dominio de Active Directory y DNS
Uninstall-WindowsFeature -Name AD-Domain-Services, DNS -Confirm:$false

#Referencia: http://technet.microsoft.com/en-us/library/hh974714.aspx
