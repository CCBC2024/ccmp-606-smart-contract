// import the dotenv module for loading environment variables
require('dotenv').config();

// Load the USDC smart contract address from the .env file
const { USDC_SMART_CONTRACT_ADDRESS } = process.env;

// Load the CharityDonationCampaign contract from the build artifacts
const charityDonationCampaign = artifacts.require("./CharityDonationCampaign.sol");

module.exports = function (_deployer) {
    // Deploy the CharityDonationCampaign contract with the USDC smart contract address as a constructor argument
    _deployer.deploy(charityDonationCampaign, USDC_SMART_CONTRACT_ADDRESS);
};
