// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract Lottery {
    address public owner;
    address payable[] public players; // 입출금을 위한 payable

    constructor() {
        owner = msg.sender;
    }

    // 입금된 금액 반환
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 사용자 참가, 입출금을 위한 payable 설정
    function enter() public payable {
        require(msg.value >= .01 ether, "msg.value should be greater than or equal to 0.01 ether");
        players.push(payable(msg.sender));
    }
}

