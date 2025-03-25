//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "hardhat/console.sol";

contract Marketplace is ReentrancyGuard {
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _totalListings; //Starts from 0
    Counters.Counter private _listingSold;  //Starts from 0
    
    address payable private owner;
    address payable private _governmentAccount;

    uint64 public governmentCommission = 2;
    uint64 public marketplaceCommission = 1;

    mapping(uint256 => Listing) public listings;
    
    constructor(address governmentAccount) {
        owner = payable(msg.sender);
        _governmentAccount = payable(governmentAccount);
    }

    //create new listing
    function createListing(
        address assetContract,
        uint256 tokenId,
        uint256 price
    ) external nonReentrant{
        _totalListings.increment();
        uint256 newListingId = _totalListings.current();

        listings[newListingId] = Listing(
            newListingId,
            price,
            payable(msg.sender),
            payable(address(0)),
            assetContract,
            tokenId
        );

        IERC721(assetContract).transferFrom(msg.sender, address(this), tokenId);

        emit ListingCreated(
            newListingId,
            tokenId, 
            assetContract, 
            price, 
            msg.sender,
            address(0)
        );
    }

    // buy/sell listing
    function buy(uint256 listingId) external payable nonReentrant{
        require(msg.sender != address(0), "Address should not be 0");

        Listing storage listing = listings[listingId];
        require(listing.listingId == listingId, "Property does not exist");
        
        uint256 marketplaceCommissionCalculated = listing
            .price
            .mul(marketplaceCommission)
            .div(100);
        uint256 governmentCommissionCalculated = listing
            .price
            .mul(governmentCommission)
            .div(100);
        uint256 requiredAmount = listing
            .price
            .add(marketplaceCommissionCalculated)
            .add(governmentCommissionCalculated);

        require(msg.value == requiredAmount, "Insufficent amount");


        listing.owner = msg.sender;

        //Commissions are paid
        _governmentAccount.transfer(governmentCommissionCalculated.mul(2));

        //Buyer pays marketplace commission
        owner.transfer(marketplaceCommissionCalculated);

        //Send money to the seller
        listing.seller.transfer(
            listing.price.sub(governmentCommissionCalculated)
        );

        IERC721(listing.assetContract).transferFrom(
            address(this),
            msg.sender,
            listing.tokenId
        );

        _listingSold.increment();

        emit ListingSold(
            listingId, 
            listing.tokenId, 
            listing.assetContract, 
            listing.price, 
            listing.seller,
            msg.sender
        );
    }

    // get all listings
    function getAllListings() external view returns (Listing[] memory) {
        uint256 unsoldListingCount = _totalListings.current() - _listingSold.current();
        Listing[] memory activeListings = new Listing[](unsoldListingCount);
        uint256 index = 0;

        for (uint256 i = 0; i < _totalListings.current(); i++) {
            if (listings[i + 1].owner == address(0)) {
                activeListings[index] = listings[listings[i + 1].listingId];
                index += 1;
            }
        }
        return activeListings;
    }

    //return listings of specific user
    function getMyListings() public view returns (Listing[] memory) {
        uint256 totalListingCount = _totalListings.current();
        uint256 itemCount = 0;
        uint256 index = 0;
        
        for (uint256 i = 0; i < totalListingCount; i++) {
            if (listings[i + 1].owner == msg.sender) {
                itemCount += 1;
            }
        } 
        Listing[] memory items = new Listing[](itemCount);
        for (uint256 i = 0; i < totalListingCount; i++) {
            if (listings[i + 1].owner == msg.sender) {
                uint256 currentId = i + 1;
                items[index] = listings[currentId];
                index += 1;
            }
        }
        return items;
    }

    //return listings created by a specific user
    function getListingsCreated() public view returns (Listing[] memory) {
        uint256 totalListingCount = _totalListings.current();
        uint256 itemCount = 0;
        uint256 index = 0;

        for (uint256 i = 0; i < totalListingCount; i++) {
            if (listings[i + 1].seller == msg.sender) {
                itemCount += 1;
            }
        } 
        Listing[] memory items = new Listing[](itemCount);
        for (uint256 i = 0; i < totalListingCount; i++) {
            if (listings[i + 1].seller == msg.sender) {
                uint256 currentId = i + 1;
                items[index] = listings[currentId];
                index += 1;
            }
        }
        return items;
    }

    // get specific listing 
    function getSpecificListing(uint256 listingId) public view returns (Listing memory){
        return listings[listingId];
    }

    //TODO
    //function updateListing() {} maybe
    //function removeListing() {} maybe
    //function addListing() {} maybe

    //structs
    struct Listing {
        uint256 listingId;
        uint256 price;
        address payable seller;
        address owner;
        address assetContract;
        uint256 tokenId;
    }


    //events
    event ListingCreated(
        uint256 indexed listingId,
        uint256 indexed tokenId,
        address indexed assetContract,
        uint256 price,
        address seller,
        address owner
    );

    event ListingSold(
        uint256 indexed listingId,
        uint256 indexed tokenId,
        address indexed assetContract,
        uint256 price,
        address seller,
        address buyer
    );
}
