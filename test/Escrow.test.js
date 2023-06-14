const { expect } = require("chai");
const { ethers } = require("hardhat");

const token = (n) => {
  return ethers.utils.parseUnits(n.toString(), "ether");
};

describe("Escrow", () => {
  let buyer, seller, realestate;
  it("save the addrress", async () => {
    [buyer, seller] = await ethers.getSigners();
    const RealEstate = await ethers.getContractFactory("RealEstate");
    realestate = await RealEstate.deploy();
    let tx = await realestate.connect(seller).mint("www.google.com");
    await tx.wait();
  });
});
