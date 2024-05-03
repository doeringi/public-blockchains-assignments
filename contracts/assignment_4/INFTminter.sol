// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Create contract > define Contract Name
interface INFTminter {
    // Mint a nft and send to _address. done
    function mint(address _address) external payable returns (uint256);

    // Burn a nft. done
    function burn(uint256 tokenId) external payable;

    // Flip sale status.
    function pauseSale() external;

    // Flip sale status.
    function activateSale() external;

    // Get sale status.
    function getSaleStatus() external view returns (bool);

    // Withdraw all funds to owner.
    function withdraw(uint256 amount) external;

    // Get current price. done
    function getPrice() external view returns (uint256);

    // Get total supply. done
    function getTotalSupply() external view returns (uint256);

    // Get IPFS hash. done
    function getIPFSHash() external view returns (string memory);
}
