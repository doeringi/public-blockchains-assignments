// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Easy creation of ERC20 tokens.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Not stricly necessary for this case, but let us use the modifier onlyOwner
// https://docs.openzeppelin.com/contracts/5.x/api/access#Ownable
import "@openzeppelin/contracts/access/Ownable.sol";

// This allows for granular control on who can execute the methods (e.g.,
// the validator); however it might fail with our validator contract!
// https://docs.openzeppelin.com/contracts/5.x/api/access#AccessControl
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

// import "hardhat/console.sol";

// Import BaseAssignment.sol
import "../BaseAssignment.sol";

contract CensorableToken is ERC20, Ownable, BaseAssignment, AccessControl {
    // Add state variables and events here.
    // bytes32 public constant BLACKLISTER_ROLE = keccak256("BLACKLISTER_ROLE");
    mapping(address => bool) public isBlacklisted;

    event Blacklisted(address indexed account);
    event UnBlacklisted(address indexed account);

    // Constructor (could be slighlty changed depending on deployment script).
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply,
        address _initialOwner,
        address _validator
    )
        BaseAssignment(0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155)
        // 0x0fc1027d91558dF467eCfeA811A8bCD74a927B1e
        ERC20(_name, _symbol)
        Ownable(_initialOwner)
    {
        require(
            _initialSupply > 10,
            "Initial supply for owner must be greater than 10"
        );

        // Mint tokens.
        _mint(msg.sender, _initialSupply * 10 ** decimals());
        _mint(_validator, 10 * 10 ** decimals());

        _approve(_initialOwner, _validator, balanceOf(_initialOwner));

        // _setupRole(BLACKLISTER_ROLE, msg.sender);
        // _setupRole(BLACKLISTER_ROLE, validator);

        // Hint: get the decimals rights!
        // See: https://docs.soliditylang.org/en/develop/units-and-global-variables.html#ether-units
    }

    // Function to blacklist an address
    function blacklistAddress(address _account) public {
        require(!isBlacklisted[_account], "Account is already blacklisted");
        isBlacklisted[_account] = true;
        emit Blacklisted(_account);
        // Note: if AccessControl fails the validation on the (not)UniMa Dapp
        // you can use a simpler approach, requiring that msg.sender is
        // either the owner or the validator.
        // Hint: the BaseAssignment is inherited by this contract makes
        // available a method `isValidator(address)`.
    }

    // Function to remove an address from the blacklist
    function unblacklistAddress(address _account) public {
        require(isBlacklisted[_account], "Account is not blacklisted");
        isBlacklisted[_account] = false;
        emit UnBlacklisted(_account);
    }

    // More functions as needed.

    function _update(
        address from,
        address to,
        uint256 amount
    ) internal override {
        super._update(from, to, amount);

        require(!isBlacklisted[from], "Sender is blacklisted");
        require(!isBlacklisted[to], "Recipient is blacklisted");
    }

    // There are multiple approaches here. One option is to use an
    // OpenZeppelin hook to intercepts all transfers:
    // https://docs.openzeppelin.com/contracts/5.x/api/token/erc20#ERC20

    // This can also help:
    // https://blog.openzeppelin.com/introducing-openzeppelin-contracts-5.0
}
