// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract RealEstate is ERC721URIStorage {
   
   using Counter for Counters.counter;
   Counters.counter private _tokenIds;

    constructor() ERC721("Real Estate", "REAL") {}
}