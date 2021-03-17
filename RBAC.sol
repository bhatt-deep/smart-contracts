// SPDX-License-Identifier: MIT

pragma solidity ^0.6.10;


contract Rbac {
    // state variables
    address public owner;
    mapping (address => uint256) public balances;
    mapping (address => bool) public blacklisted;
    
    constructor() public{
        owner = msg.sender;
        balances[owner] = 1000;
        blacklisted[owner] = false;
    } 
    
    modifier not_blacklisted {
        if (blacklisted[owner]){
             _;
        }
       
    }
    
    modifier at_least(uint256 x) {
        if (balances[owner] < x){
             _;
        }
       
    }
    
    function blacklist() public {
        blacklisted[owner] = true;
    }
    
    function transfer(address _dest, uint256 _amount) public not_blacklisted at_least(_amount) {
        balances[owner] -= _amount;
        balances[_dest] += _amount;
    }
    
    
}