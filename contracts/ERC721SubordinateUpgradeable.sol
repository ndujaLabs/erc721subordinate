// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Authors: Francesco Sullo <francesco@sullo.co>

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

abstract contract ERC721EnumerableSubordinateUpgradeable is
  Initializable,
  ERC721Upgradeable,
  ERC721EnumerableUpgradeable,
  UUPSUpgradeable
{
  using AddressUpgradeable for address;

  error NotAContract();
  error SubordinateTokensAreNotTransferable();

  ERC721EnumerableUpgradeable private _main;

  // solhint-disable
  function __ERC721SubordinateUpgradeable_init(
    string memory name_,
    string memory symbol_,
    address main_
  ) internal onlyInitializing {
    if (!main_.isContract()) revert NotAContract();
    _main = ERC721EnumerableUpgradeable(main_);
    __ERC721_init(name_, symbol_);
  }

  // ATTENTION, YOU MUST IMPLEMENT
  // function _authorizeUpgrade(address newImplementation) internal virtual onlyOwner override {}

  function mainToken() public view returns (address) {
    return address(_main);
  }

  // core views

  function balanceOf(address owner) public view override returns (uint256) {
    return _main.balanceOf(owner);
  }

  function ownerOf(uint256 tokenId) public view override returns (address) {
    return _main.ownerOf(tokenId);
  }

  // no transfers

  function _beforeTokenTransfer(
    address,
    address,
    uint256,
    uint256
  ) internal override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
    revert SubordinateTokensAreNotTransferable();
  }

  // no approvals

  function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }

  function approve(address, uint256) public override(ERC721Upgradeable) {
    revert SubordinateTokensAreNotTransferable();
  }

  function getApproved(uint256) public view override(ERC721Upgradeable) returns (address) {
    return address(0);
  }

  function setApprovalForAll(address, bool) public override(ERC721Upgradeable) {
    revert SubordinateTokensAreNotTransferable();
  }

  function isApprovedForAll(address, address) public view override(ERC721Upgradeable) returns (bool) {
    return false;
  }

  uint256[50] private __gap;
}