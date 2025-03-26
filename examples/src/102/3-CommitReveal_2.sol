// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

uint256 constant MIN_WINDOW = 2*60; // 2 minutes
uint256 constant MAX_WINDOW = 3*24*60*60; // 3 days


/**
    @notice This contract allows users to answer riddles using a Commit-and-reveal scheme.
        However, the authorship of the answer is not verified, so it is possible to frontrun+replay the commit.
        This way, the attacker could win the riddle even if he doesn't know the answer.
    @custom:deployed-at INSERT ETHERSCAN URL
    @custom:exercise This contract is part of the examples at https://github.com/jcr-security/solidity-security-teaching-resources
 */
contract RiddlerContract is Ownable {

    /************************************** State vars and Structs *******************************************************/

    struct Riddle {
        string question;
        string answer;
        uint256 commitBefore;
    }


    // Windows in seconds
    uint256 commitWindow; 
    uint256 revealWindow;
    uint256 public riddleCount;
    mapping(uint256 riddleID => Riddle) public riddles;
    mapping(address commiter => mapping(uint256 riddleID => bytes32 committedHash)) public commits;
    mapping(address player => uint256 points) public points;
    

    /************************************** Events and modifiers *******************************************************/

    event AnswerCommited(address user);
    event AnswerRevealed(address user, string answer);
    event SolutionAnnounced(uint256 id, string question, string answer);

 
    modifier enforceWindowSize(uint256 commit) {
        require(
            commit >= MIN_WINDOW && commit <= MAX_WINDOW, 
            "Minimum windows size of 2 minutes, max of 3 days"
        );
        _;
    }


    modifier isCommitTime(uint256 id) { 
        require(block.timestamp <= riddles[id].commitBefore, "Not the time to Commit"); 
        _; 
    }


    modifier isRevealTime(uint256 id) { 
        require(keccak256(abi.encode(riddles[id].answer)) != keccak256(""),
            "Not the time to reveal!"); 
        _; 
    }
    

    /************************************** External *******************************************************/ 
    
    constructor(uint256 commit) enforceWindowSize(commit) Ownable(msg.sender) {      
        commitWindow = commit;
    }


    function modifyWindowSize(uint256 commit) 
        external 
        onlyOwner 
        enforceWindowSize(commit) 
    {
        commitWindow = commit;
    }


    // Create a new riddle
    function submitRiddle(string memory _question) 
        external
        onlyOwner 
        returns(uint256) 
    {
        uint256 newId = riddleCount;
        riddleCount++;

        riddles[newId] = Riddle (
            _question, 
            "",
            block.timestamp + commitWindow
        );

        return newId;
    }


    ///@notice Commit an answer for a specific riddle
    ///@dev  commitHash is of the format keccak256(abi.encodePacked(answer, seed));
    ///@custom:fix In order to fix the vulnerability, the message should be keccak256(abi.encodePacked(answer, msg.sender, seed));
    ///  so the ownership of the answer can be proven. This way, it is not possible to frontrun+replay the 
    ///  commit hash for the win, as the attacker address won't match. Including a seed is not ALWAYS needed, e.g. if 
    ///  the space of potential answer is big enough to render precomputation impractical.
    function commitAnswer(uint256 _riddleId, bytes32 commitHash)
        external 
        isCommitTime(_riddleId) 
    {
        require(_riddleId <= riddleCount, "Riddle not found");
        require(commits[msg.sender][_riddleId] == 0, "The user has already commited for this riddle");

        commits[msg.sender][_riddleId] = commitHash;

        emit AnswerCommited(msg.sender);
    }


    // Reveal the answer for a specific riddle
    function revealAnswer(uint256 _riddleId, string calldata _answer, string calldata _seed)
        external
        isRevealTime(_riddleId)
    {
        // Check that the user has a commit hash for the given riddle
        require(commits[msg.sender][_riddleId] != 0, "No commit hash found for this riddle");
        // Check that the answer matches the commit hash
        require(
            commits[msg.sender][_riddleId] == keccak256(abi.encodePacked(_answer, _seed)), 
            "Answer does not match commit hash"
        );

        // Update the user points
        if(keccak256(abi.encode(_answer)) == keccak256(abi.encode(riddles[_riddleId].answer))) {
            points[msg.sender] += 1;
        }

        // Set commit to 0 to avoid revealing more than one
        commits[msg.sender][_riddleId] = 0;

        emit AnswerRevealed(msg.sender, _answer);
    }


    // Announce the solution for a specific riddle
    function announceSolution(uint256 id, string calldata solution) 
        external   
        onlyOwner
        returns(uint, string memory, string memory) 
    {
        require(block.timestamp > riddles[id].commitBefore, 
            "Comitting has not finished yet!");
        require(keccak256(abi.encode(riddles[id].answer)) == keccak256(""),
            "Solution already announced!"); 

        riddles[id].answer = solution;

        emit SolutionAnnounced(id, riddles[id].question, solution);

        return (id,
            riddles[id].question, 
            riddles[id].answer);
    }
}
