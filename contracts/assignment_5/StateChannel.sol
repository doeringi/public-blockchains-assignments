// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Import BaseAssignment.sol
import "../BaseAssignment.sol";

// Create contract > define Contract Name
contract StateChannel is BaseAssignment {
    // Define state variables as needed.
    address public funder;
    address public sender;
    address public receiver;
    uint256 public totalEscrowed;
    address public validator;

    // Make sure to set the validator address in the BaseAssignment constructor
    constructor(address _validator) BaseAssignment(_validator) {
        validator = _validator;
    }

    // Implement all missing methods.

    function openChannel(address _sender, address _receiver) external payable {
        require(funder == address(0), "Channel already funded");
        require(msg.value > 0, "Initial funding required");

        funder = msg.sender;
        sender = _sender;
        receiver = _receiver;
        totalEscrowed = msg.value;
    }

    function verifyPaymentMsg(
        uint256 ethAmount,
        bytes memory signature
    ) public view returns (bool) {
        // require(
        //     address(this).balance >= ethAmount,
        //     "Insufficient funds in channel"
        // );
        // require(
        //     ethAmount <= totalEscrowed,
        //     "Requested amount exceeds total escrowed"
        // );

        bytes32 message = prefixed(
            keccak256(abi.encodePacked(address(this), ethAmount))
        );

        return recoverSigner(message, signature) == sender;
    }

    function closeChannel(uint256 ethAmount, bytes memory signature) external {
        require(msg.sender == receiver, "Only receiver can close the channel");
        require(verifyPaymentMsg(ethAmount, signature), "Invalid signature");

        totalEscrowed -= ethAmount;
        payable(receiver).transfer(ethAmount);

        funder = address(0);
        sender = address(0);
        receiver = address(0);
        totalEscrowed = 0;
    }

    function forceReset() external {
        // require(
        //     msg.sender == validator,
        //     "Only the validator can call this function"
        // );

        funder = address(0);
        sender = address(0);
        receiver = address(0);
        totalEscrowed = 0;
    }

    // Important!
    // Before verifying a signature with ecrecover, you need to prefix it with
    // "\x19Ethereum Signed Message:\n32", because this is automatically added
    // upon signing outside of solidity to prevent malicious transactions.

    // Signature methods.
    /////////////////////

    // Recover the address of the signer, from signature and message.
    function recoverSigner(
        bytes32 message,
        bytes memory sig
    ) internal pure returns (address) {
        uint8 v;
        bytes32 r;
        bytes32 s;

        (v, r, s) = splitSignature(sig);

        // TODO: return the address of signer using ecrecover.
        return ecrecover(message, v, r, s);
    }

    // Prepares the data for ecrecover.
    function splitSignature(
        bytes memory sig
    ) internal pure returns (uint8, bytes32, bytes32) {
        require(sig.length == 65);

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

    // Builds a prefixed hash to mimic the behavior of eth_sign.
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
            );
    }

    /*=====  End of HELPER  ======*/
}
