pragma solidity ^0.8.0;

import "./VegaVoteToken.sol";
import "./VotingNFT.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    VegaVoteToken public token;
    VotingNFT public votingNFT;
    uint public countVote;

    struct VoteData {
        uint id;
        string description;
        uint deadline;
        uint threshold;
        uint corrVotes;
        uint negVotes;
        bool finalized;
    }
    mapping(uint => VoteData) public votes;
    mapping(uint => mapping(address => bool)) public hasVoted;

    constructor(VegaVoteToken _token, VotingNFT _votingNFT) Ownable(msg.sender) {
        token = _token;
        votingNFT = _votingNFT;
    }

    function createVote(string calldata description, uint duration, uint threshold) external onlyOwner {
        votes[countVote] = VoteData({
            id: countVote,
            description: description,
            deadline: block.timestamp + duration,
            threshold: threshold,
            corrVotes: 0,
            negVotes: 0,
            finalized: false
        });
        countVote++;
    }

    function castVote(uint voteId, bool support, uint stakeAmount, uint stakePeriod) external {
        VoteData storage voteData = votes[voteId];
        require(block.timestamp < voteData.deadline, "End voting");
        require(!hasVoted[voteId][msg.sender], "Voted");
        require(stakePeriod <= 4, "Max is 4");
        require(token.transferFrom(msg.sender, address(this), stakeAmount), "Failed");

        uint votingPower = stakeAmount * (stakePeriod * stakePeriod);
        if (support) {
            voteData.corrVotes += votingPower;
        } else {
            voteData.negVotes += votingPower;
        }
        hasVoted[voteId][msg.sender] = true;
    }

    function finalizeVote(uint voteId) external {
        VoteData storage voteData = votes[voteId];
        require(!voteData.finalized, "Finalized");
        require(
            block.timestamp >= voteData.deadline ||
            (voteData.corrVotes + voteData.negVotes) >= voteData.threshold,
            "Is not end"
        );

        voteData.finalized = true;
        votingNFT.mintResult(owner(), voteId, voteData.corrVotes, voteData.negVotes);
    }
}