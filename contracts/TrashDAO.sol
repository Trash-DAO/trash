//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TrashDAO is Ownable, IERC721Receiver, ERC20("TRASH", "$TRASH") {
    constructor() {}

    //Mint 1 $TRASH per NFT sent in, supports ERC721 and ERC1155
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
        IERC721(nftAddress).transferFrom(_from, _to, _tokenId);
    }
}
