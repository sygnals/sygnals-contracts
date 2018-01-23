pragma solidity ^0.4.18;

import "./library/IterableMap.sol";

/// @title SubscriptionContract - Allows traders(receivers) to subscribe to technical analysts(callers) calls
/// @author Norf Lipsum - <norf@sygplatform.io>
contract SubscriptionContract {

  using IterableMap for IterableMap.AddressUInt;

  /*
   *  Events
   */
  event Subscription(address indexed caller, address indexed receiver, uint indexed calls);

  /*
   *  Storage
   */
  mapping(address => IterableMap.AddressUInt) private subscriptionTable;

  /*
   *  Modifiers
   */
  modifier subscribed(address caller, address receiver) {
      require(hasSubscribed(caller, receiver));
      _;
  }

  /*
   * Public functions
   */

   /// @dev Allows receiver subscription to a specified caller for a number of calls.
   /// @param caller Address of the caller
   /// @param receiver Address of the receiver
   /// @param calls number of calls to subscribe
  function addSubscription(address caller, address receiver, uint calls) public {
    IterableMap.AddressUInt storage subscriptions = subscriptionTable[caller];
    subscriptions.insert(receiver, calls);
    Subscription(caller, receiver, calls);
  }

   /// @dev Allows to return the total number of subscribers of a specified caller.
   /// @param caller Address of the caller
   /// @return Returns the total number of subscribers
  function countSubscriptions(address caller) public view returns (uint) {
    IterableMap.AddressUInt storage subscriptions = subscriptionTable[caller];
    return subscriptions.size();
  }

   /// @dev Allows to check if a receiver has subscribed to a specified caller
   /// @param caller Address of the caller
   /// @param receiver Address of the receiver
   /// @return Returns whether the receiver has subscribed to caller
  function hasSubscribed(address caller, address receiver) public view returns(bool) {
    IterableMap.AddressUInt storage subscriptions = subscriptionTable[caller];
    return subscriptions.contains(receiver);
  }

   /// @dev Allows to return the metadata of a receiver's subscription for a specified caller.
   /// @param caller Address of the caller
   /// @param receiver Address of the receiver
   /// @return Returns address of the caller, address of the receiver and the total number of calls
  function getSubscription(address caller, address receiver) public subscribed(caller, receiver) view returns(address, address, uint) {
    IterableMap.AddressUInt storage subscriptions = subscriptionTable[caller];
    uint calls = subscriptions.get(receiver);
    return(caller, receiver, calls);
  }

   /// @dev Allows to return the metadata of a subscription for a specified caller at a given index.
   /// @param caller Address of the caller
   /// @param idx Index of the subscription
   /// @return Returns address of the caller, address of the receiver and the total number of calls
  function getSubscriptionByIndex(address caller, uint idx) public view returns(address, address, uint) {
    IterableMap.AddressUInt storage subscriptions = subscriptionTable[caller];
    address receiver = subscriptions.getKeyByIndex(idx);
    return getSubscription(caller, receiver);
  }
}
