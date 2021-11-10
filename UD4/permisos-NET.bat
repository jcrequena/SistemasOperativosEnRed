@echo off
REM Comprobamos si existen las carpetas, en caso contrario las creamos
if NOT EXIST C:\Documentación mkdir C:\Documentación
if NOT EXIST C:\Documentación\Dirección mkdir C:\Documentación\Dirección
if NOT EXIST C:\Documentación\Finanzas mkdir C:\Documentación\Finanzas
if NOT EXIST C:\Documentación\Servicios mkdir C:\Documentación\Servicios
if NOT EXIST C:\Documentación\Producción mkdir C:\Documentación\Producción
if NOT EXIST C:\Documentación\Ventas mkdir C:\Documentación\Producción
REM Compartimos en red con 'Todos' las carpetas, con los permisos NTFS filtraremos los accesos
net share Documentos_Dirección=C:\Documentación\Dirección /GRANT:Todos,full
net share Documentos_Finanzas=C:\Documentación\Finanzas /GRANT:Todos,full
net share Documentos_Producción=C:\Documentación\Producción /GRANT:Todos,full
net share Documentos_Servicios=C:\Documentación\Servicios /GRANT:Todos,full
net share Documentos_Ventas=C:\Documentación\Ventas /GRANT:Todos,full
REM 
REM Aplicamos las ACLs
REM https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/icacls

icacls C:\Documentación\Dirección /GRANT smr\Dirección:(R,W)
icacls C:\Documentación\Finanzas /GRANT smr\Finanzas:(R,W)
icacls C:\Documentación\Producción /GRANT smr\Producción:(R,W)
icacls C:\Documentación\Servicios /GRANT smr\Servicios:(R,W)
icacls C:\Documentación\Ventas /GRANT smr\Ventas:(R,W)
REM Eliminamos los permisos asignados al grupo 'Usuarios del dominio'
REM /inheritancelevel: [e - d - r]
REM     e: Enables inheritance - d: Disables inheritance and copies the ACESS - r: Removes all inherited ACESS

icacls C:\Documentación\Dirección /inheritance:d /T
icacls C:\Documentación\Dirección /remove:g Usuarios
icacls C:\Documentación\Finanzas /inheritance:d /T
icacls C:\Documentación\Finanzas /remove:g Usuarios
icacls C:\Documentación\Producción /inheritance:d /T
icacls C:\Documentación\Producción /remove:g Usuarios
icacls C:\Documentación\Servicios /inheritance:d /T
icacls C:\Documentación\Servicios /remove:g Usuarios
icacls C:\Documentación\Ventas /inheritance:d /T
icacls C:\Documentación\Ventas /remove:g Usuarios
REM Añadimos el permiso extra del grupo Acceso_extra
icacls C:\Documentación\Dirección /GRANT smr\Acceso_extra:(R)
icacls C:\Documentación\Finanzas /GRANT smr\Acceso_extra:(R)
icacls C:\Documentación\Producción /GRANT smr\Acceso_extra:(R)
icacls C:\Documentación\Servicios /GRANT smr\Acceso_extra:(R)
icacls C:\Documentación\Ventas /GRANT smr\Acceso_extra:(R)
