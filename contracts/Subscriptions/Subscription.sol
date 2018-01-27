pragma solidity ^0.4.18;

contract Subscription {

  /* Storage */
  address public subscriber;
  address public analyst;
  uint8 public calls;

  /* Public Functions */

  function Subscription(address _subscriber, address _analyst, uint8 _calls) public {
    subscriber = _subscriber;
    analyst = _analyst;
    calls = _calls;
  }

}
