//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract TrashDAO is
    Initializable,
    ERC20Upgradeable,
    OwnableUpgradeable,
    IERC721ReceiverUpgradeable
{
    function initialize() public initializer {
        __Ownable_init();
        __ERC20_init("TRASH", "$TRASH");
    }

    //Mint 1 $TRASH per NFT sent in, supports ERC721
    function onERC721Received(
        address operator,
        address,
        uint256,
        bytes memory data
    ) public virtual override returns (bytes4) {
        _mint(operator, 1 ether);
        return this.onERC721Received.selector;
    }

    //For A DAO to withdraw nfts
    function withdraw(
        address nft, //nft project address
        uint256[] calldata _tokenIds, //token ids
        address to //who to send the NFTs
    ) external onlyOwner {
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            _withdraw721(nft, address(this), to, _tokenIds[i]);
        }
    }

    function _withdraw721(
        address nftAddress,
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        IERC721Upgradeable(nftAddress).transferFrom(_from, _to, _tokenId);
    }
}
