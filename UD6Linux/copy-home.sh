#!/bin/bash
usuario=`whoami`
fecha=`date +%d%m%y`

tar -czvf /home/$usuario/$usuario$fecha /home/$usuario/
