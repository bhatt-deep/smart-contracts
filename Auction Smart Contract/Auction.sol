// SPDX-License-Identifier: MIT

pragma solidity ^0.6.10;


interface IAuction {
    function placeBid() payable external returns (bool);
    function withdraw() external returns (bool);
    function cancelAuction() external  returns (bool);
}

contract Auction is IAuction{
    // state variables
    address public owner;
    uint256 public bidIncrement;
    uint256 public startBlock;
    uint256 public endBlock;
    bool public canceled;
    uint256 public highestBindingBid;
    address public highestBidder;
    mapping(address => uint256) public fundsByBidder;
    bool ownerHasWithdrawn;
    
    constructor (address _owner, uint256 _bidIncrement, uint256 _startBlock, uint256 _endBlock) public {
	    owner = _owner;
        bidIncrement = _bidIncrement;
        startBlock = _startBlock;
        endBlock = _endBlock;
    }
    
    function min256(uint256 a, uint256 b) internal pure returns (uint256) {
    return a < b ? a : b;
    }
     
    event LogBid(address bidder, uint bid, address highestBidder, uint highestBid, uint highestBindingBid);
    
    event LogWithdrawal(address withdrawer, address withdrawalAccount, uint amount);
    
    event LogCanceled();
    
    function placeBid() public override payable
    onlyAfterStart 
    onlyBeforeEnd 
    onlyNotCancelled 
    onlyNotOwner 
    returns (bool success) {
    // logic goes here
    // only accept non zero payments
        if (msg.value == 0) {revert();}

        // add the bid sent to make total amount of the bidder            
        uint256 newBid = fundsByBidder[msg.sender] + msg.value;

        // user must send the bid amount greater than equal to 
        // highestBindingBid.
        if (newBid <= highestBindingBid) {revert();}

        // get the bid amount of highestBidder .
        uint256 highestBid = fundsByBidder[highestBidder];

        fundsByBidder[msg.sender] = newBid;

        if (newBid <= highestBid) {
            // Increase the highestBindingBid if the user has 
            // overbid the highestBindingBid but not highestBid. 
            // leave highestBidder alone

            highestBindingBid = min256(newBid + bidIncrement, highestBid);
        } else {            
            // Make the new user highestBidder
            // if it has overbid highestBid completely

            if (msg.sender != highestBidder) {
                highestBidder = msg.sender;
                highestBindingBid = min256(newBid, highestBid + bidIncrement);
            }
            highestBid = newBid;
        }

        emit LogBid(msg.sender, newBid, highestBidder, highestBid, highestBindingBid);
        return true;
    }
    
    
    function withdraw() public override
        onlyEndedOrCanceled
        returns (bool success)
    {
        address withdrawalAccount;
        uint256 withdrawalAmount;

        if (canceled) {
            // let everyone allow to withdraw if auction is cancelled
            withdrawalAccount = msg.sender;
            withdrawalAmount = fundsByBidder[withdrawalAccount];

        } else {
            // this logic will execute if auction finished
            // without getting cancelled
            if (msg.sender == owner) {
                // allow auction’s owner to withdraw 
                // highestBindingbid
                withdrawalAccount = highestBidder;
                withdrawalAmount = highestBindingBid;
                ownerHasWithdrawn = true;

            } else if (msg.sender == highestBidder) {
                // the highest bidder should only be allowed to 
                // withdraw the excess bid which is difference 
                // between highest bid and the highestBindingBid
                withdrawalAccount = highestBidder;
                if (ownerHasWithdrawn) {
                    withdrawalAmount = fundsByBidder[highestBidder];
                } else {
                    withdrawalAmount = fundsByBidder[highestBidder] - highestBindingBid;
                }

            } else {
                // the bidders who do not win highestBid are allowed
                // to withdraw their full amount
                withdrawalAccount = msg.sender;
                withdrawalAmount = fundsByBidder[withdrawalAccount];
            }
        }

        if (withdrawalAmount == 0) {revert();}

        fundsByBidder[withdrawalAccount] -= withdrawalAmount;

        // transfer the withdrawal amount
        if (!msg.sender.send(withdrawalAmount)) {revert();}

        emit LogWithdrawal(msg.sender, withdrawalAccount, withdrawalAmount);

        return true;
    }
    
    function cancelAuction() public override
        onlyOwner
        onlyBeforeEnd
        onlyNotCancelled
        returns (bool success)
    {
        canceled = true;
        LogCanceled();
        return true;
    }
    
    modifier onlyEndedOrCanceled {
             require(block.number < endBlock && !canceled);
             _;
    }
    
     modifier onlyOwner {
        if (msg.sender != owner){
             _;
        }
    }
    
    modifier onlyNotOwner {
        if (msg.sender == owner){
             _;
        }
    }
    
    modifier onlyBeforeEnd {
        if (block.number > endBlock){
             _;
        }
    }
    
     modifier onlyNotCancelled {
        if (canceled){
             _;
        }
    }
    
    modifier onlyAfterStart {
        if (block.number < startBlock) {
             _;
        }
    }
    
    
}