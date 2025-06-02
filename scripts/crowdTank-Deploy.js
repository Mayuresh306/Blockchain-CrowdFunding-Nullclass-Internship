const { Contract } = require('ethers');
const hre = require('hardhat');

async function main() {
    
    const CrowdTank = await hre.ethers.getContractFactory("CrowdTank");
    const crowdtank = await CrowdTank.deploy();

    await crowdtank.waitForDeployment();
    console.log("CrowdTank is deployed at : " , crowdtank.target);

}

main().then(() => process.exit(0)).catch((error) => {
    console.error(error);
    process.exit(1);
    
});