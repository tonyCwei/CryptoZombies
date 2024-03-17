pragma solidity 0.4.25;

import "./erc721.sol";
import "./ownable.sol";
import "./safemath.sol";


contract CryptoKitties is ERC721 {
    struct Kitty {
        uint256 genes;
    }
    
    Kitty[] private kitties;
    mapping(uint256 => address) private kittyToOwner;
    mapping(address => uint256) private ownershipTokenCount;
    mapping(uint256 => address) private kittyToApproved;

    event KittyCreated(uint256 id, uint256 genes);

    function createKitty(uint256 _genes) public {
        uint256 id = kitties.length;
        kitties.push(Kitty(_genes));
        kittyToOwner[id] = msg.sender;
        ownershipTokenCount[msg.sender]++;

        emit KittyCreated(id, _genes);
        emit Transfer(address(0), msg.sender, id);
    }

    function getKitty(uint256 _id) external view returns (uint256, uint256) {
        Kitty storage kit = kitties[_id];
        return (_id, kit.genes);
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return ownershipTokenCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return kittyToOwner[_tokenId];
    }

    function approve(address _approved, uint256 _tokenId) external payable {
        require(msg.sender == kittyToOwner[_tokenId]);
        kittyToApproved[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(kittyToOwner[_tokenId] == _from);
        require(msg.sender == _from || msg.sender == kittyToApproved[_tokenId]);
        require(_to != address(0));

        ownershipTokenCount[_from]--;
        ownershipTokenCount[_to]++;
        kittyToOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    // Implement other ERC721 functions and helper methods as needed
}
