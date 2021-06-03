export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../health-network/crypto-config/ordererOrganizations/health-network.com/orderers/orderer.health-network.com/msp/tlscacerts/tlsca.health-network.com-cert.pem
export PEER0_HM_CA=${PWD}/../health-network/crypto-config/peerOrganizations/HM.health-network.com/peers/peer0.HM.health-network.com/tls/ca.crt
export PEER0_FM_CA=${PWD}/../health-network/crypto-config/peerOrganizations/FM.health-network.com/peers/peer0.FM.health-network.com/tls/ca.crt
export PEER0_EM_CA=${PWD}/../health-network/crypto-config/peerOrganizations/EM.health-network.com/peers/peer0.EM.health-network.com/tls/ca.crt
export PEER0_P_CA=${PWD}/../health-network/crypto-config/peerOrganizations/P.health-network.com/peers/peer0.P.health-network.com/tls/ca.crt

export FABRIC_CFG_PATH=${PWD}/../config/
export CHANNEL_NAME=mychannel

# setGlobalsForOrderer(){
#      export CORE_PEER_LOCALMSPID="OrdererMSP"
#      export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../crypto-config/ordererOrganizations/health-network.com/orderers/orderer.health-network.com/msp/tlscacerts/tlsca.health-network.com-cert.pem
#      export CORE_PEER_MSPCONFIGPATH=${PWD}/../crypto-config/ordererOrganizations/health-network.com/users/Admin@health-network.com/msp
    
#  }
setGlobalsForPeer0HM(){
    export CORE_PEER_LOCALMSPID="HealthMinistryMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_HM_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../health-network/crypto-config/peerOrganizations/HM.health-network.com/users/Admin@HM.health-network.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer0FM(){
    export CORE_PEER_LOCALMSPID="FinanceMinistryMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_FM_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../health-network/crypto-config/peerOrganizations/FM.health-network.com/users/Admin@FM.health-network.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
    
}

setGlobalsForPeer0EM(){
    export CORE_PEER_LOCALMSPID="EquipementMinistryMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_EM_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../health-network/crypto-config/peerOrganizations/EM.health-network.com/users/Admin@EM.health-network.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    
}

setGlobalsForPeer0P(){
    export CORE_PEER_LOCALMSPID="PartnersMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_P_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../health-network/crypto-config/peerOrganizations/P.health-network.com/users/Admin@P.health-network.com/msp
    export CORE_PEER_ADDRESS=localhost:10051
    
}

createChannel(){
    rm -rf ./../health-network/channel-artifacts/*
    #setGlobalsForOrderer
    setGlobalsForPeer0HM

    pwd

    peer channel create -o localhost:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.example.com \
    -f ../health-network/channel-artifacts/${CHANNEL_NAME}.tx --outputBlock ./../health-network/channel-artifacts/${CHANNEL_NAME}.block \
    --tls  --cafile $ORDERER_CA
}

removeOldCrypto(){
    rm -rf ../api-1.4/crypto/*
    rm -rf ../api-1.4/fabric-client-kv-org1/*
    rm -rf ../api-2.0/org1-wallet/*
    rm -rf ../api-2.0/org2-wallet/*
}


joinChannel(){
    setGlobalsForPeer0FM
    peer channel join -b ../health-network/channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForPeer0EM
    peer channel join -b ../health-network/channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForPeer0P
    peer channel join -b ../health-network/channel-artifacts/$CHANNEL_NAME.block
    
    
}

updateAnchorPeers(){
    setGlobalsForPeer0HM
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.health-network.com -c $CHANNEL_NAME -f ../health-network/channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls  --cafile $ORDERER_CA
    
    setGlobalsForPeer0FM
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.health-network.com -c $CHANNEL_NAME -f ../health-network/channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls  --cafile $ORDERER_CA
    
    setGlobalsForPeer0EM
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.health-network.com -c $CHANNEL_NAME -f ../health-network/channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls  --cafile $ORDERER_CA
    
    setGlobalsForPeer0P
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.health-network.com -c $CHANNEL_NAME -f ../health-network/channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls  --cafile $ORDERER_CA
    

}

removeOldCrypto

createChannel
joinChannel
updateAnchorPeers

