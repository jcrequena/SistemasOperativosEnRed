#!/bin/bash
#autor:jcrequena


fntCrearUOS() {   
#Obtener datos del csv e incorporar a ldif
read -p "Escribe el fichero csv con las UOS:" fichUOS

if [ -f $fichUOS ]; then
	while IFS=$';' read c1 c2 c3
	do
 		
	done < $fichUOS
else
	 #Si el fichero no existe nos salimos de la función con el comand return
     echo "ERROR: el fichero $fichUOS no existe"
     return
fi
} 

fntCrearUsuarios() {
#función para crear equipos
echo "Crear usuarios"
}



#################################
#PROGRAMA PRINCIPAL
################################


#Menu principal
#Cada vez que se selecciona una opción, ejecuta su código y se pone a la
#espera que pulsemos una tecla para volver al menú principal

while [ opcion != "" ]
do
	clear
	echo "****************************"
	echo "**********MENU**************"
	echo "*****************************"
	echo

    	echo "1)" "Crear UOS:"
    	echo "2)" "Crear Usuarios 2"
    	echo "3)" "SALIR"

	read -p "Introduce una opcion: " opcion
	#Comprueba si el valor recogido en opcion es 1,2 o 3, si es otra cosa, se ejecuta *)
    	case $opcion in
    	1) 
			fntCrearUOS
			read -p "Press [Enter] key to continue..."
       		;;
    	2) 
        	fntCrearUsuarios
        	echo "Opcion 2"
			read -p "Press [Enter] key to continue..."
        	;;
    	3) 
        	echo "Saliendo..."
        	exit 1
        	;;

    	*) 
			echo "Error: Please try again (select 1..4)!"
        	read -p "Press [Enter] key to continue..."
		;;
   	
