// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AFLJackpot {
    address payable public devAddress;
    address payable public consolationAddress;

    uint256 public mainPool;
    uint256 public devTotal;
    uint256 public consolationTotal;

    constructor(address payable _dev,address payable _consolation){
        devAddress=_dev;
        consolationAddress=_consolation;
    }

    function receiveFunds() external payable {
        require(msg.value == 0.05 ether, 'Must send 0.05 ETH');

        uint256 mainAmount = 0.03 ether;
        uint256 consolationAmount = 0.01 ether;
        uint256 devAmount = 0.01 ether;

        mainPool += mainAmount;
        consolationTotal += consolationAmount;
        devTotal += devAmount;

        (bool sentDev,) = devAddress.call{value: devAmount}("");
        require(sentDev,'Dev transfer failed');

        (bool sentCon,) = consolationAddress.call{value: consolationAmount}("");
        require(sentCon,'Consolation transfer failed');
    }
}
