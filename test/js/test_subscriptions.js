const utils = require('./utils')

const Subscription = artifacts.require('Subscription');
const SubscriptionRegistry = artifacts.require('SubscriptionRegistry');

contract('SubscriptionRegistry', function(accounts) {
  let subscriptionRegistry;

  let analyst = accounts[1];
  let subscriber1 = accounts[2];
  let subscriber2 = accounts[3];

  beforeEach(async() => {
    subscriptionRegistry = await SubscriptionRegistry.new();
  })

  it("should subscribe", async() => {
    transaction = await subscriptionRegistry.subscribe(analyst, 5, {
      from: subscriber1
    });

    var log = utils.getEventLogs(transaction, 'LogSubscription')[0];
    assert.equal(subscriber1, log.args.requester, subscriber1 + " should be the requester");
    assert.equal(subscriber1, log.args.subscriber, subscriber1 + " should also be the subscriber");
    assert.equal(analyst, log.args.analyst, analyst + " should be the analyst");
    assert.equal(5, log.args.calls, "calls should be 5");
  });

  it("should not subscribe: self subscription", async() => {
    try {
      await subscriptionRegistry.subscribe(analyst, 5, {
        from: analyst
      });
      throw new Error("Should revert!");
    } catch (e) {
      assert.equal(e.toString().split(":")[2].trim(), 'revert', "Error should be: revert");
    }
  });

  it("should not subscribe: invalid number of calls", async() => {
    try {
      await subscriptionRegistry.subscribe(analyst, 0, {
        from: subscriber1
      });
      throw new Error("Should revert!");
    } catch (e) {
      assert.equal(e.toString().split(":")[2].trim(), 'revert', "Error should be: revert");
    }
  });

  it("should count subscriptions", async() => {
    await subscriptionRegistry.subscribe(analyst, 5, {
      from: subscriber1
    });
    count = await subscriptionRegistry.countSubscriptions({
      from: analyst
    });
    assert.equal(1, count, "subscription count should be 1");
  });

  it("should count subscriptions: no analyst data", async() => {
    count = await subscriptionRegistry.countSubscriptions({
      from: analyst
    });
    assert.equal(0, count, "subscription count should be 0");
  });

  it("should get subscription by index", async() => {
    await subscriptionRegistry.subscribe(analyst, 5, {
      from: subscriber1
    });
    transaction = await subscriptionRegistry.subscribe(analyst, 3, {
      from: subscriber2
    });

    subscription = await subscriptionRegistry.getSubscriptionByIndex(1, {
      from: analyst
    });

    var log = utils.getEventLogs(transaction, 'LogSubscription')[0];
    assert.equal(subscription, log.args.subscription, subscription + " should be contract address");
  });

  it("should not get subscription: no analyst data", async() => {
    try {
      transaction = await subscriptionRegistry.getSubscriptionByIndex(1, {
        from: analyst
      });
      throw new Error("Should revert!");
    } catch (e) {
      assert.equal(e.toString().split(":")[2].trim(), 'revert', "Error should be: revert");
    }
  });

  it("should not get subscription: unknown by index", async() => {
    await subscriptionRegistry.subscribe(analyst, 5, {
      from: subscriber1
    });
    try {
      transaction = await subscriptionRegistry.getSubscriptionByIndex(1, {
        from: analyst
      });
      throw new Error("Should revert!");
    } catch (e) {
      assert.equal(e.toString().split(":")[2].trim(), 'revert', "Error should be: revert");
    }
  });

  it("should not get subscription: negative index ", async() => {
    await subscriptionRegistry.subscribe(analyst, 5, {
      from: subscriber1
    });
    try {
      transaction = await subscriptionRegistry.getSubscriptionByIndex(-1, {
        from: analyst
      });
      throw new Error("Should revert!");
    } catch (e) {
      assert.equal(e.toString().split(":")[2].trim(), 'revert', "Error should be: revert");
    }
  });
});
