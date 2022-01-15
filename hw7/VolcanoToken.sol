// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract VolcanoToken is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDs;
    
    constructor () ERC721("VolcanoToken", "VLT") {}
    
    struct tokenMetadata {
        uint256 timestamp;
        uint256 tokenID;
        string tokenURI;
    }
    
    tokenMetadata[] tokens;
    mapping (address => tokenMetadata[]) public tokenOwnership;
    mapping (uint256 => address) public tokenToOwnerMap;
    
    function mintToken(address _address) public {
        _tokenIDs.increment();
        uint256 tokenID = _tokenIDs.current();
        _safeMint(_address, tokenID);
        tokenMetadata memory token = tokenMetadata({
                timestamp: block.timestamp, 
                tokenID: tokenID, 
                tokenURI: tokenURI(tokenID)});
        tokenOwnership[_address].push(token);
        tokens.push(token);
        tokenToOwnerMap[tokenID] = _address;
    }
    
    function removeTokenId (uint256 _tokenID) internal {
        for (uint i=0; i<tokens.length; i++) {
            if (tokens[i].tokenID == _tokenID) {
                delete tokens[i];
            } 
        }
        delete tokenToOwnerMap[_tokenID];
    }
    
    function removeMapping (address _address, uint256 _tokenID) internal {
        for (uint i=0; i<tokenOwnership[_address].length; i++) {
            if (tokenOwnership[_address][i].tokenID == _tokenID) {
                delete tokenOwnership[_address][i];
            } 
        }
    }
    
    function burnToken(uint256 _tokenID) public {
        require(msg.sender == tokenToOwnerMap[_tokenID]);
        _burn(_tokenID);
        removeTokenId(_tokenID);
        removeMapping(msg.sender, _tokenID);
    }
    
    function _baseURI() internal override view virtual returns (string memory) {
        return "VLT-";
    }
}
