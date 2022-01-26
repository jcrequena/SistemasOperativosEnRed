#!/bin/bash
# Script que da de alta los usuarios indicados en fichero csv
#ejecutamos el script pasándole como parámetro el nombre del fichero con los datos de los usuarios
#Ejemplo de uso: crear_Usuarios.sh usuarios.csv

# Lemos cada linea del ficheiro que nos indiquen como parámetro
#Las columnas del fichero son:
# username:Name:Surname:OU:Group:ID
for i in `cat $1`; do
        # Extraemos los campos de los usuarios
        LOGIN=`echo $i | cut -f 1 -d :`
        NOMBRE=`echo $i | cut -f 2 -d :`
        APELLIDOS=`echo $i | cut -f 3 -d :`
        UO=`echo $i | cut -f 4 -d :`
        GRUPO=`echo $i | cut -f 5 -d :`
        UID=`echo $i | cut -f 6 -d :`

        # Añadimos el usuario con samba-tool y lo añadimos a la Unidad Organizativa grupo que le corresponde
        echo -n "Añadiendo usuario $LOGIN..."
        #Añade el usuario en la UO correspondiente
        samba-tool user create $LOGIN abc123. --given-name=$NOMBRE --surname=$APELLIDOS --must-change-at-next-login --userou=OU=$UO --uid-number=$UID
        #Hace miembro del grupo correspondiente al usuario
        samba-tool group addmembers $GRUPO $LOGIN
        echo "[Usuario $LOGIN creado correctamente]"
done
