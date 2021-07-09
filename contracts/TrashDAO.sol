//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// ERC1155
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TrashDAO is
    Ownable,
    IERC721Receiver,
    ERC1155Receiver,
    ERC20("TRASH", "$TRASH")
{
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

    function onERC1155Received(
        address operator,
        address,
        uint256,
        uint256 value,
        bytes memory data
    ) public virtual override returns (bytes4) {
        _mint(operator, value * 1 ether); //mint tokens

        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address operator,
        address,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) public virtual override returns (bytes4) {
        uint256 qty = 0;

        for (uint256 i = 0; i < ids.length; i++) {
            qty = qty + values[i];
        }

        _mint(operator, qty * 1 ether);

        return this.onERC1155BatchReceived.selector;
    }

    //For A DAO to withdraw nfts
    function withdraw(
        address nft, //nft project address
        uint256[] calldata _tokenIds, //token ids
        uint256[] calldata amounts, // amounts per each token (for erc721 [1,1,1])
        address to, //who to send the NFTs
        bool isERC1155 //Is ERC1155
    ) external onlyOwner {
        if (isERC1155) {
            if (_tokenIds.length == 1) {
                _withdraw1155(nft, address(this), to, _tokenIds[0], amounts[0]);
            } else {
                _batchWithdraw1155(nft, address(this), to, _tokenIds, amounts);
            }
        } else if (!isERC1155) {
            for (uint256 i = 0; i < _tokenIds.length; i++) {
                _withdraw721(nft, address(this), to, _tokenIds[i]);
            }
        }
    }

    function _withdraw1155(
        address nftAddress,
        address _from,
        address _to,
        uint256 _tokenId,
        uint256 value
    ) internal {
        IERC1155(nftAddress).safeTransferFrom(_from, _to, _tokenId, value, "");
    }

    function _batchWithdraw1155(
        address nftAddress,
        address _from,
        address _to,
        uint256[] memory ids,
        uint256[] memory amounts
    ) internal {
        uint256 qty = 0;
        for (uint256 i = 0; i < ids.length; i++) {
            qty = qty + amounts[i];
        }

        IERC1155(nftAddress).safeBatchTransferFrom(
            _from,
            _to,
            ids,
            amounts,
            "0x0"
        );
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
