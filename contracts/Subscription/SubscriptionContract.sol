pragma solidity ^0.4.18;

import "./IterableAddressMap.sol";

/**
 * @title SubscriptionContract - Allows traders(receivers) to subscribe to technical analysts(callers) calls.\
 * @author Norf Lipsum - <norf@sygplatform.io>
 */
contract SubscriptionContract {

  using IterableAddressMap for IterableAddressMap.AddressUInt;

  //Events
  event Subscription(address indexed caller, address indexed receiver, uint indexed calls);

  //Storage
  mapping(address => IterableAddressMap.AddressUInt) private subscriptionTable;

  //Public Functions

  /**
   * @notice Allows `receiver` to subscribe to a `caller` for a number of `calls`.
   * @dev Current function replaces the number of calls if the receiver is already exists.
   * @dev Subscription fee calculations to be added when Syg Token is finished.
   * @param caller The address of the caller
   * @param receiver The address of the receiver
   * @param calls Number of subscription calls
   */
  function addSubscription(address caller, address receiver, uint calls) public {
    IterableAddressMap.AddressUInt storage subscriptions = subscriptionTable[caller];
    subscriptions.insert(receiver, calls);
    Subscription(caller, receiver, calls);
  }

   /**
    * @notice Allows to count and return the total number of subscribers of a `caller`.
    * @dev This function is useful for clients in particular to loops and iterations.
    * @param caller Address of the caller
    * @return Returns the total number of subscribers
    */
  function countSubscriptions(address caller) public view returns (uint) {
    IterableAddressMap.AddressUInt storage subscriptions = subscriptionTable[caller];
    return subscriptions.size();
  }

  /**
   * @notice Allows to check if a `receiver` has subscribed to a `caller`.
   * @param caller Address of the caller
   * @param receiver The address of the receiver
   * @return Returns whether the `receiver` has subscribed to `caller`
   */
  function hasSubscribed(address caller, address receiver) public view returns(bool) {
    IterableAddressMap.AddressUInt storage subscriptions = subscriptionTable[caller];
    return subscriptions.contains(receiver);
  }

   /**
   * @notice Allows to return the metadata of a `receiver`'s subscription to a `caller`.
   * @param caller Address of the caller
   * @param receiver The address of the receiver
   * @return Returns the address of the caller, address of the receiver and the subscription calls
   */
  function getSubscription(address caller, address receiver) public view returns(address, address, uint) {
    require(_callerExists(caller));
    IterableAddressMap.AddressUInt storage subscriptions = subscriptionTable[caller];

    require(subscriptions.contains(receiver));
    uint calls = subscriptions.get(receiver);

    return(caller, receiver, calls);
  }

  /**
   * @notice Allows to return the metadata of a `receiver`'s subscription to a `caller` at a given index `idx`.
   * @dev This function is useful for clients in particular to loops and iterations.
   * @param caller Address of the caller
   * @param idx Index of the subscription
   * @return Returns the address of the caller, address of the receiver and the subscription calls
   */
  function getSubscriptionByIndex(address caller, uint idx) public view returns(address, address, uint) {
    require(_callerExists(caller));
    IterableAddressMap.AddressUInt storage subscriptions = subscriptionTable[caller];

    require(idx < subscriptions.size());
    address receiver = subscriptions.getKeyByIndex(idx);
    uint calls = subscriptions.getValueByIndex(idx);

    return (caller, receiver, calls);
  }

   // Internal Functions
  function _callerExists(address caller) internal view returns(bool) {
    return subscriptionTable[caller].size() > 0;
  }
}
