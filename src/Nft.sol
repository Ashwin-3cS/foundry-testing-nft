// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract QodoNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public constant MINT_PRICE = 0.01 ether;
    uint256 public constant MAX_SUPPLY = 1000;

    constructor() ERC721("QodoNFT", "QNFT") Ownable(msg.sender) {}

    function mint() public payable returns (uint256) {
        require(msg.value >= MINT_PRICE, "Insufficient payment");
        require(_tokenIds.current() < MAX_SUPPLY, "Max supply reached");

        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _safeMint(msg.sender, newTokenId);

        return newTokenId;
    }

    function burn(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "Not token owner");
        _burn(tokenId);
    }

    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
