// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract QodoToken is ERC20, Ownable {
    uint256 public constant INITIAL_SUPPLY = 1000000 * 10 ** 18; // 1 million tokens
    uint256 public burnLimit = 100000 * 10 ** 18; // 100,000 tokens

    constructor() ERC20("QodoToken", "QDT") Ownable(msg.sender) {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        require(amount <= burnLimit, "Cannot burn more than burn limit");
        _burn(msg.sender, amount);
    }

    function setBurnLimit(uint256 newLimit) public onlyOwner {
        burnLimit = newLimit;
    }
}
