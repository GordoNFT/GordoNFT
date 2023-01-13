//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "./libraries/GordoNFTSVG.sol";
import "./interface/ILottery.sol";
import "./interface/IERC4906.sol";

contract GordoNFT is ERC721, Ownable, IERC4906, IERC2981 {
    using Counters for Counters.Counter;
    using SafeMath for uint256;
    Counters.Counter private _tokenIdTracker;

    bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
    bytes4 private constant _INTERFACE_ID_ERC4906 = 0x49064906;

    uint256 private _royaltiesPercent;
    address payable private _royaltiesPaymentsAddress;
    uint256 public constant maxSupply = 10000;
    address public lottery;

    modifier onlyLottery() {
        require(msg.sender == lottery, "Only Lottery can call function");
        _;
    }

    constructor(address feeWallet, address _lottery)
        ERC721("Gordo NFT", "Gordo")
    {
        _royaltiesPercent = 4750;
        _royaltiesPaymentsAddress = payable(feeWallet);
        lottery = _lottery;
    }

    function mint(address _to) public onlyOwner {
        require(_tokenIdTracker.current() < maxSupply, "over max supply");
        _tokenIdTracker.increment();
        uint256 newItemId = _tokenIdTracker.current();
        // super._mint(_to, newItemId);
        _safeMint(_to, newItemId);
    }

    function batchMint(address _to, uint256 mintCount) public onlyOwner {
        require(
            mintCount > 0 && _tokenIdTracker.current() + mintCount <= maxSupply,
            "amount is invalid"
        );
        for (uint256 x = 0; x < mintCount; x++) {
            _tokenIdTracker.increment();
            uint256 newItemId = _tokenIdTracker.current();
            // super._mint(_to, newItemId);
            _safeMint(_to, newItemId);
        }
    }

    function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount)
    {
        uint256 bp = _royaltiesPercent; // 7% royalties in basis points
        return (_royaltiesPaymentsAddress, _salePrice.mul(bp).div(10000));
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, ERC721)
        returns (bool)
    {
        if (
            interfaceId == _INTERFACE_ID_ERC2981 ||
            interfaceId == _INTERFACE_ID_ERC4906
        ) {
            return true;
        }
        return super.supportsInterface(interfaceId);
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bool active = lottery == address(0)
            ? true
            : ILottery(lottery).getTokenStatus(tokenId);
        bool isWinner = lottery == address(0)
            ? false
            : ILottery(lottery).isWinner(tokenId);
        return
            GordoNFTSVG.constructTokenURI(
                GordoNFTSVG.SVGParams({
                    ticket: tokenId,
                    active: active,
                    isWinner: isWinner
                })
            );
    }

    function updateTokenMetaData(uint256[] memory tokenIds) public onlyLottery {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            emit MetadataUpdate(tokenIds[i]);
        }
    }

    function getTokenInfo(uint256 tokenId)
        public
        view
        returns (bool isWinner, bool isActive)
    {
        isActive = lottery == address(0)
            ? true
            : ILottery(lottery).getTokenStatus(tokenId);
        isWinner = lottery == address(0)
            ? false
            : ILottery(lottery).isWinner(tokenId);
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        _requireMinted(tokenId);
        return getTokenURI(tokenId);
    }

    function setRoyalitiesInfo(
        address newRoyaltiesPaymentAddress,
        uint256 royailiesPercent
    ) external onlyOwner {
        _royaltiesPaymentsAddress = payable(newRoyaltiesPaymentAddress);
        _royaltiesPercent = royailiesPercent;
    }

    function setLotteryAddress(address _lottery) external onlyOwner {
        lottery = _lottery;
    }
}
