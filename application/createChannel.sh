export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=/opt/gopath/fabric-samples/health-network/crypto-config/ordererOrganizations/health-network.com/orderers/orderer.health-network.com/msp/tlscacerts/tlsca.health-network.com-cert.pem


export FABRIC_CFG_PATH=${PWD}/../health-network/
export CHANNEL_NAME=mychannel





createChannel(){



    docker exec -e "CORE_PEER_LOCALMSPID=HealthMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/HM.health-network.com/peers/peer0.HM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/HM.health-network.com/users/Admin@HM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.HM.health-network.com:7051"  -it cli  bash -c \
    "peer channel create -o orderer.health-network.com:7050 -c mychannel -f /opt/gopath/fabric-samples/health-network/channel-artifacts/channel.tx --tls --cafile $ORDERER_CA;peer channel join -b $CHANNEL_NAME.block --tls --cafile $ORDERER_CA;peer channel list;exit" 



    echo "===================== created ====================="

}


joinChannel(){

    echo "===================== FM ====================="
    docker exec  -e "CORE_PEER_LOCALMSPID=FinanceMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/peers/peer0.FM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/users/Admin@FM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.FM.health-network.com:7051" -it cli  bash -c \
    "peer channel join -b $CHANNEL_NAME.block ;peer channel list;exit"

    echo "===================== EM ====================="
    docker exec -e "CORE_PEER_LOCALMSPID=EquipementMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/EM.health-network.com/peers/peer0.EM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/EM.health-network.com/users/Admin@EM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.EM.health-network.com:7051"  cli  /bin/sh -c \
    "peer channel join -b $CHANNEL_NAME.block ;peer channel list"

    echo "===================== P ====================="
    docker exec  -e "CORE_PEER_LOCALMSPID=PartnersMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/P.health-network.com/peers/peer0.P.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/P.health-network.com/users/Admin@P.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.P.health-network.com:7051" cli  /bin/sh -c \
    "peer channel join -b $CHANNEL_NAME.block ;peer channel list"


    
}

updateAnchorPeers(){

    
    echo "===================== HM update ====================="
    docker exec -e "CORE_PEER_LOCALMSPID=HealthMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/HM.health-network.com/peers/peer0.HM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/HM.health-network.com/users/Admin@HM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.HM.health-network.com:7051"  -it cli  bash -c \
    "peer channel update -o orderer.health-network.com:7050 -c mychannel -f /opt/gopath/fabric-samples/health-network/channel-artifacts/HealthMinistryAnchor.tx --tls --cafile $ORDERER_CA;exit" 


    echo "===================== FM update ====================="
    docker exec  -e "CORE_PEER_LOCALMSPID=FinanceMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/peers/peer0.FM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/users/Admin@FM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.FM.health-network.com:7051" -it cli  bash -c \
    "peer channel update -o orderer.health-network.com:7050 -c mychannel -f /opt/gopath/fabric-samples/health-network/channel-artifacts/FinanceMinistryAnchor.tx --tls --cafile $ORDERER_CA;exit"

    
    echo "===================== EM update ====================="
    docker exec -e "CORE_PEER_LOCALMSPID=EquipementMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/EM.health-network.com/peers/peer0.EM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/EM.health-network.com/users/Admin@EM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.EM.health-network.com:7051"  cli  /bin/sh -c \
    "peer channel update -o orderer.health-network.com:7050 -c mychannel -f /opt/gopath/fabric-samples/health-network/channel-artifacts/EquipementMinistryAnchor.tx --tls --cafile $ORDERER_CA;exit"

    echo "===================== P update ====================="
    docker exec  -e "CORE_PEER_LOCALMSPID=PartnersMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/P.health-network.com/peers/peer0.P.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/P.health-network.com/users/Admin@P.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.P.health-network.com:7051" cli  /bin/sh -c \
    "peer channel update -o orderer.health-network.com:7050 -c mychannel -f /opt/gopath/fabric-samples/health-network/channel-artifacts/PartnersAnchor.tx --tls --cafile $ORDERER_CA;exit"




}


createChannel
joinChannel
updateAnchorPeers
