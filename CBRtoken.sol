pragma solidity ^0.4.21;
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract CBRcoin is Ownable {

string name;
string symbol;

//
uint8 decimals = 18;
//total supply of coins
uint256 totalSupplyInt;
//transaction limit
uint256 transactionLimit;
//map account -> balance
mapping (address => uint256) accountBalanceMap;
mapping (address => bool) whiteList;
mapping (address => mapping (address => uint256)) public allowanceMap;

//create the coins initial owner
constructor(uint256 _initialSupply, string _name, string _symbol) public {
    totalSupplyInt = _initialSupply * 10 * uint256(decimals);
    name = _name;
    symbol = _symbol;
    accountBalanceMap[msg.sender] = totalSupplyInt;
}

 //it's pointless, but a good example of modifier.
 //Do not allow a transaction that sends all tokens from an account
 modifier isNotTooMuch(uint256 _amount) {
        if(accountBalanceMap[msg.sender] > _amount ) {
            _;
        }
}

 modifier whiteListed(address _sender) {
        if(whiteList[msg.sender] == false ) {
            _;
        }
}

function totalSupply() public view returns (uint256 ) {
    return totalSupplyInt;
}

function balanceOf(address _owner) public view returns (uint256 ) {
    return accountBalanceMap[_owner];
}

function setTransactionLimit(uint256 _limit) public onlyOwner() {
    transactionLimit = _limit;
    emit TransactionLimitUpdate(transactionLimit);
}

//private transfer function with all the necessary checks
function _transfer(address _from, address _to, uint256 _value) private returns (bool) {
    require(_to != 0x0);
    require(accountBalanceMap[_from] >= _value);
    require(accountBalanceMap[_to] + _value > accountBalanceMap[_to]);
    accountBalanceMap[_from] -= _value;
    accountBalanceMap[_to] += _value;
    emit Transfer(_from,_to,_value);
    return true;
}

//public transfer from sender to target
function transfer(address _to, uint256 _value) public isNotTooMuch(_value) returns (bool){ 
    _transfer(msg.sender,_to,_value);
    return true;
}

function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    _transfer(_from,_to,_value);
    return true;
}

function approve(address _spender, uint256 _value) public returns (bool success) {
    allowanceMap[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
}

function allowance(address _from, address _to) public view returns (uint256) {
    return allowanceMap[_from][_to];
}

event Transfer(address indexed _from, address indexed _to, uint256 _value);

event Approval(address indexed _owner, address indexed _spender, uint256 _value);

// This generates a public event on the blockchain that will notify clients
event TransactionLimitUpdate(uint256 newLimit);

    
}

