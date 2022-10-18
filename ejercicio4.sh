#!/bin/bash

# 4. Opcional - Crea un script de bash que descargue el contenido 
# de una página web a un fichero.
# Una vez descargado el fichero, que busque en el mismo una palabra
# dada (esta se pasará por parametro) y muestre por pantalla el 
# número de linea donde aparece.

how_to_use()


if [ $# -eq 0 ]; then
  CONTENT='Que me gusta la bash!!!!'
else
  CONTENT=$1
fi

SEARCH=$1
curl -o ./response.txt https://lemoncode.net/
grep $SEARCH response.txt