pragma solidity ^0.4.25;

import "./erc721.sol";
import "./safemath.sol";

contract KittyBase {
    using SafeMath for uint256;

    struct Kitty {
        uint256 genes;
    }

    Kitty[] kitties;

    mapping (uint256 => address) public kittyToOwner;
    mapping (address => uint256) ownerKittyCount;
}

contract KittyOwnership is KittyBase, ERC721 {
    using SafeMath for uint256;

    mapping (uint => address) kittyApprovals;

    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerKittyCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return kittyToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerKittyCount[_to] = ownerKittyCount[_to].add(1);
        ownerKittyCount[_from] = ownerKittyCount[_from].sub(1);
        kittyToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public payable {
        require (kittyToOwner[_tokenId] == msg.sender || kittyApprovals[_tokenId] == msg.sender);
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) public payable onlyOwnerOf(_tokenId) {
        kittyApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    modifier onlyOwnerOf(uint256 _tokenId) {
        require(msg.sender == kittyToOwner[_tokenId]);
        _;
    }
}
