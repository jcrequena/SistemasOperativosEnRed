#Fuente: https://gallery.technet.microsoft.com/scriptcenter/Menu-simple-en-PowerShell-95e1f923

#Paso de parámetros al ejecutar el script en la consola
#Este script recoge 2 parámetros en la llamada del mismo en la consola. 
#La ejecución del script será puede ser de dos formas:
#./menu.ps1 param1 param2
#o 
#./menu.ps1 -Param1 parametro1 -Param2 parametro2
#Los parámetros son opcionales, si la llamada es:./menu.ps1 --> los valores de $Param1 y $Param2, será la cadena de texto vacía.
Param(
  [string]$Param1,
  [string]$Param2
)
Write-Host "Los parámetros son:"$Param1 " " $Param2
pause

#Función 1. Promocionar a CD
function promocionarCD
{
Write-Host "Ejecuto el comando CD"
}

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
#Bucle principal del Script. El bucle se ejecuta de manera infinita hasta que se cumple
#la condición until ($input -eq 's'), es decir, hasta que se pulse la tecla s.
do 
{ 
     #Llamamos a la función mostrarMenu, para dibujar el menú de opciones por pantalla
     mostrarMenu 
     #Recogemos en la varaible input, el valor que el usuario escribe por teclado (opción del menú)
     $input = Read-Host "Elegir una Opción" 
     #https://ss64.com/ps/switch.html
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
           #Si no se selecciona una de las opciones del menú, es decir, se pulsa algun carácter
           #que no sea 1, 2, 3 o s, sacamos por pantalla un aviso e indicamos lo que hay que realizar.
           default { 
              'Por favor, Pulse una de las opciones disponibles [1-3] o s para salir'
           }
     } 
     pause 
} 
until ($input -eq 's')
