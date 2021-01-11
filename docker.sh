#! /bin/bash

docker rm -f $(docker ps -qa)
docker rmi -f $(docker images)

docker network create trio
docker build -t trio-mysql db
docker run -d --network trio --name mysql -e MYSQL_ROOT_PASSWORD="password" trio-mysql

docker build -t flask-app flask-app
docker run -d --network trio --name flask-app flask-app

docker run -d --network trio -p 80:80 --mount type=bind,source=$(pwd)/nginx/nginx.conf,target=/etc/nginx/nginx.conf --name nginx nginx:alpine

