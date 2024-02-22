// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

    contract Vault{
       
        address owner;
        uint256 unlockTime; // in seconds
        mapping(address => uint256) balance;
       
       event Deposit(address indexed _sender, uint256 indexed _amount);
       event Withdrawal(address indexed _sender, uint256 indexed _amount);

        constructor(uint256 _days){
            owner = msg.sender;
            unlockTime = block.timestamp + (_days * 8400) ;
        }

        // the deposit ether is a transfer to function
        function depositEther(uint256 _amount) external{
            require(_amount > 0, "");
            require( msg.sender == owner, "transaction aborted");
            balance[msg.sender] -= _amount;
            emit Deposit(msg.sender, _amount);            
        }

        // the withdraw function is time-based
        function withdrawEther(uint256 _amount) external{
            require(_amount > 0, "ou must enter an amount greater than 0");
            require(msg.sender == owner,"You are not the owner");
            require(block.timestamp > unlockTime, "You can't withdraw yet");

            payable (msg.sender).transfer(_amount);
            balance[msg.sender] += _amount;
            emit Withdrawal(msg.sender, _amount);
        }
    }