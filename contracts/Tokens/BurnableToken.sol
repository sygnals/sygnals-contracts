pragma solidity ^ 0.4.18;

import "./StandardToken.sol";

contract BurnableToken is StandardToken {

    /* Events */
    event Burn(address indexed _from, uint256 _value);

    /* Public Functions */

    function burn(uint256 _value) public returns(bool success) {
        return _burn(msg.sender, _value);
    }

    function burnFrom(address _from, uint256 _value) public returns(bool success) {
        require(allowed[_from][msg.sender] >= _value);

        if (allowed[_from][msg.sender] < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }

        return _burn(_from, _value);
    }

    function _burn(address _from, uint256 _value) internal returns(bool success) {
        require(balances[_from] >= _value);

        balances[_from] -= _value;
        totalSupply -= _value;

        Burn(msg.sender, _value);
        return true;
    }

}
