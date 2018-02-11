pragma solidity ^ 0.4.18;

import "./StandardToken.sol";
import "../Ownership/Ownable.sol";

contract MintableToken is StandardToken, Ownable {

    /* Events */
    event Mint(address indexed _to, uint256 _value);

    /* Public Functions */

    function mint(address _to, uint256 _value) public onlyOwner returns(bool success) {
        balances[_to] += _value;
        totalSupply += _value;

        Mint(_to, _value);
        return true;
    }

}
