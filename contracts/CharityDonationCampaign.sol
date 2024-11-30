// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CharityDonationCampaign {
    // Structure to represent a campaign
    struct Campaign {
        string name; // Name of the campaign
        uint256 goal; // Target amount to be raised (in token units)
        address beneficiary; // Address of the beneficiary
        address organizationBeneficiary; // Address of the organization beneficiary
        uint256 totalRaised; // Total amount raised in the campaign (in token units)
        bool isActive; // Status of the campaign (active/inactive)
    }

    // Structure to represent a contribution
    struct Contribution {
        address contributor;
        uint256 amount;
    }

    // ERC20 Token used for donations (e.g., USDC or USDT)
    IERC20 private immutable token;

    // Array to store all campaigns
    Campaign[] private campaignList;

    // Nested mapping to track each user's contributions by campaign id
    mapping(uint256 => mapping(address => uint256))
    private campaignContributions;

    // Mapping to store contributors for each campaign
    mapping(uint256 => address[]) private campaignContributors;

    // Events
    event CampaignCreated(
        uint256 campaignId,
        uint256 goal,
        address beneficiary,
        address organizationBeneficiary
    );
    event ContributionReceived(
        uint256 campaignId,
        address contributor,
        uint256 amount
    );
    event FundsTransferred(
        uint256 campaignId,
        address beneficiary,
        uint256 totalRaised
    );

    // Modifiers
    modifier onlyOrganization(uint256 _campaignId) {
        require(
            msg.sender == campaignList[_campaignId].organizationBeneficiary,
            "Only the organization can call this function."
        );
        _;
    }

    modifier campaignExists(uint256 _campaignId) {
        require(_campaignId < campaignList.length, "Campaign does not exist.");
        _;
    }

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    // Function to check if an address is valid
    function isValidAddress(address _address) public pure returns (bool) {
        return _address != address(0);
    }

    // Function to check if a value is greater than zero
    function isPositiveValue(uint256 _value) public pure returns (bool) {
        return _value > 0;
    }

    // Function to create a new campaign
    function createCampaign(
        string memory _name,
        uint256 _goal,
        address _beneficiary,
        address _organizationBeneficiary
    ) public {
        require(
            isPositiveValue(_goal),
            "Campaign goal must be greater than zero"
        );
        require(
            isValidAddress(_beneficiary),
            "Beneficiary address cannot be zero address"
        );
        require(
            isValidAddress(_organizationBeneficiary),
            "Organization Beneficiary address cannot be zero address"
        );
        require(
            _beneficiary != _organizationBeneficiary,
            "Beneficiary and Organization Beneficiary cannot be the same"
        );

        campaignList.push(
            Campaign({
                name: _name,
                goal: _goal,
                beneficiary: _beneficiary,
                organizationBeneficiary: _organizationBeneficiary,
                totalRaised: 0,
                isActive: true
            })
        );

        emit CampaignCreated(
            campaignList.length - 1,
            _goal,
            _beneficiary,
            _organizationBeneficiary
        );
    }

    // Function to donate to a specific campaign using ERC20 tokens
    function donate(uint256 _campaignId, uint256 _amount)
    public
    campaignExists(_campaignId)
    {
        Campaign storage campaign = campaignList[_campaignId];
        require(campaign.isActive, "Campaign is not active.");
        require(
            isPositiveValue(_amount),
            "Donation amount must be greater than zero."
        );
        require(
            token.transferFrom(msg.sender, address(this), _amount),
            "Token transfer failed."
        );

        // Add the contributor to the list if not already present
        if (campaignContributions[_campaignId][msg.sender] == 0) {
            campaignContributors[_campaignId].push(msg.sender);
        }

        campaignContributions[_campaignId][msg.sender] += _amount;
        campaign.totalRaised += _amount;

        emit ContributionReceived(_campaignId, msg.sender, _amount);
    }

    // Function to withdraw funds from a campaign if the goal is met
    function withdrawFunds(uint256 _campaignId)
    public
    campaignExists(_campaignId)
    onlyOrganization(_campaignId)
    {
        Campaign storage campaign = campaignList[_campaignId];
        require(
            campaign.totalRaised >= campaign.goal,
            "Campaign has not reached its goal."
        );
        require(campaign.isActive, "Campaign is not active.");

        campaign.isActive = false;
        require(
            token.transfer(
                campaign.organizationBeneficiary,
                campaign.totalRaised
            ),
            "Token transfer failed."
        );

        emit FundsTransferred(
            _campaignId,
            campaign.beneficiary,
            campaign.totalRaised
        );
    }

    // Function to retrieve all campaigns
    function getAllCampaigns() public view returns (Campaign[] memory) {
        return campaignList;
    }

    // Function to retrieve contributions for a campaign
    function getCampaignContributions(uint256 _campaignId)
    public
    view
    campaignExists(_campaignId)
    returns (Contribution[] memory)
    {
        uint256 contributorCount = campaignContributors[_campaignId].length;

        // Create an array to store all contributions for the campaign
        Contribution[] memory contributions = new Contribution[](
            contributorCount
        );

        // Populate the array
        for (uint256 i = 0; i < contributorCount; i++) {
            address contributor = campaignContributors[_campaignId][i];
            uint256 amount = campaignContributions[_campaignId][contributor];
            contributions[i] = Contribution(contributor, amount);
        }

        return contributions;
    }

    // Function to get the total number of campaigns
    function getTotalCampaigns() public view returns (uint256) {
        return campaignList.length;
    }
}
