pragma solidity ^ 0.4 .4;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SubscriptionContract.sol";

contract TestSubscriptionContract {

  SubscriptionContract subscriptionContract;

  function beforeEach() public {
    subscriptionContract = SubscriptionContract(DeployedAddresses.SubscriptionContract());
  }

  function testSubscribe() public {
    address analyst = 0x5AEDA56215b167893e80B4fE645BA6d5Bab767DE;
    address subscriber1 = 0x6330A553Fc93768F612722BB8c2eC78aC90B3bbc;
    address subscriber2 = 0x6330A553Fc93768F612722BB8c2eC78aC90B3bbc;
    uint calls = 5;

    subscriptionContract.subscribe(analyst, subscriber1, calls);
    subscriptionContract.subscribe(analyst, subscriber2, calls);

    uint actual = subscriptionContract.countSubscriptions(analyst);
    uint expeted = 2;
    Assert.equal(actual, expected, "Subscription count should be equal");

  }

}