// SPDX-License-Identifier: MIT

pragma solidity ^0.6.10;

library SafeMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 z = x + y;
        require(z >= x, "uint overflow");

        return z;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }
}

interface IToken{
    function transfer(address _receipient, uint256 __amount) external returns(bool);

    function totalSupply() external returns(uint256);

    function balanceOf(address _owner) external returns(uint256);
}

contract StandardToken {
    using SafeMath for uint256;
    
    // state variables
    mapping (address => uint256) public  _balances;
    uint256 _totalSupply;
    string memory _name;
    string memory _symbol;
    
    constructor() public{
        _name = yorkcoin;
        _symbol = yc;
        _totalSupply = 10000;
    }
    
    
}