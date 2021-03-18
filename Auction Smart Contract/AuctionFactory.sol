// SPDX-License-Identifier: MIT

pragma solidity ^0.6.10;

import { Auction } from './Auction.sol';

contract AuctionFactory {
    address[] public auctions;

    function allAuctions() public returns (address[] memory) {
        return auctions;
    }
    
    function createAuction(uint bidIncrement, uint startBlock, uint endBlock) public {
        Auction newAuction = new Auction(msg.sender, bidIncrement, startBlock, endBlock);
        auctions.push(address(newAuction));

        emit AuctionCreated(address(newAuction), msg.sender);
    }

    event AuctionCreated(address auctionContract, address owner);
}