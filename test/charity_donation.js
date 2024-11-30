const CharityDonation = artifacts.require("CharityDonationCampaign");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("CharityDonationCampaign", function (/* accounts */) {
  // declare the contract instance variable for use in the tests
  let charityDonationInstance;

  // check if the contract is deployed
  it("should deploy the contract successfully", async function () {
    charityDonationInstance = await CharityDonation.deployed();
    const deployedAddress = charityDonationInstance.address;
    assert.isTrue(!!deployedAddress, "Deployed contract address should be available")
  });

  // get list all the campaigns
    it("should get all the campaigns", async function () {
        const campaigns = await charityDonationInstance.getAllCampaigns();
        assert.isArray(campaigns, "Campaigns should be an array");
    });

    // get the total number of campaigns
    it("should get the total number of campaigns", async function () {
        const totalCampaigns = await charityDonationInstance.getTotalCampaigns();
        // the total number of campaigns should be 0
        assert.equal(totalCampaigns, 0, "Total number of campaigns should be 0");
    });
});
