pragma solidity ^0.4.6;

/// @title Iterable Mapping Example
/// @author Adam Lemmon - <adamjlemmon@gmail.com>
contract IterMapping {

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
}
