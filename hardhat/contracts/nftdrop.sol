// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./allowlist.sol";
abstract contract nftdrop is ERC721Enumerable, ERC2981, Ownable {
    // Define a NFT drop object
    struct Drop {
        uint256 duration;
        uint256 startTime;
        uint128 ethPrice;
        uint256 supply;
        uint256 limitNFT;
    }

    IAllowlist Allowlist;
    uint256 public tokenIds;
    uint256 immutable MAX_DROP_SIZE = 1000000;
    event Sale(address from, address to, uint256 value);

    // Create a list of some sort to hold all the object
    Drop[] public drops;

    mapping(uint256 => address) public users;
    // mapping(uint64 => Drop) public drops;


    constructor(address AllowlistContract) {
        Allowlist = IAllowlist(AllowlistContract);
    }

    function setDuration(
        uint256 _setDuration,
        uint256 startTime,
        uint256 duration
    ) public onlyOwner {
        require(startTime == 0, "You already set the duration");
        require(_setDuration != 0, "Not Allowed to Start the Duration");
        startTime = block.timestamp;
        duration = _setDuration;
        // Drop storage drop = drops[dropID];
        Drop.startTime = startTime;
        Drop.duration = duration;
    }

    function setNftPerAddressLimit(
        uint256 _limitNFT,
        uint256 limitNFT
    ) public onlyOwner {
        limitNFT = _limitNFT;
        Drop.limitNFT = limitNFT;
    }

    function presaleEnded(
        uint256 startTime,
        uint256 duration
    ) public view returns (uint256) {

        return startTime + duration;
        Drop.starttime = startTime;
        Drop.duration = duration;
    }

    // Get the NFT drop objects list
    function getDrops() public view returns (Drop[] memory) {
        return drops;
    }

    // add the NFT drop objects list
    function addDropresal(
        Drop memory _drop,
        uint128 ethPrice
    ) public onlyOwner {
        require(block.timestamp < presaleEnded(), "VIPPresale is not running");
        require(
            tokenIds < MAX_DROP_SIZE,
            "Exceeded maximum Crypto Devs supply"
        );
        require(msg.value >= ethPrice, "Ether sent is not correct");
        tokenIds += 1;

        drops.push(_drop);
        uint256 id = drops.length - 1;
        users[id] = msg.sender;
        Drop.ethPrice = ethPrice;
       

        _safeMint(msg.sender, tokenIds);
        emit Sale(address(this), msg.sender, msg.value);

    }

    function addDroppublice(Drop memory _drop , uint256 ethPrice ) public onlyOwner {
        // _drop.appproved = false;
        require(block.timestamp < presaleEnded(), "VIPPresale is not running");
        require(msg.value >= ethPrice, "Ether sent is not correct");
         tokenIds += 1;

        drops.push(_drop);
        uint256 id = drops.length - 1;
        users[id] = msg.sender;

        Drop.ethPrice = ethPrice;


        _safeMint(msg.sender, tokenIds);
        emit Sale(address(this), msg.sender, msg.value);

    }

    // //Approve an NFT object to enable displaying
    // function approveDrop(uint256 _index) public onlyOwner {
    //       Drop storage drop = drops[_index];
    //       drop.appproved = true;
    // }
    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC2981, ERC721Enumerable) returns (bool) {}
}

  // function updateDrop( 
  //   uint256 _index,
  //   Drop memory _drop
  //   )  public {
  //   require(msg.sender == users[_index],"You're not the owner of this drop ");
  //   drops[_index] = _drop;
  // }
