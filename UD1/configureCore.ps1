#Para consultar la información de nuestra interfaz de red
Get-NetIPConfiguration
#Para obtener el adaptador de red
Get-NetAdapter
#Para configurar la direccion IP (suponiendo que nuestro adaptador de red es el 2)
New-NetIPAddress -InterfaceIndex 2 -IPAddress 192.168.1.20 -PrefixLength 24 -DefaultGateway 192.168.1.1
