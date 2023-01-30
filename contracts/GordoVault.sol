//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./libraries/TransferHelper.sol";
import "./interface/ISwapper.sol";
import "./interface/IWETH.sol";
import "./interface/AggregatorV3Interface.sol";

// MATIC/ETH price oracle 0x327e23A4855b6F663a28c5161541d69Af8973302

contract GordoVault is Ownable {
    using SafeMath for uint256;
    address private teamAddress;
    uint256 private teamPercent;
    uint256[] public winners;
    uint256 constant MAX_PERCENT = 1000000;
    address constant WETH = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
    address constant WMATIC = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;

    address public lottery;
    address public nft;
    address public swapper;
    uint256 public minAmount;
    address public priceOracle;
    uint256 public slippage;
    uint256 constant MAX_SLIPPAGE = 10000;
    event TeamAccountChanged(address teamAddress, uint256 teamPercent);
    event AddressChanged(address lottery, address nft);
    event MinAmountChanged(uint256 minAmount);
    event SwapperChanged(address swapper);
    event PriceOracleAndSlippageUpdated(address priceOracle, uint256 slippage);
    modifier onlyLottery() {
        require(msg.sender == lottery, "Only Lottery can call function");
        _;
    }

    constructor(address _teamAddr, address _swapper) {
        teamPercent = 333333; // 33.3333%
        teamAddress = _teamAddr;
        require(_teamAddr != address(0), "invalid team address");
        swapper = _swapper;
        priceOracle = 0x327e23A4855b6F663a28c5161541d69Af8973302; // MATIC / ETH price oracle
        slippage = 100; //1%
    }

    function setWinners(uint256[] memory _winners) public onlyLottery {
        require(_winners.length > 0, "invalid winners");
        // set new winners
        delete winners;
        for (uint256 i = 0; i < _winners.length; i++) {
            winners.push(_winners[i]);
        }
    }

    function getMinimumAmount(uint256 ethAmount)
        public
        view
        returns (uint256 maticAmount)
    {
        uint80 roundID;
        int256 price;
        uint256 startedAt;
        uint256 timeStamp;
        uint80 answeredInRound;
        (
            roundID,
            price,
            startedAt,
            timeStamp,
            answeredInRound
        ) = AggregatorV3Interface(priceOracle).latestRoundData();
        uint8 decimals = AggregatorV3Interface(priceOracle).decimals();
        maticAmount = ethAmount.mul(10**decimals).div(uint256(price));
        maticAmount = maticAmount.mul(MAX_SLIPPAGE - slippage).div(
            MAX_SLIPPAGE
        );
    }

    function sendRewards() public onlyLottery {
        // convert ETH to matic
        {
            uint256 _amount = IERC20(WETH).balanceOf(address(this));
            if (_amount > 0) {
                address[] memory path = new address[](2);
                path[0] = WETH;
                path[1] = WMATIC;
                uint256[] memory amounts = ISwapper(swapper).getAmountsOut(
                    _amount,
                    path
                );
                uint256 minMaticeAmount = getMinimumAmount(_amount);
                TransferHelper.safeTransfer(
                    WETH,
                    ISwapper(swapper).GetReceiverAddress(path),
                    _amount
                );
                ISwapper(swapper)._swap(amounts, path, address(this));
                _amount = IERC20(WMATIC).balanceOf(address(this));
                require(_amount >= minMaticeAmount); // check slippage using price oracle
                IWETH(WMATIC).withdraw(_amount);
            }
        }

        uint256 curBalance = address(this).balance;
        if (curBalance > minAmount) {
            uint256 teamAmount = curBalance.mul(teamPercent).div(MAX_PERCENT);
            TransferHelper.safeTransferETH(teamAddress, teamAmount);
            if (winners.length > 0) {
                uint256 amount = (curBalance.sub(teamAmount)).div(
                    winners.length
                );
                for (uint256 i = 0; i < winners.length; i++) {
                    if (i == winners.length - 1) {
                        amount = address(this).balance;
                    }
                    if (nft != address(0) && winners[i] > 0) {
                        address receiver = IERC721(nft).ownerOf(winners[i]);
                        if (
                            receiver != address(0) &&
                            !Address.isContract(receiver)
                        ) {
                            TransferHelper.safeTransferETH(receiver, amount);
                        }
                    }
                }
            }
        }
    }

    function setTeamAccountInfo(address _teamAddress, uint256 _teamPercent)
        public
        onlyOwner
    {
        require(
            _teamPercent <= MAX_PERCENT && _teamAddress != address(0),
            "invalid team address info"
        );
        teamAddress = _teamAddress;
        teamPercent = _teamPercent;
        emit TeamAccountChanged(teamAddress, teamPercent);
    }

    function setAddressInfo(address _lottery, address _nft) public onlyOwner {
        lottery = _lottery;
        nft = _nft;
        emit AddressChanged(lottery, nft);
    }

    function setMinAmount(uint256 _minAmount) public onlyOwner {
        minAmount = _minAmount;
        emit MinAmountChanged(minAmount);
    }

    function setSwapper(address _swapper) public onlyOwner {
        swapper = _swapper;
        emit SwapperChanged(swapper);
    }

    function setPriceOracleAndSlippage(address _priceOracle, uint256 _slippage)
        public
        onlyOwner
    {
        priceOracle = _priceOracle;
        slippage = _slippage;
        require(slippage <= MAX_SLIPPAGE, "slippage over flow");
        emit PriceOracleAndSlippageUpdated(priceOracle, slippage);
    }

    /**
     * @notice allows the owner to extract stuck funds from this contract and sent to _receiver
     * @dev since bridged funds are sent to the pocket contract, and fees are sent to the fee vault,
     * normally there should be no residue funds in this contract. but in case someone mistakenly
     * send tokens directly to this contract, this function can be used to access these funds.
     * @param _token the token to extract
     * @param _to the amount to extract
     */
    function resecueFund(address _token, address _to) external onlyOwner {
        TransferHelper.safeTransfer(
            _token,
            _to,
            IERC20(_token).balanceOf(address(this))
        );
    }

    receive() external payable virtual {}
}
