// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract Lottery {
    address public owner;
    address payable[] public players; // 입출금을 위한 payable

    constructor() {
        owner = msg.sender;
    }

    // 입출금을 위한 payable
    function enter() payable public {
        require(msg.value >= .01 ether, "msg.value should be greater than or equal to 0.01 ether");
        players.push(payable(msg.sender));
    }
}

