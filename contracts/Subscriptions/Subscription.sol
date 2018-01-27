pragma solidity ^0.4.18;

contract Subscription {
    
  /* Storage */
  address private subscriber;
  address private analyst;
  uint8 private calls;
  
  /* Public Functions */

  function Subscription(address _subscriber, address _analyst, uint8 _calls) public {
    subscriber = _subscriber;
    analyst = _analyst;
    calls = _calls;
  }
  
}