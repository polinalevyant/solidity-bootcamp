const { expect, use } = require("chai");
const { ethers } = require("hardhat");
const { constants, expectRevert } = require("@openzeppelin/test-helpers");

const { solidity } = require("ethereum-waffle");
use(solidity);

// Useful links for chai and waffle:
// https://www.chaijs.com/guide/styles/
// https://ethereum-waffle.readthedocs.io/en/latest/matchers.html

describe("VolcanoCoin", () => {
  let volcanoContract;
  let owner, addr1, addr2, addr3;

  beforeEach(async () => {
    const Volcano = await ethers.getContractFactory("VolcanoCoin");
    volcanoContract = await Volcano.deploy();
    await volcanoContract.deployed();

    [owner, addr1, addr2, addr3] = await ethers.getSigners();
  });

  it("has a name", async () => {
    let contractName = await volcanoContract.name();
    expect(contractName).to.equal("Volcano Coin");
  });

  it("reverts when transferring tokens to the zero address", async () => {
    await expect(volcanoContract.transfer(constants.ZERO_ADDRESS, 10)).to.be.reverted;
  });

  //homework
  it("has a symbol", async () => {
    let contractSymbol = await volcanoContract.symbol();
    expect(contractSymbol).to.equal("VLC");
  });

  it("has 18 decimals", async () => {
    let decimals = await volcanoContract.decimals();
    expect(decimals).to.equal(18);
  });

  it("assigns initial balance", async () => {
    let ownerBalance = await volcanoContract.balanceOf(owner.address);
    expect(ownerBalance).to.equal(100000);
  });

  it("increases allowance for address1", async () => {
    await volcanoContract.increaseAllowance(addr1.address, 10);
    let allowance = await volcanoContract.allowance(owner.address, addr1.address);
    expect(allowance.toNumber()).to.equal(10);
  });

  it("decreases allowance for address1", async () => {
    await volcanoContract.increaseAllowance(addr1.address, 10);
    await volcanoContract.decreaseAllowance(addr1.address, 10);
    let allowance = await volcanoContract.allowance(owner.address, addr1.address);
    expect(allowance.toNumber()).to.equal(0);
  });

  it("emits an event when increasing allowance", async () => {
    let transaction = await volcanoContract.increaseAllowance(addr1.address, 10);
    await expect(transaction).to.emit(volcanoContract, "Approval");
  });

  it("reverts decreaseAllowance when trying decrease below 0", async () => {
    await expect(volcanoContract.decreaseAllowance(addr1.address, 10)).to.be.reverted;
  });

  it("updates balances on successful transfer from owner to addr1", async () => {
    let ownerBalanceBefore = await volcanoContract.balanceOf(owner.address);
    let transaction = await volcanoContract.transfer(addr1.address, 100);

    let ownerBalanceAfter = await volcanoContract.balanceOf(owner.address);
    expect(ownerBalanceBefore - 100).to.equal(ownerBalanceAfter);

    let addr1BalanceAfter = await volcanoContract.balanceOf(addr1.address);
    expect(100).to.equal(addr1BalanceAfter);
  });
  
  it("reverts transfer when sender does not have enough balance", async () => {
    let transaction = volcanoContract.connect(addr1).transfer(addr2.address, 100);
    await expect(transaction).to.be.revertedWith("ERC20: transfer amount exceeds balance");
  });

  it("reverts transferFrom addr1 to addr2 called by the owner without setting allowance", async () => {
    let transaction = volcanoContract.connect(owner).transferFrom(addr1.address, addr2.address, 100);
    await expect(transaction).to.be.revertedWith("ERC20: transfer amount exceeds balance");
  });

  it("updates balances after transferFrom addr1 to addr2 called by the owner", async () => {
    let transaction = await volcanoContract.transfer(addr1.address, 1000);
    let balance = await volcanoContract.balanceOf(addr1.address);
    expect(balance).to.equal(1000);

    transaction = await volcanoContract.connect(addr1).increaseAllowance(owner.address, 1000);
    transaction = await volcanoContract.transferFrom(addr1.address, addr2.address, 1000);

    balance = await volcanoContract.balanceOf(addr1.address);
    expect(balance).to.equal(0);

    balance = await volcanoContract.balanceOf(addr2.address);
    expect(balance).to.equal(1000);
  });
});