export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=/opt/gopath/fabric-samples/health-network/crypto-config/ordererOrganizations/health-network.com/orderers/orderer.health-network.com/msp/tlscacerts/tlsca.health-network.com-cert.pem
export PEER0_HM_CA=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/HM.health-network.com/peers/peer0.HM.health-network.com/tls/ca.crt
export PEER0_FM_CA=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/peers/peer0.FM.health-network.com/tls/ca.crt
export PEER0_EM_CA=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/EM.health-network.com/peers/peer0.EM.health-network.com/tls/ca.crt
export PEER0_P_CA=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/P.health-network.com/peers/peer0.P.health-network.com/tls/ca.crt

export FABRIC_CFG_PATH=${PWD}/../health-network/
export CHANNEL_NAME=mychannel
export PRIVATE_DATA_CONFIG=/opt/gopath/fabric-samples/health-network/config/collections_config.json




export CHANNEL_NAME="mychannel"
export CC_RUNTIME_LANGUAGE="node"
export VERSION="1"
export CC_SRC_PATH="/opt/gopath/fabric-samples/health-network/application/"
export CC_NAME="healthF"

packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    
    docker exec  -e "CORE_PEER_LOCALMSPID=FinanceMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/peers/peer0.FM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/users/Admin@FM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.FM.health-network.com:7051" -it cli  bash -c \
    "peer lifecycle chaincode package healthF.tar.gz \
        --path ${CC_SRC_PATH} --lang node \
        --label healthF_1 ;exit"    

    
    echo "===================== Chaincode is packaged on peer0.FM ===================== "
}

installChaincode() {

    docker exec  -e "CORE_PEER_LOCALMSPID=FinanceMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/peers/peer0.FM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/users/Admin@FM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.FM.health-network.com:7051" -it cli  bash -c \
    "peer lifecycle chaincode install healthF.tar.gz;exit"    
    echo "===================== Chaincode is installed on peer0.FM ===================== "


    docker exec -e "CORE_PEER_LOCALMSPID=HealthMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/HM.health-network.com/peers/peer0.HM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/HM.health-network.com/users/Admin@HM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.HM.health-network.com:7051"  -it cli  bash -c \
    "peer lifecycle chaincode install healthF.tar.gz;exit" 
    echo "===================== Chaincode is installed on peer0.HM ===================== "


    docker exec -e "CORE_PEER_LOCALMSPID=EquipementMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/EM.health-network.com/peers/peer0.EM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/EM.health-network.com/users/Admin@EM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.EM.health-network.com:7051"  cli  /bin/sh -c \
    "peer lifecycle chaincode install healthF.tar.gz;exit" 
    echo "===================== Chaincode is installed on peer0.EM ===================== "


    docker exec  -e "CORE_PEER_LOCALMSPID=PartnersMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/P.health-network.com/peers/peer0.P.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/P.health-network.com/users/Admin@P.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.P.health-network.com:7051" cli  /bin/sh -c \
    "peer lifecycle chaincode install healthF.tar.gz;exit" 
    echo "===================== Chaincode is installed on peer0.P ===================== "


}


queryInstalled() {
    
    docker exec  -e "CORE_PEER_LOCALMSPID=FinanceMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/peers/peer0.FM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/users/Admin@FM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.FM.health-network.com:7051" -it cli  bash -c \
    "peer lifecycle chaincode queryinstalled" > log.txt   

    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    
    echo "===================== Query installed successful on peer0.FM on channel ===================== "

        


}



approveForFM() {
    docker exec  -e "CORE_PEER_LOCALMSPID=FinanceMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/peers/peer0.FM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/users/Admin@FM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.FM.health-network.com:7051" -it cli  bash -c \
    "peer lifecycle chaincode approveformyorg -o orderer.health-network.com:7050 \
        --ordererTLSHostnameOverride orderer.health-network.com --tls \
        --collections-config $PRIVATE_DATA_CONFIG \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}; exit"    
    

    echo "===================== chaincode approved from FM ===================== "

}

approveForHM() {
    docker exec -e "CORE_PEER_LOCALMSPID=HealthMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/HM.health-network.com/peers/peer0.HM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/HM.health-network.com/users/Admin@HM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.HM.health-network.com:7051"  -it cli  bash -c \
    "peer lifecycle chaincode approveformyorg -o orderer.health-network.com:7050 \
        --ordererTLSHostnameOverride orderer.health-network.com --tls \
        --collections-config $PRIVATE_DATA_CONFIG \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}; exit"    
    

    echo "===================== chaincode approved from HM ===================== "

}

