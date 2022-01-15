// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract VolcanoToken is ERC721, Ownable {
    uint256 tokenID = 1;
    
    constructor () ERC721("VolcanoToken", "VLT") {}
    
    struct tokenMetadata {
        uint256 timestamp;
        uint256 tokenID;
        string tokenURI;
    }
    
    tokenMetadata[] tokens;
    mapping (address => tokenMetadata[]) metadata;
    
    function mintToken(address tokenOwner, string memory tokenURI) public {
        tokenMetadata memory token = tokenMetadata(block.timestamp, tokenID, tokenURI);
        metadata[tokenOwner].push(token);
        super._safeMint(tokenOwner, tokenID);
        tokenID++;
    }
    
    function removeTokenId(uint256 _tokenID) internal {
        for (uint i=0; i<tokens.length; i++) {
            if (tokens[i].tokenID == _tokenID) {
                delete tokens[i];
            } 
        }
        delete metadata[msg.sender];
    }
    
    function removeMapping(address _address, uint256 _tokenID) internal {
        for (uint i=0; i<metadata[_address].length; i++) {
            if (metadata[_address][i].tokenID == _tokenID) {
                delete metadata[_address][i];
            } 
        }
    }
    
    function burnToken(uint256 _tokenID) public {
        require(super.ownerOf(_tokenID) == msg.sender);
        super._burn(_tokenID);
        removeMapping(msg.sender, _tokenID);
    }
    
    function getTokenURI(uint256 _tokenID) internal view returns (string memory) {
        tokenMetadata[] memory userTokens = metadata[msg.sender];

        for (uint i=0; i < userTokens.length; i++) { 
            if(userTokens[i].tokenID == _tokenID)
            {
                return userTokens[i].tokenURI;
            }
        }
        revert("Token ID not found");
    }

    function getTokenMetadata(address _account) public view returns (tokenMetadata[] memory) {
        return metadata[_account];
    }

    function getOwnedTokens() public view returns(tokenMetadata[] memory) {
        return metadata[msg.sender];
    }
}
