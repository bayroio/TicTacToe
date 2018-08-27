/*
* Author: Edgar Herrador
* Date: August 26, 2018
* Version: 0.5
*/

pragma solidity ^0.4.24;

/// @title TicTacToe o Tres en Línea o Gato
contract TicTacToe {
    uint[9] public gameBoard;
    uint totalFunds;
    
    address owner;
    address player;

    event ThrowError (string message);
    event StatusGame (string message);
    
    modifier onlyOwner { 
        if (msg.sender == owner) 
            _; 
        else
            emit ThrowError ("You does not permissions to execute this service");
    }
    
    modifier onlyPlayer { 
        if (msg.sender == player)
            _;
        else
          emit ThrowError ("You does not permissions to execute this service");
    }
    
    constructor () payable public {
        owner = msg.sender;
    }
    
    function setFunds() payable public onlyOwner {
        require(msg.value >= 1 ether, "The minimal amount to fund the network is 1 Ether");
        totalFunds = msg.value;
    }
    
    /*
    This function allows to withdraw money and transfer it to the network owner.
    */
    function getFunds() onlyOwner public {
        owner.transfer(address(this).balance);
    }
    
    /*
    This function allows to withdraw money and transfer it to the network owner, and eliminate the contract
    */
    function destructNetwork() onlyOwner public {
        selfdestruct(owner);
    }
    
    /*
    Start a new game
    */
    function startGame(address _player) payable public {
        require(msg.value >= 0.0000001 ether, "Insert 0.00000001 Ether to start a new game");
        require(msg.value * 2 >= totalFunds, "Not enough totalFunds to start a new game");
        
        player = _player;
        
        for(uint i = 0; i < gameBoard.length; i++)
            gameBoard[i] = 0;
            
        gameBoard[4] = 1;
        
        emit StatusGame("The game made its roll and it was in position 4");
    }
    
    /*
    This function is called when a player play his turn
    */
    function  roll(uint _position) payable public {
        require(_position >= 0 && _position <= 8, "Wrong position!");
        require(gameBoard[_position] == 0, "You can not roll in that position!");
        
        // 0’s for empty square.
        // 1’s for player position on the game board. 2’s for smart contract position.
        gameBoard[_position] = 2;  
        
        rollSmartContract();
        
        if (playerWon()) {
            emit StatusGame("The player is the winner! The payout will be done Nearly Instant.");
            player.transfer(msg.value * 2);
        }
        
        emit StatusGame("The player your roll was made!");
    }
    
    /*
    Function to calculate the turn of smart contract
    */
    function rollSmartContract() private {
        bool emptyBoxes = true;
        
        for(uint i = 0; i < gameBoard.length; i++) {
            if (gameBoard[i] == 0) {
                gameBoard[i] = 1;
                emptyBoxes = true;
                break;
            }
            else
                emptyBoxes = false;
        }
        
        if (!emptyBoxes)
            emit StatusGame("There are no empty boxes so the smart contract can roll!");

        if (smartContractWon())
            emit StatusGame("The smart contract is the winner!");
    }
    
    /*
    Verifying if the player won
    */
    function playerWon() private view returns (bool) {
        for (uint i= 0; i < 5; i++) {
            if (i == 0 && gameBoard[0] == 2) {
                if (gameBoard[i+1] == 2 && gameBoard[i+2] == 2) return true;
                if (gameBoard[i+3] == 2 && gameBoard[i+6] == 2) return true;
                if (gameBoard[i+4] == 2 && gameBoard[i+8] == 2) return true;
            }
            
            if (i == 1 && gameBoard[i] == 2) {
                if (gameBoard[i+3] == 2 && gameBoard[i+6] == 2) return true;
            }
            
            if (i == 2 && gameBoard[i] == 2) {
                if (gameBoard[i+2] == 2 && gameBoard[i+4] == 2) return true;
                if (gameBoard[i+3] == 2 && gameBoard[i+6] == 2) return true;
            }
            
            if (i == 3 && gameBoard[i] == 2) {
                if (gameBoard[i+1] == 1 && gameBoard[i+2] == 2) return true;
            }
            
            if (i == 4 && gameBoard[i] == 2) {
                if (gameBoard[i-1] == 2 && gameBoard[i+1] == 2) return true;
                if (gameBoard[i-3] == 2 && gameBoard[i+3] == 2) return true;
            }
        }
        
        return false;
    }
    
    /*
    Verifying if the smart contract won
    */
    function smartContractWon() private view returns (bool) {
        for (uint i= 0; i < 5; i++) {
            if (i == 0 && gameBoard[0] == 1) {
                if (gameBoard[i+1] == 1 && gameBoard[i+2] == 1) return true;
                if (gameBoard[i+3] == 1 && gameBoard[i+6] == 1) return true;
                if (gameBoard[i+4] == 1 && gameBoard[i+8] == 1) return true;
            }
            
            if (i == 1 && gameBoard[i] == 1) {
                if (gameBoard[i+3] == 1 && gameBoard[i+6] == 1) return true;
            }
            
            if (i == 2 && gameBoard[i] == 1) {
                if (gameBoard[i+2] == 1 && gameBoard[i+4] == 1) return true;
                if (gameBoard[i+3] == 1 && gameBoard[i+6] == 1) return true;
            }
            
            if (i == 3 && gameBoard[i] == 1) {
                if (gameBoard[i+1] == 1 && gameBoard[i+2] == 1) return true;
            }
            
            if (i == 4 && gameBoard[i] == 1) {
                if (gameBoard[i-1] == 1 && gameBoard[i+1] == 1) return true;
                if (gameBoard[i-3] == 1 && gameBoard[i+3] == 1) return true;
            }
        }
        
        return false;
    }
}