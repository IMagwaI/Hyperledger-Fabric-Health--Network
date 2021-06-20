#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin:/usr/local/go/bin
export PATH=${PWD}/../bin:${PWD}:$PATH

export FABRIC_CFG_PATH=${PWD}/../health-network/
export CHANNEL_NAME=mychannel

#   generate files

rm -rf ./../health-network/channel-artifacts/*
rm -rf ./../health-network/crypto-config/*

../bin/cryptogen generate --config ../health-network/crypto-config.yaml --output=../health-network/crypto-config 

../bin/configtxgen -profile OrdererGenesis -outputBlock ../health-network/channel-artifacts/genesis.block -channelID channelorderergenesis 


../bin/configtxgen -profile MyChannel -outputCreateChannelTx ../health-network/channel-artifacts/channel.tx -channelID mychannel


../bin/configtxgen -profile MyChannel -outputAnchorPeersUpdate ../health-network/channel-artifacts/HealthMinistryAnchor.tx -channelID mychannel -asOrg HealthMinistryMSP


../bin/configtxgen -profile MyChannel -outputAnchorPeersUpdate ../health-network/channel-artifacts/FinanceMinistryAnchor.tx -channelID mychannel -asOrg FinanceMinistryMSP

../bin/configtxgen -profile MyChannel -outputAnchorPeersUpdate ../health-network/channel-artifacts/EquipementMinistryAnchor.tx -channelID mychannel -asOrg EquipementMinistryMSP

../bin/configtxgen -profile MyChannel -outputAnchorPeersUpdate ../health-network/channel-artifacts/PartnersAnchor.tx -channelID mychannel -asOrg PartnersMSP


echo COMPOSE_PROJECT_NAME=net > ../health-network/.env

sleep 2

#start network
docker-compose -f ../health-network/docker-compose-cli.yaml  up -d

#docker exec -it cli sh
sleep 2
./createChannel.sh


sleep 2
./deployChaincode.sh
#echo "done"
