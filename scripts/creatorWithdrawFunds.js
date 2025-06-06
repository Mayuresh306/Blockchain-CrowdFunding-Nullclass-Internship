const { ethers } = require("hardhat");

async function main() {
    const [creator] = await ethers.getSigners();
    const ContractAddress = "0xe391a83C22c5C042fCF57a2C9Add1360Cc6ee47C";
    
    const Contract = await ethers.getContractAt("CrowdTank" , ContractAddress , creator);

    const _projectID = 1;

    const tx = await Contract.creatorWithdraw(_projectID);
    await tx.wait;

    console.log(" Project creator withdrew the funds from project :" , _projectID);
}

main().catch((error) => {
    console.log(error);
    process.exitCode=1;
});