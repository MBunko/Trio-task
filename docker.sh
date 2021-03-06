#! /bin/bash

docker rm -f $(docker ps -qa)


docker network create trio
docker volume create trio-sql
docker build -t trio-mysql db
docker run -d --network trio --name mysql --mount type=volume,source=trio-sql,target=/var/lib/mysql -e MYSQL_ROOT_PASSWORD="password" trio-mysql

docker build -t flask-app flask-app
docker run -d --network trio --name flask-app flask-app

docker run -d --network trio -p 80:80 --mount type=bind,source=$(pwd)/nginx/nginx.conf,target=/etc/nginx/nginx.conf --name nginx nginx:alpine

