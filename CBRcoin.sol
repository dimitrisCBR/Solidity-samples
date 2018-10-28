pragma solidity ^0.4.21;

contract CBRcoin {

string name;
string symbol;

//total supply of coins
uint256 totalSupplyInt;
//map account -> balance
mapping (address => uint256) accountBalanceMap;

//create the coins initial owner
constructor(uint256 _totalSupply, string _name, string _symbol) public {
    totalSupplyInt = _totalSupply;
    name = _name;
    symbol = _symbol;
    accountBalanceMap[msg.sender] = _totalSupply;
}

function totalSupply() public view returns (uint256 ) {
    return totalSupplyInt;
}

function balanceOf(address _owner) public view returns (uint256 ) {
    return accountBalanceMap[_owner];
}

function transfer(address _to, uint256 _value) public returns (bool){ 
    require(_to != 0x0);
    require(accountBalanceMap[msg.sender] >= _value);
    require(accountBalanceMap[_to] + _value > accountBalanceMap[_to]);
    accountBalanceMap[msg.sender] -= _value;
    accountBalanceMap[_to] += _value;
    emit Transfer(msg.sender,_to,_value);
    return true;
}

event Transfer(address indexed _from, address indexed _to, uint256 _value);
        
}

