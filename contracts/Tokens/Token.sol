pragma solidity ^ 0.4.18;

contract Token {

    /* Events */
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    /* Storage */
    uint256 public totalSupply;

    /* Public Functions */

    function balanceOf(address _owner) public constant returns(uint256 balance);

    function transfer(address _to, uint256 _value) public returns(bool success);

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);

    function approve(address _spender, uint256 _value) public returns(bool success);

    function allowance(address _owner, address _spender) public constant returns(uint256 remaining);

}
