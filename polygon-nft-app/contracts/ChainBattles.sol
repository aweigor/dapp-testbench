// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/utils/Base64.sol';

contract ChainBattles is ERC721URIStorage {
  using Strings for uint256;
  uint256 private _tokenId;

  function safeMint(address to) public {
      uint256 tokenId = _tokenId;
      _safeMint(to, tokenId);
      _tokenId += 1;
  }

  mapping(uint256 => uint256) public tokenIdToLevels;

  constructor() ERC721("Chain Battles", "CBTL") {}

  function generateCharacter(uint256 tokenId) public view returns (string memory) {
    bytes memory svg = abi.encodePacked(
      '<svg width="300" preserveAspectRatio="xMinYMin" viewBox="0 0 350 350">',
      '<style>.base { fill: white; } </style>',
      '<rect width="200" height="100" x="10" y="10" rx="20" ry="20" fill="black" />',
      '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', 'Warrior', '</text>',
      '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', 'Levels: ', getLevels(tokenId ),'</text>',
      '</svg>' 
    );
    return string(
      abi.encodePacked(
        "data:image/svg+xml;base64, ",
        Base64.encode(svg)
      )
    );
  }

  function getLevels(uint256 tokenId) public view returns (string memory) {
    uint256 levels = tokenIdToLevels[tokenId];
    return levels.toString();
  }

  function getTokenUri(uint256 tokenId) public returns (string memory) {
    
    bytes memory dataURI = abi.encodePacked(
      '{', 
        '"name": "NAME"', tokenId.toString(), '","',
        '"description": "DESCRIPTION"',
        '"image": "', generateCharacter(tokenId), '","',
      '}'
    );

    return string(
      abi.encodePacked(
        "data:image/svg+xml;base64, ",
        Base64.encode(dataURI)
      )
    );

  }


  function mint() public {
    _tokenId += 1;
    uint256 tokenId = _tokenId;
    _safeMint(msg.sender, tokenId);
    tokenIdToLevels[tokenId] = 0;
    _setTokenURI(tokenId, getTokenUri(tokenId));
  }

  function train(uint256 tokenId) public {
    require(_exists(tokenId), "Please use an existing token");
    require(ownerOf(tokenId) = msg.sender, "you must be owner of the token to train it");
    uint256 currentLevel = tokenIdToLevels[tokenId];
    tokenIdToLevels[tokenId] = currentLevel + 1;
    _setTokenURI(tokenId, getTokenUri(tokenId));
  }
}
