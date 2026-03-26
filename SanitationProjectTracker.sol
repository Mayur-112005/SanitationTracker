// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Sanitation Project Tracker
/// @author Prajapati Mayur Suryanath (Roll No. 34)
/// @notice BE IT 2026 - BL&DLT Mini Project 36
/// @dev SDG 6: Clean Water and Sanitation

contract SanitationProjectTracker {

    // ─── Enums ──────────────────────────────────────────────────────────────

    enum Status { Proposed, Active, Completed, Cancelled }

    // ─── Structs ─────────────────────────────────────────────────────────────

    struct Project {
        uint    id;
        string  name;
        string  location;
        string  description;
        address creator;
        uint    fundingGoal;       // in wei
        uint    fundsRaised;       // in wei
        uint    progressPercent;   // 0 – 100
        string  progressNote;
        Status  status;
        uint    createdAt;
    }

    struct Funder {
        address funder;
        uint    amount;
        uint    timestamp;
    }

    // ─── State Variables ─────────────────────────────────────────────────────

    uint public projectCount;
    address public owner;

    mapping(uint => Project)       public projects;
    mapping(uint => Funder[])      public projectFunders;
    mapping(uint => mapping(address => uint)) public contributions;

    // ─── Events ──────────────────────────────────────────────────────────────

    event ProjectCreated(uint indexed projectId, string name, address creator, uint fundingGoal);
    event ProjectFunded(uint indexed projectId, address funder, uint amount, uint totalRaised);
    event ProgressUpdated(uint indexed projectId, uint progressPercent, string note, Status newStatus);
    event StatusChanged(uint indexed projectId, Status oldStatus, Status newStatus);

    // ─── Modifiers ───────────────────────────────────────────────────────────

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    modifier projectExists(uint projectId) {
        require(projectId > 0 && projectId <= projectCount, "Project does not exist");
        _;
    }

    modifier onlyCreator(uint projectId) {
        require(projects[projectId].creator == msg.sender, "Only project creator can call this");
        _;
    }

    // ─── Constructor ─────────────────────────────────────────────────────────

    constructor() {
        owner = msg.sender;
    }

    // ─── Core Functions ──────────────────────────────────────────────────────

    /**
     * @notice Create a new sanitation project
     * @param name        Project name
     * @param location    Geographic location of the project
     * @param description Brief description of the project
     * @param fundingGoal Target funding amount in wei
     */
    function createProject(
        string memory name,
        string memory location,
        string memory description,
        uint fundingGoal
    ) external returns (uint) {
        require(bytes(name).length > 0,        "Name cannot be empty");
        require(bytes(location).length > 0,    "Location cannot be empty");
        require(bytes(description).length > 0, "Description cannot be empty");
        require(fundingGoal > 0,               "Funding goal must be > 0");

        projectCount++;

        projects[projectCount] = Project({
            id:              projectCount,
            name:            name,
            location:        location,
            description:     description,
            creator:         msg.sender,
            fundingGoal:     fundingGoal,
            fundsRaised:     0,
            progressPercent: 0,
            progressNote:    "Project just created",
            status:          Status.Proposed,
            createdAt:       block.timestamp
        });

        emit ProjectCreated(projectCount, name, msg.sender, fundingGoal);
        return projectCount;
    }

    /**
     * @notice Fund a sanitation project
     * @param projectId The ID of the project to fund
     */
    function fundProject(uint projectId)
        external
        payable
        projectExists(projectId)
    {
        require(msg.value > 0, "Must send ETH to fund");
        Project storage p = projects[projectId];
        require(p.status == Status.Proposed || p.status == Status.Active,
                "Project is not accepting funds");

        p.fundsRaised += msg.value;
        contributions[projectId][msg.sender] += msg.value;

        projectFunders[projectId].push(Funder({
            funder:    msg.sender,
            amount:    msg.value,
            timestamp: block.timestamp
        }));

        // Auto-activate once any funding received
        if (p.status == Status.Proposed) {
            p.status = Status.Active;
        }

        emit ProjectFunded(projectId, msg.sender, msg.value, p.fundsRaised);
    }

    /**
     * @notice Update project progress (only project creator)
     * @param projectId       The ID of the project
     * @param progressPercent New progress value (0–100)
     * @param note            Description of the progress update
     */
    function updateProgress(
        uint projectId,
        uint progressPercent,
        string memory note
    )
        external
        projectExists(projectId)
        onlyCreator(projectId)
    {
        require(progressPercent <= 100,  "Progress cannot exceed 100%");
        require(bytes(note).length > 0,  "Note cannot be empty");

        Project storage p = projects[projectId];
        require(p.status != Status.Cancelled,   "Cannot update cancelled project");
        require(p.status != Status.Completed,   "Project already completed");

        p.progressPercent = progressPercent;
        p.progressNote    = note;

        // Auto-complete when progress reaches 100
        Status newStatus = p.status;
        if (progressPercent == 100) {
            p.status = Status.Completed;
            newStatus = Status.Completed;
        }

        emit ProgressUpdated(projectId, progressPercent, note, newStatus);
    }

    /**
     * @notice Get full status and details of a project
     * @param projectId The ID of the project
     */
    function getStatus(uint projectId)
        external
        view
        projectExists(projectId)
        returns (
            uint    id,
            string  memory name,
            string  memory location,
            string  memory description,
            address creator,
            uint    fundingGoal,
            uint    fundsRaised,
            uint    progressPercent,
            string  memory progressNote,
            string  memory status,
            uint    createdAt
        )
    {
        Project storage p = projects[projectId];

        string memory statusStr;
        if      (p.status == Status.Proposed)  statusStr = "Proposed";
        else if (p.status == Status.Active)    statusStr = "Active";
        else if (p.status == Status.Completed) statusStr = "Completed";
        else                                   statusStr = "Cancelled";

        return (
            p.id,
            p.name,
            p.location,
            p.description,
            p.creator,
            p.fundingGoal,
            p.fundsRaised,
            p.progressPercent,
            p.progressNote,
            statusStr,
            p.createdAt
        );
    }

    // ─── Additional Utility Functions ────────────────────────────────────────

    /**
     * @notice Get all funders for a project
     */
    function getProjectFunders(uint projectId)
        external
        view
        projectExists(projectId)
        returns (Funder[] memory)
    {
        return projectFunders[projectId];
    }

    /**
     * @notice Get all projects (basic info)
     */
    function getAllProjects()
        external
        view
        returns (
            uint[]    memory ids,
            string[]  memory names,
            string[]  memory locations,
            uint[]    memory fundsRaised,
            uint[]    memory fundingGoals,
            uint[]    memory progresses
        )
    {
        ids          = new uint[](projectCount);
        names        = new string[](projectCount);
        locations    = new string[](projectCount);
        fundsRaised  = new uint[](projectCount);
        fundingGoals = new uint[](projectCount);
        progresses   = new uint[](projectCount);

        for (uint i = 1; i <= projectCount; i++) {
            Project storage p = projects[i];
            ids[i-1]          = p.id;
            names[i-1]        = p.name;
            locations[i-1]    = p.location;
            fundsRaised[i-1]  = p.fundsRaised;
            fundingGoals[i-1] = p.fundingGoal;
            progresses[i-1]   = p.progressPercent;
        }
    }

    /**
     * @notice Cancel a project (only creator, only if Proposed)
     */
    function cancelProject(uint projectId)
        external
        projectExists(projectId)
        onlyCreator(projectId)
    {
        Project storage p = projects[projectId];
        require(p.status == Status.Proposed, "Can only cancel Proposed projects");
        Status old = p.status;
        p.status = Status.Cancelled;
        emit StatusChanged(projectId, old, Status.Cancelled);
    }

    /**
     * @notice Get my contribution to a project
     */
    function getMyContribution(uint projectId)
        external
        view
        projectExists(projectId)
        returns (uint)
    {
        return contributions[projectId][msg.sender];
    }
}
