struct Balance {
  address addr;
  uint256 value;
}

Balance balances[];

function refund() {
  while (i < balances.length) {
    balances[i].addr.send(balances[i].value);
    i++;
  }
  nextRefundIndex = i;
}


struct Balance {
  address addr;
  uint256 value;
}

Balance balances[];
uint256 nextRefundIndex;

function refund() {
  uint256 i = nextRefundIndex;
  while (i < balances.length && msg.gas > 200000) {
    balances[i].addr.send(balances[i].value);
    i++;
  }
  nextRefundIndex = i;
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
