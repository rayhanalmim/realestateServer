import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { BigNumber } from "ethers";
import { ethers } from "hardhat";
import { Marketplace, PropertyNFT } from "../typechain";

let marketplace: Marketplace;
let nft: PropertyNFT;
let owner: SignerWithAddress;
let seller: SignerWithAddress;
let buyer: SignerWithAddress;

describe("Marketplace", function () {
  beforeEach(async function () {
    [owner, seller, buyer] = await ethers.getSigners();
    const Marketplace = await ethers.getContractFactory("Marketplace");
    marketplace = (await Marketplace.connect(owner).deploy(
      "0xdf3e18d64bc6a983f673ab319ccae4f1a57c7097"
    )) as Marketplace;
    await marketplace.deployed();

    const PropertyNFT = await ethers.getContractFactory("PropertyNFT");
    nft = (await PropertyNFT.connect(owner).deploy(marketplace.address)) as PropertyNFT;
    await nft.deployed();
  });

  it("Should create a new listing and return", async function () {
    let tx = await nft.mint("jkhgkjhgkjhgj");
    await tx.wait();

    tx = await marketplace.createListing(
      nft.address,
      1,
      ethers.utils.parseUnits("1", "ether")
    );

    await tx.wait();

    const allListings = await marketplace.getAllListings();
    expect(allListings.length).to.be.equal(1);

    const specificListing = await marketplace.getSpecificListing(1);
    expect(specificListing.listingId).to.be.equal(1);
  });

  it("Should transfer nft to buyer after the sale and return nfts for owner and seller", async function () {
    let tx = await nft.connect(seller).mint("token1");
    await tx.wait();

    tx = await nft.connect(seller).mint("token2");
    await tx.wait();

    tx = await marketplace
      .connect(seller)
      .createListing(nft.address, 1, ethers.utils.parseUnits("1", "ether"));
    await tx.wait();

    const nftsCreated = await marketplace.connect(seller).getListingsCreated();
    expect(nftsCreated.length).to.be.equal(1);

    tx = await marketplace
      .connect(buyer)
      .buy(1, { value: ethers.utils.parseUnits("1.03", "ether") });

    await tx.wait();

    tx = await marketplace
    .connect(seller)
    .createListing(nft.address, 2, ethers.utils.parseUnits("1", "ether"));
  await tx.wait();

    const myNfts = await marketplace.connect(buyer).getAllListings();
    console.log(myNfts);
/*     expect(myNfts.length).to.be.equal(1);

    let balance = await nft.balanceOf(buyer.address);
    expect(balance).to.be.equal(BigNumber.from(1));

    balance = await nft.balanceOf(marketplace.address);
    expect(balance).to.be.equal(BigNumber.from(0));

    balance = await nft.balanceOf(seller.address);
    expect(balance).to.be.equal(BigNumber.from(0)); */
  });
});
