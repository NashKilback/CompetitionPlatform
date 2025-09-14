// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title Simple Competition Platform
 * @dev Simplified competition contract for easy Remix deployment
 */
contract SimpleCompetition {
    struct Competition {
        string name;
        uint256 participantCount;
        uint256 prizePool;
        bool active;
    }

    struct Participant {
        address wallet;
        string name;
        string submission;
        uint256 competitionId;
    }

    mapping(uint256 => Competition) public competitions;
    mapping(uint256 => Participant) public participants;
    mapping(address => mapping(uint256 => bool)) public hasJoined;
    
    uint256 public nextCompetitionId = 1;
    uint256 public nextParticipantId = 1;
    address public owner;
    
    event CompetitionJoined(uint256 indexed competitionId, address participant, string name);
    event CompetitionCreated(uint256 indexed competitionId, string name);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        
        // Pre-create competitions for testing
        competitions[1] = Competition("AI & Blockchain Integration", 23, 15 ether, true);
        competitions[2] = Competition("Web3 Gaming Revolution", 45, 25 ether, true);
        competitions[3] = Competition("DeFi Innovation Challenge", 67, 50 ether, true);
        competitions[4] = Competition("Zero-Knowledge Privacy Solutions", 12, 30 ether, true);
        competitions[5] = Competition("Sustainable Blockchain Solutions", 8, 20 ether, true);
        competitions[6] = Competition("Cross-Chain Interoperability", 0, 40 ether, true);
        competitions[7] = Competition("Metaverse Infrastructure", 5, 60 ether, true);
        competitions[8] = Competition("Quantum-Resistant Cryptography", 2, 80 ether, true);
        competitions[9] = Competition("Neural Network Consensus", 1, 100 ether, true);
        
        nextCompetitionId = 10;
    }
    
    function joinCompetition(uint256 competitionId, string memory participantName, string memory submission) 
        external 
        payable 
    {
        require(competitionId > 0 && competitionId < nextCompetitionId, "Invalid competition");
        require(competitions[competitionId].active, "Competition not active");
        require(!hasJoined[msg.sender][competitionId], "Already joined");
        require(bytes(participantName).length > 0, "Name required");
        require(msg.value >= 0.001 ether, "Minimum fee required");
        
        // Record participation
        participants[nextParticipantId] = Participant({
            wallet: msg.sender,
            name: participantName,
            submission: submission,
            competitionId: competitionId
        });
        
        hasJoined[msg.sender][competitionId] = true;
        competitions[competitionId].participantCount++;
        competitions[competitionId].prizePool += msg.value;
        
        emit CompetitionJoined(competitionId, msg.sender, participantName);
        nextParticipantId++;
    }
    
    function createCompetition(string memory name) external payable returns (uint256) {
        uint256 competitionId = nextCompetitionId++;
        competitions[competitionId] = Competition({
            name: name,
            participantCount: 0,
            prizePool: msg.value,
            active: true
        });
        
        emit CompetitionCreated(competitionId, name);
        return competitionId;
    }
    
    function getCompetition(uint256 competitionId) external view returns (Competition memory) {
        return competitions[competitionId];
    }
    
    function hasParticipantJoined(address participant, uint256 competitionId) external view returns (bool) {
        return hasJoined[participant][competitionId];
    }
    
    function getTotalCompetitions() external view returns (uint256) {
        return nextCompetitionId - 1;
    }
    
    function withdrawFunds() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
    
    receive() external payable {}
}