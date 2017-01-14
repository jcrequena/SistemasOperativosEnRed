#!/bin/bash
#autor: Juan Carlos Requena
#Nota: La llamada al script, tiene dos parámetros y son: ProyectoFase1.sh Directorio_Base Fichero_LDIF

#################################
#DECLRACIÓN DE LAS FUNCIONES
################################

fntLeerDirectorioBase() { 
	while IFS=, read c1 c2 #columnas del fichero, ejemplo c1, c2,...,cn etc...
	do
  		#Leer dc dc
   		var1=${c1} #con esto ponemos en la variable variable var1 el contenido de la columna 1 (c1) del fichero que estamos 					#leyendo
	
	done < $fDirectorioBasecsv #aquí se pone el fichero csv con la información a leer en el bucle
}


fntCrearUsuarios() {   
  #(1) Pedir por pantalla el fichero csv de los usuarios. Suponiendo que el fichero que pido lo guardo en la
  #variable fichcsvUsers, entonces, pregunto con el if si el fichero recibido existe, en caso contrario, doy un mensaje de error
  #y salgo de la función con el comando return
if [ -f $fichcsvUsers ]; then
	while IFS=, read #columnas del fichero, ejemplo c1, c2 etc...
	do
 	
  		#Volcar datos que vamos leyendeo del csv al archivo ldif
   		echo "dn: uid=,ou=usuarios,dc=,dc=" >> $f1 # f1 será el fichero de salida (ldif)
   		echo "objectClass: inetOrgPerson" >> $f1
   		
   		#etc..
   	

	
	done < $file #aquí se pone el fichero csv que nos han puesto en (1) ver el comentario de arriba
else
	echo "ERROR:el fichero no existe $fichcsvUsers"
	
	return
fi
} 
fntCrearEquipos() {
  #función para crear equipos
  echo "Crear equipos"
}

#
# Resto de funciones
#



#################################
#PROGRAMA PRINCIPAL
################################
#Capturamos el fichero donde estará el nombre del dominio (directorio base) y extensión, 
#es el primer parámetro en la llamada del script
#En $1 se guarda el primer parámetro del script
#En $2 se guarda el segundo parámetro del script
fDirectorioBasecsv=$1
#Capturamos el fichero de salida, es el segundo parámetro en la llamada del script
ficheroBD=$2 

#http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
#En el enlace de arriba, explica cómo funciona el if
#Verdadero si el fichero existe y el parámetro 2 no es vacío
#El && es el y, es decir si se cumple -f $fDirectorioBase Y -z $ficheroBD, la condición del if es Verdadero
if [ -f $fDirectorioBase ] && [ -z $ficheroBD ];then 
	echo "ERROR: Faltan parámetros"
    	echo "Uso: crearObjetosLDAP.sh ficheroBase ficheroLDIF"
	exit 0 #nos vamos del script con el código de error 0
fi
#Crear o reiniciar archivo ldif
>$ficheroBD
#Llamamos a la funcion que lee el nombre del domino y extension (directorio base)
fntLeerDirectorioBase


#################################
#MENU PRINCIPAL
################################
#Cada vez que se selecciona una opción, ejecuta su código y se pone a la
#espera que pulsemos una tecla para volver al menú principal

while [ opcion != "" ]
do
	clear
	echo "****************************"
	echo "**********MENU**************"
	echo "*****************************"
	echo

    	echo "1)" "Crear Usuarios:"
    	echo "2)" "Opcion 2"
    	echo "3)" "SALIR"

	read -p "Introduce una opcion: " opcion
	    #Comprueba si el valor recogido en opcion es 1,2 o 3, si es otra cosa, se ejecuta *)
    	case $opcion in
    	1) 
       		#Llamar a la funcion crear usuarios o llamar a un script que cree usuarios
          #ejemplo: si queremos llamar a la funcion crear usuarios pondríamos
		      fntCrearUsuarios
		read -p "Press [Enter] key to continue..."
       		;;
    	2) 
        	echo "Opcion 2"
		read -p "Press [Enter] key to continue..."
        	;;
    	3) 
        	echo "Saliendo..."
		      #el comando exit hace que el script finalize con código de error 1
        	exit 1
        	;;

    	*) 
		echo "Error: Please try again (select 1..4)!"
        	read -p "Press [Enter] key to continue..."
		;;
   	esac
done
