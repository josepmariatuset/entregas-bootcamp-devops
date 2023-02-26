# Ejercicio 2 Github Actions

## Crea un workflow CD para el proyecto de frontend

El punto de partida de este ejercicio es el ejercicio 1.

Creo el workflow CD de github actions. Creo en la raiz la carpeta `.github/workflows` y dentro el fichero `cd.yaml`.

Empiezo definiendo el nombre del workflow `CD` y que se lance manualmente.

```` yaml
name: CD 

on: 
  workflow_dispatch:
    
````

Defino los jobs. Este workflow ha de primero compilar la solución y luego la empaquetarla.

Para compilar la solución descargo el codigo del repositorio con `actions/checkout@v3`.
Instalo node especificando la versión que necesito.
Instalo las dependencias de la aplicacion con el comando `npm ci` y luego compilo la aplicacion `npm run build --if-present`
Guardo los artefactos generados. Estan en el directorio hangman-front/dist/.

```` yaml
jobs:
  build: 
    runs-on: ubuntu-latest 
    steps:
      - uses: actions/checkout@v3 
      - uses: actions/setup-node@v3
        with:
          node-version: 16 
      - name: build 
        working-directory: ./hangman-front
        run: |
          npm ci 
          npm run build --if-present
      - uses: actions/upload-artifact@v3 
        with:
          name: build-code
          path: hangman-front/dist/
````

Ahora queda empaquetar la aplicacion en un contenedor docker.
Empiezo generando un nuevo dockerfile `Dockerfile.workflow` para contruir la imagen. Es una applicación front que se ejecuta sobre nginx. El dockerfile parte de una imagen de nginx donde copio el fichero de configuracion del nginx `nginx.conf`, la aplicación ya compilada y configuro en entrypoint para el arranque automático.

```` dockerfile
ARG source
FROM nginx:1.19.0-alpine as app

COPY nginx.conf /etc/nginx/nginx.conf 

WORKDIR /usr/share/nginx/html

COPY dist/  .

EXPOSE 8080

COPY ./entry-point.sh /
RUN chmod +x /entry-point.sh
ENTRYPOINT [ "sh", "/entry-point.sh" ] 
CMD [ "nginx", "-g", "daemon off;" ]
````

Ahora defino el job de paquetizar. Tendré que 

- Descargar el repositorio. Añado `actions/checkout@v3`
- Descargo los artefactos que he generado en el job anterior y los dejo en el mismo directorio donde se habian generado.
- Contruir la imagen y subirla al registry. Para poder poder subir imagenes al registry primero tengo que hacer un login. Para ello en la cuenta de GitHub genero un token con permisos para `write:packages`. Este token lo copio y en el repositorio añado un secreto `GIT_DOCKER_TOKEN` con este token. 

Para hacer el login con el docker utilizo la sentencia de comandos

``` code
echo "${{ secrets.GIT_DOCKER_TOKEN }}" | docker login ghcr.io -u "${{ github.actor }}" --password-stdin
```

Posteriormente genero el nombre de la imagen y la version y me lo guardo en variables de entorno.
Ahora ya puedo contruir la imagen de docker con el dockerfile que me he generado y asignadole el nombre y versión. La versión es diferente para cada ejecución del workflow. Para tener localizada la ultima versión, le añado el tag de latest tambien.
Unicamente falta subir la imagen al registry mediante el comando `docker push`.

```` yaml
  delivery:
    runs-on: ubuntu-latest
    needs: build 

    steps:
      - uses: actions/checkout@v3 
      - uses: actions/download-artifact@v3 
        with:
          name: build-code 
          path: hangman-front/dist/
          
      - name: Build and Push Docker Image 
        working-directory: ./hangman-front
        env:
          DOCKER_USER: "josepmariatuset"
          DOCKER_REPOSITORY: "hangman-front"
        run: |
          echo "${{ secrets.GIT_DOCKER_TOKEN }}" | docker login ghcr.io -u "${{ github.actor }}" --password-stdin
          image=ghcr.io/$DOCKER_USER/$DOCKER_REPOSITORY
          image=$(echo $image | tr '[A-Z]' '[a-z]')
          version=$(echo $(date +%s) | sed -e 's,.*/\(.*\),\1,')

          docker build . --file Dockerfile.workflow --tag $image:$version 
          docker tag $image:$version $image:latest
          docker push $image:$version 
          docker push $image:latest 

````

fichero completo

```` yaml
name: CD 

on: 
  workflow_dispatch:
    
jobs:
  build: 
    runs-on: ubuntu-latest 

    steps:
      - uses: actions/checkout@v3 
      - uses: actions/setup-node@v3
        with:
          node-version: 16 
          cache: 'npm'
          cache-dependency-path: hangman-front/package-lock.json 
      - name: build 
        working-directory: ./hangman-front
        run: |
          npm ci 
          npm run build --if-present
      - uses: actions/upload-artifact@v3 
        with:
          name: build-code
          path: hangman-front/dist/

  delivery:
    runs-on: ubuntu-latest
    needs: build 

    steps:
      - uses: actions/checkout@v3 
      - uses: actions/download-artifact@v3 
        with:
          name: build-code 
          path: hangman-front/dist/
          
      - name: Build and Push Docker Image 
        working-directory: ./hangman-front
        env:
          DOCKER_USER: "josepmariatuset"
          DOCKER_REPOSITORY: "hangman-front"
        run: |
          echo "${{ secrets.GIT_DOCKER_TOKEN }}" | docker login ghcr.io -u "${{ github.actor }}" --password-stdin
          image=ghcr.io/$DOCKER_USER/$DOCKER_REPOSITORY
          image=$(echo $image | tr '[A-Z]' '[a-z]')
          version=$(echo $(date +%s) | sed -e 's,.*/\(.*\),\1,')

          docker build . --file Dockerfile.workflow --tag $image:$version 
          docker tag $image:$version $image:latest
          docker push $image:$version 
          docker push $image:latest
````
