pragma solidity ^0.4.18;

import "./IterableAddressSubscription.sol";

contract SubscriptionRegistry {

  using IterableAddressSubscription for IterableAddressSubscription.AddressSubscription;

  /* Events */
  event LogSubscription(address indexed requester, Subscription subscription, address subscriber, address analyst, uint8 calls);
  event LogUnsubscription(address indexed requester, Subscription subscription, address subscriber, address analyst, uint8 calls);

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

  function getSubscriberByIndex(uint idx) public view returns(address subscriber) {
    address analyst = msg.sender;
    IterableAddressSubscription.AddressSubscription storage subscriptions = subscriptionsMap[analyst];
    require(idx < subscriptions.size());

    subscriber = subscriptions.getKeyByIndex(idx);
  }

  function getSubscriptionByIndex(uint idx) public view returns(Subscription subscription) {
    address analyst = msg.sender;
    IterableAddressSubscription.AddressSubscription storage subscriptions = subscriptionsMap[analyst];
    require(idx < subscriptions.size());

    subscription = subscriptions.getValueByIndex(idx);
  }

  function getSubscriptionByAddress(address subscriber) public view returns(Subscription subscription) {
    //require(address(subscriber) != address(0));
    address analyst = msg.sender;
    IterableAddressSubscription.AddressSubscription storage subscriptions = subscriptionsMap[analyst];
    require(subscriptions.contains(subscriber));

    subscription = subscriptions.get(subscriber);
  }

  function getSubscriptionFromAddress(address analyst) public view returns(Subscription subscription) {
    //require(address(analyst) != address(0));
    address subscriber = msg.sender;
    IterableAddressSubscription.AddressSubscription storage subscriptions = subscriptionsMap[analyst];
    require(subscriptions.contains(subscriber));

    subscription = subscriptions.get(subscriber);
  }

  function unsubscribe(address analyst) public returns(bool unsubscribed) {
    require(analyst != msg.sender);
    //require(address(analyst) != address(0));

    IterableAddressSubscription.AddressSubscription storage subscriptions = subscriptionsMap[analyst];
    address subscriber = msg.sender;
    require(subscriptions.contains(subscriber));

    Subscription subscription = subscriptions.get(subscriber);
    unsubscribed = subscriptions.remove(subscriber);
    if(unsubscribed) {
      LogUnsubscription(subscriber, subscription, subscription.subscriber(), subscription.analyst(), subscription.calls());
    }
  }

}
