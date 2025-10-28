// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title ProDemoToken - A demo ERC20 token with minting and burning capabilities
/// @author Divine Favour D
contract ProDemoToken is ERC20, Ownable {

    mapping(address => bool) public frozenAccounts;

    event AccountFrozen(address indexed account, bool isFrozen);
    event TokensBurned(address indexed burner, uint256 amount);
    event TokensMinted(address indexed receiver, uint256 amount);

    constructor() ERC20("ProDemoToken", "PDT") {
        _mint(msg.sender, 1000 * 10 ** decimals()); // initial supply
    }

    /// @notice Mint new tokens (owner only)
    /// @param to Address to receive minted tokens
    /// @param amount Amount of tokens to mint
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    /// @notice Burn tokens from your own account
    /// @param amount Amount of tokens to burn
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }

    /// @notice Freeze or unfreeze an account (owner only)
    /// @param account Address to freeze/unfreeze
    /// @param freeze True to freeze, false to unfreeze
    function freezeAccount(address account, bool freeze) external onlyOwner {
        frozenAccounts[account] = freeze;
        emit AccountFrozen(account, freeze);
    }

    /// @notice Override transfer to check if sender/receiver is frozen
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        require(!frozenAccounts[from], "Sender account is frozen");
        require(!frozenAccounts[to], "Receiver account is frozen");
        super._beforeTokenTransfer(from, to, amount);
    }
}