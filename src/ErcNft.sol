// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CombinedToken is ERC20, ERC721, Ownable {
    uint256 private _nextTokenId;

    // ERC-20 Constructor
    constructor() ERC20("MyToken", "MTK") ERC721("MyNFT", "MNFT") {}

    // ERC-20 Mint
    function mintERC20(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // ERC-721 Mint
    function mintNFT(address to) external onlyOwner {
        _safeMint(to, _nextTokenId);
        _nextTokenId++;
    }

    // ERC-20 Burn
    function burnERC20(address from, uint256 amount) external {
        _burn(from, amount);
    }

    // ERC-721 Burn
    function burnNFT(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        _burn(tokenId);
    }

    // Transfer NFT (overrides from ERC721)
    function transferNFT(address from, address to, uint256 tokenId) external {
        safeTransferFrom(from, to, tokenId);
    }
}
