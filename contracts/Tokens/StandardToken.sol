pragma solidity ^ 0.4.18;

import "./Token.sol";

contract StandardToken is Token {

    /* Storage */
    uint256 constant MAX_UINT256 = 2**256 - 1;
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    /* Public Functions */

    function balanceOf(address _owner) public constant returns(uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns(bool success) {
        return _transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
        require(allowed[_from][msg.sender] >= _value);

        if (allowed[_from][msg.sender] < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }

        return _transfer(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public returns(bool success) {
        allowed[msg.sender][_spender] = _value;

        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function _transfer(address _from, address _to, uint256 _value) internal returns(bool success) {
        require(_to != 0x0);
        require(balances[_from] >= _value);
        require(balances[_to] + _value >= balances[_to]);

        uint256 previousBalance = balances[_from] + balances[_to];

        balances[_from] -= _value;
        balances[_to] += _value;

        Transfer(_from, _to, _value);

        assert(balances[_from] + balances[_to] == previousBalance);
        return true;
    }
}
