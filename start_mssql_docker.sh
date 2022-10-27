#!/bin/bash

MSSQL_SA_PASSWORD="G@tos123?"
CONTAINER_NAME="sql1"
CONTAINER_HOSTNAME="sql1"
IMAGE="mcr.microsoft.com/mssql/server"
VERSION="2022"
TAG="latest"

echo "Verificando se docker está ativo"
if ! sudo service docker status > /dev/null
then
    echo "Iniciando serviço de docker"
    sudo service docker start > /dev/null
fi

echo "Verificando se existe a imagem $IMAGE"
if ! sudo docker images | grep $IMAGE
then
    echo "Fazendo download da $IMAGE:$VERSION-$TAG"
    sudo docker pull $IMAGE:$VERSION-$TAG   
fi

echo "Verificando se o container da $IMAGE está ativo"
if ! sudo docker ps -a | grep $IMAGE:$VERSION-$TAG
then
    echo "Executando container $CONTAINER_NAME"
    sudo docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=$MSSQL_SA_PASSWORD"  -p 1433:1433 --name $CONTAINER_NAME --hostname $CONTAINER_HOSTNAME    -d    mcr.microsoft.com/mssql/server:2022-latest
elif ! sudo docker ps | grep $IMAGE:$VERSION-$TAG
then 
    echo "Reiniciando container $CONTAINER_NAME"
    sudo docker restart $CONTAINER_NAME
fi

