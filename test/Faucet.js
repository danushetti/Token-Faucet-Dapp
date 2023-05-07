const {expect} = require("chai");
const hre = require("hardhat");

async function main(){
    const Faucet = await hre.ethers.getContractFactory("Faucet");
    const faucet = await Faucet.deploy("0xB78c5e98de6E031372Bc0a3D46cA2279D319FC5");
    await faucet.deployed();
}