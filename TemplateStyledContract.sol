pragma solidity ^0.4.6;

// Template contract visualizing style guide and contract layout
// Note visibility => payable => write => constant
// Checks => Effects => Interactions pattern followed within each method

// import './<path to contract>.sol'

/// @title Styled Contract Layout Template
/// @author Adam Lemmon - <adamjlemmon@gmail.com>
contract TemplateContract {
	/**
	* Constants
	*/
	uint public constant CONSTANT = 0;

	/**
	* Storage
	*/
	uint public storageUint = 0;

	/**
	* Modifiers
	*/
	modifier templateModifier(uint param) {
		_;
	}

	/**
	* Events
	*/
	event LogTemplateEvent(uint param);

	/// @dev Contract constructor
	/// @param _storageUint ....description
	function TemplateContract(uint _storageUint) {
		storageUint = _storageUint;
	}

	/// @dev Contract fallback
	function () payable { }

	/**
	* External
	*/
	/// @dev Template example with several modifiers
	/// visibility modifiers preceed custom modifiers
	/// @param param ...description
	/// @return _param ...desc
	function templateModifiersFunction(uint param)
		external // visibility
		templateModifier(param) // Custom
		returns (uint _param)
	{
		_param = param;
	}

	/**
	* Public
	*/
	/// @dev Template example with several params and if statement
	/// @param param ...description
	/// @param param2 ...description
	/// @param param3 ...description
	/// @param param4 ...description
	function templateParamsandIfStatementFunction(
		uint param,
		uint param2,
		uint param3,
		uint param4
	)
		public
	{
		// If else styling
		if(param == param2) {
			_;
		} else if (param2 == param3) {
			_;
		} else {
			_;
		}
	}

	/**
	* Internal
	*/

	/**
	* Private
	*/
}
