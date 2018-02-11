let IterableAddressSubscription = artifacts.require("IterableAddressSubscription");
let SubscriptionRegistry = artifacts.require("SubscriptionRegistry");
let IterableHashSignal = artifacts.require("IterableHashSignal");
let SignalRegistry = artifacts.require("SignalRegistry");
let SygToken = artifacts.require('SygToken');

module.exports = function(deployer) {

  deployer.deploy(IterableAddressSubscription);
  deployer.link(IterableAddressSubscription, [ SubscriptionRegistry ]);

  deployer.deploy(IterableHashSignal);
  deployer.link(IterableHashSignal, [ SignalRegistry ]);

  deployer.deploy(SubscriptionRegistry);

  deployer.deploy(SygToken);

};
