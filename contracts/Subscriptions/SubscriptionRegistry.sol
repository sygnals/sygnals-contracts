pragma solidity ^0.4.18;

import "./IterableAddressSubscription.sol";

/**
 * @title SubscriptionRegistry - Allows traders to subscribe to technical analysts calls.
 * @dev Add analyst function to quit and issue refund to analyst's subscribers
 * @author Norf Lipsum - <norf@sygplatform.io>
 */
contract SubscriptionRegistry {

  using IterableAddressSubscription for IterableAddressSubscription.AddressSubscription;

  /* Events */
  event LogSubscription(address indexed requester, Subscription subscription, address subscriber, address analyst, uint8 calls);
  event LogUnsubscription(address indexed requester, Subscription subscription, address subscriber, address analyst, uint8 calls);

  /* Storage */
  mapping(address => IterableAddressSubscription.AddressSubscription) private subscriptionsMap;

  /* Public Functions */

  /**
   * @notice Allows the subscriber(msg.sender) to subscribe to `analyst` for a number of `calls`.
   * @dev Current function replaces the number of calls if the subscriber already exists.
   * @dev Subscription fee calculations to be added when Syg Token is finished.
   * @param analyst The address of the analyst
   * @param calls Number of subscription calls
   * @return Returns the Subscription `subscription`
   */
  function subscribe(address analyst, uint8 calls) public returns(Subscription subscription) {
    //require not self subscription
    require(analyst != msg.sender);
    //validate calls
    require(calls > 0);
    //require(address(analyst) != address(0));

    IterableAddressSubscription.AddressSubscription storage subscriptions = subscriptionsMap[analyst];
    address subscriber = msg.sender;

    subscription = new Subscription(subscriber, analyst, calls);
    subscriptions.insert(subscriber, subscription);

    LogSubscription(subscriber, subscription, subscriber, analyst, calls);
  }

 /**
  * @notice Allows to count the total number of subscriptions under analyst(msg.sender)
  * @dev This function is useful for clients in particular to loops and iterations.
  * @return Returns the total number of subscriptions
  */
  function countSubscriptions() public view returns(uint count) {
    address analyst = msg.sender;
    IterableAddressSubscription.AddressSubscription storage subscriptions = subscriptionsMap[analyst];

    count = subscriptions.size();
  }

  /**
   * @notice Allows to return the `subscriber` address under analyst(msg.sender) at a given index `idx`
   * @dev This function is useful for clients in particular to loops and iterations.
   * @param idx Index of the subscription
   * @return Returns the address of the `subscriber`
   */
  function getSubscriberByIndex(uint idx) public view returns(address subscriber) {
    address analyst = msg.sender;
    IterableAddressSubscription.AddressSubscription storage subscriptions = subscriptionsMap[analyst];

    //Require target index is bounded
    require(idx < subscriptions.size());

    subscriber = subscriptions.getKeyByIndex(idx);
  }

  /**
   * @notice Allows to return the `subscription` under analyst(msg.sender) at a given index `idx`.
   * @dev This function is useful for clients in particular to loops and iterations.
   * @param idx Index of the subscription
   * @return Returns the Subscription `subscription`
   */
  function getSubscriptionByIndex(uint idx) public view returns(Subscription subscription) {
    address analyst = msg.sender;
    IterableAddressSubscription.AddressSubscription storage subscriptions = subscriptionsMap[analyst];

    //Require target index is bounded
    require(idx < subscriptions.size());

    subscription = subscriptions.getValueByIndex(idx);
  }

  /**
   * @notice Allows to return the `subscription` of a `subscriber` under analyst(msg.sender)
   * @dev This function is useful for clients in particular to loops and iterations.
   * @param subscriber The address of the subscriber
   * @return Returns the Subscription `subscription`
   */
  function getSubscriptionByAddress(address subscriber) public view returns(Subscription subscription) {
    //require(address(subscriber) != address(0));
    address analyst = msg.sender;
    IterableAddressSubscription.AddressSubscription storage subscriptions = subscriptionsMap[analyst];

    //Require subscriber is currently subscribed to analyst
    require(subscriptions.contains(subscriber));

    subscription = subscriptions.get(subscriber);
  }

  /**
   * @notice Allows to return the `subscription` of a subscriber(msg.sender) under `analyst`
   * @dev This function is useful for clients in particular to loops and iterations.
   * @param analyst The address of the analyst
   * @return Returns the Subscription `subscription`
   */
  function getSubscriptionFromAddress(address analyst) public view returns(Subscription subscription) {
    //require(address(analyst) != address(0));
    address subscriber = msg.sender;
    IterableAddressSubscription.AddressSubscription storage subscriptions = subscriptionsMap[analyst];

    //Require subscriber is currently subscribed to analyst
    require(subscriptions.contains(subscriber));

    subscription = subscriptions.get(subscriber);
  }

  /**
   * @notice Allows the subscriber(msg.sender) to unsubscribe to `analyst`.
   * @dev Subscription fee calculations to be added when Syg Token is finished.
   * @dev Destroy subscription contract upon removal?
   * @param analyst The address of the analyst
   * @return Returns boolean result
   */
  function unsubscribe(address analyst) public returns(bool unsubscribed) {
    require(analyst != msg.sender);
    //require(address(analyst) != address(0));

    IterableAddressSubscription.AddressSubscription storage subscriptions = subscriptionsMap[analyst];
    address subscriber = msg.sender;

    //Require subscriber is currently subscribed to analyst
    require(subscriptions.contains(subscriber));

    Subscription subscription = subscriptions.get(subscriber);
    unsubscribed = subscriptions.remove(subscriber);
    if(unsubscribed) {
      LogUnsubscription(subscriber, subscription, subscription.subscriber(), subscription.analyst(), subscription.calls());
    }
  }

}