approveForEM() {
    docker exec -e "CORE_PEER_LOCALMSPID=EquipementMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/EM.health-network.com/peers/peer0.EM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/EM.health-network.com/users/Admin@EM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.EM.health-network.com:7051"  cli  /bin/sh -c \
    "peer lifecycle chaincode approveformyorg -o orderer.health-network.com:7050 \
        --ordererTLSHostnameOverride orderer.health-network.com --tls \
        --collections-config $PRIVATE_DATA_CONFIG \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}; exit"    
    

    echo "===================== chaincode approved from EM ===================== "

}
approveForP() {
    docker exec  -e "CORE_PEER_LOCALMSPID=PartnersMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/P.health-network.com/peers/peer0.P.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/P.health-network.com/users/Admin@P.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.P.health-network.com:7051" cli  /bin/sh -c \
    "peer lifecycle chaincode approveformyorg -o orderer.health-network.com:7050 \
        --ordererTLSHostnameOverride orderer.health-network.com --tls \
        --collections-config $PRIVATE_DATA_CONFIG \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}; exit"    
    

    echo "===================== chaincode approved from P ===================== "

}


checkCommitReadyness() {
    docker exec  -e "CORE_PEER_LOCALMSPID=FinanceMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/peers/peer0.FM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/users/Admin@FM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.FM.health-network.com:7051" -it cli  bash -c \
    "peer lifecycle chaincode checkcommitreadiness \
        --collections-config $PRIVATE_DATA_CONFIG \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required ; exit"
    
    echo "===================== checking commit readyness  ===================== "
}




commitChaincodeDefination() {
    docker exec  -e "CORE_PEER_LOCALMSPID=FinanceMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/peers/peer0.FM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/users/Admin@FM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.FM.health-network.com:7051" -it cli  bash -c \
    "peer lifecycle chaincode commit -o orderer.health-network.com:7050 --ordererTLSHostnameOverride orderer.health-network.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --collections-config $PRIVATE_DATA_CONFIG \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --peerAddresses peer0.HM.health-network.com:7051 --tlsRootCertFiles $PEER0_HM_CA \
        --peerAddresses peer0.FM.health-network.com:7051 --tlsRootCertFiles $PEER0_FM_CA \
        --peerAddresses peer0.EM.health-network.com:7051 --tlsRootCertFiles $PEER0_EM_CA \
        --peerAddresses peer0.P.health-network.com:7051 --tlsRootCertFiles $PEER0_P_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required; exit"

    echo "===================== chaincode commited  ===================== "

    
}


queryCommitted() {
    docker exec  -e "CORE_PEER_LOCALMSPID=FinanceMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/peers/peer0.FM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/users/Admin@FM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.FM.health-network.com:7051" -it cli  bash -c \
    "peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}; exit"
    
    echo "===================== query commited  ===================== "

}


chaincodeInvokeInit() {

    export myvar='{\"Args\":[\"instantiate\"]}'
    
    docker exec  -e "CORE_PEER_LOCALMSPID=FinanceMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/peers/peer0.FM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/users/Admin@FM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.FM.health-network.com:7051" -it cli  bash -c \
    "peer chaincode invoke -o orderer.health-network.com:7050 \
        --ordererTLSHostnameOverride orderer.health-network.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses peer0.HM.health-network.com:7051 --tlsRootCertFiles $PEER0_HM_CA \
        --peerAddresses peer0.FM.health-network.com:7051 --tlsRootCertFiles $PEER0_FM_CA \
        --peerAddresses peer0.EM.health-network.com:7051 --tlsRootCertFiles $PEER0_EM_CA \
        --peerAddresses peer0.P.health-network.com:7051 --tlsRootCertFiles $PEER0_P_CA \
        --isInit -c $myvar "

    echo "===================== invoke init  ===================== "

}



packageChaincode
installChaincode
queryInstalled
approveForFM
approveForHM
approveForEM
approveForP
checkCommitReadyness
commitChaincodeDefination
queryCommitted

chaincodeInvokeInit
sleep 5
