//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRandomGenerator {
    function getRequestStatus(uint256 _requestId)
        external
        view
        returns (
            uint256 paid,
            bool fulfilled,
            uint256[] memory randomWords
        );

    function requestRandomWords(uint256 lotteryId)
        external
        returns (uint256 requestId);
}
