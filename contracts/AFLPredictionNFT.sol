// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract AFLPredictionNFT is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;
    address payable public jackpotContract;

    struct Prediction {
        string first;
        string tenth;
        string last;
    }

    mapping(uint256 => Prediction) public predictions;

    constructor(address payable _jackpotContract)
        ERC721('AFL Prediction NFT', 'AFLP')
        Ownable(msg.sender)
    {
        tokenCounter = 1;
        jackpotContract = _jackpotContract;
    }

    function mintPrediction(
        string memory _first,
        string memory _tenth,
        string memory _last,
        string memory _tokenURI
    ) external payable returns (uint256) {
        require(msg.value == 0.05 ether, 'Send 0.05 ETH');

        uint256 tokenId = tokenCounter;

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        predictions[tokenId] = Prediction(_first,_tenth,_last);

        tokenCounter += 1;

        (bool sent,) = jackpotContract.call{value: msg.value}("");
        require(sent,'Transfer failed');

        return tokenId;
    }
}
