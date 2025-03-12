pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract VotingNFT is ERC721 {
    uint256 public tokenCounter;

    struct VoteResult {
        uint voteId;
        uint corrVotes;
        uint negVotes;
    }
    mapping(uint256 => VoteResult) public results;

    constructor() ERC721("VotingResult", "VOTE") {
        tokenCounter = 0;
    }

    function mintResult(address to, uint voteId, uint corrVotes, uint negVotes) external returns (uint256) {
        uint256 tokenId = tokenCounter;
        _safeMint(to, tokenId);
        results[tokenId] = VoteResult(voteId, corrVotes, negVotes);
        tokenCounter++;
        return tokenId;
    }
}