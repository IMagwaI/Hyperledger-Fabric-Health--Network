[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

# intra-ministerial blockchain (hyperledger fabric 2)

## architecture

<img width="964" alt="arch" src="https://raw.githubusercontent.com/IMagwaI/Hyperledger-Fabric-Health--Network/main/images/paper.png">

## install prerequisites
before we run our project we must add hyperledger fabric binarie files and copy the bin folder to our project
for more information check the link bellow 
https://hyperledger-fabric.readthedocs.io/en/release-2.2/install.html

## to run the network
we navigate to fabric-samples/application folder then we run the script
```sh
./startFabric.sh
```
the script will create the network, setup the channel and deploy the chaincode

chaincode --> fabric-samples/health-network/application  folder 
NB: dont forget to run "npm install"
 
[contributors-shield]: https://img.shields.io/github/contributors/IMagwaI/Hyperledger-Fabric-Health--Network.svg?style=for-the-badge
[contributors-url]: https://github.com/IMagwaI/Hyperledger-Fabric-Health--Network/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/IMagwaI/Hyperledger-Fabric-Health--Network.svg?style=for-the-badge
[forks-url]: https://github.com/IMagwaI/Hyperledger-Fabric-Health--Network/network/members
[stars-shield]: https://img.shields.io/github/stars/IMagwaI/Hyperledger-Fabric-Health--Network.svg?style=for-the-badge
[stars-url]: https://github.com/IMagwaI/Hyperledger-Fabric-Health--Network/stargazers
[issues-shield]: https://img.shields.io/github/issues/IMagwaI/Hyperledger-Fabric-Health--Network.svg?style=for-the-badge
[issues-url]: https://github.com/IMagwaI/Hyperledger-Fabric-Health--Network/issues
[license-shield]: https://img.shields.io/github/license/IMagwaI/Hyperledger-Fabric-Health--Network.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt

