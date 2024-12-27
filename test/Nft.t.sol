// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../lib/openzeppelin-contracts/lib/forge-std/src/Test.sol";
import "../src/Nft.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/draft-IERC6093.sol"; // This contains the errors
import "../lib/openzeppelin-contracts/lib/forge-std/src/console.sol"; // This contains the errors;

contract NFTTest is Test {
    QodoNFT public nft;
    address public owner;
    address public user1;
    address public user2;

    function setUp() public {
        owner = payable(address(this));
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");

        nft = new QodoNFT();

        vm.deal(user1, 100 ether);
        vm.deal(user2, 100 ether);
    }

    function testMint() public {
        vm.prank(user1);
        uint256 tokenId = nft.mint{value: 0.01 ether}();
        assertEq(tokenId, 1);
        assertEq(nft.ownerOf(1), user1);
    }

    function test_RevertWhen_InsufficientPayment() public {
        vm.expectRevert("Insufficient payment");
        vm.prank(user1);
        nft.mint{value: 0.009 ether}();
    }

    function test_RevertWhen_MaxSupplyReached() public {
        for (uint i = 0; i < 1000; i++) {
            vm.prank(user1);
            nft.mint{value: 0.01 ether}();
        }

        vm.expectRevert("Max supply reached");
        vm.prank(user1);
        nft.mint{value: 0.01 ether}();
    }

    function testBurn() public {
        vm.prank(user1);
        uint256 tokenId = nft.mint{value: 0.01 ether}();

        vm.prank(user1);
        nft.burn(tokenId);

        // Log that burn happened
        console.log("Token", tokenId, "was burned");

        // Just expect any revert
        vm.expectRevert();
        nft.ownerOf(tokenId);
    }

    function test_RevertWhen_NotTokenOwner() public {
        vm.prank(user1);
        uint256 tokenId = nft.mint{value: 0.01 ether}();

        vm.expectRevert("Not token owner");
        vm.prank(user2);
        nft.burn(tokenId);
    }

    function testWithdraw() public {
        vm.prank(user1);
        nft.mint{value: 0.01 ether}();

        assertEq(address(nft).balance, 0.01 ether);

        uint256 initialBalance = address(owner).balance;
        nft.withdraw();

        assertEq(address(nft).balance, 0);
        assertEq(address(owner).balance, initialBalance + 0.01 ether);
    }

    function test_RevertWhen_WithdrawNotOwner() public {
        vm.prank(user1);
        nft.mint{value: 0.01 ether}();

        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                user1
            )
        );
        vm.prank(user1);
        nft.withdraw();
    }

    receive() external payable {}
}
