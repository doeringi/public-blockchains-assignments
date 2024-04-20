// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Easy creation of ERC20 tokens.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Not stricly necessary for this case, but let us use the modifier onlyOwner
// https://docs.openzeppelin.com/contracts/5.x/api/access#Ownable
import "@openzeppelin/contracts/access/Ownable.sol";


// Import BaseAssignment.sol
import "../BaseAssignment.sol";

contract CensorableToken is ERC20, Ownable, BaseAssignment {

    // Add state variables and events here.

    // Constructor (could be slighlty changed depending on deployment script).
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply, address _initialOwner)
        BaseAssignment(0x0fc1027d91558dF467eCfeA811A8bCD74a927B1e)
        ERC20(_name, _symbol)
        Ownable(_initialOwner)
    {

       // Mint tokens.
    }


    // Function to blacklist an address
    function blacklistAddress(address _account) external onlyOwner {
       // Your code here.
    }

    // Function to remove an address from the blacklist
    function unblacklistAddress(address _account) external onlyOwner {
    
    }

 
    // More functions as needed.


}
