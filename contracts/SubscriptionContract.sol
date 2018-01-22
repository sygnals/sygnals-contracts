pragma solidity ^ 0.4 .4;

contract SubscriptionContract {

  struct Subscription {
    address analyst;
    address subscriber;
    uint calls;
  }

  mapping(address => Subscription[]) private subscriptions;

  function subscribe(address _analyst, address _subscriber, uint _calls) public {
    subscriptions[_analyst].push(Subscription(_analyst, _subscriber, _calls));
  }

  function countSubscriptions(address _analyst) public view returns(uint) {
    return subscriptions[_analyst].length;
  }

  function getSubscriptionAtIndex(address _analyst, uint index) public view returns(address analyst, address subscriber, uint calls) {
    Subscription memory s = subscriptions[_analyst][index];
    return (s.analyst, s.subscriber, s.calls);
  }

}