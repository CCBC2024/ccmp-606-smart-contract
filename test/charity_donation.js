const CharityDonation = artifacts.require("CharityDonationCampaign");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("CharityDonationCampaign", function (/* accounts */) {
  it("should assert true", async function () {
    await CharityDonation.deployed();
    return assert.isTrue(true);
  });
});
