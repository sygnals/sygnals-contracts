const SubscriptionContract = artifacts.require("../Subscription/SubscriptionContract.sol")

module.exports = function(deployer) {
  deployer.deploy(SubscriptionContract);
};
