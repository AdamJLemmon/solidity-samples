pragma solidity ^0.4.6;

/// @title Circuit Breaker Example
/// @author Adam Lemmon - <adamjlemmon@gmail.com>
contract CircuitBreaker {
	/**
	* Storage
	*/
	enum State { active, inactive }
	State public state = State.active;

	bool private stopped = false;
	address private owner;

	/**
	* Public
	*/
	/// @dev Toggle the circuit breaker to enable / disable functionality
	/// @param _state The state to transition to
	function setState(State _state) public {
		if(msg.sender != owner) throw;
		state = _state;
	}

	/// @dev Disable method if circuit breaker set
	modifier haltOnInactive {
		if (state != State.inactive) _;
	}

	/// @dev In case of circuit breaker continue to allow method to function
	modifier enableOnInactive {
		if (state == State.inactive) _;
	}

	/// @dev Disable any transfer in case on emergency
	function transfer() public haltOnInactive { }

	/// @dev Only allow user's to withdraw funds in case of emergency
	function withdraw() public enableOnInactive { }
}
