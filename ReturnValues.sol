pragma solidity ^0.4.6;

/// @title Return value pattern examples
/// @author Adam Lemmon - <adamjlemmon@gmail.com>
contract ReturnValues {
	/**
	* Storage
	*/
  enum State { inactive, active }

  struct MyStruct {
    bytes32 id;
    bytes32 structType;
    State state;
  }

  mapping(bytes32=>MyStruct) structIdToStructDetail;

	/**
	* Events
	*/
	event LogStructGet(
    bytes32 id,
    bytes32 structType,
    uint8 state,
    address sender
  );

  /**
  * External
  */
  /// @dev Get the values of a struct via TX
  /// @param id The id of the struct
  /// @return bytes32 id, bytes32 structType, uint8 state
  function structGet(bytes32 id)
    external
    returns(bytes32, bytes32, uint8)
  {
    MyStruct myStruct = structIdToStructDetail[id];
    LogStructGet(
      id,
      myStruct.structType,
      uint8(myStruct.state),
      msg.sender
    );
  }

  /// @dev Get the values of a struct via constant
  /// @param id The id of the struct
  /// @return bytes32 id, bytes32 structType, uint8 state
  function structGetCONSTANT(bytes32 id)
    external
    constant
    returns(bytes32 structId, bytes32 structType, uint8 state)
  {
    structId = id;
    structType = structIdToStructDetail[id].structType;
    state = uint8(structIdToStructDetail[id].state);
  }
}
