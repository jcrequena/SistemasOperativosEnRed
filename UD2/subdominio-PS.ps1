#El comando para crear un dominio secundario (subdominio (child domain)) 
# o un dominio de árbol (tree domanin) es casi el mismo. 
#Como recordatorio: Para instalar ADDS para poder promocionar un dominio, el comando es:

Install-WindowsFeature –Name AD-Domain-Services –IncludeManagementTools
# Dominio secundario (child domain): 
# nos solicitará la contraseña del administrador del dominio raíz y la del DSRM, después se reiniciará el servidor.
# DSRM: Elimina un objeto de un tipo específico o cualquier objeto general del directorio.
# DSRM: https://technet.microsoft.com/es-es/library/cc731865(v=ws.10).aspx
Install-ADDSDomain 
–Credential (Get-Credential smr\administrador) 
–NewDomainName sor 
–ParentDomainName smr.local 
–DomainType Childomain –InstallDNS

# Dominio de árbol (Tree domain): 
# nos solicitará introducir la contraseña del administrador del dominio raíz y la del DSRM, después se reiniciará el servidor.
Install-ADDSDomain 
  –Credential (Get-Credential smr\administrador) 
    –NewDomainName dominio-arbol.local –ParentDomainName smr.local –DomainType TreeDomain –InstallDNS
