pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/VegaVoteToken.sol";
import "../src/VotingNFT.sol";
import "../src/Voting.sol";

contract VotingTest is Test {
    VegaVoteToken token;
    VotingNFT nft;
    Voting voting;
    address admin = address(0xABCD);
    address voter = address(0xABCF);

    function setUp() public {
        vm.startPrank(admin);
        token = new VegaVoteToken();
        nft = new VotingNFT();
        voting = new Voting(token, nft);
        vm.stopPrank();

        vm.startPrank(admin);
        token.mint(voter, 1000 * 10 ** token.decimals());
        vm.stopPrank();

        vm.deal(voter, 1 ether);
    }

    function testVoting() public {
        vm.startPrank(admin);
        voting.createVote("DESCR", 1 days, 100);
        vm.stopPrank();

        vm.startPrank(voter);
        token.approve(address(voting), 500 * 10 ** token.decimals());
        voting.castVote(0, true, 100 * 10 ** token.decimals(), 2);
        vm.stopPrank();

        vm.warp(block.timestamp + 1 days + 1);

        vm.startPrank(admin);
        voting.finalizeVote(0);
        vm.stopPrank();

        assertEq(nft.tokenCounter(), 1);
        assertEq(token.balanceOf(voter), 900 * 10 ** token.decimals());
    }
}