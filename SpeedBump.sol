pragma solidity ^0.4.6;

/// @title Speed Bump Example
/// @author Adam Lemmon - <adamjlemmon@gmail.com>
contract SpeedBump {
	/**
	* Storage
	*/
	// Explicitly specify a wait duration for all Withdrawals
	// this is the 'speed bump'
	struct Withdrawal {
		uint amount;
		uint createdAt;
	}

	mapping (address => uint) private balances;
	mapping (address => Withdrawal) private withdrawals;
	// All withdrawals are held for 1 day
	uint constant wait = 30 seconds;

	/**
	* Public
	*/
	/// @dev Make a request to withdrawal your balance
	/// all withdrawals required to wait
	function requestWithdrawal() public {
		if (balances[msg.sender] > 0) {
			uint amount = balances[msg.sender];
			balances[msg.sender] = 0;

			// TODO consider lock to disable deposits while
			/// withdrawl in progress

			withdrawals[msg.sender] = Withdrawal({
				amount: amount,
				createdAt: now
			});
		}
	}

	/// @dev Attempt to execute the withdrawal if wait period has elapsed
	function executeWithdraw() public {
		if(withdrawals[msg.sender].amount > 0 && now > withdrawals[msg.sender].createdAt + wait) {
			uint amount = withdrawals[msg.sender].amount;
			withdrawals[msg.sender].amount = 0;

			if(!msg.sender.send(amount)) throw;
		}
	}
}
