pragma solidity ^ 0.4.18;

import "./StandardToken.sol";

contract SygToken is StandardToken {

    /* Fallback Functions */

    function () public {
        revert();
    }

    /* Storage */
    string public name;
    string public symbol;
    uint8 public decimals = 18;

    function SygToken(
        uint256 _initialAmount,
        string _tokenName,
        uint8 _decimalUnits,
        string _tokenSymbol
    ) public {
        balances[msg.sender] = _initialAmount;
        totalSupply = _initialAmount;
        name = _tokenName;
        decimals = _decimalUnits;
        symbol = _tokenSymbol;
    }

}
