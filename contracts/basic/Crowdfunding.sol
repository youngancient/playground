// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract CrowdFunding {
    address owner;
    uint8 constant platformFeePercentage = 2;
    uint8 constant miniPlatformFeePercentage = 1;
    uint256 counter;

    constructor() {
        owner = msg.sender;
    }

    // campaign struct
    // the title must be unique and hence is a key
    struct Campaign {
        string title;
        uint id;
        string description;
        address payable benefactor;
        uint noOfDonations;
        uint goal;
        uint deadline;
        uint amountRaised;
        uint timeCreated;
        bool isDeadlineReached;
    }

    Campaign[] allCampaigns;
    // campaign id -> campaign struct mapping
    mapping(string => Campaign) private usersCampaigns;
    // benefactor -> campaign id mapping, a user can have multiple campaigns
    mapping(address => string[]) private benefactorToCampaignIdMap;

    // events
    event CampaignCreated(
        address indexed owner,
        string indexed campaignName,
        uint256 amountRaised,
        uint256 indexed endTime
    );
    event DonationReceived(
        address indexed giver,
        string indexed campaignName,
        uint256 indexed amountSent
    );
    event CampaignEnded(
        address indexed owner,
        string indexed campaignName,
        uint256 amountRaised,
        uint256 indexed endTime
    );

    // modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized!");
        _;
    }

    // Useful modular functions

    // checks if campaign with _id exists
    function doesCampaignExist(string memory _id) public view returns (bool) {
        return bytes(usersCampaigns[_id].title).length > 0;
    }

    // checks if a user has created the same campaign and is active
    function doesUserCampaignExist(
        address _userAddress
    ) public view returns (bool) {
        return benefactorToCampaignIdMap[_userAddress].length > 0;
    }

    // checks if campaign deadline based on name has ended
    function hasCampaignDeadlineReached(
        string memory _campaignName
    ) public view returns (bool) {
        return usersCampaigns[_campaignName].deadline <= block.timestamp;
        // returns true if the deadline has reached
    }

    // get user campaigns
    // function getUserCampaigns() external view returns (Campaign[] memory userCampaigns_) {
    //     string[] memory userTotalCampaigns =  benefactorToCampaignIdMap[msg.sender];
    //     for (uint8 i; i < userTotalCampaigns.length; i++){
    //         userCampaigns_.push(usersCampaigns[userTotalCampaigns[i]]);
    //     }
    // }

    function getAllUsersCampaigns() external view returns (Campaign[] memory) {
        return allCampaigns;
    }

    // Core functions
    function createCampaign(
        string memory _title,
        string memory _description,
        address _benefactor,
        uint _goal,
        uint _deadline
    ) public {
        // require campaign exists
        require(
            !doesCampaignExist(_title),
            "A campaign exists with that already!"
        );
        // require that a user has not created such campaign
        require(
            !doesUserCampaignExist(_benefactor),
            "You have created this campaign already!"
        );
        // require that the goal is greater than 0
        require(_goal > 0, "Goal cannot be zero!");
        counter++; // increment the counter
        Campaign memory newCampaign = Campaign(
            _title,
            counter,
            _description,
            payable(_benefactor),
            0,
            _goal,
            _deadline + block.timestamp,
            0,
            block.timestamp,
            false
        );
        usersCampaigns[_title] = newCampaign;
        benefactorToCampaignIdMap[_benefactor].push(_title);
        allCampaigns.push(newCampaign);
        emit CampaignCreated(
            _benefactor,
            _title,
            _goal,
            _deadline + block.timestamp
        );
    }

    // depositing to contract
    function donateToCampaign(string memory _campaignName) public payable {
        // check campaign deadline
        endCampaign(_campaignName);
        // require(!checkCampaignDeadline(_campaignName), "Campaign has ended already!");
        require(msg.value > 0, "Cannot send zero Wei!");
        // if the campaign exists and has not ended
        Campaign storage campaign = usersCampaigns[_campaignName]; // gets campaign from storage
        campaign.amountRaised = campaign.amountRaised + msg.value;
        campaign.noOfDonations = campaign.noOfDonations + 1;
        emit DonationReceived(msg.sender, _campaignName, msg.value);
    }

    // ends campaign is the deadline is reached
    function endCampaign(string memory _campaignName) public {
        require(doesCampaignExist(_campaignName), "Campaign does not exist!");
        // access the campaign from storage
        Campaign storage campaign = usersCampaigns[_campaignName];
        // check if the campaign deadline has reached and the campaign deadline boolean isnt true
        if (
            !hasCampaignDeadlineReached(_campaignName) &&
            !campaign.isDeadlineReached
        ) {
            campaign.isDeadlineReached = true; // this prevents re-entracy
            uint amountToBePaid;
            uint feeCharge;
            // charge a small amount for usage
            if (amountToBePaid >= campaign.goal) {
                amountToBePaid =
                    ((100 - platformFeePercentage) * amountToBePaid) /
                    100;
            } else {
                amountToBePaid =
                    ((100 - miniPlatformFeePercentage) * amountToBePaid) /
                    100;
            }
            feeCharge = campaign.amountRaised - amountToBePaid;

            // we are using the check-effect-interaction form to update state before executing transactions
            // transfer if the amounts are not zeros
            if (amountToBePaid != 0 && feeCharge != 0) {
                (bool success, ) = campaign.benefactor.call{
                    value: amountToBePaid
                }("");
                require(success, "Campaign money Transfer Failed!");

                (bool feePaymentSuccess, ) = owner.call{value: feeCharge}("");
                require(feePaymentSuccess, "Fee Transfer Failed!");
            }
            emit CampaignEnded(
                campaign.benefactor,
                _campaignName,
                amountToBePaid,
                campaign.deadline
            );
        }
    }
}
