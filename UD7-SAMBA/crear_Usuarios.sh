#!/bin/bash
# Script que da de alta los usuarios indicados en fichero csv
#ejecutamos el script pasándole como parámetro el nombre del fichero con los datos de los usuarios
#Ejemplo de uso: crear_Usuarios.sh usuarios.csv

# Lemos cada linea del ficheiro que nos indiquen como parámetro
#Las columnas del fichero son:
# username:Name:Surname:OU:Group:ID


while IFS=, read -r col1 col2 col3 col4 col5 col6
do
    echo "I got:$col1|$col2"
        # Extraemos los campos de los usuarios
        LOGIN=$col1
        NOMBRE=`$col2
        APELLIDOS=$col3
        UO=$col4
        GRUPO=$col5
        UID=$col6

        # Añadimos el usuario con samba-tool y lo añadimos a la Unidad Organizativa grupo que le corresponde
        echo -n "Añadiendo usuario $LOGIN..."
        #Añade el usuario en la UO correspondiente
        samba-tool user create $LOGIN abc123. --given-name=$NOMBRE --surname=$APELLIDOS --must-change-at-next-login --userou=OU=$UO --uid-number=$UID
        #Se hace miembro del grupo correspondiente al usuario
        samba-tool group addmembers $GRUPO $LOGIN
        echo "[Usuario $LOGIN creado correctamente]"
    
done <  $1
