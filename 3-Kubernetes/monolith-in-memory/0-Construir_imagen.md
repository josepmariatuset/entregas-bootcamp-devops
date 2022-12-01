# Construir la imagen Monolith-in-memory

Entro en todo-app e instalo las depencias de frontend y raiz
``` bash
cd ./todo-app/frontend
npm install
cd ../
npm install
 ```

Genero la imagen de docker
``` bash
$docker build -t jmtuset/lc-todo-monolith:latest . 
$ docker build -t jmtuset/lc-todo-monolith:latest .
Sending build context to Docker daemon  175.1MB
Step 1/15 : FROM node:12-alpine3.12 as builder
---> 2ac3ae179d11
Step 2/15 : WORKDIR /build
---> Using cache
---> ef40f0392296
Step 3/15 : COPY ./src ./src
---> Using cache
---> 59fc7d8d0384
Step 4/15 : COPY ./frontend ./frontend
---> Using cache
---> 57357f88b292
Step 5/15 : COPY package*.json ./
---> Using cache
---> bfe073c85f81
Step 6/15 : COPY tsconfig.json ./
---> Using cache
---> aaa6d6bcbd9b
Step 7/15 : RUN npm install
---> Using cache
---> cd1c70e1da65
Step 8/15 : RUN cd ./frontend && npm install
---> Using cache
---> 4c263a97928f
Step 9/15 : RUN npm run build
---> Using cache
---> 8637abef5fc6
Step 10/15 : FROM node:12-alpine3.12 as app
---> 2ac3ae179d11
Step 11/15 : WORKDIR /app
---> Using cache
---> f9e8d6756a12
Step 12/15 : COPY --from=builder ./build/wwwroot ./
---> Using cache
---> 88610416bd1e
Step 13/15 : COPY package*.json ./
---> Using cache
---> 7d136372b8ee
Step 14/15 : RUN npm ci --only=production
---> Using cache
---> 1ed5d9cbade2
Step 15/15 : CMD [ "node", "app.js" ]
---> Using cache
---> dd3e8479107d
Successfully built dd3e8479107d
Successfully tagged jmtuset/lc-todo-monolith:latest
 ```

Subo la imagen a docker hub
``` bash
$ docker push jmtuset/lc-todo-monolith:latest
The push refers to repository [docker.io/jmtuset/lc-todo-monolith]Screenshot from 2022-11-21 19-27-59.png
c5a6ece21320: Layer already exists 
f9e04e78037d: Layer already exists 
3b838ffb3f30: Layer already exists 
c4d5b8843f1c: Layer already exists 
8371ea6c57cf: Layer already exists 
3209848a3072: Layer already exists 
ca1db43afcf3: Layer already exists 
eb4bde6b29a6: Layer already exists 
v1.0: digest: sha256:cb3abc243ecca3840d1cd31375fa2f1d0035e294106f8e9cc16f53605f48d595 size: 1995
roche@roche-VM:~/bootcamp-devops-lemoncode/02-orquestacion/exercises/00-monolith-in-mem/todo-app$ ^C
 ```

Ejecuto la app con docker
``` bash
docker run -d -p 3000:3000 -e NODE_ENV=production -e PORT=3000 jmtuset/lc-todo-monolith
 ```

Abrir un navegador con la url http://localhost:3000

![todo app in memory running with docker in local](README_files/Screenshot_from_2022-11-21_20-27-56.png)
