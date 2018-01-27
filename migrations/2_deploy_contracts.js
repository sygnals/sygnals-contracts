let IterableAddressSubscription = artifacts.require("IterableAddressSubscription");
let SubscriptionRegistry = artifacts.require("SubscriptionRegistry");

module.exports = function(deployer) {

  deployer.deploy(IterableAddressSubscription);
  deployer.link(IterableAddressSubscription, [ SubscriptionRegistry ]);

  deployer.deploy(SubscriptionRegistry);

};
