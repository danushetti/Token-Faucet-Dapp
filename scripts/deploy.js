async function main() {
  const DanuToken = await ethers.getContractFactory("DanuToken");
  const danuToken = await DanuToken.deploy(100_000_000);

  await danuToken.deployed();

  console.log(
    `danuToken deployed to ${danuToken.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
