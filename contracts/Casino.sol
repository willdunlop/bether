//  All contracts must sart with the compiler version
pragma solidity ^0.4.11;

//
contract Casino {
  address owner;

  uint minimumBet;
  uint totalBet;
  uint numberOfBets;
  uint maxAmountOfBets = 100;
  address[] players;

  struct Player {
    uint amountBet;
    uint numberSelected;
  }

  mapping(address => Player) playerInfo;

  //  Fallback function in case someone sends ether to the contracts
  //  so it doesnt get lost
  function() public payable {}

  /**
  * function Casino
  * Acts as the constructor to the contract due to it having
  * a duplicate name.
  */
  function Casino(uint _minimumBet) public {
    owner = msg.sender;

    if(_minimumBet != 0) minimumBet = _minimumBet;
  }

  /**
  * function bet
  * The world 'payable' is a modifier that indicates that
  * a payment of ether is required to execute this function
  */
  function bet(uint number) payable public {
    //  assert requires it's params to be true.
    //  If they return false, the function stops there
    assert (checkPlayerExists(msg.sender) == false);
    assert (number >= 1 && number <= 10);
    assert (msg.value >= minimumBet);

    playerInfo[msg.sender].amountBet = msg.value;
    playerInfo[msg.sender].numberSelected = number;
    numberOfBets += 1;
    players.push(msg.sender);
    totalBet += msg.value;

    if(numberOfBets >= maxAmountOfBets) generateNumberWinner();
  }

  /**
  * function generateNumberWinner
  * Generates a number between 1 and 10
  */
  function generateNumberWinner() public {
    uint numberGenerated = block.number % 10 + 1;
    distributePrizes(numberGenerated);
  }

  /**
  * function distributePrizes
  * Checks the answers of each player and marks them as a winners
  * if they chose the correct answer. The total win amount is then
  * evenly distributed to all the winners
  */
  function distributePrizes(uint numberWinner) public {
    //  Creates a temporary in memory array with fixed numbers
    address[100] memory winners;
    uint count = 0;

    for(uint i=0; i < players.length; i++) {
      address playerAddress = players[i];
      if(playerInfo[playerAddress].numberSelected == numberWinner) {
        winners[count] = playerAddress;
        count++;
      }
      //  Delete all the players
      delete playerInfo[playerAddress];
    }

    players.length = 0;

    uint winnerEtherAmount = totalBet / winners.length;

    for(uint j = 0; j < count; j++) {
      //  Check the address is not empty
      if(winners[j] != address(0))
        winners[j].transfer(winnerEtherAmount);
    }
  }

  /**
  * function checkPlayerExists
  * Checks to see if the player has already played
  */
  function checkPlayerExists(address player) public view returns (bool) {
    for(uint i = 0; i < players.length; i++) {
      if(players[i] == player) return true;
    }
    return false;
  }

  /**
  * function kill
  * Used to destroy the contract. Only the owner is allowed
  * to do this.
  */
  function kill() public {
    if(msg.sender == owner)
      selfdestruct(owner);
  }
}
