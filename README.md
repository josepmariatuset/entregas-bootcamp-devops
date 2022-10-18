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

Script ejercicio 3
```shell
$ ./ejercicio3.sh 'Bash a tope!!!'
Bash a tope!!!
$ ./ejercicio3.sh
Que me gusta la bash!!!!

```
### 4. Opcional - Crea un script de bash que descargue el conetenido de una página web a un fichero.

Una vez descargado el fichero, que busque en el mismo una palabra dada (esta se pasará por parametro) y muestre por pantalla el núemro de linea donde aparece.
