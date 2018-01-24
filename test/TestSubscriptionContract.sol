pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Subscription/SubscriptionContract.sol";
import "./ThrowProxy.sol";

contract TestSubscriptionContract {

  SubscriptionContract subscriptionContract;
  address caller = 0x2191eF87E392377ec08E7c08Eb105Ef5448eCED5;
  address receiver1 = 0x0F4F2Ac550A1b4e2280d04c21cEa7EBD822934b5;
  address receiver2 = 0x6330A553Fc93768F612722BB8c2eC78aC90B3bbc;

  function beforeEach() public {
    subscriptionContract = new SubscriptionContract();
  }

  function testAddSubscription() public {
    uint actual;

    subscriptionContract.addSubscription(caller, receiver1, uint(5));
    subscriptionContract.addSubscription(caller, receiver2, uint(5));

    actual = subscriptionContract.countSubscriptions(caller);
    Assert.equal(actual, uint(2), "Subscription count should be uint(2)");
  }

  function testCountSubscriptions() public {
    uint actual;

    actual = subscriptionContract.countSubscriptions(caller);
    Assert.equal(actual, uint(0), "Subscription count should be zero");

    subscriptionContract.addSubscription(caller, receiver1, uint(5));
    subscriptionContract.addSubscription(caller, receiver2, uint(5));

    actual = subscriptionContract.countSubscriptions(caller);
    Assert.equal(actual, uint(2), "Subscription count should be uint(2)");
  }

  function testHasSubscribed() public {
    bool actual;

    actual = subscriptionContract.hasSubscribed(caller, receiver1);
    Assert.isFalse(actual, "Receiver1 should not have been subscribed");

    subscriptionContract.addSubscription(caller, receiver1, uint(5));

    actual = subscriptionContract.hasSubscribed(caller, receiver1);
    Assert.isTrue(actual, "Receiver1 should have been subscribed");

    actual = subscriptionContract.hasSubscribed(caller, receiver2);
    Assert.isFalse(actual, "Receiver2 should not have been subscribed");
  }

  function testGetSubscription() public {
    ThrowProxy throwProxy = new ThrowProxy(address(subscriptionContract));
    bool threw;

    SubscriptionContract(address(throwProxy)).getSubscription(caller, receiver1);
    threw = throwProxy.execute();
    Assert.isFalse(threw, "Should be false, as it should throw");

    subscriptionContract.addSubscription(caller, receiver1, uint(2));

    SubscriptionContract(address(throwProxy)).getSubscription(caller, receiver2);
    threw = throwProxy.execute();
    Assert.isFalse(threw, "Should be false, as it should throw");

    subscriptionContract.addSubscription(caller, receiver2, uint(6));

    var (callerR, receiverR, callsR) = subscriptionContract.getSubscription(caller, receiver2);
    Assert.equal(callerR, caller, "Subscription caller should be equal to caller");
    Assert.equal(receiverR, receiver2, "Subscription receiver should be equal to receiver2");
    Assert.equal(callsR, uint(6), "Subscription calls should be equal uint(6)");
  }

  function testGetSubscriptionByIndex() public {
    ThrowProxy throwProxy = new ThrowProxy(address(subscriptionContract));
    bool threw;

    SubscriptionContract(address(throwProxy)).getSubscriptionByIndex(caller, 0);
    threw = throwProxy.execute.gas(200000)();
    Assert.isFalse(threw, "Should be false, as it should throw");

    subscriptionContract.addSubscription(caller, receiver1, uint(2));

    SubscriptionContract(address(throwProxy)).getSubscriptionByIndex(caller, 1);
    threw = throwProxy.execute.gas(200000)();
    Assert.isFalse(threw, "Should be false, as it should throw");

    subscriptionContract.addSubscription(caller, receiver2, uint(6));

    var (callerR, receiverR, callsR) = subscriptionContract.getSubscriptionByIndex(caller, 1);
    Assert.equal(callerR, caller, "Subscription caller should be equal to caller");
    Assert.equal(receiverR, receiver2, "Subscription receiver should be equal to receiver2");
    Assert.equal(callsR, uint(6), "Subscription calls should be equal uint(6)");
  }

}
