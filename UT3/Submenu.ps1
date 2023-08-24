#Fuente: https://gallery.technet.microsoft.com/scriptcenter/Menu-simple-en-PowerShell-95e1f923

#----------------Funcion Submenu  -------------#
function mostrar_Submenu
{
     param (
           [string]$Titulo = 'Submenu.....'
     )
     Clear-Host 
     Write-Host "================ $Titulo ================"
    
     Write-Host "1: Opción 1."
     Write-Host "2: Opción 2."
     Write-Host "s: Volver al menu principal."
do
{
     $input = Read-Host "Por favor, pulse una opcion"
     switch ($input)
     {
           '1' {
                'Opcion 1'
                return
           } '2' {
                'Opcion 2'
                return
           } 
     }
}
until ($input -eq 'q')
}



#Función que nos muestra un menú por pantalla con 3 opciones, donde una de ellas es para acceder
# a un submenú) y una última para salir del mismo.

function mostrarMenu 
{ 
     param ( 
           [string]$Titulo = 'Selección de opciones' 
     ) 
     Clear-Host 
     Write-Host "================ $Titulo================" 
      
     
     Write-Host "1. Primera Opción" 
     Write-Host "2. Segunda Opción" 
     Write-Host "3. Submneu" 
     Write-Host "s. Presiona 's' para salir" 
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
                mostrar_Submenu      
           } 's' {
                'Saliendo del script...'
                return 
           }  
     } 
     pause 
} 
until ($input -eq 's')
