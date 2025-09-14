// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CompetitionPlatform {
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
        uint256 joinedAt;
    }

    mapping(uint256 => Competition) public competitions;
    mapping(uint256 => Participant) public participants;
    mapping(address => mapping(uint256 => bool)) public hasJoined;
    
    uint256 public nextCompetitionId;
    uint256 public nextParticipantId;
    address public owner;
    
    event CompetitionJoined(uint256 indexed competitionId, address indexed participant, string name);
    event CompetitionCreated(uint256 indexed competitionId, string name);
    
    constructor() {
        owner = msg.sender;
        nextCompetitionId = 1;
        nextParticipantId = 1;
        
        // Pre-create 9 competitions for 2026
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
    
    function joinCompetition(
        uint256 competitionId, 
        string memory participantName, 
        string memory submission
    ) external payable {
        require(competitionId > 0 && competitionId < nextCompetitionId, "Invalid competition ID");
        require(competitions[competitionId].active, "Competition not active");
        require(bytes(participantName).length > 0, "Participant name required");
        require(msg.value >= 0.0001 ether, "Minimum 0.0001 ETH required");
        
        // Create participant record
        participants[nextParticipantId] = Participant({
            wallet: msg.sender,
            name: participantName,
            submission: submission,
            competitionId: competitionId,
            joinedAt: block.timestamp
        });
        
        // Update records - allow multiple joins from same address
        competitions[competitionId].participantCount++;
        competitions[competitionId].prizePool += msg.value;
        
        emit CompetitionJoined(competitionId, msg.sender, participantName);
        
        nextParticipantId++;
    }
    
    function createCompetition(string memory name) external payable returns (uint256) {
        require(bytes(name).length > 0, "Competition name required");
        
        uint256 competitionId = nextCompetitionId;
        competitions[competitionId] = Competition({
            name: name,
            participantCount: 0,
            prizePool: msg.value,
            active: true
        });
        
        emit CompetitionCreated(competitionId, name);
        
        nextCompetitionId++;
        return competitionId;
    }
    
    function getCompetition(uint256 competitionId) external view returns (
        string memory name,
        uint256 participantCount,
        uint256 prizePool,
        bool active
    ) {
        Competition memory comp = competitions[competitionId];
        return (comp.name, comp.participantCount, comp.prizePool, comp.active);
    }
    
    function getParticipant(uint256 participantId) external view returns (
        address wallet,
        string memory name,
        string memory submission,
        uint256 competitionId,
        uint256 joinedAt
    ) {
        Participant memory p = participants[participantId];
        return (p.wallet, p.name, p.submission, p.competitionId, p.joinedAt);
    }
    
    function hasParticipantJoined(address participant, uint256 competitionId) external view returns (bool) {
        return hasJoined[participant][competitionId];
    }
    
    function getTotalCompetitions() external view returns (uint256) {
        return nextCompetitionId - 1;
    }
    
    function getTotalParticipants() external view returns (uint256) {
        return nextParticipantId - 1;
    }
    
    function withdrawFunds() external {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }
    
    receive() external payable {}
}