pragma solidity ^0.4.6;

// Proxy contract to enable contract upgrade and versioning
// Note this is a partial implementation and much is TODO

/// @title Ugradeable Contract Proxy
/// @author Adam Lemmon - <adamjlemmon@gmail.com>
contract UpgradeableProxy {
	address public latest;
	address public owner;
	bytes public data;

	function UpgradeableProxy(address initialVersion) {
		latest = initialVersion;
		owner = msg.sender;
	}

	/// @dev Update to a new version of the contract
	/// @param newVersion Address of the new contract
	function update(address newVersion) {
		if(msg.sender != owner) throw;
		latest = newVersion;
	}

	/// @dev All method requests hit this fallback and are routed
	/// to latest version of contract operating in the context of
	/// this proxy thus maintaining storage
	function () {
		if(!latest.delegatecall(msg.data)) throw;
	}
}
