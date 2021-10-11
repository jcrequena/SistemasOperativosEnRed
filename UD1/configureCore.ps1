#CmdLets RED

#Para consultar la información de nuestra interfaz de red
Get-NetIPConfiguration
#Para obtener el adaptador de red
Get-NetAdapter

#Para configurar la direccion IP (suponiendo que nuestro adaptador de red es el 2)
New-NetIPAddress -InterfaceIndex 2 -IPAddress 192.168.1.20 -PrefixLength 24 -DefaultGateway 192.168.1.1
#Para configurar el DNS (suponiendo que nuestro adaptador de red es el 2)
Set-DnsClientServerAddress -InterfaceIndex 2 -ServerAddresses 192.168.1.1

#NOTA:Si se tiene sólo 1 interfaz de red el comando se puede simplificar
New-NetIPAddress –IPAddress 192.168.1.20 -DefaultGateway 192.168.1.1 -PrefixLength 24 -InterfaceIndex (Get-NetAdapter).InterfaceIndex
Set-DNSClientServerAddress –InterfaceIndex (Get-NetAdapter).InterfaceIndex –ServerAddresses 192.168.1.20

#Cambiar el nombre del equipo (el nuevo nombre será orion)
Rename-Computer -NewName orion
