//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./FundMe.sol";

contract FundTokenERC20 is ERC20 {
    FundMe fundMe;
    constructor(address fundMeAddr) ERC20("DonutBai", "DB") {
        fundMe = FundMe(fundMeAddr);
    }

    function mint(uint256 amountToMint) public fundSuccess {
        require(fundMe.fundersToAmount(msg.sender) >= amountToMint, "You can't mint this many tokens");
        _mint(msg.sender, amountToMint);
        fundMe.setFunderToAmount(msg.sender, fundMe.fundersToAmount(msg.sender) - amountToMint);
    }

    function claim(uint256 amountToClaim) public fundSuccess {
        require(balanceOf(msg.sender) >= amountToClaim, "You don't have enough tokens to claim");
        _burn(msg.sender, amountToClaim);
    }

    modifier fundSuccess() {
        require(fundMe.getFundSuccess(), "The fundme isn't completed yet");
        _;
    }
}