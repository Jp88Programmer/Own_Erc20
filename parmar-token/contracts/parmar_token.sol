// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/ERC20.sol)
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract ParmarToken is ERC20 {
    address payable public owner;
    uint256 public blockReward;

    constructor(uint256 maxSupply,uint256 reward) ERC20("Parmar", "PAR") ERC20Capped(maxSupply * 10 ** decimals()){
        owner = payable(msg.sender);
        _mint(owner, (maxSupply * 10 ** decimals() * 60) / 100 );
        blockReward = reward * (10 ** decimals());
    }

    function _mint(address account, uint256 amount) internal virtual override(ERC20Capped, ERC20) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override{
        if(from != address(0) && to != address(0) && to != block.coinbase && block.coinbase != address(0) && ERC20.totalSupply() + blockReward <= cap()){
            _mintMinerReward();
        }
        super._beforeTokenTransfer(from,to,amount);
    }

    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward = reward * (10 ** decimals());
    }

    function destroy() public onlyOwner {
        selfdestruct(owner);
    }

    modifier onlyOwner{
        require(msg.sender == owner,"Only the owner can call this function");
        _;
    }

}
