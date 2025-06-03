// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

// creating a crowd funding app as a project (2/6/2025)  

contract CrowdTank {

    // nullclass internship --- task2 ( line 9 , 61 , 71 to 73 )
    uint TotalRaisedFunding;

    //data type for project details.
    struct project {
        address creator;
        string name;
        string description;
        uint fundingGoal;
        uint deadline;
        uint amountRaised;
        bool funded;
    }

    // projctID => project details
    mapping (uint => project) public Projects;

    // projectID => userAddress => contributions
    mapping (uint => mapping (address => uint)) public Contributions;

    // projectID => whether the id is used or not
    mapping (uint => bool) isIdUsed;

    // events 
    event ProjectCreated(uint indexed projectID , address indexed creator , string name , string description , uint fundingGoal , uint deadline);
    event funded(uint indexed projectID , address contributor , uint amount);
    event fundsWithdrawn(uint indexed projectID , address withdrawer , uint amount , string withdrawerType);

    // creating the 'project create' function
    function createProject(string memory _name , string memory _description , uint _fundingGoal , uint _durationSeconds , uint _id) external {
        require(!isIdUsed[_id], "Project ID is already in use!" );
        isIdUsed[_id] = true;
        Projects[_id] = project({
            creator : msg.sender,
            name: _name,
            description: _description,
            fundingGoal: _fundingGoal,
            deadline: block.timestamp+_durationSeconds,
            amountRaised: 0,
            funded: false
        });
        emit ProjectCreated(_id , msg.sender , _name , _description , _fundingGoal , block.timestamp+_durationSeconds);
    }

    // creating the 'fund the project' function
        function fundProject(uint _projectID) external payable {
         project storage Project = Projects[_projectID];
         require(block.timestamp<=Project.deadline , "Project deadline is over!");
         require(!Project.funded , "Project Reached its Funding requirement");
         require(msg.value>0 , "send some ether to contribute in the project");
         Project.amountRaised+=msg.value;
         Contributions[_projectID][msg.sender] = msg.value;
         // task 2 (line 61)
         TotalRaisedFunding+=msg.value;

         emit funded(_projectID, msg.sender, msg.value);

         if (Project.amountRaised>=Project.fundingGoal) {
            Project.funded = true;
         }
    }

    // task 2 ( line 71 to 73 )
    function Get_Total_Raised_Funding() view public returns(uint) {
        return TotalRaisedFunding;
    }

    // withdrawing fund = user
    function userWithdraw(uint _projectID) external payable {
        project storage Project = Projects[_projectID];
        require(Project.amountRaised<Project.fundingGoal , "Funding goal has reached , user can't withdraw");
        uint fundsContributed = Contributions[_projectID][msg.sender];
        payable(msg.sender).transfer(fundsContributed);
    }

    // withdrawing funds = project creator
    function creatorWithdraw(uint _projectID) external payable {
        project storage Project = Projects[_projectID];
        uint totalfunding = Project.amountRaised;
        require(Project.funded , "funding goal has not reached , admin can't withdraw");
        require(Project.creator == msg.sender , "only admin can withdraw");
        require(Project.deadline<=block.timestamp , "deadline has not reached , admin can't withdraw");
        payable(msg.sender).transfer(totalfunding);
    }

      //nullclass internship --- task 1  ( line 83 to 91 )
      function Time_Left(uint projectID) view public returns(uint) {
        project storage Project = Projects[projectID];
        if (block.timestamp >= Project.deadline) {
            return 0;
        } else {
            return(Project.deadline - block.timestamp);
        }

      }
    
}