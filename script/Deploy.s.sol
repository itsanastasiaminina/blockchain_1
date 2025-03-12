pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/VegaVoteToken.sol";
import "../src/VotingNFT.sol";
import "../src/Voting.sol";

contract DeployScript is Script {
    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        VegaVoteToken token = VegaVoteToken(0xD3835FE9807DAecc7dEBC53795E7170844684CeF);

        VotingNFT nft = new VotingNFT();
        Voting voting = new Voting(token, nft);

        vm.stopBroadcast();
    }
}