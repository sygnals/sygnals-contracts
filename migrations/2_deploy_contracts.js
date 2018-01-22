const SubscriptionContract = artifacts.require("./SubscriptionContract.sol")

module.exports = function(deployer) {
  deployer.deploy(SubscriptionContract);
};