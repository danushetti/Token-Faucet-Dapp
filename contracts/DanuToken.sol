//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// Max supply of DanuToken will never exceed 100_000_000
// The person to deploy this contract will be considered the 'Creator' of DanuToken
// And he will get 70% of the total supply of DanuToken as a reward
// i.e. 70_000_000 DanuToken(s)
// Moreover, he will also get the control over the withdrawal rate of the faucet
// One DanuToken can be divided into 18 smaller values because it has 18 decimal values
// The miner/validator who includes a transaction of this contract will also receive 
// some DanuToken(s) as `block reward`, which can be updated by the creator 
// whenever he wants. Block reward is initially set to 50 tokens
// The creator will also have the option to 'destroy' the DanuToken contract

contract DanuToken is ERC20Capped, ERC20Burnable {
    address payable public owner;
    uint256 public blockReward;

    constructor(uint256 cap)
        ERC20("DanuToken", "DANU")
        ERC20Capped(cap * (10**decimals()))
    {
        owner = payable(msg.sender);
        //we are assigning all of the initial supply to msg.sender

        //we can use this pattern of writing 10**decimals  througout our code
        //to take the place of the 18 zeros that we normally would have to type out
        //so this will give us the 70 million + 18 decimals
        _mint(msg.sender, 70000000 * (10**decimals()));
        blockReward = 50 * (10**decimals());
    }

    // Overriding the _mint functions from ER20Capped and ERC20
    function _mint(address account, uint256 amount)
        internal
        virtual
        override(ERC20Capped, ERC20)
    {
        require(
            ERC20.totalSupply() + amount <= cap(),
            "DanuToken: cap exceeded"
        );
        super._mint(account, amount);
    }

    //block reward includes, _beforeTokenTransfer, _mintMinerReward
    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        if (
            from != address(0) &&
            to != block.coinbase &&
            block.coinbase != address(0)
        ) {
            _mintMinerReward();
        }
        super._beforeTokenTransfer(from, to, value);
    }

    function setBlockReward(uint256 reward) public onlyOwner{
        blockReward = reward * (10**decimals());
    }

    function destroy() public onlyOwner {
        selfdestruct(owner);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only the owner can call this function");
        _;
    }
}
