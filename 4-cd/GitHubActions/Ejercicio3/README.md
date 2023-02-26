# Ejercicio 3 Github Actions

La implementación de los ejercicios de Github Actions estan realizados en el siguiente [repositorio](https://github.com/josepmariatuset/github-actions-ejercicio1).

## Crea un workflow que ejecute tests e2e

El punto de partida de este ejercicio es el ejercicio 2.

Creo el workflow E2E de github actions. Creo en la raiz la carpeta `.github/workflows` y dentro el fichero `e2e.yaml`.

Empiezo definiendo el nombre del workflow `E2E-Test` y que se lance manualmente.

```` yaml
name: E2E-Test

on: 
  workflow_dispatch:   
````

Este workflow tiene que levantar toda la solucion (`hangman-front` y `hangman-api`) con sus dependencias (`postgres`) y luego lanzar los test E2E. Configuro como servicios del job estas imagenes. 
La imagen de `hangman-api` utilizo la que hay en el docker-hub en la cuenta de Jaime Salas, que generó durante el curso. La imagen de `hangman-front` utilizo la que genero en el workflow de CD. 

````yaml
    services:
      postgres: 
        image: postgres:14-alpine
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: hangman_db
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
      hangman-api: 
        image: jaimesalas/hangman-api:latest
        ports:
          - 3001:3000

      hangman-front: 
        image: ghcr.io/josepmariatuset/hangman-front:latest
        env:
          API_URL: http://localhost:3001
        ports:
          - 8080:8080

````

En el repositorio copio  las carpetas de `hangman-e2e` y `hangman-api` (La necesito para inicializar la base de datos de postgres).  

En el job defino los siguiente steps.

- `actions/checkout@v3` para descargar el codigo del repositorio
- `actions/setup-node@v3` para configurar node. Se requiere para inicializar la base de datos.
- Mediante knex inicializo la base de datos de postgres
- Ejecuto los test E2E con Cypress
- Guardo los videos generados por Cypress en la ejecución de los test.

```` yaml
    steps:
      - uses: actions/checkout@v3 
      - uses: actions/setup-node@v3 
        with:
          node-version: 16
      - name: Create database relationships 
        working-directory: ./hangman-api 
        env: 
          DATABASE_PORT: 5432
          DATABASE_HOST: localhost
          DATABASE_NAME: hangman_db
          DATABASE_USER: postgres
          DATABASE_PASSWORD: postgres
          DATABASE_POOL_MIN: 2
          DATABASE_POOL_MAX: 10
        run: |
          npm ci 
          npx knex migrate:latest --env development

      - name: Cypress run
        uses: cypress-io/github-action@v5
        with:
          working-directory: ./hangman-e2e/e2e
          start: npm run open
      - name: Store cypress videos
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: cypress-videos
          path: hangman-e2e/e2e/cypress/videos    
````

fichero completo

```` yaml
name: E2E-Test

on: 
  workflow_dispatch:
    

jobs:
  test-e2e:
    runs-on: ubuntu-latest

    services:
      postgres: 
        image: postgres:14-alpine
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: hangman_db
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
      hangman-api: 
        image: jaimesalas/hangman-api:latest
        ports:
          - 3001:3000

      hangman-front: 
        image: ghcr.io/josepmariatuset/hangman-front:latest
        env:
          API_URL: http://localhost:3001
        ports:
          - 8080:8080

    steps:
      - uses: actions/checkout@v3 
      - uses: actions/setup-node@v3 
        with:
          node-version: 16
      - name: Create database relationships 
        working-directory: ./hangman-api 
        env: 
          DATABASE_PORT: 5432
          DATABASE_HOST: localhost
          DATABASE_NAME: hangman_db
          DATABASE_USER: postgres
          DATABASE_PASSWORD: postgres
          DATABASE_POOL_MIN: 2
          DATABASE_POOL_MAX: 10
        run: |
          npm ci 
          npx knex migrate:latest --env development

      - name: Cypress run
        uses: cypress-io/github-action@v5
        with:
          working-directory: ./hangman-e2e/e2e
          start: npm run open
      - name: Store cypress videos
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: cypress-videos
          path: hangman-e2e/e2e/cypress/videos
````
