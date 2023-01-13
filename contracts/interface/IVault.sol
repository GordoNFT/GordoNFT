//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVault {
    function setWinners(uint256[] memory _winners) external;

    function sendRewards() external;
}
