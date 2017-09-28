#Fuente: https://gallery.technet.microsoft.com/scriptcenter/Menu-simple-en-PowerShell-95e1f923

#Función que nos muestra un menú por pantalla con 3 opciones y una última para salir del mismo
function mostrarMenu 
{ 
     param ( 
           [string]$Titulo = 'Selección de opciones' 
     ) 
     cls 
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
                cls 
                'Primera Opción' 
           } '2' { 
                cls 
                'Segunda Opción' 
           } '3' { 
                cls 
                'Tercera Opción' 
           } 's' { 
                return 
           }  
     } 
     pause 
} 
until ($input -eq 's')
