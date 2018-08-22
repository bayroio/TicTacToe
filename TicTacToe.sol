/*
* Author: Edgar Herrador
* Date: August 22, 2018
* Version: 0.1
*/

pragma solidity ^0.4.24;

/// @title TicTacToe o Tres en Línea o Gato
contract TicTacToe {
    uint n;
    uint[9] public a;
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
    
    /*function newPlayer1(address _player1) public returns(bool){
        player1 = _player1;
        return true;
    }*/
    
    function startGame(address _player) payable public {
        require(msg.value >= 0.0000001 ether, "Dealer registration cost is 0.00000001 Ether");
        
        player = _player;
        
        n = 0;
        for(uint i = 0; i < a.length; i++)
            a[i] = 0;
            
        a[4] = 1;
        
        emit StatusGame("The game made its roll and it was in position 4");
    }
    
    function  roll(uint _position) payable public {
        require(_position >= 0 && _position <= 8, "Wrong position!");
        require(a[_position] == 0, "You can not roll in that position!");
        
        a[_position] = 2;
        
        rollSmartContract();
        
        if (playerWon()) {
            emit StatusGame("The player is the winner! The payout will be done Nearly Instant.");
            player.transfer(msg.value * 2);
        }
        
        emit StatusGame("The player your roll was made!");
    }
    
    function rollSmartContract() private {
        bool emptyBoxes = true;
        
        for(uint i = 0; i < a.length; i++) {
            if (a[i] == 0) {
                a[i] = 1;
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
    
    function playerWon() private view returns (bool) {
        for (uint i= 0; i < 5; i++) {
            if (i == 0 && a[0] == 2) {
                if (a[i+1] == 2 && a[i+2] == 2) return true;
                if (a[i+3] == 2 && a[i+6] == 2) return true;
                if (a[i+4] == 2 && a[i+8] == 2) return true;
            }
            
            if (i == 1 && a[i] == 2) {
                if (a[i+3] == 2 && a[i+6] == 2) return true;
            }
            
            if (i == 2 && a[i] == 2) {
                if (a[i+2] == 2 && a[i+4] == 2) return true;
                if (a[i+3] == 2 && a[i+6] == 2) return true;
            }
            
            if (i == 3 && a[i] == 2) {
                if (a[i+1] == 1 && a[i+2] == 2) return true;
            }
            
            if (i == 4 && a[i] == 2) {
                if (a[i-1] == 2 && a[i+1] == 2) return true;
                if (a[i-3] == 2 && a[i+3] == 2) return true;
            }
        }
        
        return false;
    }
    
    function smartContractWon() private view returns (bool) {
        for (uint i= 0; i < 5; i++) {
            if (i == 0 && a[0] == 1) {
                if (a[i+1] == 1 && a[i+2] == 1) return true;
                if (a[i+3] == 1 && a[i+6] == 1) return true;
                if (a[i+4] == 1 && a[i+8] == 1) return true;
            }
            
            if (i == 1 && a[i] == 1) {
                if (a[i+3] == 1 && a[i+6] == 1) return true;
            }
            
            if (i == 2 && a[i] == 1) {
                if (a[i+2] == 1 && a[i+4] == 1) return true;
                if (a[i+3] == 1 && a[i+6] == 1) return true;
            }
            
            if (i == 3 && a[i] == 1) {
                if (a[i+1] == 1 && a[i+2] == 1) return true;
            }
            
            if (i == 4 && a[i] == 1) {
                if (a[i-1] == 1 && a[i+1] == 1) return true;
                if (a[i-3] == 1 && a[i+3] == 1) return true;
            }
        }
        
        return false;
    }
}