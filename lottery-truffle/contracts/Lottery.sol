// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract Lottery {
    address public owner;
    address payable[] public players; // 입출금을 위한 payable
    uint256 public lotteryId;
    mapping(uint256 => address) public lotteryHistory;

    constructor() {
        owner = msg.sender;
    }

    // 입금된 금액 반환
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 플레이어 목록 반환, player는 storage에 저장된 값이므로 memory로 설정한 뒤 반환
    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    // 사용자 참가, 입출금을 위한 payable 설정
    function enter() public payable {
        require(msg.value >= .01 ether, "msg.value should be greater than or equal to 0.01 ether");
        players.push(payable(msg.sender));
    }

    // 랜덤값 반환 - 블록 내부의 값을 이용한 랜덤값 생성, 안전하지 않음
    function getRandomNumberV1() public view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    // 승자 선정
    function pickWinner() public onlyOwner {
        uint256 index = getRandomNumberV1() % players.length;

        // reentrancy attack을 방지하기 위해 다른 contract 호출 전 상태 변경을 진행해야 한다.
        // Checks-Effects-Interactions Pattern
        lotteryHistory[lotteryId] = players[index];
        lotteryId++;

        (bool success, ) = players[index].call{value: address(this).balance}("");
        require (success, "Failed to send Ether");

        players = new address payable[](0);
    }

    // 승자 선정 함수 호출 조건 설정 - 코드 반복을 제거하기 위해 modifier 사용, require와 거의 동일
    modifier onlyOwner {
        require(msg.sender == owner, "you're not owner");
        _;
    }
}

