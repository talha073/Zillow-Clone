const { expect } = require("chai");
const { ethers } = require("hardhat");

const token = (n) => {
  return ethers.utils.parseUnits(n.toString(), "ether");
};

describe("Escrow", () => {
  let buyer, seller, inspector, lender, realEstate, escrow;
  it("save the address", async () => {
    [buyer, seller, inspector, lender] = await ethers.getSigners();

    const RealEstate = await ethers.getContractFactory("RealEstate");
    realEstate = await RealEstate.deploy();
    console.log("contract deployed at: ", realEstate.address);

    let tx = await realEstate.connect(seller).mint("www.google.com");
    await tx.wait();

    const Escrow = await ethers.getContractFactory("Escrow");
    console.log("33");
    escrow = await Escrow.deploy(
      realEstate.address,
      seller.address,
      inspector.address,
      lender.address
    );

    let result = await escrow.nftAddress();
    expect(result).to.be.equal(realEstate.address);
  });
});
