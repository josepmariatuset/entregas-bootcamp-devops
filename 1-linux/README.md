# Ejercicios

## Ejercicios CLI

### 1. Crea mediante comandos de bash la siguiente jerarquía de ficheros y directorios.

```
foo/
├─ dummy/
│  ├─ file1.txt
│  ├─ file2.txt
├─ empty/
```

Donde `file1.txt` debe contener el siguiente texto:

```
Me encanta la bash!!
```

Y `file2.txt` debe permanecer vacío.


## Respuesta ##

```shell
$ mkdir -p foo/dummy
$ mkdir -p foo/empty
$ touch foo/dummy/file1.txt foo/dummy/file2.txt
$ echo 'Me encanta la bash!!' > foo/dummy/file1.txt
$ cat foo/dummy/file1.txt
Me encanta la bash!!

$ tree
.
`-- foo
    |-- dummy
    |   |-- file1.txt
    |   `-- file2.txt
    `-- empty

```
### 2. Mediante comandos de bash, vuelca el contenido de file1.txt a file2.txt y mueve file2.txt a la carpeta empty.

El resultado de los comandos ejecutados sobre la jerarquía anterior deben dar el siguiente resultado.

```
foo/
├─ dummy/
│  ├─ file1.txt
├─ empty/
  ├─ file2.txt
```

Donde `file1.txt` y `file2.txt` deben contener el siguiente texto:

```
Me encanta la bash!!
```
## Respuesta ##

```shell
$ cat foo/dummy/file1.txt > foo/dummy/file2.txt  
$ mv foo/dummy/file2.txt foo/empty/
$ tree
.
`-- foo
    |-- dummy
    |   `-- file1.txt
    `-- empty
        `-- file2.txt

$ cat foo/dummy/file1.txt
Me encanta la bash!!
$ cat foo/empty/file2.txt
Me encanta la bash!!

```
### 3. Crear un script de bash que agrupe los pasos de los ejercicios anteriores y además permita establecer el texto de file1.txt alimentándose como parámetro al invocarlo.

Si se le pasa un texto vacío al invocar el script, el texto de los ficheros, el texto por defecto será:

```
Que me gusta la bash!!!!
```

## Respuesta ##
Script ejercicio3.sh
```
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
```
OUTPUT
```shell
$ ./ejercicio3.sh 'Bash a tope!!!'
Bash a tope!!!
$ ./ejercicio3.sh
Que me gusta la bash!!!!

```
### 4. Opcional - Crea un script de bash que descargue el contenido de una página web a un fichero.

Una vez descargado el fichero, que busque en el mismo una palabra dada (esta se pasará por parametro) y muestre por pantalla el núemro de linea donde aparece.

## Respuesta ##
Script ejercicio4.sh
```
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
  #curl -o ./response.txt $URI
  COUNTLINES=$(grep $SEARCH response.txt | wc -l)
  LINES=$(grep -n $SEARCH response.txt | cut -d : -f1 | tr "\n" ",")
  echo "la palabra '$SEARCH' aparece en un total de $COUNTLINES veces, en las lineas ${LINES::-1}"
fi
```

OUTPUT
```
$ ./ejercicio4.sh Bootcamp
Descargando pagina web https://lemoncode.net/masteres
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 55624    0 55624    0     0   8885      0 --:--:--  0:00:06 --:--:-- 11742
la palabra 'Bootcamp' aparece en un total de 16 veces, en las lineas 87,97,107,242,252,262,363,550,560,654,664,758,768,831,841,851


$ ./ejercicio4.sh Master
Descargando pagina web https://lemoncode.net/masteres
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 55624    0 55624    0     0  75066      0 --:--:-- --:--:-- --:--:-- 75167
la palabra 'Master' aparece en un total de 3 veces, en las lineas 77,232,821
```
