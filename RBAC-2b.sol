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
    function transfer(address _receipient, uint256 _amount) external returns(bool);

    function totalSupply() external returns(uint256);

    function balanceOf(address owner) external returns(uint256);
}

contract StandardToken is IToken {
    using SafeMath for uint256;
    
    // state variables
    address public _owner;
    mapping (address => uint256) public  _balances;
    uint256 _totalSupply;
    string _name;
    string _symbol;
    
    constructor () public {
        _owner = msg.sender;
        _name = "yorkcoin";
        _symbol = "yc";
        _totalSupply = 1000;
    }
    
    function mint(address owner, uint256 amount) public {
        require(msg.sender == _owner, "Unauthorized");

        _totalSupply = _totalSupply.add(amount);
        _balances[owner] = _balances[owner].add(amount);
    }
    
    function transfer(address _receipient, uint256 _amount) public override returns (bool) {
         require(msg.sender == _owner, "Unauthorized");
        _balances[_owner] = _balances[_owner].sub(_amount);
        _balances[_receipient] = _balances[_receipient].add(_amount);
        return true;
    }
    
    function balanceOf(address owner) public override returns (uint256) {
        return _balances[owner];
    }
    
    function totalSupply() public override returns (uint256) {
        return _totalSupply;
    }
}