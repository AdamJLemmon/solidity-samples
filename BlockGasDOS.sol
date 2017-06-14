pragma solidity ^0.4.9;


/// @title
/// @author Adam Lemmon <adamjlemmon@gmail.com>
contract BlockGasDOS {
  /**
  * Storage
  */
  struct Balance {
    address addr;
    uint256 value;
  }

  Balance[] balances;
  uint256 nextRefundIndex; // FIX

  /**
  * External
  */
  function itertionRefund() external {
    uint8 i = 0;
    while (i < balances.length) {
      balances[i].addr.send(balances[i].value);
      i++;
    }
    nextRefundIndex = i;
  }

  function safeIterationRefund() external {
    uint256 i = nextRefundIndex;
    while (i < balances.length && msg.gas > 200000) {
      balances[i].addr.send(balances[i].value);
      i++;
    }
    nextRefundIndex = i;
  }

  function singleRefund(uint index) external {
    uint amount = balances[index].value;
    balances[index].value = 0;

    if (!balances[index].addr.send(amount)) {
      throw;
    }
  }

  function getRefundLength()
    external
    constant
    returns(uint)
  {
      return balances.length;
  }
}


 /*Real World Example: OpenZeppelin VestedToken*/

/**
 * @title Vested token
 * @dev Tokens that can be vested for a group of addresses.
 */
/*contract VestedToken {
  // FIX for block gas DOS
  uint256 MAX_GRANTS_PER_ADDRESS = 20;

  mapping (address => TokenGrant[]) public grants;

  function grantVestedTokens() public {
    // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
    if (tokenGrantsCount(_to) > MAX_GRANTS_PER_ADDRESS) throw;

    uint count = grants[_to].push(TokenGrant());

    transfer(_to, _value);
  }

  function transferableTokens(address holder, uint64 time) {
    uint256 grantIndex = tokenGrantsCount(holder);

    // Iterate through all the grants the holder has, and add all non-vested tokens
    uint256 nonVested = 0;
    for (uint256 i = 0; i < grantIndex; i++) {
      nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
    }

    // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
    uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
  }
}*/
