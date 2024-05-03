// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./INFTminter.sol";

// TODO: inherit BaseAssignment and implement INFTminter.

contract NFTminter_template is ERC721URIStorage, INFTminter {
    // Use strings methods directly on variables.
    using Strings for uint256;
    using Strings for address;

    uint256 private _nextTokenId;

    // Other variables as needed ...
    uint256 private _totalSupply;
    uint256 private mintPrice = 0.0001 ether;

    constructor() ERC721("Token", "TKN") {
        // Constructor code as needed ...
    }

    // mint a nft and send to _address
    function mint(address _address) public payable returns (uint256) {
        uint256 currentPrice = getPrice();
        require(
            msg.value >= currentPrice,
            "Insufficient funds sent for minting."
        );

        uint256 tokenId = _nextTokenId++;
        _totalSupply++;

        string memory metadata = generateMetadata(tokenId, _address);
        string memory encodedMetadata = encodeMetadata(metadata);

        // Return token URI
        string memory tokenURI = getTokenURI(tokenId, _address);

        // Mint ...
        _mint(_address, tokenId);

        // Set encoded token URI to token
        _setTokenURI(tokenId, encodedMetadata);

        return tokenId;
    }

    // Other methods as needed ...
    function isApprovedOrOwner(
        address spender,
        uint256 tokenId
    ) public view returns (bool) {
        address owner = ownerOf(tokenId);
        return (spender == owner ||
            getApproved(tokenId) == spender ||
            isApprovedForAll(owner, spender));
    }

    function burn(uint256 tokenId) public payable {
        require(
            msg.value >= 0.0001 ether,
            "Burn fee of 0.0001 ETH is required"
        );
        require(
            isApprovedOrOwner(_msgSender(), tokenId),
            "Caller is not owner nor approved"
        );

        _burn(tokenId);
        _totalSupply--;
        mintPrice = mintPrice > 0.001 ether
            ? mintPrice - 0.001 ether
            : 0.0001 ether; // Ensure price does not drop below the base
    }

    function getPrice() public view returns (uint256) {
        if (_totalSupply == 0) {
            return 0.0001 ether;
        } else {
            uint256 price = 0.0001 ether * (2 ** _totalSupply);
            return price > 0.05 ether ? 0.05 ether : price;
        }
    }

    function generateMetadata(
        uint256 tokenId,
        address newOwner
    ) private view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '{"name":"My beautiful artwork #',
                    Strings.toString(tokenId),
                    '","image":"ipfs://,',
                    getIPFSHash(),
                    '","creator":"',
                    Strings.toHexString(uint160(ownerOf(tokenId)), 20),
                    '","owner":"',
                    Strings.toHexString(uint160(newOwner), 20),
                    '"}'
                )
            );
    }

    function encodeMetadata(
        string memory metadata
    ) private pure returns (string memory) {
        string memory base64Json = Base64.encode(bytes(metadata));
        return
            string(
                abi.encodePacked("data:application/json;base64,", base64Json)
            );
    }

    function getTotalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function getIPFSHash() public view override returns (string memory) {
        return "QmUbZJ6vRzCy1rw93TpiVdDUB6bdqjGUew92sfxmoJTprE";
    }

    /*=============================================
    =                   HELPER                  =
    =============================================*/

    // Get tokenURI for token id
    function getTokenURI(
        uint256 tokenId,
        address newOwner
    ) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "My beautiful artwork #',
            tokenId.toString(),
            '"',
            '"hash": "',
            // TODO: hash
            "SOME_HASH",
            '",',
            '"by": "',
            // TODO: owner,
            "0x_OWNER",
            '",',
            '"new_owner": "',
            newOwner,
            '"',
            "}"
        );

        // Encode dataURI using base64 and return
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    // Get tokenURI for token id using string.concat.
    function getTokenURI2(
        uint256 tokenId,
        address newOwner
    ) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "My beautiful artwork #',
            tokenId.toString(),
            '"',
            '"hash": "',
            // TODO: hash
            "SOME_HASH",
            '",',
            '"by": "',
            // TODO: owner,
            "0x_OWNER",
            '",',
            '"new_owner": "',
            newOwner,
            '"',
            "}"
        );

        // Encode dataURI using base64 and return
        return
            string.concat(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            );
    }

    // Not actually needed by assignment, but you can try it out
    // to learn about strings.
    function strlen(string memory s) public pure returns (uint) {
        uint len;
        uint i = 0;
        uint bytelength = bytes(s).length;
        for (len = 0; i < bytelength; len++) {
            bytes1 b = bytes(s)[i];
            if (b < 0x80) {
                i += 1;
            } else if (b < 0xE0) {
                i += 2;
            } else if (b < 0xF0) {
                i += 3;
            } else if (b < 0xF8) {
                i += 4;
            } else if (b < 0xFC) {
                i += 5;
            } else {
                i += 6;
            }
        }
        return len;
    }
}
