#!/bin/bash

# 4. Opcional - Crea un script de bash que descargue el contenido 
# de una página web a un fichero.
# Una vez descargado el fichero, que busque en el mismo una palabra
# dada (esta se pasará por parametro) y muestre por pantalla el 
# número de linea donde aparece.

URI=https://lemoncode.net/masteres
if [ $# -eq 0 ]; then
  echo 'Falta el parametro de búsqueda'
else
  SEARCH=$1
  echo "Descargando pagina web $URI"
  curl -o ./response.txt $URI
  COUNTLINES=$(grep $SEARCH response.txt | wc -l)
  LINES=$(grep -n $SEARCH response.txt | cut -d : -f1 | tr "\n" ",")
  echo "la palabra '$SEARCH' aparece en un total de $COUNTLINES veces, en las lineas ${LINES::-1}"
fi