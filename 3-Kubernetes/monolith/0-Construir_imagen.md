# Construir la imagen Monolith

Levanto con docker un postgress en local
``` bash
$ docker run --rm -d -p 5432:5432 --name postgres postgres:10.4
```

Populo la base de datos
``` bash
$ docker exec -it postgres psql -U postgres
```

Pego el contenido de `todos_db.sql`


Verifico que exista la base de datos
``` bash
todos_db=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 todos_db  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)

todos_db=# 
```

Creo imagen
``` bash
docker build -t jmtuset/lc-todo-monolith-psql:latest . 
```

Creo la network
``` bash
docker network create monolith-psql
```

Inicio la base de datos, montando un volumen para persistir los datos y utilizando la network creada

``` bash
docker run -d --network monolith-psql -v todos:/var/lib/postgresql/data --name postgres postgres:10.4
```

Inicio la applicación con las variables de entorno para configurarla.
``` bash
docker run -d -p 3000:3000 --network lemoncode -e NODE_ENV=production -e PORT=3000 -e DB_HOST=postgres -e DB_USER=postgres -e DB_PASSWORD=postgres -e DB_PORT=5432 -e DB_NAME=todos_db -e DB_VERSION=10.4 --name todoapp jmtuset/lc-todo-monolith-psql  
```
