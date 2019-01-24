#!/bin/bash
#Ejecutar el script como root
#Crear el usuario jcrequena y le asigna como grupo secundario depInformatica
useradd -G depInformatica jcrequena
#Le asignamos el passwd al usuario jcrequena
passwd jcrequena

#Creación de grupos
groupadd mynewgroup

#Hacemos al usuario jcrequena miembro del grupo secundario mynewgroup
usermod -a -G mynewgroup jcrequena
#Hacemos al usuario jcrequena que su grupo primario sea groupnamePrimary
usermod -g groupnamePrimary jcrequena
#Hacemos al usuario jcrequena miembro de los grupos secundarios group1,group2,group3 
usermod -a -G group1,group2,group3 jcrequena

#Comando para listar los grupos
groups
#Comando para listar los grupos con su ID
id
#Comando para ver todos los grupos del sistema
getent group
