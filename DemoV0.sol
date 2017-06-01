pragma solidity ^0.4.6;

/// @title Demo Version 0 - To be Upgraded
/// @author Adam Lemmon - <adamjlemmon@gmail.com>
contract DemoV0 {
	/*
	* Storage
	*/
	address private owner;

	// Iterable Mapping
	// Map key => index of its value
	mapping(uint=>uint) public keyToIndexMap;
	string[] public values;
	uint[] public keys;

	mapping (address => uint) public userBalances;

	/*
	* Modifiers
	*/
	modifier onlyOwner {
		if(msg.sender != owner) throw;
		_;
	}

	/*
	* Events
	*/
	event PublishAllKeyValuePairs(uint key, string value);

	/// @dev Contract constructor
	function DemoV0() {
		owner = msg.sender;
	}

	/*
	* External
	*/
	/// @dev Deposit from external address
	function deposit()
		external
		payable
	{
	    userBalances[msg.sender] += msg.value;
	}

	/// @dev Secure withdraw from external address
	function withdrawBalance() external {
	    uint amount = userBalances[msg.sender];

		// Zero the balance before sending
		userBalances[msg.sender] = 0;

		if (!msg.sender.send(amount)) { throw; }
	}

	/*
	* Public
	*/
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
}
