// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract QodoNFT is ERC721, Ownable {
    uint256 private _currentTokenId;

    uint256 public constant MINT_PRICE = 0.01 ether;
    uint256 public constant MAX_SUPPLY = 1000;

    constructor() ERC721("QodoNFT", "QNFT") Ownable(msg.sender) {}

    function mint() public payable returns (uint256) {
        require(msg.value >= MINT_PRICE, "Insufficient payment");
        require(_currentTokenId < MAX_SUPPLY, "Max supply reached");

        _currentTokenId += 1;
        _safeMint(msg.sender, _currentTokenId);

        return _currentTokenId;
    }

    function burn(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "Not token owner");
        _burn(tokenId);
    }

    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
