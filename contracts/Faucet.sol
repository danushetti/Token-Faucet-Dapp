//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//interface is like a blue print,
//has all the functions that are available on erc20 contract
//allow one contract talk to another contract
//we only define the functions that we need to use
interface IERC20{
   function transfer(address to, uint256 amount)external view returns (bool);
   function balanceOf(address accouunt) external view returns(uint256);
   event Transfer(address indexed from, address indexed to, uint256 value);
}

//this contract contains pre-loaded erc20 tokens
contract Faucet{
  // we are to call the interface by passing in the address of thecontract we want to represent
  // that will create local instance of the contrtact with which we can call methods 

  address payable owner;
  IERC20 public token;
  uint public withdrawlAmount = 50 * (10**18);
  uint public lockTime = 1 minutes;

  // indexed: we can search by these parameter names in event logs
  event Deposit(address indexed from, uint256 indexed amount);
  event WithDrawl(address indexed to, uint256 indexed amount);
  mapping(address => uint256) nextAccessTime;

  constructor(address tokenAddress) payable{
    token= IERC20(tokenAddress);
    owner= payable(msg.sender);
  }

  function requestTokens() public {
    require(msg.sender!= address(0), "not a valid acccount");
    require(token.balanceOf(address(this))>withdrawlAmount,"insufficient balance");
    require(block.timestamp>=nextAccessTime[msg.sender], "Insufficient TimeElapse since last withdrawl");
    token.transfer(msg.sender, withdrawlAmount);
    nextAccessTime[msg.sender]=block.timestamp+lockTime;
  }

  receive() external payable{
    emit Deposit(msg.sender, msg.value);
  }

  function getBalance() external view returns (uint256){
    return token.balanceOf(address(this));
  }

  function setwithdrawlAmount(uint256 amount) external onlyOwner{
    withdrawlAmount= amount * (10**18);
  }

  function setlockTime(uint256 time) external onlyOwner{
    lockTime= time * 1 minutes;
  }

  function withdrawl() external onlyOwner{
    emit WithDrawl(msg.sender, token.balanceOf(address(this)));
    token.transfer(msg.sender, token.balanceOf(address(this)));
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "only the owner can call this function");
    _;
  }
}