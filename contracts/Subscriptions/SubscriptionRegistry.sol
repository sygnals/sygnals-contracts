pragma solidity ^0.4.18;

import "./IterableAddressSubscription.sol";

contract SubscriptionRegistry {

  using IterableAddressSubscription for IterableAddressSubscription.AddressSubscription;
  
  /* Events */
  event LogSubscription(address indexed requester, Subscription subscription, address subscriber, address analyst, uint8 calls);

  /* Storage */
  mapping(address => IterableAddressSubscription.AddressSubscription) private subscriptionsMap;

  /* Public Functions */

  function subscribe(address analyst, uint8 calls) public returns(Subscription subscription) {
    require(analyst != msg.sender);
    require(calls > 0);
    //require(address(analyst) != address(0));
    
    IterableAddressSubscription.AddressSubscription storage subscriptions = subscriptionsMap[analyst];
    address subscriber = msg.sender;

    subscription = new Subscription(subscriber, analyst, calls);
    subscriptions.insert(subscriber, subscription);

    LogSubscription(subscriber, subscription, subscriber, analyst, calls);
  }
  
  function countSubscriptions() public view returns(uint count) {
    address analyst = msg.sender;
    IterableAddressSubscription.AddressSubscription storage subscriptions = subscriptionsMap[analyst];
    
    count = subscriptions.size();
  }
  
  function getSubscriptionByIndex(uint idx) public view returns(Subscription subscription) {
    address analyst = msg.sender;
    IterableAddressSubscription.AddressSubscription storage subscriptions = subscriptionsMap[analyst];
    require(idx < subscriptions.size());
    
    subscription = subscriptions.getValueByIndex(idx);
  }

}