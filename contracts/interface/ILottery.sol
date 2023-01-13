//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ILottery {
    //-------------------------------------------------------------------------
    // STATE MODIFYING FUNCTIONS
    //-------------------------------------------------------------------------
    function onEachRound(
        uint256 _lotteryId,
        uint256 _requestId,
        uint256[] memory _randomNumbers
    ) external;

    function getTokenStatus(uint256 tokenId) external view returns (bool);

    function isWinner(uint256 tokenId) external view returns (bool);
}
