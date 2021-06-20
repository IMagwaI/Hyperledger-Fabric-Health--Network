export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../health-network/crypto-config/ordererOrganizations/health-network.com/orderers/orderer.health-network.com/msp/tlscacerts/tlsca.health-network.com-cert.pem
export PEER0_HM_CA=${PWD}/../health-network/crypto-config/peerOrganizations/HM.health-network.com/peers/peer0.HM.health-network.com/tls/ca.crt
export PEER0_FM_CA=${PWD}/../health-network/crypto-config/peerOrganizations/FM.health-network.com/peers/peer0.FM.health-network.com/tls/ca.crt
export PEER0_EM_CA=${PWD}/../health-network/crypto-config/peerOrganizations/EM.health-network.com/peers/peer0.EM.health-network.com/tls/ca.crt
export PEER0_P_CA=${PWD}/../health-network/crypto-config/peerOrganizations/P.health-network.com/peers/peer0.P.health-network.com/tls/ca.crt

export FABRIC_CFG_PATH=${PWD}/../config/
export CHANNEL_NAME=mychannel



CHANNEL_NAME="mychannel"
CC_RUNTIME_LANGUAGE="node"
VERSION="1"
CC_SRC_PATH="./finance-ministry/contract"
CC_NAME="healthF"

packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    
    docker exec  -e "CORE_PEER_LOCALMSPID=FinanceMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/peers/peer0.FM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/users/Admin@FM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.FM.health-network.com:7051" -it cli  bash -c \
    "peer lifecycle chaincode package healthF.tar.gz \
        --path /opt/gopath/fabric-samples/health-network/application/finance-ministry/contract --lang node \
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



}


queryInstalled() {
    
    docker exec  -e "CORE_PEER_LOCALMSPID=FinanceMinistryMSP" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/peers/peer0.FM.health-network.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/fabric-samples/health-network/crypto-config/peerOrganizations/FM.health-network.com/users/Admin@FM.health-network.com/msp" -e "CORE_PEER_ADDRESS=peer0.FM.health-network.com:7051" -it cli  bash -c \
    "peer lifecycle chaincode queryinstalled > log.txt ;cat log.txt; exit"    

    #PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    #echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.FM on channel ===================== "
}

# queryInstalled

# --collections-config ./artifacts/private-data/collections_config.json \
#         --signature-policy "OR('Org1MSP.member','Org2MSP.member')" \
# --collections-config $PRIVATE_DATA_CONFIG \

approveForMyOrg1() {
    setGlobalsForPeer0Org1
    # set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --collections-config $PRIVATE_DATA_CONFIG \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}
    # set +x

    echo "===================== chaincode approved from org 1 ===================== "

}

getBlock() {
    setGlobalsForPeer0Org1
    # peer channel fetch 10 -c mychannel -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com --tls \
    #     --cafile $ORDERER_CA

    peer channel getinfo  -c mychannel -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --cafile $ORDERER_CA
}

# getBlock

# approveForMyOrg1

# --signature-policy "OR ('Org1MSP.member')"
# --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA
# --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles $PEER0_ORG2_CA
#--channel-config-policy Channel/Application/Admins
# --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer')"

checkCommitReadyness() {
    setGlobalsForPeer0Org1
    peer lifecycle chaincode checkcommitreadiness \
        --collections-config $PRIVATE_DATA_CONFIG \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness

# --collections-config ./artifacts/private-data/collections_config.json \
# --signature-policy "OR('Org1MSP.member','Org2MSP.member')" \
approveForMyOrg2() {
    setGlobalsForPeer0Org2

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --collections-config $PRIVATE_DATA_CONFIG \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}

    echo "===================== chaincode approved from org 2 ===================== "
}

# approveForMyOrg2

checkCommitReadyness() {

    setGlobalsForPeer0Org1
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --collections-config $PRIVATE_DATA_CONFIG \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness

commitChaincodeDefination() {
    setGlobalsForPeer0Org1
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --collections-config $PRIVATE_DATA_CONFIG \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required

}

# commitChaincodeDefination

queryCommitted() {
    setGlobalsForPeer0Org1
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}

}

# queryCommitted

chaincodeInvokeInit() {
    setGlobalsForPeer0Org1
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --isInit -c '{"Args":[]}'

}

# chaincodeInvokeInit

chaincodeInvoke() {
    # setGlobalsForPeer0Org1
    # peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
    # --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} \
    # --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    # --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA  \
    # -c '{"function":"initLedger","Args":[]}'

    setGlobalsForPeer0Org1

    ## Create Car
    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME}  \
    #     --peerAddresses localhost:7051 \
    #     --tlsRootCertFiles $PEER0_ORG1_CA \
    #     --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA   \
    #     -c '{"function": "createCar","Args":["Car-ABCDEEE", "Audi", "R8", "Red", "Pavan"]}'

    ## Init ledger
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"function": "initLedger","Args":[]}'

    ## Add private data
    export CAR=$(echo -n "{\"key\":\"1111\", \"make\":\"Tesla\",\"model\":\"Tesla A1\",\"color\":\"White\",\"owner\":\"pavan\",\"price\":\"10000\"}" | base64 | tr -d \\n)
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"function": "createPrivateCar", "Args":[]}' \
        --transient "{\"car\":\"$CAR\"}"
}

# chaincodeInvoke

chaincodeQuery() {
    setGlobalsForPeer0Org2

    # Query all cars
    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["queryAllCars"]}'

    # Query Car by Id
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryCar","Args":["CAR0"]}'
    #'{"Args":["GetSampleData","Key1"]}'

    # Query Private Car by Id
    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "readPrivateCar","Args":["1111"]}'
    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "readCarPrivateDetails","Args":["1111"]}'
}

# chaincodeQuery

# Run this function if you add any new dependency in chaincode
# presetup

packageChaincode
installChaincode
queryInstalled
#approveForMyOrg1
#checkCommitReadyness
#approveForMyOrg2
#checkCommitReadyness
#commitChaincodeDefination
#queryCommitted
#chaincodeInvokeInit
#sleep 5
#chaincodeInvoke
#sleep 3
#chaincodeQuery