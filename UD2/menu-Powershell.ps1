#Fuente: https://gallery.technet.microsoft.com/scriptcenter/Menu-simple-en-PowerShell-95e1f923

#Paso de parámetros al ejecutar el script en la consola
#Este script recoje 2 parámetros en la llamada del mismo en la consola. 
#La ejecución del script será: ./menu.ps1 param1 param2
#Los parámetros son opcionales, si la llamada es:./menu.ps1 los valores de $Param1 y $Param2, será la cadena de texto vacía.
Param(
  [string]$Param1,
  [string]$Param2
)
Write-Host "Los parámetros son:"$Param1 " " $Param2
pause

#Función que nos muestra un menú por pantalla con 3 opciones y una última para salir del mismo
# La función “mostrarMenu”, puede tomar como parámetro un título y devolverá por pantalla 
# "================ $Titulo================" , donde $Titulo será el título pasado por parámetro.
#Si no se le pasa un parámetro, por defecto $Titulo contendrá la cadena 'Selección de opciones'  
#https://technet.microsoft.com/es-es/library/jj554301.aspx
function mostrarMenu 
{ 
     param ( 
           [string]$Titulo = 'Selección de opciones' 
     ) 
     Clear-Host 
     Write-Host "================ $Titulo================" 
      
     
     Write-Host "1) Primera Opción" 
     Write-Host "2) Segunda Opción" 
     Write-Host "3) Tercera Opción" 
     Write-Host "S) Presiona 'S' para salir" 
}

do 
{ 
     mostrarMenu 
     $input = Read-Host "Elegir una Opción" 
     switch ($input) 
     { 
           '1' { 
                Clear-Host  
                'Primera Opción' 
                pause
           } '2' { 
                Clear-Host  
                'Segunda Opción' 
                pause
           } '3' { 
                Clear-Host  
                'Tercera Opción' 
                pause
           } 's' {
                'Saliendo del script...'
                return 
           }  
     } 
     pause 
} 
until ($input -eq 's')
