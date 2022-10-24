#!/bin/bash

if [ $# -eq 0 ]; then
  CONTENT='Que me gusta la bash!!!!'
else
  CONTENT=$1
fi

#Crea mediante comandos de bash la siguiente jerarquía de ficheros y directorios.
mkdir -p foo/dummy
mkdir -p foo/empty
touch foo/dummy/file1.txt foo/dummy/file2.txt

#Donde file1.txt debe contener el siguiente texto: Me encanta la bash!!
echo $CONTENT > foo/dummy/file1.txt
cat foo/dummy/file1.txt

#Mediante comandos de bash, vuelca el contenido de file1.txt a file2.txt
cat foo/dummy/file1.txt > foo/dummy/file2.txt  
# y mueve file2.txt a la carpeta empty.
mv foo/dummy/file2.txt foo/empty/
