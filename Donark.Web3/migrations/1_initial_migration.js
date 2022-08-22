const BloodDonation = artifacts.require("./Contracts/BloodDonation.sol");

module.exports = async function (deployer) {
deployer.deploy(BloodDonation);
};
