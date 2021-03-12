// SPDX-License-Identifier: MIT

pragma solidity ^0.6.10;

contract Greeter {
    // state variables
    string public greeting;
    address public creator;
    
    constructor(string memory _message) public {
        creator = msg.sender;
        greeting = _message;
    }

    function setGreeting(string memory _greeting) public {
        require(msg.sender == creator, "Unauthorized");
        greeting = _greeting;
    }
    
    function getAll() public view returns(string memory, address) {
        return (greeting, creator);
    }
}