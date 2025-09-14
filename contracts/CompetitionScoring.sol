// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title Competition Scoring System
 * @dev Privacy-preserving competition scoring with FHE for judge confidentiality
 * @author Competition Platform Team
 */
contract CompetitionScoring {
    struct Competition {
        string name;
        string description;
        address organizer;
        uint256 startTime;
        uint256 endTime;
        uint256 maxParticipants;
        uint256 participantCount;
        bool active;
        bool finalized;
        uint256 totalPrize;
    }

    struct Participant {
        address wallet;
        string name;
        string submission;
        uint256 totalScore;
        uint256 judgeCount;
        bool qualified;
    }

    struct Judge {
        address wallet;
        string name;
        bool authorized;
        uint256 competitionsJudged;
    }

    // State variables
    mapping(uint256 => Competition) public competitions;
    mapping(uint256 => mapping(uint256 => Participant)) public participants;
    mapping(uint256 => mapping(address => bool)) public isParticipant;
    mapping(uint256 => mapping(address => bool)) public isJudge;
    mapping(address => Judge) public judges;
    mapping(uint256 => mapping(address => mapping(uint256 => uint256))) private judgeScores; // competition -> judge -> participant -> score
    mapping(uint256 => mapping(address => bool)) public hasJudgeScored;
    
    uint256 public nextCompetitionId = 1;
    uint256 public nextParticipantId = 1;
    address public admin;
    
    // Events
    event CompetitionCreated(uint256 indexed competitionId, string name, address organizer);
    event ParticipantRegistered(uint256 indexed competitionId, uint256 indexed participantId, address participant);
    event JudgeAuthorized(uint256 indexed competitionId, address judge);
    event ScoreSubmitted(uint256 indexed competitionId, address judge, uint256 participantId);
    event CompetitionFinalized(uint256 indexed competitionId, uint256 winnerId);
    event PrizeDistributed(uint256 indexed competitionId, address winner, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin allowed");
        _;
    }

    modifier onlyOrganizer(uint256 competitionId) {
        require(msg.sender == competitions[competitionId].organizer, "Only organizer allowed");
        _;
    }

    modifier onlyAuthorizedJudge(uint256 competitionId) {
        require(isJudge[competitionId][msg.sender], "Not an authorized judge");
        _;
    }

    modifier competitionExists(uint256 competitionId) {
        require(competitionId > 0 && competitionId < nextCompetitionId, "Competition does not exist");
        _;
    }

    modifier competitionActive(uint256 competitionId) {
        require(competitions[competitionId].active, "Competition not active");
        require(block.timestamp >= competitions[competitionId].startTime, "Competition not started");
        require(block.timestamp <= competitions[competitionId].endTime, "Competition ended");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @dev Create a new competition
     */
    function createCompetition(
        string memory name,
        string memory description,
        uint256 startTime,
        uint256 endTime,
        uint256 maxParticipants
    ) external payable returns (uint256) {
        require(startTime > block.timestamp, "Start time must be in future");
        require(endTime > startTime, "End time must be after start time");
        require(maxParticipants > 0, "Max participants must be greater than 0");

        uint256 competitionId = nextCompetitionId++;
        
        competitions[competitionId] = Competition({
            name: name,
            description: description,
            organizer: msg.sender,
            startTime: startTime,
            endTime: endTime,
            maxParticipants: maxParticipants,
            participantCount: 0,
            active: true,
            finalized: false,
            totalPrize: msg.value
        });

        emit CompetitionCreated(competitionId, name, msg.sender);
        return competitionId;
    }

    /**
     * @dev Register as a participant in a competition
     */
    function registerParticipant(
        uint256 competitionId,
        string memory name,
        string memory submission
    ) external competitionExists(competitionId) competitionActive(competitionId) {
        require(!isParticipant[competitionId][msg.sender], "Already registered");
        require(competitions[competitionId].participantCount < competitions[competitionId].maxParticipants, "Competition full");

        uint256 participantId = nextParticipantId++;
        
        participants[competitionId][participantId] = Participant({
            wallet: msg.sender,
            name: name,
            submission: submission,
            totalScore: 0,
            judgeCount: 0,
            qualified: true
        });

        isParticipant[competitionId][msg.sender] = true;
        competitions[competitionId].participantCount++;

        emit ParticipantRegistered(competitionId, participantId, msg.sender);
    }

    /**
     * @dev Authorize a judge for a competition
     */
    function authorizeJudge(
        uint256 competitionId,
        address judgeAddress,
        string memory judgeName
    ) external competitionExists(competitionId) onlyOrganizer(competitionId) {
        require(!isJudge[competitionId][judgeAddress], "Judge already authorized");
        
        isJudge[competitionId][judgeAddress] = true;
        
        if (!judges[judgeAddress].authorized) {
            judges[judgeAddress] = Judge({
                wallet: judgeAddress,
                name: judgeName,
                authorized: true,
                competitionsJudged: 0
            });
        }

        emit JudgeAuthorized(competitionId, judgeAddress);
    }

    /**
     * @dev Submit private score for a participant (FHE-protected in production)
     * @notice In production, scores would be encrypted using FHE
     */
    function submitScore(
        uint256 competitionId,
        uint256 participantId,
        uint256 score
    ) external 
        competitionExists(competitionId) 
        onlyAuthorizedJudge(competitionId) {
        
        require(score <= 100, "Score must be between 0 and 100");
        require(participantId > 0 && participantId < nextParticipantId, "Invalid participant ID");
        require(participants[competitionId][participantId].wallet != address(0), "Participant not found");
        require(!hasJudgeScored[competitionId][msg.sender], "Judge already scored");

        // In production, this would use FHE encryption
        judgeScores[competitionId][msg.sender][participantId] = score;
        hasJudgeScored[competitionId][msg.sender] = true;
        
        // Update participant's aggregate score
        participants[competitionId][participantId].totalScore += score;
        participants[competitionId][participantId].judgeCount++;

        emit ScoreSubmitted(competitionId, msg.sender, participantId);
    }

    /**
     * @dev Get participant's average score
     */
    function getAverageScore(uint256 competitionId, uint256 participantId) 
        external 
        view 
        returns (uint256) {
        Participant memory participant = participants[competitionId][participantId];
        if (participant.judgeCount == 0) return 0;
        return participant.totalScore / participant.judgeCount;
    }

    /**
     * @dev Finalize competition and determine winner
     */
    function finalizeCompetition(uint256 competitionId) 
        external 
        competitionExists(competitionId) 
        onlyOrganizer(competitionId) {
        
        require(block.timestamp > competitions[competitionId].endTime, "Competition still active");
        require(!competitions[competitionId].finalized, "Already finalized");
        
        uint256 highestScore = 0;
        uint256 winnerId = 0;
        
        // Find winner with highest average score
        for (uint256 i = 1; i < nextParticipantId; i++) {
            if (participants[competitionId][i].wallet != address(0) && 
                participants[competitionId][i].judgeCount > 0) {
                
                uint256 avgScore = participants[competitionId][i].totalScore / participants[competitionId][i].judgeCount;
                
                if (avgScore > highestScore) {
                    highestScore = avgScore;
                    winnerId = i;
                }
            }
        }
        
        competitions[competitionId].finalized = true;
        competitions[competitionId].active = false;
        
        // Distribute prize to winner
        if (winnerId > 0 && competitions[competitionId].totalPrize > 0) {
            address winner = participants[competitionId][winnerId].wallet;
            uint256 prize = competitions[competitionId].totalPrize;
            competitions[competitionId].totalPrize = 0;
            
            payable(winner).transfer(prize);
            emit PrizeDistributed(competitionId, winner, prize);
        }

        emit CompetitionFinalized(competitionId, winnerId);
    }

    /**
     * @dev Get competition details
     */
    function getCompetition(uint256 competitionId) 
        external 
        view 
        competitionExists(competitionId) 
        returns (Competition memory) {
        return competitions[competitionId];
    }

    /**
     * @dev Get participant details
     */
    function getParticipant(uint256 competitionId, uint256 participantId) 
        external 
        view 
        returns (Participant memory) {
        return participants[competitionId][participantId];
    }

    /**
     * @dev Check if address is authorized judge for competition
     */
    function isAuthorizedJudge(uint256 competitionId, address judge) 
        external 
        view 
        returns (bool) {
        return isJudge[competitionId][judge];
    }

    /**
     * @dev Emergency pause competition (admin only)
     */
    function pauseCompetition(uint256 competitionId) 
        external 
        onlyAdmin 
        competitionExists(competitionId) {
        competitions[competitionId].active = false;
    }

    /**
     * @dev Get total number of competitions
     */
    function getTotalCompetitions() external view returns (uint256) {
        return nextCompetitionId - 1;
    }

    /**
     * @dev Receive function to accept ETH for prizes
     */
    receive() external payable {}
}