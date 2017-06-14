pragma solidity ^0.4.6;

// Examples

/// @title Example code segments
/// @author Adam Lemmon - <adamjlemmon@gmail.com>
contract DemoExamples {

	/*******************
    * Iterable Mapping *
    *******************/
	// Map a key to the index of its value
	mapping(uint=>uint) public keyToIndexMap;
	string[] public values;
	uint[] public keys;

	event PublishAllKeyValuePairs(uint key, string value);

	/// @dev Set a key's value by appending key and value to arrays
	/// and update mapping with new value's index
	function setKeyValue(uint key, string value) public {
		keyToIndexMap[key] = values.length;
		keys.push(key);
		values.push(value);
	}

	/// @dev Iterate over an entire mapping
	/// publishing each key / value pair
	function publishAllKeyValuePairs() public {
		for (var i = 0; i < keys.length; i++) {
			uint valueIndex = keyToIndexMap[keys[i]];
			string value = values[valueIndex];

			PublishAllKeyValuePairs(keys[i], value);
		}
	}

	/*************
	* Reentrancy *
	*************/
	mapping (address => uint) private userBalances;

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

	/******************
	* Circuit Breaker *
	******************/
	enum State { active, inactive }
	State public state = State.active;

	bool private stopped = false;
	address private owner;

	/// @dev Toggle the circuit breaker to enable / disable functionality
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

	/*************
	* Speed Bump *
	*************/
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


contract Test {
    string private demoString;

		function getStringExternal() external returns(string) {
			return demoString;
		}
}

contract Fail {
		Test test;

		function Fail() {
			test = new Test();
		}

    function getString() returns(string) {
				string str = test.getStringExternal();
		}
}



/*
Dynamic return EX
*/
/*contract Test {
    address[] forms;

    function addForm(address form){
        forms.push(form);
    }

    function getForms() public returns(address[]){
        return forms;
    }
}

contract Fail {

    function getForms() returns(uint) {
        Test t = new Test();
        t.addForm(address(0x1));
        var forms = t.getForms();

        return forms.length; // error: Member "length" not found or not visible after argument-dependent lookup in inaccessible dynamic type
    }
}*/



// Note returns(string[]) error: Internal type is not allowed for public or external functions.
