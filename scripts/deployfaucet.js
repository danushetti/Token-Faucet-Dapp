async function main() {
    const Faucet = await ethers.getContractFactory("Faucet");
    const faucet = await Faucet.deploy("0xB78c5e98de6E031372Bc0a3D46cA2279D319FC5B");
  
    await faucet.deployed();
  
    console.log(
      `faucet contract deployed to ${faucet.address}`
    );
  }
  
  // We recommend this pattern to be able to use async/await everywhere
  // and properly handle errors.
  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  