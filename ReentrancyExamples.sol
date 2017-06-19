pragma solidity ^0.4.6;

/// @title Reentrancy Examples
/// @author Adam Lemmon - <adamjlemmon@gmail.com>
contract ReentrancyExamples {
	/**
	* Storage
	*/
	mapping (address => uint) private userBalances;

	/**
	* Public
	*/
	/// @dev Insecure transfer from contrct to a recipient
	/// @param recipient The address to transfer the balance funds
	function refundBalanceInsecure(address recipient) public {
	    uint amount = userBalances[recipient];

		// Ether sent with ALL available gas
		if (!(recipient.call.value(amount)())) { throw; }

		// At this point, the recipient's code is executed, and can call refundBalance again

		userBalances[recipient] = 0;
	}

	/// @dev Secure withdraw from external address
	function withdrawBalanceSecure() public {
	    uint amount = userBalances[msg.sender];

		// Zero the balance before sending
		userBalances[msg.sender] = 0;

		// Ether sent with only stipend of 2,300 gas
		// currently only enough to log an event
		if (!msg.sender.send(amount)) { throw; }

		// At this point, the sender's contract has a balance of 0
		// Also message sent without enough gas to reenter
	}
}
