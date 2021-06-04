#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin:/usr/local/go/bin
export PATH=${PWD}/../bin:${PWD}:$PATH

docker-compose -f ../health-network/docker-compose-cli.yaml  up -d

sleep 5
#docker exec -it cli sh
sleep 2
./createChannel.sh

echo "done"