#Antes de quitar un Controlador de Dominio de forma "correcta", es necesario que cheques los siguientes puntos:
#Estado de Salud del Servidor: Estado de salud (event viewer) del sistema operativo del servidor.
#Estado del salud Controlador de Dominio: es necesario que ejecutes un DCDIAG /v sobre el Controlador de Dominio a eliminar.
#Conectividad con el 2do Controlador de Dominio (réplica): verificar la conectividad con el controlador de dominio restante.
#Estado de Replicación: es necesario chequear la replicación entre los DC con los comandos repadmin.
#Teniendo todos estos puntos OK, podras proceder a eliminar el DC. 

#Hay que elimnar el ROL AD DS y DNS
#Luego, disminuir nivel (degradación)
#Powershell

uninstall-ADDSDomainController 



#Referencia: https://blog.ragasys.es/eliminar-controlador-de-dominio-adicional-sobre-ms-windows-server-2016
